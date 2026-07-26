import os
import uuid
from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.models import UserModel
from app.schemas import UserRegister, UserResponse, UserUpdate
from app.auth import get_password_hash

router = APIRouter(prefix="/users", tags=["Users"])

UPLOAD_DIR = os.path.join(os.path.dirname(os.path.dirname(__file__)), "uploads")
os.makedirs(UPLOAD_DIR, exist_ok=True)

@router.post("", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def create_user(
    username: str = Form(...),
    password: str = Form(...),
    role: Optional[str] = Form("User"),
    mobile: Optional[str] = Form(None),
    email: Optional[str] = Form(None),
    company: Optional[str] = Form(None),
    branch: Optional[str] = Form(None),
    city: Optional[str] = Form(None),
    department: Optional[str] = Form(None),
    designation: Optional[str] = Form(None),
    reporting_manager: Optional[str] = Form(None),
    file: Optional[UploadFile] = File(None),
    db: Session = Depends(get_db)
):
    existing = db.query(UserModel).filter(UserModel.username == username).first()
    if existing:
        raise HTTPException(status_code=400, detail="Username already exists")

    profile_path = None
    if file:
        file_ext = os.path.splitext(file.filename)[1]
        filename = f"user_{uuid.uuid4().hex}{file_ext}"
        file_path = os.path.join(UPLOAD_DIR, filename)
        with open(file_path, "wb") as buffer:
            content = await file.read()
            buffer.write(content)
        profile_path = f"/static/uploads/{filename}"

    user = UserModel(
        username=username,
        password_hash=get_password_hash(password),
        role=role or "User",
        mobile=mobile,
        email=email,
        company=company,
        branch=branch,
        city=city,
        department=department,
        designation=designation,
        reporting_manager=reporting_manager,
        profile_picture=profile_path
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    return user

@router.post("/json", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
def create_user_json(user_data: UserRegister, db: Session = Depends(get_db)):
    existing = db.query(UserModel).filter(UserModel.username == user_data.username).first()
    if existing:
        raise HTTPException(status_code=400, detail="Username already exists")
    
    user = UserModel(
        username=user_data.username,
        password_hash=get_password_hash(user_data.password),
        role=user_data.role or "User",
        mobile=user_data.mobile,
        email=user_data.email,
        company=user_data.company,
        branch=user_data.branch,
        city=user_data.city,
        department=user_data.department,
        designation=user_data.designation,
        reporting_manager=user_data.reporting_manager
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    return user

@router.get("", response_model=List[UserResponse])
def list_users(db: Session = Depends(get_db)):
    return db.query(UserModel).all()

@router.get("/{user_id}", response_model=UserResponse)
def get_user(user_id: int, db: Session = Depends(get_db)):
    user = db.query(UserModel).filter(UserModel.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user
