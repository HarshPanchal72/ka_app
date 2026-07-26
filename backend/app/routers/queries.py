import os
import uuid
from typing import List, Optional
from datetime import datetime
from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.models import QueryModel
from app.schemas import QueryCreate, QueryResponse, QueryUpdate

router = APIRouter(prefix="/queries", tags=["Queries & Tickets"])

UPLOAD_DIR = os.path.join(os.path.dirname(os.path.dirname(__file__)), "uploads")
os.makedirs(UPLOAD_DIR, exist_ok=True)

@router.post("", response_model=QueryResponse, status_code=status.HTTP_201_CREATED)
async def create_query(
    user_id: Optional[str] = Form("1"),
    sent_date: Optional[str] = Form(None),
    engineer_name: Optional[str] = Form(None),
    user_name: Optional[str] = Form(None),
    mobile_no: Optional[str] = Form(None),
    email: Optional[str] = Form(None),
    branch: Optional[str] = Form(None),
    department: Optional[str] = Form(None),
    sub_department: Optional[str] = Form(None),
    city: Optional[str] = Form(None),
    company: Optional[str] = Form(None),
    reporting_manager: Optional[str] = Form(None),
    query_text: str = Form(...),
    remarks: Optional[str] = Form(None),
    status_val: Optional[str] = Form("Pending"),
    w_type: Optional[str] = Form(""),
    file: Optional[UploadFile] = File(None),
    db: Session = Depends(get_db)
):
    image_url = None
    if file:
        file_ext = os.path.splitext(file.filename)[1]
        filename = f"query_{uuid.uuid4().hex}{file_ext}"
        file_path = os.path.join(UPLOAD_DIR, filename)
        with open(file_path, "wb") as buffer:
            content = await file.read()
            buffer.write(content)
        image_url = f"/static/uploads/{filename}"

    if not sent_date:
        sent_date = datetime.now().strftime("%d/%m/%Y")

    query = QueryModel(
        user_id=user_id,
        sent_date=sent_date,
        engineer_name=engineer_name,
        user_name=user_name,
        mobile_no=mobile_no,
        email=email,
        branch=branch,
        department=department,
        sub_department=sub_department,
        city=city,
        company=company,
        reporting_manager=reporting_manager,
        query_text=query_text,
        remarks=remarks,
        status=status_val or "Pending",
        image_path=image_url,
        w_type=w_type or ""
    )
    db.add(query)
    db.commit()
    db.refresh(query)
    return query

@router.post("/json", response_model=QueryResponse, status_code=status.HTTP_201_CREATED)
def create_query_json(data: QueryCreate, db: Session = Depends(get_db)):
    sent_date = data.sent_date or datetime.now().strftime("%d/%m/%Y")
    
    query = QueryModel(
        user_id=data.user_id,
        sent_date=sent_date,
        engineer_name=data.engineer_name,
        user_name=data.user_name,
        mobile_no=data.mobile_no,
        email=data.email,
        branch=data.branch,
        department=data.department,
        sub_department=data.sub_department,
        city=data.city,
        company=data.company,
        reporting_manager=data.reporting_manager,
        query_text=data.query_text,
        remarks=data.remarks,
        status=data.status or "Pending",
        w_type=data.w_type or ""
    )
    db.add(query)
    db.commit()
    db.refresh(query)
    return query

@router.get("", response_model=List[QueryResponse])
def get_queries(
    user_id: Optional[str] = None,
    status_filter: Optional[str] = None,
    department: Optional[str] = None,
    engineer_name: Optional[str] = None,
    db: Session = Depends(get_db)
):
    query_builder = db.query(QueryModel)
    if user_id:
        query_builder = query_builder.filter(QueryModel.user_id == user_id)
    if status_filter:
        query_builder = query_builder.filter(QueryModel.status == status_filter)
    if department:
        query_builder = query_builder.filter(QueryModel.department == department)
    if engineer_name:
        query_builder = query_builder.filter(QueryModel.engineer_name == engineer_name)
    
    return query_builder.order_by(QueryModel.id.desc()).all()

@router.get("/{query_id}", response_model=QueryResponse)
def get_query_by_id(query_id: int, db: Session = Depends(get_db)):
    query = db.query(QueryModel).filter(QueryModel.id == query_id).first()
    if not query:
        raise HTTPException(status_code=404, detail="Query not found")
    return query

@router.patch("/{query_id}", response_model=QueryResponse)
def update_query(query_id: int, data: QueryUpdate, db: Session = Depends(get_db)):
    query = db.query(QueryModel).filter(QueryModel.id == query_id).first()
    if not query:
        raise HTTPException(status_code=404, detail="Query not found")
    
    if data.status is not None:
        query.status = data.status
    if data.remarks is not None:
        query.remarks = data.remarks
    if data.engineer_name is not None:
        query.engineer_name = data.engineer_name
    
    db.commit()
    db.refresh(query)
    return query
