# University Accommodation System – Backend Server

Backend server for the **University Accommodation System Android App**, built using **Node.js, Express, and MySQL**.  
This server manages student accommodation data such as students, leases, rooms, invoices, and inspections.

---

# Quick Links

**Android App:**
android app (udba.apk)<br>

**ER Diagram:**  
https://dbdiagram.io/d/69bbc8a978c6c4bc7a1fe414  <br>

**API Diagram:**  
https://miro.com/app/board/uXjVGqHM6t4=/?share_link_id=403010924186 <br>

--- 

# Getting started
1. Use Repository: add the .env varibles. <br>
  **.env** to backend-server
  ```
  DATABASE_URL=
  PORT=
  ADMIN_USER=
  ADMIN_PASS=
  SESSION_SECRET=<br>
  ```
  **commands**
   ```
   git clone https://github.com/AbhijeetNagar56/University-Database.git
   cd University-Database
   npm run build
   npm start
   ```

2. Use Docker image: add a db_pass.txt.
   ```
   git clone https://github.com/AbhijeetNagar56/University-Database.git
   cd University-Database
   docker-compose -f app.yaml up -d
   ```

---

**Login Page → Query Console Sample Query**

```sql
select * from Students;
```

## Tech Stack
**Frontend:** Android Studio, Kotlin, Jetpack Compose
**Backend:** Node.js, Express.js
**Database:** MySQL
**Authentication:** express-mysql-session
**Hosting:** Render (Backend)
**Database Hosting:** Railway
**File Uploads:** Multer
**Environment Management:** dotenv

## API Overview

The backend provides REST APIs to manage:

Students
Halls of Residence
Student Apartments
Leases
Invoices
Inspections
Staff
Authentication Sessions


## Database Information

### Database schema details are available in:

public/Database.txt

### Visual structure:

public/structure.png


## Deployment Details
Backend Hosting: Render (Free Tier)
Database Hosting: Railway

These platforms allow:

Cloud-based API hosting
Remote MySQL access
Scalable backend deployment


## Features Supported
Student accommodation management
Lease handling
Invoice and payment tracking
Inspection records
Authentication with session storage
RESTful API architecture
MySQL relational database integration


## License
This project is created for academic purposes as part of a University Database Management System project.
