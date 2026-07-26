from sqlalchemy import Column, Integer, String, Boolean, DateTime, Text, ForeignKey
from sqlalchemy.sql import func
from app.database import Base

class UserModel(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_order=True, primary_key=True, index=True)
    username = Column(String, unique=True, index=True, nullable=False)
    password_hash = Column(String, nullable=False)
    role = Column(String, default="User")  # User, Manager, Acc
    mobile = Column(String, nullable=True)
    email = Column(String, nullable=True)
    company = Column(String, nullable=True)
    branch = Column(String, nullable=True)
    city = Column(String, nullable=True)
    department = Column(String, nullable=True)
    designation = Column(String, nullable=True)
    reporting_manager = Column(String, nullable=True)
    profile_picture = Column(String, nullable=True)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class QueryModel(Base):
    __tablename__ = "queries"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String, nullable=True, index=True)
    sent_date = Column(String, nullable=True)
    engineer_name = Column(String, nullable=True)
    user_name = Column(String, nullable=True)
    mobile_no = Column(String, nullable=True)
    email = Column(String, nullable=True)
    branch = Column(String, nullable=True)
    department = Column(String, nullable=True)
    sub_department = Column(String, nullable=True)
    city = Column(String, nullable=True)
    company = Column(String, nullable=True)
    reporting_manager = Column(String, nullable=True)
    query_text = Column(Text, nullable=False)
    remarks = Column(Text, nullable=True)
    status = Column(String, default="Pending")  # Pending, Completed, In Progress
    image_path = Column(String, nullable=True)
    w_type = Column(String, nullable=True, default="")
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class TokenRecordModel(Base):
    __tablename__ = "token_records"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String, nullable=True)
    user_name = Column(String, nullable=True)
    token_code = Column(String, index=True, nullable=False)
    remarks = Column(Text, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
