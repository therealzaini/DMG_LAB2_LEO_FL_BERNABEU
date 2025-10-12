CREATE TABLE Staff(
Staff_Id INT PRIMARY KEY,
name VARCHAR(50),
statue VARCHAR(50)
);
CREATE TABLE Practionners(
Staff_id INT PRIMARY KEY,
specialty VARCHAR(50),
license_number int,
FOREIGN KEY (Staff_id) REFERENCES Staff(Staff_Id) ON DELETE CASCADE
);
CREATE TABLE Caregiving(
Staff_id INT PRIMARY KEY,
ward VARCHAR(50),
grade VARCHAR(50),
FOREIGN KEY (Staff_id) REFERENCES Staff(Staff_Id) ON DELETE CASCADE
);
CREATE TABLE technical(
Staff_id INT PRIMARY KEY,
modality VARCHAR(50),
certification varchar(50),
FOREIGN KEY (Staff_id) REFERENCES Staff(Staff_Id) ON DELETE CASCADE
);

CREATE TABLE hospital(
HID INT PRIMARY KEY,
name VARCHAR(50),
city VARCHAR(50),
region VARCHAR(50)
);

CREATE TABLE dept(
DEP_ID INT PRIMARY KEY,
name VARCHAR(50),
speciality VARCHAR(50),
HID INT NOT NULL,
FOREIGN KEY (HID) REFERENCES Hospital(HID) ON DELETE NO ACTION
);
CREATE TABLE Work_in(
Staff_id INT NOT NULL,
Dep_id INT,
PRIMARY KEY (Staff_id,dep_id),
FOREIGN KEY (Staff_id) REFERENCES Staff(Staff_Id) ON DELETE NO ACTION,
FOREIGN KEY (dep_id) REFERENCES dept(dep_id) ON DELETE NO ACTION
);

CREATE TABLE medication(
Class VARCHAR(50),
Drug_id INT PRIMARY KEY,
name VARCHAR(50),
form VARCHAR(50),
strength VARCHAR(50),
active_ingredient VARCHAR(50),
manufacturer VARCHAR(50)
);
CREATE TABLE stock(
HID INT,
Drug_id INT,
Unit_Price REAL,
qty INT,
stock_timestamp DATE,
reorder_level VARCHAR(50),
PRIMARY KEY (HID,Drug_id),
FOREIGN KEY (HID) REFERENCES hospital(HID),
FOREIGN KEY (Drug_id) REFERENCES medication(Drug_id)
);

CREATE TABLE Prescription(
PID INT PRIMARY KEY,
DateIssued DATE
);

CREATE TABLE Include(
PID INT,
Drug_id INt,
Dosage real,
Duration VARCHAR(50),
PRIMARY KEY(PID,Drug_id),
FOREIGN KEY (PID) REFERENCES Prescription(PID),
FOREIGN KEY (Drug_id) REFERENCES medication(Drug_id)
);

CREATE TABLE Patient(
IID INT PRIMARY KEY,
CIN VARCHAR(50),
name VARCHAR(50),
sex VARCHAR(50),
birth_date DATE,
blood_group VARCHAR(50),
Phone VARCHAR(50)
);

CREATE TABLE Contact_Location(
CLID INT PRIMARY KEY,
city VARCHAR(50),
province VARCHAR(50),
street VARCHAR(50),
Number INT,
Postal_Code INT,
Phone VARCHAR(50)
);

CREATE TABLE Have(
CLID INT,
IID INT,
PRIMARY KEY(CLID,IID),
FOREIGN KEY(IID) REFERENCES Patient(IID),
FOREIGN KEY(CLID) REFERENCES Contact_Location(CLID)
);

CREATE TABLE Insurance(
InsID INT PRIMARY KEY,
Type VARCHAR(50)
);

CREATE TABLE Covers(
InsID INT,
IID INT,
PRIMARY KEY (InsID,IID),
FOREIGN KEY (IID) REFERENCES Patient(IID),
FOREIGN KEY (InsID) REFERENCES Insurance(InsID)
);

CREATE TABLE Expense(
ExId INT PRIMARY KEY,
Total real,
InsID INT,
FOREIGN KEY (InsID) REFERENCES Insurance(InsID)
);

CREATE TABLE Clinical_activity(
CAID INT PRIMARY KEY,
Time VARCHAR(50),
Date date,
Dep_id INT,
Staff_id INT,
IID INT NOT NULL,
ExId INT NOT NULL,
PID INT,
FOREIGN KEY (PID) REFERENCES Prescription(PID),
FOREIGN KEY (ExId) REFERENCES Expense(ExId) ON DELETE NO ACTION,
FOREIGN KEY (IID) REFERENCES Patient(IID) ON DELETE NO ACTION,
FOREIGN KEY (Dep_id) REFERENCES dept(Dep_id),
FOREIGN KEY (Staff_id) REFERENCES Staff(Staff_id)
);

CREATE TABLE appointment(
CAID INT PRIMARY KEY,
Reason VARCHAR(50),
Statues varchar(50),
FOREIGN KEY (CAID) REFERENCES Clinical_activity(CAID)
);


CREATE TABLE Emergency(
CAID INT PRIMARY KEY,
triage_level VARCHAR(50),
outcome varchar(50),
FOREIGN KEY (CAID) REFERENCES Clinical_activity(CAID)
);


-- ADDING THE FOREIGN KEYS THAT WEREN'T ADDED PREVIOUSLY:
-- for prescription:
ALTER TABLE Prescription
ADD COLUMN CAID INT,
ADD FOREIGN KEY (CAID)
REFERENCES Clinical_activity(CAID);

-- for expenses:
ALTER TABLE Expense
ADD COLUMN CAID INT,
ADD FOREIGN KEY (CAID)
REFERENCES Clinical_activity(CAID);

INSERT INTO Staff VALUES
(1, 'Dr. Ahmed El Mansouri', 'Active'),
(2, 'Nurse Fatima Zahra', 'On Duty');

INSERT INTO Practionners VALUES
(1, 'Cardiologist', 78945),
(2, 'General Nurse', 11223);

INSERT INTO Caregiving VALUES
(2, 'Pediatric Ward', 'Senior');

INSERT INTO technical VALUES
(1, 'Radiology', 'Certified Technician');

INSERT INTO hospital VALUES
(1, 'CHU Benguerir', 'Benguerir', 'Marrakech-Safi'),
(2, 'Mohammed VI Hospital', 'Marrakech', 'Marrakech-Safi');

INSERT INTO dept VALUES
(1, 'Cardiology', 'Heart Care', 1),
(2, 'Pediatrics', 'Child Health', 2);

INSERT INTO Work_in VALUES
(1, 1),
(2, 2);

INSERT INTO medication VALUES
('Antibiotic', 1, 'Amoxicillin', 'Tablet', '500mg', 'Amoxicillin', 'Sothema'),
('Analgesic', 2, 'Paracetamol', 'Syrup', '250mg/5ml', 'Paracetamol', 'Laprophan');

INSERT INTO stock VALUES
(1, 1, 25.50, 300, '2025-10-01', '50 units'),
(2, 2, 12.00, 150, '2025-09-28', '30 units');

INSERT INTO Prescription VALUES
(1, '2025-10-10', NULL),
(2, '2025-09-30', NULL);

INSERT INTO Patient VALUES
(1, 'JH123456', 'Youssef Ait Hmadou', 'Male', '1995-03-15', 'O+', '0612345678'),
(2, 'KH654321', 'Sara El Amrani', 'Female', '2000-06-22', 'A-', '0623456789');

INSERT INTO Contact_Location VALUES
(1, 'Benguerir', 'Rhamna', 'Avenue Mohammed V', 12, 43150, '0612345678'),
(2, 'Marrakech', 'Marrakech', 'Rue Ibn Sina', 45, 40000, '0623456789');

INSERT INTO Have VALUES
(1, 1),
(2, 2);

INSERT INTO Insurance VALUES
(1, 'CNOPS'),
(2, 'CNSS');

INSERT INTO Covers VALUES
(1, 1),
(2, 2);

INSERT INTO Expense VALUES
(1, 1250.75, 1, NULL),
(2, 600.00, 2, NULL);

INSERT INTO Clinical_activity VALUES
(1, '10:00', '2025-10-12', 1, 1, 1, 1, 1),
(2, '14:30', '2025-10-11', 2, 2, 2, 2, 2);

INSERT INTO appointment VALUES
(1, 'Routine Checkup', 'Scheduled'),
(2, 'Vaccination', 'Completed');

INSERT INTO Emergency VALUES
(2, 'Low', 'Stable');

SELECT p.name AS Patient_Name
FROM Patient p
JOIN Clinical_activity ca ON p.IID = ca.IID
JOIN appointment a ON ca.CAID = a.CAID
JOIN dept d ON ca.Dep_id = d.Dep_id
JOIN hospital ho ON d.HID = ho.HID
WHERE ho.city = 'Benguerir'
  AND a.Statues = 'Scheduled';