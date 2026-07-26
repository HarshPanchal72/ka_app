from fastapi import APIRouter

router = APIRouter(prefix="/meta", tags=["Metadata & Dropdowns"])

@router.get("/options")
def get_dropdown_options():
    return {
        "departments": ["HR", "ERP", "Accounts", "Sales"],
        "sub_departments": {
            "HR": ["Recruitment", "Payroll", "Training"],
            "ERP": ["Development", "Support", "Testing"],
            "Accounts": ["Billing", "Audit", "Tax"],
            "Sales": ["Marketing", "Tele-calling", "Showroom"]
        },
        "cities": ["Ahmedabad", "Gandhinagar", "Vadodara", "Surat", "Banglore"],
        "branches": {
            "Ahmedabad": ["Ahmedabad-Makarba", "Prahladnagar Nexa", "Sanathal", "Maninagar", "Dariyapur"],
            "Gandhinagar": ["Nexa Gandhinagar", "Ather Gandhinagar"],
            "Vadodara": ["Ather Vadodara", "Workshop Vadodara", "Arena Vadodara", "BharatBenz Vadodara"],
            "Surat": ["Ather Vesu", "Piplod Surat", "Bardoli-Surat", "Kadodara Surat", "TrueValue Surat"],
            "Banglore": ["TrueValue Banglore", "Arena Banglore", "Nexa Banglore"]
        },
        "designations": {
            "HR": ["HR Manager", "HR Executive", "HR Recruiter"],
            "ERP": ["GM ERP", "Manager ERP", "ERP Sr.Executive", "ERP Jr.Executive"],
            "Accounts": ["Account Manager", "Senior Accountant", "Junior Accountant"],
            "Sales": ["Sales Manager", "Sales Executive", "Sales Officer"]
        },
        "companies": ["KAPL", "KMPL", "KCPL", "KW", "Ather"],
        "engineers": ["Bhupendra Sir", "Maunik Sir", "Yash Sir", "Komal Ma'am", "ICT Group"]
    }
