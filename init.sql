CREATE DATABASE IF NOT EXISTS university;
USE university;

-- =======================================================
-- 1. BASE INDEPENDENT TABLES
-- =======================================================

-- Places (Lookup for global room listings)
CREATE TABLE Places (
    place_number INT AUTO_INCREMENT PRIMARY KEY,
    place_type ENUM('Hall', 'Apartment') NOT NULL
);

-- Advisers
CREATE TABLE Advisers (
    adviser_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    position VARCHAR(50),
    department_name VARCHAR(100),
    internal_phone VARCHAR(15),
    email VARCHAR(100) UNIQUE,
    room_number VARCHAR(10)
);

-- Courses
CREATE TABLE Courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_title VARCHAR(100) NOT NULL,
    course_year INT,
    instructor_name VARCHAR(100),
    instructor_phone VARCHAR(15),
    instructor_email VARCHAR(100),
    instructor_room VARCHAR(10),
    department_name VARCHAR(100)
);

-- Residence Staff
CREATE TABLE Residence_Staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    street VARCHAR(100),
    city VARCHAR(50),
    postcode VARCHAR(10),
    date_of_birth DATE,
    gender ENUM('Male', 'Female', 'Other'),
    position VARCHAR(50),
    location VARCHAR(100)
);

-- Apartments
CREATE TABLE Apartments (
    apartment_id INT AUTO_INCREMENT PRIMARY KEY,
    street VARCHAR(100),
    city VARCHAR(50),
    postcode VARCHAR(10),
    num_bedrooms INT
);

-- =======================================================
-- 2. DEPENDENT CORE TABLES
-- =======================================================

-- Express Session Storage Table
CREATE TABLE IF NOT EXISTS sessions (
  session_id VARCHAR(128) COLLATE utf8mb4_bin NOT NULL,
  expires INT(11) UNSIGNED NOT NULL,
  data TEXT COLLATE utf8mb4_bin,
  PRIMARY KEY (session_id)
);
-- Students
CREATE TABLE Students (
    banner_number VARCHAR(15) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    street VARCHAR(100),
    city VARCHAR(50),
    postcode VARCHAR(10),
    mobile_phone VARCHAR(15),
    email VARCHAR(100) UNIQUE,
    date_of_birth DATE,
    gender ENUM('Male', 'Female', 'Other'),
    student_category VARCHAR(30),
    nationality VARCHAR(50),
    special_needs TEXT,
    additional_comments TEXT,
    status VARCHAR(20),
    major VARCHAR(50),
    minor VARCHAR(50),
    adviser_id INT,
    course_id INT
);

-- Halls
CREATE TABLE Halls (
    hall_id INT AUTO_INCREMENT PRIMARY KEY,
    hall_name VARCHAR(100) NOT NULL,
    street VARCHAR(100),
    city VARCHAR(50),
    postcode VARCHAR(10),
    telephone VARCHAR(15),
    manager_staff_id INT
);

-- Hall Rooms
CREATE TABLE Hall_Rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    place_number INT NOT NULL UNIQUE,
    hall_id INT NOT NULL,
    room_number VARCHAR(10),
    monthly_rent DECIMAL(10,2) NOT NULL
);

-- Apartment Rooms
CREATE TABLE Apartment_Rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    place_number INT NOT NULL UNIQUE,
    apartment_id INT NOT NULL,
    room_number VARCHAR(10),
    monthly_rent DECIMAL(10,2) NOT NULL
);

-- Leases
CREATE TABLE Leases (
    lease_id INT AUTO_INCREMENT PRIMARY KEY,
    banner_number VARCHAR(15),
    place_number INT,
    lease_duration_semesters INT,
    start_date DATE,
    end_date DATE,
    address VARCHAR(200),
    room_number VARCHAR(10)
);

-- Invoices
CREATE TABLE Invoices (
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    lease_id INT,
    semester VARCHAR(20),
    payment_due DECIMAL(10,2),
    banner_number VARCHAR(15),
    place_number INT,
    room_number VARCHAR(10),
    address VARCHAR(200),
    date_paid DATE,
    payment_method VARCHAR(30),
    first_reminder_date DATE,
    second_reminder_date DATE
);

-- Apartment Inspections
CREATE TABLE Apartment_Inspections (
    inspection_id INT AUTO_INCREMENT PRIMARY KEY,
    apartment_id INT,
    staff_id INT,
    inspection_date DATE,
    satisfactory BOOLEAN,
    comments TEXT
);

-- Next of Kin
CREATE TABLE Next_of_Kin (
    kin_id INT AUTO_INCREMENT PRIMARY KEY,
    banner_number VARCHAR(15),
    name VARCHAR(100) NOT NULL,
    relationship VARCHAR(50),
    street VARCHAR(100),
    city VARCHAR(50),
    postcode VARCHAR(10),
    phone VARCHAR(15)
);

-- =======================================================
-- 3. CONSTRAINT DECLARATIONS (ALTER STATEMENTS)
-- =======================================================

-- Students
ALTER TABLE Students
  ADD CONSTRAINT fk_students_adviser FOREIGN KEY (adviser_id) REFERENCES Advisers(adviser_id) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT fk_students_course FOREIGN KEY (course_id) REFERENCES Courses(course_id) ON DELETE SET NULL ON UPDATE CASCADE;

-- Halls
ALTER TABLE Halls
  ADD CONSTRAINT fk_halls_manager FOREIGN KEY (manager_staff_id) REFERENCES Residence_Staff(staff_id) ON DELETE SET NULL ON UPDATE CASCADE;

-- Hall_Rooms
ALTER TABLE Hall_Rooms
  ADD CONSTRAINT fk_hallrooms_hall FOREIGN KEY (hall_id) REFERENCES Halls(hall_id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT fk_hallrooms_place FOREIGN KEY (place_number) REFERENCES Places(place_number) ON DELETE CASCADE ON UPDATE CASCADE;

-- Apartment_Rooms
ALTER TABLE Apartment_Rooms
  ADD CONSTRAINT fk_apartmentrooms_apartment FOREIGN KEY (apartment_id) REFERENCES Apartments(apartment_id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT fk_apartmentrooms_place FOREIGN KEY (place_number) REFERENCES Places(place_number) ON DELETE CASCADE ON UPDATE CASCADE;

-- Leases
ALTER TABLE Leases
  ADD CONSTRAINT fk_leases_student FOREIGN KEY (banner_number) REFERENCES Students(banner_number) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT fk_leases_place FOREIGN KEY (place_number) REFERENCES Places(place_number) ON DELETE CASCADE ON UPDATE CASCADE;

-- Invoices
ALTER TABLE Invoices
  ADD CONSTRAINT fk_invoices_lease FOREIGN KEY (lease_id) REFERENCES Leases(lease_id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT fk_invoices_student FOREIGN KEY (banner_number) REFERENCES Students(banner_number) ON DELETE CASCADE ON UPDATE CASCADE;

-- Apartment_Inspections
ALTER TABLE Apartment_Inspections
  ADD CONSTRAINT fk_inspections_apartment FOREIGN KEY (apartment_id) REFERENCES Apartments(apartment_id) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT fk_inspections_staff FOREIGN KEY (staff_id) REFERENCES Residence_Staff(staff_id) ON DELETE SET NULL ON UPDATE CASCADE;

-- Next_of_Kin
ALTER TABLE Next_of_Kin
  ADD CONSTRAINT fk_kin_student FOREIGN KEY (banner_number) REFERENCES Students(banner_number) ON DELETE CASCADE ON UPDATE CASCADE;