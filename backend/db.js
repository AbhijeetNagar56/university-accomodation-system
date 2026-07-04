import mysql from "mysql2/promise";
import dotenv from "dotenv";
import fs from 'fs';


dotenv.config();

let dbUrl;

// If a secret file is provided, build the DB URL dynamically
if (process.env.DB_PASSWORD_FILE) {
  const password = fs.readFileSync(process.env.DB_PASSWORD_FILE, 'utf8').trim();
  dbUrl = `mysql://${process.env.DB_USER}:${password}@${process.env.DB_HOST}:${process.env.DB_PORT}/${process.env.DB_NAME}`;
} else {
  // fallback: use DB env directly (for local dev)
  dbUrl = process.env.DB;
}

if (!dbUrl && process.env.DATABASE_URL) {
  dbUrl = process.env.DATABASE_URL;
}

if (!dbUrl) {
  console.error("Database connection string is empty! Check your environment variables.");
  process.exit(1);
}

const pool = mysql.createPool(dbUrl); 

export default pool;