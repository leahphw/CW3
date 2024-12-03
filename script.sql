-- Create a new database
CREATE DATABASE NHSDatabase;

-- Use the newly created database
USE NHSDatabase;

-- Table to store administrative staff information
CREATE TABLE AdminStaff (
    Id INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each admin staff
    FirstName VARCHAR(40),             -- Admin staff's first name
    LastName VARCHAR(40),              -- Admin staff's last name
    Position VARCHAR(40)               -- Job position of the admin staff
);

-- Table to store countries
CREATE TABLE Country (
    Id INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each country
    Name VARCHAR(40) NOT NULL          -- Name of the country
);

-- Table to store counties within countries
CREATE TABLE County (
    Id INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each county
    Name VARCHAR(40) NOT NULL,         -- Name of the county
    CountryID INT NOT NULL,            -- ID of the associated country
    FOREIGN KEY (CountryID) REFERENCES Country(Id) ON DELETE RESTRICT
);

-- Table to store districts within counties
CREATE TABLE District (
    Id INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each district
    Name VARCHAR(40) NOT NULL,         -- Name of the district
    CountyID INT NOT NULL,             -- ID of the associated county
    FOREIGN KEY (CountyID) REFERENCES County(Id) ON DELETE RESTRICT
);

-- Table to store hospital information
CREATE TABLE Hospital (
    Id INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each hospital
    Name VARCHAR(156) NOT NULL,        -- Name of the hospital
    DistrictID INT NOT NULL,           -- ID of the associated district
    MaximumCapacity INT NOT NULL,      -- Maximum capacity of the hospital
    FOREIGN KEY (DistrictID) REFERENCES District(Id) ON DELETE RESTRICT
);

-- Table to store minister statements
CREATE TABLE MinisterStatement (
    Id INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each statement
    MinisterName VARCHAR(40),          -- Name of the minister issuing the statement
    IssueType VARCHAR(40),             -- Type of issue the statement addresses
    Statement LONGTEXT,                -- Full statement text
    CountryId INT NOT NULL,            -- ID of the associated country
    FOREIGN KEY (CountryId) REFERENCES Country(Id)
);

-- Table to store patient information
CREATE TABLE Patient (
    Id INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each patient
    FirstName VARCHAR(40),             -- Patient's first name
    LastName VARCHAR(40),              -- Patient's last name
    DistrictId INT NOT NULL,           -- ID of the associated district
    Postcode VARCHAR(10),              -- Patient's postcode
    PhoneNo VARCHAR(20),               -- Patient's phone number
    Address VARCHAR(50),               -- Patient's address
    Gender VARCHAR(10),                -- Patient's gender
    FOREIGN KEY (DistrictId) REFERENCES District(Id)
);

-- Table to store patient records
CREATE TABLE PatientRecord (
    Id INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each record
    PatientId INT NOT NULL,            -- ID of the associated patient
    DateOfAppointment DATE,            -- Date of the appointment
    HospitalId INT NOT NULL,           -- ID of the hospital where the appointment occurred
    Reason VARCHAR(255),               -- Reason for the appointment
    Notes VARCHAR(255),                -- Additional notes about the appointment
    Tests VARCHAR(255),                -- Tests conducted during the appointment
    Admitted BOOLEAN,                  -- Whether the patient was admitted
    FOREIGN KEY (PatientId) REFERENCES Patient(Id),
    FOREIGN KEY (HospitalId) REFERENCES Hospital(Id)
);

-- Table to store appointment information
CREATE TABLE Appointment (
    Id INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for each appointment
    PatientId INT NOT NULL,            -- ID of the associated patient
    HospitalId INT NOT NULL,           -- ID of the hospital where the appointment is scheduled
    Date DATE NOT NULL,                -- Appointment date
    Reason VARCHAR(255),               -- Reason for the appointment
    FOREIGN KEY (PatientId) REFERENCES Patient(Id) ON DELETE CASCADE,
    FOREIGN KEY (HospitalId) REFERENCES Hospital(Id) ON DELETE CASCADE
);

-- Table to link appointments with waiting list entries
CREATE TABLE WaitingListAppointment (
    Id INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for the waiting list appointment
    WaitingListId INT,                 -- ID of the waiting list entry
    AppointmentId INT NOT NULL UNIQUE, -- ID of the associated appointment
    FOREIGN KEY (AppointmentId) REFERENCES Appointment(Id) ON DELETE CASCADE
);

-- Table to link direct appointments with admin staff
CREATE TABLE DirectAppointment (
    Id INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for the direct appointment
    AppointmentId INT NOT NULL UNIQUE, -- ID of the associated appointment
    AdminStaffId INT NOT NULL,         -- ID of the admin staff creating the appointment
    FOREIGN KEY (AppointmentId) REFERENCES Appointment(Id) ON DELETE CASCADE,
    FOREIGN KEY (AdminStaffId) REFERENCES AdminStaff(Id) ON DELETE RESTRICT
);

-- Table to store patients on a waiting list
CREATE TABLE WaitingList (
    Id INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID for the waiting list entry
    PatientId INT NOT NULL,            -- ID of the associated patient
    TreatmentType VARCHAR(40),         -- Type of treatment required
    DateOfEntry DATE,                  -- Date the patient was added to the waiting list
    WLAppointmentId INT,               -- ID of the associated waiting list appointment
    FOREIGN KEY (WLAppointmentId) REFERENCES WaitingListAppointment(Id) ON DELETE CASCADE,
    FOREIGN KEY (PatientId) REFERENCES Patient(Id)
);

-- Add foreign key constraint to WaitingListAppointment
ALTER TABLE WaitingListAppointment 
ADD CONSTRAINT fk_Name FOREIGN KEY (WaitingListId) REFERENCES WaitingList(Id) ON DELETE RESTRICT;

-- TODO: Patients table needs to be populated before WaitingList and Appointment (the other tables don't work right now because they can't reference PatientID)
-- Insert data into Patients table


-- Insert data into WaitingList table
INSERT INTO WaitingList (PatientId, TreatmentType, DateOfEntry, WLAppointmentId)
VALUES 
-- TODO: allow multiple waiting list entries for 1 patient
(1, 'Cardiology', '2024-12-01', 1),
(2, 'Orthopedics', '2024-12-02', 2),
(3, 'Dermatology', '2024-12-03', 3),
(4, 'Neurology', '2024-12-04', 4),
(5, 'Pediatrics', '2024-12-05', 5),
(6, 'Oncology', '2024-12-06', 6),
(7, 'Gastroenterology', '2024-12-07', 7),
(8, 'Ophthalmology', '2024-12-08', 8),
(9, 'Endocrinology', '2024-12-09', 9),
(10, 'Pulmonology', '2024-12-10', 10);

-- Insert data into Appointment table
INSERT INTO Appointment (PatientId, HospitalId, Date, Reason)
VALUES 
-- TODO: allow multiple appointments for 1 patient
(1, 1, '2024-12-15', 'Follow-up check'),
(2, 1, '2024-12-16', 'Initial consultation'),
(3, 2, '2024-12-17', 'Routine check'),
(4, 3, '2024-12-18', 'Test results review'),
(5, 4, '2024-12-19', 'Pre-surgery evaluation'),
(6, 5, '2024-12-20', 'Post-surgery care'),
(7, 6, '2024-12-21', 'Physical therapy assessment'),
(8, 7, '2024-12-22', 'Medication review'),
(9, 8, '2024-12-23', 'Diagnostic imaging follow-up'),
(10, 9, '2024-12-24', 'Specialist referral');

-- Insert data into DirectAppointment table
INSERT INTO DirectAppointment (AppointmentId, AdminStaffId)
VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);

-- Insert data into WaitingListAppointment table
INSERT INTO WaitingListAppointment (WaitingListId, AppointmentId)
VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);