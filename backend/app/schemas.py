from pydantic import BaseModel, EmailStr
from typing import Optional, List
from datetime import datetime

# Token Schemas
class Token(BaseModel):
    access_token: str
    token_type: str
    role: str
    username: str

class TokenData(BaseModel):
    username: Optional[str] = None
    role: Optional[str] = None

# User Schemas
class UserLogin(BaseModel):
    username: str
    password: str
    role: Optional[str] = "User"

class UserRegister(BaseModel):
    username: str
    password: str
    role: Optional[str] = "User"
    mobile: Optional[str] = None
    email: Optional[str] = None
    company: Optional[str] = None
    branch: Optional[str] = None
    city: Optional[str] = None
    department: Optional[str] = None
    designation: Optional[str] = None
    reporting_manager: Optional[str] = None

class UserUpdate(BaseModel):
    mobile: Optional[str] = None
    email: Optional[str] = None
    company: Optional[str] = None
    branch: Optional[str] = None
    city: Optional[str] = None
    department: Optional[str] = None
    designation: Optional[str] = None

class ChangePassword(BaseModel):
    username: Optional[str] = None
    old_password: str
    new_password: str

class UserResponse(BaseModel):
    id: int
    username: str
    role: str
    mobile: Optional[str] = None
    email: Optional[str] = None
    company: Optional[str] = None
    branch: Optional[str] = None
    city: Optional[str] = None
    department: Optional[str] = None
    designation: Optional[str] = None
    reporting_manager: Optional[str] = None
    profile_picture: Optional[str] = None

    class Config:
        from_attributes = True

# Query / Ticket Schemas
class QueryCreate(BaseModel):
    user_id: Optional[str] = "1"
    sent_date: Optional[str] = None
    engineer_name: Optional[str] = None
    user_name: Optional[str] = None
    mobile_no: Optional[str] = None
    email: Optional[str] = None
    branch: Optional[str] = None
    department: Optional[str] = None
    sub_department: Optional[str] = None
    city: Optional[str] = None
    company: Optional[str] = None
    reporting_manager: Optional[str] = None
    query_text: str
    remarks: Optional[str] = None
    status: Optional[str] = "Pending"
    w_type: Optional[str] = ""

class QueryUpdate(BaseModel):
    status: Optional[str] = None
    remarks: Optional[str] = None
    engineer_name: Optional[str] = None

class QueryResponse(BaseModel):
    id: int
    user_id: Optional[str] = None
    sent_date: Optional[str] = None
    engineer_name: Optional[str] = None
    user_name: Optional[str] = None
    mobile_no: Optional[str] = None
    email: Optional[str] = None
    branch: Optional[str] = None
    department: Optional[str] = None
    sub_department: Optional[str] = None
    city: Optional[str] = None
    company: Optional[str] = None
    reporting_manager: Optional[str] = None
    query_text: str
    remarks: Optional[str] = None
    status: str
    image_path: Optional[str] = None
    w_type: Optional[str] = ""

    class Config:
        from_attributes = True

# Token Record Schemas
class TokenRecordCreate(BaseModel):
    user_id: Optional[str] = None
    user_name: Optional[str] = None
    token_code: str
    remarks: Optional[str] = None

class TokenRecordResponse(BaseModel):
    id: int
    user_id: Optional[str] = None
    user_name: Optional[str] = None
    token_code: str
    remarks: Optional[str] = None
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True
