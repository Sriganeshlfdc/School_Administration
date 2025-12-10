-- 1. Select Database
USE school_administration;

-- 2. Disable Foreign Key Checks
SET FOREIGN_KEY_CHECKS = 0;

-- 3. Drop All Tables (Cleans up everything, including old triggers)
DROP TABLE IF EXISTS `enrollmenthistory`;
DROP TABLE IF EXISTS `academichistory`;
DROP TABLE IF EXISTS `enrollment`;
DROP TABLE IF EXISTS `parents`;
DROP TABLE IF EXISTS `students`;

-- 4. Re-enable Foreign Key Checks
SET FOREIGN_KEY_CHECKS = 1;

-- =========================================================================
-- 5. CREATE TABLES (Clean Version - No Warnings)
-- =========================================================================

-- Table: Students
CREATE TABLE `students` (
  `StudentID` INT NOT NULL AUTO_INCREMENT, -- Changed from int(11) to INT
  `AdmissionYear` YEAR NOT NULL,           -- Changed from year(4) to YEAR
  `Name` varchar(100) DEFAULT NULL,
  `Surname` varchar(100) NOT NULL,
  `DateOfBirth` date NOT NULL,
  `Gender` varchar(10) NOT NULL,
  `HouseNo` VARCHAR(50) DEFAULT NULL,
  `Street` VARCHAR(100) DEFAULT NULL,
  `Village` VARCHAR(100) DEFAULT NULL,
  `Town` VARCHAR(100) DEFAULT NULL, 
  `District` VARCHAR(100) DEFAULT NULL,
  `State` VARCHAR(100) DEFAULT NULL,
  `Country` VARCHAR(100) DEFAULT 'Uganda',
  `PhotoPath` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`StudentID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: Parents
CREATE TABLE `parents` (
  `ParentId` INT NOT NULL, -- Changed from int(11) to INT
  `StudentID` INT NOT NULL,
  
  -- Father details
  `father_name` varchar(255) NOT NULL, 
  `father_age` INT DEFAULT NULL,
  `father_contact` varchar(50) DEFAULT NULL,
  `father_email` VARCHAR(150) DEFAULT NULL,
  `father_occupation` varchar(100) DEFAULT NULL,
  `father_education` varchar(100) DEFAULT NULL,
  
  -- Mother details
  `mother_name` varchar(255) NOT NULL,
  `mother_age` INT DEFAULT NULL,
  `mother_contact` varchar(50) DEFAULT NULL,
  `mother_email` VARCHAR(150) DEFAULT NULL,
  `mother_occupation` varchar(100) DEFAULT NULL,
  `mother_education` varchar(100) DEFAULT NULL,
  
  -- Guardian details
  `guardian_name` varchar(255) DEFAULT NULL,
  `guardian_relation` ENUM('Brother','Sister','Uncle','Aunt','Grandparent','Other') DEFAULT NULL,
  `guardian_age` INT DEFAULT NULL,
  `guardian_contact` varchar(50) DEFAULT NULL,
  `guardian_email` VARCHAR(150) DEFAULT NULL,
  `guardian_occupation` varchar(100) DEFAULT NULL,
  `guardian_education` varchar(100) DEFAULT NULL,
  `guardian_address` text DEFAULT NULL,
  
  `MoreInformation` text DEFAULT NULL,
  
  PRIMARY KEY (`ParentId`),
  UNIQUE KEY `Unique_Student_Parent` (`StudentID`),
  CONSTRAINT `parents_ibfk_1` FOREIGN KEY (`StudentID`) REFERENCES `students` (`StudentID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: Enrollment
CREATE TABLE `enrollment` (
  `EnrollmentID` INT NOT NULL, -- Changed from int(11) to INT
  `StudentID` INT NOT NULL,
  `AcademicYear` VARCHAR(20) NOT NULL,
  `Level` varchar(50) NOT NULL,
  `Class` varchar(50) NOT NULL,
  `Term` varchar(50) NOT NULL,
  `Stream` varchar(50) DEFAULT NULL,
  `Residence` varchar(50) NOT NULL,
  `EntryStatus` varchar(50) NOT NULL,
  
  PRIMARY KEY (`EnrollmentID`),
  UNIQUE KEY `Unique_Student_Enrollment` (`StudentID`),
  CONSTRAINT `enrollment_ibfk_1` FOREIGN KEY (`StudentID`) REFERENCES `students` (`StudentID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: AcademicHistory
CREATE TABLE `academichistory` (
  `HistoryID` INT NOT NULL, -- Changed from int(11) to INT
  `StudentID` INT NOT NULL,
  `FormerSchool` varchar(255) DEFAULT NULL,
  `PLEIndexNumber` varchar(50) DEFAULT NULL,
  `PLEAggregate` INT DEFAULT NULL,
  `UCEIndexNumber` varchar(50) DEFAULT NULL,
  `UCEResult` text DEFAULT NULL,
  
  PRIMARY KEY (`HistoryID`),
  UNIQUE KEY `Unique_Student_History` (`StudentID`),
  CONSTRAINT `academichistory_ibfk_1` FOREIGN KEY (`StudentID`) REFERENCES `students` (`StudentID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Table: EnrollmentHistory
CREATE TABLE `enrollmenthistory` (
  `EnrollmentHistoryID` INT NOT NULL AUTO_INCREMENT, -- Changed from int(11) to INT
  `StudentID` INT NOT NULL,
  `AcademicYear` VARCHAR(20) NOT NULL,
  `Level` varchar(50) NOT NULL,
  `Class` varchar(50) NOT NULL,
  `Term` varchar(50) NOT NULL,
  `Stream` varchar(50) DEFAULT NULL,
  `Residence` varchar(50) NOT NULL,
  `EntryStatus` varchar(50) NOT NULL,
  `DateMoved` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`EnrollmentHistoryID`),
  KEY `StudentID` (`StudentID`),
  CONSTRAINT `enrollmenthistory_ibfk_1` FOREIGN KEY (`StudentID`) REFERENCES `students` (`StudentID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- =========================================================================
-- 6. TRIGGERS
-- =========================================================================

DELIMITER //

-- Trigger for Parents
CREATE TRIGGER `sync_parents_id` BEFORE INSERT ON `parents`
FOR EACH ROW
BEGIN
    SET NEW.ParentId = NEW.StudentID;
END//

-- Trigger for Enrollment
CREATE TRIGGER `sync_enrollment_id` BEFORE INSERT ON `enrollment`
FOR EACH ROW
BEGIN
    SET NEW.EnrollmentID = NEW.StudentID;
END//

-- Trigger for AcademicHistory
CREATE TRIGGER `sync_academichistory_id` BEFORE INSERT ON `academichistory`
FOR EACH ROW
BEGIN
    SET NEW.HistoryID = NEW.StudentID;
END//

DELIMITER ;