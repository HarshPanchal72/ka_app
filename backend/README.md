# Kataria App (ka_app) Python Backend

This is the official Python (FastAPI) REST API backend for the **Kataria Group Flutter Application**.

---

## 🚀 Features
- **Authentication**: JWT-based auth for `User`, `Manager`, and `Acc.` roles.
- **User Management**: User registration, profile updates, and admin user list.
- **Query & Support Ticket System**: Ticket submission with file/photo attachments, query status tracking (Pending/Completed), assignment to engineers.
- **Token Generation**: QR / Token creation and logging.
- **Metadata Endpoints**: Dynamic options for departments, branches, designations, engineers, and cities.
- **Render Ready**: Pre-configured `render.yaml`, `Dockerfile`, and PostgreSQL database integration.

---

## 💻 Local Setup & Running

1. **Navigate to the `backend` directory**:
   ```bash
   cd backend
   ```

2. **Create and Activate Virtual Environment**:
   ```bash
   python -m venv venv
   # On Windows:
   venv\Scripts\activate
   # On macOS/Linux:
   source venv/bin/activate
   ```

3. **Install Dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

4. **Run the Development Server**:
   ```bash
   uvicorn app.main:app --reload --port 8000
   ```

5. **Interactive API Documentation (Swagger)**:
   Open your browser and navigate to: [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs)

---

## 🌐 Deploying to Render Server

### Option A: Using Render Blueprints (Recommended)
1. Push your repository (or the `backend` folder) to your **GitHub** / **GitLab** account.
2. Log into your [Render Dashboard](https://dashboard.render.com/).
3. Click **New +** -> **Blueprint**.
4. Connect your repository. Render will automatically detect `render.yaml` and configure:
   - Web Service instance
   - PostgreSQL Database connection (`DATABASE_URL`)
5. Click **Apply**. Render will automatically build and deploy your service!

### Option B: Deploying Manually as a Web Service on Render
1. Log into your [Render Dashboard](https://dashboard.render.com/).
2. Click **New +** -> **Web Service**.
3. Connect your repository and choose the `backend` folder as the Root Directory.
4. Set the runtime environment details:
   - **Environment**: `Python 3`
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `gunicorn app.main:app -w 4 -k uvicorn.workers.UvicornWorker --bind 0.0.0.0:$PORT`
5. Under **Environment Variables**, add:
   - `DATABASE_URL` = `postgresql://flutter_db_gnje_user:u78MtRZFQZS6WBZckXmETjsPka8QCbtZ@dpg-d9i9j558nd3s739h8it0-a/flutter_db_gnje`
   - `SECRET_KEY` = `your_secure_secret_key`
6. Click **Create Web Service**.

---

## 🔐 Default Demo Accounts (Pre-Seeded)

| Username | Password | Role |
|---|---|---|
| `emilys` | `emilyspass` | User |
| `manager` | `manager123` | Manager |
| `admin` | `admin123` | Acc. (Admin) |
