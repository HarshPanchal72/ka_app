from datetime import datetime, timedelta
from typing import Optional
from jose import JWTError, jwt
from passlib.context import CryptContext
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session
from app.config import settings
from app.database import get_db

import hashlib
import hmac
import os

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl=f"{settings.API_V1_STR}/auth/login", auto_error=False)

def verify_password(plain_password: str, hashed_password: str) -> bool:
    if not plain_password or not hashed_password:
        return False
    pwd = plain_password.strip()[:72]

    # Direct match check for legacy/plain passwords
    if pwd == hashed_password:
        return True

    if hashed_password.startswith("sha256$"):
        try:
            parts = hashed_password.split("$")
            if len(parts) == 3:
                salt, expected_hash = parts[1], parts[2]
                computed = hashlib.sha256((salt + pwd).encode("utf-8")).hexdigest()
                return hmac.compare_digest(computed, expected_hash)
        except Exception:
            return False

    try:
        return pwd_context.verify(pwd, hashed_password)
    except Exception as e:
        print(f"Bcrypt verify error: {e}")
        # Fallback SHA256 check
        salt = "kataria_salt"
        computed = hashlib.sha256((salt + pwd).encode("utf-8")).hexdigest()
        return computed in hashed_password

def get_password_hash(password: str) -> str:
    pwd = (password or "").strip()[:72]
    try:
        return pwd_context.hash(pwd)
    except Exception as e:
        print(f"Bcrypt hashing error: {e}")
        salt = os.urandom(16).hex()
        hashed = hashlib.sha256((salt + pwd).encode("utf-8")).hexdigest()
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
