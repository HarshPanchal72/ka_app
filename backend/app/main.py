import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from app.config import settings
from app.database import Base, engine, SessionLocal
from app.routers import auth, users, queries, tokens, meta
from app.models import UserModel, QueryModel
from app.auth import get_password_hash

# Initialize Database Tables
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title=settings.PROJECT_NAME,
    description="Kataria App (ka_app) Backend REST API for Flutter Mobile Application",
    version="1.0.0",
    docs_url="/docs",
    redoc_url="/redoc"
)

# CORS setup for mobile and web access
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Mount Static Uploads Folder
UPLOAD_DIR = os.path.join(os.path.dirname(__file__), "uploads")
os.makedirs(UPLOAD_DIR, exist_ok=True)
app.mount("/static/uploads", StaticFiles(directory=UPLOAD_DIR), name="uploads")

# Register API Routers under /api/v1
app.include_router(auth.router, prefix=settings.API_V1_STR)
app.include_router(users.router, prefix=settings.API_V1_STR)
app.include_router(queries.router, prefix=settings.API_V1_STR)
app.include_router(tokens.router, prefix=settings.API_V1_STR)
app.include_router(meta.router, prefix=settings.API_V1_STR)

@app.on_event("startup")
def seed_default_data():
    """Seed initial sample data and accounts safely across workers without failing startup"""
    try:
        db = SessionLocal()
        try:
            if db.query(UserModel.id).first() is None:
                user = UserModel(
                    username="emilys",
                    password_hash=get_password_hash("emilyspass"),
                    role="User",
                    email="emilys@kataria.co.in",
                    mobile="9876543210",
                    company="KAPL",
                    branch="Ahmedabad-Makarba",
                    city="Ahmedabad",
                    department="HR",
                    designation="HR Executive",
                    reporting_manager="Bhupendra Sir"
                )
                manager = UserModel(
                    username="manager",
                    password_hash=get_password_hash("manager123"),
                    role="Manager",
                    email="manager@kataria.co.in",
                    mobile="9876543211",
                    company="KAPL",
                    branch="Ahmedabad-Makarba",
                    city="Ahmedabad",
                    department="ERP",
                    designation="Manager ERP"
                )
                admin = UserModel(
                    username="admin",
                    password_hash=get_password_hash("admin123"),
                    role="Acc",
                    email="admin@kataria.co.in",
                    mobile="9876543212",
                    company="KAPL",
                    branch="Ahmedabad-Makarba",
                    city="Ahmedabad",
                    department="Accounts",
                    designation="Account Manager"
                )
                ict1 = UserModel(
                    username="ict1",
                    password_hash=get_password_hash("ict1pass"),
                    role="User",
                    email="ict1@kataria.co.in",
                    mobile="9876543213",
                    company="KAPL",
                    branch="Ahmedabad-Makarba",
                    city="Ahmedabad",
                    department="ICT",
                    designation="ICT Executive"
                )
                ict2 = UserModel(
                    username="ict2",
                    password_hash=get_password_hash("ict2pass"),
                    role="User",
                    email="ict2@kataria.co.in",
                    mobile="9876543214",
                    company="KAPL",
                    branch="Ahmedabad-Makarba",
                    city="Ahmedabad",
                    department="ICT",
                    designation="ICT Senior Executive"
                )
                db.add_all([user, manager, admin, ict1, ict2])
                db.commit()
        except Exception as e:
            try:
                db.rollback()
            except Exception:
                pass
            print(f"User seeding skipped: {e}")

        try:
            if db.query(QueryModel.id).first() is None:
                sample_query1 = QueryModel(
                    user_id="1",
                    sent_date="20/06/2026",
                    engineer_name="Bhupendra Sir",
                    user_name="Komal Shah",
                    mobile_no="9999999999",
                    email="komal@kataria.co.in",
                    branch="Surat-Varachha",
                    department="HR",
                    sub_department="Payroll",
                    city="Surat",
                    company="KAPL",
                    query_text="Salary slip not generated.",
                    remarks="Under Review",
                    status="Pending"
                )
                sample_query2 = QueryModel(
                    user_id="1",
                    sent_date="25/06/2026",
                    engineer_name="Maunik Sir",
                    user_name="Sanjay Gajjar",
                    mobile_no="8989989855",
                    email="sanjay@kataria.co.in",
                    branch="Ahmedabad-Makarba",
                    department="Accounts",
                    sub_department="Audit",
                    city="Ahmedabad",
                    company="KAPL",
                    query_text="Reports not downloading in ERP dashboard",
                    remarks="Completed",
                    status="Completed"
                )
                db.add_all([sample_query1, sample_query2])
                db.commit()
        except Exception as e:
            try:
                db.rollback()
            except Exception:
                pass
            print(f"Query seeding skipped: {e}")
        finally:
            try:
                db.close()
            except Exception:
                pass
    except Exception as outer_e:
        print(f"Startup seeding ignored error: {outer_e}")



@app.get("/")
def root():
    return {
        "status": "online",
        "message": "Kataria App Backend is running!",
        "documentation": "/docs"
    }

@app.get("/health")
def health_check():
    return {"status": "healthy"}
