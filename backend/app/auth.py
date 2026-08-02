from datetime import datetime, timedelta
from typing import Optional
from jose import JWTError, jwt
from passlib.context import CryptContext
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session
from app.config import settings
from app.database import get_db

import bcrypt
import hashlib
import hmac
import os

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl=f"{settings.API_V1_STR}/auth/login", auto_error=False)

def verify_password(plain_password: str, hashed_password: str) -> bool:
    if not plain_password or not hashed_password:
        return False
    pwd_str = plain_password.strip()[:72]
    pwd_bytes = pwd_str.encode("utf-8")
    hashed_str = hashed_password.strip()

    # 1. Plaintext match for sample/default accounts
    if pwd_str == hashed_str:
        return True

    # 2. SHA256 fallback format
    if hashed_str.startswith("sha256$"):
        try:
            parts = hashed_str.split("$")
            if len(parts) == 3:
                salt, expected_hash = parts[1], parts[2]
                computed = hashlib.sha256((salt + pwd_str).encode("utf-8")).hexdigest()
                return hmac.compare_digest(computed, expected_hash)
        except Exception:
            pass

    # 3. Direct bcrypt check (works reliably in Python 3.14 without passlib bug)
    if hashed_str.startswith("$2b$") or hashed_str.startswith("$2a$") or hashed_str.startswith("$2y$"):
        try:
            return bcrypt.checkpw(pwd_bytes, hashed_str.encode("utf-8"))
        except Exception as b_err:
            print(f"Direct bcrypt checkpw error: {b_err}")

    # 4. Passlib check fallback
    try:
        return pwd_context.verify(pwd_str, hashed_str)
    except Exception as p_err:
        print(f"Passlib verify error: {p_err}")

    return False

def get_password_hash(password: str) -> str:
    pwd_str = (password or "").strip()[:72]
    pwd_bytes = pwd_str.encode("utf-8")
    
    # 1. Try direct bcrypt first
    try:
        salt = bcrypt.gensalt()
        return bcrypt.hashpw(pwd_bytes, salt).decode("utf-8")
    except Exception as b_err:
        print(f"Direct bcrypt hashpw error: {b_err}")

    # 2. Try passlib
    try:
        return pwd_context.hash(pwd_str)
    except Exception as p_err:
        print(f"Passlib hash error: {p_err}")

    # 3. Fail-safe SHA256
    salt = os.urandom(16).hex()
    hashed = hashlib.sha256((salt + pwd_str).encode("utf-8")).hexdigest()
    return f"sha256${salt}${hashed}"


def create_access_token(data: dict, expires_delta: Optional[timedelta] = None) -> str:
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM)
    return encoded_jwt

def get_current_user_optional(
    token: Optional[str] = Depends(oauth2_scheme),
    db: Session = Depends(get_db)
):
    if not token:
        return None
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            return None
    except JWTError:
        return None
    
    from app.models import UserModel
    user = db.query(UserModel).filter(UserModel.username == username).first()
    return user
