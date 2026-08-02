import os
import uuid
from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form, status
from sqlalchemy.orm import Session
from sqlalchemy.sql import func
from app.database import get_db
from app.models import UserModel
from app.schemas import UserRegister, UserResponse, UserUpdate, ChangePassword
from app.auth import get_password_hash, verify_password, get_current_user_optional

router = APIRouter(prefix="/users", tags=["Users"])

UPLOAD_DIR = os.path.join(os.path.dirname(os.path.dirname(__file__)), "uploads")
os.makedirs(UPLOAD_DIR, exist_ok=True)

@router.post("", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def create_user(
    username: str = Form(...),
    password: str = Form(...),
    role: Optional[str] = Form("User"),
    badge_id: Optional[str] = Form(None),
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
    clean_username = username.strip()
    clean_badge = (badge_id or company or clean_username).strip()

    existing = db.query(UserModel).filter(
        (func.lower(UserModel.username) == func.lower(clean_username)) |
        (func.lower(UserModel.badge_id) == func.lower(clean_badge))
    ).first()
    if existing:
        raise HTTPException(status_code=400, detail="Username or Badge ID already exists")

    profile_path = None
    if file and file.filename:
        content = await file.read()
        if len(content) > 0:
            file_ext = os.path.splitext(file.filename)[1] or ".jpg"
            filename = f"user_{uuid.uuid4().hex}{file_ext}"
            file_path = os.path.join(UPLOAD_DIR, filename)
            with open(file_path, "wb") as buffer:
                buffer.write(content)
            profile_path = f"/static/uploads/{filename}"

    user = UserModel(
        username=clean_username,
        badge_id=clean_badge,
        password_hash=get_password_hash(password.strip()),
        role=role or "User",
        mobile=mobile,
        email=email,
        company=company or clean_badge,
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
    clean_username = user_data.username.strip()
    existing = db.query(UserModel).filter(func.lower(UserModel.username) == func.lower(clean_username)).first()
    if existing:
        raise HTTPException(status_code=400, detail="Username already exists")
    
    user = UserModel(
        username=clean_username,
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

@router.get("/by-username/{username}", response_model=UserResponse)
def get_user_by_username(username: str, db: Session = Depends(get_db)):
    clean_name = username.strip()
    user = None
    try:
        user = db.query(UserModel).filter(
            (func.lower(UserModel.username) == func.lower(clean_name)) |
            (func.lower(UserModel.badge_id) == func.lower(clean_name)) |
            (func.lower(UserModel.company) == func.lower(clean_name))
        ).first()
    except Exception as e:
        db.rollback()
        user = db.query(UserModel).filter(
            (func.lower(UserModel.username) == func.lower(clean_name)) |
            (func.lower(UserModel.company) == func.lower(clean_name))
        ).first()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@router.get("/{user_id}", response_model=UserResponse)
def get_user(user_id: int, db: Session = Depends(get_db)):
    user = db.query(UserModel).filter(UserModel.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

@router.post("/update", response_model=UserResponse)
async def update_user_profile(
    username: Optional[str] = Form(None),
    badge_id: Optional[str] = Form(None),
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
    target_name = (username or badge_id or "").strip()
    if not target_name:
        raise HTTPException(status_code=400, detail="Username or Badge ID is required for update")
    
    user = None
    try:
        user = db.query(UserModel).filter(
            (func.lower(UserModel.username) == func.lower(target_name)) |
            (func.lower(UserModel.badge_id) == func.lower(target_name)) |
            (func.lower(UserModel.company) == func.lower(target_name))
        ).first()
    except Exception:
        db.rollback()
        user = db.query(UserModel).filter(
            (func.lower(UserModel.username) == func.lower(target_name)) |
            (func.lower(UserModel.company) == func.lower(target_name))
        ).first()

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    if badge_id is not None: user.badge_id = badge_id
    if mobile is not None: user.mobile = mobile
    if email is not None: user.email = email
    if company is not None: user.company = company
    if branch is not None: user.branch = branch
    if city is not None: user.city = city
    if department is not None: user.department = department
    if designation is not None: user.designation = designation
    if reporting_manager is not None: user.reporting_manager = reporting_manager

    if file and file.filename:
        content = await file.read()
        if len(content) > 0:
            file_ext = os.path.splitext(file.filename)[1] or ".jpg"
            filename = f"user_{uuid.uuid4().hex}{file_ext}"
            file_path = os.path.join(UPLOAD_DIR, filename)
            with open(file_path, "wb") as buffer:
                buffer.write(content)
            user.profile_picture = f"/static/uploads/{filename}"

    db.commit()
    db.refresh(user)
    return user

@router.put("/by-username/{username}", response_model=UserResponse)
async def update_user_profile_by_username(
    username: str,
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
    return await update_user_profile(
        username=username,
        mobile=mobile,
        email=email,
        company=company,
        branch=branch,
        city=city,
        department=department,
        designation=designation,
        reporting_manager=reporting_manager,
        file=file,
        db=db
    )

@router.post("/change-password")
def change_user_password(
    data: ChangePassword,
    current_user: Optional[UserModel] = Depends(get_current_user_optional),
    db: Session = Depends(get_db)
):
    user = None
    if data.username:
        user = db.query(UserModel).filter(func.lower(UserModel.username) == func.lower(data.username.strip())).first()
    if not user and current_user:
        user = current_user

    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    clean_old_pswd = data.old_password.strip()
    clean_new_pswd = data.new_password.strip()

    if not verify_password(clean_old_pswd, user.password_hash):
        raise HTTPException(status_code=400, detail="Old password is incorrect")

    user.password_hash = get_password_hash(clean_new_pswd)
    db.commit()
    return {"message": "Password changed successfully"}

