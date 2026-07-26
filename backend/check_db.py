import psycopg2
import sys

# External connection string for Render database
DB_URL = "postgresql://flutter_db_gnje_user:u78MtRZFQZS6WBZckXmETjsPka8QCbtZ@dpg-d9i9j558nd3s739h8it0-a.singapore-postgres.render.com/flutter_db_gnje?sslmode=require"

def main():
    try:
        conn = psycopg2.connect(DB_URL)
        cursor = conn.cursor()
        
        print("\n=========================================")
        print("  👥 USERS TABLE DATA (kataria_db)")
        print("=========================================")
        cursor.execute("SELECT id, username, role, mobile, email, department, designation FROM users;")
        users = cursor.fetchall()
        if not users:
            print("No users found.")
        else:
            for u in users:
                print(f"ID: {u[0]} | Username: {u[1]} | Role: {u[2]} | Mobile: {u[3]} | Email: {u[4]} | Dept: {u[5]} | Desig: {u[6]}")
                
        print("\n=========================================")
        print("  🎫 QUERIES TABLE DATA (Support Tickets)")
        print("=========================================")
        cursor.execute("SELECT id, query_number, query_type, priority, status, engineer_name, created_at FROM queries;")
        queries = cursor.fetchall()
        if not queries:
            print("No support queries found.")
        else:
            for q in queries:
                print(f"Ticket #{q[1]} | Type: {q[2]} | Priority: {q[3]} | Status: {q[4]} | Engineer: {q[5]} | Date: {q[6]}")
                
        print("=========================================\n")
        cursor.close()
        conn.close()
    except Exception as e:
        print(f"Database connection error: {e}")

if __name__ == "__main__":
    main()
