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


-- Insert data into Country table
INSERT INTO Country (Name)
    VALUES
    ('England'),
    ('Scotland'),
    ('Wales'),
    ('Northern Ireland');

-- Insert data into County table
INSERT INTO County (Name, CountryID)
    VALUES
    ('Greater London', 1),
    ('West Midlands', 1),
    ('Greater Manchester', 1),
    ('Glasgow', 2),
    ('Edinburgh', 2),
    ('Aberdeen', 2),
    ('Cardiff', 3),
    ('Swansea', 3),
    ('Antrim and Newtownabbey', 4),
    ('Ards and North Down', 4);

-- Insert data into District table
INSERT INTO District (Name, CountyID) 
    VALUES 
    ('Camden', 1),
    ('Birmingham', 2),
    ('Manchester City Centre', 3),
    ('Anderston/City/Yorkhill', 4),
    ('Leith', 5),
    ('Torry/Ferryhill', 6),
    ('Adamsdown', 7),
    ('Morriston', 8),
    ('Glengormley', 9),
    ('Bangor', 10);  

-- Insert data into Hospital table
INSERT INTO Hospital (Name, DistrictID, MaximumCapacity)
    VALUES 
    ('Hospital of Camden', 1, 3000),
    ('Hospital of Birmingham', 2, 1300),
    ('Hospital of Manchester', 3, 3000),
    ('Hospital of Anderston', 4, 1000),
    ('Hospital of Leith', 5, 1300),
    ('Hospital of Torry', 6, 2000),
    ('Hospital of Adamsdown', 7, 1500),
    ('Hospital of Morriston', 8, 2000),
    ('Hospital of Glengormley', 9, 1400),
    ('Hospital of Bangor', 10, 2100);

-- Insert data into MinisterStatment table
INSERT INTO MinisterStatement (MinisterName, IssueType, Statement, CountryId) 
    VALUES 
    ('John Smith', 'Primary Care', 'We aim to ensure everyone has access to quality primary care services.', 1),
    ('Jane Doe', 'Mental Health', 'Mental health support is being expanded with new programs nationwide.', 3),
    ('Michael Brown', 'Hospital Infrastructure', 'Significant funding will be allocated to upgrade hospital facilities.', 1),
    ('Emily White', 'Pharmaceuticals', 'We are improving access to affordable medications.', 4),
    ('James Black', 'Medical Workforce', 'Our focus is on increasing the number of trained healthcare professionals.', 4),
    ('Sarah Green', 'Public Health', 'Promoting preventative healthcare to reduce disease rates.', 3),
    ('Robert Gray', 'Emergency Services', 'We are enhancing the response times and capacity of emergency services.', 2),
    ('Linda Blue', 'Chronic Illness Management', 'Programs for managing chronic conditions are being expanded.', 2),
    ('Thomas Gold', 'Health Technology', 'Investments in healthcare technology will improve patient outcomes.', 1),
    ('Anna Silver', 'Health Equity', 'Reducing disparities in healthcare access remains a top priority.', 3);


-- Insert data into AdminStaff table
INSERT INTO AdminStaff(FirstName, LastName, Position)
    VALUES 
    ('John', 'Doe', 'Data Clerk'),
    ('Jane', 'Doe', 'Patient Data Coordinator'),
    ('Sam', 'Yu', 'Database Administrator'),
    ('Dimitrios', 'Papaoikonomou', 'Database Administrator'),
    ('Jay', 'Xiao', 'Database Administrator'),
    ('Leah', 'Le', 'Database Administrator'),
    ('Thomas', 'Rochelle', 'Medical Records Officer'),
    ('Colin', 'Bailey', 'Principal Records Officer'),
    ('Frederik', 'Dahlqvist', 'Scheduling Coordinator'),
    ('Keir', 'Starmer', 'System Administrator');


-- Insert data into Patient table
INSERT INTO Patient(FirstName, LastName, DistrictId, Postcode, PhoneNo, Address, Gender)
    VALUES 
    ('Emily', 'Carter', 1, 'AB12 3CD', '1234567890', '45 Oak Avenue', 'Female'),
    ('Jack', 'Thompson', 2, 'CD34 5EF', '9876543210', '67 Maple Lane', 'Male'),
    ('Olivia', 'Williams', 3, 'EF56 7GH', '4561237890', '89 Pine Road', 'Female'),
    ('Liam', 'Johnson', 4, 'GH78 9IJ', '3216549870', '101 Birch Close', 'Male'),
    ('Sophia', 'Taylor', 5, 'IJ90 1KL', '1230987654', '12 Cedar Drive', 'Female'),
    ('Noah', 'Brown', 6, 'KL23 4MN', '7890123456', '34 Fir Grove', 'Male'),
    ('Ava', 'Wilson', 7, 'MN45 6OP', '4567891230', '56 Spruce Lane', 'Female'),
    ('James', 'Davis', 8, 'OP67 8QR', '2345678901', '78 Ash Court', 'Male'),
    ('Mia', 'Miller', 9, 'QR89 0ST', '5678901234', '90 Elm Way', 'Female'),
    ('Ethan', 'Moore', 10, 'ST12 3UV', '8901234567', '102 Willow Park', 'Male');

-- Insert data into PatientRecord table
INSERT INTO PatientRecord (PatientId, DateOfAppointment, HospitalId, Reason, Notes, Tests, Admitted)
    VALUES 
    (1, '2024-12-01', 1, 'General Checkup', 'Routine appointment, no issues.', 'Blood Test', FALSE),
    (2, '2024-11-28', 1, 'Flu Symptoms', 'Patient reported fever and cough.', 'Influenza Test', FALSE),
    (3, '2024-11-25', 2, 'Back Pain', 'Chronic lower back pain reported.', 'X-ray', FALSE),
    (4, '2024-12-02', 2, 'Skin Rash', 'Possible allergic reaction.', 'Skin Biopsy', FALSE),
    (5, '2024-12-03', 2, 'Chest Pain', 'Referred for cardiac evaluation.', 'ECG, Blood Test', TRUE),
    (6, '2024-12-01', 4, 'Headache', 'Recurring migraines, prescribed medication.', 'CT Scan', FALSE),
    (7, '2024-11-30', 5, 'High Blood Pressure', 'Routine follow-up for hypertension.', 'Blood Pressure Test', FALSE),
    (8, '2024-12-02', 6, 'Leg Injury', 'Suspected fracture, further evaluation needed.', 'X-ray', FALSE),
    (9, '2024-11-29', 7, 'Diabetes Management', 'Patient reported difficulty maintaining sugar levels.', 'Blood Sugar Test', FALSE),
    (10, '2024-12-03', 8, 'Asthma Symptoms', 'Severe shortness of breath noted.', 'Pulmonary Function Test', TRUE);



-- Insert data into WaitingList table
INSERT INTO WaitingList (PatientId, TreatmentType, DateOfEntry)
VALUES 
-- TODO: allow multiple waiting list entries for 1 patient
(1, 'Cardiology', '2024-12-01'),
(2, 'Orthopedics', '2024-12-02'),
(3, 'Dermatology', '2024-12-03'),
(4, 'Neurology', '2024-12-04'),
(5, 'Pediatrics', '2024-12-05'),
(6, 'Oncology', '2024-12-06'),
(7, 'Gastroenterology', '2024-12-07'),
(8, 'Ophthalmology', '2024-12-08'),
(9, 'Endocrinology', '2024-12-09'),
(10, 'Pulmonology', '2024-12-10');

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
INSERT INTO WaitingListAppointment (AppointmentId)
VALUES 
(1),
(2),
(3),
(4),
(5),
(6),
(7),
(8),
(9),
(10);

-- Basic Queries
-- Query to find list of patients and hospitals where they have been treated
Select Patient.firstName as PatientFirstName, Patient.LastName as PatientLastName, Hospital.name as HospitalName
    FROM Patient
    JOIN Appointment ON Patient.id = Appointment.patientId
    JOIN Hospital on Appointment.hospitalId = Hospital.id;

-- Query to find the firstName and lastName of patients whose appointments are scheduled after December 3, 2024
SELECT Patient.FirstName, Patient.LastName, Appointment.Date 
FROM Appointment 
JOIN Patient ON Appointment.PatientId = Patient.Id 
WHERE Appointment.Date > '2024-12-3';


-- Medium Queries
--Query that returns the most frequent appointment reasons per district
SELECT D.Name AS DistrictName, A.Reason, COUNT(A.Id) AS ReasonCount
    FROM District D JOIN Hospital H ON D.Id= H.DistrictID JOIN Appointment A ON H.Id = A.HospitalId
        GROUP BY D.Id, D.Name, A.Reason ORDER BY D.Name, ReasonCount DESC;

-- Count the number of appointments per hospital, including hospitals with no appointments
SELECT 
    h.Name AS HospitalName, 
    COUNT(a.Id) AS NumberOfAppointments
FROM 
    Hospital h
LEFT JOIN 
    Appointment a ON h.Id = a.HospitalId
GROUP BY 
    h.Name
ORDER BY 
    NumberOfAppointments DESC;

-- List of patients and the hospitals they visited, including those who haven't visited any hospital
SELECT 
    p.FirstName AS PatientFirstName,
    p.LastName AS PatientLastName,
    h.Name AS HospitalName,
    a.Date AS AppointmentDate,
    a.Reason AS AppointmentReason
FROM 
    Patient p
LEFT JOIN 
    PatientRecord pr ON p.Id = pr.PatientId
LEFT JOIN 
    Appointment a ON pr.Id = a.PatientId
LEFT JOIN 
    Hospital h ON a.HospitalId = h.Id
ORDER BY 
    p.LastName, p.FirstName;


-- Advanced Queries
--Query to find patients with more appointments than the average number of appointments per person
SELECT P.FirstName, P.LastName, COUNT(A.Id) AS TotalAppointments
    FROM Patient P JOIN Appointment A ON P.id = A.PatientId
    GROUP BY P.id, P.FirstName, P.LastName HAVING COUNT(A.Id)> (
    SELECT AVG(TotalCount) FROM (SELECT COUNT(A1.Id) AS TotalCount
        FROM Appointment A1 GROUP BY A1.PatientId) SubQuery);

-- Query to find most common reason for Hospital appointments and frequency
SELECT Hospital.name AS HospitalName, PatientRecord.reason AS MostCommonReason, COUNT(PatientRecord.id) AS Freq
    FROM Hospital
    JOIN PatientRecord ON PatientRecord.hospitalId = Hospital.id
    WHERE PatientRecord.reason = (SELECT reason
                                    FROM PatientRecord
                                    WHERE hospitalId = Hospital.id
                                    GROUP BY reason
                                    LIMIT 1)
    GROUP BY Hospital.id, PatientRecord.reason;

-- Query to find the name of districts that have more appointments than the average district
SELECT District.Name
FROM District 
JOIN Patient ON District.Id = Patient.DistrictId 
JOIN Appointment ON Patient.Id = Appointment.PatientId 
GROUP BY District.Id 
HAVING COUNT(Appointment.Id) > (
SELECT AVG(AppointmentCount) 
FROM (
    SELECT District.Id, COUNT(Appointment.Id) AS AppointmentCount 
    FROM District 
    JOIN Patient ON District.Id = Patient.DistrictId 
    JOIN Appointment ON Patient.Id = Appointment.PatientId 
    GROUP BY District.Id ) AS Districts
);

