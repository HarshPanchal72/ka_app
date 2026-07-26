import uuid
from typing import List, Optional
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database import get_db
from app.models import TokenRecordModel
from app.schemas import TokenRecordCreate, TokenRecordResponse

router = APIRouter(prefix="/tokens", tags=["Token Generation"])

@router.post("/generate", response_model=TokenRecordResponse, status_code=status.HTTP_201_CREATED)
def generate_token(data: TokenRecordCreate, db: Session = Depends(get_db)):
    token_code = data.token_code or f"TK-{uuid.uuid4().hex[:8].upper()}"
    record = TokenRecordModel(
        user_id=data.user_id,
        user_name=data.user_name,
        token_code=token_code,
        remarks=data.remarks
    )
    db.add(record)
    db.commit()
    db.refresh(record)
    return record

@router.get("", response_model=List[TokenRecordResponse])
def get_tokens(user_id: Optional[str] = None, db: Session = Depends(get_db)):
    query = db.query(TokenRecordModel)
    if user_id:
        query = query.filter(TokenRecordModel.user_id == user_id)
    return query.order_by(TokenRecordModel.id.desc()).all()
