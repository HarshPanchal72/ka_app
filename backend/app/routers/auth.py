from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy.sql import func
from app.database import get_db
from app.models import UserModel
from app.schemas import UserLogin, Token, UserResponse, ChangePassword
from app.auth import verify_password, get_password_hash, create_access_token, get_current_user_optional

router = APIRouter(prefix="/auth", tags=["Authentication"])

@router.post("/login")
def login(login_data: UserLogin, db: Session = Depends(get_db)):
    clean_username = login_data.username.strip()
    clean_password = login_data.password.strip()
    user = db.query(UserModel).filter(func.lower(UserModel.username) == func.lower(clean_username)).first()
    
    if not user or not verify_password(clean_password, user.password_hash):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid Badge ID or Password",
        )

    access_token = create_access_token(data={"sub": user.username, "role": user.role})
    
    return {
        "access_token": access_token,
        "token_type": "bearer",
        "role": user.role,
        "username": user.username,
        "user": {
            "id": user.id,
            "username": user.username,
            "role": user.role,
            "mobile": user.mobile or "",
            "email": user.email or "",
            "company": user.company or "",
            "branch": user.branch or "",
            "city": user.city or "",
            "department": user.department or "",
            "designation": user.designation or "",
            "reporting_manager": user.reporting_manager or "",
            "profile_picture": user.profile_picture or "",
        }
    }

@router.post("/change-password")
def change_password(
    data: ChangePassword,
    current_user: UserModel = Depends(get_current_user_optional),
    db: Session = Depends(get_db)
):
    if not current_user:
        raise HTTPException(status_code=401, detail="Authentication required")
    
    if not verify_password(data.old_password, current_user.password_hash):
        raise HTTPException(status_code=400, detail="Old password is incorrect")
    
    current_user.password_hash = get_password_hash(data.new_password)
    db.commit()
    return {"message": "Password changed successfully"}

@router.get("/me", response_model=UserResponse)
def get_me(current_user: UserModel = Depends(get_current_user_optional)):
    if not current_user:
        raise HTTPException(status_code=401, detail="Authentication required")
    return current_user
