from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.models import UserModel
from app.schemas import UserLogin, Token, UserResponse, ChangePassword
from app.auth import verify_password, get_password_hash, create_access_token, get_current_user_optional

router = APIRouter(prefix="/auth", tags=["Authentication"])

@router.post("/login")
def login(login_data: UserLogin, db: Session = Depends(get_db)):
    user = db.query(UserModel).filter(UserModel.username == login_data.username).first()
    
    if not user or not verify_password(login_data.password, user.password_hash):
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
            "mobile": user.mobile,
            "email": user.email,
            "company": user.company,
            "branch": user.branch,
            "city": user.city,
            "department": user.department,
            "designation": user.designation,
            "reporting_manager": user.reporting_manager,
            "profile_picture": user.profile_picture,
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
