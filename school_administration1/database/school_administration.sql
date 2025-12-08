-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 04, 2025 at 01:52 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `school_administration`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `GenerateDetailedStudentData` ()   BEGIN
    -- Configuration Variables
    DECLARE v_max_students_per_stream INT DEFAULT 20; -- 20 * 5 streams = 100 per class
    
    -- Loop Counters
    DECLARE c_idx INT DEFAULT 1; -- Class Loop
    DECLARE s_idx INT DEFAULT 1; -- Stream Loop
    DECLARE stu_idx INT DEFAULT 1; -- Student Loop
    
    -- Data Variables
    DECLARE v_student_id INT;
    DECLARE v_class VARCHAR(10);
    DECLARE v_level VARCHAR(20);
    DECLARE v_stream VARCHAR(1);
    
    DECLARE v_gender VARCHAR(10);
    DECLARE v_surname VARCHAR(50);
    DECLARE v_name VARCHAR(50);
    DECLARE v_dob DATE;
    DECLARE v_address VARCHAR(100);
    DECLARE v_photo_path VARCHAR(255);
    
    -- Parent Variables
    DECLARE v_father_name VARCHAR(100);
    DECLARE v_father_contact VARCHAR(20);
    DECLARE v_father_age INT;
    DECLARE v_father_occ VARCHAR(50);
    DECLARE v_father_edu VARCHAR(50);
    
    DECLARE v_mother_name VARCHAR(100);
    DECLARE v_mother_contact VARCHAR(20);
    DECLARE v_mother_age INT;
    DECLARE v_mother_occ VARCHAR(50);
    DECLARE v_mother_edu VARCHAR(50);
    
    -- Guardian Variables (All or Nothing)
    DECLARE v_has_guardian INT;
    DECLARE v_guardian_name VARCHAR(100);
    DECLARE v_guardian_contact VARCHAR(20);
    DECLARE v_guardian_rel VARCHAR(20);
    DECLARE v_guardian_age INT;
    DECLARE v_guardian_occ VARCHAR(50);
    DECLARE v_guardian_addr VARCHAR(100);
    
    -- Academic & Enrollment
    DECLARE v_former_school VARCHAR(100);
    DECLARE v_ple_idx VARCHAR(20);
    DECLARE v_ple_agg INT;
    DECLARE v_uce_idx VARCHAR(20);
    DECLARE v_uce_res VARCHAR(20);
    DECLARE v_adm_year INT DEFAULT 2025;
    DECLARE v_reg_year INT;
    DECLARE v_term VARCHAR(20);
    DECLARE v_residence VARCHAR(20);
    DECLARE v_entry_status VARCHAR(20);
    DECLARE v_more_info TEXT;

    -- ==========================================================
    -- START GENERATION
    -- ==========================================================
    
    -- 1. Loop Classes (PP1 to S6 -> 16 classes)
    SET c_idx = 1;
    WHILE c_idx <= 16 DO
        
        -- Determine Class and Level
        IF c_idx = 1 THEN SET v_class = 'PP1'; SET v_level = 'Pre-Primary';
        ELSEIF c_idx = 2 THEN SET v_class = 'PP2'; SET v_level = 'Pre-Primary';
        ELSEIF c_idx = 3 THEN SET v_class = 'PP3'; SET v_level = 'Pre-Primary';
        ELSEIF c_idx = 4 THEN SET v_class = 'P1'; SET v_level = 'Primary';
        ELSEIF c_idx = 5 THEN SET v_class = 'P2'; SET v_level = 'Primary';
        ELSEIF c_idx = 6 THEN SET v_class = 'P3'; SET v_level = 'Primary';
        ELSEIF c_idx = 7 THEN SET v_class = 'P4'; SET v_level = 'Primary';
        ELSEIF c_idx = 8 THEN SET v_class = 'P5'; SET v_level = 'Primary';
        ELSEIF c_idx = 9 THEN SET v_class = 'P6'; SET v_level = 'Primary';
        ELSEIF c_idx = 10 THEN SET v_class = 'P7'; SET v_level = 'Primary';
        ELSEIF c_idx = 11 THEN SET v_class = 'S1'; SET v_level = 'Secondary';
        ELSEIF c_idx = 12 THEN SET v_class = 'S2'; SET v_level = 'Secondary';
        ELSEIF c_idx = 13 THEN SET v_class = 'S3'; SET v_level = 'Secondary';
        ELSEIF c_idx = 14 THEN SET v_class = 'S4'; SET v_level = 'Secondary';
        ELSEIF c_idx = 15 THEN SET v_class = 'S5'; SET v_level = 'Secondary';
        ELSEIF c_idx = 16 THEN SET v_class = 'S6'; SET v_level = 'Secondary';
        END IF;

        -- 2. Loop Streams (A-E)
        SET s_idx = 1;
        WHILE s_idx <= 5 DO
            SET v_stream = ELT(s_idx, 'A', 'B', 'C', 'D', 'E');

            -- 3. Loop Students (20 per stream)
            SET stu_idx = 1;
            WHILE stu_idx <= v_max_students_per_stream DO
                
                -- --- GENERATE STUDENT INFO ---
                SET v_gender = IF(FLOOR(RAND()*2)=1, 'Male', 'Female');
                SET v_surname = ELT(FLOOR(1 + (RAND() * 19)), 'Kato', 'Mukasa', 'Okello', 'Akello', 'Namukasa', 'Musoke', 'Mugabe', 'Kyomuhendo', 'Nalubega', 'Ochieng', 'Lwanga', 'Nantogo', 'Opio', 'Aine', 'Busingye', 'Ssemwogerere', 'Nakato', 'Waiswa', 'Byaruhanga');
                
                IF v_gender = 'Male' THEN
                    SET v_name = ELT(FLOOR(1 + (RAND() * 15)), 'John', 'David', 'Moses', 'Isaac', 'Brian', 'Joseph', 'Paul', 'Ivan', 'Samuel', 'Daniel', 'Solomon', 'Timothy', 'Mark', 'Andrew', 'Peter');
                ELSE
                    SET v_name = ELT(FLOOR(1 + (RAND() * 15)), 'Mary', 'Sarah', 'Grace', 'Joy', 'Pritah', 'Esther', 'Joan', 'Sandra', 'Ritah', 'Mercy', 'Doreen', 'Rebecca', 'Alice', 'Brenda', 'Winnie');
                END IF;

                SET v_dob = DATE_ADD('2005-01-01', INTERVAL FLOOR(RAND() * 2190) DAY);
                SET v_address = ELT(FLOOR(1 + (RAND() * 14)), 'Kampala', 'Jinja', 'Gulu', 'Mbarara', 'Mbale', 'Entebbe', 'Mukono', 'Fort Portal', 'Arua', 'Kabale', 'Masaka', 'Lira', 'Soroti', 'Hoima');
                
                -- Photo Path: /assets/uploads/Class/Stream/Surname_Name_Rand.jpg
                SET v_photo_path = CONCAT('/assets/uploads/', v_class, '/', v_stream, '/', v_surname, '_', v_name, '_', FLOOR(RAND()*1000), '.jpg');

                -- INSERT STUDENT
                INSERT INTO students (AdmissionYear, Name, Surname, DateOfBirth, Gender, CurrentAddress, PhotoPath)
                VALUES (v_adm_year, v_name, v_surname, v_dob, v_gender, v_address, v_photo_path);
                
                SET v_student_id = LAST_INSERT_ID();

                -- --- GENERATE PARENTS INFO ---
                -- Father
                SET v_father_name = CONCAT(ELT(FLOOR(1 + (RAND() * 15)), 'John', 'David', 'Moses', 'Isaac', 'Brian', 'Joseph', 'Paul', 'Ivan', 'Samuel', 'Daniel', 'Solomon', 'Timothy', 'Mark', 'Andrew', 'Peter'), ' ', v_surname);
                SET v_father_contact = CONCAT('+2567', ELT(FLOOR(1 + (RAND() * 4)), '7', '0', '5', '8'), FLOOR(1000000 + (RAND() * 8999999)));
                SET v_father_age = FLOOR(35 + (RAND() * 30));
                SET v_father_occ = ELT(FLOOR(1 + (RAND() * 9)), 'Teacher', 'Farmer', 'Doctor', 'Engineer', 'Driver', 'Shopkeeper', 'Civil Servant', 'Carpenter', 'Mechanic');
                SET v_father_edu = ELT(FLOOR(1 + (RAND() * 5)), 'Primary', 'Secondary', 'Diploma', 'Bachelor’s Degree', 'Master’s Degree');

                -- Mother
                SET v_mother_name = CONCAT(ELT(FLOOR(1 + (RAND() * 15)), 'Mary', 'Sarah', 'Grace', 'Joy', 'Pritah', 'Esther', 'Joan', 'Sandra', 'Ritah', 'Mercy', 'Doreen', 'Rebecca', 'Alice', 'Brenda', 'Winnie'), ' ', ELT(FLOOR(1 + (RAND() * 19)), 'Kato', 'Mukasa', 'Okello', 'Akello', 'Namukasa', 'Musoke', 'Mugabe', 'Kyomuhendo', 'Nalubega', 'Ochieng', 'Lwanga', 'Nantogo', 'Opio', 'Aine', 'Busingye', 'Ssemwogerere', 'Nakato', 'Waiswa', 'Byaruhanga'));
                SET v_mother_contact = CONCAT('+2567', ELT(FLOOR(1 + (RAND() * 4)), '7', '0', '5', '8'), FLOOR(1000000 + (RAND() * 8999999)));
                SET v_mother_age = FLOOR(30 + (RAND() * 30));
                SET v_mother_occ = ELT(FLOOR(1 + (RAND() * 8)), 'Nurse', 'Farmer', 'Teacher', 'Tailor', 'Trader', 'Civil Servant', 'Housewife', 'Entrepreneur');
                SET v_mother_edu = ELT(FLOOR(1 + (RAND() * 5)), 'Primary', 'Secondary', 'Diploma', 'Bachelor’s Degree', 'Master’s Degree');

                -- Guardian (All or Nothing) - 40% Chance
                SET v_has_guardian = IF(RAND() > 0.6, 1, 0);
                
                IF v_has_guardian = 1 THEN
                    SET v_guardian_name = CONCAT(ELT(FLOOR(1 + (RAND() * 15)), 'John', 'David', 'Mary', 'Sarah', 'Moses', 'Grace', 'Isaac', 'Joy', 'Brian', 'Pritah', 'Joseph', 'Esther', 'Paul', 'Joan', 'Ivan'), ' ', v_surname);
                    SET v_guardian_contact = CONCAT('+2567', ELT(FLOOR(1 + (RAND() * 4)), '7', '0', '5', '8'), FLOOR(1000000 + (RAND() * 8999999)));
                    SET v_guardian_rel = ELT(FLOOR(1 + (RAND() * 6)), 'Brother', 'Sister', 'Uncle', 'Aunt', 'Grandparent', 'Other');
                    SET v_guardian_age = FLOOR(30 + (RAND() * 40));
                    SET v_guardian_occ = ELT(FLOOR(1 + (RAND() * 9)), 'Teacher', 'Farmer', 'Doctor', 'Engineer', 'Driver', 'Shopkeeper', 'Civil Servant', 'Carpenter', 'Mechanic');
                    SET v_guardian_addr = v_address; -- Same as student usually
                ELSE
                    SET v_guardian_name = NULL;
                    SET v_guardian_contact = NULL;
                    SET v_guardian_rel = NULL;
                    SET v_guardian_age = NULL;
                    SET v_guardian_occ = NULL;
                    SET v_guardian_addr = NULL;
                END IF;

                SET v_more_info = ELT(FLOOR(1 + (RAND() * 6)), 'Debate Club', 'Football Team', 'Choir', 'Prefect', 'Scout', 'None');

                -- INSERT PARENTS
                INSERT INTO parents (
                    StudentID, 
                    father_name, father_age, father_contact, father_occupation, father_education,
                    mother_name, mother_age, mother_contact, mother_occupation, mother_education,
                    guardian_name, guardian_relation, guardian_contact, guardian_age, guardian_occupation, guardian_address,
                    MoreInformation
                ) VALUES (
                    v_student_id,
                    v_father_name, v_father_age, v_father_contact, v_father_occ, v_father_edu,
                    v_mother_name, v_mother_age, v_mother_contact, v_mother_occ, v_mother_edu,
                    v_guardian_name, v_guardian_rel, v_guardian_contact, v_guardian_age, v_guardian_occ, v_guardian_addr,
                    v_more_info
                );

                -- --- ACADEMIC RECORDS ---
                SET v_former_school = CONCAT('School ', FLOOR(1 + (RAND() * 100)));
                
                IF v_level = 'Secondary' THEN
                    SET v_ple_agg = FLOOR(4 + (RAND() * 32));
                    SET v_ple_idx = CONCAT('00', FLOOR(1000 + (RAND() * 9000)), '/', FLOOR(10 + (RAND() * 999)));
                ELSE
                    SET v_ple_agg = NULL;
                    SET v_ple_idx = NULL;
                END IF;

                IF v_class = 'S5' OR v_class = 'S6' THEN
                    SET v_uce_idx = CONCAT('U', FLOOR(1000 + (RAND() * 9000)), '/', FLOOR(1 + (RAND() * 500)));
                    SET v_uce_res = CONCAT('Div ', FLOOR(1 + (RAND() * 4)));
                ELSE
                    SET v_uce_idx = NULL;
                    SET v_uce_res = NULL;
                END IF;

                INSERT INTO academichistory (StudentID, FormerSchool, PLEIndexNumber, PLEAggregate, UCEIndexNumber, UCEResult)
                VALUES (v_student_id, v_former_school, v_ple_idx, v_ple_agg, v_uce_idx, v_uce_res);

                -- --- ENROLLMENT ---
                SET v_reg_year = IF(RAND() > 0.5, 2025, 2026);
                SET v_term = ELT(FLOOR(1 + (RAND() * 3)), 'Term I', 'Term II', 'Term III');
                SET v_residence = IF(RAND() > 0.5, 'Boarding', 'Day');
                SET v_entry_status = IF(RAND() > 0.5, 'New', 'Continuing');

                INSERT INTO enrollment (StudentID, AcademicYear, Level, Class, Term, Stream, Residence, EntryStatus)
                VALUES (v_student_id, v_reg_year, v_level, v_class, v_term, v_stream, v_residence, v_entry_status);

                SET stu_idx = stu_idx + 1;
            END WHILE; -- End Student Loop

            SET s_idx = s_idx + 1;
        END WHILE; -- End Stream Loop

        SET c_idx = c_idx + 1;
    END WHILE; -- End Class Loop

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GenerateRandomStudentData` ()   BEGIN
    -- Loop Counters
    DECLARE c_idx INT DEFAULT 1; -- Class Index (1-16)
    DECLARE s_idx INT DEFAULT 1; -- Stream Index (1-5)
    DECLARE stu_idx INT DEFAULT 1; -- Student Index (1-6)
    
    -- Variables for Data
    DECLARE v_student_id INT;
    DECLARE v_class VARCHAR(50);
    DECLARE v_level VARCHAR(50);
    DECLARE v_stream VARCHAR(50);
    DECLARE v_gender VARCHAR(10);
    DECLARE v_surname VARCHAR(100);
    DECLARE v_name VARCHAR(100);
    DECLARE v_dob DATE;
    DECLARE v_address TEXT;
    
    -- Parent Variables
    DECLARE v_father_name VARCHAR(255);
    DECLARE v_mother_name VARCHAR(255);
    DECLARE v_guardian_rel VARCHAR(20);
    
    -- Academic Variables
    DECLARE v_ple_agg INT;
    DECLARE v_ple_idx VARCHAR(50);
    DECLARE v_uce_idx VARCHAR(50);
    DECLARE v_uce_res TEXT;

    -- =============================================
    -- START GENERATION LOOPS
    -- =============================================
    
    -- Loop 1: Classes (16 Classes: PP1-PP3, P1-P7, S1-S6)
    SET c_idx = 1;
    WHILE c_idx <= 16 DO
        
        -- Map Index to Class Name & Level
        IF c_idx = 1 THEN SET v_class = 'PP1'; SET v_level = 'Pre-Primary';
        ELSEIF c_idx = 2 THEN SET v_class = 'PP2'; SET v_level = 'Pre-Primary';
        ELSEIF c_idx = 3 THEN SET v_class = 'PP3'; SET v_level = 'Pre-Primary';
        ELSEIF c_idx = 4 THEN SET v_class = 'P1'; SET v_level = 'Primary';
        ELSEIF c_idx = 5 THEN SET v_class = 'P2'; SET v_level = 'Primary';
        ELSEIF c_idx = 6 THEN SET v_class = 'P3'; SET v_level = 'Primary';
        ELSEIF c_idx = 7 THEN SET v_class = 'P4'; SET v_level = 'Primary';
        ELSEIF c_idx = 8 THEN SET v_class = 'P5'; SET v_level = 'Primary';
        ELSEIF c_idx = 9 THEN SET v_class = 'P6'; SET v_level = 'Primary';
        ELSEIF c_idx = 10 THEN SET v_class = 'P7'; SET v_level = 'Primary';
        ELSEIF c_idx = 11 THEN SET v_class = 'S1'; SET v_level = 'Secondary';
        ELSEIF c_idx = 12 THEN SET v_class = 'S2'; SET v_level = 'Secondary';
        ELSEIF c_idx = 13 THEN SET v_class = 'S3'; SET v_level = 'Secondary';
        ELSEIF c_idx = 14 THEN SET v_class = 'S4'; SET v_level = 'Secondary';
        ELSEIF c_idx = 15 THEN SET v_class = 'S5'; SET v_level = 'Secondary';
        ELSEIF c_idx = 16 THEN SET v_class = 'S6'; SET v_level = 'Secondary';
        END IF;

        -- Loop 2: Streams (5 Streams: A, B, C, D, E)
        SET s_idx = 1;
        WHILE s_idx <= 5 DO
            SET v_stream = ELT(s_idx, 'A', 'B', 'C', 'D', 'E');

            -- Loop 3: Students (6 Students per Stream = 30 per Class)
            SET stu_idx = 1;
            WHILE stu_idx <= 6 DO
                
                -- A. Generate Basic Student Info
                SET v_gender = IF(FLOOR(RAND()*2)=1, 'Male', 'Female');
                SET v_surname = ELT(FLOOR(1 + (RAND() * 15)), 'Mukasa', 'Kato', 'Okello', 'Akello', 'Musoke', 'Namukasa', 'Ochieng', 'Lwanga', 'Mugabe', 'Nalubega', 'Kyomuhendo', 'Nantogo', 'Opio', 'Aine', 'Busingye');
                
                IF v_gender = 'Male' THEN
                    SET v_name = ELT(FLOOR(1 + (RAND() * 10)), 'John', 'David', 'Moses', 'Isaac', 'Brian', 'Joseph', 'Paul', 'Ivan', 'Samuel', 'Daniel');
                ELSE
                    SET v_name = ELT(FLOOR(1 + (RAND() * 10)), 'Mary', 'Sarah', 'Grace', 'Joy', 'Pritah', 'Esther', 'Joan', 'Sandra', 'Ritah', 'Mercy');
                END IF;

                SET v_dob = DATE_ADD('2005-01-01', INTERVAL FLOOR(RAND() * 2190) DAY);
                SET v_address = ELT(FLOOR(1 + (RAND() * 8)), 'Kawempe, Kampala', 'Nakawa, Kampala', 'Walukuba, Jinja', 'Layibi, Gulu', 'Kamukuzi, Mbarara', 'Entebbe', 'Mukono', 'Fort Portal');

                -- INSERT INTO students Table
                INSERT INTO students (AdmissionYear, Name, Surname, DateOfBirth, Gender, CurrentAddress, PhotoPath)
                VALUES (2025, v_name, v_surname, v_dob, v_gender, v_address, CONCAT('img/std/', v_class, '_', v_surname, '_', FLOOR(RAND()*1000), '.jpg'));
                
                SET v_student_id = LAST_INSERT_ID();

                -- B. Generate Parent Info
                SET v_father_name = CONCAT(ELT(FLOOR(1 + (RAND() * 10)), 'James', 'Peter', 'Francis', 'Bosco', 'Charles', 'Andrew', 'Patrick', 'Robert', 'Simon', 'Geoffrey'), ' ', v_surname);
                SET v_mother_name = CONCAT(ELT(FLOOR(1 + (RAND() * 10)), 'Betty', 'Susan', 'Hellen', 'Florence', 'Christine', 'Alice', 'Jennifer', 'Rose', 'Margaret', 'Lillian'), ' ', ELT(FLOOR(1 + (RAND() * 15)), 'Mukasa', 'Kato', 'Okello', 'Akello', 'Musoke', 'Namukasa', 'Ochieng', 'Lwanga', 'Mugabe', 'Nalubega', 'Kyomuhendo', 'Nantogo', 'Opio', 'Aine', 'Busingye'));
                
                -- Guardian Relation (Must match ENUM in your schema: 'Brother','Sister','Uncle','Aunt','Grandparent','Other')
                SET v_guardian_rel = ELT(FLOOR(1 + (RAND() * 6)), 'Uncle', 'Aunt', 'Grandparent', 'Brother', 'Sister', 'Other');

                -- INSERT INTO parents Table
                INSERT INTO parents (
                    StudentID, 
                    father_name, father_age, father_contact, father_occupation, father_education,
                    mother_name, mother_age, mother_contact, mother_occupation, mother_education,
                    guardian_name, guardian_relation, guardian_contact, guardian_occupation, guardian_address, MoreInformation
                ) VALUES (
                    v_student_id,
                    v_father_name, FLOOR(35 + (RAND() * 20)), CONCAT('+2567', FLOOR(10000000 + (RAND() * 89999999))), 
                    ELT(FLOOR(1 + (RAND() * 5)), 'Farmer', 'Teacher', 'Engineer', 'Doctor', 'Businessman'), 'Degree',
                    v_mother_name, FLOOR(30 + (RAND() * 20)), CONCAT('+2567', FLOOR(10000000 + (RAND() * 89999999))),
                    ELT(FLOOR(1 + (RAND() * 5)), 'Nurse', 'Teacher', 'Accountant', 'Businesswoman', 'Housewife'), 'Diploma',
                    -- Optional Guardian 30% chance
                    IF(RAND() > 0.7, CONCAT('G. ', v_surname), NULL),
                    IF(RAND() > 0.7, v_guardian_rel, NULL),
                    IF(RAND() > 0.7, CONCAT('+2567', FLOOR(10000000 + (RAND() * 89999999))), NULL),
                    IF(RAND() > 0.7, 'Trader', NULL),
                    IF(RAND() > 0.7, v_address, NULL),
                    ELT(FLOOR(1 + (RAND() * 4)), 'Prefect', 'Scout', 'Choir Member', 'Football Team')
                );

                -- C. Generate Academic History (Context aware)
                IF v_level = 'Secondary' THEN
                    SET v_ple_agg = FLOOR(4 + (RAND() * 20));
                    SET v_ple_idx = CONCAT('00', FLOOR(1000 + (RAND() * 9000)), '/', FLOOR(10 + (RAND() * 900)));
                ELSE
                    SET v_ple_agg = NULL;
                    SET v_ple_idx = NULL;
                END IF;

                IF v_class = 'S5' OR v_class = 'S6' THEN
                    SET v_uce_idx = CONCAT('U', FLOOR(1000 + (RAND() * 9000)), '/', FLOOR(001 + (RAND() * 500)));
                    SET v_uce_res = CONCAT('Division ', FLOOR(1 + (RAND() * 2)));
                ELSE
                    SET v_uce_idx = NULL;
                    SET v_uce_res = NULL;
                END IF;

                -- INSERT INTO academichistory Table
                INSERT INTO academichistory (StudentID, FormerSchool, PLEIndexNumber, PLEAggregate, UCEIndexNumber, UCEResult)
                VALUES (
                    v_student_id,
                    ELT(FLOOR(1 + (RAND() * 5)), 'Buddo Junior', 'Kampala Parents', 'Greenhill Academy', 'City Parents', 'Hillside Primary'),
                    v_ple_idx, v_ple_agg, v_uce_idx, v_uce_res
                );

                -- D. Generate Enrollment Record
                -- INSERT INTO enrollment Table
                INSERT INTO enrollment (StudentID, RegistrationYear, Level, Class, Term, Stream, Residence, EntryStatus)
                VALUES (
                    v_student_id,
                    2025,
                    v_level,
                    v_class,
                    'Term I',
                    v_stream,
                    IF(RAND() > 0.5, 'Boarding', 'Day'),
                    IF(v_class = 'P1' OR v_class = 'S1' OR v_class = 'S5', 'New', 'Continuing')
                );

                SET stu_idx = stu_idx + 1;
            END WHILE; -- End Student Loop

            SET s_idx = s_idx + 1;
        END WHILE; -- End Stream Loop

        SET c_idx = c_idx + 1;
    END WHILE; -- End Class Loop

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GenerateStrictStudentData` ()   BEGIN
    -- -------------------------------------------------------------------------
    -- 1. DECLARE VARIABLES
    -- -------------------------------------------------------------------------
    
    -- Loop Counters
    DECLARE c_idx INT DEFAULT 1;  -- Class Loop (1-16)
    DECLARE s_idx INT DEFAULT 1;  -- Stream Loop (1-5)
    DECLARE stu_idx INT DEFAULT 1; -- Student Loop (1-10)
    
    -- Student Variables
    DECLARE v_student_id INT;
    DECLARE v_class VARCHAR(10);
    DECLARE v_level VARCHAR(20);
    DECLARE v_stream VARCHAR(1);
    DECLARE v_gender VARCHAR(10);
    DECLARE v_surname VARCHAR(50);
    DECLARE v_name VARCHAR(50);
    DECLARE v_dob DATE;
    DECLARE v_address VARCHAR(100);
    DECLARE v_photo_path VARCHAR(255);
    
    -- Parent Variables
    DECLARE v_father_name VARCHAR(100);
    DECLARE v_father_contact VARCHAR(20);
    DECLARE v_father_age INT;
    DECLARE v_father_occ VARCHAR(50);
    DECLARE v_father_edu VARCHAR(50);
    
    DECLARE v_mother_name VARCHAR(100);
    DECLARE v_mother_contact VARCHAR(20);
    DECLARE v_mother_age INT;
    DECLARE v_mother_occ VARCHAR(50);
    DECLARE v_mother_edu VARCHAR(50);
    
    -- Guardian Variables (All or Nothing)
    DECLARE v_has_guardian INT;
    DECLARE v_guardian_name VARCHAR(100);
    DECLARE v_guardian_contact VARCHAR(20);
    DECLARE v_guardian_rel VARCHAR(20);
    DECLARE v_guardian_age INT;
    DECLARE v_guardian_occ VARCHAR(50);
    DECLARE v_guardian_edu VARCHAR(50);
    DECLARE v_guardian_addr VARCHAR(100);
    
    -- Academic & Enrollment Variables
    DECLARE v_former_school VARCHAR(100);
    DECLARE v_ple_idx VARCHAR(30);
    DECLARE v_ple_agg INT;
    DECLARE v_uce_idx VARCHAR(30);
    DECLARE v_uce_res VARCHAR(20);
    DECLARE v_reg_year INT;
    DECLARE v_term VARCHAR(20);
    DECLARE v_residence VARCHAR(20);
    DECLARE v_entry_status VARCHAR(20);
    DECLARE v_more_info TEXT;

    -- -------------------------------------------------------------------------
    -- 2. START GENERATION LOOPS
    -- -------------------------------------------------------------------------
    
    -- LOOP 1: Classes (16 Total: PP1-PP3, P1-P7, S1-S6)
    SET c_idx = 1;
    WHILE c_idx <= 16 DO
        
        -- Determine Class Name & Level
        IF c_idx = 1 THEN SET v_class = 'PP1'; SET v_level = 'Pre-Primary';
        ELSEIF c_idx = 2 THEN SET v_class = 'PP2'; SET v_level = 'Pre-Primary';
        ELSEIF c_idx = 3 THEN SET v_class = 'PP3'; SET v_level = 'Pre-Primary';
        ELSEIF c_idx = 4 THEN SET v_class = 'P1'; SET v_level = 'Primary';
        ELSEIF c_idx = 5 THEN SET v_class = 'P2'; SET v_level = 'Primary';
        ELSEIF c_idx = 6 THEN SET v_class = 'P3'; SET v_level = 'Primary';
        ELSEIF c_idx = 7 THEN SET v_class = 'P4'; SET v_level = 'Primary';
        ELSEIF c_idx = 8 THEN SET v_class = 'P5'; SET v_level = 'Primary';
        ELSEIF c_idx = 9 THEN SET v_class = 'P6'; SET v_level = 'Primary';
        ELSEIF c_idx = 10 THEN SET v_class = 'P7'; SET v_level = 'Primary';
        ELSEIF c_idx = 11 THEN SET v_class = 'S1'; SET v_level = 'Secondary';
        ELSEIF c_idx = 12 THEN SET v_class = 'S2'; SET v_level = 'Secondary';
        ELSEIF c_idx = 13 THEN SET v_class = 'S3'; SET v_level = 'Secondary';
        ELSEIF c_idx = 14 THEN SET v_class = 'S4'; SET v_level = 'Secondary';
        ELSEIF c_idx = 15 THEN SET v_class = 'S5'; SET v_level = 'Secondary';
        ELSEIF c_idx = 16 THEN SET v_class = 'S6'; SET v_level = 'Secondary';
        END IF;

        -- LOOP 2: Streams (5 Streams: A, B, C, D, E)
        SET s_idx = 1;
        WHILE s_idx <= 5 DO
            SET v_stream = ELT(s_idx, 'A', 'B', 'C', 'D', 'E');

            -- LOOP 3: Students (Strictly 10 per stream = 50 per class)
            SET stu_idx = 1;
            WHILE stu_idx <= 10 DO
                
                -- A. GENERATE STUDENT IDENTITY
                SET v_gender = IF(FLOOR(RAND()*2)=1, 'Male', 'Female');
                SET v_surname = ELT(FLOOR(1 + (RAND() * 20)), 'Kato', 'Mukasa', 'Okello', 'Akello', 'Namukasa', 'Musoke', 'Mugabe', 'Kyomuhendo', 'Nalubega', 'Ochieng', 'Lwanga', 'Nantogo', 'Opio', 'Aine', 'Busingye', 'Ssemwogerere', 'Nakato', 'Waiswa', 'Byaruhanga', 'Tumusiime');
                
                IF v_gender = 'Male' THEN
                    SET v_name = ELT(FLOOR(1 + (RAND() * 15)), 'John', 'David', 'Moses', 'Isaac', 'Brian', 'Joseph', 'Paul', 'Ivan', 'Samuel', 'Daniel', 'Solomon', 'Timothy', 'Mark', 'Andrew', 'Peter');
                ELSE
                    SET v_name = ELT(FLOOR(1 + (RAND() * 15)), 'Mary', 'Sarah', 'Grace', 'Joy', 'Pritah', 'Esther', 'Joan', 'Sandra', 'Ritah', 'Mercy', 'Doreen', 'Rebecca', 'Alice', 'Brenda', 'Winnie');
                END IF;

                SET v_dob = DATE_ADD('2005-01-01', INTERVAL FLOOR(RAND() * 2190) DAY);
                SET v_address = ELT(FLOOR(1 + (RAND() * 10)), 'Kampala', 'Gulu', 'Mbarara', 'Mbale', 'Arua', 'Jinja', 'Fort Portal', 'Masaka', 'Soroti', 'Lira');
                
                -- Photo Path (Strict format: uploads/Class/Stream/Surname_Name.jpg)
                SET v_photo_path = CONCAT('uploads/', v_class, '/', v_stream, '/', v_surname, '_', v_name, '.jpg');

                -- INSERT INTO students
                INSERT INTO students (AdmissionYear, Name, Surname, DateOfBirth, Gender, CurrentAddress, PhotoPath)
                VALUES (2025, v_name, v_surname, v_dob, v_gender, v_address, v_photo_path);
                
                SET v_student_id = LAST_INSERT_ID();

                -- B. GENERATE PARENTS (Mandatory)
                -- Father
                SET v_father_name = CONCAT(ELT(FLOOR(1 + (RAND() * 15)), 'John', 'David', 'Moses', 'Isaac', 'Brian', 'Joseph', 'Paul', 'Ivan', 'Samuel', 'Daniel', 'Solomon', 'Timothy', 'Mark', 'Andrew', 'Peter'), ' ', v_surname);
                SET v_father_contact = CONCAT('+2567', ELT(FLOOR(1 + (RAND() * 4)), '7', '0', '5', '8'), FLOOR(1000000 + (RAND() * 8999999)));
                SET v_father_age = FLOOR(30 + (RAND() * 40));
                SET v_father_occ = ELT(FLOOR(1 + (RAND() * 9)), 'Teacher', 'Farmer', 'Doctor', 'Engineer', 'Driver', 'Shopkeeper', 'Civil Servant', 'Carpenter', 'Mechanic');
                SET v_father_edu = ELT(FLOOR(1 + (RAND() * 5)), 'Primary', 'Secondary', 'Diploma', 'Bachelor’s Degree', 'Master’s Degree');

                -- Mother
                SET v_mother_name = CONCAT(ELT(FLOOR(1 + (RAND() * 15)), 'Mary', 'Sarah', 'Grace', 'Joy', 'Pritah', 'Esther', 'Joan', 'Sandra', 'Ritah', 'Mercy', 'Doreen', 'Rebecca', 'Alice', 'Brenda', 'Winnie'), ' ', ELT(FLOOR(1 + (RAND() * 20)), 'Kato', 'Mukasa', 'Okello', 'Akello', 'Namukasa', 'Musoke', 'Mugabe', 'Kyomuhendo', 'Nalubega', 'Ochieng', 'Lwanga', 'Nantogo', 'Opio', 'Aine', 'Busingye', 'Ssemwogerere', 'Nakato', 'Waiswa', 'Byaruhanga', 'Tumusiime'));
                SET v_mother_contact = CONCAT('+2567', ELT(FLOOR(1 + (RAND() * 4)), '7', '0', '5', '8'), FLOOR(1000000 + (RAND() * 8999999)));
                SET v_mother_age = FLOOR(28 + (RAND() * 37));
                SET v_mother_occ = ELT(FLOOR(1 + (RAND() * 8)), 'Nurse', 'Farmer', 'Teacher', 'Tailor', 'Trader', 'Civil Servant', 'Housewife', 'Entrepreneur');
                SET v_mother_edu = ELT(FLOOR(1 + (RAND() * 5)), 'Primary', 'Secondary', 'Diploma', 'Bachelor’s Degree', 'Master’s Degree');

                -- C. GUARDIAN (All or Nothing Rule)
                -- 30% chance of having a guardian
                IF RAND() > 0.7 THEN
                    SET v_guardian_name = CONCAT(ELT(FLOOR(1 + (RAND() * 10)), 'James', 'Charles', 'Patrick', 'Robert', 'Susan', 'Hellen', 'Florence', 'Alice', 'Rose', 'Lillian'), ' ', v_surname);
                    SET v_guardian_contact = CONCAT('+2567', ELT(FLOOR(1 + (RAND() * 4)), '7', '0', '5', '8'), FLOOR(1000000 + (RAND() * 8999999)));
                    SET v_guardian_rel = ELT(FLOOR(1 + (RAND() * 6)), 'Father', 'Mother', 'Uncle', 'Aunt', 'Grandparent', 'Other');
                    SET v_guardian_age = FLOOR(25 + (RAND() * 55));
                    SET v_guardian_occ = 'Civil Servant'; -- Simplified for random
                    SET v_guardian_edu = 'Diploma';
                    SET v_guardian_addr = v_address;
                ELSE
                    -- STRICTLY NULL if no guardian
                    SET v_guardian_name = NULL;
                    SET v_guardian_contact = NULL;
                    SET v_guardian_rel = NULL;
                    SET v_guardian_age = NULL;
                    SET v_guardian_occ = NULL;
                    SET v_guardian_edu = NULL;
                    SET v_guardian_addr = NULL;
                END IF;

                SET v_more_info = ELT(FLOOR(1 + (RAND() * 6)), 'Active in debate club', 'Prefect', 'Choir member', 'Football team', 'Science fair participant', 'None');

                -- INSERT INTO parents
                INSERT INTO parents (
                    StudentID, 
                    father_name, father_age, father_contact, father_occupation, father_education,
                    mother_name, mother_age, mother_contact, mother_occupation, mother_education,
                    guardian_name, guardian_relation, guardian_contact, guardian_age, guardian_occupation, guardian_education, guardian_address,
                    MoreInformation
                ) VALUES (
                    v_student_id,
                    v_father_name, v_father_age, v_father_contact, v_father_occ, v_father_edu,
                    v_mother_name, v_mother_age, v_mother_contact, v_mother_occ, v_mother_edu,
                    v_guardian_name, v_guardian_rel, v_guardian_contact, v_guardian_age, v_guardian_occ, v_guardian_edu, v_guardian_addr,
                    v_more_info
                );

                -- D. ACADEMIC RECORDS (Logic for PLE/UCE)
                SET v_former_school = ELT(FLOOR(1 + (RAND() * 7)), 'Namilyango College', 'Gayaza High School', 'St. Mary’s Kitende', 'Ntare School', 'Gulu High School', 'Jinja SS', 'Buddo S.S.');
                
                -- PLE only for Secondary
                IF v_level = 'Secondary' THEN
                    SET v_ple_agg = FLOOR(4 + (RAND() * 32));
                    SET v_ple_idx = CONCAT('PLE/UG/', FLOOR(10 + (RAND() * 15)), '/', FLOOR(10000 + (RAND() * 89999)));
                ELSE
                    SET v_ple_agg = NULL;
                    SET v_ple_idx = NULL;
                END IF;

                -- UCE only for A-Level (S5, S6)
                IF v_class = 'S5' OR v_class = 'S6' THEN
                    SET v_uce_idx = CONCAT('UCE/UG/', FLOOR(10 + (RAND() * 15)), '/', FLOOR(10000 + (RAND() * 89999)));
                    SET v_uce_res = ELT(FLOOR(1 + (RAND() * 4)), 'Division I', 'Division II', 'Division III', 'Division IV');
                ELSE
                    SET v_uce_idx = NULL;
                    SET v_uce_res = NULL;
                END IF;

                INSERT INTO academichistory (StudentID, FormerSchool, PLEIndexNumber, PLEAggregate, UCEIndexNumber, UCEResult)
                VALUES (v_student_id, v_former_school, v_ple_idx, v_ple_agg, v_uce_idx, v_uce_res);

                -- E. ENROLLMENT (Strict Allocation)
                SET v_reg_year = IF(RAND() > 0.5, 2025, 2026);
                SET v_term = ELT(FLOOR(1 + (RAND() * 3)), 'Term I', 'Term II', 'Term III');
                SET v_residence = IF(RAND() > 0.5, 'Boarding', 'Day');
                SET v_entry_status = IF(RAND() > 0.5, 'New', 'Continuing');

                INSERT INTO enrollment (StudentID, AcademicYear, Level, Class, Term, Stream, Residence, EntryStatus)
                VALUES (v_student_id, v_reg_year, v_level, v_class, v_term, v_stream, v_residence, v_entry_status);

                SET stu_idx = stu_idx + 1;
            END WHILE; -- End Student Loop

            SET s_idx = s_idx + 1;
        END WHILE; -- End Stream Loop

        SET c_idx = c_idx + 1;
    END WHILE; -- End Class Loop

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GenerateStrictUgandanData` ()   BEGIN
    -- =========================================================================
    -- 1. VARIABLE DECLARATION
    -- =========================================================================
    
    -- Loop Counters for Setup
    DECLARE c_idx INT DEFAULT 1;
    DECLARE s_idx INT DEFAULT 1;
    DECLARE stu_idx INT DEFAULT 1;
    
    -- Cursor Variables
    DECLARE done INT DEFAULT FALSE;
    DECLARE cur_level VARCHAR(20);
    DECLARE cur_class VARCHAR(10);
    DECLARE cur_stream VARCHAR(1);
    
    -- Student Data
    DECLARE v_student_id INT;
    DECLARE v_gender VARCHAR(10);
    DECLARE v_surname VARCHAR(50);
    DECLARE v_name VARCHAR(50);
    DECLARE v_dob DATE;
    DECLARE v_address VARCHAR(100);
    DECLARE v_photo VARCHAR(255);
    
    -- Parent Data
    DECLARE v_father_name VARCHAR(100);
    DECLARE v_father_contact VARCHAR(20);
    DECLARE v_father_age INT;
    DECLARE v_father_occ VARCHAR(50);
    DECLARE v_father_edu VARCHAR(50);
    
    DECLARE v_mother_name VARCHAR(100);
    DECLARE v_mother_contact VARCHAR(20);
    DECLARE v_mother_age INT;
    DECLARE v_mother_occ VARCHAR(50);
    DECLARE v_mother_edu VARCHAR(50);
    
    -- Guardian Data
    DECLARE v_has_guardian INT;
    DECLARE v_guardian_name VARCHAR(100);
    DECLARE v_guardian_contact VARCHAR(20);
    DECLARE v_guardian_rel VARCHAR(20);
    DECLARE v_guardian_age INT;
    DECLARE v_guardian_occ VARCHAR(50);
    DECLARE v_guardian_edu VARCHAR(50);
    DECLARE v_guardian_addr VARCHAR(100);
    
    -- Academic & Enrollment
    DECLARE v_former_school VARCHAR(100);
    DECLARE v_ple_idx VARCHAR(50);
    DECLARE v_ple_agg INT;
    DECLARE v_uce_idx VARCHAR(50);
    DECLARE v_uce_res VARCHAR(20);
    DECLARE v_adm_year INT;
    DECLARE v_academic_year VARCHAR(20) DEFAULT '2025-26';
    DECLARE v_term VARCHAR(20);
    DECLARE v_residence VARCHAR(20);
    DECLARE v_entry_status VARCHAR(20);
    DECLARE v_more_info TEXT;

    -- Helper Variables for Setup
    DECLARE v_temp_class VARCHAR(10);
    DECLARE v_temp_level VARCHAR(20);
    DECLARE v_temp_stream VARCHAR(1);

    -- Cursor Definition (The Magic: Select Randomly from the Queue)
    DECLARE admission_cursor CURSOR FOR 
        SELECT t_level, t_class, t_stream 
        FROM temp_admission_queue 
        ORDER BY RAND();
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    -- =========================================================================
    -- 2. SETUP: BUILD ADMISSION QUEUE (Strict Quotas)
    -- =========================================================================
    
    -- Create a temporary table to hold the slots
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_admission_queue (
        id INT AUTO_INCREMENT PRIMARY KEY,
        t_level VARCHAR(20),
        t_class VARCHAR(10),
        t_stream VARCHAR(1)
    );
    
    TRUNCATE TABLE temp_admission_queue;

    -- Fill Queue: 16 Classes * 5 Streams * 10 Students = 800 Slots
    SET c_idx = 1;
    WHILE c_idx <= 16 DO
        -- Map Index to Class/Level
        IF c_idx = 1 THEN SET v_temp_class = 'PP.1'; SET v_temp_level = 'Pre-Primary';
        ELSEIF c_idx = 2 THEN SET v_temp_class = 'PP.2'; SET v_temp_level = 'Pre-Primary';
        ELSEIF c_idx = 3 THEN SET v_temp_class = 'PP.3'; SET v_temp_level = 'Pre-Primary';
        ELSEIF c_idx = 4 THEN SET v_temp_class = 'P.1'; SET v_temp_level = 'Primary';
        ELSEIF c_idx = 5 THEN SET v_temp_class = 'P.2'; SET v_temp_level = 'Primary';
        ELSEIF c_idx = 6 THEN SET v_temp_class = 'P.3'; SET v_temp_level = 'Primary';
        ELSEIF c_idx = 7 THEN SET v_temp_class = 'P.4'; SET v_temp_level = 'Primary';
        ELSEIF c_idx = 8 THEN SET v_temp_class = 'P.5'; SET v_temp_level = 'Primary';
        ELSEIF c_idx = 9 THEN SET v_temp_class = 'P.6'; SET v_temp_level = 'Primary';
        ELSEIF c_idx = 10 THEN SET v_temp_class = 'P.7'; SET v_temp_level = 'Primary';
        ELSEIF c_idx = 11 THEN SET v_temp_class = 'S.1'; SET v_temp_level = 'Secondary';
        ELSEIF c_idx = 12 THEN SET v_temp_class = 'S.2'; SET v_temp_level = 'Secondary';
        ELSEIF c_idx = 13 THEN SET v_temp_class = 'S.3'; SET v_temp_level = 'Secondary';
        ELSEIF c_idx = 14 THEN SET v_temp_class = 'S.4'; SET v_temp_level = 'Secondary';
        ELSEIF c_idx = 15 THEN SET v_temp_class = 'S.5'; SET v_temp_level = 'Secondary';
        ELSEIF c_idx = 16 THEN SET v_temp_class = 'S.6'; SET v_temp_level = 'Secondary';
        END IF;

        SET s_idx = 1;
        WHILE s_idx <= 5 DO
            SET v_temp_stream = ELT(s_idx, 'A', 'B', 'C', 'D', 'E');
            
            SET stu_idx = 1;
            WHILE stu_idx <= 10 DO
                INSERT INTO temp_admission_queue (t_level, t_class, t_stream) 
                VALUES (v_temp_level, v_temp_class, v_temp_stream);
                SET stu_idx = stu_idx + 1;
            END WHILE;
            
            SET s_idx = s_idx + 1;
        END WHILE;
        
        SET c_idx = c_idx + 1;
    END WHILE;

    -- =========================================================================
    -- 3. EXECUTION: PROCESS QUEUE RANDOMLY
    -- =========================================================================
    
    OPEN admission_cursor;
    
    read_loop: LOOP
        FETCH admission_cursor INTO cur_level, cur_class, cur_stream;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- ---------------------------------------------------------
        -- GENERATE RANDOM DATA FOR THIS SLOT
        -- ---------------------------------------------------------
        
        -- ADMISSION YEAR (2024 or 2025)
        SET v_adm_year = FLOOR(2024 + (RAND() * 2));

        -- STUDENT IDENTITY
        SET v_gender = IF(FLOOR(RAND()*2)=1, 'Male', 'Female');
        SET v_surname = ELT(FLOOR(1 + (RAND() * 20)), 'Kato', 'Mukasa', 'Okello', 'Akello', 'Namukasa', 'Musoke', 'Mugabe', 'Kyomuhendo', 'Nalubega', 'Ochieng', 'Lwanga', 'Nantogo', 'Opio', 'Aine', 'Busingye', 'Ssemwogerere', 'Nakato', 'Waiswa', 'Byaruhanga', 'Tumusiime');
        
        IF v_gender = 'Male' THEN
            SET v_name = ELT(FLOOR(1 + (RAND() * 15)), 'John', 'David', 'Moses', 'Isaac', 'Brian', 'Joseph', 'Paul', 'Ivan', 'Samuel', 'Daniel', 'Solomon', 'Timothy', 'Mark', 'Andrew', 'Peter');
        ELSE
            SET v_name = ELT(FLOOR(1 + (RAND() * 15)), 'Mary', 'Sarah', 'Grace', 'Joy', 'Pritah', 'Esther', 'Joan', 'Sandra', 'Ritah', 'Mercy', 'Doreen', 'Rebecca', 'Alice', 'Brenda', 'Winnie');
        END IF;

        SET v_dob = DATE_ADD('2005-01-01', INTERVAL FLOOR(RAND() * 1825) DAY); 
        SET v_address = ELT(FLOOR(1 + (RAND() * 10)), 'Kampala', 'Gulu', 'Mbale', 'Jinja', 'Mbarara', 'Arua', 'Fort Portal', 'Masaka', 'Soroti', 'Lira');
        SET v_photo = 'static/images/default_profile.png'; 

        -- INSERT STUDENT
        INSERT INTO students (AdmissionYear, Name, Surname, DateOfBirth, Gender, CurrentAddress, PhotoPath)
        VALUES (v_adm_year, v_name, v_surname, v_dob, v_gender, v_address, v_photo);
        
        SET v_student_id = LAST_INSERT_ID();

        -- PARENT DETAILS
        SET v_father_name = CONCAT(ELT(FLOOR(1 + (RAND() * 15)), 'John', 'David', 'Moses', 'Isaac', 'Brian', 'Joseph', 'Paul', 'Ivan', 'Samuel', 'Daniel', 'Solomon', 'Timothy', 'Mark', 'Andrew', 'Peter'), ' ', v_surname);
        SET v_father_contact = CONCAT('+2567', ELT(FLOOR(1 + (RAND() * 4)), '7', '0', '5', '8'), FLOOR(1000000 + (RAND() * 8999999)));
        SET v_father_age = FLOOR(30 + (RAND() * 40));
        SET v_father_occ = ELT(FLOOR(1 + (RAND() * 9)), 'Teacher', 'Farmer', 'Doctor', 'Engineer', 'Driver', 'Shopkeeper', 'Civil Servant', 'Carpenter', 'Mechanic');
        SET v_father_edu = ELT(FLOOR(1 + (RAND() * 5)), 'Primary', 'Secondary', 'Diploma', 'Bachelor’s Degree', 'Master’s Degree');

        SET v_mother_name = CONCAT(ELT(FLOOR(1 + (RAND() * 15)), 'Mary', 'Sarah', 'Grace', 'Joy', 'Pritah', 'Esther', 'Joan', 'Sandra', 'Ritah', 'Mercy', 'Doreen', 'Rebecca', 'Alice', 'Brenda', 'Winnie'), ' ', ELT(FLOOR(1 + (RAND() * 20)), 'Kato', 'Mukasa', 'Okello', 'Akello', 'Namukasa', 'Musoke', 'Mugabe', 'Kyomuhendo', 'Nalubega', 'Ochieng', 'Lwanga', 'Nantogo', 'Opio', 'Aine', 'Busingye', 'Ssemwogerere', 'Nakato', 'Waiswa', 'Byaruhanga', 'Tumusiime'));
        SET v_mother_contact = CONCAT('+2567', ELT(FLOOR(1 + (RAND() * 4)), '7', '0', '5', '8'), FLOOR(1000000 + (RAND() * 8999999)));
        SET v_mother_age = FLOOR(28 + (RAND() * 37));
        SET v_mother_occ = ELT(FLOOR(1 + (RAND() * 8)), 'Nurse', 'Farmer', 'Teacher', 'Tailor', 'Trader', 'Civil Servant', 'Housewife', 'Entrepreneur');
        SET v_mother_edu = ELT(FLOOR(1 + (RAND() * 5)), 'Primary', 'Secondary', 'Diploma', 'Bachelor’s Degree', 'Master’s Degree');

        -- GUARDIAN
        IF RAND() < 0.3 THEN
            SET v_guardian_name = CONCAT(ELT(FLOOR(1 + (RAND() * 10)), 'James', 'Charles', 'Patrick', 'Robert', 'Susan', 'Hellen', 'Florence', 'Alice', 'Rose', 'Lillian'), ' ', v_surname);
            SET v_guardian_contact = CONCAT('+2567', ELT(FLOOR(1 + (RAND() * 4)), '7', '0', '5', '8'), FLOOR(1000000 + (RAND() * 8999999)));
            SET v_guardian_rel = ELT(FLOOR(1 + (RAND() * 6)), 'Father', 'Mother', 'Uncle', 'Aunt', 'Grandparent', 'Other');
            SET v_guardian_age = FLOOR(25 + (RAND() * 55));
            SET v_guardian_occ = ELT(FLOOR(1 + (RAND() * 9)), 'Teacher', 'Farmer', 'Doctor', 'Engineer', 'Driver', 'Shopkeeper', 'Civil Servant', 'Carpenter', 'Mechanic');
            SET v_guardian_edu = ELT(FLOOR(1 + (RAND() * 5)), 'Primary', 'Secondary', 'Diploma', 'Bachelor’s Degree', 'Master’s Degree');
            SET v_guardian_addr = v_address;
        ELSE
            SET v_guardian_name = NULL; SET v_guardian_contact = NULL; SET v_guardian_rel = NULL;
            SET v_guardian_age = NULL; SET v_guardian_occ = NULL; SET v_guardian_edu = NULL; SET v_guardian_addr = NULL;
        END IF;

        SET v_more_info = ELT(FLOOR(1 + (RAND() * 5)), 'Active in debate club', 'Prefect', 'Choir member', 'Football team', 'Science fair participant');

        INSERT INTO parents (StudentID, father_name, father_age, father_contact, father_occupation, father_education, mother_name, mother_age, mother_contact, mother_occupation, mother_education, guardian_name, guardian_relation, guardian_contact, guardian_age, guardian_occupation, guardian_education, guardian_address, MoreInformation)
        VALUES (v_student_id, v_father_name, v_father_age, v_father_contact, v_father_occ, v_father_edu, v_mother_name, v_mother_age, v_mother_contact, v_mother_occ, v_mother_edu, v_guardian_name, v_guardian_rel, v_guardian_contact, v_guardian_age, v_guardian_occ, v_guardian_edu, v_guardian_addr, v_more_info);

        -- ACADEMIC RECORDS
        SET v_former_school = ELT(FLOOR(1 + (RAND() * 5)), 'Namilyango School', 'Gayaza High School', 'Ntare School', 'Buddo Junior', 'Greenhill Academy');
        SET v_ple_idx = CONCAT('PLE/UG/20', FLOOR(10 + (RAND() * 14)), '/', LPAD(FLOOR(RAND() * 100000), 5, '0'));
        SET v_ple_agg = FLOOR(4 + (RAND() * 32));
        SET v_uce_idx = CONCAT('UCE/UG/20', FLOOR(10 + (RAND() * 14)), '/', LPAD(FLOOR(RAND() * 100000), 5, '0'));
        SET v_uce_res = ELT(FLOOR(1 + (RAND() * 4)), 'Division I', 'Division II', 'Division III', 'Division IV');

        INSERT INTO academichistory (StudentID, FormerSchool, PLEIndexNumber, PLEAggregate, UCEIndexNumber, UCEResult)
        VALUES (v_student_id, v_former_school, v_ple_idx, v_ple_agg, v_uce_idx, v_uce_res);

        -- ENROLLMENT (Using Cursor Data)
        SET v_term = ELT(FLOOR(1 + (RAND() * 3)), 'Term 1', 'Term 2', 'Term 3');
        SET v_residence = IF(RAND() > 0.5, 'Boarding', 'Day');
        SET v_entry_status = IF(cur_class = 'P.1' OR cur_class = 'S.1' OR cur_class = 'PP.1', 'New', 'Continuing');

        INSERT INTO enrollment (StudentID, AcademicYear, Level, Class, Term, Stream, Residence, EntryStatus)
        VALUES (v_student_id, v_academic_year, cur_level, cur_class, v_term, cur_stream, v_residence, v_entry_status);

    END LOOP;

    CLOSE admission_cursor;
    
    -- Cleanup
    DROP TEMPORARY TABLE IF EXISTS temp_admission_queue;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `academichistory`
--

CREATE TABLE `academichistory` (
  `HistoryID` int(11) NOT NULL,
  `StudentID` int(11) NOT NULL,
  `FormerSchool` varchar(255) DEFAULT NULL,
  `PLEIndexNumber` varchar(50) DEFAULT NULL,
  `PLEAggregate` int(11) DEFAULT NULL,
  `UCEIndexNumber` varchar(50) DEFAULT NULL,
  `UCEResult` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `academichistory`
--

INSERT INTO `academichistory` (`HistoryID`, `StudentID`, `FormerSchool`, `PLEIndexNumber`, `PLEAggregate`, `UCEIndexNumber`, `UCEResult`) VALUES
(1, 1, 'Buddo Junior', 'PLE/UG/2016/19458', 23, 'UCE/UG/2016/53030', 'Division I'),
(2, 2, 'Namilyango School', 'PLE/UG/2012/47882', 30, 'UCE/UG/2020/16169', 'Division III'),
(3, 3, 'Ntare School', 'PLE/UG/2020/32828', 16, 'UCE/UG/2022/40887', 'Division II'),
(4, 4, 'Ntare School', 'PLE/UG/2013/84904', 21, 'UCE/UG/2012/39134', 'Division II'),
(5, 5, 'Namilyango School', 'PLE/UG/2012/37394', 15, 'UCE/UG/2019/20883', 'Division I'),
(6, 6, 'Ntare School', 'PLE/UG/2013/77939', 10, 'UCE/UG/2018/52203', 'Division IV'),
(7, 7, 'Gayaza High School', 'PLE/UG/2023/99573', 10, 'UCE/UG/2023/23884', 'Division II'),
(8, 8, 'Gayaza High School', 'PLE/UG/2015/93200', 17, 'UCE/UG/2014/34247', 'Division III'),
(9, 9, 'Greenhill Academy', 'PLE/UG/2013/40160', 14, 'UCE/UG/2016/42389', 'Division III'),
(10, 10, 'Ntare School', 'PLE/UG/2017/39296', 12, 'UCE/UG/2011/64541', 'Division IV'),
(11, 11, 'Buddo Junior', 'PLE/UG/2015/85070', 8, 'UCE/UG/2012/36850', 'Division II'),
(12, 12, 'Greenhill Academy', 'PLE/UG/2016/82618', 28, 'UCE/UG/2015/53406', 'Division III'),
(13, 13, 'Greenhill Academy', 'PLE/UG/2018/43897', 12, 'UCE/UG/2010/39151', 'Division IV'),
(14, 14, 'Ntare School', 'PLE/UG/2016/84189', 31, 'UCE/UG/2021/39141', 'Division III'),
(15, 15, 'Gayaza High School', 'PLE/UG/2014/77607', 32, 'UCE/UG/2011/72042', 'Division II'),
(16, 16, 'Ntare School', 'PLE/UG/2016/57795', 21, 'UCE/UG/2023/33045', 'Division III'),
(17, 17, 'Namilyango School', 'PLE/UG/2013/95846', 5, 'UCE/UG/2015/66174', 'Division I'),
(18, 18, 'Gayaza High School', 'PLE/UG/2012/91184', 6, 'UCE/UG/2018/76173', 'Division I'),
(19, 19, 'Gayaza High School', 'PLE/UG/2015/85218', 5, 'UCE/UG/2020/43297', 'Division I'),
(20, 20, 'Buddo Junior', 'PLE/UG/2021/01359', 22, 'UCE/UG/2021/38877', 'Division II'),
(21, 21, 'Gayaza High School', 'PLE/UG/2023/74196', 33, 'UCE/UG/2014/97133', 'Division IV'),
(22, 22, 'Namilyango School', 'PLE/UG/2019/95972', 28, 'UCE/UG/2023/57163', 'Division IV'),
(23, 23, 'Greenhill Academy', 'PLE/UG/2021/53068', 9, 'UCE/UG/2013/83767', 'Division II'),
(24, 24, 'Gayaza High School', 'PLE/UG/2023/26717', 16, 'UCE/UG/2012/84346', 'Division III'),
(25, 25, 'Gayaza High School', 'PLE/UG/2019/23458', 9, 'UCE/UG/2012/24805', 'Division IV'),
(26, 26, 'Buddo Junior', 'PLE/UG/2017/51143', 34, 'UCE/UG/2012/00438', 'Division III'),
(27, 27, 'Gayaza High School', 'PLE/UG/2011/50702', 8, 'UCE/UG/2012/36416', 'Division II'),
(28, 28, 'Namilyango School', 'PLE/UG/2014/06130', 18, 'UCE/UG/2010/78743', 'Division IV'),
(29, 29, 'Greenhill Academy', 'PLE/UG/2011/66473', 4, 'UCE/UG/2012/63644', 'Division IV'),
(30, 30, 'Namilyango School', 'PLE/UG/2014/94993', 31, 'UCE/UG/2016/67480', 'Division I'),
(31, 31, 'Namilyango School', 'PLE/UG/2014/28906', 18, 'UCE/UG/2015/76026', 'Division III'),
(32, 32, 'Buddo Junior', 'PLE/UG/2017/32203', 35, 'UCE/UG/2023/77234', 'Division I'),
(33, 33, 'Ntare School', 'PLE/UG/2010/42407', 35, 'UCE/UG/2019/50910', 'Division II'),
(34, 34, 'Namilyango School', 'PLE/UG/2020/63256', 30, 'UCE/UG/2013/63396', 'Division III'),
(35, 35, 'Namilyango School', 'PLE/UG/2023/70688', 25, 'UCE/UG/2014/46167', 'Division II'),
(36, 36, 'Namilyango School', 'PLE/UG/2012/75485', 13, 'UCE/UG/2014/52931', 'Division IV'),
(37, 37, 'Greenhill Academy', 'PLE/UG/2021/43337', 25, 'UCE/UG/2011/49392', 'Division I'),
(38, 38, 'Buddo Junior', 'PLE/UG/2014/25865', 17, 'UCE/UG/2015/66184', 'Division I'),
(39, 39, 'Greenhill Academy', 'PLE/UG/2018/10205', 28, 'UCE/UG/2018/57979', 'Division I'),
(40, 40, 'Buddo Junior', 'PLE/UG/2023/70337', 20, 'UCE/UG/2017/02204', 'Division III'),
(41, 41, 'Namilyango School', 'PLE/UG/2017/24113', 24, 'UCE/UG/2015/19035', 'Division III'),
(42, 42, 'Buddo Junior', 'PLE/UG/2017/59524', 13, 'UCE/UG/2020/87304', 'Division I'),
(43, 43, 'Gayaza High School', 'PLE/UG/2018/99543', 6, 'UCE/UG/2015/66492', 'Division I'),
(44, 44, 'Namilyango School', 'PLE/UG/2016/96436', 15, 'UCE/UG/2021/14081', 'Division I'),
(45, 45, 'Ntare School', 'PLE/UG/2013/62045', 18, 'UCE/UG/2015/57596', 'Division III'),
(46, 46, 'Greenhill Academy', 'PLE/UG/2013/84555', 18, 'UCE/UG/2020/22350', 'Division IV'),
(47, 47, 'Greenhill Academy', 'PLE/UG/2017/94766', 11, 'UCE/UG/2014/88793', 'Division II'),
(48, 48, 'Buddo Junior', 'PLE/UG/2010/18127', 26, 'UCE/UG/2010/91591', 'Division III'),
(49, 49, 'Namilyango School', 'PLE/UG/2010/67285', 10, 'UCE/UG/2010/60519', 'Division IV'),
(50, 50, 'Buddo Junior', 'PLE/UG/2021/89979', 6, 'UCE/UG/2018/95372', 'Division IV'),
(51, 51, 'Gayaza High School', 'PLE/UG/2015/86075', 8, 'UCE/UG/2012/33282', 'Division I'),
(52, 52, 'Ntare School', 'PLE/UG/2014/25780', 16, 'UCE/UG/2012/75752', 'Division I'),
(53, 53, 'Namilyango School', 'PLE/UG/2016/11362', 9, 'UCE/UG/2016/78968', 'Division III'),
(54, 54, 'Greenhill Academy', 'PLE/UG/2016/34177', 14, 'UCE/UG/2018/96983', 'Division I'),
(55, 55, 'Greenhill Academy', 'PLE/UG/2019/11680', 19, 'UCE/UG/2010/66181', 'Division II'),
(56, 56, 'Gayaza High School', 'PLE/UG/2018/27325', 22, 'UCE/UG/2010/58179', 'Division III'),
(57, 57, 'Gayaza High School', 'PLE/UG/2013/59024', 11, 'UCE/UG/2015/17579', 'Division IV'),
(58, 58, 'Ntare School', 'PLE/UG/2019/95245', 28, 'UCE/UG/2023/66933', 'Division II'),
(59, 59, 'Greenhill Academy', 'PLE/UG/2014/03705', 12, 'UCE/UG/2012/19786', 'Division II'),
(60, 60, 'Namilyango School', 'PLE/UG/2010/86902', 14, 'UCE/UG/2011/48073', 'Division I'),
(61, 61, 'Greenhill Academy', 'PLE/UG/2017/03551', 21, 'UCE/UG/2019/79497', 'Division IV'),
(62, 62, 'Buddo Junior', 'PLE/UG/2015/88627', 11, 'UCE/UG/2017/04644', 'Division III'),
(63, 63, 'Ntare School', 'PLE/UG/2014/26403', 14, 'UCE/UG/2021/27686', 'Division IV'),
(64, 64, 'Gayaza High School', 'PLE/UG/2018/90411', 26, 'UCE/UG/2020/65434', 'Division I'),
(65, 65, 'Ntare School', 'PLE/UG/2016/66327', 31, 'UCE/UG/2015/22035', 'Division I'),
(66, 66, 'Ntare School', 'PLE/UG/2014/10717', 19, 'UCE/UG/2012/37586', 'Division II'),
(67, 67, 'Greenhill Academy', 'PLE/UG/2020/10563', 15, 'UCE/UG/2017/49567', 'Division IV'),
(68, 68, 'Buddo Junior', 'PLE/UG/2021/39823', 17, 'UCE/UG/2023/64219', 'Division I'),
(69, 69, 'Buddo Junior', 'PLE/UG/2012/47709', 31, 'UCE/UG/2022/89162', 'Division IV'),
(70, 70, 'Buddo Junior', 'PLE/UG/2018/76392', 35, 'UCE/UG/2019/40837', 'Division I'),
(71, 71, 'Ntare School', 'PLE/UG/2014/82806', 11, 'UCE/UG/2020/03452', 'Division IV'),
(72, 72, 'Ntare School', 'PLE/UG/2015/38273', 28, 'UCE/UG/2018/88063', 'Division III'),
(73, 73, 'Buddo Junior', 'PLE/UG/2017/35859', 11, 'UCE/UG/2012/02741', 'Division III'),
(74, 74, 'Namilyango School', 'PLE/UG/2022/23779', 19, 'UCE/UG/2019/00030', 'Division IV'),
(75, 75, 'Namilyango School', 'PLE/UG/2020/43949', 4, 'UCE/UG/2020/86090', 'Division IV'),
(76, 76, 'Buddo Junior', 'PLE/UG/2012/69493', 30, 'UCE/UG/2011/88394', 'Division I'),
(77, 77, 'Greenhill Academy', 'PLE/UG/2015/26283', 6, 'UCE/UG/2017/57516', 'Division I'),
(78, 78, 'Buddo Junior', 'PLE/UG/2014/77917', 33, 'UCE/UG/2013/44749', 'Division III'),
(79, 79, 'Buddo Junior', 'PLE/UG/2016/50419', 7, 'UCE/UG/2011/04137', 'Division IV'),
(80, 80, 'Ntare School', 'PLE/UG/2022/66637', 25, 'UCE/UG/2014/54045', 'Division IV'),
(81, 81, 'Buddo Junior', 'PLE/UG/2017/61618', 21, 'UCE/UG/2021/63757', 'Division III'),
(82, 82, 'Greenhill Academy', 'PLE/UG/2013/21618', 16, 'UCE/UG/2013/17279', 'Division I'),
(83, 83, 'Namilyango School', 'PLE/UG/2015/83189', 33, 'UCE/UG/2011/90407', 'Division I'),
(84, 84, 'Buddo Junior', 'PLE/UG/2010/16112', 28, 'UCE/UG/2015/75177', 'Division III'),
(85, 85, 'Namilyango School', 'PLE/UG/2020/20748', 29, 'UCE/UG/2014/39007', 'Division IV'),
(86, 86, 'Gayaza High School', 'PLE/UG/2022/76984', 10, 'UCE/UG/2020/18807', 'Division III'),
(87, 87, 'Ntare School', 'PLE/UG/2022/13786', 33, 'UCE/UG/2011/91546', 'Division I'),
(88, 88, 'Buddo Junior', 'PLE/UG/2020/99043', 24, 'UCE/UG/2013/31889', 'Division IV'),
(89, 89, 'Gayaza High School', 'PLE/UG/2022/43155', 21, 'UCE/UG/2016/57147', 'Division III'),
(90, 90, 'Ntare School', 'PLE/UG/2023/44507', 14, 'UCE/UG/2015/84573', 'Division I'),
(91, 91, 'Namilyango School', 'PLE/UG/2010/81451', 35, 'UCE/UG/2017/70518', 'Division IV'),
(92, 92, 'Greenhill Academy', 'PLE/UG/2017/10569', 34, 'UCE/UG/2016/39598', 'Division III'),
(93, 93, 'Gayaza High School', 'PLE/UG/2020/09806', 8, 'UCE/UG/2016/89711', 'Division I'),
(94, 94, 'Ntare School', 'PLE/UG/2018/31634', 28, 'UCE/UG/2021/77283', 'Division II'),
(95, 95, 'Buddo Junior', 'PLE/UG/2015/94799', 21, 'UCE/UG/2021/49814', 'Division I'),
(96, 96, 'Gayaza High School', 'PLE/UG/2016/37756', 20, 'UCE/UG/2016/69848', 'Division I'),
(97, 97, 'Namilyango School', 'PLE/UG/2019/23217', 5, 'UCE/UG/2018/76051', 'Division I'),
(98, 98, 'Ntare School', 'PLE/UG/2023/45708', 15, 'UCE/UG/2016/28936', 'Division I'),
(99, 99, 'Namilyango School', 'PLE/UG/2016/85219', 29, 'UCE/UG/2016/90734', 'Division I'),
(100, 100, 'Namilyango School', 'PLE/UG/2016/06106', 30, 'UCE/UG/2023/20884', 'Division I'),
(101, 101, 'Ntare School', 'PLE/UG/2017/33945', 4, 'UCE/UG/2010/09889', 'Division II'),
(102, 102, 'Greenhill Academy', 'PLE/UG/2023/87827', 21, 'UCE/UG/2011/98821', 'Division III'),
(103, 103, 'Gayaza High School', 'PLE/UG/2015/14953', 21, 'UCE/UG/2014/04357', 'Division I'),
(104, 104, 'Ntare School', 'PLE/UG/2010/24977', 11, 'UCE/UG/2015/43189', 'Division IV'),
(105, 105, 'Greenhill Academy', 'PLE/UG/2011/86605', 4, 'UCE/UG/2015/05453', 'Division I'),
(106, 106, 'Gayaza High School', 'PLE/UG/2020/85045', 35, 'UCE/UG/2014/78637', 'Division IV'),
(107, 107, 'Greenhill Academy', 'PLE/UG/2015/37678', 25, 'UCE/UG/2013/30324', 'Division III'),
(108, 108, 'Greenhill Academy', 'PLE/UG/2014/06791', 15, 'UCE/UG/2018/83570', 'Division II'),
(109, 109, 'Greenhill Academy', 'PLE/UG/2012/93492', 11, 'UCE/UG/2014/85916', 'Division II'),
(110, 110, 'Ntare School', 'PLE/UG/2010/86683', 8, 'UCE/UG/2011/03012', 'Division IV'),
(111, 111, 'Greenhill Academy', 'PLE/UG/2018/53702', 32, 'UCE/UG/2021/44413', 'Division IV'),
(112, 112, 'Gayaza High School', 'PLE/UG/2011/67906', 5, 'UCE/UG/2012/78369', 'Division II'),
(113, 113, 'Namilyango School', 'PLE/UG/2010/06016', 10, 'UCE/UG/2020/34781', 'Division II'),
(114, 114, 'Namilyango School', 'PLE/UG/2015/11419', 13, 'UCE/UG/2012/87579', 'Division IV'),
(115, 115, 'Ntare School', 'PLE/UG/2012/45984', 29, 'UCE/UG/2018/73700', 'Division IV'),
(116, 116, 'Ntare School', 'PLE/UG/2010/37152', 29, 'UCE/UG/2023/24346', 'Division II'),
(117, 117, 'Namilyango School', 'PLE/UG/2014/22796', 12, 'UCE/UG/2018/21704', 'Division II'),
(118, 118, 'Namilyango School', 'PLE/UG/2019/76929', 31, 'UCE/UG/2023/21985', 'Division I'),
(119, 119, 'Ntare School', 'PLE/UG/2022/21409', 14, 'UCE/UG/2010/09431', 'Division II'),
(120, 120, 'Gayaza High School', 'PLE/UG/2011/94323', 14, 'UCE/UG/2021/02262', 'Division III'),
(121, 121, 'Greenhill Academy', 'PLE/UG/2016/69225', 35, 'UCE/UG/2021/20603', 'Division III'),
(122, 122, 'Ntare School', 'PLE/UG/2013/00337', 12, 'UCE/UG/2014/86983', 'Division II'),
(123, 123, 'Gayaza High School', 'PLE/UG/2018/78013', 8, 'UCE/UG/2013/04841', 'Division II'),
(124, 124, 'Buddo Junior', 'PLE/UG/2012/38106', 18, 'UCE/UG/2012/57654', 'Division II'),
(125, 125, 'Buddo Junior', 'PLE/UG/2023/41094', 9, 'UCE/UG/2019/83031', 'Division I'),
(126, 126, 'Gayaza High School', 'PLE/UG/2016/59617', 25, 'UCE/UG/2016/51495', 'Division I'),
(127, 127, 'Namilyango School', 'PLE/UG/2022/51704', 30, 'UCE/UG/2017/32723', 'Division IV'),
(128, 128, 'Gayaza High School', 'PLE/UG/2014/89722', 21, 'UCE/UG/2010/41060', 'Division I'),
(129, 129, 'Greenhill Academy', 'PLE/UG/2013/79563', 11, 'UCE/UG/2020/03448', 'Division IV'),
(130, 130, 'Greenhill Academy', 'PLE/UG/2021/97572', 20, 'UCE/UG/2018/57369', 'Division I'),
(131, 131, 'Namilyango School', 'PLE/UG/2015/55179', 25, 'UCE/UG/2019/36459', 'Division IV'),
(132, 132, 'Namilyango School', 'PLE/UG/2019/06624', 11, 'UCE/UG/2023/24999', 'Division II'),
(133, 133, 'Greenhill Academy', 'PLE/UG/2011/71319', 14, 'UCE/UG/2016/49167', 'Division IV'),
(134, 134, 'Greenhill Academy', 'PLE/UG/2016/82481', 24, 'UCE/UG/2019/62655', 'Division I'),
(135, 135, 'Ntare School', 'PLE/UG/2012/66980', 27, 'UCE/UG/2018/89267', 'Division III'),
(136, 136, 'Greenhill Academy', 'PLE/UG/2017/83766', 24, 'UCE/UG/2020/64508', 'Division I'),
(137, 137, 'Buddo Junior', 'PLE/UG/2018/27367', 20, 'UCE/UG/2021/38674', 'Division III'),
(138, 138, 'Ntare School', 'PLE/UG/2018/49267', 24, 'UCE/UG/2020/70004', 'Division II'),
(139, 139, 'Ntare School', 'PLE/UG/2023/06743', 18, 'UCE/UG/2011/14855', 'Division II'),
(140, 140, 'Gayaza High School', 'PLE/UG/2010/24172', 5, 'UCE/UG/2017/43701', 'Division III'),
(141, 141, 'Greenhill Academy', 'PLE/UG/2018/43272', 12, 'UCE/UG/2010/29799', 'Division II'),
(142, 142, 'Ntare School', 'PLE/UG/2019/67142', 15, 'UCE/UG/2021/99165', 'Division III'),
(143, 143, 'Greenhill Academy', 'PLE/UG/2019/39117', 34, 'UCE/UG/2017/85695', 'Division III'),
(144, 144, 'Namilyango School', 'PLE/UG/2020/34820', 21, 'UCE/UG/2018/55726', 'Division IV'),
(145, 145, 'Greenhill Academy', 'PLE/UG/2014/01229', 7, 'UCE/UG/2017/20257', 'Division II'),
(146, 146, 'Ntare School', 'PLE/UG/2023/08922', 24, 'UCE/UG/2023/76716', 'Division I'),
(147, 147, 'Greenhill Academy', 'PLE/UG/2012/11362', 35, 'UCE/UG/2017/80853', 'Division II'),
(148, 148, 'Gayaza High School', 'PLE/UG/2015/97059', 23, 'UCE/UG/2012/11395', 'Division IV'),
(149, 149, 'Buddo Junior', 'PLE/UG/2019/44705', 7, 'UCE/UG/2012/53224', 'Division I'),
(150, 150, 'Buddo Junior', 'PLE/UG/2017/22043', 22, 'UCE/UG/2013/42190', 'Division II'),
(151, 151, 'Buddo Junior', 'PLE/UG/2023/47339', 21, 'UCE/UG/2015/15837', 'Division III'),
(152, 152, 'Buddo Junior', 'PLE/UG/2015/95705', 26, 'UCE/UG/2019/25128', 'Division I'),
(153, 153, 'Gayaza High School', 'PLE/UG/2020/88036', 10, 'UCE/UG/2014/17329', 'Division IV'),
(154, 154, 'Namilyango School', 'PLE/UG/2020/82410', 28, 'UCE/UG/2015/68209', 'Division I'),
(155, 155, 'Gayaza High School', 'PLE/UG/2014/75520', 32, 'UCE/UG/2011/93753', 'Division II'),
(156, 156, 'Ntare School', 'PLE/UG/2015/31567', 16, 'UCE/UG/2010/89093', 'Division II'),
(157, 157, 'Gayaza High School', 'PLE/UG/2017/55773', 10, 'UCE/UG/2014/02865', 'Division I'),
(158, 158, 'Greenhill Academy', 'PLE/UG/2011/46326', 6, 'UCE/UG/2010/02652', 'Division IV'),
(159, 159, 'Gayaza High School', 'PLE/UG/2014/39260', 5, 'UCE/UG/2023/82225', 'Division I'),
(160, 160, 'Ntare School', 'PLE/UG/2012/41608', 21, 'UCE/UG/2017/89058', 'Division IV'),
(161, 161, 'Ntare School', 'PLE/UG/2021/52039', 10, 'UCE/UG/2016/64004', 'Division IV'),
(162, 162, 'Greenhill Academy', 'PLE/UG/2020/80318', 27, 'UCE/UG/2014/39606', 'Division IV'),
(163, 163, 'Gayaza High School', 'PLE/UG/2014/82481', 8, 'UCE/UG/2012/53351', 'Division I'),
(164, 164, 'Buddo Junior', 'PLE/UG/2014/33108', 29, 'UCE/UG/2023/40450', 'Division I'),
(165, 165, 'Namilyango School', 'PLE/UG/2012/65734', 25, 'UCE/UG/2015/99854', 'Division IV'),
(166, 166, 'Buddo Junior', 'PLE/UG/2017/65486', 24, 'UCE/UG/2013/46660', 'Division II'),
(167, 167, 'Gayaza High School', 'PLE/UG/2020/69704', 11, 'UCE/UG/2011/76605', 'Division III'),
(168, 168, 'Gayaza High School', 'PLE/UG/2014/77363', 34, 'UCE/UG/2016/49592', 'Division I'),
(169, 169, 'Ntare School', 'PLE/UG/2023/10194', 22, 'UCE/UG/2018/21290', 'Division II'),
(170, 170, 'Greenhill Academy', 'PLE/UG/2016/75920', 19, 'UCE/UG/2011/98182', 'Division III'),
(171, 171, 'Gayaza High School', 'PLE/UG/2018/21561', 12, 'UCE/UG/2018/37567', 'Division IV'),
(172, 172, 'Namilyango School', 'PLE/UG/2020/57873', 26, 'UCE/UG/2020/62058', 'Division IV'),
(173, 173, 'Buddo Junior', 'PLE/UG/2013/92965', 33, 'UCE/UG/2021/40451', 'Division III'),
(174, 174, 'Greenhill Academy', 'PLE/UG/2016/57080', 17, 'UCE/UG/2016/99993', 'Division III'),
(175, 175, 'Ntare School', 'PLE/UG/2011/15529', 20, 'UCE/UG/2011/84787', 'Division I'),
(176, 176, 'Buddo Junior', 'PLE/UG/2016/28328', 6, 'UCE/UG/2017/30105', 'Division IV'),
(177, 177, 'Greenhill Academy', 'PLE/UG/2011/90069', 6, 'UCE/UG/2020/41270', 'Division IV'),
(178, 178, 'Gayaza High School', 'PLE/UG/2013/16734', 6, 'UCE/UG/2021/90766', 'Division I'),
(179, 179, 'Buddo Junior', 'PLE/UG/2020/45339', 35, 'UCE/UG/2017/63228', 'Division III'),
(180, 180, 'Buddo Junior', 'PLE/UG/2022/67904', 23, 'UCE/UG/2010/35783', 'Division III'),
(181, 181, 'Gayaza High School', 'PLE/UG/2010/49992', 14, 'UCE/UG/2011/52703', 'Division II'),
(182, 182, 'Ntare School', 'PLE/UG/2012/52387', 4, 'UCE/UG/2016/34561', 'Division II'),
(183, 183, 'Gayaza High School', 'PLE/UG/2022/54996', 7, 'UCE/UG/2023/30499', 'Division III'),
(184, 184, 'Namilyango School', 'PLE/UG/2012/45028', 28, 'UCE/UG/2016/16228', 'Division II'),
(185, 185, 'Gayaza High School', 'PLE/UG/2012/80838', 18, 'UCE/UG/2022/95180', 'Division I'),
(186, 186, 'Greenhill Academy', 'PLE/UG/2018/24089', 18, 'UCE/UG/2018/61126', 'Division II'),
(187, 187, 'Buddo Junior', 'PLE/UG/2017/74176', 6, 'UCE/UG/2012/79368', 'Division II'),
(188, 188, 'Buddo Junior', 'PLE/UG/2023/15848', 29, 'UCE/UG/2018/44721', 'Division III'),
(189, 189, 'Namilyango School', 'PLE/UG/2018/99559', 8, 'UCE/UG/2019/95817', 'Division IV'),
(190, 190, 'Gayaza High School', 'PLE/UG/2016/40790', 25, 'UCE/UG/2011/55196', 'Division II'),
(191, 191, 'Ntare School', 'PLE/UG/2015/51410', 16, 'UCE/UG/2015/71364', 'Division II'),
(192, 192, 'Buddo Junior', 'PLE/UG/2014/64637', 10, 'UCE/UG/2010/54935', 'Division III'),
(193, 193, 'Namilyango School', 'PLE/UG/2022/05263', 19, 'UCE/UG/2013/79561', 'Division I'),
(194, 194, 'Ntare School', 'PLE/UG/2023/09532', 21, 'UCE/UG/2015/48084', 'Division I'),
(195, 195, 'Namilyango School', 'PLE/UG/2017/59552', 15, 'UCE/UG/2010/97198', 'Division IV'),
(196, 196, 'Greenhill Academy', 'PLE/UG/2020/88181', 12, 'UCE/UG/2019/51832', 'Division III'),
(197, 197, 'Greenhill Academy', 'PLE/UG/2011/91074', 11, 'UCE/UG/2015/30361', 'Division II'),
(198, 198, 'Greenhill Academy', 'PLE/UG/2014/91876', 27, 'UCE/UG/2021/10278', 'Division IV'),
(199, 199, 'Greenhill Academy', 'PLE/UG/2012/43893', 24, 'UCE/UG/2022/40048', 'Division II'),
(200, 200, 'Greenhill Academy', 'PLE/UG/2022/60468', 16, 'UCE/UG/2012/57735', 'Division II'),
(201, 201, 'Greenhill Academy', 'PLE/UG/2016/73328', 13, 'UCE/UG/2013/50790', 'Division III'),
(202, 202, 'Ntare School', 'PLE/UG/2019/70093', 18, 'UCE/UG/2012/51569', 'Division I'),
(203, 203, 'Buddo Junior', 'PLE/UG/2014/62708', 9, 'UCE/UG/2010/64104', 'Division I'),
(204, 204, 'Gayaza High School', 'PLE/UG/2020/52993', 18, 'UCE/UG/2019/00786', 'Division I'),
(205, 205, 'Ntare School', 'PLE/UG/2019/03442', 10, 'UCE/UG/2022/81241', 'Division II'),
(206, 206, 'Greenhill Academy', 'PLE/UG/2012/89997', 6, 'UCE/UG/2018/91367', 'Division III'),
(207, 207, 'Greenhill Academy', 'PLE/UG/2015/17234', 27, 'UCE/UG/2012/78173', 'Division II'),
(208, 208, 'Buddo Junior', 'PLE/UG/2016/08325', 7, 'UCE/UG/2013/90896', 'Division IV'),
(209, 209, 'Gayaza High School', 'PLE/UG/2010/64417', 5, 'UCE/UG/2014/32832', 'Division IV'),
(210, 210, 'Greenhill Academy', 'PLE/UG/2022/68994', 25, 'UCE/UG/2014/57965', 'Division IV'),
(211, 211, 'Greenhill Academy', 'PLE/UG/2015/48957', 9, 'UCE/UG/2015/54059', 'Division II'),
(212, 212, 'Buddo Junior', 'PLE/UG/2021/99299', 16, 'UCE/UG/2010/03829', 'Division I'),
(213, 213, 'Namilyango School', 'PLE/UG/2010/84247', 7, 'UCE/UG/2010/87341', 'Division I'),
(214, 214, 'Ntare School', 'PLE/UG/2020/22099', 28, 'UCE/UG/2012/46337', 'Division IV'),
(215, 215, 'Ntare School', 'PLE/UG/2011/82201', 31, 'UCE/UG/2022/75870', 'Division I'),
(216, 216, 'Greenhill Academy', 'PLE/UG/2017/75760', 12, 'UCE/UG/2010/26884', 'Division II'),
(217, 217, 'Gayaza High School', 'PLE/UG/2021/44183', 28, 'UCE/UG/2017/40935', 'Division II'),
(218, 218, 'Buddo Junior', 'PLE/UG/2022/29915', 29, 'UCE/UG/2012/34712', 'Division II'),
(219, 219, 'Namilyango School', 'PLE/UG/2018/51740', 28, 'UCE/UG/2014/24859', 'Division II'),
(220, 220, 'Greenhill Academy', 'PLE/UG/2017/02072', 17, 'UCE/UG/2011/12627', 'Division II'),
(221, 221, 'Greenhill Academy', 'PLE/UG/2017/03231', 24, 'UCE/UG/2011/69476', 'Division I'),
(222, 222, 'Namilyango School', 'PLE/UG/2012/55910', 9, 'UCE/UG/2012/49725', 'Division IV'),
(223, 223, 'Namilyango School', 'PLE/UG/2020/35107', 20, 'UCE/UG/2016/81057', 'Division III'),
(224, 224, 'Buddo Junior', 'PLE/UG/2020/99292', 23, 'UCE/UG/2011/72852', 'Division II'),
(225, 225, 'Ntare School', 'PLE/UG/2023/34190', 30, 'UCE/UG/2012/33648', 'Division I'),
(226, 226, 'Gayaza High School', 'PLE/UG/2014/52700', 26, 'UCE/UG/2023/66233', 'Division II'),
(227, 227, 'Buddo Junior', 'PLE/UG/2018/08604', 24, 'UCE/UG/2023/97965', 'Division IV'),
(228, 228, 'Gayaza High School', 'PLE/UG/2023/77869', 33, 'UCE/UG/2013/56844', 'Division I'),
(229, 229, 'Buddo Junior', 'PLE/UG/2014/75040', 28, 'UCE/UG/2019/90565', 'Division III'),
(230, 230, 'Ntare School', 'PLE/UG/2015/58496', 29, 'UCE/UG/2013/73754', 'Division I'),
(231, 231, 'Greenhill Academy', 'PLE/UG/2019/56384', 32, 'UCE/UG/2019/86916', 'Division I'),
(232, 232, 'Greenhill Academy', 'PLE/UG/2020/64256', 5, 'UCE/UG/2013/26748', 'Division III'),
(233, 233, 'Greenhill Academy', 'PLE/UG/2021/62776', 25, 'UCE/UG/2017/56854', 'Division II'),
(234, 234, 'Gayaza High School', 'PLE/UG/2017/43884', 25, 'UCE/UG/2010/09560', 'Division II'),
(235, 235, 'Buddo Junior', 'PLE/UG/2020/88584', 8, 'UCE/UG/2010/83418', 'Division I'),
(236, 236, 'Gayaza High School', 'PLE/UG/2015/02484', 4, 'UCE/UG/2023/72692', 'Division IV'),
(237, 237, 'Gayaza High School', 'PLE/UG/2012/97053', 13, 'UCE/UG/2018/08222', 'Division III'),
(238, 238, 'Greenhill Academy', 'PLE/UG/2018/63864', 14, 'UCE/UG/2020/59379', 'Division IV'),
(239, 239, 'Greenhill Academy', 'PLE/UG/2020/76894', 23, 'UCE/UG/2019/58263', 'Division IV'),
(240, 240, 'Gayaza High School', 'PLE/UG/2018/74744', 35, 'UCE/UG/2020/76010', 'Division III'),
(241, 241, 'Buddo Junior', 'PLE/UG/2020/24473', 5, 'UCE/UG/2016/17763', 'Division III'),
(242, 242, 'Buddo Junior', 'PLE/UG/2021/97872', 18, 'UCE/UG/2013/96062', 'Division I'),
(243, 243, 'Gayaza High School', 'PLE/UG/2013/57597', 5, 'UCE/UG/2017/59017', 'Division II'),
(244, 244, 'Namilyango School', 'PLE/UG/2023/54925', 30, 'UCE/UG/2016/82897', 'Division IV'),
(245, 245, 'Gayaza High School', 'PLE/UG/2011/78700', 24, 'UCE/UG/2021/11550', 'Division I'),
(246, 246, 'Ntare School', 'PLE/UG/2014/48184', 16, 'UCE/UG/2017/41627', 'Division III'),
(247, 247, 'Buddo Junior', 'PLE/UG/2014/09263', 23, 'UCE/UG/2020/89602', 'Division II'),
(248, 248, 'Namilyango School', 'PLE/UG/2016/80921', 27, 'UCE/UG/2013/96803', 'Division I'),
(249, 249, 'Greenhill Academy', 'PLE/UG/2016/63549', 32, 'UCE/UG/2016/83444', 'Division III'),
(250, 250, 'Greenhill Academy', 'PLE/UG/2013/42802', 16, 'UCE/UG/2019/32280', 'Division III'),
(251, 251, 'Gayaza High School', 'PLE/UG/2014/44535', 15, 'UCE/UG/2016/34298', 'Division II'),
(252, 252, 'Ntare School', 'PLE/UG/2023/33803', 32, 'UCE/UG/2016/53724', 'Division II'),
(253, 253, 'Ntare School', 'PLE/UG/2011/20993', 25, 'UCE/UG/2021/95674', 'Division II'),
(254, 254, 'Greenhill Academy', 'PLE/UG/2010/53946', 20, 'UCE/UG/2023/17483', 'Division I'),
(255, 255, 'Greenhill Academy', 'PLE/UG/2022/42859', 20, 'UCE/UG/2014/04755', 'Division II'),
(256, 256, 'Greenhill Academy', 'PLE/UG/2017/70762', 34, 'UCE/UG/2019/37814', 'Division IV'),
(257, 257, 'Ntare School', 'PLE/UG/2015/73370', 18, 'UCE/UG/2010/98415', 'Division III'),
(258, 258, 'Gayaza High School', 'PLE/UG/2020/66558', 8, 'UCE/UG/2020/28402', 'Division I'),
(259, 259, 'Buddo Junior', 'PLE/UG/2021/92938', 8, 'UCE/UG/2023/24065', 'Division II'),
(260, 260, 'Greenhill Academy', 'PLE/UG/2019/93495', 21, 'UCE/UG/2022/80002', 'Division II'),
(261, 261, 'Buddo Junior', 'PLE/UG/2020/23491', 4, 'UCE/UG/2016/16218', 'Division II'),
(262, 262, 'Greenhill Academy', 'PLE/UG/2017/12399', 5, 'UCE/UG/2022/24066', 'Division III'),
(263, 263, 'Greenhill Academy', 'PLE/UG/2011/50116', 12, 'UCE/UG/2021/45092', 'Division III'),
(264, 264, 'Greenhill Academy', 'PLE/UG/2012/04148', 25, 'UCE/UG/2014/46021', 'Division II'),
(265, 265, 'Gayaza High School', 'PLE/UG/2019/70034', 17, 'UCE/UG/2010/85836', 'Division I'),
(266, 266, 'Gayaza High School', 'PLE/UG/2023/91152', 24, 'UCE/UG/2015/12292', 'Division II'),
(267, 267, 'Greenhill Academy', 'PLE/UG/2020/91373', 16, 'UCE/UG/2013/01946', 'Division II'),
(268, 268, 'Ntare School', 'PLE/UG/2010/53063', 19, 'UCE/UG/2021/70908', 'Division I'),
(269, 269, 'Buddo Junior', 'PLE/UG/2013/34126', 32, 'UCE/UG/2016/75785', 'Division II'),
(270, 270, 'Namilyango School', 'PLE/UG/2020/43159', 33, 'UCE/UG/2013/56215', 'Division I'),
(271, 271, 'Buddo Junior', 'PLE/UG/2010/01952', 33, 'UCE/UG/2016/71885', 'Division I'),
(272, 272, 'Gayaza High School', 'PLE/UG/2021/10641', 5, 'UCE/UG/2023/59063', 'Division I'),
(273, 273, 'Greenhill Academy', 'PLE/UG/2014/95686', 30, 'UCE/UG/2014/02031', 'Division I'),
(274, 274, 'Buddo Junior', 'PLE/UG/2010/93310', 19, 'UCE/UG/2018/60382', 'Division I'),
(275, 275, 'Gayaza High School', 'PLE/UG/2014/05908', 13, 'UCE/UG/2014/61258', 'Division I'),
(276, 276, 'Namilyango School', 'PLE/UG/2017/50612', 4, 'UCE/UG/2017/65366', 'Division III'),
(277, 277, 'Gayaza High School', 'PLE/UG/2014/71402', 21, 'UCE/UG/2018/36659', 'Division I'),
(278, 278, 'Namilyango School', 'PLE/UG/2023/79682', 5, 'UCE/UG/2020/73695', 'Division II'),
(279, 279, 'Namilyango School', 'PLE/UG/2020/30177', 13, 'UCE/UG/2018/24185', 'Division II'),
(280, 280, 'Namilyango School', 'PLE/UG/2013/02874', 16, 'UCE/UG/2022/28562', 'Division III'),
(281, 281, 'Buddo Junior', 'PLE/UG/2010/91050', 20, 'UCE/UG/2020/41295', 'Division III'),
(282, 282, 'Namilyango School', 'PLE/UG/2022/11738', 32, 'UCE/UG/2011/96544', 'Division II'),
(283, 283, 'Greenhill Academy', 'PLE/UG/2015/20440', 29, 'UCE/UG/2014/34237', 'Division III'),
(284, 284, 'Namilyango School', 'PLE/UG/2013/60352', 14, 'UCE/UG/2021/11855', 'Division I'),
(285, 285, 'Greenhill Academy', 'PLE/UG/2021/78250', 15, 'UCE/UG/2016/35714', 'Division II'),
(286, 286, 'Gayaza High School', 'PLE/UG/2023/68431', 23, 'UCE/UG/2010/44516', 'Division I'),
(287, 287, 'Gayaza High School', 'PLE/UG/2010/31994', 18, 'UCE/UG/2014/18403', 'Division IV'),
(288, 288, 'Gayaza High School', 'PLE/UG/2023/16510', 32, 'UCE/UG/2023/99566', 'Division I'),
(289, 289, 'Greenhill Academy', 'PLE/UG/2017/77068', 11, 'UCE/UG/2021/44106', 'Division III'),
(290, 290, 'Namilyango School', 'PLE/UG/2023/92723', 24, 'UCE/UG/2016/46023', 'Division IV'),
(291, 291, 'Buddo Junior', 'PLE/UG/2014/24751', 15, 'UCE/UG/2011/27701', 'Division I'),
(292, 292, 'Ntare School', 'PLE/UG/2023/44949', 11, 'UCE/UG/2022/71856', 'Division IV'),
(293, 293, 'Namilyango School', 'PLE/UG/2023/82829', 9, 'UCE/UG/2015/36117', 'Division III'),
(294, 294, 'Greenhill Academy', 'PLE/UG/2021/40005', 21, 'UCE/UG/2018/36484', 'Division IV'),
(295, 295, 'Namilyango School', 'PLE/UG/2018/85244', 16, 'UCE/UG/2015/77076', 'Division III'),
(296, 296, 'Gayaza High School', 'PLE/UG/2017/08584', 29, 'UCE/UG/2021/52332', 'Division I'),
(297, 297, 'Ntare School', 'PLE/UG/2016/85786', 35, 'UCE/UG/2014/59774', 'Division I'),
(298, 298, 'Namilyango School', 'PLE/UG/2022/13000', 6, 'UCE/UG/2023/53336', 'Division IV'),
(299, 299, 'Buddo Junior', 'PLE/UG/2023/83743', 13, 'UCE/UG/2023/88692', 'Division III'),
(300, 300, 'Greenhill Academy', 'PLE/UG/2011/25057', 30, 'UCE/UG/2016/71253', 'Division I'),
(301, 301, 'Namilyango School', 'PLE/UG/2014/50994', 21, 'UCE/UG/2013/44580', 'Division III'),
(302, 302, 'Namilyango School', 'PLE/UG/2011/27285', 35, 'UCE/UG/2012/82545', 'Division III'),
(303, 303, 'Greenhill Academy', 'PLE/UG/2016/59659', 21, 'UCE/UG/2022/98437', 'Division I'),
(304, 304, 'Buddo Junior', 'PLE/UG/2019/00456', 4, 'UCE/UG/2010/15990', 'Division III'),
(305, 305, 'Namilyango School', 'PLE/UG/2023/49211', 23, 'UCE/UG/2017/97372', 'Division I'),
(306, 306, 'Buddo Junior', 'PLE/UG/2016/97573', 18, 'UCE/UG/2015/42124', 'Division I'),
(307, 307, 'Gayaza High School', 'PLE/UG/2021/15655', 11, 'UCE/UG/2020/05323', 'Division IV'),
(308, 308, 'Buddo Junior', 'PLE/UG/2016/31607', 12, 'UCE/UG/2014/89354', 'Division II'),
(309, 309, 'Ntare School', 'PLE/UG/2016/59470', 25, 'UCE/UG/2017/76432', 'Division I'),
(310, 310, 'Gayaza High School', 'PLE/UG/2011/72414', 12, 'UCE/UG/2012/14234', 'Division I'),
(311, 311, 'Greenhill Academy', 'PLE/UG/2018/20527', 13, 'UCE/UG/2021/33306', 'Division I'),
(312, 312, 'Greenhill Academy', 'PLE/UG/2018/23288', 14, 'UCE/UG/2010/03471', 'Division I'),
(313, 313, 'Ntare School', 'PLE/UG/2018/60973', 12, 'UCE/UG/2016/66774', 'Division IV'),
(314, 314, 'Ntare School', 'PLE/UG/2022/91113', 33, 'UCE/UG/2021/28839', 'Division I'),
(315, 315, 'Ntare School', 'PLE/UG/2010/80429', 35, 'UCE/UG/2017/67660', 'Division IV'),
(316, 316, 'Namilyango School', 'PLE/UG/2016/80188', 24, 'UCE/UG/2022/39280', 'Division II'),
(317, 317, 'Namilyango School', 'PLE/UG/2015/83154', 4, 'UCE/UG/2018/84179', 'Division II'),
(318, 318, 'Greenhill Academy', 'PLE/UG/2017/25209', 24, 'UCE/UG/2015/07298', 'Division I'),
(319, 319, 'Buddo Junior', 'PLE/UG/2013/01429', 15, 'UCE/UG/2019/42188', 'Division I'),
(320, 320, 'Greenhill Academy', 'PLE/UG/2012/14634', 11, 'UCE/UG/2019/86936', 'Division I'),
(321, 321, 'Gayaza High School', 'PLE/UG/2019/45292', 12, 'UCE/UG/2022/78003', 'Division I'),
(322, 322, 'Ntare School', 'PLE/UG/2011/99434', 22, 'UCE/UG/2023/01757', 'Division I'),
(323, 323, 'Gayaza High School', 'PLE/UG/2017/85061', 22, 'UCE/UG/2014/93003', 'Division III'),
(324, 324, 'Namilyango School', 'PLE/UG/2013/26148', 19, 'UCE/UG/2018/63730', 'Division II'),
(325, 325, 'Gayaza High School', 'PLE/UG/2017/43968', 25, 'UCE/UG/2010/01204', 'Division I'),
(326, 326, 'Gayaza High School', 'PLE/UG/2010/03958', 10, 'UCE/UG/2022/74070', 'Division I'),
(327, 327, 'Greenhill Academy', 'PLE/UG/2016/55320', 14, 'UCE/UG/2023/98928', 'Division IV'),
(328, 328, 'Namilyango School', 'PLE/UG/2018/84141', 16, 'UCE/UG/2016/17448', 'Division II'),
(329, 329, 'Ntare School', 'PLE/UG/2019/22316', 35, 'UCE/UG/2012/09768', 'Division IV'),
(330, 330, 'Gayaza High School', 'PLE/UG/2021/00453', 22, 'UCE/UG/2023/93325', 'Division IV'),
(331, 331, 'Gayaza High School', 'PLE/UG/2011/82466', 30, 'UCE/UG/2019/03938', 'Division I'),
(332, 332, 'Gayaza High School', 'PLE/UG/2016/14278', 15, 'UCE/UG/2014/48707', 'Division III'),
(333, 333, 'Namilyango School', 'PLE/UG/2020/24518', 4, 'UCE/UG/2015/74284', 'Division III'),
(334, 334, 'Namilyango School', 'PLE/UG/2017/39401', 17, 'UCE/UG/2010/69972', 'Division II'),
(335, 335, 'Greenhill Academy', 'PLE/UG/2010/84106', 4, 'UCE/UG/2018/94502', 'Division IV'),
(336, 336, 'Namilyango School', 'PLE/UG/2014/32325', 27, 'UCE/UG/2019/23819', 'Division I'),
(337, 337, 'Buddo Junior', 'PLE/UG/2023/71496', 28, 'UCE/UG/2020/25735', 'Division I'),
(338, 338, 'Namilyango School', 'PLE/UG/2017/05814', 28, 'UCE/UG/2018/65604', 'Division III'),
(339, 339, 'Gayaza High School', 'PLE/UG/2014/58440', 34, 'UCE/UG/2010/43111', 'Division IV'),
(340, 340, 'Ntare School', 'PLE/UG/2015/69606', 14, 'UCE/UG/2017/59770', 'Division II'),
(341, 341, 'Ntare School', 'PLE/UG/2019/69797', 16, 'UCE/UG/2022/35829', 'Division I'),
(342, 342, 'Namilyango School', 'PLE/UG/2023/70792', 24, 'UCE/UG/2010/37736', 'Division III'),
(343, 343, 'Ntare School', 'PLE/UG/2014/11423', 23, 'UCE/UG/2018/39049', 'Division I'),
(344, 344, 'Ntare School', 'PLE/UG/2023/48596', 20, 'UCE/UG/2010/81605', 'Division IV'),
(345, 345, 'Gayaza High School', 'PLE/UG/2017/89315', 34, 'UCE/UG/2010/49507', 'Division II'),
(346, 346, 'Ntare School', 'PLE/UG/2011/26910', 34, 'UCE/UG/2023/81722', 'Division II'),
(347, 347, 'Namilyango School', 'PLE/UG/2021/61690', 24, 'UCE/UG/2014/80206', 'Division IV'),
(348, 348, 'Gayaza High School', 'PLE/UG/2018/18379', 7, 'UCE/UG/2010/82067', 'Division I'),
(349, 349, 'Gayaza High School', 'PLE/UG/2016/38478', 18, 'UCE/UG/2010/99846', 'Division IV'),
(350, 350, 'Gayaza High School', 'PLE/UG/2013/43845', 17, 'UCE/UG/2021/82522', 'Division III'),
(351, 351, 'Ntare School', 'PLE/UG/2019/84608', 10, 'UCE/UG/2016/61549', 'Division IV'),
(352, 352, 'Buddo Junior', 'PLE/UG/2012/75564', 10, 'UCE/UG/2019/96861', 'Division III'),
(353, 353, 'Ntare School', 'PLE/UG/2013/65058', 18, 'UCE/UG/2014/18267', 'Division IV'),
(354, 354, 'Namilyango School', 'PLE/UG/2023/37342', 34, 'UCE/UG/2019/43405', 'Division I'),
(355, 355, 'Ntare School', 'PLE/UG/2013/96640', 4, 'UCE/UG/2013/11504', 'Division IV'),
(356, 356, 'Namilyango School', 'PLE/UG/2013/08001', 24, 'UCE/UG/2010/12300', 'Division III'),
(357, 357, 'Gayaza High School', 'PLE/UG/2013/32179', 29, 'UCE/UG/2010/87293', 'Division I'),
(358, 358, 'Buddo Junior', 'PLE/UG/2011/08317', 8, 'UCE/UG/2015/60522', 'Division IV'),
(359, 359, 'Greenhill Academy', 'PLE/UG/2018/24729', 15, 'UCE/UG/2011/42085', 'Division IV'),
(360, 360, 'Buddo Junior', 'PLE/UG/2023/48907', 24, 'UCE/UG/2020/89954', 'Division I'),
(361, 361, 'Buddo Junior', 'PLE/UG/2019/49702', 17, 'UCE/UG/2017/48557', 'Division IV'),
(362, 362, 'Gayaza High School', 'PLE/UG/2017/02917', 18, 'UCE/UG/2012/63180', 'Division III'),
(363, 363, 'Buddo Junior', 'PLE/UG/2013/17448', 6, 'UCE/UG/2022/34478', 'Division IV'),
(364, 364, 'Greenhill Academy', 'PLE/UG/2013/28209', 28, 'UCE/UG/2023/40779', 'Division I'),
(365, 365, 'Gayaza High School', 'PLE/UG/2019/37056', 29, 'UCE/UG/2022/17138', 'Division I'),
(366, 366, 'Ntare School', 'PLE/UG/2015/41763', 30, 'UCE/UG/2022/12903', 'Division IV'),
(367, 367, 'Greenhill Academy', 'PLE/UG/2021/54828', 14, 'UCE/UG/2023/87834', 'Division II'),
(368, 368, 'Ntare School', 'PLE/UG/2022/06786', 25, 'UCE/UG/2013/02559', 'Division II'),
(369, 369, 'Namilyango School', 'PLE/UG/2015/61758', 30, 'UCE/UG/2013/82195', 'Division II'),
(370, 370, 'Greenhill Academy', 'PLE/UG/2010/22450', 6, 'UCE/UG/2020/58126', 'Division III'),
(371, 371, 'Buddo Junior', 'PLE/UG/2022/18282', 13, 'UCE/UG/2022/70168', 'Division IV'),
(372, 372, 'Buddo Junior', 'PLE/UG/2022/44637', 21, 'UCE/UG/2015/47978', 'Division I'),
(373, 373, 'Greenhill Academy', 'PLE/UG/2020/83861', 32, 'UCE/UG/2010/33709', 'Division III'),
(374, 374, 'Gayaza High School', 'PLE/UG/2021/00380', 23, 'UCE/UG/2011/61871', 'Division IV'),
(375, 375, 'Namilyango School', 'PLE/UG/2022/12061', 34, 'UCE/UG/2015/02589', 'Division I'),
(376, 376, 'Gayaza High School', 'PLE/UG/2021/34426', 11, 'UCE/UG/2012/02978', 'Division III'),
(377, 377, 'Buddo Junior', 'PLE/UG/2018/19463', 7, 'UCE/UG/2010/65563', 'Division II'),
(378, 378, 'Ntare School', 'PLE/UG/2017/02529', 21, 'UCE/UG/2018/50660', 'Division III'),
(379, 379, 'Gayaza High School', 'PLE/UG/2018/27039', 18, 'UCE/UG/2015/60081', 'Division IV'),
(380, 380, 'Ntare School', 'PLE/UG/2011/95425', 18, 'UCE/UG/2015/48566', 'Division II'),
(381, 381, 'Namilyango School', 'PLE/UG/2020/21141', 32, 'UCE/UG/2021/31241', 'Division I'),
(382, 382, 'Namilyango School', 'PLE/UG/2021/98688', 15, 'UCE/UG/2022/20208', 'Division II'),
(383, 383, 'Ntare School', 'PLE/UG/2011/74181', 18, 'UCE/UG/2011/02051', 'Division IV'),
(384, 384, 'Buddo Junior', 'PLE/UG/2011/70249', 7, 'UCE/UG/2016/98765', 'Division III'),
(385, 385, 'Buddo Junior', 'PLE/UG/2015/50937', 19, 'UCE/UG/2021/76357', 'Division II'),
(386, 386, 'Ntare School', 'PLE/UG/2011/86117', 4, 'UCE/UG/2017/49709', 'Division IV'),
(387, 387, 'Gayaza High School', 'PLE/UG/2017/22278', 17, 'UCE/UG/2015/80850', 'Division IV'),
(388, 388, 'Ntare School', 'PLE/UG/2015/85883', 5, 'UCE/UG/2018/85934', 'Division III'),
(389, 389, 'Buddo Junior', 'PLE/UG/2015/95212', 19, 'UCE/UG/2018/50425', 'Division III'),
(390, 390, 'Buddo Junior', 'PLE/UG/2015/98718', 30, 'UCE/UG/2012/48528', 'Division IV'),
(391, 391, 'Buddo Junior', 'PLE/UG/2023/52944', 27, 'UCE/UG/2012/54044', 'Division I'),
(392, 392, 'Ntare School', 'PLE/UG/2018/30714', 29, 'UCE/UG/2010/83452', 'Division I'),
(393, 393, 'Greenhill Academy', 'PLE/UG/2023/40581', 8, 'UCE/UG/2016/80847', 'Division III'),
(394, 394, 'Gayaza High School', 'PLE/UG/2011/51750', 11, 'UCE/UG/2018/19716', 'Division II'),
(395, 395, 'Ntare School', 'PLE/UG/2016/17940', 16, 'UCE/UG/2016/07276', 'Division I'),
(396, 396, 'Gayaza High School', 'PLE/UG/2013/33563', 35, 'UCE/UG/2021/31628', 'Division I'),
(397, 397, 'Greenhill Academy', 'PLE/UG/2018/44877', 17, 'UCE/UG/2019/32766', 'Division III'),
(398, 398, 'Greenhill Academy', 'PLE/UG/2016/53438', 10, 'UCE/UG/2014/14928', 'Division III'),
(399, 399, 'Buddo Junior', 'PLE/UG/2017/22127', 22, 'UCE/UG/2014/68959', 'Division III'),
(400, 400, 'Greenhill Academy', 'PLE/UG/2016/50551', 9, 'UCE/UG/2014/95527', 'Division IV'),
(401, 401, 'Namilyango School', 'PLE/UG/2013/08096', 21, 'UCE/UG/2017/99267', 'Division II'),
(402, 402, 'Greenhill Academy', 'PLE/UG/2010/32168', 18, 'UCE/UG/2013/91130', 'Division IV'),
(403, 403, 'Buddo Junior', 'PLE/UG/2013/35118', 32, 'UCE/UG/2016/66860', 'Division IV'),
(404, 404, 'Ntare School', 'PLE/UG/2015/73637', 19, 'UCE/UG/2012/44224', 'Division III'),
(405, 405, 'Buddo Junior', 'PLE/UG/2011/09634', 11, 'UCE/UG/2021/53356', 'Division I'),
(406, 406, 'Buddo Junior', 'PLE/UG/2015/56721', 27, 'UCE/UG/2023/67734', 'Division II'),
(407, 407, 'Gayaza High School', 'PLE/UG/2018/27616', 21, 'UCE/UG/2022/70652', 'Division IV'),
(408, 408, 'Ntare School', 'PLE/UG/2014/42822', 6, 'UCE/UG/2011/31404', 'Division I'),
(409, 409, 'Buddo Junior', 'PLE/UG/2018/08883', 26, 'UCE/UG/2012/82335', 'Division III'),
(410, 410, 'Gayaza High School', 'PLE/UG/2010/97487', 30, 'UCE/UG/2012/58702', 'Division II'),
(411, 411, 'Gayaza High School', 'PLE/UG/2013/18521', 7, 'UCE/UG/2010/84030', 'Division I'),
(412, 412, 'Greenhill Academy', 'PLE/UG/2010/16901', 30, 'UCE/UG/2019/94148', 'Division III'),
(413, 413, 'Gayaza High School', 'PLE/UG/2011/77997', 24, 'UCE/UG/2022/50691', 'Division IV'),
(414, 414, 'Gayaza High School', 'PLE/UG/2013/63528', 14, 'UCE/UG/2019/55404', 'Division III'),
(415, 415, 'Ntare School', 'PLE/UG/2017/18102', 12, 'UCE/UG/2020/87419', 'Division I'),
(416, 416, 'Greenhill Academy', 'PLE/UG/2016/58323', 18, 'UCE/UG/2017/30827', 'Division IV'),
(417, 417, 'Namilyango School', 'PLE/UG/2014/45541', 16, 'UCE/UG/2017/60164', 'Division II'),
(418, 418, 'Namilyango School', 'PLE/UG/2022/05343', 22, 'UCE/UG/2020/06924', 'Division I'),
(419, 419, 'Buddo Junior', 'PLE/UG/2012/63751', 24, 'UCE/UG/2013/27511', 'Division III'),
(420, 420, 'Gayaza High School', 'PLE/UG/2012/11179', 5, 'UCE/UG/2021/13971', 'Division I'),
(421, 421, 'Gayaza High School', 'PLE/UG/2023/17010', 34, 'UCE/UG/2014/61166', 'Division I'),
(422, 422, 'Buddo Junior', 'PLE/UG/2019/45183', 9, 'UCE/UG/2017/23622', 'Division III'),
(423, 423, 'Namilyango School', 'PLE/UG/2023/58799', 4, 'UCE/UG/2014/59756', 'Division IV'),
(424, 424, 'Buddo Junior', 'PLE/UG/2022/37556', 12, 'UCE/UG/2011/91918', 'Division I'),
(425, 425, 'Gayaza High School', 'PLE/UG/2019/57187', 30, 'UCE/UG/2016/75492', 'Division II'),
(426, 426, 'Ntare School', 'PLE/UG/2012/30656', 34, 'UCE/UG/2020/03605', 'Division IV'),
(427, 427, 'Ntare School', 'PLE/UG/2011/26499', 34, 'UCE/UG/2023/87627', 'Division III'),
(428, 428, 'Ntare School', 'PLE/UG/2021/97935', 16, 'UCE/UG/2023/65485', 'Division II'),
(429, 429, 'Namilyango School', 'PLE/UG/2014/09142', 19, 'UCE/UG/2012/42349', 'Division III'),
(430, 430, 'Gayaza High School', 'PLE/UG/2011/82495', 26, 'UCE/UG/2011/41573', 'Division III'),
(431, 431, 'Namilyango School', 'PLE/UG/2012/50886', 33, 'UCE/UG/2011/69691', 'Division I'),
(432, 432, 'Gayaza High School', 'PLE/UG/2019/39352', 35, 'UCE/UG/2019/42748', 'Division I'),
(433, 433, 'Ntare School', 'PLE/UG/2022/22205', 17, 'UCE/UG/2015/67780', 'Division I'),
(434, 434, 'Gayaza High School', 'PLE/UG/2012/91916', 7, 'UCE/UG/2021/76251', 'Division II'),
(435, 435, 'Greenhill Academy', 'PLE/UG/2014/02815', 7, 'UCE/UG/2016/96438', 'Division II'),
(436, 436, 'Gayaza High School', 'PLE/UG/2015/11357', 19, 'UCE/UG/2010/74396', 'Division III'),
(437, 437, 'Gayaza High School', 'PLE/UG/2014/69566', 22, 'UCE/UG/2020/17384', 'Division III'),
(438, 438, 'Greenhill Academy', 'PLE/UG/2018/48373', 23, 'UCE/UG/2019/42217', 'Division I'),
(439, 439, 'Namilyango School', 'PLE/UG/2016/33111', 12, 'UCE/UG/2014/67496', 'Division III'),
(440, 440, 'Greenhill Academy', 'PLE/UG/2011/97504', 20, 'UCE/UG/2019/91593', 'Division II'),
(441, 441, 'Greenhill Academy', 'PLE/UG/2022/35741', 10, 'UCE/UG/2023/05742', 'Division II'),
(442, 442, 'Gayaza High School', 'PLE/UG/2022/75865', 7, 'UCE/UG/2012/70117', 'Division IV'),
(443, 443, 'Greenhill Academy', 'PLE/UG/2018/21521', 12, 'UCE/UG/2020/79928', 'Division IV'),
(444, 444, 'Buddo Junior', 'PLE/UG/2022/38396', 10, 'UCE/UG/2022/83835', 'Division III'),
(445, 445, 'Namilyango School', 'PLE/UG/2022/03948', 23, 'UCE/UG/2021/49147', 'Division IV'),
(446, 446, 'Namilyango School', 'PLE/UG/2014/18984', 33, 'UCE/UG/2010/43607', 'Division I'),
(447, 447, 'Greenhill Academy', 'PLE/UG/2020/84972', 34, 'UCE/UG/2012/20526', 'Division II'),
(448, 448, 'Greenhill Academy', 'PLE/UG/2014/04759', 12, 'UCE/UG/2013/33659', 'Division IV'),
(449, 449, 'Ntare School', 'PLE/UG/2014/80337', 8, 'UCE/UG/2013/78601', 'Division I'),
(450, 450, 'Greenhill Academy', 'PLE/UG/2014/89762', 19, 'UCE/UG/2019/01654', 'Division I'),
(451, 451, 'Namilyango School', 'PLE/UG/2023/51870', 27, 'UCE/UG/2011/25703', 'Division I'),
(452, 452, 'Namilyango School', 'PLE/UG/2011/02252', 29, 'UCE/UG/2023/45436', 'Division II'),
(453, 453, 'Gayaza High School', 'PLE/UG/2019/82765', 5, 'UCE/UG/2021/92359', 'Division I'),
(454, 454, 'Buddo Junior', 'PLE/UG/2011/57661', 20, 'UCE/UG/2022/83618', 'Division III'),
(455, 455, 'Gayaza High School', 'PLE/UG/2010/92256', 21, 'UCE/UG/2023/04287', 'Division II'),
(456, 456, 'Gayaza High School', 'PLE/UG/2010/35972', 26, 'UCE/UG/2015/98615', 'Division III'),
(457, 457, 'Greenhill Academy', 'PLE/UG/2010/59982', 34, 'UCE/UG/2010/16657', 'Division IV'),
(458, 458, 'Namilyango School', 'PLE/UG/2014/21418', 6, 'UCE/UG/2021/78594', 'Division II'),
(459, 459, 'Namilyango School', 'PLE/UG/2014/11884', 23, 'UCE/UG/2018/37629', 'Division IV'),
(460, 460, 'Greenhill Academy', 'PLE/UG/2019/69811', 19, 'UCE/UG/2014/16947', 'Division IV'),
(461, 461, 'Gayaza High School', 'PLE/UG/2016/66178', 32, 'UCE/UG/2016/68877', 'Division I'),
(462, 462, 'Greenhill Academy', 'PLE/UG/2015/94838', 22, 'UCE/UG/2011/68950', 'Division I'),
(463, 463, 'Gayaza High School', 'PLE/UG/2022/46518', 21, 'UCE/UG/2014/07441', 'Division II'),
(464, 464, 'Ntare School', 'PLE/UG/2020/21496', 30, 'UCE/UG/2016/76809', 'Division III'),
(465, 465, 'Ntare School', 'PLE/UG/2013/75129', 34, 'UCE/UG/2017/86640', 'Division III'),
(466, 466, 'Buddo Junior', 'PLE/UG/2023/51698', 24, 'UCE/UG/2019/35364', 'Division IV'),
(467, 467, 'Namilyango School', 'PLE/UG/2013/83735', 17, 'UCE/UG/2017/49137', 'Division IV'),
(468, 468, 'Namilyango School', 'PLE/UG/2019/82490', 9, 'UCE/UG/2016/74234', 'Division II'),
(469, 469, 'Buddo Junior', 'PLE/UG/2019/04353', 11, 'UCE/UG/2010/62835', 'Division IV'),
(470, 470, 'Ntare School', 'PLE/UG/2021/99610', 17, 'UCE/UG/2012/51517', 'Division I'),
(471, 471, 'Greenhill Academy', 'PLE/UG/2020/99483', 27, 'UCE/UG/2019/05967', 'Division II'),
(472, 472, 'Ntare School', 'PLE/UG/2016/73227', 9, 'UCE/UG/2019/94445', 'Division III'),
(473, 473, 'Greenhill Academy', 'PLE/UG/2018/76994', 33, 'UCE/UG/2014/85372', 'Division II'),
(474, 474, 'Gayaza High School', 'PLE/UG/2019/52416', 24, 'UCE/UG/2018/28047', 'Division II'),
(475, 475, 'Buddo Junior', 'PLE/UG/2012/92629', 35, 'UCE/UG/2012/93893', 'Division I'),
(476, 476, 'Namilyango School', 'PLE/UG/2022/34370', 4, 'UCE/UG/2023/86711', 'Division II'),
(477, 477, 'Greenhill Academy', 'PLE/UG/2013/65255', 21, 'UCE/UG/2021/30751', 'Division I'),
(478, 478, 'Gayaza High School', 'PLE/UG/2018/98086', 6, 'UCE/UG/2015/87276', 'Division I'),
(479, 479, 'Namilyango School', 'PLE/UG/2019/48398', 13, 'UCE/UG/2010/25014', 'Division I'),
(480, 480, 'Buddo Junior', 'PLE/UG/2015/88312', 10, 'UCE/UG/2014/14255', 'Division III'),
(481, 481, 'Gayaza High School', 'PLE/UG/2020/13018', 15, 'UCE/UG/2016/16092', 'Division II'),
(482, 482, 'Namilyango School', 'PLE/UG/2022/72521', 5, 'UCE/UG/2023/84720', 'Division II'),
(483, 483, 'Buddo Junior', 'PLE/UG/2022/48149', 30, 'UCE/UG/2018/65460', 'Division II'),
(484, 484, 'Buddo Junior', 'PLE/UG/2018/59285', 10, 'UCE/UG/2014/79877', 'Division I'),
(485, 485, 'Buddo Junior', 'PLE/UG/2018/77595', 8, 'UCE/UG/2015/38259', 'Division IV'),
(486, 486, 'Ntare School', 'PLE/UG/2012/32829', 7, 'UCE/UG/2017/30849', 'Division IV'),
(487, 487, 'Namilyango School', 'PLE/UG/2022/49560', 28, 'UCE/UG/2013/09971', 'Division III'),
(488, 488, 'Buddo Junior', 'PLE/UG/2014/39824', 6, 'UCE/UG/2013/01814', 'Division II'),
(489, 489, 'Buddo Junior', 'PLE/UG/2020/69249', 10, 'UCE/UG/2022/97559', 'Division I'),
(490, 490, 'Buddo Junior', 'PLE/UG/2018/04577', 19, 'UCE/UG/2013/68767', 'Division IV'),
(491, 491, 'Ntare School', 'PLE/UG/2014/25977', 13, 'UCE/UG/2020/79776', 'Division IV'),
(492, 492, 'Ntare School', 'PLE/UG/2020/27145', 9, 'UCE/UG/2011/95914', 'Division II'),
(493, 493, 'Greenhill Academy', 'PLE/UG/2010/70053', 16, 'UCE/UG/2021/98442', 'Division II'),
(494, 494, 'Namilyango School', 'PLE/UG/2019/02424', 35, 'UCE/UG/2021/31963', 'Division I'),
(495, 495, 'Gayaza High School', 'PLE/UG/2010/99907', 35, 'UCE/UG/2021/35490', 'Division I'),
(496, 496, 'Greenhill Academy', 'PLE/UG/2022/93413', 34, 'UCE/UG/2023/92635', 'Division IV'),
(497, 497, 'Gayaza High School', 'PLE/UG/2018/94353', 34, 'UCE/UG/2023/86627', 'Division II'),
(498, 498, 'Ntare School', 'PLE/UG/2015/72893', 19, 'UCE/UG/2013/65733', 'Division III'),
(499, 499, 'Greenhill Academy', 'PLE/UG/2020/99602', 25, 'UCE/UG/2014/67104', 'Division II'),
(500, 500, 'Gayaza High School', 'PLE/UG/2023/98481', 7, 'UCE/UG/2018/58112', 'Division I'),
(501, 501, 'Gayaza High School', 'PLE/UG/2011/60923', 29, 'UCE/UG/2011/07703', 'Division I'),
(502, 502, 'Gayaza High School', 'PLE/UG/2016/98103', 23, 'UCE/UG/2010/47507', 'Division I'),
(503, 503, 'Ntare School', 'PLE/UG/2014/20642', 5, 'UCE/UG/2018/75183', 'Division I'),
(504, 504, 'Namilyango School', 'PLE/UG/2018/56429', 6, 'UCE/UG/2020/52282', 'Division II'),
(505, 505, 'Buddo Junior', 'PLE/UG/2023/59266', 7, 'UCE/UG/2021/62691', 'Division IV'),
(506, 506, 'Buddo Junior', 'PLE/UG/2015/84889', 5, 'UCE/UG/2020/44296', 'Division I'),
(507, 507, 'Gayaza High School', 'PLE/UG/2016/26662', 4, 'UCE/UG/2013/08756', 'Division IV'),
(508, 508, 'Greenhill Academy', 'PLE/UG/2010/40869', 5, 'UCE/UG/2023/72170', 'Division III'),
(509, 509, 'Greenhill Academy', 'PLE/UG/2014/02910', 12, 'UCE/UG/2012/23826', 'Division III'),
(510, 510, 'Gayaza High School', 'PLE/UG/2022/97684', 7, 'UCE/UG/2018/74639', 'Division IV'),
(511, 511, 'Gayaza High School', 'PLE/UG/2015/51310', 13, 'UCE/UG/2023/80891', 'Division I'),
(512, 512, 'Ntare School', 'PLE/UG/2023/08837', 22, 'UCE/UG/2019/58168', 'Division IV'),
(513, 513, 'Greenhill Academy', 'PLE/UG/2012/26266', 31, 'UCE/UG/2016/92587', 'Division I'),
(514, 514, 'Ntare School', 'PLE/UG/2016/72548', 12, 'UCE/UG/2011/84709', 'Division IV'),
(515, 515, 'Gayaza High School', 'PLE/UG/2014/73175', 25, 'UCE/UG/2013/10974', 'Division IV'),
(516, 516, 'Buddo Junior', 'PLE/UG/2015/81130', 31, 'UCE/UG/2022/72989', 'Division I'),
(517, 517, 'Greenhill Academy', 'PLE/UG/2019/72175', 20, 'UCE/UG/2016/74583', 'Division II'),
(518, 518, 'Gayaza High School', 'PLE/UG/2010/06825', 10, 'UCE/UG/2022/65815', 'Division III'),
(519, 519, 'Gayaza High School', 'PLE/UG/2023/08874', 20, 'UCE/UG/2015/34293', 'Division III'),
(520, 520, 'Ntare School', 'PLE/UG/2015/13875', 23, 'UCE/UG/2018/35062', 'Division IV'),
(521, 521, 'Gayaza High School', 'PLE/UG/2015/05695', 6, 'UCE/UG/2012/67242', 'Division IV'),
(522, 522, 'Namilyango School', 'PLE/UG/2018/65954', 21, 'UCE/UG/2021/44401', 'Division III'),
(523, 523, 'Gayaza High School', 'PLE/UG/2021/05850', 29, 'UCE/UG/2021/75019', 'Division II'),
(524, 524, 'Greenhill Academy', 'PLE/UG/2017/12579', 6, 'UCE/UG/2023/74172', 'Division III'),
(525, 525, 'Ntare School', 'PLE/UG/2018/48447', 21, 'UCE/UG/2014/08449', 'Division II'),
(526, 526, 'Greenhill Academy', 'PLE/UG/2012/01384', 22, 'UCE/UG/2022/63822', 'Division III'),
(527, 527, 'Buddo Junior', 'PLE/UG/2010/48762', 12, 'UCE/UG/2021/48358', 'Division IV'),
(528, 528, 'Buddo Junior', 'PLE/UG/2017/48533', 28, 'UCE/UG/2015/68916', 'Division I'),
(529, 529, 'Ntare School', 'PLE/UG/2017/07555', 29, 'UCE/UG/2021/72055', 'Division I'),
(530, 530, 'Greenhill Academy', 'PLE/UG/2023/27396', 19, 'UCE/UG/2017/21430', 'Division II'),
(531, 531, 'Greenhill Academy', 'PLE/UG/2014/95336', 27, 'UCE/UG/2022/09369', 'Division IV'),
(532, 532, 'Gayaza High School', 'PLE/UG/2016/39598', 20, 'UCE/UG/2015/55126', 'Division II'),
(533, 533, 'Greenhill Academy', 'PLE/UG/2020/39488', 26, 'UCE/UG/2013/22887', 'Division II'),
(534, 534, 'Gayaza High School', 'PLE/UG/2017/01353', 15, 'UCE/UG/2021/04262', 'Division III'),
(535, 535, 'Gayaza High School', 'PLE/UG/2016/42918', 26, 'UCE/UG/2014/28690', 'Division III'),
(536, 536, 'Namilyango School', 'PLE/UG/2011/16829', 23, 'UCE/UG/2016/67545', 'Division IV'),
(537, 537, 'Gayaza High School', 'PLE/UG/2011/06433', 33, 'UCE/UG/2015/19357', 'Division IV'),
(538, 538, 'Gayaza High School', 'PLE/UG/2019/36886', 28, 'UCE/UG/2020/40931', 'Division IV'),
(539, 539, 'Namilyango School', 'PLE/UG/2022/11637', 31, 'UCE/UG/2022/02620', 'Division II'),
(540, 540, 'Namilyango School', 'PLE/UG/2023/43391', 15, 'UCE/UG/2017/48734', 'Division IV'),
(541, 541, 'Greenhill Academy', 'PLE/UG/2021/78417', 15, 'UCE/UG/2017/39064', 'Division II'),
(542, 542, 'Greenhill Academy', 'PLE/UG/2012/96278', 14, 'UCE/UG/2020/62940', 'Division IV'),
(543, 543, 'Greenhill Academy', 'PLE/UG/2013/64301', 21, 'UCE/UG/2021/30587', 'Division I'),
(544, 544, 'Ntare School', 'PLE/UG/2012/27338', 27, 'UCE/UG/2022/19642', 'Division II'),
(545, 545, 'Namilyango School', 'PLE/UG/2016/72176', 11, 'UCE/UG/2011/63888', 'Division IV'),
(546, 546, 'Gayaza High School', 'PLE/UG/2013/29572', 30, 'UCE/UG/2013/72637', 'Division IV'),
(547, 547, 'Ntare School', 'PLE/UG/2019/99695', 34, 'UCE/UG/2021/24452', 'Division III'),
(548, 548, 'Greenhill Academy', 'PLE/UG/2022/05384', 21, 'UCE/UG/2017/13843', 'Division I'),
(549, 549, 'Buddo Junior', 'PLE/UG/2019/14796', 25, 'UCE/UG/2021/27273', 'Division IV'),
(550, 550, 'Buddo Junior', 'PLE/UG/2019/19697', 4, 'UCE/UG/2016/37061', 'Division II'),
(551, 551, 'Gayaza High School', 'PLE/UG/2015/18833', 26, 'UCE/UG/2022/45049', 'Division III'),
(552, 552, 'Gayaza High School', 'PLE/UG/2010/33837', 20, 'UCE/UG/2017/18367', 'Division II'),
(553, 553, 'Ntare School', 'PLE/UG/2020/05203', 6, 'UCE/UG/2012/80757', 'Division II'),
(554, 554, 'Greenhill Academy', 'PLE/UG/2021/06441', 32, 'UCE/UG/2014/86989', 'Division II'),
(555, 555, 'Gayaza High School', 'PLE/UG/2018/17893', 7, 'UCE/UG/2023/60357', 'Division I');
INSERT INTO `academichistory` (`HistoryID`, `StudentID`, `FormerSchool`, `PLEIndexNumber`, `PLEAggregate`, `UCEIndexNumber`, `UCEResult`) VALUES
(556, 556, 'Namilyango School', 'PLE/UG/2010/70024', 19, 'UCE/UG/2015/47949', 'Division I'),
(557, 557, 'Ntare School', 'PLE/UG/2016/84022', 28, 'UCE/UG/2014/42487', 'Division I'),
(558, 558, 'Buddo Junior', 'PLE/UG/2017/57708', 13, 'UCE/UG/2020/82812', 'Division IV'),
(559, 559, 'Namilyango School', 'PLE/UG/2017/24371', 20, 'UCE/UG/2021/63891', 'Division III'),
(560, 560, 'Ntare School', 'PLE/UG/2020/22821', 30, 'UCE/UG/2017/11486', 'Division IV'),
(561, 561, 'Namilyango School', 'PLE/UG/2019/85763', 11, 'UCE/UG/2019/54395', 'Division IV'),
(562, 562, 'Greenhill Academy', 'PLE/UG/2018/51658', 29, 'UCE/UG/2015/64490', 'Division I'),
(563, 563, 'Gayaza High School', 'PLE/UG/2014/87183', 14, 'UCE/UG/2011/35898', 'Division III'),
(564, 564, 'Ntare School', 'PLE/UG/2021/80149', 19, 'UCE/UG/2010/66451', 'Division I'),
(565, 565, 'Greenhill Academy', 'PLE/UG/2016/45074', 31, 'UCE/UG/2023/11116', 'Division III'),
(566, 566, 'Namilyango School', 'PLE/UG/2023/41461', 9, 'UCE/UG/2018/56216', 'Division IV'),
(567, 567, 'Ntare School', 'PLE/UG/2020/35988', 19, 'UCE/UG/2015/39123', 'Division IV'),
(568, 568, 'Buddo Junior', 'PLE/UG/2019/45970', 13, 'UCE/UG/2012/83055', 'Division III'),
(569, 569, 'Gayaza High School', 'PLE/UG/2018/16799', 34, 'UCE/UG/2014/67872', 'Division II'),
(570, 570, 'Greenhill Academy', 'PLE/UG/2013/63044', 17, 'UCE/UG/2014/16035', 'Division IV'),
(571, 571, 'Greenhill Academy', 'PLE/UG/2018/34683', 30, 'UCE/UG/2011/10624', 'Division I'),
(572, 572, 'Ntare School', 'PLE/UG/2017/64637', 20, 'UCE/UG/2019/71606', 'Division III'),
(573, 573, 'Greenhill Academy', 'PLE/UG/2015/36409', 21, 'UCE/UG/2019/60865', 'Division I'),
(574, 574, 'Gayaza High School', 'PLE/UG/2012/97027', 11, 'UCE/UG/2013/50470', 'Division IV'),
(575, 575, 'Buddo Junior', 'PLE/UG/2011/15917', 19, 'UCE/UG/2022/10894', 'Division IV'),
(576, 576, 'Buddo Junior', 'PLE/UG/2016/30999', 7, 'UCE/UG/2017/50789', 'Division IV'),
(577, 577, 'Gayaza High School', 'PLE/UG/2022/37100', 10, 'UCE/UG/2023/03790', 'Division II'),
(578, 578, 'Gayaza High School', 'PLE/UG/2010/45394', 9, 'UCE/UG/2016/73222', 'Division II'),
(579, 579, 'Namilyango School', 'PLE/UG/2012/39579', 20, 'UCE/UG/2016/65163', 'Division IV'),
(580, 580, 'Namilyango School', 'PLE/UG/2016/21823', 26, 'UCE/UG/2021/15385', 'Division I'),
(581, 581, 'Greenhill Academy', 'PLE/UG/2018/25436', 20, 'UCE/UG/2022/75862', 'Division I'),
(582, 582, 'Ntare School', 'PLE/UG/2010/59131', 31, 'UCE/UG/2016/85916', 'Division IV'),
(583, 583, 'Namilyango School', 'PLE/UG/2022/31754', 30, 'UCE/UG/2011/13953', 'Division II'),
(584, 584, 'Buddo Junior', 'PLE/UG/2019/28752', 19, 'UCE/UG/2017/21428', 'Division II'),
(585, 585, 'Buddo Junior', 'PLE/UG/2013/35271', 4, 'UCE/UG/2023/88872', 'Division II'),
(586, 586, 'Ntare School', 'PLE/UG/2012/21843', 24, 'UCE/UG/2017/79473', 'Division II'),
(587, 587, 'Namilyango School', 'PLE/UG/2022/41489', 15, 'UCE/UG/2017/47058', 'Division IV'),
(588, 588, 'Namilyango School', 'PLE/UG/2019/09373', 17, 'UCE/UG/2020/55243', 'Division II'),
(589, 589, 'Namilyango School', 'PLE/UG/2020/28351', 8, 'UCE/UG/2022/93259', 'Division I'),
(590, 590, 'Namilyango School', 'PLE/UG/2013/93496', 35, 'UCE/UG/2011/72771', 'Division I'),
(591, 591, 'Ntare School', 'PLE/UG/2015/72345', 17, 'UCE/UG/2022/26727', 'Division III'),
(592, 592, 'Buddo Junior', 'PLE/UG/2020/05068', 32, 'UCE/UG/2015/17707', 'Division III'),
(593, 593, 'Ntare School', 'PLE/UG/2017/12545', 7, 'UCE/UG/2012/45242', 'Division IV'),
(594, 594, 'Greenhill Academy', 'PLE/UG/2019/50349', 18, 'UCE/UG/2021/55534', 'Division II'),
(595, 595, 'Namilyango School', 'PLE/UG/2016/22878', 25, 'UCE/UG/2018/17597', 'Division IV'),
(596, 596, 'Buddo Junior', 'PLE/UG/2020/72155', 14, 'UCE/UG/2016/22580', 'Division IV'),
(597, 597, 'Greenhill Academy', 'PLE/UG/2014/92375', 27, 'UCE/UG/2023/44496', 'Division II'),
(598, 598, 'Greenhill Academy', 'PLE/UG/2018/03332', 17, 'UCE/UG/2010/05111', 'Division I'),
(599, 599, 'Ntare School', 'PLE/UG/2023/39143', 6, 'UCE/UG/2013/03648', 'Division II'),
(600, 600, 'Namilyango School', 'PLE/UG/2020/67064', 7, 'UCE/UG/2018/63342', 'Division II'),
(601, 601, 'Ntare School', 'PLE/UG/2023/05134', 17, 'UCE/UG/2010/71965', 'Division III'),
(602, 602, 'Buddo Junior', 'PLE/UG/2020/68851', 7, 'UCE/UG/2016/88294', 'Division I'),
(603, 603, 'Greenhill Academy', 'PLE/UG/2010/48392', 13, 'UCE/UG/2023/12334', 'Division III'),
(604, 604, 'Namilyango School', 'PLE/UG/2014/52376', 21, 'UCE/UG/2012/38239', 'Division II'),
(605, 605, 'Gayaza High School', 'PLE/UG/2013/60522', 10, 'UCE/UG/2011/08786', 'Division I'),
(606, 606, 'Namilyango School', 'PLE/UG/2022/04170', 19, 'UCE/UG/2013/72751', 'Division IV'),
(607, 607, 'Ntare School', 'PLE/UG/2011/98168', 23, 'UCE/UG/2010/35897', 'Division III'),
(608, 608, 'Buddo Junior', 'PLE/UG/2018/67205', 21, 'UCE/UG/2019/89017', 'Division II'),
(609, 609, 'Gayaza High School', 'PLE/UG/2020/76077', 23, 'UCE/UG/2020/94994', 'Division II'),
(610, 610, 'Greenhill Academy', 'PLE/UG/2020/83700', 33, 'UCE/UG/2011/88908', 'Division I'),
(611, 611, 'Namilyango School', 'PLE/UG/2011/58165', 20, 'UCE/UG/2022/84371', 'Division III'),
(612, 612, 'Buddo Junior', 'PLE/UG/2010/73573', 25, 'UCE/UG/2011/46928', 'Division I'),
(613, 613, 'Namilyango School', 'PLE/UG/2023/27270', 18, 'UCE/UG/2016/80592', 'Division III'),
(614, 614, 'Ntare School', 'PLE/UG/2011/10777', 7, 'UCE/UG/2014/09913', 'Division III'),
(615, 615, 'Buddo Junior', 'PLE/UG/2012/04465', 22, 'UCE/UG/2020/10806', 'Division I'),
(616, 616, 'Greenhill Academy', 'PLE/UG/2014/72460', 22, 'UCE/UG/2021/16810', 'Division II'),
(617, 617, 'Greenhill Academy', 'PLE/UG/2021/84518', 25, 'UCE/UG/2020/77262', 'Division III'),
(618, 618, 'Greenhill Academy', 'PLE/UG/2022/79933', 11, 'UCE/UG/2021/34695', 'Division II'),
(619, 619, 'Namilyango School', 'PLE/UG/2014/99708', 6, 'UCE/UG/2014/51260', 'Division III'),
(620, 620, 'Buddo Junior', 'PLE/UG/2021/10122', 4, 'UCE/UG/2021/92988', 'Division II'),
(621, 621, 'Greenhill Academy', 'PLE/UG/2020/82479', 32, 'UCE/UG/2010/41224', 'Division IV'),
(622, 622, 'Buddo Junior', 'PLE/UG/2012/44542', 27, 'UCE/UG/2015/62437', 'Division I'),
(623, 623, 'Buddo Junior', 'PLE/UG/2013/09255', 29, 'UCE/UG/2019/05262', 'Division I'),
(624, 624, 'Buddo Junior', 'PLE/UG/2016/34782', 13, 'UCE/UG/2016/34741', 'Division II'),
(625, 625, 'Namilyango School', 'PLE/UG/2016/25262', 29, 'UCE/UG/2013/93468', 'Division IV'),
(626, 626, 'Ntare School', 'PLE/UG/2013/59313', 8, 'UCE/UG/2022/16890', 'Division I'),
(627, 627, 'Gayaza High School', 'PLE/UG/2016/56965', 18, 'UCE/UG/2018/61484', 'Division II'),
(628, 628, 'Gayaza High School', 'PLE/UG/2010/34800', 25, 'UCE/UG/2013/39434', 'Division I'),
(629, 629, 'Greenhill Academy', 'PLE/UG/2016/49897', 5, 'UCE/UG/2020/71129', 'Division I'),
(630, 630, 'Greenhill Academy', 'PLE/UG/2012/91837', 8, 'UCE/UG/2023/25137', 'Division II'),
(631, 631, 'Namilyango School', 'PLE/UG/2019/39622', 32, 'UCE/UG/2013/73684', 'Division IV'),
(632, 632, 'Greenhill Academy', 'PLE/UG/2021/43389', 24, 'UCE/UG/2022/42555', 'Division III'),
(633, 633, 'Namilyango School', 'PLE/UG/2011/34128', 16, 'UCE/UG/2023/69264', 'Division III'),
(634, 634, 'Ntare School', 'PLE/UG/2019/61255', 4, 'UCE/UG/2014/46251', 'Division II'),
(635, 635, 'Greenhill Academy', 'PLE/UG/2013/78919', 7, 'UCE/UG/2012/52021', 'Division I'),
(636, 636, 'Buddo Junior', 'PLE/UG/2018/12018', 27, 'UCE/UG/2013/21020', 'Division I'),
(637, 637, 'Gayaza High School', 'PLE/UG/2020/76721', 20, 'UCE/UG/2014/94628', 'Division IV'),
(638, 638, 'Greenhill Academy', 'PLE/UG/2013/32244', 34, 'UCE/UG/2021/10387', 'Division I'),
(639, 639, 'Ntare School', 'PLE/UG/2019/74594', 25, 'UCE/UG/2010/29157', 'Division II'),
(640, 640, 'Greenhill Academy', 'PLE/UG/2017/79998', 17, 'UCE/UG/2019/99798', 'Division I'),
(641, 641, 'Ntare School', 'PLE/UG/2023/03196', 15, 'UCE/UG/2019/27043', 'Division II'),
(642, 642, 'Buddo Junior', 'PLE/UG/2020/51590', 14, 'UCE/UG/2012/82140', 'Division III'),
(643, 643, 'Gayaza High School', 'PLE/UG/2021/30003', 34, 'UCE/UG/2023/79718', 'Division I'),
(644, 644, 'Gayaza High School', 'PLE/UG/2021/32947', 7, 'UCE/UG/2018/72737', 'Division IV'),
(645, 645, 'Buddo Junior', 'PLE/UG/2021/36897', 12, 'UCE/UG/2013/51908', 'Division IV'),
(646, 646, 'Gayaza High School', 'PLE/UG/2020/71216', 14, 'UCE/UG/2016/23027', 'Division IV'),
(647, 647, 'Greenhill Academy', 'PLE/UG/2013/12270', 34, 'UCE/UG/2015/21248', 'Division IV'),
(648, 648, 'Namilyango School', 'PLE/UG/2018/30406', 29, 'UCE/UG/2010/84173', 'Division I'),
(649, 649, 'Ntare School', 'PLE/UG/2015/47114', 6, 'UCE/UG/2023/55685', 'Division IV'),
(650, 650, 'Gayaza High School', 'PLE/UG/2012/12524', 35, 'UCE/UG/2017/86951', 'Division III'),
(651, 651, 'Namilyango School', 'PLE/UG/2010/81828', 4, 'UCE/UG/2018/10881', 'Division III'),
(652, 652, 'Namilyango School', 'PLE/UG/2023/80508', 5, 'UCE/UG/2021/05511', 'Division III'),
(653, 653, 'Ntare School', 'PLE/UG/2011/12893', 12, 'UCE/UG/2023/09028', 'Division III'),
(654, 654, 'Namilyango School', 'PLE/UG/2017/59810', 13, 'UCE/UG/2018/22926', 'Division II'),
(655, 655, 'Gayaza High School', 'PLE/UG/2019/32146', 23, 'UCE/UG/2011/67964', 'Division I'),
(656, 656, 'Buddo Junior', 'PLE/UG/2016/51281', 8, 'UCE/UG/2011/24497', 'Division IV'),
(657, 657, 'Namilyango School', 'PLE/UG/2019/94112', 24, 'UCE/UG/2015/93857', 'Division III'),
(658, 658, 'Greenhill Academy', 'PLE/UG/2017/10629', 30, 'UCE/UG/2022/91792', 'Division IV'),
(659, 659, 'Namilyango School', 'PLE/UG/2010/93924', 21, 'UCE/UG/2023/18502', 'Division I'),
(660, 660, 'Greenhill Academy', 'PLE/UG/2013/25087', 22, 'UCE/UG/2011/76467', 'Division III'),
(661, 661, 'Buddo Junior', 'PLE/UG/2014/07951', 20, 'UCE/UG/2014/08217', 'Division II'),
(662, 662, 'Gayaza High School', 'PLE/UG/2023/93323', 30, 'UCE/UG/2014/04555', 'Division II'),
(663, 663, 'Greenhill Academy', 'PLE/UG/2022/15940', 4, 'UCE/UG/2019/21804', 'Division I'),
(664, 664, 'Namilyango School', 'PLE/UG/2014/36190', 29, 'UCE/UG/2023/26588', 'Division III'),
(665, 665, 'Ntare School', 'PLE/UG/2013/64245', 19, 'UCE/UG/2016/80966', 'Division III'),
(666, 666, 'Gayaza High School', 'PLE/UG/2014/84697', 15, 'UCE/UG/2012/93859', 'Division I'),
(667, 667, 'Ntare School', 'PLE/UG/2012/54887', 9, 'UCE/UG/2012/36204', 'Division II'),
(668, 668, 'Greenhill Academy', 'PLE/UG/2016/62031', 26, 'UCE/UG/2018/05572', 'Division II'),
(669, 669, 'Greenhill Academy', 'PLE/UG/2017/59072', 17, 'UCE/UG/2014/40299', 'Division I'),
(670, 670, 'Gayaza High School', 'PLE/UG/2018/15097', 35, 'UCE/UG/2017/56253', 'Division II'),
(671, 671, 'Namilyango School', 'PLE/UG/2014/37323', 30, 'UCE/UG/2010/77132', 'Division III'),
(672, 672, 'Buddo Junior', 'PLE/UG/2021/16652', 16, 'UCE/UG/2015/86973', 'Division I'),
(673, 673, 'Buddo Junior', 'PLE/UG/2017/49412', 33, 'UCE/UG/2010/53724', 'Division III'),
(674, 674, 'Gayaza High School', 'PLE/UG/2017/85517', 25, 'UCE/UG/2021/18050', 'Division II'),
(675, 675, 'Greenhill Academy', 'PLE/UG/2020/28523', 9, 'UCE/UG/2023/26742', 'Division II'),
(676, 676, 'Gayaza High School', 'PLE/UG/2015/88094', 12, 'UCE/UG/2020/82638', 'Division IV'),
(677, 677, 'Greenhill Academy', 'PLE/UG/2012/34104', 7, 'UCE/UG/2017/42325', 'Division II'),
(678, 678, 'Greenhill Academy', 'PLE/UG/2016/79218', 19, 'UCE/UG/2023/46738', 'Division II'),
(679, 679, 'Buddo Junior', 'PLE/UG/2010/88574', 17, 'UCE/UG/2015/74873', 'Division III'),
(680, 680, 'Greenhill Academy', 'PLE/UG/2017/13211', 8, 'UCE/UG/2013/78428', 'Division I'),
(681, 681, 'Namilyango School', 'PLE/UG/2019/42396', 35, 'UCE/UG/2018/19820', 'Division I'),
(682, 682, 'Buddo Junior', 'PLE/UG/2020/53960', 15, 'UCE/UG/2011/57721', 'Division III'),
(683, 683, 'Gayaza High School', 'PLE/UG/2012/10753', 33, 'UCE/UG/2014/97002', 'Division IV'),
(684, 684, 'Gayaza High School', 'PLE/UG/2021/05645', 31, 'UCE/UG/2012/17469', 'Division II'),
(685, 685, 'Gayaza High School', 'PLE/UG/2019/27640', 15, 'UCE/UG/2022/47945', 'Division III'),
(686, 686, 'Buddo Junior', 'PLE/UG/2014/24361', 14, 'UCE/UG/2022/35801', 'Division I'),
(687, 687, 'Buddo Junior', 'PLE/UG/2020/63827', 34, 'UCE/UG/2022/42952', 'Division III'),
(688, 688, 'Gayaza High School', 'PLE/UG/2014/79725', 5, 'UCE/UG/2021/06507', 'Division IV'),
(689, 689, 'Ntare School', 'PLE/UG/2021/88807', 34, 'UCE/UG/2010/36340', 'Division III'),
(690, 690, 'Greenhill Academy', 'PLE/UG/2016/79628', 22, 'UCE/UG/2016/45749', 'Division IV'),
(691, 691, 'Buddo Junior', 'PLE/UG/2014/19328', 4, 'UCE/UG/2017/57238', 'Division II'),
(692, 692, 'Gayaza High School', 'PLE/UG/2019/68438', 18, 'UCE/UG/2012/44620', 'Division IV'),
(693, 693, 'Namilyango School', 'PLE/UG/2023/79199', 35, 'UCE/UG/2016/46752', 'Division IV'),
(694, 694, 'Greenhill Academy', 'PLE/UG/2010/34104', 23, 'UCE/UG/2023/12070', 'Division III'),
(695, 695, 'Greenhill Academy', 'PLE/UG/2016/62595', 24, 'UCE/UG/2014/78930', 'Division IV'),
(696, 696, 'Ntare School', 'PLE/UG/2017/51877', 34, 'UCE/UG/2013/30494', 'Division IV'),
(697, 697, 'Namilyango School', 'PLE/UG/2015/67725', 11, 'UCE/UG/2011/92278', 'Division I'),
(698, 698, 'Namilyango School', 'PLE/UG/2012/87464', 28, 'UCE/UG/2013/81886', 'Division II'),
(699, 699, 'Namilyango School', 'PLE/UG/2011/54858', 15, 'UCE/UG/2012/78748', 'Division II'),
(700, 700, 'Buddo Junior', 'PLE/UG/2010/89452', 16, 'UCE/UG/2013/07829', 'Division III'),
(701, 701, 'Gayaza High School', 'PLE/UG/2017/87329', 26, 'UCE/UG/2022/48699', 'Division III'),
(702, 702, 'Ntare School', 'PLE/UG/2022/86179', 25, 'UCE/UG/2021/91881', 'Division I'),
(703, 703, 'Namilyango School', 'PLE/UG/2015/96645', 24, 'UCE/UG/2013/28841', 'Division III'),
(704, 704, 'Greenhill Academy', 'PLE/UG/2022/50864', 32, 'UCE/UG/2010/29879', 'Division II'),
(705, 705, 'Namilyango School', 'PLE/UG/2019/35773', 25, 'UCE/UG/2013/36852', 'Division I'),
(706, 706, 'Namilyango School', 'PLE/UG/2017/69998', 29, 'UCE/UG/2022/03821', 'Division III'),
(707, 707, 'Greenhill Academy', 'PLE/UG/2011/49593', 9, 'UCE/UG/2016/64416', 'Division IV'),
(708, 708, 'Buddo Junior', 'PLE/UG/2013/40380', 10, 'UCE/UG/2022/64866', 'Division III'),
(709, 709, 'Namilyango School', 'PLE/UG/2018/90366', 26, 'UCE/UG/2020/82951', 'Division IV'),
(710, 710, 'Greenhill Academy', 'PLE/UG/2012/44253', 23, 'UCE/UG/2018/42737', 'Division I'),
(711, 711, 'Gayaza High School', 'PLE/UG/2011/36261', 19, 'UCE/UG/2015/47810', 'Division I'),
(712, 712, 'Namilyango School', 'PLE/UG/2021/04568', 28, 'UCE/UG/2020/49634', 'Division I'),
(713, 713, 'Buddo Junior', 'PLE/UG/2021/02087', 21, 'UCE/UG/2020/04362', 'Division IV'),
(714, 714, 'Buddo Junior', 'PLE/UG/2022/27661', 25, 'UCE/UG/2016/39470', 'Division III'),
(715, 715, 'Ntare School', 'PLE/UG/2013/58021', 10, 'UCE/UG/2014/82979', 'Division II'),
(716, 716, 'Gayaza High School', 'PLE/UG/2012/82941', 22, 'UCE/UG/2014/03357', 'Division I'),
(717, 717, 'Ntare School', 'PLE/UG/2011/87354', 5, 'UCE/UG/2018/86317', 'Division III'),
(718, 718, 'Namilyango School', 'PLE/UG/2011/07941', 6, 'UCE/UG/2013/83055', 'Division II'),
(719, 719, 'Buddo Junior', 'PLE/UG/2023/90136', 24, 'UCE/UG/2016/28906', 'Division I'),
(720, 720, 'Gayaza High School', 'PLE/UG/2010/53391', 21, 'UCE/UG/2012/12013', 'Division I'),
(721, 721, 'Ntare School', 'PLE/UG/2014/01014', 5, 'UCE/UG/2013/20857', 'Division I'),
(722, 722, 'Buddo Junior', 'PLE/UG/2019/49501', 17, 'UCE/UG/2018/69029', 'Division III'),
(723, 723, 'Namilyango School', 'PLE/UG/2020/52385', 16, 'UCE/UG/2015/85181', 'Division I'),
(724, 724, 'Gayaza High School', 'PLE/UG/2022/73356', 34, 'UCE/UG/2018/18096', 'Division I'),
(725, 725, 'Namilyango School', 'PLE/UG/2012/30208', 4, 'UCE/UG/2012/71473', 'Division I'),
(726, 726, 'Ntare School', 'PLE/UG/2017/51139', 32, 'UCE/UG/2023/20059', 'Division I'),
(727, 727, 'Namilyango School', 'PLE/UG/2012/77690', 15, 'UCE/UG/2016/36663', 'Division II'),
(728, 728, 'Gayaza High School', 'PLE/UG/2013/08528', 28, 'UCE/UG/2018/66515', 'Division III'),
(729, 729, 'Gayaza High School', 'PLE/UG/2014/93527', 24, 'UCE/UG/2016/23435', 'Division IV'),
(730, 730, 'Gayaza High School', 'PLE/UG/2014/62918', 10, 'UCE/UG/2012/16367', 'Division II'),
(731, 731, 'Greenhill Academy', 'PLE/UG/2012/99072', 15, 'UCE/UG/2022/34357', 'Division I'),
(732, 732, 'Buddo Junior', 'PLE/UG/2016/09627', 5, 'UCE/UG/2023/74886', 'Division IV'),
(733, 733, 'Namilyango School', 'PLE/UG/2011/54744', 13, 'UCE/UG/2022/60085', 'Division II'),
(734, 734, 'Greenhill Academy', 'PLE/UG/2021/26167', 30, 'UCE/UG/2015/51230', 'Division II'),
(735, 735, 'Greenhill Academy', 'PLE/UG/2020/85252', 6, 'UCE/UG/2021/84473', 'Division IV'),
(736, 736, 'Buddo Junior', 'PLE/UG/2010/17291', 31, 'UCE/UG/2019/01478', 'Division IV'),
(737, 737, 'Gayaza High School', 'PLE/UG/2013/52614', 33, 'UCE/UG/2023/20088', 'Division I'),
(738, 738, 'Namilyango School', 'PLE/UG/2020/36866', 25, 'UCE/UG/2012/92937', 'Division I'),
(739, 739, 'Greenhill Academy', 'PLE/UG/2015/40349', 29, 'UCE/UG/2020/37796', 'Division III'),
(740, 740, 'Ntare School', 'PLE/UG/2019/68962', 18, 'UCE/UG/2012/47718', 'Division IV'),
(741, 741, 'Greenhill Academy', 'PLE/UG/2023/30458', 23, 'UCE/UG/2012/89607', 'Division I'),
(742, 742, 'Greenhill Academy', 'PLE/UG/2011/89164', 5, 'UCE/UG/2018/76547', 'Division I'),
(743, 743, 'Ntare School', 'PLE/UG/2016/90256', 8, 'UCE/UG/2023/34734', 'Division IV'),
(744, 744, 'Greenhill Academy', 'PLE/UG/2010/30100', 15, 'UCE/UG/2023/72405', 'Division III'),
(745, 745, 'Buddo Junior', 'PLE/UG/2022/25679', 26, 'UCE/UG/2019/33360', 'Division III'),
(746, 746, 'Ntare School', 'PLE/UG/2019/14482', 26, 'UCE/UG/2010/98007', 'Division IV'),
(747, 747, 'Greenhill Academy', 'PLE/UG/2015/17013', 25, 'UCE/UG/2022/56005', 'Division I'),
(748, 748, 'Namilyango School', 'PLE/UG/2020/37060', 24, 'UCE/UG/2011/61279', 'Division III'),
(749, 749, 'Ntare School', 'PLE/UG/2017/07826', 28, 'UCE/UG/2018/58635', 'Division I'),
(750, 750, 'Gayaza High School', 'PLE/UG/2020/01659', 27, 'UCE/UG/2019/20538', 'Division IV'),
(751, 751, 'Gayaza High School', 'PLE/UG/2014/63726', 13, 'UCE/UG/2016/63704', 'Division III'),
(752, 752, 'Gayaza High School', 'PLE/UG/2016/36206', 19, 'UCE/UG/2015/43230', 'Division I'),
(753, 753, 'Greenhill Academy', 'PLE/UG/2021/30661', 4, 'UCE/UG/2011/53957', 'Division II'),
(754, 754, 'Buddo Junior', 'PLE/UG/2011/49712', 6, 'UCE/UG/2023/48073', 'Division III'),
(755, 755, 'Greenhill Academy', 'PLE/UG/2012/88337', 34, 'UCE/UG/2011/61557', 'Division IV'),
(756, 756, 'Gayaza High School', 'PLE/UG/2023/96723', 33, 'UCE/UG/2019/78889', 'Division IV'),
(757, 757, 'Greenhill Academy', 'PLE/UG/2019/33239', 26, 'UCE/UG/2016/34573', 'Division II'),
(758, 758, 'Buddo Junior', 'PLE/UG/2011/23085', 32, 'UCE/UG/2021/31848', 'Division I'),
(759, 759, 'Buddo Junior', 'PLE/UG/2010/41103', 33, 'UCE/UG/2014/88992', 'Division II'),
(760, 760, 'Greenhill Academy', 'PLE/UG/2014/08927', 20, 'UCE/UG/2014/01158', 'Division I'),
(761, 761, 'Buddo Junior', 'PLE/UG/2023/50441', 26, 'UCE/UG/2023/70967', 'Division III'),
(762, 762, 'Gayaza High School', 'PLE/UG/2017/50018', 32, 'UCE/UG/2023/20210', 'Division I'),
(763, 763, 'Buddo Junior', 'PLE/UG/2017/45542', 23, 'UCE/UG/2019/49087', 'Division II'),
(764, 764, 'Greenhill Academy', 'PLE/UG/2022/68013', 27, 'UCE/UG/2018/96517', 'Division IV'),
(765, 765, 'Buddo Junior', 'PLE/UG/2010/89212', 14, 'UCE/UG/2023/90573', 'Division III'),
(766, 766, 'Buddo Junior', 'PLE/UG/2010/84837', 9, 'UCE/UG/2013/83352', 'Division II'),
(767, 767, 'Ntare School', 'PLE/UG/2019/83008', 9, 'UCE/UG/2015/41627', 'Division IV'),
(768, 768, 'Ntare School', 'PLE/UG/2012/62537', 19, 'UCE/UG/2018/44692', 'Division II'),
(769, 769, 'Greenhill Academy', 'PLE/UG/2023/25694', 15, 'UCE/UG/2010/14062', 'Division III'),
(770, 770, 'Greenhill Academy', 'PLE/UG/2010/73878', 19, 'UCE/UG/2013/67453', 'Division III'),
(771, 771, 'Gayaza High School', 'PLE/UG/2019/56380', 26, 'UCE/UG/2022/21040', 'Division II'),
(772, 772, 'Ntare School', 'PLE/UG/2014/00588', 35, 'UCE/UG/2022/42548', 'Division III'),
(773, 773, 'Namilyango School', 'PLE/UG/2019/10810', 21, 'UCE/UG/2016/57321', 'Division III'),
(774, 774, 'Namilyango School', 'PLE/UG/2023/48372', 19, 'UCE/UG/2023/24218', 'Division II'),
(775, 775, 'Greenhill Academy', 'PLE/UG/2020/01154', 32, 'UCE/UG/2015/35578', 'Division III'),
(776, 776, 'Buddo Junior', 'PLE/UG/2020/80954', 31, 'UCE/UG/2021/57661', 'Division II'),
(777, 777, 'Ntare School', 'PLE/UG/2020/52212', 14, 'UCE/UG/2010/32710', 'Division II'),
(778, 778, 'Namilyango School', 'PLE/UG/2021/07240', 31, 'UCE/UG/2011/97207', 'Division III'),
(779, 779, 'Buddo Junior', 'PLE/UG/2014/77642', 31, 'UCE/UG/2022/02217', 'Division II'),
(780, 780, 'Greenhill Academy', 'PLE/UG/2018/16682', 4, 'UCE/UG/2017/68092', 'Division IV'),
(781, 781, 'Gayaza High School', 'PLE/UG/2010/97846', 29, 'UCE/UG/2010/86259', 'Division I'),
(782, 782, 'Ntare School', 'PLE/UG/2014/84432', 13, 'UCE/UG/2023/86253', 'Division II'),
(783, 783, 'Buddo Junior', 'PLE/UG/2017/97994', 10, 'UCE/UG/2010/47683', 'Division II'),
(784, 784, 'Greenhill Academy', 'PLE/UG/2017/33195', 34, 'UCE/UG/2021/09767', 'Division I'),
(785, 785, 'Namilyango School', 'PLE/UG/2010/79826', 31, 'UCE/UG/2021/71452', 'Division I'),
(786, 786, 'Ntare School', 'PLE/UG/2010/68579', 15, 'UCE/UG/2019/41362', 'Division IV'),
(787, 787, 'Buddo Junior', 'PLE/UG/2022/15077', 7, 'UCE/UG/2011/15301', 'Division II'),
(788, 788, 'Buddo Junior', 'PLE/UG/2021/85632', 29, 'UCE/UG/2015/49197', 'Division II'),
(789, 789, 'Namilyango School', 'PLE/UG/2017/32136', 32, 'UCE/UG/2016/82025', 'Division III'),
(790, 790, 'Ntare School', 'PLE/UG/2014/75951', 33, 'UCE/UG/2014/71699', 'Division III'),
(791, 791, 'Greenhill Academy', 'PLE/UG/2011/80049', 25, 'UCE/UG/2022/56117', 'Division I'),
(792, 792, 'Ntare School', 'PLE/UG/2017/92613', 6, 'UCE/UG/2019/01205', 'Division I'),
(793, 793, 'Gayaza High School', 'PLE/UG/2012/01124', 22, 'UCE/UG/2022/80184', 'Division II'),
(794, 794, 'Ntare School', 'PLE/UG/2017/48018', 28, 'UCE/UG/2014/33990', 'Division III'),
(795, 795, 'Namilyango School', 'PLE/UG/2011/10210', 7, 'UCE/UG/2014/08423', 'Division III'),
(796, 796, 'Buddo Junior', 'PLE/UG/2020/00869', 27, 'UCE/UG/2019/06679', 'Division II'),
(797, 797, 'Greenhill Academy', 'PLE/UG/2013/45626', 23, 'UCE/UG/2020/81681', 'Division IV'),
(798, 798, 'Buddo Junior', 'PLE/UG/2016/02552', 28, 'UCE/UG/2019/15075', 'Division III'),
(799, 799, 'Namilyango School', 'PLE/UG/2019/00767', 4, 'UCE/UG/2010/28970', 'Division I'),
(800, 800, 'Buddo Junior', 'PLE/UG/2020/01227', 27, 'UCE/UG/2018/78308', 'Division I');

-- --------------------------------------------------------

--
-- Table structure for table `enrollment`
--

CREATE TABLE `enrollment` (
  `EnrollmentID` int(11) NOT NULL,
  `StudentID` int(11) NOT NULL,
  `AcademicYear` varchar(20) NOT NULL,
  `Level` varchar(50) NOT NULL,
  `Class` varchar(50) NOT NULL,
  `Term` varchar(50) NOT NULL,
  `Stream` varchar(50) DEFAULT NULL,
  `Residence` varchar(50) NOT NULL,
  `EntryStatus` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `enrollment`
--

INSERT INTO `enrollment` (`EnrollmentID`, `StudentID`, `AcademicYear`, `Level`, `Class`, `Term`, `Stream`, `Residence`, `EntryStatus`) VALUES
(1, 1, '2025-26', 'pre-primary', 'S.6', 'Term 2', 'C', 'Day', 'Continuing'),
(2, 2, '2025-26', 'Primary', 'P.3', 'Term 2', 'B', 'Day', 'Continuing'),
(3, 3, '2025-26', 'Primary', 'P.5', 'Term 2', 'C', 'Boarding', 'Continuing'),
(4, 4, '2025-26', 'Primary', 'P.7', 'Term 2', 'B', 'Day', 'Continuing'),
(5, 5, '2025-26', 'Primary', 'P.7', 'Term 3', 'C', 'Boarding', 'Continuing'),
(6, 6, '2025-26', 'Primary', 'P.2', 'Term 1', 'A', 'Boarding', 'Continuing'),
(7, 7, '2025-26', 'pre-primary', 'PP.1', 'Term 3', 'C', 'Day', 'New'),
(8, 8, '2025-26', 'Primary', 'P.5', 'Term 3', 'B', 'Day', 'Continuing'),
(9, 9, '2025-26', 'Secondary', 'S.4', 'Term 1', 'A', 'Day', 'Continuing'),
(10, 10, '2025-26', 'Secondary', 'S.2', 'Term 3', 'A', 'Day', 'Continuing'),
(11, 11, '2025-26', 'Primary', 'P.4', 'Term 3', 'E', 'Boarding', 'Continuing'),
(12, 12, '2025-26', 'Primary', 'P.7', 'Term 1', 'D', 'Day', 'Continuing'),
(13, 13, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'D', 'Day', 'Continuing'),
(14, 14, '2025-26', 'Primary', 'P.4', 'Term 2', 'E', 'Boarding', 'Continuing'),
(15, 15, '2025-26', 'Primary', 'P.2', 'Term 3', 'B', 'Boarding', 'Continuing'),
(16, 16, '2025-26', 'Secondary', 'S.4', 'Term 2', 'B', 'Boarding', 'Continuing'),
(17, 17, '2025-26', 'Secondary', 'S.4', 'Term 1', 'E', 'Day', 'Continuing'),
(18, 18, '2025-26', 'Primary', 'P.7', 'Term 3', 'B', 'Day', 'Continuing'),
(19, 19, '2025-26', 'Secondary', 'S.1', 'Term 3', 'D', 'Boarding', 'New'),
(20, 20, '2025-26', 'Secondary', 'S.5', 'Term 1', 'B', 'Boarding', 'Continuing'),
(21, 21, '2025-26', 'Primary', 'P.1', 'Term 1', 'C', 'Boarding', 'New'),
(22, 22, '2025-26', 'Primary', 'P.4', 'Term 3', 'D', 'Boarding', 'Continuing'),
(23, 23, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'C', 'Boarding', 'Continuing'),
(24, 24, '2025-26', 'Primary', 'P.2', 'Term 2', 'E', 'Day', 'Continuing'),
(25, 25, '2025-26', 'Primary', 'P.5', 'Term 1', 'B', 'Boarding', 'Continuing'),
(26, 26, '2025-26', 'Primary', 'P.6', 'Term 2', 'E', 'Boarding', 'Continuing'),
(27, 27, '2025-26', 'Primary', 'P.3', 'Term 3', 'D', 'Day', 'Continuing'),
(28, 28, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'D', 'Day', 'Continuing'),
(29, 29, '2025-26', 'Primary', 'P.4', 'Term 3', 'B', 'Boarding', 'Continuing'),
(30, 30, '2025-26', 'Primary', 'P.4', 'Term 1', 'A', 'Day', 'Continuing'),
(31, 31, '2025-26', 'Primary', 'P.6', 'Term 1', 'B', 'Day', 'Continuing'),
(32, 32, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'A', 'Day', 'Continuing'),
(33, 33, '2025-26', 'Primary', 'P.3', 'Term 3', 'C', 'Day', 'Continuing'),
(34, 34, '2025-26', 'Primary', 'P.3', 'Term 2', 'A', 'Boarding', 'Continuing'),
(35, 35, '2025-26', 'Secondary', 'S.4', 'Term 2', 'C', 'Boarding', 'Continuing'),
(36, 36, '2025-26', 'Primary', 'P.3', 'Term 1', 'A', 'Boarding', 'Continuing'),
(37, 37, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'C', 'Boarding', 'Continuing'),
(38, 38, '2025-26', 'Primary', 'P.6', 'Term 3', 'E', 'Boarding', 'Continuing'),
(39, 39, '2025-26', 'Primary', 'P.2', 'Term 1', 'B', 'Boarding', 'Continuing'),
(40, 40, '2025-26', 'Primary', 'P.4', 'Term 3', 'E', 'Boarding', 'Continuing'),
(41, 41, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'E', 'Boarding', 'Continuing'),
(42, 42, '2025-26', 'Primary', 'P.5', 'Term 3', 'A', 'Boarding', 'Continuing'),
(43, 43, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'A', 'Day', 'New'),
(44, 44, '2025-26', 'Secondary', 'S.2', 'Term 2', 'A', 'Day', 'Continuing'),
(45, 45, '2025-26', 'Primary', 'P.1', 'Term 3', 'E', 'Day', 'New'),
(46, 46, '2025-26', 'Primary', 'P.2', 'Term 1', 'A', 'Day', 'Continuing'),
(47, 47, '2025-26', 'Primary', 'P.5', 'Term 3', 'D', 'Day', 'Continuing'),
(48, 48, '2025-26', 'Secondary', 'S.4', 'Term 1', 'C', 'Day', 'Continuing'),
(49, 49, '2025-26', 'Primary', 'P.4', 'Term 2', 'D', 'Day', 'Continuing'),
(50, 50, '2025-26', 'Primary', 'P.5', 'Term 2', 'A', 'Day', 'Continuing'),
(51, 51, '2025-26', 'Secondary', 'S.3', 'Term 3', 'E', 'Day', 'Continuing'),
(52, 52, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'A', 'Boarding', 'Continuing'),
(53, 53, '2025-26', 'Secondary', 'S.5', 'Term 2', 'D', 'Day', 'Continuing'),
(54, 54, '2025-26', 'Primary', 'P.2', 'Term 2', 'D', 'Day', 'Continuing'),
(55, 55, '2025-26', 'Secondary', 'S.1', 'Term 1', 'D', 'Boarding', 'New'),
(56, 56, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'C', 'Day', 'New'),
(57, 57, '2026-27', 'pre-primary', 'PP.1', 'Term 1', '', 'Day', 'New'),
(58, 58, '2025-26', 'Primary', 'P.3', 'Term 3', 'B', 'Boarding', 'Continuing'),
(59, 59, '2025-26', 'Primary', 'P.5', 'Term 2', 'B', 'Boarding', 'Continuing'),
(60, 60, '2025-26', 'Secondary', 'S.6', 'Term 1', 'D', 'Boarding', 'Continuing'),
(61, 61, '2025-26', 'Secondary', 'S.1', 'Term 1', 'E', 'Boarding', 'New'),
(62, 62, '2025-26', 'Primary', 'P.6', 'Term 3', 'C', 'Boarding', 'Continuing'),
(63, 63, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'A', 'Day', 'Continuing'),
(64, 64, '2025-26', 'Secondary', 'S.3', 'Term 1', 'B', 'Boarding', 'Continuing'),
(65, 65, '2025-26', 'Secondary', 'S.2', 'Term 2', 'C', 'Boarding', 'Continuing'),
(66, 66, '2025-26', 'Secondary', 'S.1', 'Term 2', 'D', 'Day', 'New'),
(67, 67, '2025-26', 'Secondary', 'S.1', 'Term 1', 'C', 'Boarding', 'New'),
(68, 68, '2025-26', 'Secondary', 'S.4', 'Term 1', 'A', 'Boarding', 'Continuing'),
(69, 69, '2025-26', 'Secondary', 'S.6', 'Term 1', 'E', 'Day', 'Continuing'),
(70, 70, '2025-26', 'Primary', 'P.6', 'Term 3', 'C', 'Day', 'Continuing'),
(71, 71, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'B', 'Day', 'Continuing'),
(72, 72, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'B', 'Day', 'New'),
(73, 73, '2025-26', 'Secondary', 'S.2', 'Term 1', 'E', 'Boarding', 'Continuing'),
(74, 74, '2025-26', 'Secondary', 'S.5', 'Term 3', 'D', 'Boarding', 'Continuing'),
(75, 75, '2025-26', 'Primary', 'P.1', 'Term 1', 'E', 'Day', 'New'),
(76, 76, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'D', 'Boarding', 'New'),
(77, 77, '2025-26', 'Secondary', 'S.4', 'Term 1', 'E', 'Boarding', 'Continuing'),
(78, 78, '2025-26', 'Primary', 'P.6', 'Term 1', 'E', 'Boarding', 'Continuing'),
(79, 79, '2025-26', 'Secondary', 'S.1', 'Term 3', 'C', 'Boarding', 'New'),
(80, 80, '2025-26', 'Pre-Primary', 'PP.3', 'Term 1', 'B', 'Day', 'Continuing'),
(81, 81, '2025-26', 'Primary', 'P.3', 'Term 1', 'E', 'Day', 'Continuing'),
(82, 82, '2025-26', 'Secondary', 'S.1', 'Term 3', 'B', 'Boarding', 'New'),
(83, 83, '2025-26', 'Secondary', 'S.1', 'Term 3', 'C', 'Boarding', 'New'),
(84, 84, '2025-26', 'Secondary', 'S.3', 'Term 1', 'A', 'Boarding', 'Continuing'),
(85, 85, '2025-26', 'Secondary', 'S.5', 'Term 1', 'C', 'Boarding', 'Continuing'),
(86, 86, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'E', 'Day', 'New'),
(87, 87, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'E', 'Boarding', 'New'),
(88, 88, '2025-26', 'Primary', 'P.6', 'Term 1', 'D', 'Boarding', 'Continuing'),
(89, 89, '2025-26', 'Primary', 'P.1', 'Term 3', 'B', 'Day', 'New'),
(90, 90, '2025-26', 'Primary', 'P.5', 'Term 3', 'A', 'Boarding', 'Continuing'),
(91, 91, '2025-26', 'Secondary', 'S.3', 'Term 2', 'C', 'Day', 'Continuing'),
(92, 92, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'C', 'Boarding', 'Continuing'),
(93, 93, '2025-26', 'Primary', 'P.1', 'Term 3', 'A', 'Day', 'New'),
(94, 94, '2025-26', 'Secondary', 'S.5', 'Term 3', 'C', 'Day', 'Continuing'),
(95, 95, '2025-26', 'Secondary', 'S.3', 'Term 3', 'C', 'Day', 'Continuing'),
(96, 96, '2025-26', 'Primary', 'P.7', 'Term 2', 'C', 'Boarding', 'Continuing'),
(97, 97, '2025-26', 'Secondary', 'S.6', 'Term 3', 'A', 'Boarding', 'Continuing'),
(98, 98, '2025-26', 'Secondary', 'S.5', 'Term 1', 'A', 'Boarding', 'Continuing'),
(99, 99, '2025-26', 'Secondary', 'S.6', 'Term 1', 'D', 'Boarding', 'Continuing'),
(100, 100, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'D', 'Day', 'Continuing'),
(101, 101, '2025-26', 'Primary', 'P.7', 'Term 3', 'C', 'Boarding', 'Continuing'),
(102, 102, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'B', 'Day', 'Continuing'),
(103, 103, '2025-26', 'Primary', 'P.2', 'Term 3', 'D', 'Day', 'Continuing'),
(104, 104, '2025-26', 'Primary', 'P.3', 'Term 1', 'D', 'Boarding', 'Continuing'),
(105, 105, '2025-26', 'Primary', 'P.6', 'Term 1', 'B', 'Boarding', 'Continuing'),
(106, 106, '2025-26', 'Primary', 'P.3', 'Term 1', 'D', 'Boarding', 'Continuing'),
(107, 107, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'C', 'Day', 'Continuing'),
(108, 108, '2025-26', 'Primary', 'P.7', 'Term 2', 'E', 'Day', 'Continuing'),
(109, 109, '2025-26', 'Secondary', 'S.6', 'Term 1', 'E', 'Day', 'Continuing'),
(110, 110, '2025-26', 'Pre-Primary', 'PP.3', 'Term 1', 'B', 'Day', 'Continuing'),
(111, 111, '2025-26', 'Primary', 'P.3', 'Term 2', 'D', 'Day', 'Continuing'),
(112, 112, '2025-26', 'Secondary', 'S.2', 'Term 2', 'A', 'Day', 'Continuing'),
(113, 113, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'E', 'Day', 'Continuing'),
(114, 114, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'D', 'Boarding', 'New'),
(115, 115, '2025-26', 'Primary', 'P.1', 'Term 3', 'E', 'Boarding', 'New'),
(116, 116, '2025-26', 'Secondary', 'S.4', 'Term 2', 'C', 'Day', 'Continuing'),
(117, 117, '2025-26', 'Secondary', 'S.6', 'Term 3', 'B', 'Day', 'Continuing'),
(118, 118, '2025-26', 'Primary', 'P.3', 'Term 2', 'B', 'Boarding', 'Continuing'),
(119, 119, '2025-26', 'Primary', 'P.2', 'Term 3', 'D', 'Boarding', 'Continuing'),
(120, 120, '2025-26', 'Primary', 'P.3', 'Term 2', 'C', 'Day', 'Continuing'),
(121, 121, '2025-26', 'Pre-Primary', 'PP.3', 'Term 1', 'C', 'Boarding', 'Continuing'),
(122, 122, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'E', 'Day', 'Continuing'),
(123, 123, '2025-26', 'Secondary', 'S.3', 'Term 3', 'D', 'Boarding', 'Continuing'),
(124, 124, '2025-26', 'Primary', 'P.7', 'Term 3', 'E', 'Boarding', 'Continuing'),
(125, 125, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'A', 'Day', 'Continuing'),
(126, 126, '2025-26', 'Primary', 'P.7', 'Term 3', 'B', 'Day', 'Continuing'),
(127, 127, '2025-26', 'Secondary', 'S.6', 'Term 3', 'B', 'Day', 'Continuing'),
(128, 128, '2025-26', 'Secondary', 'S.4', 'Term 3', 'A', 'Boarding', 'Continuing'),
(129, 129, '2025-26', 'Primary', 'P.7', 'Term 2', 'E', 'Day', 'Continuing'),
(130, 130, '2025-26', 'Secondary', 'S.3', 'Term 1', 'E', 'Boarding', 'Continuing'),
(131, 131, '2025-26', 'Primary', 'P.7', 'Term 3', 'A', 'Day', 'Continuing'),
(132, 132, '2025-26', 'Primary', 'P.3', 'Term 2', 'D', 'Day', 'Continuing'),
(133, 133, '2025-26', 'Primary', 'P.2', 'Term 2', 'D', 'Day', 'Continuing'),
(134, 134, '2025-26', 'Secondary', 'S.2', 'Term 1', 'B', 'Boarding', 'Continuing'),
(135, 135, '2025-26', 'Primary', 'P.6', 'Term 2', 'B', 'Day', 'Continuing'),
(136, 136, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'B', 'Boarding', 'New'),
(137, 137, '2025-26', 'Secondary', 'S.2', 'Term 2', 'C', 'Boarding', 'Continuing'),
(138, 138, '2025-26', 'Secondary', 'S.6', 'Term 2', 'D', 'Boarding', 'Continuing'),
(139, 139, '2025-26', 'Secondary', 'S.3', 'Term 2', 'A', 'Day', 'Continuing'),
(140, 140, '2025-26', 'Primary', 'P.7', 'Term 3', 'E', 'Day', 'Continuing'),
(141, 141, '2025-26', 'Secondary', 'S.2', 'Term 1', 'E', 'Day', 'Continuing'),
(142, 142, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'A', 'Day', 'Continuing'),
(143, 143, '2025-26', 'Secondary', 'S.2', 'Term 3', 'E', 'Boarding', 'Continuing'),
(144, 144, '2025-26', 'Primary', 'P.4', 'Term 3', 'E', 'Day', 'Continuing'),
(145, 145, '2025-26', 'Secondary', 'S.6', 'Term 3', 'A', 'Boarding', 'Continuing'),
(146, 146, '2025-26', 'Primary', 'P.2', 'Term 3', 'B', 'Boarding', 'Continuing'),
(147, 147, '2025-26', 'Secondary', 'S.3', 'Term 2', 'D', 'Boarding', 'Continuing'),
(148, 148, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'D', 'Boarding', 'New'),
(149, 149, '2025-26', 'Primary', 'P.7', 'Term 1', 'B', 'Boarding', 'Continuing'),
(150, 150, '2025-26', 'Primary', 'P.7', 'Term 3', 'A', 'Boarding', 'Continuing'),
(151, 151, '2026-27', 'pre-primary', 'PP.1', 'Term 1', '', 'Boarding', 'New'),
(152, 152, '2025-26', 'Primary', 'P.3', 'Term 2', 'B', 'Day', 'Continuing'),
(153, 153, '2025-26', 'Primary', 'P.3', 'Term 2', 'C', 'Day', 'Continuing'),
(154, 154, '2025-26', 'Secondary', 'S.3', 'Term 3', 'C', 'Day', 'Continuing'),
(155, 155, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'E', 'Boarding', 'Continuing'),
(156, 156, '2025-26', 'Secondary', 'S.1', 'Term 2', 'A', 'Boarding', 'New'),
(157, 157, '2025-26', 'Primary', 'P.7', 'Term 3', 'E', 'Day', 'Continuing'),
(158, 158, '2025-26', 'Primary', 'P.2', 'Term 3', 'B', 'Boarding', 'Continuing'),
(159, 159, '2025-26', 'Primary', 'P.6', 'Term 1', 'C', 'Day', 'Continuing'),
(160, 160, '2025-26', 'Secondary', 'S.2', 'Term 3', 'B', 'Day', 'Continuing'),
(161, 161, '2025-26', 'Primary', 'P.4', 'Term 2', 'A', 'Day', 'Continuing'),
(162, 162, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'A', 'Boarding', 'Continuing'),
(163, 163, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'A', 'Day', 'New'),
(164, 164, '2025-26', 'Primary', 'P.1', 'Term 2', 'E', 'Day', 'New'),
(165, 165, '2025-26', 'Primary', 'P.1', 'Term 3', 'C', 'Day', 'New'),
(166, 166, '2025-26', 'Primary', 'P.1', 'Term 1', 'E', 'Boarding', 'New'),
(167, 167, '2025-26', 'Secondary', 'S.5', 'Term 2', 'C', 'Day', 'Continuing'),
(168, 168, '2025-26', 'Primary', 'P.5', 'Term 3', 'A', 'Boarding', 'Continuing'),
(169, 169, '2025-26', 'Primary', 'P.6', 'Term 3', 'C', 'Day', 'Continuing'),
(170, 170, '2025-26', 'Primary', 'P.2', 'Term 2', 'E', 'Day', 'Continuing'),
(171, 171, '2025-26', 'Secondary', 'S.5', 'Term 3', 'B', 'Day', 'Continuing'),
(172, 172, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'B', 'Day', 'New'),
(173, 173, '2025-26', 'Secondary', 'S.4', 'Term 2', 'B', 'Day', 'Continuing'),
(174, 174, '2025-26', 'Secondary', 'S.1', 'Term 1', 'A', 'Boarding', 'New'),
(175, 175, '2025-26', 'Primary', 'P.7', 'Term 2', 'C', 'Boarding', 'Continuing'),
(176, 176, '2025-26', 'Secondary', 'S.6', 'Term 1', 'A', 'Day', 'Continuing'),
(177, 177, '2025-26', 'Secondary', 'S.2', 'Term 1', 'D', 'Boarding', 'Continuing'),
(178, 178, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'E', 'Day', 'Continuing'),
(179, 179, '2025-26', 'Secondary', 'S.6', 'Term 1', 'B', 'Day', 'Continuing'),
(180, 180, '2025-26', 'Primary', 'P.3', 'Term 1', 'A', 'Day', 'Continuing'),
(181, 181, '2025-26', 'Secondary', 'S.2', 'Term 1', 'D', 'Boarding', 'Continuing'),
(182, 182, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'E', 'Boarding', 'Continuing'),
(183, 183, '2025-26', 'Secondary', 'S.6', 'Term 3', 'D', 'Boarding', 'Continuing'),
(184, 184, '2025-26', 'Primary', 'P.7', 'Term 1', 'D', 'Boarding', 'Continuing'),
(185, 185, '2025-26', 'Secondary', 'S.4', 'Term 3', 'E', 'Day', 'Continuing'),
(186, 186, '2025-26', 'Secondary', 'S.6', 'Term 2', 'C', 'Day', 'Continuing'),
(187, 187, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'E', 'Day', 'New'),
(188, 188, '2025-26', 'Primary', 'P.7', 'Term 1', 'E', 'Day', 'Continuing'),
(189, 189, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'A', 'Boarding', 'Continuing'),
(190, 190, '2025-26', 'Primary', 'P.3', 'Term 2', 'A', 'Day', 'Continuing'),
(191, 191, '2025-26', 'Secondary', 'S.5', 'Term 1', 'C', 'Day', 'Continuing'),
(192, 192, '2025-26', 'Secondary', 'S.1', 'Term 3', 'E', 'Day', 'New'),
(193, 193, '2025-26', 'Secondary', 'S.4', 'Term 3', 'E', 'Day', 'Continuing'),
(194, 194, '2025-26', 'Pre-Primary', 'PP.3', 'Term 1', 'C', 'Boarding', 'Continuing'),
(195, 195, '2025-26', 'Secondary', 'S.5', 'Term 1', 'D', 'Boarding', 'Continuing'),
(196, 196, '2025-26', 'Secondary', 'S.6', 'Term 2', 'A', 'Boarding', 'Continuing'),
(197, 197, '2025-26', 'Secondary', 'S.6', 'Term 3', 'D', 'Boarding', 'Continuing'),
(198, 198, '2025-26', 'Primary', 'P.7', 'Term 2', 'D', 'Day', 'Continuing'),
(199, 199, '2025-26', 'Primary', 'P.2', 'Term 3', 'E', 'Day', 'Continuing'),
(200, 200, '2025-26', 'Primary', 'P.4', 'Term 2', 'C', 'Boarding', 'Continuing'),
(201, 201, '2025-26', 'Primary', 'P.3', 'Term 3', 'C', 'Boarding', 'Continuing'),
(202, 202, '2025-26', 'Secondary', 'S.3', 'Term 3', 'D', 'Day', 'Continuing'),
(203, 203, '2025-26', 'Secondary', 'S.5', 'Term 2', 'E', 'Day', 'Continuing'),
(204, 204, '2025-26', 'Secondary', 'S.2', 'Term 1', 'A', 'Day', 'Continuing'),
(205, 205, '2025-26', 'Secondary', 'S.1', 'Term 2', 'E', 'Day', 'New'),
(206, 206, '2025-26', 'Primary', 'P.2', 'Term 3', 'A', 'Boarding', 'Continuing'),
(207, 207, '2025-26', 'Primary', 'P.2', 'Term 1', 'A', 'Boarding', 'Continuing'),
(208, 208, '2025-26', 'Secondary', 'S.2', 'Term 2', 'D', 'Day', 'Continuing'),
(209, 209, '2025-26', 'Secondary', 'S.4', 'Term 3', 'B', 'Boarding', 'Continuing'),
(210, 210, '2025-26', 'Secondary', 'S.6', 'Term 3', 'B', 'Boarding', 'Continuing'),
(211, 211, '2025-26', 'Primary', 'P.2', 'Term 3', 'C', 'Day', 'Continuing'),
(212, 212, '2025-26', 'Primary', 'P.2', 'Term 1', 'D', 'Day', 'Continuing'),
(213, 213, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'C', 'Day', 'Continuing'),
(214, 214, '2025-26', 'Primary', 'P.3', 'Term 3', 'D', 'Day', 'Continuing'),
(215, 215, '2025-26', 'Secondary', 'S.6', 'Term 2', 'C', 'Boarding', 'Continuing'),
(216, 216, '2025-26', 'Primary', 'P.2', 'Term 3', 'C', 'Day', 'Continuing'),
(217, 217, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'D', 'Boarding', 'Continuing'),
(218, 218, '2025-26', 'Secondary', 'S.4', 'Term 1', 'D', 'Boarding', 'Continuing'),
(219, 219, '2025-26', 'Secondary', 'S.2', 'Term 3', 'D', 'Boarding', 'Continuing'),
(220, 220, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'C', 'Boarding', 'Continuing'),
(221, 221, '2025-26', 'Primary', 'P.5', 'Term 2', 'A', 'Boarding', 'Continuing'),
(222, 222, '2025-26', 'Secondary', 'S.1', 'Term 3', 'C', 'Boarding', 'New'),
(223, 223, '2025-26', 'Primary', 'P.6', 'Term 3', 'A', 'Day', 'Continuing'),
(224, 224, '2025-26', 'Primary', 'P.4', 'Term 1', 'C', 'Day', 'Continuing'),
(225, 225, '2025-26', 'Secondary', 'S.6', 'Term 3', 'E', 'Boarding', 'Continuing'),
(226, 226, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'A', 'Boarding', 'Continuing'),
(227, 227, '2025-26', 'Secondary', 'S.4', 'Term 3', 'D', 'Day', 'Continuing'),
(228, 228, '2025-26', 'Primary', 'P.4', 'Term 2', 'B', 'Day', 'Continuing'),
(229, 229, '2025-26', 'Primary', 'P.3', 'Term 1', 'D', 'Day', 'Continuing'),
(230, 230, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'D', 'Day', 'Continuing'),
(231, 231, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'B', 'Day', 'Continuing'),
(232, 232, '2025-26', 'Primary', 'P.2', 'Term 3', 'E', 'Day', 'Continuing'),
(233, 233, '2025-26', 'Primary', 'P.2', 'Term 3', 'E', 'Boarding', 'Continuing'),
(234, 234, '2025-26', 'Primary', 'P.5', 'Term 3', 'D', 'Boarding', 'Continuing'),
(235, 235, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'B', 'Boarding', 'Continuing'),
(236, 236, '2025-26', 'Primary', 'P.3', 'Term 3', 'D', 'Day', 'Continuing'),
(237, 237, '2025-26', 'Secondary', 'S.3', 'Term 3', 'E', 'Day', 'Continuing'),
(238, 238, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'E', 'Day', 'Continuing'),
(239, 239, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'D', 'Boarding', 'Continuing'),
(240, 240, '2025-26', 'Primary', 'P.7', 'Term 2', 'E', 'Boarding', 'Continuing'),
(241, 241, '2025-26', 'Primary', 'P.5', 'Term 1', 'B', 'Boarding', 'Continuing'),
(242, 242, '2025-26', 'Secondary', 'S.2', 'Term 1', 'D', 'Day', 'Continuing'),
(243, 243, '2025-26', 'Secondary', 'S.2', 'Term 3', 'A', 'Boarding', 'Continuing'),
(244, 244, '2025-26', 'Secondary', 'S.6', 'Term 2', 'E', 'Day', 'Continuing'),
(245, 245, '2025-26', 'Secondary', 'S.1', 'Term 2', 'A', 'Boarding', 'New'),
(246, 246, '2025-26', 'Primary', 'P.1', 'Term 2', 'B', 'Day', 'New'),
(247, 247, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'D', 'Day', 'Continuing'),
(248, 248, '2025-26', 'Secondary', 'S.1', 'Term 3', 'B', 'Boarding', 'New'),
(249, 249, '2025-26', 'Secondary', 'S.2', 'Term 3', 'C', 'Boarding', 'Continuing'),
(250, 250, '2025-26', 'Secondary', 'S.6', 'Term 2', 'E', 'Day', 'Continuing'),
(251, 251, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'B', 'Day', 'New'),
(252, 252, '2025-26', 'Primary', 'P.1', 'Term 1', 'A', 'Boarding', 'New'),
(253, 253, '2025-26', 'Primary', 'P.6', 'Term 3', 'C', 'Boarding', 'Continuing'),
(254, 254, '2025-26', 'Primary', 'P.2', 'Term 3', 'B', 'Day', 'Continuing'),
(255, 255, '2025-26', 'Primary', 'P.6', 'Term 1', 'C', 'Day', 'Continuing'),
(256, 256, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'C', 'Day', 'New'),
(257, 257, '2025-26', 'Primary', 'P.7', 'Term 2', 'C', 'Boarding', 'Continuing'),
(258, 258, '2025-26', 'Secondary', 'S.3', 'Term 1', 'B', 'Boarding', 'Continuing'),
(259, 259, '2025-26', 'Secondary', 'S.5', 'Term 1', 'E', 'Day', 'Continuing'),
(260, 260, '2025-26', 'Primary', 'P.3', 'Term 2', 'A', 'Boarding', 'Continuing'),
(261, 261, '2025-26', 'Secondary', 'S.6', 'Term 3', 'C', 'Boarding', 'Continuing'),
(262, 262, '2025-26', 'Secondary', 'S.5', 'Term 1', 'D', 'Boarding', 'Continuing'),
(263, 263, '2025-26', 'Secondary', 'S.1', 'Term 1', 'B', 'Boarding', 'New'),
(264, 264, '2025-26', 'Primary', 'P.4', 'Term 2', 'D', 'Boarding', 'Continuing'),
(265, 265, '2025-26', 'Secondary', 'S.6', 'Term 2', 'B', 'Boarding', 'Continuing'),
(266, 266, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'D', 'Day', 'Continuing'),
(267, 267, '2025-26', 'Secondary', 'S.5', 'Term 3', 'E', 'Boarding', 'Continuing'),
(268, 268, '2025-26', 'Secondary', 'S.3', 'Term 1', 'B', 'Day', 'Continuing'),
(269, 269, '2025-26', 'Pre-Primary', 'PP.3', 'Term 1', 'E', 'Day', 'Continuing'),
(270, 270, '2025-26', 'Primary', 'P.1', 'Term 2', 'A', 'Day', 'New'),
(271, 271, '2025-26', 'Primary', 'P.4', 'Term 2', 'A', 'Boarding', 'Continuing'),
(272, 272, '2025-26', 'Primary', 'P.7', 'Term 3', 'D', 'Day', 'Continuing'),
(273, 273, '2025-26', 'Primary', 'P.4', 'Term 3', 'E', 'Boarding', 'Continuing'),
(274, 274, '2025-26', 'Primary', 'P.4', 'Term 1', 'A', 'Day', 'Continuing'),
(275, 275, '2025-26', 'Secondary', 'S.6', 'Term 3', 'A', 'Day', 'Continuing'),
(276, 276, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'B', 'Boarding', 'Continuing'),
(277, 277, '2025-26', 'Secondary', 'S.3', 'Term 1', 'E', 'Day', 'Continuing'),
(278, 278, '2025-26', 'Secondary', 'S.2', 'Term 3', 'E', 'Day', 'Continuing'),
(279, 279, '2025-26', 'Primary', 'P.5', 'Term 3', 'B', 'Day', 'Continuing'),
(280, 280, '2025-26', 'Secondary', 'S.2', 'Term 3', 'B', 'Day', 'Continuing'),
(281, 281, '2025-26', 'Primary', 'P.1', 'Term 1', 'E', 'Day', 'New'),
(282, 282, '2025-26', 'Primary', 'P.1', 'Term 1', 'B', 'Day', 'New'),
(283, 283, '2025-26', 'Secondary', 'S.3', 'Term 2', 'B', 'Boarding', 'Continuing'),
(284, 284, '2025-26', 'Primary', 'P.3', 'Term 1', 'B', 'Day', 'Continuing'),
(285, 285, '2025-26', 'Secondary', 'S.4', 'Term 2', 'B', 'Day', 'Continuing'),
(286, 286, '2025-26', 'Secondary', 'S.1', 'Term 3', 'A', 'Day', 'New'),
(287, 287, '2025-26', 'Primary', 'P.4', 'Term 2', 'D', 'Day', 'Continuing'),
(288, 288, '2025-26', 'Secondary', 'S.6', 'Term 3', 'B', 'Day', 'Continuing'),
(289, 289, '2025-26', 'Primary', 'P.3', 'Term 2', 'C', 'Day', 'Continuing'),
(290, 290, '2025-26', 'Secondary', 'S.2', 'Term 3', 'D', 'Boarding', 'Continuing'),
(291, 291, '2025-26', 'Primary', 'P.1', 'Term 3', 'A', 'Day', 'New'),
(292, 292, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'C', 'Day', 'Continuing'),
(293, 293, '2025-26', 'Secondary', 'S.5', 'Term 1', 'A', 'Boarding', 'Continuing'),
(294, 294, '2025-26', 'Secondary', 'S.1', 'Term 3', 'C', 'Day', 'New'),
(295, 295, '2025-26', 'Primary', 'P.4', 'Term 1', 'C', 'Boarding', 'Continuing'),
(296, 296, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'A', 'Boarding', 'Continuing'),
(297, 297, '2025-26', 'Secondary', 'S.1', 'Term 2', 'C', 'Boarding', 'New'),
(298, 298, '2025-26', 'Primary', 'P.3', 'Term 2', 'E', 'Day', 'Continuing'),
(299, 299, '2025-26', 'Primary', 'P.1', 'Term 1', 'B', 'Day', 'New'),
(300, 300, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'A', 'Day', 'New'),
(301, 301, '2025-26', 'Secondary', 'S.6', 'Term 2', 'E', 'Boarding', 'Continuing'),
(302, 302, '2025-26', 'Secondary', 'S.1', 'Term 3', 'B', 'Boarding', 'New'),
(303, 303, '2025-26', 'Primary', 'P.6', 'Term 3', 'A', 'Boarding', 'Continuing'),
(304, 304, '2025-26', 'Secondary', 'S.1', 'Term 3', 'D', 'Boarding', 'New'),
(305, 305, '2025-26', 'Secondary', 'S.5', 'Term 1', 'B', 'Boarding', 'Continuing'),
(306, 306, '2025-26', 'Primary', 'P.2', 'Term 3', 'C', 'Day', 'Continuing'),
(307, 307, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'A', 'Day', 'Continuing'),
(308, 308, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'D', 'Boarding', 'Continuing'),
(309, 309, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'C', 'Day', 'Continuing'),
(310, 310, '2025-26', 'Primary', 'P.2', 'Term 1', 'C', 'Boarding', 'Continuing'),
(311, 311, '2025-26', 'Primary', 'P.4', 'Term 3', 'A', 'Day', 'Continuing'),
(312, 312, '2025-26', 'pre-primary', 'PP.1', 'Term 1', '', 'Day', 'New'),
(313, 313, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'D', 'Boarding', 'New'),
(314, 314, '2025-26', 'Primary', 'P.2', 'Term 1', 'E', 'Day', 'Continuing'),
(315, 315, '2025-26', 'Primary', 'P.7', 'Term 3', 'A', 'Day', 'Continuing'),
(316, 316, '2025-26', 'Secondary', 'S.2', 'Term 2', 'D', 'Boarding', 'Continuing'),
(317, 317, '2025-26', 'Primary', 'P.2', 'Term 3', 'E', 'Boarding', 'Continuing'),
(318, 318, '2025-26', 'Primary', 'P.3', 'Term 3', 'C', 'Day', 'Continuing'),
(319, 319, '2025-26', 'Primary', 'P.5', 'Term 3', 'C', 'Day', 'Continuing'),
(320, 320, '2025-26', 'Primary', 'P.5', 'Term 2', 'E', 'Boarding', 'Continuing'),
(321, 321, '2025-26', 'Primary', 'P.5', 'Term 2', 'D', 'Day', 'Continuing'),
(322, 322, '2025-26', 'Secondary', 'S.3', 'Term 1', 'D', 'Boarding', 'Continuing'),
(323, 323, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'C', 'Day', 'New'),
(324, 324, '2025-26', 'Primary', 'P.7', 'Term 3', 'C', 'Boarding', 'Continuing'),
(325, 325, '2025-26', 'Secondary', 'S.6', 'Term 1', 'B', 'Day', 'Continuing'),
(326, 326, '2025-26', 'Secondary', 'S.1', 'Term 1', 'B', 'Day', 'New'),
(327, 327, '2025-26', 'Secondary', 'S.6', 'Term 3', 'A', 'Day', 'Continuing'),
(328, 328, '2025-26', 'Secondary', 'S.5', 'Term 3', 'B', 'Day', 'Continuing'),
(329, 329, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'A', 'Boarding', 'New'),
(330, 330, '2025-26', 'Primary', 'P.4', 'Term 2', 'C', 'Boarding', 'Continuing'),
(331, 331, '2025-26', 'Primary', 'P.1', 'Term 1', 'C', 'Boarding', 'New'),
(332, 332, '2025-26', 'Primary', 'P.5', 'Term 1', 'D', 'Day', 'Continuing'),
(333, 333, '2025-26', 'Secondary', 'S.4', 'Term 3', 'A', 'Boarding', 'Continuing'),
(334, 334, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'E', 'Day', 'New'),
(335, 335, '2025-26', 'Secondary', 'S.2', 'Term 3', 'E', 'Boarding', 'Continuing'),
(336, 336, '2025-26', 'Primary', 'P.2', 'Term 3', 'B', 'Day', 'Continuing'),
(337, 337, '2025-26', 'Secondary', 'S.2', 'Term 3', 'B', 'Day', 'Continuing'),
(338, 338, '2025-26', 'Primary', 'P.3', 'Term 3', 'D', 'Boarding', 'Continuing'),
(339, 339, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'E', 'Boarding', 'Continuing'),
(340, 340, '2025-26', 'Secondary', 'S.5', 'Term 2', 'D', 'Day', 'Continuing'),
(341, 341, '2025-26', 'Secondary', 'S.6', 'Term 1', 'B', 'Boarding', 'Continuing'),
(342, 342, '2025-26', 'Secondary', 'S.3', 'Term 2', 'D', 'Day', 'Continuing'),
(343, 343, '2025-26', 'Secondary', 'S.2', 'Term 1', 'E', 'Day', 'Continuing'),
(344, 344, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'D', 'Day', 'Continuing'),
(345, 345, '2025-26', 'Primary', 'P.1', 'Term 3', 'D', 'Day', 'New'),
(346, 346, '2025-26', 'Primary', 'P.3', 'Term 3', 'C', 'Day', 'Continuing'),
(347, 347, '2025-26', 'Primary', 'P.6', 'Term 2', 'C', 'Boarding', 'Continuing'),
(348, 348, '2025-26', 'Secondary', 'S.1', 'Term 2', 'E', 'Boarding', 'New'),
(349, 349, '2025-26', 'Primary', 'P.4', 'Term 3', 'A', 'Day', 'Continuing'),
(350, 350, '2025-26', 'Secondary', 'S.6', 'Term 3', 'D', 'Day', 'Continuing'),
(351, 351, '2025-26', 'Secondary', 'S.1', 'Term 3', 'E', 'Day', 'New'),
(352, 352, '2025-26', 'Primary', 'P.5', 'Term 2', 'D', 'Day', 'Continuing'),
(353, 353, '2025-26', 'Primary', 'P.6', 'Term 2', 'A', 'Day', 'Continuing'),
(354, 354, '2025-26', 'Secondary', 'S.1', 'Term 2', 'C', 'Boarding', 'New'),
(355, 355, '2025-26', 'Primary', 'P.1', 'Term 3', 'E', 'Day', 'New'),
(356, 356, '2025-26', 'Primary', 'P.5', 'Term 2', 'A', 'Boarding', 'Continuing'),
(357, 357, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'C', 'Day', 'Continuing'),
(358, 358, '2025-26', 'Primary', 'P.3', 'Term 1', 'E', 'Day', 'Continuing'),
(359, 359, '2025-26', 'Primary', 'P.1', 'Term 3', 'D', 'Boarding', 'New'),
(360, 360, '2025-26', 'Secondary', 'S.3', 'Term 1', 'B', 'Boarding', 'Continuing'),
(361, 361, '2025-26', 'Primary', 'P.7', 'Term 2', 'B', 'Day', 'Continuing'),
(362, 362, '2025-26', 'Primary', 'P.6', 'Term 3', 'B', 'Boarding', 'Continuing'),
(363, 363, '2025-26', 'Primary', 'P.6', 'Term 3', 'E', 'Boarding', 'Continuing'),
(364, 364, '2025-26', 'Primary', 'P.7', 'Term 3', 'B', 'Day', 'Continuing'),
(365, 365, '2025-26', 'Primary', 'P.1', 'Term 1', 'C', 'Boarding', 'New'),
(366, 366, '2025-26', 'Secondary', 'S.1', 'Term 3', 'E', 'Day', 'New'),
(367, 367, '2025-26', 'Primary', 'P.7', 'Term 3', 'D', 'Day', 'Continuing'),
(368, 368, '2025-26', 'Secondary', 'S.3', 'Term 1', 'C', 'Day', 'Continuing'),
(369, 369, '2025-26', 'Secondary', 'S.2', 'Term 1', 'E', 'Day', 'Continuing'),
(370, 370, '2025-26', 'Primary', 'P.6', 'Term 1', 'E', 'Day', 'Continuing'),
(371, 371, '2025-26', 'Secondary', 'S.6', 'Term 3', 'C', 'Day', 'Continuing'),
(372, 372, '2025-26', 'Primary', 'P.7', 'Term 1', 'C', 'Day', 'Continuing'),
(373, 373, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'C', 'Day', 'New'),
(374, 374, '2025-26', 'Primary', 'P.3', 'Term 1', 'A', 'Day', 'Continuing'),
(375, 375, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'D', 'Boarding', 'New'),
(376, 376, '2025-26', 'Primary', 'P.4', 'Term 2', 'B', 'Day', 'Continuing'),
(377, 377, '2025-26', 'Secondary', 'S.6', 'Term 2', 'E', 'Day', 'Continuing'),
(378, 378, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'E', 'Boarding', 'Continuing'),
(379, 379, '2025-26', 'Primary', 'P.7', 'Term 2', 'A', 'Boarding', 'Continuing'),
(380, 380, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'D', 'Day', 'Continuing'),
(381, 381, '2025-26', 'Secondary', 'S.3', 'Term 3', 'D', 'Day', 'Continuing'),
(382, 382, '2025-26', 'Primary', 'P.1', 'Term 2', 'A', 'Boarding', 'New'),
(383, 383, '2025-26', 'Primary', 'P.4', 'Term 1', 'B', 'Boarding', 'Continuing'),
(384, 384, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'D', 'Day', 'Continuing'),
(385, 385, '2025-26', 'Secondary', 'S.4', 'Term 1', 'B', 'Day', 'Continuing'),
(386, 386, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'D', 'Boarding', 'Continuing'),
(387, 387, '2025-26', 'Primary', 'P.2', 'Term 2', 'C', 'Boarding', 'Continuing'),
(388, 388, '2025-26', 'Pre-Primary', 'PP.3', 'Term 1', 'C', 'Boarding', 'Continuing'),
(389, 389, '2025-26', 'Primary', 'P.5', 'Term 1', 'C', 'Boarding', 'Continuing'),
(390, 390, '2025-26', 'Primary', 'P.5', 'Term 3', 'B', 'Day', 'Continuing'),
(391, 391, '2025-26', 'Primary', 'P.6', 'Term 2', 'E', 'Boarding', 'Continuing'),
(392, 392, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'D', 'Day', 'Continuing'),
(393, 393, '2025-26', 'Primary', 'P.5', 'Term 1', 'E', 'Boarding', 'Continuing'),
(394, 394, '2025-26', 'Secondary', 'S.4', 'Term 3', 'E', 'Boarding', 'Continuing'),
(395, 395, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'C', 'Boarding', 'New'),
(396, 396, '2025-26', 'Pre-Primary', 'PP.3', 'Term 1', 'E', 'Day', 'Continuing'),
(397, 397, '2025-26', 'Primary', 'P.4', 'Term 2', 'A', 'Day', 'Continuing'),
(398, 398, '2025-26', 'Secondary', 'S.2', 'Term 1', 'B', 'Boarding', 'Continuing'),
(399, 399, '2025-26', 'Primary', 'P.4', 'Term 3', 'B', 'Day', 'Continuing'),
(400, 400, '2025-26', 'Primary', 'P.7', 'Term 3', 'B', 'Boarding', 'Continuing'),
(401, 401, '2025-26', 'Secondary', 'S.5', 'Term 3', 'E', 'Day', 'Continuing'),
(402, 402, '2025-26', 'Secondary', 'S.4', 'Term 1', 'C', 'Day', 'Continuing'),
(403, 403, '2025-26', 'Primary', 'P.5', 'Term 2', 'C', 'Day', 'Continuing'),
(404, 404, '2025-26', 'Primary', 'P.2', 'Term 1', 'C', 'Day', 'Continuing'),
(405, 405, '2025-26', 'Secondary', 'S.4', 'Term 1', 'D', 'Day', 'Continuing'),
(406, 406, '2025-26', 'Primary', 'P.5', 'Term 1', 'B', 'Boarding', 'Continuing'),
(407, 407, '2025-26', 'Secondary', 'S.3', 'Term 2', 'E', 'Day', 'Continuing'),
(408, 408, '2025-26', 'Secondary', 'S.2', 'Term 1', 'C', 'Boarding', 'Continuing'),
(409, 409, '2025-26', 'Secondary', 'S.4', 'Term 2', 'E', 'Day', 'Continuing'),
(410, 410, '2025-26', 'Primary', 'P.6', 'Term 3', 'E', 'Boarding', 'Continuing'),
(411, 411, '2025-26', 'Primary', 'P.5', 'Term 3', 'D', 'Day', 'Continuing'),
(412, 412, '2025-26', 'Primary', 'P.7', 'Term 1', 'A', 'Boarding', 'Continuing'),
(413, 413, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'B', 'Day', 'Continuing'),
(414, 414, '2025-26', 'Primary', 'P.4', 'Term 2', 'D', 'Day', 'Continuing'),
(415, 415, '2025-26', 'Primary', 'P.5', 'Term 1', 'C', 'Day', 'Continuing'),
(416, 416, '2025-26', 'Primary', 'P.2', 'Term 3', 'C', 'Boarding', 'Continuing'),
(417, 417, '2025-26', 'Primary', 'P.1', 'Term 3', 'A', 'Boarding', 'New'),
(418, 418, '2025-26', 'Primary', 'P.3', 'Term 1', 'B', 'Day', 'Continuing'),
(419, 419, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'B', 'Boarding', 'New'),
(420, 420, '2026-27', 'pre-primary', 'PP.1', 'Term 1', '', 'Day', 'New'),
(421, 421, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'D', 'Day', 'New'),
(422, 422, '2025-26', 'Secondary', 'S.6', 'Term 3', 'E', 'Boarding', 'Continuing'),
(423, 423, '2025-26', 'Primary', 'P.5', 'Term 1', 'D', 'Boarding', 'Continuing'),
(424, 424, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'B', 'Day', 'Continuing'),
(425, 425, '2025-26', 'Secondary', 'S.4', 'Term 3', 'A', 'Boarding', 'Continuing'),
(426, 426, '2025-26', 'Secondary', 'S.6', 'Term 1', 'B', 'Boarding', 'Continuing'),
(427, 427, '2025-26', 'Secondary', 'S.6', 'Term 1', 'C', 'Boarding', 'Continuing'),
(428, 428, '2025-26', 'Primary', 'P.5', 'Term 1', 'E', 'Boarding', 'Continuing'),
(429, 429, '2025-26', 'Primary', 'P.5', 'Term 2', 'C', 'Day', 'Continuing'),
(430, 430, '2025-26', 'Primary', 'P.1', 'Term 2', 'A', 'Boarding', 'New'),
(431, 431, '2025-26', 'Secondary', 'S.5', 'Term 3', 'D', 'Day', 'Continuing'),
(432, 432, '2025-26', 'Secondary', 'S.5', 'Term 2', 'E', 'Boarding', 'Continuing'),
(433, 433, '2025-26', 'Primary', 'P.3', 'Term 1', 'C', 'Day', 'Continuing'),
(434, 434, '2025-26', 'Primary', 'P.4', 'Term 2', 'A', 'Day', 'Continuing'),
(435, 435, '2025-26', 'Secondary', 'S.3', 'Term 2', 'C', 'Day', 'Continuing'),
(436, 436, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'A', 'Day', 'Continuing'),
(437, 437, '2025-26', 'Primary', 'P.1', 'Term 1', 'C', 'Day', 'New'),
(438, 438, '2025-26', 'Secondary', 'S.1', 'Term 2', 'D', 'Boarding', 'New'),
(439, 439, '2025-26', 'Secondary', 'S.1', 'Term 2', 'E', 'Day', 'New'),
(440, 440, '2025-26', 'Primary', 'P.1', 'Term 3', 'C', 'Boarding', 'New'),
(441, 441, '2025-26', 'Primary', 'P.1', 'Term 1', 'B', 'Boarding', 'New'),
(442, 442, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'E', 'Boarding', 'New'),
(443, 443, '2025-26', 'Primary', 'P.6', 'Term 3', 'E', 'Day', 'Continuing'),
(444, 444, '2025-26', 'Primary', 'P.1', 'Term 1', 'C', 'Boarding', 'New'),
(445, 445, '2025-26', 'Secondary', 'S.3', 'Term 3', 'A', 'Day', 'Continuing'),
(446, 446, '2025-26', 'Secondary', 'S.5', 'Term 3', 'A', 'Boarding', 'Continuing'),
(447, 447, '2025-26', 'Primary', 'P.7', 'Term 1', 'E', 'Day', 'Continuing'),
(448, 448, '2025-26', 'Primary', 'P.6', 'Term 3', 'A', 'Boarding', 'Continuing'),
(449, 449, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'B', 'Day', 'New'),
(450, 450, '2025-26', 'Primary', 'P.4', 'Term 1', 'E', 'Day', 'Continuing'),
(451, 451, '2025-26', 'Primary', 'P.3', 'Term 1', 'E', 'Boarding', 'Continuing'),
(452, 452, '2025-26', 'Primary', 'P.4', 'Term 2', 'B', 'Boarding', 'Continuing'),
(453, 453, '2025-26', 'Primary', 'P.6', 'Term 1', 'A', 'Boarding', 'Continuing'),
(454, 454, '2025-26', 'Primary', 'P.2', 'Term 1', 'C', 'Day', 'Continuing'),
(455, 455, '2025-26', 'Primary', 'P.1', 'Term 3', 'A', 'Boarding', 'New'),
(456, 456, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'C', 'Day', 'Continuing'),
(457, 457, '2025-26', 'Primary', 'P.5', 'Term 2', 'B', 'Day', 'Continuing'),
(458, 458, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'B', 'Day', 'Continuing'),
(459, 459, '2025-26', 'Primary', 'P.1', 'Term 3', 'E', 'Boarding', 'New'),
(460, 460, '2025-26', 'Secondary', 'S.5', 'Term 3', 'B', 'Boarding', 'Continuing'),
(461, 461, '2025-26', 'Secondary', 'S.3', 'Term 1', 'B', 'Day', 'Continuing'),
(462, 462, '2025-26', 'Primary', 'P.4', 'Term 3', 'C', 'Boarding', 'Continuing'),
(463, 463, '2025-26', 'Primary', 'P.2', 'Term 2', 'A', 'Day', 'Continuing'),
(464, 464, '2025-26', 'Primary', 'P.7', 'Term 1', 'E', 'Boarding', 'Continuing'),
(465, 465, '2025-26', 'Secondary', 'S.1', 'Term 3', 'B', 'Day', 'New'),
(466, 466, '2025-26', 'Primary', 'P.3', 'Term 3', 'E', 'Day', 'Continuing'),
(467, 467, '2025-26', 'Primary', 'P.2', 'Term 2', 'D', 'Boarding', 'Continuing'),
(468, 468, '2025-26', 'Secondary', 'S.5', 'Term 2', 'A', 'Day', 'Continuing'),
(469, 469, '2025-26', 'Primary', 'P.2', 'Term 3', 'A', 'Day', 'Continuing'),
(470, 470, '2025-26', 'Secondary', 'S.4', 'Term 3', 'A', 'Day', 'Continuing'),
(471, 471, '2025-26', 'Primary', 'P.6', 'Term 2', 'B', 'Boarding', 'Continuing'),
(472, 472, '2025-26', 'Primary', 'P.6', 'Term 2', 'D', 'Boarding', 'Continuing'),
(473, 473, '2025-26', 'Secondary', 'S.2', 'Term 3', 'B', 'Boarding', 'Continuing'),
(474, 474, '2025-26', 'Secondary', 'S.3', 'Term 2', 'D', 'Day', 'Continuing'),
(475, 475, '2025-26', 'Primary', 'P.2', 'Term 3', 'E', 'Day', 'Continuing'),
(476, 476, '2025-26', 'Primary', 'P.4', 'Term 2', 'D', 'Day', 'Continuing'),
(477, 477, '2025-26', 'Secondary', 'S.3', 'Term 3', 'C', 'Boarding', 'Continuing'),
(478, 478, '2025-26', 'Secondary', 'S.6', 'Term 3', 'C', 'Day', 'Continuing'),
(479, 479, '2025-26', 'Primary', 'P.5', 'Term 1', 'A', 'Boarding', 'Continuing'),
(480, 480, '2025-26', 'Primary', 'P.1', 'Term 3', 'D', 'Boarding', 'New'),
(481, 481, '2025-26', 'Primary', 'P.3', 'Term 3', 'E', 'Day', 'Continuing'),
(482, 482, '2025-26', 'Secondary', 'S.5', 'Term 3', 'A', 'Day', 'Continuing'),
(483, 483, '2025-26', 'Primary', 'P.7', 'Term 1', 'C', 'Day', 'Continuing'),
(484, 484, '2025-26', 'Primary', 'P.6', 'Term 1', 'D', 'Boarding', 'Continuing'),
(485, 485, '2025-26', 'Secondary', 'S.1', 'Term 1', 'A', 'Boarding', 'New'),
(486, 486, '2025-26', 'Secondary', 'S.5', 'Term 3', 'B', 'Boarding', 'Continuing'),
(487, 487, '2025-26', 'Primary', 'P.4', 'Term 1', 'B', 'Boarding', 'Continuing'),
(488, 488, '2025-26', 'Primary', 'P.6', 'Term 2', 'B', 'Boarding', 'Continuing'),
(489, 489, '2025-26', 'Primary', 'P.4', 'Term 3', 'C', 'Day', 'Continuing'),
(490, 490, '2025-26', 'Secondary', 'S.6', 'Term 3', 'A', 'Boarding', 'Continuing'),
(491, 491, '2025-26', 'Primary', 'P.5', 'Term 2', 'E', 'Boarding', 'Continuing'),
(492, 492, '2025-26', 'Primary', 'P.6', 'Term 2', 'D', 'Day', 'Continuing'),
(493, 493, '2025-26', 'Secondary', 'S.2', 'Term 1', 'E', 'Boarding', 'Continuing'),
(494, 494, '2025-26', 'Secondary', 'S.5', 'Term 1', 'E', 'Boarding', 'Continuing'),
(495, 495, '2025-26', 'Primary', 'P.6', 'Term 1', 'A', 'Day', 'Continuing'),
(496, 496, '2025-26', 'Primary', 'P.4', 'Term 1', 'C', 'Boarding', 'Continuing'),
(497, 497, '2025-26', 'Primary', 'P.6', 'Term 3', 'B', 'Boarding', 'Continuing'),
(498, 498, '2025-26', 'Primary', 'P.1', 'Term 1', 'A', 'Boarding', 'New'),
(499, 499, '2025-26', 'Secondary', 'S.3', 'Term 3', 'B', 'Boarding', 'Continuing'),
(500, 500, '2025-26', 'Primary', 'P.3', 'Term 1', 'C', 'Boarding', 'Continuing'),
(501, 501, '2025-26', 'Secondary', 'S.4', 'Term 2', 'C', 'Boarding', 'Continuing'),
(502, 502, '2025-26', 'Secondary', 'S.2', 'Term 2', 'C', 'Boarding', 'Continuing'),
(503, 503, '2025-26', 'Primary', 'P.2', 'Term 3', 'B', 'Boarding', 'Continuing'),
(504, 504, '2025-26', 'Secondary', 'S.3', 'Term 1', 'B', 'Boarding', 'Continuing'),
(505, 505, '2025-26', 'Secondary', 'S.3', 'Term 3', 'E', 'Day', 'Continuing'),
(506, 506, '2025-26', 'Secondary', 'S.5', 'Term 3', 'C', 'Boarding', 'Continuing'),
(507, 507, '2025-26', 'Primary', 'P.4', 'Term 2', 'A', 'Boarding', 'Continuing'),
(508, 508, '2025-26', 'Primary', 'P.5', 'Term 2', 'E', 'Boarding', 'Continuing'),
(509, 509, '2025-26', 'pre-primary', 'PP.1', 'Term 1', '', 'Day', 'New'),
(510, 510, '2025-26', 'Secondary', 'S.1', 'Term 1', 'D', 'Day', 'New'),
(511, 511, '2025-26', 'Primary', 'P.2', 'Term 3', 'E', 'Boarding', 'Continuing'),
(512, 512, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'E', 'Day', 'Continuing'),
(513, 513, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'B', 'Boarding', 'Continuing'),
(514, 514, '2025-26', 'Secondary', 'S.4', 'Term 3', 'A', 'Day', 'Continuing'),
(515, 515, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'D', 'Day', 'Continuing'),
(516, 516, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'E', 'Day', 'New'),
(517, 517, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'B', 'Day', 'Continuing'),
(518, 518, '2025-26', 'Secondary', 'S.3', 'Term 2', 'C', 'Boarding', 'Continuing'),
(519, 519, '2025-26', 'Secondary', 'S.3', 'Term 3', 'E', 'Day', 'Continuing'),
(520, 520, '2025-26', 'Primary', 'P.5', 'Term 1', 'E', 'Day', 'Continuing'),
(521, 521, '2025-26', 'Secondary', 'S.4', 'Term 1', 'E', 'Day', 'Continuing'),
(522, 522, '2025-26', 'Secondary', 'S.5', 'Term 2', 'C', 'Boarding', 'Continuing'),
(523, 523, '2025-26', 'Primary', 'P.2', 'Term 1', 'C', 'Day', 'Continuing'),
(524, 524, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'B', 'Boarding', 'Continuing'),
(525, 525, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'E', 'Boarding', 'Continuing'),
(526, 526, '2025-26', 'Secondary', 'S.6', 'Term 3', 'D', 'Boarding', 'Continuing'),
(527, 527, '2025-26', 'Secondary', 'S.2', 'Term 3', 'D', 'Boarding', 'Continuing'),
(528, 528, '2025-26', 'Primary', 'P.6', 'Term 1', 'A', 'Day', 'Continuing'),
(529, 529, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'A', 'Boarding', 'Continuing'),
(530, 530, '2025-26', 'Secondary', 'S.4', 'Term 3', 'A', 'Boarding', 'Continuing'),
(531, 531, '2025-26', 'Primary', 'P.1', 'Term 1', 'C', 'Boarding', 'New'),
(532, 532, '2025-26', 'Secondary', 'S.5', 'Term 3', 'A', 'Day', 'Continuing'),
(533, 533, '2025-26', 'Primary', 'P.4', 'Term 1', 'D', 'Boarding', 'Continuing'),
(534, 534, '2025-26', 'Secondary', 'S.3', 'Term 2', 'D', 'Day', 'Continuing'),
(535, 535, '2026-27', 'pre-primary', 'PP.1', 'Term 1', '', 'Day', 'New'),
(536, 536, '2025-26', 'Primary', 'P.3', 'Term 2', 'B', 'Day', 'Continuing'),
(537, 537, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'E', 'Boarding', 'Continuing'),
(538, 538, '2025-26', 'Secondary', 'S.2', 'Term 3', 'A', 'Boarding', 'Continuing'),
(539, 539, '2025-26', 'Secondary', 'S.4', 'Term 3', 'D', 'Boarding', 'Continuing'),
(540, 540, '2025-26', 'Primary', 'P.4', 'Term 3', 'D', 'Day', 'Continuing'),
(541, 541, '2025-26', 'Secondary', 'S.5', 'Term 1', 'C', 'Day', 'Continuing'),
(542, 542, '2025-26', 'Primary', 'P.6', 'Term 1', 'D', 'Day', 'Continuing'),
(543, 543, '2025-26', 'Secondary', 'S.4', 'Term 3', 'E', 'Day', 'Continuing'),
(544, 544, '2025-26', 'Pre-Primary', 'PP.3', 'Term 1', 'A', 'Day', 'Continuing'),
(545, 545, '2025-26', 'Primary', 'P.4', 'Term 3', 'E', 'Boarding', 'Continuing'),
(546, 546, '2025-26', 'Primary', 'P.1', 'Term 2', 'D', 'Day', 'New'),
(547, 547, '2025-26', 'Primary', 'P.1', 'Term 3', 'B', 'Boarding', 'New'),
(548, 548, '2025-26', 'Primary', 'P.6', 'Term 3', 'A', 'Boarding', 'Continuing'),
(549, 549, '2025-26', 'Secondary', 'S.2', 'Term 1', 'B', 'Boarding', 'Continuing'),
(550, 550, '2025-26', 'Primary', 'P.3', 'Term 3', 'D', 'Day', 'Continuing'),
(551, 551, '2025-26', 'Primary', 'P.6', 'Term 1', 'D', 'Boarding', 'Continuing'),
(552, 552, '2025-26', 'Secondary', 'S.3', 'Term 3', 'E', 'Boarding', 'Continuing'),
(553, 553, '2025-26', 'Secondary', 'S.1', 'Term 3', 'C', 'Day', 'New'),
(554, 554, '2025-26', 'Secondary', 'S.3', 'Term 2', 'A', 'Boarding', 'Continuing'),
(555, 555, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'E', 'Day', 'Continuing'),
(556, 556, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'B', 'Day', 'New'),
(557, 557, '2025-26', 'Primary', 'P.7', 'Term 1', 'A', 'Day', 'Continuing'),
(558, 558, '2025-26', 'Secondary', 'S.4', 'Term 1', 'E', 'Boarding', 'Continuing'),
(559, 559, '2025-26', 'Primary', 'P.3', 'Term 2', 'E', 'Boarding', 'Continuing'),
(560, 560, '2025-26', 'Secondary', 'S.5', 'Term 2', 'A', 'Day', 'Continuing'),
(561, 561, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'C', 'Day', 'Continuing'),
(562, 562, '2025-26', 'Secondary', 'S.6', 'Term 1', 'D', 'Boarding', 'Continuing'),
(563, 563, '2025-26', 'Primary', 'P.5', 'Term 3', 'E', 'Day', 'Continuing'),
(564, 564, '2025-26', 'Secondary', 'S.2', 'Term 1', 'E', 'Boarding', 'Continuing'),
(565, 565, '2025-26', 'Primary', 'P.5', 'Term 2', 'A', 'Boarding', 'Continuing'),
(566, 566, '2025-26', 'Secondary', 'S.3', 'Term 1', 'E', 'Boarding', 'Continuing'),
(567, 567, '2025-26', 'Secondary', 'S.5', 'Term 1', 'A', 'Boarding', 'Continuing'),
(568, 568, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'A', 'Day', 'New'),
(569, 569, '2025-26', 'Pre-Primary', 'PP.3', 'Term 1', 'C', 'Boarding', 'Continuing'),
(570, 570, '2025-26', 'Secondary', 'S.3', 'Term 1', 'E', 'Boarding', 'Continuing'),
(571, 571, '2025-26', 'Secondary', 'S.1', 'Term 2', 'E', 'Day', 'New'),
(572, 572, '2025-26', 'Primary', 'P.4', 'Term 3', 'B', 'Boarding', 'Continuing'),
(573, 573, '2025-26', 'Primary', 'P.1', 'Term 2', 'C', 'Boarding', 'New'),
(574, 574, '2025-26', 'Primary', 'P.2', 'Term 2', 'B', 'Day', 'Continuing'),
(575, 575, '2025-26', 'Primary', 'P.6', 'Term 3', 'B', 'Day', 'Continuing'),
(576, 576, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'B', 'Day', 'Continuing'),
(577, 577, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'A', 'Day', 'Continuing'),
(578, 578, '2025-26', 'Secondary', 'S.2', 'Term 2', 'E', 'Day', 'Continuing'),
(579, 579, '2025-26', 'Primary', 'P.4', 'Term 2', 'A', 'Day', 'Continuing'),
(580, 580, '2025-26', 'Secondary', 'S.5', 'Term 2', 'C', 'Day', 'Continuing'),
(581, 581, '2025-26', 'Primary', 'P.2', 'Term 3', 'A', 'Boarding', 'Continuing'),
(582, 582, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'C', 'Boarding', 'New'),
(583, 583, '2025-26', 'Secondary', 'S.3', 'Term 1', 'A', 'Boarding', 'Continuing'),
(584, 584, '2025-26', 'Secondary', 'S.1', 'Term 3', 'C', 'Day', 'New'),
(585, 585, '2025-26', 'Secondary', 'S.4', 'Term 3', 'B', 'Boarding', 'Continuing'),
(586, 586, '2025-26', 'Secondary', 'S.3', 'Term 2', 'A', 'Boarding', 'Continuing'),
(587, 587, '2025-26', 'Secondary', 'S.4', 'Term 3', 'C', 'Day', 'Continuing'),
(588, 588, '2025-26', 'Primary', 'P.6', 'Term 3', 'D', 'Boarding', 'Continuing'),
(589, 589, '2025-26', 'Secondary', 'S.5', 'Term 2', 'B', 'Boarding', 'Continuing'),
(590, 590, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'D', 'Boarding', 'Continuing'),
(591, 591, '2025-26', 'Secondary', 'S.4', 'Term 2', 'C', 'Boarding', 'Continuing'),
(592, 592, '2025-26', 'Primary', 'P.4', 'Term 1', 'E', 'Boarding', 'Continuing'),
(593, 593, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'A', 'Boarding', 'Continuing'),
(594, 594, '2025-26', 'Secondary', 'S.2', 'Term 2', 'C', 'Boarding', 'Continuing'),
(595, 595, '2025-26', 'Secondary', 'S.6', 'Term 2', 'E', 'Boarding', 'Continuing'),
(596, 596, '2025-26', 'Primary', 'P.6', 'Term 2', 'C', 'Boarding', 'Continuing'),
(597, 597, '2025-26', 'Secondary', 'S.5', 'Term 3', 'A', 'Boarding', 'Continuing'),
(598, 598, '2025-26', 'Pre-Primary', 'PP.3', 'Term 1', 'B', 'Day', 'Continuing'),
(599, 599, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'D', 'Day', 'Continuing'),
(600, 600, '2025-26', 'Primary', 'P.4', 'Term 3', 'D', 'Boarding', 'Continuing'),
(601, 601, '2025-26', 'Primary', 'P.3', 'Term 3', 'A', 'Day', 'Continuing'),
(602, 602, '2025-26', 'Primary', 'P.1', 'Term 3', 'D', 'Day', 'New'),
(603, 603, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'B', 'Boarding', 'Continuing'),
(604, 604, '2025-26', 'Primary', 'P.5', 'Term 1', 'A', 'Day', 'Continuing'),
(605, 605, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'E', 'Boarding', 'Continuing'),
(606, 606, '2025-26', 'Secondary', 'S.4', 'Term 2', 'B', 'Day', 'Continuing'),
(607, 607, '2025-26', 'Secondary', 'S.3', 'Term 2', 'D', 'Day', 'Continuing'),
(608, 608, '2025-26', 'Secondary', 'S.4', 'Term 1', 'D', 'Day', 'Continuing'),
(609, 609, '2025-26', 'Primary', 'P.1', 'Term 2', 'D', 'Day', 'New'),
(610, 610, '2025-26', 'Secondary', 'S.6', 'Term 2', 'E', 'Boarding', 'Continuing'),
(611, 611, '2025-26', 'Primary', 'P.4', 'Term 1', 'C', 'Boarding', 'Continuing'),
(612, 612, '2025-26', 'Primary', 'P.5', 'Term 3', 'D', 'Boarding', 'Continuing'),
(613, 613, '2025-26', 'Primary', 'P.6', 'Term 1', 'D', 'Day', 'Continuing'),
(614, 614, '2025-26', 'Secondary', 'S.5', 'Term 3', 'D', 'Day', 'Continuing'),
(615, 615, '2025-26', 'Secondary', 'S.4', 'Term 3', 'D', 'Day', 'Continuing'),
(616, 616, '2025-26', 'Secondary', 'S.1', 'Term 3', 'A', 'Boarding', 'New'),
(617, 617, '2025-26', 'Primary', 'P.3', 'Term 3', 'A', 'Boarding', 'Continuing'),
(618, 618, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'A', 'Day', 'Continuing'),
(619, 619, '2025-26', 'Secondary', 'S.2', 'Term 1', 'C', 'Day', 'Continuing'),
(620, 620, '2025-26', 'Secondary', 'S.1', 'Term 2', 'A', 'Boarding', 'New'),
(621, 621, '2025-26', 'Primary', 'P.1', 'Term 3', 'B', 'Boarding', 'New'),
(622, 622, '2025-26', 'Secondary', 'S.5', 'Term 1', 'A', 'Boarding', 'Continuing'),
(623, 623, '2025-26', 'Primary', 'P.3', 'Term 3', 'A', 'Boarding', 'Continuing'),
(624, 624, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'A', 'Day', 'Continuing'),
(625, 625, '2025-26', 'Secondary', 'S.1', 'Term 2', 'E', 'Boarding', 'New'),
(626, 626, '2025-26', 'Secondary', 'S.3', 'Term 3', 'C', 'Day', 'Continuing'),
(627, 627, '2025-26', 'Primary', 'P.7', 'Term 2', 'B', 'Boarding', 'Continuing'),
(628, 628, '2025-26', 'Secondary', 'S.4', 'Term 2', 'C', 'Day', 'Continuing'),
(629, 629, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'E', 'Day', 'New'),
(630, 630, '2025-26', 'Primary', 'P.7', 'Term 2', 'A', 'Day', 'Continuing'),
(631, 631, '2025-26', 'Secondary', 'S.4', 'Term 3', 'A', 'Day', 'Continuing'),
(632, 632, '2025-26', 'Primary', 'P.3', 'Term 2', 'E', 'Day', 'Continuing'),
(633, 633, '2025-26', 'Primary', 'P.7', 'Term 2', 'D', 'Day', 'Continuing'),
(634, 634, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'E', 'Day', 'Continuing'),
(635, 635, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'A', 'Day', 'Continuing'),
(636, 636, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'C', 'Boarding', 'New'),
(637, 637, '2025-26', 'Primary', 'P.6', 'Term 1', 'C', 'Boarding', 'Continuing'),
(638, 638, '2025-26', 'Secondary', 'S.6', 'Term 2', 'D', 'Boarding', 'Continuing'),
(639, 639, '2025-26', 'Primary', 'P.6', 'Term 2', 'E', 'Day', 'Continuing'),
(640, 640, '2025-26', 'Primary', 'P.5', 'Term 1', 'A', 'Day', 'Continuing'),
(641, 641, '2025-26', 'Secondary', 'S.6', 'Term 3', 'C', 'Boarding', 'Continuing'),
(642, 642, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'C', 'Boarding', 'Continuing'),
(643, 643, '2025-26', 'Primary', 'P.3', 'Term 2', 'E', 'Boarding', 'Continuing');
INSERT INTO `enrollment` (`EnrollmentID`, `StudentID`, `AcademicYear`, `Level`, `Class`, `Term`, `Stream`, `Residence`, `EntryStatus`) VALUES
(644, 644, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'B', 'Day', 'New'),
(645, 645, '2025-26', 'Primary', 'P.2', 'Term 2', 'C', 'Boarding', 'Continuing'),
(646, 646, '2025-26', 'Secondary', 'S.2', 'Term 2', 'C', 'Day', 'Continuing'),
(647, 647, '2025-26', 'Secondary', 'S.5', 'Term 2', 'D', 'Boarding', 'Continuing'),
(648, 648, '2025-26', 'Secondary', 'S.1', 'Term 3', 'A', 'Day', 'New'),
(649, 649, '2025-26', 'Primary', 'P.2', 'Term 3', 'B', 'Boarding', 'Continuing'),
(650, 650, '2025-26', 'Primary', 'P.2', 'Term 2', 'A', 'Day', 'Continuing'),
(651, 651, '2025-26', 'Secondary', 'S.3', 'Term 3', 'A', 'Boarding', 'Continuing'),
(652, 652, '2025-26', 'Primary', 'P.7', 'Term 2', 'D', 'Boarding', 'Continuing'),
(653, 653, '2025-26', 'Primary', 'P.6', 'Term 1', 'C', 'Boarding', 'Continuing'),
(654, 654, '2025-26', 'Secondary', 'S.5', 'Term 3', 'E', 'Day', 'Continuing'),
(655, 655, '2025-26', 'Primary', 'P.3', 'Term 2', 'A', 'Boarding', 'Continuing'),
(656, 656, '2025-26', 'Secondary', 'S.4', 'Term 2', 'B', 'Boarding', 'Continuing'),
(657, 657, '2025-26', 'Secondary', 'S.4', 'Term 1', 'E', 'Boarding', 'Continuing'),
(658, 658, '2025-26', 'Secondary', 'S.5', 'Term 3', 'C', 'Boarding', 'Continuing'),
(659, 659, '2025-26', 'Primary', 'P.1', 'Term 2', 'D', 'Day', 'New'),
(660, 660, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'B', 'Day', 'Continuing'),
(661, 661, '2025-26', 'Primary', 'P.5', 'Term 3', 'B', 'Day', 'Continuing'),
(662, 662, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'D', 'Day', 'Continuing'),
(663, 663, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'B', 'Day', 'New'),
(664, 664, '2025-26', 'Primary', 'P.7', 'Term 3', 'D', 'Day', 'Continuing'),
(665, 665, '2025-26', 'Primary', 'P.1', 'Term 1', 'B', 'Day', 'New'),
(666, 666, '2025-26', 'Primary', 'P.4', 'Term 3', 'C', 'Day', 'Continuing'),
(667, 667, '2025-26', 'Secondary', 'S.2', 'Term 2', 'C', 'Day', 'Continuing'),
(668, 668, '2025-26', 'Secondary', 'S.1', 'Term 3', 'A', 'Boarding', 'New'),
(669, 669, '2025-26', 'Primary', 'P.3', 'Term 3', 'E', 'Day', 'Continuing'),
(670, 670, '2025-26', 'Secondary', 'S.6', 'Term 3', 'A', 'Boarding', 'Continuing'),
(671, 671, '2025-26', 'Primary', 'P.5', 'Term 1', 'B', 'Boarding', 'Continuing'),
(672, 672, '2025-26', 'Secondary', 'S.4', 'Term 1', 'D', 'Day', 'Continuing'),
(673, 673, '2025-26', 'Secondary', 'S.5', 'Term 1', 'E', 'Boarding', 'Continuing'),
(674, 674, '2025-26', 'Secondary', 'S.1', 'Term 1', 'B', 'Day', 'New'),
(675, 675, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'C', 'Boarding', 'Continuing'),
(676, 676, '2025-26', 'Primary', 'P.2', 'Term 1', 'D', 'Day', 'Continuing'),
(677, 677, '2025-26', 'Primary', 'P.3', 'Term 1', 'B', 'Boarding', 'Continuing'),
(678, 678, '2025-26', 'Primary', 'P.1', 'Term 2', 'D', 'Day', 'New'),
(679, 679, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'D', 'Boarding', 'New'),
(680, 680, '2025-26', 'Primary', 'P.1', 'Term 3', 'D', 'Day', 'New'),
(681, 681, '2025-26', 'Secondary', 'S.2', 'Term 3', 'B', 'Day', 'Continuing'),
(682, 682, '2025-26', 'Secondary', 'S.1', 'Term 3', 'C', 'Boarding', 'New'),
(683, 683, '2025-26', 'Secondary', 'S.2', 'Term 1', 'D', 'Boarding', 'Continuing'),
(684, 684, '2025-26', 'Secondary', 'S.5', 'Term 2', 'B', 'Day', 'Continuing'),
(685, 685, '2025-26', 'Secondary', 'S.6', 'Term 3', 'B', 'Boarding', 'Continuing'),
(686, 686, '2025-26', 'Secondary', 'S.2', 'Term 3', 'B', 'Day', 'Continuing'),
(687, 687, '2025-26', 'Primary', 'P.4', 'Term 2', 'C', 'Day', 'Continuing'),
(688, 688, '2025-26', 'Primary', 'P.1', 'Term 3', 'C', 'Boarding', 'New'),
(689, 689, '2025-26', 'Secondary', 'S.1', 'Term 2', 'A', 'Day', 'New'),
(690, 690, '2025-26', 'Primary', 'P.5', 'Term 2', 'C', 'Day', 'Continuing'),
(691, 691, '2025-26', 'Primary', 'P.5', 'Term 3', 'E', 'Boarding', 'Continuing'),
(692, 692, '2025-26', 'Primary', 'P.5', 'Term 2', 'C', 'Day', 'Continuing'),
(693, 693, '2025-26', 'Secondary', 'S.2', 'Term 1', 'A', 'Day', 'Continuing'),
(694, 694, '2026-27', 'pre-primary', 'PP.1', 'Term 1', '', 'Day', 'New'),
(695, 695, '2025-26', 'Primary', 'P.5', 'Term 1', 'D', 'Day', 'Continuing'),
(696, 696, '2025-26', 'Secondary', 'S.2', 'Term 1', 'B', 'Day', 'Continuing'),
(697, 697, '2025-26', 'Primary', 'P.4', 'Term 2', 'E', 'Boarding', 'Continuing'),
(698, 698, '2025-26', 'Secondary', 'S.3', 'Term 2', 'A', 'Boarding', 'Continuing'),
(699, 699, '2025-26', 'Primary', 'P.6', 'Term 3', 'B', 'Day', 'Continuing'),
(700, 700, '2025-26', 'Primary', 'P.4', 'Term 1', 'D', 'Day', 'Continuing'),
(701, 701, '2025-26', 'Primary', 'P.2', 'Term 3', 'A', 'Day', 'Continuing'),
(702, 702, '2025-26', 'Primary', 'P.7', 'Term 2', 'D', 'Day', 'Continuing'),
(703, 703, '2025-26', 'Primary', 'P.6', 'Term 3', 'A', 'Boarding', 'Continuing'),
(704, 704, '2025-26', 'Primary', 'P.1', 'Term 2', 'E', 'Day', 'New'),
(705, 705, '2025-26', 'Secondary', 'S.5', 'Term 3', 'C', 'Boarding', 'Continuing'),
(706, 706, '2025-26', 'Secondary', 'S.5', 'Term 2', 'B', 'Day', 'Continuing'),
(707, 707, '2025-26', 'Primary', 'P.3', 'Term 2', 'B', 'Day', 'Continuing'),
(708, 708, '2025-26', 'Secondary', 'S.6', 'Term 2', 'D', 'Boarding', 'Continuing'),
(709, 709, '2025-26', 'Secondary', 'S.1', 'Term 2', 'E', 'Boarding', 'New'),
(710, 710, '2025-26', 'Primary', 'P.5', 'Term 3', 'C', 'Day', 'Continuing'),
(711, 711, '2025-26', 'Primary', 'P.2', 'Term 2', 'D', 'Day', 'Continuing'),
(712, 712, '2025-26', 'Secondary', 'S.5', 'Term 2', 'E', 'Day', 'Continuing'),
(713, 713, '2025-26', 'Secondary', 'S.1', 'Term 3', 'D', 'Boarding', 'New'),
(714, 714, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'E', 'Day', 'Continuing'),
(715, 715, '2025-26', 'Primary', 'P.2', 'Term 3', 'E', 'Boarding', 'Continuing'),
(716, 716, '2025-26', 'Secondary', 'S.4', 'Term 2', 'A', 'Day', 'Continuing'),
(717, 717, '2025-26', 'Secondary', 'S.2', 'Term 1', 'D', 'Day', 'Continuing'),
(718, 718, '2025-26', 'Primary', 'P.4', 'Term 3', 'E', 'Day', 'Continuing'),
(719, 719, '2025-26', 'Primary', 'P.5', 'Term 3', 'C', 'Boarding', 'Continuing'),
(720, 720, '2025-26', 'Primary', 'P.7', 'Term 1', 'A', 'Day', 'Continuing'),
(721, 721, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'C', 'Day', 'New'),
(722, 722, '2025-26', 'Primary', 'P.7', 'Term 2', 'E', 'Boarding', 'Continuing'),
(723, 723, '2025-26', 'Secondary', 'S.3', 'Term 2', 'D', 'Day', 'Continuing'),
(724, 724, '2025-26', 'Secondary', 'S.3', 'Term 3', 'B', 'Boarding', 'Continuing'),
(725, 725, '2025-26', 'Primary', 'P.6', 'Term 2', 'D', 'Day', 'Continuing'),
(726, 726, '2025-26', 'Secondary', 'S.4', 'Term 3', 'D', 'Day', 'Continuing'),
(727, 727, '2025-26', 'Primary', 'P.6', 'Term 3', 'A', 'Day', 'Continuing'),
(728, 728, '2025-26', 'Secondary', 'S.2', 'Term 3', 'C', 'Boarding', 'Continuing'),
(729, 729, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'B', 'Day', 'New'),
(730, 730, '2025-26', 'Pre-Primary', 'PP.3', 'Term 1', 'A', 'Day', 'Continuing'),
(731, 731, '2025-26', 'Primary', 'P.7', 'Term 1', 'D', 'Boarding', 'Continuing'),
(732, 732, '2025-26', 'Secondary', 'S.6', 'Term 3', 'C', 'Day', 'Continuing'),
(733, 733, '2025-26', 'Secondary', 'S.6', 'Term 2', 'A', 'Day', 'Continuing'),
(734, 734, '2025-26', 'Primary', 'P.1', 'Term 1', 'B', 'Boarding', 'New'),
(735, 735, '2025-26', 'Primary', 'P.6', 'Term 2', 'E', 'Boarding', 'Continuing'),
(736, 736, '2025-26', 'Primary', 'P.2', 'Term 3', 'A', 'Boarding', 'Continuing'),
(737, 737, '2025-26', 'Primary', 'P.1', 'Term 2', 'E', 'Boarding', 'New'),
(738, 738, '2025-26', 'Secondary', 'S.4', 'Term 3', 'C', 'Day', 'Continuing'),
(739, 739, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'D', 'Day', 'New'),
(740, 740, '2025-26', 'Primary', 'P.2', 'Term 1', 'D', 'Boarding', 'Continuing'),
(741, 741, '2025-26', 'Secondary', 'S.6', 'Term 2', 'A', 'Day', 'Continuing'),
(742, 742, '2025-26', 'Secondary', 'S.6', 'Term 1', 'C', 'Day', 'Continuing'),
(743, 743, '2025-26', 'Primary', 'P.2', 'Term 2', 'D', 'Day', 'Continuing'),
(744, 744, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'C', 'Boarding', 'Continuing'),
(745, 745, '2025-26', 'Secondary', 'S.1', 'Term 1', 'B', 'Boarding', 'New'),
(746, 746, '2025-26', 'Secondary', 'S.4', 'Term 2', 'B', 'Day', 'Continuing'),
(747, 747, '2025-26', 'Secondary', 'S.4', 'Term 2', 'C', 'Day', 'Continuing'),
(748, 748, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'C', 'Day', 'Continuing'),
(749, 749, '2025-26', 'Pre-Primary', 'PP.3', 'Term 1', 'E', 'Boarding', 'Continuing'),
(750, 750, '2025-26', 'Secondary', 'S.1', 'Term 1', 'B', 'Boarding', 'New'),
(751, 751, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'A', 'Boarding', 'Continuing'),
(752, 752, '2025-26', 'Primary', 'P.4', 'Term 3', 'B', 'Boarding', 'Continuing'),
(753, 753, '2025-26', 'Primary', 'P.7', 'Term 1', 'A', 'Boarding', 'Continuing'),
(754, 754, '2025-26', 'Primary', 'P.1', 'Term 2', 'D', 'Day', 'New'),
(755, 755, '2025-26', 'Secondary', 'S.5', 'Term 1', 'B', 'Day', 'Continuing'),
(756, 756, '2025-26', 'Secondary', 'S.3', 'Term 3', 'A', 'Boarding', 'Continuing'),
(757, 757, '2025-26', 'Primary', 'P.6', 'Term 1', 'B', 'Boarding', 'Continuing'),
(758, 758, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'B', 'Day', 'Continuing'),
(759, 759, '2025-26', 'Secondary', 'S.4', 'Term 3', 'D', 'Day', 'Continuing'),
(760, 760, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'A', 'Boarding', 'New'),
(761, 761, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'C', 'Day', 'Continuing'),
(762, 762, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'E', 'Boarding', 'New'),
(763, 763, '2025-26', 'Primary', 'P.5', 'Term 3', 'E', 'Boarding', 'Continuing'),
(764, 764, '2025-26', 'Primary', 'P.7', 'Term 3', 'C', 'Boarding', 'Continuing'),
(765, 765, '2025-26', 'Primary', 'P.5', 'Term 1', 'D', 'Day', 'Continuing'),
(766, 766, '2025-26', 'Primary', 'P.1', 'Term 2', 'B', 'Boarding', 'New'),
(767, 767, '2025-26', 'Primary', 'P.2', 'Term 1', 'B', 'Boarding', 'Continuing'),
(768, 768, '2025-26', 'Secondary', 'S.4', 'Term 1', 'D', 'Boarding', 'Continuing'),
(769, 769, '2025-26', 'Primary', 'P.3', 'Term 2', 'B', 'Day', 'Continuing'),
(770, 770, '2025-26', 'Secondary', 'S.3', 'Term 2', 'A', 'Day', 'Continuing'),
(771, 771, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'E', 'Boarding', 'New'),
(772, 772, '2025-26', 'Primary', 'P.7', 'Term 1', 'B', 'Boarding', 'Continuing'),
(773, 773, '2025-26', 'Secondary', 'S.5', 'Term 3', 'E', 'Boarding', 'Continuing'),
(774, 774, '2025-26', 'Primary', 'P.7', 'Term 1', 'C', 'Day', 'Continuing'),
(775, 775, '2025-26', 'Secondary', 'S.2', 'Term 3', 'A', 'Day', 'Continuing'),
(776, 776, '2025-26', 'Secondary', 'S.1', 'Term 1', 'D', 'Day', 'New'),
(777, 777, '2025-26', 'Primary', 'P.7', 'Term 1', 'A', 'Day', 'Continuing'),
(778, 778, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'E', 'Boarding', 'Continuing'),
(779, 779, '2025-26', 'Secondary', 'S.5', 'Term 3', 'D', 'Boarding', 'Continuing'),
(780, 780, '2025-26', 'Secondary', 'S.1', 'Term 3', 'D', 'Boarding', 'New'),
(781, 781, '2025-26', 'Secondary', 'S.3', 'Term 1', 'B', 'Boarding', 'Continuing'),
(782, 782, '2025-26', 'Secondary', 'S.3', 'Term 3', 'C', 'Day', 'Continuing'),
(783, 783, '2025-26', 'Secondary', 'S.1', 'Term 2', 'D', 'Boarding', 'New'),
(784, 784, '2025-26', 'Secondary', 'S.1', 'Term 1', 'B', 'Boarding', 'New'),
(785, 785, '2025-26', 'Primary', 'P.3', 'Term 3', 'C', 'Boarding', 'Continuing'),
(786, 786, '2025-26', 'Primary', 'P.1', 'Term 3', 'A', 'Boarding', 'New'),
(787, 787, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'D', 'Day', 'Continuing'),
(788, 788, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'B', 'Day', 'Continuing'),
(789, 789, '2025-26', 'Secondary', 'S.2', 'Term 2', 'A', 'Boarding', 'Continuing'),
(790, 790, '2025-26', 'Secondary', 'S.4', 'Term 2', 'B', 'Boarding', 'Continuing'),
(791, 791, '2025-26', 'Primary', 'P.6', 'Term 3', 'D', 'Day', 'Continuing'),
(792, 792, '2025-26', 'Secondary', 'S.5', 'Term 2', 'D', 'Boarding', 'Continuing'),
(793, 793, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'D', 'Boarding', 'Continuing'),
(794, 794, '2025-26', 'Secondary', 'S.2', 'Term 3', 'A', 'Day', 'Continuing'),
(795, 795, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'E', 'Boarding', 'New'),
(796, 796, '2025-26', 'Primary', 'P.7', 'Term 2', 'B', 'Day', 'Continuing'),
(797, 797, '2025-26', 'Primary', 'P.4', 'Term 3', 'B', 'Day', 'Continuing'),
(798, 798, '2025-26', 'Primary', 'P.5', 'Term 1', 'E', 'Day', 'Continuing'),
(799, 799, '2025-26', 'Secondary', 'S.3', 'Term 2', 'C', 'Boarding', 'Continuing'),
(800, 800, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'B', 'Day', 'Continuing');

-- --------------------------------------------------------

--
-- Table structure for table `enrollmenthistory`
--

CREATE TABLE `enrollmenthistory` (
  `HistoryID` int(11) NOT NULL,
  `StudentID` int(11) NOT NULL,
  `AcademicYear` varchar(20) NOT NULL,
  `Level` varchar(50) NOT NULL,
  `Class` varchar(50) NOT NULL,
  `Term` varchar(50) NOT NULL,
  `Stream` varchar(50) DEFAULT NULL,
  `Residence` varchar(50) NOT NULL,
  `EntryStatus` varchar(50) NOT NULL,
  `DateMoved` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `enrollmenthistory`
--

INSERT INTO `enrollmenthistory` (`HistoryID`, `StudentID`, `AcademicYear`, `Level`, `Class`, `Term`, `Stream`, `Residence`, `EntryStatus`, `DateMoved`) VALUES
(1, 694, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'A', 'Day', 'New', '2025-12-04 09:44:18'),
(2, 694, '2025-26', 'pre-primary', 'PP.1', 'Term 1', 'A', 'Day', 'New', '2025-12-04 09:53:29'),
(3, 535, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'C', 'Day', 'New', '2025-12-04 09:54:41'),
(4, 57, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'D', 'Day', 'New', '2025-12-04 09:55:52'),
(5, 509, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'A', 'Day', 'New', '2025-12-04 10:05:04'),
(6, 312, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'A', 'Day', 'New', '2025-12-04 10:08:08'),
(7, 151, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'D', 'Boarding', 'New', '2025-12-04 10:14:06'),
(8, 420, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'A', 'Day', 'New', '2025-12-04 10:20:59');

-- --------------------------------------------------------

--
-- Table structure for table `parents`
--

CREATE TABLE `parents` (
  `ParentId` int(11) NOT NULL,
  `StudentID` int(11) NOT NULL,
  `father_name` varchar(255) NOT NULL,
  `father_age` int(11) DEFAULT NULL,
  `father_contact` varchar(50) DEFAULT NULL,
  `father_occupation` varchar(100) DEFAULT NULL,
  `father_education` varchar(100) DEFAULT NULL,
  `mother_name` varchar(255) NOT NULL,
  `mother_age` int(11) DEFAULT NULL,
  `mother_contact` varchar(50) DEFAULT NULL,
  `mother_occupation` varchar(100) DEFAULT NULL,
  `mother_education` varchar(100) DEFAULT NULL,
  `guardian_name` varchar(255) DEFAULT NULL,
  `guardian_relation` enum('Father','Mother','Uncle','Aunt','Grandparent','Other') DEFAULT NULL,
  `guardian_age` int(11) DEFAULT NULL,
  `guardian_contact` varchar(50) DEFAULT NULL,
  `guardian_occupation` varchar(100) DEFAULT NULL,
  `guardian_education` varchar(100) DEFAULT NULL,
  `guardian_address` text DEFAULT NULL,
  `MoreInformation` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `parents`
--

INSERT INTO `parents` (`ParentId`, `StudentID`, `father_name`, `father_age`, `father_contact`, `father_occupation`, `father_education`, `mother_name`, `mother_age`, `mother_contact`, `mother_occupation`, `mother_education`, `guardian_name`, `guardian_relation`, `guardian_age`, `guardian_contact`, `guardian_occupation`, `guardian_education`, `guardian_address`, `MoreInformation`) VALUES
(1, 1, 'Mark Akello', 42, '+256774289237', 'Doctor', 'Diploma', 'Alice Nantogo', 32, '+256701240858', 'Tailor', 'Bachelor’s Degree', '', '', NULL, '', NULL, NULL, '', 'Active in debate club'),
(2, 2, 'Andrew Kyomuhendo', 67, '+256709937302', 'Civil Servant', 'Bachelor’s Degree', 'Joan Akello', 42, '+256705640561', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(3, 3, 'Ivan Musoke', 40, '+256709420427', 'Driver', 'Master’s Degree', 'Sarah Nantogo', 60, '+256752007919', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(4, 4, 'Moses Aine', 57, '+256777175430', 'Engineer', 'Bachelor’s Degree', 'Esther Byaruhanga', 44, '+256706156371', 'Tailor', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(5, 5, 'Ivan Okello', 56, '+256777045838', 'Doctor', 'Secondary', 'Mercy Kyomuhendo', 43, '+256782740093', 'Trader', 'Secondary', 'Robert Okello', 'Mother', 40, '+256702003666', 'Engineer', 'Secondary', 'Mbarara', 'Prefect'),
(6, 6, 'Andrew Namukasa', 34, '+256759501709', 'Carpenter', 'Diploma', 'Esther Mugabe', 43, '+256704322931', 'Nurse', 'Master’s Degree', 'James Namukasa', 'Grandparent', 73, '+256785433486', 'Engineer', 'Secondary', 'Fort Portal', 'Active in debate club'),
(7, 7, 'Brian Ochieng', 44, '+256701925589', 'Engineer', 'Bachelor’s Degree', 'Brenda Kato', 41, '+256704293412', 'Civil Servant', 'Diploma', '', '', NULL, '', NULL, NULL, '', 'Football team'),
(8, 8, 'Solomon Kyomuhendo', 50, '+256754730536', 'Engineer', 'Secondary', 'Joy Musoke', 58, '+256758177233', 'Civil Servant', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(9, 9, 'Andrew Nalubega', 51, '+256704248501', 'Shopkeeper', 'Secondary', 'Mercy Nalubega', 42, '+256778333889', 'Trader', 'Diploma', 'Hellen Nalubega', 'Uncle', 73, '+256788417000', 'Mechanic', 'Primary', 'Jinja', 'Active in debate club'),
(10, 10, 'Samuel Kato', 30, '+256771748155', 'Civil Servant', 'Master’s Degree', 'Winnie Akello', 35, '+256776997375', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(11, 11, 'Ivan Nalubega', 42, '+256707476866', 'Engineer', 'Primary', 'Doreen Ssemwogerere', 56, '+256788658568', 'Teacher', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(12, 12, 'John Byaruhanga', 45, '+256703082870', 'Doctor', 'Primary', 'Sandra Nalubega', 38, '+256756397886', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(13, 13, 'Brian Kato', 57, '+256702676128', 'Mechanic', 'Diploma', 'Joan Nakato', 36, '+256785691647', 'Civil Servant', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(14, 14, 'Solomon Byaruhanga', 43, '+256775993545', 'Mechanic', 'Master’s Degree', 'Mercy Nalubega', 51, '+256774606881', 'Nurse', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(15, 15, 'Brian Kato', 63, '+256785359062', 'Civil Servant', 'Master’s Degree', 'Sandra Ssemwogerere', 45, '+256709835494', 'Tailor', 'Master’s Degree', 'Hellen Kato', 'Grandparent', 66, '+256786946281', 'Driver', 'Secondary', 'Soroti', 'Active in debate club'),
(16, 16, 'Ivan Tumusiime', 67, '+256782318165', 'Doctor', 'Diploma', 'Rebecca Namukasa', 37, '+256783942349', 'Teacher', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(17, 17, 'Paul Opio', 55, '+256783393800', 'Engineer', 'Secondary', 'Brenda Busingye', 39, '+256786755958', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(18, 18, 'Moses Kato', 59, '+256755599306', 'Farmer', 'Diploma', 'Esther Kato', 28, '+256771016326', 'Nurse', 'Primary', 'Charles Kato', 'Other', 78, '+256789115369', 'Teacher', 'Secondary', 'Mbarara', 'Choir member'),
(19, 19, 'Joseph Byaruhanga', 60, '+256703827681', 'Carpenter', 'Primary', 'Alice Ssemwogerere', 40, '+256754628193', 'Tailor', 'Secondary', 'Alice Byaruhanga', 'Uncle', 58, '+256754691648', 'Mechanic', 'Master’s Degree', 'Mbarara', 'Science fair participant'),
(20, 20, 'Samuel Opio', 57, '+256782909205', 'Carpenter', 'Master’s Degree', 'Brenda Tumusiime', 30, '+256777131888', 'Teacher', 'Primary', 'Hellen Opio', 'Grandparent', 49, '+256755819846', 'Civil Servant', 'Diploma', 'Masaka', 'Prefect'),
(21, 21, 'Samuel Mugabe', 42, '+256754995097', 'Doctor', 'Secondary', 'Mercy Musoke', 60, '+256752235930', 'Entrepreneur', 'Secondary', 'Hellen Mugabe', 'Grandparent', 68, '+256788823707', 'Mechanic', 'Secondary', 'Mbarara', 'Science fair participant'),
(22, 22, 'Andrew Aine', 51, '+256704189239', 'Civil Servant', 'Bachelor’s Degree', 'Ritah Busingye', 44, '+256785010581', 'Entrepreneur', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(23, 23, 'John Kato', 39, '+256789407928', 'Engineer', 'Primary', 'Ritah Kyomuhendo', 43, '+256771179382', 'Entrepreneur', 'Bachelor’s Degree', 'Robert Kato', 'Uncle', 62, '+256771900301', 'Doctor', 'Primary', 'Gulu', 'Science fair participant'),
(24, 24, 'Andrew Namukasa', 56, '+256786792007', 'Engineer', 'Primary', 'Grace Ochieng', 43, '+256783201608', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(25, 25, 'Ivan Mugabe', 32, '+256777864806', 'Teacher', 'Primary', 'Joan Nakato', 59, '+256784968772', 'Entrepreneur', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(26, 26, 'Isaac Okello', 40, '+256754731376', 'Teacher', 'Secondary', 'Sandra Nantogo', 60, '+256709798364', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(27, 27, 'Ivan Namukasa', 39, '+256778152786', 'Carpenter', 'Primary', 'Mercy Opio', 36, '+256704645463', 'Entrepreneur', 'Master’s Degree', 'Charles Namukasa', 'Uncle', 63, '+256788261629', 'Farmer', 'Master’s Degree', 'Kampala', 'Prefect'),
(28, 28, 'Isaac Opio', 43, '+256705726869', 'Teacher', 'Diploma', 'Brenda Mukasa', 40, '+256789800228', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(29, 29, 'David Waiswa', 60, '+256775049136', 'Engineer', 'Master’s Degree', 'Pritah Opio', 63, '+256706080082', 'Nurse', 'Bachelor’s Degree', 'Charles Waiswa', 'Father', 78, '+256785220839', 'Shopkeeper', 'Primary', 'Soroti', 'Science fair participant'),
(30, 30, 'Samuel Namukasa', 59, '+256771245240', 'Driver', 'Diploma', 'Pritah Busingye', 52, '+256754191576', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(31, 31, 'Brian Aine', 40, '+256703849344', 'Engineer', 'Primary', 'Doreen Nakato', 36, '+256774152146', 'Farmer', 'Master’s Degree', 'Susan Aine', 'Father', 63, '+256708855032', 'Engineer', 'Diploma', 'Fort Portal', 'Football team'),
(32, 32, 'John Ssemwogerere', 42, '+256703034433', 'Carpenter', 'Secondary', 'Joy Kato', 45, '+256704520485', 'Farmer', 'Secondary', 'James Ssemwogerere', 'Grandparent', 72, '+256754557816', 'Mechanic', 'Master’s Degree', 'Fort Portal', 'Active in debate club'),
(33, 33, 'David Nantogo', 39, '+256709198749', 'Driver', 'Diploma', 'Joy Ssemwogerere', 43, '+256779202124', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(34, 34, 'Solomon Lwanga', 66, '+256777182656', 'Driver', 'Bachelor’s Degree', 'Winnie Byaruhanga', 52, '+256753726927', 'Tailor', 'Secondary', 'Susan Lwanga', 'Mother', 76, '+256708296384', 'Carpenter', 'Secondary', 'Soroti', 'Prefect'),
(35, 35, 'Daniel Waiswa', 42, '+256772696200', 'Mechanic', 'Master’s Degree', 'Pritah Mukasa', 36, '+256707032562', 'Farmer', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(36, 36, 'Daniel Kyomuhendo', 54, '+256773391362', 'Doctor', 'Diploma', 'Brenda Tumusiime', 51, '+256776334820', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(37, 37, 'Isaac Nakato', 65, '+256702758768', 'Carpenter', 'Diploma', 'Winnie Musoke', 44, '+256758257420', 'Housewife', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(38, 38, 'Mark Busingye', 61, '+256755660886', 'Engineer', 'Secondary', 'Winnie Lwanga', 50, '+256786672218', 'Farmer', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(39, 39, 'David Namukasa', 37, '+256709246778', 'Doctor', 'Bachelor’s Degree', 'Pritah Nakato', 38, '+256772136344', 'Entrepreneur', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(40, 40, 'John Opio', 50, '+256774116096', 'Driver', 'Master’s Degree', 'Grace Okello', 62, '+256778237643', 'Teacher', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(41, 41, 'Timothy Akello', 59, '+256752482837', 'Farmer', 'Bachelor’s Degree', 'Rebecca Ssemwogerere', 30, '+256755979012', 'Civil Servant', 'Secondary', 'Alice Akello', 'Aunt', 56, '+256755001934', 'Teacher', 'Master’s Degree', 'Kampala', 'Football team'),
(42, 42, 'John Musoke', 41, '+256702873641', 'Carpenter', 'Primary', 'Joan Lwanga', 63, '+256759075393', 'Farmer', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(43, 43, 'Moses Akello', 39, '+256708209286', 'Carpenter', 'Diploma', 'Sandra Nalubega', 59, '+256753426420', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(44, 44, 'Joseph Ochieng', 50, '+256776175895', 'Mechanic', 'Master’s Degree', 'Brenda Aine', 49, '+256753796158', 'Entrepreneur', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(45, 45, 'Paul Nalubega', 47, '+256788014228', 'Carpenter', 'Master’s Degree', 'Mercy Aine', 61, '+256755371214', 'Farmer', 'Master’s Degree', 'Robert Nalubega', 'Uncle', 25, '+256773920483', 'Carpenter', 'Primary', 'Mbarara', 'Choir member'),
(46, 46, 'Mark Nalubega', 63, '+256778321224', 'Carpenter', 'Secondary', 'Ritah Busingye', 37, '+256789430496', 'Tailor', 'Diploma', 'Charles Nalubega', 'Father', 72, '+256752223468', 'Farmer', 'Secondary', 'Jinja', 'Science fair participant'),
(47, 47, 'Samuel Tumusiime', 31, '+256771948265', 'Carpenter', 'Primary', 'Doreen Musoke', 56, '+256707606018', 'Trader', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(48, 48, 'John Nakato', 56, '+256774556931', 'Farmer', 'Bachelor’s Degree', 'Sarah Kyomuhendo', 46, '+256756660852', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(49, 49, 'Andrew Nantogo', 65, '+256704986721', 'Farmer', 'Primary', 'Brenda Akello', 60, '+256702698091', 'Housewife', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(50, 50, 'Paul Lwanga', 44, '+256703280873', 'Teacher', 'Master’s Degree', 'Alice Akello', 46, '+256751115438', 'Tailor', 'Master’s Degree', 'Florence Lwanga', 'Other', 68, '+256789780762', 'Farmer', 'Diploma', 'Lira', 'Choir member'),
(51, 51, 'Mark Lwanga', 69, '+256706949959', 'Mechanic', 'Master’s Degree', 'Esther Kyomuhendo', 36, '+256787403076', 'Entrepreneur', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(52, 52, 'Joseph Nakato', 66, '+256783899495', 'Shopkeeper', 'Primary', 'Doreen Namukasa', 61, '+256774434128', 'Teacher', 'Primary', 'Susan Nakato', 'Mother', 57, '+256782701707', 'Doctor', 'Bachelor’s Degree', 'Kampala', 'Prefect'),
(53, 53, 'Andrew Waiswa', 36, '+256708230494', 'Engineer', 'Secondary', 'Mercy Kato', 36, '+256706949946', 'Farmer', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(54, 54, 'Paul Musoke', 30, '+256706600021', 'Farmer', 'Master’s Degree', 'Joy Kyomuhendo', 43, '+256778207668', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(55, 55, 'Timothy Ochieng', 54, '+256786270326', 'Doctor', 'Diploma', 'Rebecca Kyomuhendo', 61, '+256703353544', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(56, 56, 'John Nalubega', 37, '+256779750239', 'Teacher', 'Diploma', 'Doreen Ssemwogerere', 52, '+256786406560', 'Trader', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(57, 57, 'Joseph Nantogo', 49, '+256754617376', 'Farmer', 'Diploma', 'Winnie Kyomuhendo', 51, '+256787374083', 'Entrepreneur', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(58, 58, 'Ivan Nalubega', 30, '+256709096357', 'Doctor', 'Diploma', 'Winnie Okello', 34, '+256758306818', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(59, 59, 'David Kyomuhendo', 45, '+256772170921', 'Driver', 'Diploma', 'Rebecca Lwanga', 35, '+256776182252', 'Teacher', 'Master’s Degree', 'Lillian Kyomuhendo', 'Uncle', 45, '+256788608581', 'Civil Servant', 'Bachelor’s Degree', 'Soroti', 'Science fair participant'),
(60, 60, 'Moses Tumusiime', 67, '+256708783116', 'Farmer', 'Master’s Degree', 'Alice Busingye', 43, '+256786878691', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(61, 61, 'Samuel Aine', 54, '+256758465408', 'Shopkeeper', 'Primary', 'Sandra Mugabe', 57, '+256774563621', 'Housewife', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(62, 62, 'Timothy Opio', 52, '+256705744349', 'Doctor', 'Bachelor’s Degree', 'Mercy Tumusiime', 57, '+256774586905', 'Housewife', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(63, 63, 'Solomon Opio', 58, '+256787405187', 'Driver', 'Secondary', 'Rebecca Namukasa', 49, '+256757471492', 'Housewife', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(64, 64, 'Moses Akello', 50, '+256788476010', 'Teacher', 'Master’s Degree', 'Joy Lwanga', 32, '+256789730470', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(65, 65, 'Brian Musoke', 46, '+256775827133', 'Driver', 'Secondary', 'Sandra Kato', 55, '+256759215683', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(66, 66, 'Mark Aine', 57, '+256759630687', 'Shopkeeper', 'Primary', 'Grace Waiswa', 61, '+256787353100', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(67, 67, 'Solomon Byaruhanga', 57, '+256783340912', 'Civil Servant', 'Secondary', 'Sandra Nalubega', 28, '+256787168505', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(68, 68, 'Joseph Ssemwogerere', 56, '+256756906060', 'Engineer', 'Bachelor’s Degree', 'Ritah Nakato', 60, '+256709500086', 'Trader', 'Diploma', 'Rose Ssemwogerere', 'Uncle', 70, '+256782336690', 'Civil Servant', 'Secondary', 'Jinja', 'Active in debate club'),
(69, 69, 'Paul Lwanga', 46, '+256772120865', 'Civil Servant', 'Secondary', 'Esther Byaruhanga', 63, '+256759244330', 'Nurse', 'Diploma', 'Florence Lwanga', 'Other', 33, '+256701145537', 'Doctor', 'Master’s Degree', 'Jinja', 'Science fair participant'),
(70, 70, 'Ivan Ssemwogerere', 65, '+256708674090', 'Carpenter', 'Diploma', 'Mary Opio', 51, '+256778352085', 'Civil Servant', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(71, 71, 'Mark Lwanga', 50, '+256703856538', 'Shopkeeper', 'Diploma', 'Alice Nantogo', 36, '+256705725431', 'Trader', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(72, 72, 'Ivan Nalubega', 47, '+256703714614', 'Doctor', 'Primary', 'Rebecca Nalubega', 52, '+256781468387', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(73, 73, 'Solomon Opio', 59, '+256703934059', 'Civil Servant', 'Secondary', 'Alice Waiswa', 36, '+256787895931', 'Housewife', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(74, 74, 'Samuel Okello', 47, '+256775655238', 'Shopkeeper', 'Master’s Degree', 'Pritah Waiswa', 46, '+256755298484', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(75, 75, 'Peter Mugabe', 57, '+256771356182', 'Doctor', 'Diploma', 'Alice Ochieng', 50, '+256783669424', 'Farmer', 'Primary', 'Patrick Mugabe', 'Other', 75, '+256772680152', 'Mechanic', 'Master’s Degree', 'Gulu', 'Choir member'),
(76, 76, 'Daniel Namukasa', 56, '+256783027364', 'Civil Servant', 'Diploma', 'Grace Nantogo', 42, '+256701949089', 'Civil Servant', 'Secondary', 'Susan Namukasa', 'Other', 53, '+256758044371', 'Shopkeeper', 'Bachelor’s Degree', 'Masaka', 'Choir member'),
(77, 77, 'Peter Mugabe', 40, '+256784321828', 'Doctor', 'Secondary', 'Sarah Nalubega', 28, '+256789125418', 'Teacher', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(78, 78, 'Mark Ssemwogerere', 56, '+256788817850', 'Civil Servant', 'Bachelor’s Degree', 'Pritah Lwanga', 29, '+256752085096', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(79, 79, 'Isaac Waiswa', 37, '+256754755591', 'Civil Servant', 'Master’s Degree', 'Mary Aine', 48, '+256705449605', 'Teacher', 'Primary', 'Rose Waiswa', 'Other', 38, '+256751018036', 'Shopkeeper', 'Diploma', 'Soroti', 'Science fair participant'),
(80, 80, 'Peter Opio', 46, '+256756309357', 'Doctor', 'Secondary', 'Esther Mukasa', 37, '+256777886033', 'Nurse', 'Diploma', 'James Opio', 'Other', 46, '+256783619145', 'Engineer', 'Master’s Degree', 'Soroti', 'Active in debate club'),
(81, 81, 'Mark Byaruhanga', 31, '+256778640593', 'Civil Servant', 'Secondary', 'Grace Tumusiime', 28, '+256757524686', 'Housewife', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(82, 82, 'Moses Musoke', 59, '+256702307287', 'Doctor', 'Primary', 'Ritah Lwanga', 61, '+256778525292', 'Entrepreneur', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(83, 83, 'Andrew Namukasa', 47, '+256753098376', 'Driver', 'Primary', 'Alice Akello', 40, '+256774306750', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(84, 84, 'Mark Ssemwogerere', 37, '+256783649313', 'Teacher', 'Bachelor’s Degree', 'Sandra Nalubega', 49, '+256702916612', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(85, 85, 'Peter Kato', 64, '+256783358923', 'Driver', 'Master’s Degree', 'Pritah Nantogo', 52, '+256774086455', 'Teacher', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(86, 86, 'Brian Ssemwogerere', 47, '+256784676673', 'Mechanic', 'Diploma', 'Winnie Okello', 43, '+256751903201', 'Housewife', 'Bachelor’s Degree', 'Susan Ssemwogerere', 'Grandparent', 57, '+256778050143', 'Shopkeeper', 'Secondary', 'Soroti', 'Prefect'),
(87, 87, 'Moses Busingye', 67, '+256708804983', 'Teacher', 'Secondary', 'Doreen Nantogo', 53, '+256753625849', 'Trader', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(88, 88, 'Solomon Ochieng', 34, '+256788333730', 'Farmer', 'Diploma', 'Winnie Kyomuhendo', 58, '+256783588530', 'Teacher', 'Master’s Degree', 'Lillian Ochieng', 'Father', 47, '+256772977257', 'Mechanic', 'Bachelor’s Degree', 'Soroti', 'Football team'),
(89, 89, 'David Tumusiime', 39, '+256754428022', 'Teacher', 'Bachelor’s Degree', 'Esther Opio', 33, '+256777348906', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(90, 90, 'Moses Waiswa', 37, '+256701262954', 'Carpenter', 'Diploma', 'Esther Okello', 38, '+256709336447', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(91, 91, 'Moses Lwanga', 52, '+256784464758', 'Shopkeeper', 'Bachelor’s Degree', 'Grace Byaruhanga', 55, '+256778342377', 'Farmer', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(92, 92, 'Andrew Ssemwogerere', 44, '+256759077005', 'Farmer', 'Bachelor’s Degree', 'Brenda Nalubega', 57, '+256701318151', 'Housewife', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(93, 93, 'Brian Mugabe', 61, '+256778652496', 'Engineer', 'Bachelor’s Degree', 'Mary Mugabe', 51, '+256702648160', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(94, 94, 'Andrew Lwanga', 51, '+256774918434', 'Engineer', 'Diploma', 'Mary Byaruhanga', 63, '+256703073506', 'Farmer', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(95, 95, 'Daniel Byaruhanga', 63, '+256709939303', 'Farmer', 'Diploma', 'Brenda Byaruhanga', 52, '+256774178643', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(96, 96, 'David Tumusiime', 44, '+256758584366', 'Doctor', 'Primary', 'Winnie Ochieng', 61, '+256706600669', 'Trader', 'Diploma', 'Hellen Tumusiime', 'Mother', 51, '+256708305612', 'Carpenter', 'Master’s Degree', 'Mbale', 'Active in debate club'),
(97, 97, 'Paul Waiswa', 61, '+256785975530', 'Engineer', 'Secondary', 'Joan Namukasa', 40, '+256781344031', 'Trader', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(98, 98, 'Andrew Musoke', 33, '+256789722415', 'Driver', 'Secondary', 'Doreen Waiswa', 60, '+256775640488', 'Entrepreneur', 'Bachelor’s Degree', 'Alice Musoke', 'Aunt', 64, '+256772625177', 'Civil Servant', 'Primary', 'Mbarara', 'Football team'),
(99, 99, 'Solomon Nakato', 44, '+256773835702', 'Carpenter', 'Primary', 'Pritah Byaruhanga', 35, '+256756804285', 'Farmer', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(100, 100, 'Ivan Busingye', 49, '+256707911187', 'Farmer', 'Diploma', 'Mercy Ssemwogerere', 31, '+256771637257', 'Farmer', 'Master’s Degree', 'Patrick Busingye', 'Aunt', 50, '+256709567335', 'Engineer', 'Secondary', 'Jinja', 'Prefect'),
(101, 101, 'Daniel Mukasa', 49, '+256758539240', 'Mechanic', 'Primary', 'Sarah Kato', 42, '+256755507637', 'Tailor', 'Primary', 'James Mukasa', 'Father', 64, '+256706746722', 'Doctor', 'Primary', 'Arua', 'Prefect'),
(102, 102, 'John Mukasa', 35, '+256775533762', 'Farmer', 'Bachelor’s Degree', 'Mercy Okello', 29, '+256753119276', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(103, 103, 'Ivan Nakato', 67, '+256751915283', 'Engineer', 'Secondary', 'Winnie Tumusiime', 34, '+256777478749', 'Housewife', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(104, 104, 'Timothy Busingye', 33, '+256751139190', 'Engineer', 'Diploma', 'Brenda Nantogo', 61, '+256773690548', 'Civil Servant', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(105, 105, 'Moses Tumusiime', 66, '+256784308211', 'Driver', 'Bachelor’s Degree', 'Doreen Aine', 36, '+256772731535', 'Trader', 'Primary', 'Susan Tumusiime', 'Uncle', 59, '+256754519862', 'Teacher', 'Secondary', 'Mbale', 'Active in debate club'),
(106, 106, 'Timothy Waiswa', 63, '+256753467093', 'Engineer', 'Secondary', 'Pritah Aine', 55, '+256757137422', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(107, 107, 'Mark Opio', 64, '+256708666801', 'Civil Servant', 'Master’s Degree', 'Alice Mugabe', 64, '+256787789118', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(108, 108, 'Solomon Busingye', 66, '+256777132430', 'Driver', 'Bachelor’s Degree', 'Doreen Aine', 45, '+256703249755', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(109, 109, 'Daniel Musoke', 50, '+256702248415', 'Farmer', 'Secondary', 'Mercy Opio', 43, '+256779898648', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(110, 110, 'Brian Kato', 32, '+256754668619', 'Farmer', 'Diploma', 'Rebecca Aine', 64, '+256787917362', 'Trader', 'Master’s Degree', 'Charles Kato', 'Other', 41, '+256771350040', 'Carpenter', 'Diploma', 'Mbale', 'Football team'),
(111, 111, 'Moses Opio', 64, '+256755735039', 'Carpenter', 'Secondary', 'Sarah Ssemwogerere', 30, '+256706789998', 'Tailor', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(112, 112, 'Joseph Ochieng', 52, '+256783098409', 'Teacher', 'Master’s Degree', 'Doreen Namukasa', 61, '+256782491824', 'Nurse', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(113, 113, 'Isaac Aine', 42, '+256759878872', 'Driver', 'Master’s Degree', 'Joan Nakato', 32, '+256785565625', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(114, 114, 'Joseph Aine', 52, '+256785258077', 'Engineer', 'Diploma', 'Rebecca Busingye', 34, '+256702845860', 'Teacher', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(115, 115, 'Moses Ssemwogerere', 58, '+256775165771', 'Farmer', 'Bachelor’s Degree', 'Esther Kyomuhendo', 39, '+256782596118', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(116, 116, 'Mark Opio', 52, '+256788560564', 'Doctor', 'Master’s Degree', 'Joan Nalubega', 63, '+256782059113', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(117, 117, 'Ivan Okello', 49, '+256707900691', 'Teacher', 'Primary', 'Mary Waiswa', 49, '+256776983236', 'Entrepreneur', 'Master’s Degree', 'Charles Okello', 'Aunt', 79, '+256786487089', 'Doctor', 'Secondary', 'Kampala', 'Active in debate club'),
(118, 118, 'Ivan Nakato', 63, '+256753649961', 'Doctor', 'Master’s Degree', 'Doreen Nakato', 33, '+256784764674', 'Trader', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(119, 119, 'Brian Ochieng', 51, '+256755626175', 'Farmer', 'Secondary', 'Sarah Nalubega', 39, '+256789742846', 'Civil Servant', 'Diploma', 'Robert Ochieng', 'Aunt', 29, '+256757001347', 'Driver', 'Diploma', 'Mbale', 'Football team'),
(120, 120, 'Daniel Opio', 53, '+256776072389', 'Farmer', 'Secondary', 'Sarah Lwanga', 62, '+256775581815', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(121, 121, 'Timothy Ssemwogerere', 33, '+256701874764', 'Farmer', 'Diploma', 'Winnie Kyomuhendo', 28, '+256788159477', 'Civil Servant', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(122, 122, 'John Ssemwogerere', 42, '+256782631914', 'Teacher', 'Primary', 'Sandra Musoke', 47, '+256786836997', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(123, 123, 'Joseph Akello', 59, '+256754358792', 'Shopkeeper', 'Bachelor’s Degree', 'Sarah Okello', 29, '+256706904229', 'Farmer', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(124, 124, 'Andrew Ochieng', 68, '+256707886101', 'Driver', 'Bachelor’s Degree', 'Pritah Namukasa', 34, '+256779082848', 'Farmer', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(125, 125, 'David Namukasa', 44, '+256789868477', 'Mechanic', 'Secondary', 'Grace Opio', 43, '+256789551073', 'Farmer', 'Master’s Degree', 'Alice Namukasa', 'Uncle', 48, '+256709721435', 'Civil Servant', 'Secondary', 'Soroti', 'Prefect'),
(126, 126, 'Daniel Byaruhanga', 56, '+256789192759', 'Shopkeeper', 'Master’s Degree', 'Sandra Mukasa', 52, '+256788374125', 'Entrepreneur', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(127, 127, 'Solomon Mukasa', 38, '+256782376493', 'Shopkeeper', 'Diploma', 'Doreen Kato', 33, '+256771432253', 'Trader', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(128, 128, 'Ivan Opio', 37, '+256752507565', 'Engineer', 'Diploma', 'Brenda Mugabe', 38, '+256786499097', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(129, 129, 'Joseph Ssemwogerere', 52, '+256774445670', 'Civil Servant', 'Master’s Degree', 'Grace Namukasa', 56, '+256757950005', 'Trader', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(130, 130, 'Mark Namukasa', 44, '+256703477345', 'Mechanic', 'Bachelor’s Degree', 'Alice Tumusiime', 56, '+256705708406', 'Teacher', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(131, 131, 'Brian Opio', 52, '+256702472385', 'Doctor', 'Master’s Degree', 'Pritah Mukasa', 35, '+256704874664', 'Civil Servant', 'Master’s Degree', 'Lillian Opio', 'Father', 38, '+256705613519', 'Civil Servant', 'Master’s Degree', 'Kampala', 'Prefect'),
(132, 132, 'Ivan Aine', 65, '+256778224867', 'Teacher', 'Secondary', 'Rebecca Nakato', 63, '+256753088850', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(133, 133, 'Timothy Okello', 42, '+256756409320', 'Carpenter', 'Primary', 'Sarah Akello', 55, '+256751474428', 'Trader', 'Diploma', 'Susan Okello', 'Mother', 38, '+256709105887', 'Shopkeeper', 'Diploma', 'Kampala', 'Choir member'),
(134, 134, 'Daniel Byaruhanga', 48, '+256782757958', 'Civil Servant', 'Secondary', 'Winnie Okello', 46, '+256752045746', 'Farmer', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(135, 135, 'Andrew Nalubega', 48, '+256781688813', 'Teacher', 'Primary', 'Winnie Nakato', 34, '+256778809312', 'Farmer', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(136, 136, 'Joseph Musoke', 43, '+256777877357', 'Engineer', 'Master’s Degree', 'Joan Lwanga', 60, '+256773438905', 'Trader', 'Diploma', 'Lillian Musoke', 'Other', 66, '+256782533730', 'Farmer', 'Bachelor’s Degree', 'Soroti', 'Active in debate club'),
(137, 137, 'Timothy Busingye', 47, '+256785948691', 'Shopkeeper', 'Diploma', 'Sarah Aine', 41, '+256775848167', 'Teacher', 'Secondary', 'Florence Busingye', 'Father', 45, '+256703437043', 'Civil Servant', 'Bachelor’s Degree', 'Fort Portal', 'Active in debate club'),
(138, 138, 'Solomon Nantogo', 66, '+256781667468', 'Engineer', 'Primary', 'Joan Byaruhanga', 52, '+256707413874', 'Farmer', 'Bachelor’s Degree', 'James Nantogo', 'Uncle', 58, '+256778123258', 'Carpenter', 'Secondary', 'Gulu', 'Prefect'),
(139, 139, 'David Namukasa', 48, '+256785214330', 'Mechanic', 'Secondary', 'Ritah Mukasa', 49, '+256756895702', 'Entrepreneur', 'Bachelor’s Degree', 'Florence Namukasa', 'Grandparent', 59, '+256788446090', 'Civil Servant', 'Diploma', 'Arua', 'Football team'),
(140, 140, 'Solomon Okello', 66, '+256779944647', 'Shopkeeper', 'Secondary', 'Ritah Byaruhanga', 28, '+256774908713', 'Housewife', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(141, 141, 'Samuel Tumusiime', 43, '+256782209372', 'Doctor', 'Diploma', 'Esther Opio', 41, '+256786450927', 'Entrepreneur', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(142, 142, 'Peter Nalubega', 43, '+256708831307', 'Farmer', 'Diploma', 'Sandra Busingye', 60, '+256779184765', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(143, 143, 'Mark Lwanga', 39, '+256772199068', 'Carpenter', 'Secondary', 'Esther Nakato', 31, '+256776749075', 'Trader', 'Diploma', 'Rose Lwanga', 'Other', 54, '+256787158002', 'Mechanic', 'Primary', 'Kampala', 'Choir member'),
(144, 144, 'Peter Nalubega', 67, '+256757229076', 'Shopkeeper', 'Diploma', 'Sarah Akello', 46, '+256752324504', 'Entrepreneur', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(145, 145, 'Solomon Mugabe', 31, '+256777329702', 'Farmer', 'Diploma', 'Joy Ochieng', 47, '+256786308837', 'Housewife', 'Diploma', 'Hellen Mugabe', 'Father', 69, '+256783773128', 'Shopkeeper', 'Diploma', 'Gulu', 'Football team'),
(146, 146, 'Isaac Ochieng', 39, '+256759757411', 'Doctor', 'Bachelor’s Degree', 'Esther Waiswa', 62, '+256709830904', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(147, 147, 'Moses Nalubega', 49, '+256705932283', 'Carpenter', 'Diploma', 'Grace Akello', 41, '+256707678800', 'Trader', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(148, 148, 'Daniel Kyomuhendo', 58, '+256755960568', 'Mechanic', 'Secondary', 'Winnie Byaruhanga', 41, '+256789328197', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(149, 149, 'Daniel Busingye', 57, '+256773555993', 'Shopkeeper', 'Bachelor’s Degree', 'Joy Aine', 31, '+256789008801', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(150, 150, 'Mark Kyomuhendo', 57, '+256751425177', 'Doctor', 'Diploma', 'Brenda Aine', 33, '+256789146581', 'Entrepreneur', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(151, 151, 'Joseph Aine', 32, '+256784171248', 'Doctor', 'Primary', 'Joan Akello', 55, '+256706347442', 'Entrepreneur', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(152, 152, 'John Ssemwogerere', 37, '+256704691602', 'Civil Servant', 'Primary', 'Mary Kato', 57, '+256772738024', 'Tailor', 'Bachelor’s Degree', 'Robert Ssemwogerere', 'Grandparent', 33, '+256759241796', 'Engineer', 'Bachelor’s Degree', 'Mbale', 'Science fair participant'),
(153, 153, 'Peter Namukasa', 53, '+256709555537', 'Teacher', 'Diploma', 'Mercy Nantogo', 62, '+256782621591', 'Nurse', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(154, 154, 'Brian Nakato', 66, '+256708159282', 'Doctor', 'Diploma', 'Pritah Kyomuhendo', 62, '+256783861833', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(155, 155, 'John Byaruhanga', 58, '+256703862204', 'Shopkeeper', 'Master’s Degree', 'Pritah Byaruhanga', 62, '+256785545919', 'Farmer', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(156, 156, 'Peter Aine', 55, '+256702710015', 'Shopkeeper', 'Secondary', 'Sandra Busingye', 60, '+256779927790', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(157, 157, 'Daniel Mukasa', 39, '+256781249131', 'Farmer', 'Master’s Degree', 'Winnie Akello', 62, '+256778488430', 'Nurse', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(158, 158, 'Andrew Waiswa', 46, '+256753075633', 'Engineer', 'Bachelor’s Degree', 'Sandra Mugabe', 52, '+256778551842', 'Housewife', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(159, 159, 'Solomon Kyomuhendo', 60, '+256783390109', 'Teacher', 'Master’s Degree', 'Joan Mugabe', 58, '+256703130303', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(160, 160, 'Solomon Akello', 38, '+256786408219', 'Farmer', 'Diploma', 'Sandra Namukasa', 28, '+256752191555', 'Civil Servant', 'Secondary', 'Robert Akello', 'Grandparent', 71, '+256778643892', 'Farmer', 'Secondary', 'Arua', 'Active in debate club'),
(161, 161, 'Paul Tumusiime', 35, '+256784598237', 'Driver', 'Primary', 'Winnie Aine', 53, '+256709847116', 'Trader', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(162, 162, 'Mark Byaruhanga', 37, '+256751516506', 'Civil Servant', 'Primary', 'Pritah Musoke', 52, '+256709440079', 'Trader', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(163, 163, 'Brian Namukasa', 56, '+256755795023', 'Shopkeeper', 'Secondary', 'Rebecca Waiswa', 42, '+256775449905', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(164, 164, 'Solomon Ochieng', 44, '+256778897636', 'Farmer', 'Bachelor’s Degree', 'Joy Mukasa', 31, '+256755968017', 'Housewife', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(165, 165, 'Isaac Busingye', 51, '+256779925776', 'Civil Servant', 'Master’s Degree', 'Winnie Lwanga', 49, '+256755321570', 'Trader', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(166, 166, 'Solomon Waiswa', 57, '+256702835931', 'Carpenter', 'Secondary', 'Mercy Nalubega', 44, '+256776267058', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(167, 167, 'Paul Akello', 63, '+256785946533', 'Driver', 'Secondary', 'Ritah Kato', 57, '+256755194417', 'Trader', 'Secondary', 'Charles Akello', 'Father', 30, '+256784522868', 'Doctor', 'Secondary', 'Kampala', 'Football team'),
(168, 168, 'Ivan Nalubega', 48, '+256759047286', 'Shopkeeper', 'Diploma', 'Rebecca Mugabe', 36, '+256701926281', 'Housewife', 'Diploma', 'Hellen Nalubega', 'Father', 53, '+256787695824', 'Teacher', 'Master’s Degree', 'Lira', 'Football team'),
(169, 169, 'Solomon Ochieng', 31, '+256784173706', 'Teacher', 'Diploma', 'Alice Ssemwogerere', 40, '+256752561448', 'Farmer', 'Master’s Degree', 'Susan Ochieng', 'Uncle', 56, '+256701479387', 'Carpenter', 'Secondary', 'Arua', 'Prefect'),
(170, 170, 'Isaac Aine', 65, '+256785381237', 'Mechanic', 'Secondary', 'Grace Kato', 43, '+256789776550', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(171, 171, 'Timothy Mugabe', 34, '+256785315208', 'Teacher', 'Primary', 'Joan Waiswa', 47, '+256788500670', 'Farmer', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(172, 172, 'Daniel Nalubega', 42, '+256784438132', 'Engineer', 'Primary', 'Mary Tumusiime', 36, '+256789081441', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(173, 173, 'Solomon Byaruhanga', 41, '+256758151117', 'Teacher', 'Diploma', 'Joy Nakato', 54, '+256702230091', 'Farmer', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(174, 174, 'Andrew Byaruhanga', 45, '+256706816696', 'Teacher', 'Primary', 'Brenda Ochieng', 34, '+256751503713', 'Housewife', 'Secondary', 'Susan Byaruhanga', 'Grandparent', 49, '+256777782012', 'Teacher', 'Bachelor’s Degree', 'Gulu', 'Prefect'),
(175, 175, 'Isaac Opio', 62, '+256704834475', 'Carpenter', 'Diploma', 'Ritah Waiswa', 30, '+256787744676', 'Farmer', 'Diploma', 'Rose Opio', 'Aunt', 45, '+256788408986', 'Farmer', 'Bachelor’s Degree', 'Lira', 'Prefect'),
(176, 176, 'David Kato', 44, '+256789883195', 'Carpenter', 'Primary', 'Pritah Okello', 53, '+256757382258', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(177, 177, 'David Busingye', 53, '+256776608424', 'Teacher', 'Diploma', 'Sarah Okello', 49, '+256705934914', 'Farmer', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(178, 178, 'Paul Aine', 32, '+256755946294', 'Civil Servant', 'Secondary', 'Grace Kato', 55, '+256754291223', 'Civil Servant', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(179, 179, 'Solomon Okello', 44, '+256702209275', 'Engineer', 'Bachelor’s Degree', 'Rebecca Nantogo', 39, '+256707791816', 'Farmer', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(180, 180, 'Andrew Namukasa', 40, '+256754958997', 'Teacher', 'Diploma', 'Brenda Namukasa', 37, '+256705587553', 'Civil Servant', 'Master’s Degree', 'James Namukasa', 'Other', 47, '+256781850954', 'Doctor', 'Master’s Degree', 'Jinja', 'Active in debate club'),
(181, 181, 'John Busingye', 64, '+256776960871', 'Doctor', 'Master’s Degree', 'Mary Mukasa', 36, '+256705020452', 'Housewife', 'Diploma', 'Hellen Busingye', 'Mother', 31, '+256782036632', 'Civil Servant', 'Primary', 'Jinja', 'Football team'),
(182, 182, 'Brian Tumusiime', 35, '+256706402396', 'Carpenter', 'Master’s Degree', 'Grace Tumusiime', 34, '+256706550800', 'Nurse', 'Master’s Degree', 'Rose Tumusiime', 'Father', 53, '+256787577711', 'Farmer', 'Secondary', 'Masaka', 'Active in debate club'),
(183, 183, 'Solomon Kato', 69, '+256788042236', 'Shopkeeper', 'Primary', 'Joy Okello', 62, '+256786273805', 'Entrepreneur', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(184, 184, 'Timothy Nakato', 61, '+256755453282', 'Driver', 'Primary', 'Brenda Kyomuhendo', 29, '+256775361170', 'Housewife', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(185, 185, 'Brian Opio', 40, '+256782274506', 'Carpenter', 'Diploma', 'Grace Okello', 53, '+256772810184', 'Housewife', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(186, 186, 'Mark Busingye', 44, '+256783154183', 'Teacher', 'Secondary', 'Mercy Byaruhanga', 61, '+256758217154', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(187, 187, 'Joseph Musoke', 50, '+256704582162', 'Engineer', 'Secondary', 'Esther Tumusiime', 55, '+256781234195', 'Civil Servant', 'Primary', 'Susan Musoke', 'Grandparent', 40, '+256781536093', 'Engineer', 'Master’s Degree', 'Mbarara', 'Prefect'),
(188, 188, 'Solomon Byaruhanga', 68, '+256703444281', 'Mechanic', 'Primary', 'Grace Waiswa', 51, '+256786817270', 'Teacher', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(189, 189, 'David Nakato', 69, '+256704718106', 'Civil Servant', 'Bachelor’s Degree', 'Winnie Waiswa', 41, '+256707751629', 'Trader', 'Diploma', 'Alice Nakato', 'Other', 62, '+256752772398', 'Carpenter', 'Primary', 'Kampala', 'Science fair participant'),
(190, 190, 'Andrew Tumusiime', 57, '+256782787256', 'Carpenter', 'Master’s Degree', 'Ritah Nakato', 46, '+256751034859', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(191, 191, 'Isaac Nantogo', 34, '+256771985156', 'Farmer', 'Diploma', 'Esther Tumusiime', 30, '+256785972880', 'Civil Servant', 'Master’s Degree', 'Susan Nantogo', 'Grandparent', 57, '+256777986347', 'Shopkeeper', 'Secondary', 'Lira', 'Football team'),
(192, 192, 'Brian Nantogo', 69, '+256759414746', 'Farmer', 'Master’s Degree', 'Ritah Ochieng', 29, '+256753953017', 'Farmer', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(193, 193, 'Timothy Nakato', 40, '+256782833806', 'Civil Servant', 'Bachelor’s Degree', 'Alice Opio', 41, '+256782497596', 'Teacher', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(194, 194, 'Mark Ssemwogerere', 61, '+256702401166', 'Driver', 'Primary', 'Doreen Ochieng', 46, '+256708722253', 'Entrepreneur', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(195, 195, 'Brian Lwanga', 67, '+256756587658', 'Carpenter', 'Secondary', 'Pritah Nalubega', 30, '+256702792860', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(196, 196, 'Samuel Okello', 53, '+256707059404', 'Carpenter', 'Diploma', 'Esther Tumusiime', 59, '+256758267289', 'Housewife', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(197, 197, 'Ivan Lwanga', 43, '+256772368133', 'Doctor', 'Secondary', 'Joan Ochieng', 63, '+256786305587', 'Nurse', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(198, 198, 'Joseph Busingye', 69, '+256756843744', 'Teacher', 'Secondary', 'Mary Nantogo', 36, '+256782046946', 'Housewife', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(199, 199, 'John Lwanga', 36, '+256782308627', 'Engineer', 'Secondary', 'Rebecca Opio', 51, '+256787070444', 'Nurse', 'Bachelor’s Degree', 'Hellen Lwanga', 'Aunt', 67, '+256751538353', 'Teacher', 'Primary', 'Masaka', 'Science fair participant'),
(200, 200, 'Brian Akello', 48, '+256784603732', 'Teacher', 'Primary', 'Sandra Waiswa', 31, '+256774871460', 'Farmer', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(201, 201, 'Isaac Kyomuhendo', 69, '+256771956055', 'Shopkeeper', 'Secondary', 'Sandra Busingye', 57, '+256779787656', 'Nurse', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(202, 202, 'Daniel Tumusiime', 48, '+256771087347', 'Doctor', 'Master’s Degree', 'Mary Musoke', 44, '+256704963528', 'Entrepreneur', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(203, 203, 'Peter Ochieng', 50, '+256751550127', 'Doctor', 'Primary', 'Ritah Opio', 47, '+256709285403', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(204, 204, 'Peter Byaruhanga', 31, '+256775015044', 'Carpenter', 'Primary', 'Sarah Kato', 53, '+256785374381', 'Entrepreneur', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(205, 205, 'Joseph Ochieng', 43, '+256778840788', 'Teacher', 'Primary', 'Mercy Aine', 39, '+256751374756', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(206, 206, 'Peter Akello', 68, '+256785738848', 'Farmer', 'Primary', 'Rebecca Busingye', 41, '+256705313830', 'Tailor', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(207, 207, 'Daniel Byaruhanga', 47, '+256705115406', 'Civil Servant', 'Diploma', 'Joy Opio', 36, '+256701664377', 'Entrepreneur', 'Master’s Degree', 'Hellen Byaruhanga', 'Grandparent', 55, '+256706448061', 'Carpenter', 'Secondary', 'Kampala', 'Football team'),
(208, 208, 'Moses Busingye', 33, '+256754261993', 'Engineer', 'Diploma', 'Rebecca Namukasa', 58, '+256783153705', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(209, 209, 'Andrew Kato', 55, '+256705313985', 'Civil Servant', 'Bachelor’s Degree', 'Ritah Opio', 32, '+256701516616', 'Tailor', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(210, 210, 'Mark Tumusiime', 56, '+256704194601', 'Doctor', 'Secondary', 'Sandra Ssemwogerere', 55, '+256704100050', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(211, 211, 'Paul Waiswa', 66, '+256782045585', 'Farmer', 'Primary', 'Alice Mukasa', 61, '+256754683226', 'Teacher', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(212, 212, 'Joseph Busingye', 48, '+256753775902', 'Engineer', 'Diploma', 'Joan Aine', 57, '+256774775153', 'Housewife', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(213, 213, 'Joseph Akello', 41, '+256756171453', 'Civil Servant', 'Master’s Degree', 'Sandra Busingye', 32, '+256788351189', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(214, 214, 'Timothy Lwanga', 33, '+256753142618', 'Carpenter', 'Diploma', 'Mercy Ochieng', 52, '+256706134583', 'Trader', 'Primary', 'Patrick Lwanga', 'Grandparent', 50, '+256751913838', 'Teacher', 'Master’s Degree', 'Jinja', 'Active in debate club'),
(215, 215, 'Samuel Busingye', 38, '+256759628069', 'Farmer', 'Secondary', 'Alice Mugabe', 56, '+256776620080', 'Entrepreneur', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(216, 216, 'Mark Aine', 40, '+256705361216', 'Carpenter', 'Secondary', 'Pritah Nantogo', 55, '+256784999628', 'Tailor', 'Bachelor’s Degree', 'Rose Aine', 'Uncle', 30, '+256756908066', 'Doctor', 'Master’s Degree', 'Mbale', 'Football team'),
(217, 217, 'John Byaruhanga', 45, '+256753551607', 'Teacher', 'Secondary', 'Sandra Ochieng', 52, '+256781710150', 'Nurse', 'Secondary', 'Rose Byaruhanga', 'Mother', 33, '+256775306478', 'Carpenter', 'Bachelor’s Degree', 'Gulu', 'Active in debate club'),
(218, 218, 'Andrew Ochieng', 66, '+256771757794', 'Doctor', 'Diploma', 'Sarah Busingye', 44, '+256709527680', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(219, 219, 'Solomon Mukasa', 62, '+256787669077', 'Carpenter', 'Bachelor’s Degree', 'Sarah Kyomuhendo', 34, '+256751166185', 'Housewife', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(220, 220, 'Solomon Aine', 38, '+256751261430', 'Mechanic', 'Secondary', 'Joy Nalubega', 50, '+256709949596', 'Nurse', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(221, 221, 'Paul Tumusiime', 56, '+256779538649', 'Engineer', 'Primary', 'Pritah Akello', 49, '+256775715530', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(222, 222, 'Timothy Byaruhanga', 56, '+256754287167', 'Doctor', 'Secondary', 'Rebecca Waiswa', 45, '+256772835593', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(223, 223, 'Peter Mugabe', 49, '+256788780807', 'Carpenter', 'Master’s Degree', 'Mercy Ssemwogerere', 40, '+256787764415', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(224, 224, 'Isaac Ochieng', 39, '+256788015173', 'Carpenter', 'Diploma', 'Grace Namukasa', 34, '+256756765361', 'Nurse', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(225, 225, 'Timothy Akello', 38, '+256753527406', 'Doctor', 'Bachelor’s Degree', 'Rebecca Busingye', 34, '+256779686578', 'Entrepreneur', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(226, 226, 'Paul Byaruhanga', 30, '+256751019084', 'Teacher', 'Diploma', 'Rebecca Nantogo', 38, '+256757030195', 'Teacher', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(227, 227, 'Moses Aine', 69, '+256707770008', 'Shopkeeper', 'Secondary', 'Esther Mukasa', 49, '+256705811218', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(228, 228, 'Timothy Ochieng', 30, '+256706754835', 'Farmer', 'Bachelor’s Degree', 'Sarah Musoke', 31, '+256777056060', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(229, 229, 'Daniel Busingye', 69, '+256783628299', 'Teacher', 'Primary', 'Mercy Aine', 37, '+256756056301', 'Civil Servant', 'Diploma', 'Hellen Busingye', 'Uncle', 61, '+256706235195', 'Mechanic', 'Diploma', 'Kampala', 'Choir member'),
(230, 230, 'Solomon Nakato', 65, '+256702160929', 'Teacher', 'Diploma', 'Sandra Kato', 41, '+256758399242', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(231, 231, 'Solomon Waiswa', 43, '+256755600962', 'Farmer', 'Master’s Degree', 'Winnie Okello', 58, '+256752705955', 'Tailor', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(232, 232, 'Ivan Musoke', 42, '+256786058442', 'Mechanic', 'Diploma', 'Mary Ochieng', 54, '+256704253554', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team');
INSERT INTO `parents` (`ParentId`, `StudentID`, `father_name`, `father_age`, `father_contact`, `father_occupation`, `father_education`, `mother_name`, `mother_age`, `mother_contact`, `mother_occupation`, `mother_education`, `guardian_name`, `guardian_relation`, `guardian_age`, `guardian_contact`, `guardian_occupation`, `guardian_education`, `guardian_address`, `MoreInformation`) VALUES
(233, 233, 'Solomon Busingye', 69, '+256708499921', 'Engineer', 'Primary', 'Joan Aine', 62, '+256779150033', 'Entrepreneur', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(234, 234, 'Timothy Kyomuhendo', 41, '+256701220282', 'Engineer', 'Primary', 'Joan Waiswa', 45, '+256775643774', 'Entrepreneur', 'Master’s Degree', 'Rose Kyomuhendo', 'Other', 40, '+256782537282', 'Driver', 'Bachelor’s Degree', 'Soroti', 'Active in debate club'),
(235, 235, 'David Kyomuhendo', 52, '+256786285347', 'Teacher', 'Bachelor’s Degree', 'Pritah Musoke', 31, '+256752652697', 'Housewife', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(236, 236, 'Moses Nakato', 48, '+256752969040', 'Shopkeeper', 'Bachelor’s Degree', 'Joan Kyomuhendo', 42, '+256709269269', 'Farmer', 'Master’s Degree', 'James Nakato', 'Mother', 62, '+256756146135', 'Shopkeeper', 'Master’s Degree', 'Masaka', 'Prefect'),
(237, 237, 'Paul Mukasa', 53, '+256753059245', 'Doctor', 'Diploma', 'Rebecca Nalubega', 38, '+256753514785', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(238, 238, 'Solomon Aine', 66, '+256703423045', 'Carpenter', 'Secondary', 'Mary Okello', 28, '+256753197318', 'Teacher', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(239, 239, 'Timothy Ssemwogerere', 43, '+256754418222', 'Driver', 'Bachelor’s Degree', 'Brenda Namukasa', 31, '+256754528598', 'Farmer', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(240, 240, 'Isaac Akello', 54, '+256781800749', 'Carpenter', 'Secondary', 'Pritah Musoke', 56, '+256706792288', 'Entrepreneur', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(241, 241, 'Andrew Busingye', 37, '+256752671437', 'Engineer', 'Diploma', 'Joan Opio', 57, '+256783371835', 'Farmer', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(242, 242, 'Isaac Ochieng', 57, '+256702458366', 'Mechanic', 'Diploma', 'Sandra Musoke', 55, '+256787292447', 'Trader', 'Bachelor’s Degree', 'James Ochieng', 'Grandparent', 45, '+256772862916', 'Driver', 'Secondary', 'Fort Portal', 'Science fair participant'),
(243, 243, 'Daniel Kato', 44, '+256755409595', 'Engineer', 'Bachelor’s Degree', 'Sarah Aine', 38, '+256771575133', 'Farmer', 'Primary', 'Rose Kato', 'Mother', 28, '+256774250293', 'Shopkeeper', 'Master’s Degree', 'Arua', 'Prefect'),
(244, 244, 'Isaac Mukasa', 41, '+256708507991', 'Mechanic', 'Master’s Degree', 'Doreen Aine', 37, '+256704769556', 'Entrepreneur', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(245, 245, 'Joseph Aine', 66, '+256781661548', 'Doctor', 'Bachelor’s Degree', 'Doreen Namukasa', 60, '+256773716597', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(246, 246, 'Brian Akello', 61, '+256787498670', 'Carpenter', 'Bachelor’s Degree', 'Doreen Opio', 60, '+256774719488', 'Farmer', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(247, 247, 'Moses Okello', 50, '+256788437690', 'Farmer', 'Primary', 'Brenda Nalubega', 46, '+256703550404', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(248, 248, 'Ivan Musoke', 64, '+256707507401', 'Farmer', 'Primary', 'Sarah Mukasa', 43, '+256774114067', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(249, 249, 'Paul Kyomuhendo', 67, '+256781990725', 'Engineer', 'Master’s Degree', 'Esther Musoke', 58, '+256771575887', 'Housewife', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(250, 250, 'Joseph Namukasa', 38, '+256755929818', 'Engineer', 'Secondary', 'Joy Nalubega', 41, '+256705323886', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(251, 251, 'Isaac Aine', 44, '+256788451748', 'Engineer', 'Bachelor’s Degree', 'Esther Ssemwogerere', 38, '+256789817027', 'Tailor', 'Secondary', 'Alice Aine', 'Grandparent', 61, '+256771987123', 'Mechanic', 'Bachelor’s Degree', 'Gulu', 'Choir member'),
(252, 252, 'Isaac Byaruhanga', 43, '+256782223371', 'Doctor', 'Secondary', 'Doreen Aine', 47, '+256771275953', 'Trader', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(253, 253, 'Ivan Busingye', 38, '+256783008899', 'Driver', 'Diploma', 'Joan Opio', 53, '+256783158708', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(254, 254, 'Paul Waiswa', 56, '+256785498597', 'Carpenter', 'Master’s Degree', 'Esther Tumusiime', 39, '+256789305583', 'Housewife', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(255, 255, 'Timothy Tumusiime', 44, '+256776088323', 'Farmer', 'Diploma', 'Ritah Tumusiime', 44, '+256773067094', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(256, 256, 'Moses Musoke', 50, '+256706024500', 'Mechanic', 'Master’s Degree', 'Winnie Kato', 60, '+256772070072', 'Nurse', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(257, 257, 'Ivan Nalubega', 57, '+256776987279', 'Engineer', 'Primary', 'Grace Ochieng', 62, '+256782160059', 'Farmer', 'Secondary', 'Charles Nalubega', 'Aunt', 29, '+256786245840', 'Civil Servant', 'Secondary', 'Masaka', 'Prefect'),
(258, 258, 'Paul Akello', 48, '+256707615944', 'Farmer', 'Diploma', 'Ritah Nantogo', 50, '+256773144259', 'Teacher', 'Master’s Degree', 'Alice Akello', 'Grandparent', 71, '+256777959641', 'Civil Servant', 'Master’s Degree', 'Arua', 'Football team'),
(259, 259, 'Isaac Nalubega', 46, '+256774690456', 'Carpenter', 'Primary', 'Alice Tumusiime', 37, '+256701943216', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(260, 260, 'Daniel Namukasa', 61, '+256771596445', 'Civil Servant', 'Diploma', 'Mary Opio', 52, '+256776273313', 'Trader', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(261, 261, 'Daniel Mukasa', 56, '+256781116015', 'Doctor', 'Secondary', 'Mary Mukasa', 63, '+256779332507', 'Entrepreneur', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(262, 262, 'Samuel Akello', 46, '+256706825910', 'Teacher', 'Primary', 'Ritah Kyomuhendo', 34, '+256773495548', 'Nurse', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(263, 263, 'Peter Waiswa', 39, '+256756991879', 'Farmer', 'Primary', 'Joy Ssemwogerere', 44, '+256779149310', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(264, 264, 'Samuel Namukasa', 56, '+256759847694', 'Engineer', 'Primary', 'Alice Okello', 44, '+256774423382', 'Nurse', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(265, 265, 'Isaac Mugabe', 58, '+256708562158', 'Mechanic', 'Master’s Degree', 'Esther Akello', 30, '+256787556368', 'Farmer', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(266, 266, 'Daniel Opio', 37, '+256759909970', 'Mechanic', 'Primary', 'Winnie Ochieng', 47, '+256703805672', 'Housewife', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(267, 267, 'Samuel Lwanga', 60, '+256778348807', 'Engineer', 'Bachelor’s Degree', 'Mercy Busingye', 35, '+256782511750', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(268, 268, 'Samuel Kyomuhendo', 69, '+256759253889', 'Farmer', 'Primary', 'Winnie Kyomuhendo', 28, '+256775349120', 'Trader', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(269, 269, 'Paul Nakato', 54, '+256777594836', 'Mechanic', 'Bachelor’s Degree', 'Doreen Ochieng', 35, '+256775994846', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(270, 270, 'Daniel Aine', 52, '+256784971153', 'Engineer', 'Diploma', 'Joy Ssemwogerere', 62, '+256778170577', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(271, 271, 'Ivan Kyomuhendo', 59, '+256776077381', 'Mechanic', 'Diploma', 'Brenda Tumusiime', 37, '+256779680233', 'Teacher', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(272, 272, 'Paul Mukasa', 57, '+256753183856', 'Civil Servant', 'Diploma', 'Sandra Kato', 32, '+256759982036', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(273, 273, 'Timothy Musoke', 64, '+256788842461', 'Civil Servant', 'Master’s Degree', 'Joy Ochieng', 44, '+256784046266', 'Farmer', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(274, 274, 'Solomon Opio', 69, '+256777131096', 'Carpenter', 'Secondary', 'Doreen Ssemwogerere', 45, '+256786025909', 'Civil Servant', 'Master’s Degree', 'Patrick Opio', 'Aunt', 60, '+256782784625', 'Doctor', 'Secondary', 'Kampala', 'Science fair participant'),
(275, 275, 'Daniel Aine', 37, '+256755893487', 'Engineer', 'Primary', 'Doreen Okello', 37, '+256752422415', 'Housewife', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(276, 276, 'Ivan Kyomuhendo', 63, '+256755658995', 'Shopkeeper', 'Diploma', 'Rebecca Kyomuhendo', 44, '+256756580507', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(277, 277, 'Samuel Lwanga', 66, '+256706949610', 'Shopkeeper', 'Primary', 'Mary Nakato', 47, '+256788280455', 'Farmer', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(278, 278, 'Peter Kato', 40, '+256759141187', 'Shopkeeper', 'Diploma', 'Esther Ochieng', 29, '+256709838586', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(279, 279, 'Paul Lwanga', 64, '+256777326355', 'Doctor', 'Bachelor’s Degree', 'Mercy Mukasa', 46, '+256754801074', 'Teacher', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(280, 280, 'Moses Lwanga', 46, '+256772341965', 'Shopkeeper', 'Master’s Degree', 'Doreen Aine', 36, '+256704747449', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(281, 281, 'Mark Namukasa', 49, '+256705979294', 'Civil Servant', 'Secondary', 'Brenda Ssemwogerere', 34, '+256709986675', 'Entrepreneur', 'Master’s Degree', 'Susan Namukasa', 'Uncle', 38, '+256776495513', 'Teacher', 'Secondary', 'Fort Portal', 'Choir member'),
(282, 282, 'Timothy Mukasa', 52, '+256774531283', 'Shopkeeper', 'Diploma', 'Rebecca Okello', 37, '+256709412808', 'Tailor', 'Diploma', 'Florence Mukasa', 'Mother', 33, '+256704860460', 'Mechanic', 'Primary', 'Arua', 'Science fair participant'),
(283, 283, 'Paul Namukasa', 31, '+256758122759', 'Carpenter', 'Primary', 'Pritah Waiswa', 59, '+256708800684', 'Civil Servant', 'Master’s Degree', 'Alice Namukasa', 'Grandparent', 66, '+256756250348', 'Civil Servant', 'Primary', 'Mbale', 'Choir member'),
(284, 284, 'Paul Ochieng', 37, '+256754095225', 'Carpenter', 'Master’s Degree', 'Ritah Kyomuhendo', 28, '+256777361142', 'Entrepreneur', 'Master’s Degree', 'Patrick Ochieng', 'Mother', 48, '+256758761650', 'Driver', 'Secondary', 'Arua', 'Choir member'),
(285, 285, 'Paul Byaruhanga', 48, '+256702615032', 'Carpenter', 'Bachelor’s Degree', 'Doreen Lwanga', 60, '+256758076164', 'Nurse', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(286, 286, 'Mark Waiswa', 66, '+256709553665', 'Civil Servant', 'Bachelor’s Degree', 'Ritah Lwanga', 30, '+256776782502', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(287, 287, 'Andrew Waiswa', 51, '+256704168537', 'Shopkeeper', 'Diploma', 'Brenda Byaruhanga', 53, '+256789185863', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(288, 288, 'Samuel Ssemwogerere', 59, '+256782998582', 'Teacher', 'Primary', 'Mary Okello', 55, '+256706146409', 'Entrepreneur', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(289, 289, 'Paul Busingye', 59, '+256755288897', 'Doctor', 'Primary', 'Esther Byaruhanga', 28, '+256701091139', 'Nurse', 'Primary', 'Lillian Busingye', 'Grandparent', 74, '+256703755436', 'Doctor', 'Diploma', 'Soroti', 'Choir member'),
(290, 290, 'Samuel Namukasa', 64, '+256775675696', 'Civil Servant', 'Master’s Degree', 'Sandra Busingye', 28, '+256779510434', 'Farmer', 'Primary', 'Patrick Namukasa', 'Father', 52, '+256785707169', 'Driver', 'Master’s Degree', 'Arua', 'Football team'),
(291, 291, 'Daniel Musoke', 53, '+256782910752', 'Doctor', 'Bachelor’s Degree', 'Pritah Aine', 59, '+256701105915', 'Farmer', 'Diploma', 'Hellen Musoke', 'Aunt', 27, '+256771202389', 'Engineer', 'Bachelor’s Degree', 'Masaka', 'Active in debate club'),
(292, 292, 'Samuel Ssemwogerere', 52, '+256707236576', 'Carpenter', 'Secondary', 'Doreen Nakato', 63, '+256776380853', 'Nurse', 'Secondary', 'Lillian Ssemwogerere', 'Grandparent', 39, '+256704831236', 'Farmer', 'Primary', 'Arua', 'Active in debate club'),
(293, 293, 'Solomon Ochieng', 35, '+256786307062', 'Mechanic', 'Secondary', 'Joy Opio', 56, '+256704945630', 'Trader', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(294, 294, 'Peter Opio', 34, '+256774289550', 'Driver', 'Primary', 'Alice Kato', 48, '+256753931918', 'Housewife', 'Secondary', 'Alice Opio', 'Mother', 78, '+256777795656', 'Farmer', 'Bachelor’s Degree', 'Gulu', 'Prefect'),
(295, 295, 'David Kato', 58, '+256787659171', 'Doctor', 'Secondary', 'Brenda Nalubega', 39, '+256705156975', 'Farmer', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(296, 296, 'Timothy Ssemwogerere', 37, '+256706966845', 'Mechanic', 'Master’s Degree', 'Sarah Ssemwogerere', 59, '+256706313492', 'Tailor', 'Bachelor’s Degree', 'Charles Ssemwogerere', 'Other', 25, '+256776440118', 'Farmer', 'Bachelor’s Degree', 'Gulu', 'Science fair participant'),
(297, 297, 'Andrew Busingye', 49, '+256707000660', 'Engineer', 'Bachelor’s Degree', 'Rebecca Akello', 45, '+256705844474', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(298, 298, 'John Ochieng', 52, '+256781052774', 'Civil Servant', 'Primary', 'Joy Ssemwogerere', 35, '+256777924670', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(299, 299, 'Isaac Kyomuhendo', 46, '+256772828590', 'Driver', 'Primary', 'Esther Nalubega', 56, '+256777882687', 'Trader', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(300, 300, 'Peter Ochieng', 56, '+256709698140', 'Engineer', 'Primary', 'Esther Kyomuhendo', 62, '+256756646400', 'Civil Servant', 'Master’s Degree', 'Hellen Ochieng', 'Other', 55, '+256789165167', 'Doctor', 'Diploma', 'Arua', 'Football team'),
(301, 301, 'Joseph Ssemwogerere', 39, '+256777708219', 'Mechanic', 'Primary', 'Brenda Waiswa', 44, '+256759181719', 'Trader', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(302, 302, 'Moses Aine', 46, '+256781196701', 'Teacher', 'Master’s Degree', 'Sandra Ssemwogerere', 41, '+256705451355', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(303, 303, 'Mark Musoke', 37, '+256758527947', 'Engineer', 'Diploma', 'Ritah Kato', 41, '+256702200320', 'Tailor', 'Primary', 'Hellen Musoke', 'Father', 67, '+256774134642', 'Engineer', 'Diploma', 'Soroti', 'Football team'),
(304, 304, 'Isaac Ssemwogerere', 37, '+256706411068', 'Farmer', 'Secondary', 'Pritah Musoke', 54, '+256758793481', 'Entrepreneur', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(305, 305, 'Samuel Namukasa', 64, '+256758231167', 'Mechanic', 'Primary', 'Winnie Namukasa', 30, '+256776008793', 'Civil Servant', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(306, 306, 'John Nantogo', 46, '+256778075689', 'Civil Servant', 'Primary', 'Doreen Mukasa', 40, '+256705319823', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(307, 307, 'Brian Kato', 63, '+256707891466', 'Carpenter', 'Bachelor’s Degree', 'Brenda Nantogo', 41, '+256779641868', 'Entrepreneur', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(308, 308, 'Daniel Okello', 35, '+256701584339', 'Driver', 'Secondary', 'Joan Nantogo', 60, '+256758958904', 'Civil Servant', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(309, 309, 'Joseph Nakato', 52, '+256771426637', 'Shopkeeper', 'Diploma', 'Joan Opio', 41, '+256781658925', 'Civil Servant', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(310, 310, 'Daniel Ochieng', 46, '+256786635375', 'Farmer', 'Bachelor’s Degree', 'Sarah Nalubega', 57, '+256752500552', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(311, 311, 'Andrew Kato', 62, '+256753916168', 'Teacher', 'Master’s Degree', 'Mary Aine', 53, '+256771594684', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(312, 312, 'Mark Namukasa', 56, '+256704335262', 'Doctor', 'Secondary', 'Joan Nalubega', 58, '+256781835586', 'Housewife', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(313, 313, 'Ivan Akello', 60, '+256771221214', 'Civil Servant', 'Secondary', 'Joan Namukasa', 30, '+256787772145', 'Nurse', 'Secondary', 'Charles Akello', 'Aunt', 30, '+256772655375', 'Mechanic', 'Secondary', 'Soroti', 'Science fair participant'),
(314, 314, 'John Lwanga', 66, '+256755492613', 'Teacher', 'Bachelor’s Degree', 'Esther Ssemwogerere', 29, '+256757954088', 'Housewife', 'Primary', 'Hellen Lwanga', 'Aunt', 43, '+256773059312', 'Carpenter', 'Secondary', 'Mbale', 'Science fair participant'),
(315, 315, 'John Waiswa', 69, '+256779323842', 'Farmer', 'Master’s Degree', 'Mary Kyomuhendo', 50, '+256788082695', 'Civil Servant', 'Diploma', 'James Waiswa', 'Mother', 68, '+256704787252', 'Engineer', 'Secondary', 'Jinja', 'Football team'),
(316, 316, 'Timothy Busingye', 61, '+256753346077', 'Farmer', 'Diploma', 'Sarah Ssemwogerere', 47, '+256752103055', 'Teacher', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(317, 317, 'Moses Mugabe', 36, '+256783585048', 'Mechanic', 'Diploma', 'Sarah Akello', 34, '+256758571979', 'Teacher', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(318, 318, 'Mark Opio', 37, '+256776077034', 'Doctor', 'Diploma', 'Joy Musoke', 41, '+256784481596', 'Civil Servant', 'Diploma', 'Rose Opio', 'Other', 55, '+256771528552', 'Mechanic', 'Primary', 'Fort Portal', 'Science fair participant'),
(319, 319, 'Timothy Opio', 41, '+256784743966', 'Farmer', 'Primary', 'Alice Waiswa', 36, '+256783097645', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(320, 320, 'Samuel Ssemwogerere', 49, '+256757443098', 'Doctor', 'Master’s Degree', 'Rebecca Akello', 45, '+256755142812', 'Entrepreneur', 'Secondary', 'Lillian Ssemwogerere', 'Uncle', 39, '+256782444637', 'Doctor', 'Diploma', 'Kampala', 'Choir member'),
(321, 321, 'Moses Kyomuhendo', 53, '+256755168607', 'Driver', 'Master’s Degree', 'Brenda Nakato', 47, '+256708011673', 'Teacher', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(322, 322, 'Brian Nakato', 60, '+256787355046', 'Shopkeeper', 'Master’s Degree', 'Doreen Busingye', 46, '+256758845178', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(323, 323, 'Isaac Namukasa', 67, '+256751243646', 'Shopkeeper', 'Primary', 'Sarah Okello', 35, '+256773858629', 'Nurse', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(324, 324, 'Isaac Ssemwogerere', 58, '+256706578537', 'Civil Servant', 'Diploma', 'Doreen Ssemwogerere', 61, '+256784881110', 'Farmer', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(325, 325, 'Andrew Ssemwogerere', 64, '+256707779635', 'Mechanic', 'Diploma', 'Joy Busingye', 37, '+256784497808', 'Nurse', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(326, 326, 'Joseph Mukasa', 32, '+256752844330', 'Civil Servant', 'Secondary', 'Sandra Lwanga', 56, '+256771206392', 'Civil Servant', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(327, 327, 'Paul Kato', 55, '+256785639630', 'Shopkeeper', 'Secondary', 'Ritah Mukasa', 60, '+256755476072', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(328, 328, 'Brian Ssemwogerere', 40, '+256772607414', 'Carpenter', 'Secondary', 'Doreen Byaruhanga', 49, '+256702242037', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(329, 329, 'Joseph Lwanga', 69, '+256756845944', 'Teacher', 'Secondary', 'Sarah Nakato', 56, '+256759601921', 'Entrepreneur', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(330, 330, 'Mark Lwanga', 69, '+256702861293', 'Doctor', 'Bachelor’s Degree', 'Grace Waiswa', 54, '+256774094741', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(331, 331, 'John Nakato', 42, '+256705052494', 'Farmer', 'Master’s Degree', 'Sarah Ssemwogerere', 30, '+256753975998', 'Teacher', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(332, 332, 'Andrew Busingye', 69, '+256756286809', 'Farmer', 'Primary', 'Alice Nakato', 39, '+256758792027', 'Nurse', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(333, 333, 'Mark Aine', 36, '+256754452720', 'Civil Servant', 'Master’s Degree', 'Doreen Lwanga', 59, '+256753826321', 'Teacher', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(334, 334, 'John Lwanga', 63, '+256788443098', 'Civil Servant', 'Master’s Degree', 'Esther Mugabe', 51, '+256709591672', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(335, 335, 'Solomon Musoke', 58, '+256756308770', 'Carpenter', 'Primary', 'Brenda Akello', 56, '+256775270126', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(336, 336, 'Solomon Tumusiime', 63, '+256772863906', 'Driver', 'Primary', 'Doreen Nalubega', 35, '+256778754147', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(337, 337, 'Andrew Ssemwogerere', 69, '+256758454007', 'Engineer', 'Secondary', 'Alice Nalubega', 49, '+256759045533', 'Farmer', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(338, 338, 'David Nakato', 49, '+256787275746', 'Engineer', 'Secondary', 'Alice Byaruhanga', 51, '+256771188048', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(339, 339, 'David Kyomuhendo', 48, '+256756793581', 'Engineer', 'Diploma', 'Rebecca Kato', 46, '+256789853704', 'Trader', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(340, 340, 'Paul Akello', 43, '+256754408956', 'Driver', 'Diploma', 'Joy Kyomuhendo', 30, '+256702520082', 'Housewife', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(341, 341, 'Joseph Aine', 30, '+256757610788', 'Carpenter', 'Primary', 'Pritah Kato', 50, '+256778457338', 'Trader', 'Primary', 'Florence Aine', 'Grandparent', 75, '+256703848102', 'Doctor', 'Bachelor’s Degree', 'Masaka', 'Football team'),
(342, 342, 'Paul Ssemwogerere', 69, '+256751039236', 'Mechanic', 'Master’s Degree', 'Joan Ochieng', 43, '+256776539260', 'Farmer', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(343, 343, 'Mark Nakato', 31, '+256775812643', 'Shopkeeper', 'Master’s Degree', 'Rebecca Tumusiime', 52, '+256751810443', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(344, 344, 'Isaac Waiswa', 39, '+256783177812', 'Engineer', 'Diploma', 'Alice Byaruhanga', 53, '+256778251255', 'Entrepreneur', 'Master’s Degree', 'Rose Waiswa', 'Grandparent', 60, '+256753673475', 'Farmer', 'Bachelor’s Degree', 'Mbarara', 'Active in debate club'),
(345, 345, 'Solomon Mukasa', 64, '+256754501232', 'Farmer', 'Primary', 'Sandra Byaruhanga', 41, '+256772793837', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(346, 346, 'Ivan Waiswa', 38, '+256772120275', 'Shopkeeper', 'Diploma', 'Rebecca Kyomuhendo', 48, '+256754761626', 'Trader', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(347, 347, 'Mark Byaruhanga', 52, '+256779826232', 'Carpenter', 'Diploma', 'Mary Busingye', 55, '+256701040510', 'Civil Servant', 'Primary', 'Hellen Byaruhanga', 'Other', 34, '+256752176924', 'Farmer', 'Primary', 'Mbarara', 'Prefect'),
(348, 348, 'David Kato', 42, '+256705143197', 'Farmer', 'Bachelor’s Degree', 'Pritah Kyomuhendo', 29, '+256781962262', 'Housewife', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(349, 349, 'Peter Akello', 50, '+256704487357', 'Engineer', 'Diploma', 'Esther Namukasa', 60, '+256776511922', 'Trader', 'Secondary', 'James Akello', 'Aunt', 45, '+256772224464', 'Farmer', 'Bachelor’s Degree', 'Soroti', 'Active in debate club'),
(350, 350, 'Joseph Mukasa', 66, '+256704072527', 'Driver', 'Bachelor’s Degree', 'Mary Akello', 42, '+256752080750', 'Civil Servant', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(351, 351, 'Paul Mukasa', 43, '+256782766472', 'Teacher', 'Secondary', 'Rebecca Nantogo', 58, '+256751907393', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(352, 352, 'Peter Tumusiime', 51, '+256784722640', 'Driver', 'Bachelor’s Degree', 'Brenda Nalubega', 60, '+256753563308', 'Trader', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(353, 353, 'Isaac Ssemwogerere', 40, '+256707678323', 'Teacher', 'Bachelor’s Degree', 'Winnie Ssemwogerere', 49, '+256779508912', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(354, 354, 'Brian Tumusiime', 47, '+256784598366', 'Teacher', 'Master’s Degree', 'Sarah Okello', 30, '+256773584594', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(355, 355, 'Isaac Opio', 36, '+256705459501', 'Engineer', 'Secondary', 'Pritah Nantogo', 53, '+256781982872', 'Nurse', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(356, 356, 'Isaac Busingye', 59, '+256755910627', 'Teacher', 'Primary', 'Brenda Kyomuhendo', 39, '+256705149316', 'Farmer', 'Primary', 'Lillian Busingye', 'Mother', 28, '+256703562892', 'Civil Servant', 'Bachelor’s Degree', 'Soroti', 'Active in debate club'),
(357, 357, 'Solomon Okello', 55, '+256754851552', 'Mechanic', 'Bachelor’s Degree', 'Sandra Nalubega', 31, '+256753137584', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(358, 358, 'Paul Okello', 57, '+256783529093', 'Shopkeeper', 'Bachelor’s Degree', 'Sarah Musoke', 42, '+256773627869', 'Farmer', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(359, 359, 'David Nalubega', 57, '+256757299802', 'Engineer', 'Bachelor’s Degree', 'Joan Tumusiime', 62, '+256752357819', 'Farmer', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(360, 360, 'Mark Byaruhanga', 38, '+256789866766', 'Farmer', 'Master’s Degree', 'Ritah Byaruhanga', 39, '+256788323456', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(361, 361, 'Brian Nalubega', 60, '+256702840788', 'Farmer', 'Diploma', 'Rebecca Opio', 63, '+256756445486', 'Nurse', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(362, 362, 'Paul Tumusiime', 57, '+256783543062', 'Shopkeeper', 'Bachelor’s Degree', 'Pritah Kato', 34, '+256779552562', 'Entrepreneur', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(363, 363, 'David Ochieng', 31, '+256757882930', 'Carpenter', 'Primary', 'Esther Mugabe', 28, '+256757573126', 'Housewife', 'Primary', 'Patrick Ochieng', 'Uncle', 76, '+256786278877', 'Shopkeeper', 'Diploma', 'Lira', 'Choir member'),
(364, 364, 'Andrew Nalubega', 35, '+256758629727', 'Farmer', 'Diploma', 'Doreen Kato', 34, '+256779715625', 'Entrepreneur', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(365, 365, 'Daniel Lwanga', 57, '+256705701200', 'Mechanic', 'Diploma', 'Brenda Nakato', 55, '+256706330721', 'Entrepreneur', 'Bachelor’s Degree', 'Alice Lwanga', 'Uncle', 29, '+256754850189', 'Mechanic', 'Diploma', 'Kampala', 'Active in debate club'),
(366, 366, 'Moses Nakato', 37, '+256774027595', 'Carpenter', 'Master’s Degree', 'Doreen Nakato', 48, '+256777589901', 'Trader', 'Primary', 'Robert Nakato', 'Uncle', 48, '+256773939053', 'Shopkeeper', 'Primary', 'Soroti', 'Active in debate club'),
(367, 367, 'Paul Musoke', 31, '+256755061427', 'Carpenter', 'Secondary', 'Joan Aine', 61, '+256785643786', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(368, 368, 'Solomon Nalubega', 65, '+256781797530', 'Farmer', 'Secondary', 'Pritah Ochieng', 58, '+256704448814', 'Nurse', 'Bachelor’s Degree', 'Susan Nalubega', 'Mother', 42, '+256775705823', 'Teacher', 'Primary', 'Mbale', 'Football team'),
(369, 369, 'Peter Lwanga', 68, '+256776927400', 'Carpenter', 'Primary', 'Pritah Kato', 43, '+256705255521', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(370, 370, 'Samuel Kyomuhendo', 39, '+256774480170', 'Teacher', 'Diploma', 'Winnie Aine', 44, '+256704450679', 'Nurse', 'Primary', 'Hellen Kyomuhendo', 'Mother', 48, '+256703680231', 'Doctor', 'Secondary', 'Mbale', 'Choir member'),
(371, 371, 'Daniel Lwanga', 56, '+256753775838', 'Doctor', 'Bachelor’s Degree', 'Joan Akello', 36, '+256752514002', 'Trader', 'Secondary', 'Hellen Lwanga', 'Father', 27, '+256708086539', 'Mechanic', 'Master’s Degree', 'Gulu', 'Prefect'),
(372, 372, 'Peter Tumusiime', 66, '+256703176475', 'Carpenter', 'Diploma', 'Winnie Namukasa', 45, '+256708934425', 'Civil Servant', 'Primary', 'Charles Tumusiime', 'Father', 66, '+256783555781', 'Engineer', 'Master’s Degree', 'Gulu', 'Science fair participant'),
(373, 373, 'Peter Lwanga', 52, '+256778246145', 'Engineer', 'Secondary', 'Esther Ssemwogerere', 60, '+256786829341', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(374, 374, 'Samuel Waiswa', 56, '+256786981994', 'Doctor', 'Secondary', 'Winnie Busingye', 52, '+256754148919', 'Teacher', 'Secondary', 'James Waiswa', 'Mother', 27, '+256788633761', 'Doctor', 'Primary', 'Fort Portal', 'Science fair participant'),
(375, 375, 'Moses Waiswa', 51, '+256786296373', 'Mechanic', 'Primary', 'Winnie Ochieng', 59, '+256702388285', 'Housewife', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(376, 376, 'David Lwanga', 47, '+256774352444', 'Farmer', 'Secondary', 'Winnie Byaruhanga', 60, '+256758159942', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(377, 377, 'Timothy Namukasa', 66, '+256702499583', 'Teacher', 'Diploma', 'Joan Busingye', 33, '+256779685227', 'Housewife', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(378, 378, 'John Tumusiime', 34, '+256771349044', 'Engineer', 'Bachelor’s Degree', 'Grace Ssemwogerere', 64, '+256708786159', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(379, 379, 'Peter Tumusiime', 54, '+256751740798', 'Carpenter', 'Diploma', 'Brenda Tumusiime', 48, '+256771258958', 'Civil Servant', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(380, 380, 'Paul Byaruhanga', 64, '+256706383883', 'Driver', 'Primary', 'Sarah Kato', 47, '+256789895312', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(381, 381, 'David Byaruhanga', 37, '+256756170674', 'Doctor', 'Bachelor’s Degree', 'Doreen Musoke', 63, '+256705286971', 'Teacher', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(382, 382, 'Paul Mugabe', 60, '+256708365360', 'Engineer', 'Bachelor’s Degree', 'Joan Tumusiime', 55, '+256752043425', 'Teacher', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(383, 383, 'Moses Akello', 61, '+256775285608', 'Driver', 'Secondary', 'Mary Okello', 60, '+256757855057', 'Farmer', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(384, 384, 'Joseph Nalubega', 49, '+256705428916', 'Teacher', 'Bachelor’s Degree', 'Winnie Mukasa', 42, '+256702545659', 'Tailor', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(385, 385, 'Ivan Byaruhanga', 64, '+256757974871', 'Mechanic', 'Primary', 'Mary Opio', 58, '+256772515629', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(386, 386, 'Brian Kato', 60, '+256755996796', 'Teacher', 'Secondary', 'Rebecca Mukasa', 32, '+256775607319', 'Nurse', 'Primary', 'Lillian Kato', 'Aunt', 34, '+256788875262', 'Farmer', 'Secondary', 'Arua', 'Science fair participant'),
(387, 387, 'Brian Waiswa', 66, '+256785588889', 'Teacher', 'Secondary', 'Rebecca Busingye', 39, '+256709316936', 'Housewife', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(388, 388, 'Samuel Kyomuhendo', 69, '+256709975692', 'Mechanic', 'Master’s Degree', 'Pritah Waiswa', 58, '+256753883926', 'Farmer', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(389, 389, 'David Ochieng', 45, '+256774179986', 'Mechanic', 'Secondary', 'Sarah Ochieng', 33, '+256771893790', 'Tailor', 'Bachelor’s Degree', 'Patrick Ochieng', 'Other', 66, '+256789323512', 'Teacher', 'Master’s Degree', 'Gulu', 'Football team'),
(390, 390, 'David Mukasa', 43, '+256786942434', 'Shopkeeper', 'Secondary', 'Pritah Nakato', 43, '+256772395034', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(391, 391, 'Andrew Nalubega', 59, '+256757742773', 'Engineer', 'Master’s Degree', 'Esther Byaruhanga', 51, '+256755733020', 'Trader', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(392, 392, 'Moses Opio', 44, '+256772473086', 'Engineer', 'Bachelor’s Degree', 'Ritah Lwanga', 57, '+256778303970', 'Tailor', 'Primary', 'Patrick Opio', 'Other', 75, '+256785305181', 'Mechanic', 'Secondary', 'Lira', 'Active in debate club'),
(393, 393, 'Mark Tumusiime', 68, '+256708800626', 'Doctor', 'Diploma', 'Pritah Akello', 39, '+256783040126', 'Entrepreneur', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(394, 394, 'Paul Waiswa', 41, '+256785644704', 'Mechanic', 'Bachelor’s Degree', 'Grace Nalubega', 45, '+256758838382', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(395, 395, 'Joseph Busingye', 39, '+256706873096', 'Doctor', 'Diploma', 'Alice Ssemwogerere', 48, '+256776565681', 'Entrepreneur', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(396, 396, 'Ivan Namukasa', 41, '+256751891146', 'Farmer', 'Primary', 'Ritah Ssemwogerere', 54, '+256772813772', 'Nurse', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(397, 397, 'Daniel Busingye', 33, '+256783817543', 'Driver', 'Primary', 'Winnie Lwanga', 53, '+256759547864', 'Trader', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(398, 398, 'Peter Nakato', 68, '+256774881825', 'Driver', 'Bachelor’s Degree', 'Ritah Byaruhanga', 43, '+256788497233', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(399, 399, 'Andrew Okello', 63, '+256756017539', 'Driver', 'Master’s Degree', 'Alice Lwanga', 29, '+256773825009', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(400, 400, 'Timothy Waiswa', 62, '+256706210582', 'Engineer', 'Diploma', 'Brenda Namukasa', 39, '+256703610976', 'Civil Servant', 'Diploma', 'Patrick Waiswa', 'Other', 63, '+256783181662', 'Carpenter', 'Primary', 'Gulu', 'Active in debate club'),
(401, 401, 'Solomon Kato', 68, '+256777061344', 'Civil Servant', 'Master’s Degree', 'Sandra Busingye', 29, '+256775489019', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(402, 402, 'Moses Nalubega', 53, '+256759279950', 'Farmer', 'Primary', 'Grace Ochieng', 61, '+256787054302', 'Trader', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(403, 403, 'Mark Byaruhanga', 41, '+256759642597', 'Driver', 'Master’s Degree', 'Mercy Opio', 44, '+256773016696', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(404, 404, 'Paul Nalubega', 54, '+256754245106', 'Teacher', 'Secondary', 'Sarah Busingye', 46, '+256709644974', 'Trader', 'Diploma', 'Florence Nalubega', 'Mother', 73, '+256784018940', 'Carpenter', 'Bachelor’s Degree', 'Mbarara', 'Science fair participant'),
(405, 405, 'Andrew Nakato', 40, '+256786187392', 'Shopkeeper', 'Secondary', 'Mercy Namukasa', 38, '+256774415232', 'Teacher', 'Diploma', 'Florence Nakato', 'Other', 72, '+256779113673', 'Driver', 'Primary', 'Arua', 'Prefect'),
(406, 406, 'Moses Mugabe', 43, '+256777352923', 'Shopkeeper', 'Primary', 'Pritah Lwanga', 47, '+256753103612', 'Entrepreneur', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(407, 407, 'Isaac Nantogo', 62, '+256758827862', 'Engineer', 'Bachelor’s Degree', 'Esther Aine', 51, '+256771482807', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(408, 408, 'Joseph Akello', 45, '+256789692679', 'Teacher', 'Primary', 'Grace Opio', 52, '+256757994215', 'Entrepreneur', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(409, 409, 'Andrew Ochieng', 36, '+256756741565', 'Carpenter', 'Master’s Degree', 'Mercy Nantogo', 57, '+256782253106', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(410, 410, 'David Mugabe', 35, '+256709088702', 'Mechanic', 'Diploma', 'Joy Waiswa', 56, '+256782994987', 'Farmer', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(411, 411, 'Joseph Kyomuhendo', 42, '+256771728778', 'Engineer', 'Bachelor’s Degree', 'Brenda Kato', 39, '+256756276185', 'Housewife', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(412, 412, 'Isaac Akello', 44, '+256779607856', 'Mechanic', 'Bachelor’s Degree', 'Mary Aine', 57, '+256707978405', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(413, 413, 'Mark Tumusiime', 47, '+256777287102', 'Teacher', 'Primary', 'Brenda Lwanga', 40, '+256786036420', 'Nurse', 'Primary', 'James Tumusiime', 'Aunt', 26, '+256702585731', 'Shopkeeper', 'Master’s Degree', 'Jinja', 'Prefect'),
(414, 414, 'Moses Nakato', 62, '+256757761592', 'Civil Servant', 'Secondary', 'Doreen Mugabe', 36, '+256755950527', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(415, 415, 'Mark Busingye', 64, '+256789178570', 'Shopkeeper', 'Diploma', 'Joan Nakato', 49, '+256788555731', 'Tailor', 'Secondary', 'Florence Busingye', 'Grandparent', 28, '+256778734162', 'Farmer', 'Bachelor’s Degree', 'Masaka', 'Football team'),
(416, 416, 'Paul Namukasa', 36, '+256784471845', 'Civil Servant', 'Master’s Degree', 'Alice Mugabe', 32, '+256773255238', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(417, 417, 'Paul Nakato', 62, '+256702107670', 'Civil Servant', 'Primary', 'Winnie Ssemwogerere', 36, '+256778863326', 'Trader', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(418, 418, 'Timothy Nantogo', 65, '+256771029041', 'Engineer', 'Secondary', 'Mercy Mukasa', 31, '+256708785370', 'Entrepreneur', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(419, 419, 'Joseph Waiswa', 42, '+256775929198', 'Carpenter', 'Diploma', 'Sandra Mugabe', 31, '+256773169486', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(420, 420, 'Daniel Musoke', 31, '+256775059303', 'Carpenter', 'Primary', 'Brenda Mugabe', 46, '+256789656078', 'Trader', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(421, 421, 'Moses Byaruhanga', 46, '+256705655131', 'Driver', 'Diploma', 'Ritah Nalubega', 48, '+256754969215', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(422, 422, 'Solomon Busingye', 63, '+256787836900', 'Mechanic', 'Primary', 'Rebecca Nalubega', 51, '+256781395221', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(423, 423, 'Timothy Ochieng', 47, '+256751895500', 'Carpenter', 'Primary', 'Mercy Waiswa', 38, '+256756938113', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(424, 424, 'Solomon Akello', 42, '+256777839670', 'Doctor', 'Secondary', 'Brenda Nalubega', 46, '+256707578326', 'Teacher', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(425, 425, 'Timothy Busingye', 61, '+256788776881', 'Doctor', 'Secondary', 'Sandra Busingye', 36, '+256773774796', 'Farmer', 'Secondary', 'James Busingye', 'Father', 52, '+256706792218', 'Doctor', 'Bachelor’s Degree', 'Jinja', 'Science fair participant'),
(426, 426, 'Solomon Waiswa', 48, '+256703277879', 'Driver', 'Secondary', 'Grace Aine', 56, '+256783386943', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(427, 427, 'Brian Nantogo', 58, '+256783193446', 'Carpenter', 'Primary', 'Rebecca Opio', 34, '+256784086880', 'Entrepreneur', 'Master’s Degree', 'Rose Nantogo', 'Mother', 57, '+256783211101', 'Farmer', 'Primary', 'Arua', 'Football team'),
(428, 428, 'Joseph Okello', 33, '+256786131875', 'Carpenter', 'Bachelor’s Degree', 'Alice Mugabe', 51, '+256778477163', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(429, 429, 'Isaac Kato', 51, '+256774893520', 'Engineer', 'Secondary', 'Pritah Nantogo', 62, '+256789426837', 'Housewife', 'Secondary', 'Robert Kato', 'Uncle', 49, '+256789690839', 'Carpenter', 'Bachelor’s Degree', 'Mbale', 'Choir member'),
(430, 430, 'Joseph Nalubega', 55, '+256703757809', 'Doctor', 'Secondary', 'Mary Akello', 43, '+256759006977', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(431, 431, 'Paul Nantogo', 36, '+256756286074', 'Teacher', 'Bachelor’s Degree', 'Joan Tumusiime', 62, '+256756593059', 'Housewife', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(432, 432, 'Isaac Musoke', 66, '+256787456034', 'Engineer', 'Secondary', 'Esther Nakato', 39, '+256772297173', 'Farmer', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(433, 433, 'Paul Kyomuhendo', 49, '+256777359007', 'Doctor', 'Primary', 'Pritah Ochieng', 54, '+256704134306', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(434, 434, 'Isaac Kato', 32, '+256707355770', 'Farmer', 'Bachelor’s Degree', 'Joy Ssemwogerere', 39, '+256701205548', 'Tailor', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(435, 435, 'Brian Okello', 37, '+256754822702', 'Shopkeeper', 'Bachelor’s Degree', 'Alice Nakato', 40, '+256754638979', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(436, 436, 'Mark Namukasa', 59, '+256751432555', 'Driver', 'Diploma', 'Brenda Mukasa', 54, '+256755100174', 'Farmer', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(437, 437, 'Samuel Tumusiime', 52, '+256709047148', 'Teacher', 'Master’s Degree', 'Winnie Mugabe', 51, '+256751792632', 'Entrepreneur', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(438, 438, 'Peter Musoke', 38, '+256701642754', 'Carpenter', 'Secondary', 'Sandra Kyomuhendo', 44, '+256702590297', 'Housewife', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(439, 439, 'John Aine', 37, '+256782348146', 'Driver', 'Primary', 'Sandra Kyomuhendo', 46, '+256709514123', 'Civil Servant', 'Master’s Degree', 'Alice Aine', 'Father', 49, '+256703767206', 'Mechanic', 'Bachelor’s Degree', 'Gulu', 'Active in debate club'),
(440, 440, 'Brian Mugabe', 50, '+256789709835', 'Civil Servant', 'Master’s Degree', 'Esther Musoke', 48, '+256773173977', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(441, 441, 'Brian Okello', 45, '+256782393550', 'Engineer', 'Primary', 'Rebecca Byaruhanga', 58, '+256705714555', 'Trader', 'Secondary', 'Lillian Okello', 'Mother', 33, '+256788272018', 'Carpenter', 'Bachelor’s Degree', 'Arua', 'Active in debate club'),
(442, 442, 'David Byaruhanga', 57, '+256757174120', 'Engineer', 'Bachelor’s Degree', 'Grace Tumusiime', 53, '+256709699134', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(443, 443, 'Daniel Waiswa', 60, '+256785280986', 'Engineer', 'Master’s Degree', 'Winnie Kyomuhendo', 63, '+256781802422', 'Tailor', 'Diploma', 'Alice Waiswa', 'Grandparent', 56, '+256752646595', 'Engineer', 'Primary', 'Masaka', 'Football team'),
(444, 444, 'Ivan Tumusiime', 56, '+256781659521', 'Teacher', 'Diploma', 'Sarah Akello', 63, '+256708900589', 'Farmer', 'Master’s Degree', 'James Tumusiime', 'Mother', 50, '+256753256096', 'Shopkeeper', 'Bachelor’s Degree', 'Gulu', 'Choir member'),
(445, 445, 'John Ochieng', 57, '+256785433517', 'Teacher', 'Master’s Degree', 'Alice Akello', 28, '+256709089686', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(446, 446, 'Solomon Waiswa', 52, '+256785253010', 'Engineer', 'Secondary', 'Joy Musoke', 34, '+256782049309', 'Trader', 'Primary', 'Patrick Waiswa', 'Father', 58, '+256781068665', 'Shopkeeper', 'Secondary', 'Lira', 'Science fair participant'),
(447, 447, 'Brian Mukasa', 67, '+256757228231', 'Shopkeeper', 'Secondary', 'Mercy Mugabe', 35, '+256752998828', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(448, 448, 'Isaac Busingye', 57, '+256787075515', 'Driver', 'Secondary', 'Mercy Nantogo', 64, '+256787489473', 'Civil Servant', 'Bachelor’s Degree', 'Charles Busingye', 'Mother', 33, '+256789945370', 'Teacher', 'Master’s Degree', 'Gulu', 'Prefect'),
(449, 449, 'Ivan Mugabe', 66, '+256751026053', 'Driver', 'Master’s Degree', 'Doreen Byaruhanga', 47, '+256753521063', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(450, 450, 'Isaac Tumusiime', 51, '+256784508476', 'Driver', 'Primary', 'Mercy Kato', 56, '+256771842413', 'Trader', 'Secondary', 'Robert Tumusiime', 'Aunt', 38, '+256783083478', 'Driver', 'Bachelor’s Degree', 'Masaka', 'Football team'),
(451, 451, 'Joseph Nantogo', 65, '+256755369266', 'Mechanic', 'Secondary', 'Ritah Ssemwogerere', 61, '+256779367238', 'Civil Servant', 'Master’s Degree', 'Susan Nantogo', 'Mother', 73, '+256785895430', 'Driver', 'Bachelor’s Degree', 'Kampala', 'Choir member'),
(452, 452, 'Brian Busingye', 37, '+256777452024', 'Civil Servant', 'Secondary', 'Winnie Namukasa', 29, '+256776744764', 'Teacher', 'Secondary', 'Alice Busingye', 'Father', 76, '+256782227163', 'Driver', 'Diploma', 'Mbarara', 'Science fair participant'),
(453, 453, 'Timothy Kato', 62, '+256786784602', 'Farmer', 'Diploma', 'Sandra Kyomuhendo', 43, '+256703217071', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(454, 454, 'Moses Mugabe', 36, '+256783667854', 'Mechanic', 'Secondary', 'Mercy Mugabe', 40, '+256751156136', 'Trader', 'Master’s Degree', 'Robert Mugabe', 'Other', 51, '+256754718679', 'Shopkeeper', 'Diploma', 'Masaka', 'Active in debate club'),
(455, 455, 'David Lwanga', 37, '+256702163216', 'Shopkeeper', 'Secondary', 'Joan Lwanga', 40, '+256708480353', 'Farmer', 'Bachelor’s Degree', 'Robert Lwanga', 'Grandparent', 64, '+256759114913', 'Driver', 'Diploma', 'Jinja', 'Science fair participant'),
(456, 456, 'Brian Ochieng', 51, '+256773232725', 'Mechanic', 'Primary', 'Doreen Okello', 32, '+256758299734', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(457, 457, 'Ivan Ssemwogerere', 42, '+256774288177', 'Driver', 'Diploma', 'Sarah Waiswa', 41, '+256772559397', 'Teacher', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(458, 458, 'Peter Byaruhanga', 64, '+256757075427', 'Doctor', 'Bachelor’s Degree', 'Ritah Busingye', 62, '+256773209558', 'Entrepreneur', 'Primary', 'James Byaruhanga', 'Father', 59, '+256753054211', 'Mechanic', 'Master’s Degree', 'Mbarara', 'Football team'),
(459, 459, 'Timothy Akello', 33, '+256778421476', 'Mechanic', 'Secondary', 'Brenda Nalubega', 49, '+256702939012', 'Teacher', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(460, 460, 'Timothy Nalubega', 47, '+256776391918', 'Engineer', 'Bachelor’s Degree', 'Grace Waiswa', 47, '+256784466146', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(461, 461, 'Andrew Akello', 42, '+256753003582', 'Carpenter', 'Secondary', 'Joy Okello', 39, '+256782907895', 'Housewife', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(462, 462, 'Solomon Okello', 54, '+256785216764', 'Civil Servant', 'Diploma', 'Mercy Lwanga', 31, '+256751431478', 'Teacher', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(463, 463, 'Samuel Aine', 66, '+256789433570', 'Civil Servant', 'Primary', 'Winnie Nantogo', 56, '+256776339325', 'Nurse', 'Primary', 'Patrick Aine', 'Mother', 66, '+256786073481', 'Mechanic', 'Diploma', 'Lira', 'Prefect');
INSERT INTO `parents` (`ParentId`, `StudentID`, `father_name`, `father_age`, `father_contact`, `father_occupation`, `father_education`, `mother_name`, `mother_age`, `mother_contact`, `mother_occupation`, `mother_education`, `guardian_name`, `guardian_relation`, `guardian_age`, `guardian_contact`, `guardian_occupation`, `guardian_education`, `guardian_address`, `MoreInformation`) VALUES
(464, 464, 'Solomon Ochieng', 36, '+256706822335', 'Carpenter', 'Master’s Degree', 'Rebecca Mukasa', 42, '+256774077429', 'Entrepreneur', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(465, 465, 'Andrew Busingye', 62, '+256753995631', 'Teacher', 'Bachelor’s Degree', 'Doreen Mugabe', 28, '+256703455001', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(466, 466, 'Brian Ssemwogerere', 42, '+256779631488', 'Civil Servant', 'Bachelor’s Degree', 'Sarah Kyomuhendo', 39, '+256787578826', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(467, 467, 'Brian Okello', 56, '+256755830650', 'Civil Servant', 'Diploma', 'Esther Nalubega', 64, '+256784128692', 'Entrepreneur', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(468, 468, 'Timothy Waiswa', 54, '+256783526596', 'Farmer', 'Primary', 'Mary Nakato', 60, '+256771402654', 'Farmer', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(469, 469, 'Isaac Okello', 33, '+256706127233', 'Civil Servant', 'Diploma', 'Pritah Mukasa', 55, '+256706018842', 'Nurse', 'Master’s Degree', 'Florence Okello', 'Uncle', 28, '+256707245197', 'Mechanic', 'Master’s Degree', 'Fort Portal', 'Active in debate club'),
(470, 470, 'Daniel Ochieng', 36, '+256775382105', 'Doctor', 'Primary', 'Joy Kato', 60, '+256703316729', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(471, 471, 'Timothy Opio', 47, '+256778367024', 'Carpenter', 'Bachelor’s Degree', 'Doreen Ssemwogerere', 55, '+256757353539', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(472, 472, 'Mark Nalubega', 42, '+256776223803', 'Carpenter', 'Primary', 'Sarah Musoke', 33, '+256781051094', 'Housewife', 'Secondary', 'Charles Nalubega', 'Uncle', 50, '+256776692003', 'Mechanic', 'Secondary', 'Mbale', 'Choir member'),
(473, 473, 'Isaac Mugabe', 31, '+256754490027', 'Mechanic', 'Bachelor’s Degree', 'Winnie Kyomuhendo', 43, '+256776175441', 'Teacher', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(474, 474, 'Joseph Busingye', 45, '+256773873940', 'Teacher', 'Master’s Degree', 'Doreen Nantogo', 63, '+256787630576', 'Trader', 'Secondary', 'Susan Busingye', 'Other', 53, '+256701622596', 'Civil Servant', 'Primary', 'Mbale', 'Choir member'),
(475, 475, 'Isaac Mugabe', 62, '+256709607664', 'Farmer', 'Diploma', 'Esther Tumusiime', 51, '+256783014205', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(476, 476, 'Solomon Kato', 49, '+256751849669', 'Farmer', 'Diploma', 'Brenda Kato', 46, '+256709466548', 'Civil Servant', 'Master’s Degree', 'Hellen Kato', 'Father', 70, '+256771899267', 'Teacher', 'Master’s Degree', 'Jinja', 'Active in debate club'),
(477, 477, 'Ivan Busingye', 63, '+256784909529', 'Mechanic', 'Master’s Degree', 'Grace Tumusiime', 51, '+256707509869', 'Entrepreneur', 'Master’s Degree', 'Robert Busingye', 'Grandparent', 79, '+256702860362', 'Carpenter', 'Master’s Degree', 'Soroti', 'Prefect'),
(478, 478, 'Peter Musoke', 57, '+256758887270', 'Carpenter', 'Primary', 'Sarah Akello', 57, '+256708498697', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(479, 479, 'Daniel Nalubega', 43, '+256755336598', 'Farmer', 'Primary', 'Mercy Byaruhanga', 47, '+256784720142', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(480, 480, 'Ivan Ssemwogerere', 47, '+256777341754', 'Teacher', 'Master’s Degree', 'Doreen Aine', 56, '+256771815603', 'Trader', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(481, 481, 'Brian Tumusiime', 35, '+256777322914', 'Shopkeeper', 'Diploma', 'Mary Ochieng', 61, '+256702624072', 'Nurse', 'Diploma', 'Rose Tumusiime', 'Father', 30, '+256708097295', 'Doctor', 'Master’s Degree', 'Gulu', 'Football team'),
(482, 482, 'Solomon Kyomuhendo', 53, '+256787955366', 'Shopkeeper', 'Secondary', 'Brenda Ochieng', 56, '+256752774625', 'Teacher', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(483, 483, 'Peter Ssemwogerere', 49, '+256753537572', 'Driver', 'Secondary', 'Brenda Nantogo', 57, '+256705614701', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(484, 484, 'Peter Ssemwogerere', 43, '+256775754186', 'Farmer', 'Diploma', 'Ritah Kato', 59, '+256701168691', 'Farmer', 'Diploma', 'Charles Ssemwogerere', 'Father', 64, '+256775730421', 'Engineer', 'Primary', 'Lira', 'Football team'),
(485, 485, 'Isaac Kato', 35, '+256703354269', 'Mechanic', 'Secondary', 'Pritah Tumusiime', 64, '+256783687529', 'Entrepreneur', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(486, 486, 'Solomon Namukasa', 36, '+256789367606', 'Teacher', 'Master’s Degree', 'Sarah Kato', 54, '+256754114614', 'Tailor', 'Secondary', 'Robert Namukasa', 'Uncle', 29, '+256751612425', 'Teacher', 'Primary', 'Lira', 'Active in debate club'),
(487, 487, 'Peter Byaruhanga', 65, '+256776810944', 'Driver', 'Master’s Degree', 'Brenda Nakato', 33, '+256705099347', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(488, 488, 'Samuel Tumusiime', 36, '+256772266294', 'Engineer', 'Secondary', 'Grace Okello', 59, '+256773185964', 'Tailor', 'Master’s Degree', 'Lillian Tumusiime', 'Father', 37, '+256703382581', 'Teacher', 'Master’s Degree', 'Lira', 'Active in debate club'),
(489, 489, 'Samuel Nalubega', 41, '+256776434587', 'Shopkeeper', 'Primary', 'Sandra Musoke', 52, '+256789087757', 'Trader', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(490, 490, 'Daniel Aine', 62, '+256788389710', 'Shopkeeper', 'Master’s Degree', 'Mary Ssemwogerere', 34, '+256789636862', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(491, 491, 'Isaac Opio', 54, '+256707187623', 'Mechanic', 'Master’s Degree', 'Alice Kyomuhendo', 61, '+256701434730', 'Teacher', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(492, 492, 'Peter Kato', 42, '+256701876366', 'Doctor', 'Bachelor’s Degree', 'Grace Nakato', 33, '+256751486399', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(493, 493, 'Solomon Musoke', 44, '+256704298794', 'Civil Servant', 'Diploma', 'Mercy Kyomuhendo', 28, '+256788061116', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(494, 494, 'David Nantogo', 46, '+256707582970', 'Carpenter', 'Master’s Degree', 'Winnie Namukasa', 41, '+256774670200', 'Civil Servant', 'Secondary', 'Susan Nantogo', 'Aunt', 65, '+256703876034', 'Teacher', 'Primary', 'Kampala', 'Active in debate club'),
(495, 495, 'Daniel Aine', 51, '+256707316798', 'Shopkeeper', 'Secondary', 'Rebecca Nakato', 28, '+256784550605', 'Entrepreneur', 'Secondary', 'Robert Aine', 'Grandparent', 61, '+256752462085', 'Carpenter', 'Primary', 'Mbale', 'Science fair participant'),
(496, 496, 'Mark Ssemwogerere', 32, '+256771630565', 'Teacher', 'Secondary', 'Mary Mugabe', 43, '+256756254685', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(497, 497, 'Brian Tumusiime', 41, '+256773503984', 'Shopkeeper', 'Secondary', 'Joan Musoke', 34, '+256775138929', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(498, 498, 'David Ssemwogerere', 34, '+256786397064', 'Civil Servant', 'Diploma', 'Alice Nakato', 48, '+256759228670', 'Entrepreneur', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(499, 499, 'Andrew Aine', 64, '+256771521142', 'Teacher', 'Master’s Degree', 'Grace Namukasa', 28, '+256752257267', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(500, 500, 'Paul Akello', 40, '+256787563354', 'Teacher', 'Bachelor’s Degree', 'Ritah Mugabe', 60, '+256776944460', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(501, 501, 'Peter Mugabe', 67, '+256703074934', 'Mechanic', 'Master’s Degree', 'Sarah Nantogo', 50, '+256753604016', 'Farmer', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(502, 502, 'Mark Kato', 50, '+256759256983', 'Civil Servant', 'Secondary', 'Joy Mugabe', 54, '+256787413510', 'Tailor', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(503, 503, 'Isaac Opio', 50, '+256774863947', 'Doctor', 'Master’s Degree', 'Joan Busingye', 43, '+256771236748', 'Entrepreneur', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(504, 504, 'Mark Nantogo', 59, '+256781981821', 'Doctor', 'Diploma', 'Sarah Akello', 37, '+256754562146', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(505, 505, 'Ivan Mukasa', 33, '+256784759270', 'Doctor', 'Master’s Degree', 'Ritah Mugabe', 37, '+256782246404', 'Entrepreneur', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(506, 506, 'Daniel Akello', 38, '+256777360732', 'Mechanic', 'Primary', 'Alice Opio', 50, '+256755771780', 'Trader', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(507, 507, 'Peter Nalubega', 37, '+256706476468', 'Teacher', 'Bachelor’s Degree', 'Doreen Okello', 46, '+256757057902', 'Trader', 'Primary', 'Rose Nalubega', 'Aunt', 51, '+256773011448', 'Driver', 'Primary', 'Mbarara', 'Prefect'),
(508, 508, 'Daniel Okello', 39, '+256777599078', 'Mechanic', 'Primary', 'Alice Nantogo', 32, '+256759549282', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(509, 509, 'Isaac Aine', 63, '+256752039291', 'Mechanic', 'Master’s Degree', 'Brenda Nakato', 59, '+256702436388', 'Civil Servant', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(510, 510, 'David Nantogo', 41, '+256758472684', 'Mechanic', 'Bachelor’s Degree', 'Ritah Ssemwogerere', 56, '+256702181910', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(511, 511, 'Ivan Ssemwogerere', 30, '+256754182911', 'Mechanic', 'Bachelor’s Degree', 'Doreen Musoke', 34, '+256706405230', 'Nurse', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(512, 512, 'Brian Waiswa', 41, '+256751115190', 'Engineer', 'Primary', 'Rebecca Okello', 60, '+256708607707', 'Housewife', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(513, 513, 'Paul Akello', 62, '+256786829429', 'Farmer', 'Secondary', 'Mercy Nantogo', 54, '+256789035132', 'Entrepreneur', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(514, 514, 'Joseph Musoke', 32, '+256773300911', 'Shopkeeper', 'Bachelor’s Degree', 'Sarah Mukasa', 62, '+256777321410', 'Trader', 'Master’s Degree', 'Susan Musoke', 'Other', 65, '+256784036220', 'Carpenter', 'Master’s Degree', 'Lira', 'Active in debate club'),
(515, 515, 'Andrew Lwanga', 48, '+256784468690', 'Farmer', 'Diploma', 'Brenda Kato', 31, '+256701675771', 'Farmer', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(516, 516, 'David Nakato', 65, '+256753682828', 'Driver', 'Primary', 'Alice Ssemwogerere', 29, '+256708840109', 'Trader', 'Bachelor’s Degree', 'Florence Nakato', 'Other', 55, '+256781861120', 'Carpenter', 'Bachelor’s Degree', 'Jinja', 'Football team'),
(517, 517, 'Andrew Namukasa', 56, '+256776202755', 'Shopkeeper', 'Primary', 'Brenda Waiswa', 38, '+256784022510', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(518, 518, 'Daniel Namukasa', 56, '+256773384114', 'Shopkeeper', 'Master’s Degree', 'Ritah Mugabe', 29, '+256781779982', 'Entrepreneur', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(519, 519, 'Joseph Tumusiime', 60, '+256778877655', 'Farmer', 'Diploma', 'Doreen Akello', 41, '+256786045418', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(520, 520, 'Brian Nakato', 65, '+256707912282', 'Farmer', 'Primary', 'Winnie Nantogo', 44, '+256773623013', 'Teacher', 'Secondary', 'James Nakato', 'Aunt', 35, '+256783242254', 'Farmer', 'Diploma', 'Kampala', 'Science fair participant'),
(521, 521, 'David Ssemwogerere', 69, '+256706737639', 'Teacher', 'Primary', 'Rebecca Musoke', 36, '+256772571355', 'Trader', 'Diploma', 'Charles Ssemwogerere', 'Aunt', 79, '+256781657652', 'Mechanic', 'Primary', 'Mbarara', 'Active in debate club'),
(522, 522, 'Brian Mugabe', 51, '+256705159515', 'Doctor', 'Master’s Degree', 'Joy Aine', 49, '+256751754918', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(523, 523, 'Timothy Mukasa', 34, '+256753974663', 'Shopkeeper', 'Diploma', 'Mary Opio', 40, '+256786408791', 'Entrepreneur', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(524, 524, 'Daniel Opio', 36, '+256772543630', 'Doctor', 'Master’s Degree', 'Sandra Kato', 51, '+256752051989', 'Housewife', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(525, 525, 'Timothy Mugabe', 56, '+256754382969', 'Farmer', 'Primary', 'Ritah Opio', 54, '+256702658821', 'Nurse', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(526, 526, 'Moses Tumusiime', 57, '+256702257347', 'Mechanic', 'Bachelor’s Degree', 'Mary Nakato', 30, '+256784517167', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(527, 527, 'Daniel Lwanga', 42, '+256782226273', 'Farmer', 'Master’s Degree', 'Mercy Ssemwogerere', 58, '+256785997889', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(528, 528, 'Samuel Opio', 52, '+256781821805', 'Shopkeeper', 'Secondary', 'Joan Lwanga', 42, '+256708640096', 'Teacher', 'Bachelor’s Degree', 'Lillian Opio', 'Uncle', 49, '+256775581609', 'Teacher', 'Master’s Degree', 'Fort Portal', 'Football team'),
(529, 529, 'Peter Busingye', 40, '+256759063703', 'Shopkeeper', 'Secondary', 'Rebecca Waiswa', 58, '+256771488811', 'Entrepreneur', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(530, 530, 'Samuel Byaruhanga', 44, '+256701861281', 'Driver', 'Diploma', 'Sandra Nalubega', 51, '+256702991917', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(531, 531, 'John Kato', 63, '+256788674446', 'Shopkeeper', 'Bachelor’s Degree', 'Doreen Namukasa', 50, '+256775887861', 'Tailor', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(532, 532, 'John Waiswa', 68, '+256704421608', 'Civil Servant', 'Bachelor’s Degree', 'Mary Mugabe', 52, '+256704782912', 'Nurse', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(533, 533, 'Isaac Waiswa', 48, '+256753265582', 'Driver', 'Secondary', 'Ritah Akello', 51, '+256772904913', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(534, 534, 'Ivan Opio', 59, '+256777239441', 'Driver', 'Diploma', 'Joy Kyomuhendo', 30, '+256702533921', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(535, 535, 'Peter Nalubega', 69, '+256701280886', 'Carpenter', 'Secondary', 'Mercy Nantogo', 31, '+256787788227', 'Farmer', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(536, 536, 'Isaac Nalubega', 30, '+256785653383', 'Driver', 'Secondary', 'Grace Tumusiime', 41, '+256709067483', 'Farmer', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(537, 537, 'Brian Akello', 52, '+256789025853', 'Farmer', 'Master’s Degree', 'Pritah Nakato', 64, '+256773595815', 'Nurse', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(538, 538, 'Joseph Busingye', 35, '+256773325475', 'Mechanic', 'Primary', 'Ritah Nakato', 42, '+256701543784', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(539, 539, 'Peter Nakato', 65, '+256757162034', 'Doctor', 'Primary', 'Sarah Kyomuhendo', 42, '+256751555845', 'Housewife', 'Bachelor’s Degree', 'Patrick Nakato', 'Mother', 30, '+256789999992', 'Carpenter', 'Bachelor’s Degree', 'Mbarara', 'Prefect'),
(540, 540, 'Mark Opio', 49, '+256783378843', 'Civil Servant', 'Master’s Degree', 'Ritah Kato', 32, '+256755913822', 'Entrepreneur', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(541, 541, 'Ivan Opio', 36, '+256771881997', 'Shopkeeper', 'Secondary', 'Sarah Mugabe', 38, '+256701985563', 'Nurse', 'Diploma', 'Patrick Opio', 'Father', 36, '+256787882697', 'Civil Servant', 'Master’s Degree', 'Masaka', 'Football team'),
(542, 542, 'Solomon Busingye', 57, '+256776547922', 'Shopkeeper', 'Primary', 'Doreen Mukasa', 55, '+256704025703', 'Civil Servant', 'Secondary', 'Robert Busingye', 'Mother', 42, '+256775540182', 'Teacher', 'Diploma', 'Masaka', 'Choir member'),
(543, 543, 'David Nantogo', 61, '+256754576092', 'Civil Servant', 'Primary', 'Alice Opio', 31, '+256759604537', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(544, 544, 'Joseph Kyomuhendo', 37, '+256708897081', 'Doctor', 'Primary', 'Pritah Nalubega', 53, '+256772655472', 'Housewife', 'Primary', 'Rose Kyomuhendo', 'Uncle', 55, '+256705780493', 'Driver', 'Bachelor’s Degree', 'Soroti', 'Science fair participant'),
(545, 545, 'Samuel Mugabe', 44, '+256706731108', 'Mechanic', 'Diploma', 'Brenda Nakato', 32, '+256709211609', 'Entrepreneur', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(546, 546, 'Moses Nantogo', 45, '+256756811053', 'Teacher', 'Primary', 'Winnie Aine', 49, '+256756727401', 'Nurse', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(547, 547, 'Paul Ochieng', 58, '+256772773615', 'Mechanic', 'Bachelor’s Degree', 'Winnie Nantogo', 58, '+256787251962', 'Nurse', 'Master’s Degree', 'Florence Ochieng', 'Mother', 58, '+256757972865', 'Driver', 'Diploma', 'Jinja', 'Prefect'),
(548, 548, 'Moses Byaruhanga', 58, '+256778045241', 'Farmer', 'Master’s Degree', 'Brenda Busingye', 34, '+256771660853', 'Civil Servant', 'Master’s Degree', 'Lillian Byaruhanga', 'Father', 58, '+256759664948', 'Civil Servant', 'Master’s Degree', 'Lira', 'Active in debate club'),
(549, 549, 'Joseph Byaruhanga', 53, '+256771445729', 'Carpenter', 'Secondary', 'Joan Tumusiime', 45, '+256753565355', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(550, 550, 'Samuel Lwanga', 46, '+256753069067', 'Engineer', 'Bachelor’s Degree', 'Sarah Nantogo', 34, '+256752682144', 'Teacher', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(551, 551, 'David Ochieng', 45, '+256707576035', 'Civil Servant', 'Secondary', 'Sandra Lwanga', 44, '+256774719117', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(552, 552, 'Andrew Namukasa', 61, '+256751013818', 'Mechanic', 'Primary', 'Brenda Musoke', 35, '+256707643425', 'Civil Servant', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(553, 553, 'Joseph Aine', 37, '+256779772787', 'Teacher', 'Bachelor’s Degree', 'Joan Kato', 44, '+256787700480', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(554, 554, 'Isaac Musoke', 53, '+256751307970', 'Carpenter', 'Secondary', 'Winnie Kato', 32, '+256704721178', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(555, 555, 'Ivan Aine', 62, '+256755608026', 'Driver', 'Primary', 'Joy Aine', 39, '+256751160634', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(556, 556, 'Joseph Mukasa', 47, '+256709485330', 'Engineer', 'Bachelor’s Degree', 'Joan Tumusiime', 60, '+256759283076', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(557, 557, 'Joseph Musoke', 64, '+256708216441', 'Carpenter', 'Master’s Degree', 'Doreen Busingye', 48, '+256754056617', 'Housewife', 'Primary', 'Lillian Musoke', 'Grandparent', 32, '+256778591322', 'Driver', 'Master’s Degree', 'Gulu', 'Active in debate club'),
(558, 558, 'Samuel Nakato', 68, '+256773930366', 'Carpenter', 'Secondary', 'Alice Nalubega', 45, '+256754707982', 'Farmer', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(559, 559, 'Ivan Akello', 34, '+256776751921', 'Shopkeeper', 'Master’s Degree', 'Sandra Tumusiime', 39, '+256772713735', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(560, 560, 'Joseph Kyomuhendo', 47, '+256787779882', 'Mechanic', 'Diploma', 'Winnie Mukasa', 47, '+256709676742', 'Civil Servant', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(561, 561, 'Mark Mukasa', 46, '+256708721056', 'Driver', 'Diploma', 'Ritah Ochieng', 31, '+256751318369', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(562, 562, 'John Okello', 37, '+256756047265', 'Doctor', 'Bachelor’s Degree', 'Rebecca Aine', 30, '+256773175486', 'Civil Servant', 'Master’s Degree', 'Charles Okello', 'Aunt', 29, '+256757310131', 'Driver', 'Secondary', 'Mbale', 'Active in debate club'),
(563, 563, 'Moses Akello', 64, '+256753861757', 'Doctor', 'Master’s Degree', 'Mary Mukasa', 52, '+256705881098', 'Civil Servant', 'Primary', 'Rose Akello', 'Other', 64, '+256773757334', 'Carpenter', 'Primary', 'Gulu', 'Football team'),
(564, 564, 'Mark Aine', 44, '+256788090603', 'Driver', 'Primary', 'Esther Nalubega', 45, '+256779259977', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(565, 565, 'Andrew Busingye', 51, '+256784705065', 'Driver', 'Bachelor’s Degree', 'Sarah Lwanga', 41, '+256776548915', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(566, 566, 'Paul Nakato', 33, '+256787364178', 'Doctor', 'Secondary', 'Doreen Nantogo', 34, '+256758765432', 'Farmer', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(567, 567, 'Mark Okello', 38, '+256709303054', 'Doctor', 'Bachelor’s Degree', 'Sandra Nantogo', 34, '+256701403248', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(568, 568, 'Daniel Tumusiime', 42, '+256701916286', 'Doctor', 'Diploma', 'Mary Kyomuhendo', 43, '+256787727724', 'Housewife', 'Master’s Degree', 'Hellen Tumusiime', 'Father', 77, '+256785632832', 'Driver', 'Diploma', 'Mbale', 'Choir member'),
(569, 569, 'Daniel Okello', 69, '+256772169005', 'Driver', 'Bachelor’s Degree', 'Rebecca Nakato', 59, '+256789097425', 'Trader', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(570, 570, 'Brian Aine', 62, '+256709867926', 'Farmer', 'Secondary', 'Winnie Nakato', 60, '+256706718450', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(571, 571, 'Mark Akello', 48, '+256784242752', 'Farmer', 'Bachelor’s Degree', 'Rebecca Nakato', 54, '+256786748272', 'Civil Servant', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(572, 572, 'David Byaruhanga', 61, '+256704158453', 'Carpenter', 'Master’s Degree', 'Esther Busingye', 29, '+256759909380', 'Farmer', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(573, 573, 'David Mugabe', 67, '+256777389544', 'Shopkeeper', 'Secondary', 'Esther Mukasa', 42, '+256705407349', 'Trader', 'Secondary', 'Lillian Mugabe', 'Grandparent', 44, '+256707764719', 'Shopkeeper', 'Master’s Degree', 'Masaka', 'Football team'),
(574, 574, 'Timothy Lwanga', 55, '+256786280157', 'Engineer', 'Secondary', 'Rebecca Namukasa', 46, '+256784463844', 'Teacher', 'Primary', 'Alice Lwanga', 'Aunt', 49, '+256778592538', 'Engineer', 'Bachelor’s Degree', 'Lira', 'Choir member'),
(575, 575, 'Moses Busingye', 44, '+256751837833', 'Driver', 'Diploma', 'Winnie Kyomuhendo', 33, '+256784271279', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(576, 576, 'Paul Ochieng', 44, '+256751752456', 'Shopkeeper', 'Master’s Degree', 'Joan Lwanga', 28, '+256705013109', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(577, 577, 'Moses Namukasa', 45, '+256777194654', 'Carpenter', 'Primary', 'Alice Byaruhanga', 45, '+256779873159', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(578, 578, 'Moses Akello', 59, '+256788738264', 'Farmer', 'Diploma', 'Doreen Mugabe', 36, '+256758092140', 'Housewife', 'Diploma', 'Rose Akello', 'Other', 48, '+256784347658', 'Engineer', 'Bachelor’s Degree', 'Mbale', 'Football team'),
(579, 579, 'Samuel Byaruhanga', 56, '+256707209469', 'Doctor', 'Secondary', 'Sarah Kyomuhendo', 50, '+256702743653', 'Trader', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(580, 580, 'David Tumusiime', 37, '+256773683055', 'Teacher', 'Diploma', 'Rebecca Okello', 64, '+256704738252', 'Civil Servant', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(581, 581, 'David Okello', 32, '+256701842189', 'Mechanic', 'Bachelor’s Degree', 'Doreen Akello', 47, '+256781531083', 'Tailor', 'Bachelor’s Degree', 'Robert Okello', 'Father', 58, '+256706375487', 'Carpenter', 'Secondary', 'Jinja', 'Science fair participant'),
(582, 582, 'Paul Musoke', 32, '+256706945642', 'Engineer', 'Bachelor’s Degree', 'Grace Tumusiime', 40, '+256706964563', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(583, 583, 'Samuel Namukasa', 33, '+256707458479', 'Doctor', 'Secondary', 'Esther Kato', 44, '+256771966559', 'Housewife', 'Master’s Degree', 'James Namukasa', 'Mother', 36, '+256751215168', 'Doctor', 'Bachelor’s Degree', 'Soroti', 'Science fair participant'),
(584, 584, 'Mark Mugabe', 44, '+256774342052', 'Civil Servant', 'Diploma', 'Sandra Waiswa', 54, '+256784794638', 'Teacher', 'Diploma', 'Lillian Mugabe', 'Grandparent', 67, '+256774542894', 'Driver', 'Primary', 'Jinja', 'Prefect'),
(585, 585, 'Andrew Nantogo', 61, '+256755967495', 'Doctor', 'Primary', 'Mary Ochieng', 51, '+256704037142', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(586, 586, 'Ivan Tumusiime', 68, '+256753167613', 'Teacher', 'Secondary', 'Rebecca Nakato', 28, '+256758056249', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(587, 587, 'Peter Kato', 41, '+256777690133', 'Doctor', 'Secondary', 'Mary Kato', 58, '+256772744608', 'Trader', 'Primary', 'Alice Kato', 'Father', 77, '+256753226794', 'Engineer', 'Master’s Degree', 'Arua', 'Active in debate club'),
(588, 588, 'Isaac Waiswa', 56, '+256751588702', 'Teacher', 'Diploma', 'Brenda Akello', 45, '+256772536071', 'Housewife', 'Bachelor’s Degree', 'Rose Waiswa', 'Grandparent', 29, '+256782939408', 'Farmer', 'Bachelor’s Degree', 'Arua', 'Prefect'),
(589, 589, 'Andrew Namukasa', 43, '+256779595390', 'Carpenter', 'Primary', 'Sarah Kato', 57, '+256787688458', 'Housewife', 'Diploma', 'Alice Namukasa', 'Aunt', 77, '+256754260518', 'Mechanic', 'Master’s Degree', 'Gulu', 'Active in debate club'),
(590, 590, 'Paul Mukasa', 31, '+256704801802', 'Mechanic', 'Diploma', 'Ritah Lwanga', 35, '+256785739153', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(591, 591, 'David Namukasa', 50, '+256707654077', 'Doctor', 'Master’s Degree', 'Rebecca Byaruhanga', 48, '+256704338731', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(592, 592, 'Isaac Aine', 42, '+256781322704', 'Driver', 'Diploma', 'Alice Ssemwogerere', 30, '+256704771462', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(593, 593, 'Ivan Tumusiime', 66, '+256782249655', 'Farmer', 'Master’s Degree', 'Brenda Waiswa', 39, '+256751993830', 'Farmer', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(594, 594, 'Joseph Musoke', 59, '+256783348226', 'Mechanic', 'Secondary', 'Doreen Ssemwogerere', 64, '+256759941428', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(595, 595, 'Isaac Aine', 34, '+256756499030', 'Civil Servant', 'Secondary', 'Grace Kato', 54, '+256754234382', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(596, 596, 'Peter Musoke', 48, '+256788752382', 'Civil Servant', 'Secondary', 'Sandra Nantogo', 46, '+256709070034', 'Housewife', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(597, 597, 'Andrew Lwanga', 42, '+256756911852', 'Shopkeeper', 'Secondary', 'Joy Lwanga', 37, '+256783103945', 'Trader', 'Master’s Degree', 'Patrick Lwanga', 'Grandparent', 27, '+256756011241', 'Teacher', 'Primary', 'Lira', 'Science fair participant'),
(598, 598, 'Mark Ochieng', 58, '+256784691945', 'Engineer', 'Bachelor’s Degree', 'Grace Nakato', 55, '+256759684469', 'Housewife', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(599, 599, 'Isaac Ssemwogerere', 44, '+256774685978', 'Shopkeeper', 'Master’s Degree', 'Brenda Nantogo', 33, '+256772134541', 'Tailor', 'Diploma', 'James Ssemwogerere', 'Aunt', 58, '+256774437716', 'Engineer', 'Primary', 'Jinja', 'Active in debate club'),
(600, 600, 'Paul Kato', 42, '+256784965283', 'Doctor', 'Secondary', 'Brenda Lwanga', 31, '+256789652691', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(601, 601, 'Isaac Namukasa', 69, '+256751394821', 'Carpenter', 'Primary', 'Grace Nalubega', 53, '+256754472181', 'Teacher', 'Diploma', 'James Namukasa', 'Other', 58, '+256703453511', 'Engineer', 'Primary', 'Mbarara', 'Football team'),
(602, 602, 'David Ochieng', 50, '+256776491041', 'Civil Servant', 'Primary', 'Grace Nantogo', 40, '+256705904629', 'Nurse', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(603, 603, 'Daniel Ssemwogerere', 58, '+256785111565', 'Doctor', 'Master’s Degree', 'Sarah Busingye', 36, '+256705008634', 'Housewife', 'Secondary', 'Rose Ssemwogerere', 'Uncle', 74, '+256756782393', 'Engineer', 'Diploma', 'Masaka', 'Science fair participant'),
(604, 604, 'David Nakato', 61, '+256708302678', 'Driver', 'Secondary', 'Alice Namukasa', 60, '+256756042341', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(605, 605, 'Daniel Aine', 44, '+256782360183', 'Doctor', 'Diploma', 'Brenda Aine', 61, '+256788662706', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(606, 606, 'Solomon Aine', 63, '+256774887800', 'Mechanic', 'Primary', 'Rebecca Kyomuhendo', 48, '+256751842366', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(607, 607, 'Brian Kyomuhendo', 30, '+256756719709', 'Teacher', 'Diploma', 'Pritah Byaruhanga', 49, '+256782781869', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(608, 608, 'John Mugabe', 64, '+256703297218', 'Driver', 'Primary', 'Sarah Mukasa', 55, '+256774917027', 'Tailor', 'Master’s Degree', 'Rose Mugabe', 'Other', 62, '+256776432117', 'Civil Servant', 'Secondary', 'Soroti', 'Football team'),
(609, 609, 'Peter Nalubega', 63, '+256783505577', 'Doctor', 'Primary', 'Grace Waiswa', 43, '+256788401913', 'Trader', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(610, 610, 'Timothy Busingye', 37, '+256773699179', 'Teacher', 'Master’s Degree', 'Winnie Mugabe', 35, '+256752952824', 'Teacher', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(611, 611, 'Isaac Akello', 60, '+256776219557', 'Farmer', 'Secondary', 'Winnie Okello', 43, '+256756734931', 'Farmer', 'Diploma', 'Alice Akello', 'Father', 45, '+256758164966', 'Engineer', 'Bachelor’s Degree', 'Kampala', 'Football team'),
(612, 612, 'John Opio', 35, '+256753063392', 'Mechanic', 'Diploma', 'Sarah Nalubega', 41, '+256787849759', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(613, 613, 'Mark Nantogo', 67, '+256784254191', 'Shopkeeper', 'Primary', 'Joan Akello', 63, '+256706820166', 'Entrepreneur', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(614, 614, 'Mark Okello', 48, '+256759066437', 'Shopkeeper', 'Bachelor’s Degree', 'Joan Kyomuhendo', 45, '+256709406063', 'Trader', 'Primary', 'Charles Okello', 'Mother', 30, '+256709301163', 'Mechanic', 'Diploma', 'Gulu', 'Science fair participant'),
(615, 615, 'Moses Tumusiime', 53, '+256772889068', 'Doctor', 'Master’s Degree', 'Joy Ssemwogerere', 33, '+256778604163', 'Farmer', 'Diploma', 'Hellen Tumusiime', 'Mother', 49, '+256772329325', 'Civil Servant', 'Primary', 'Arua', 'Prefect'),
(616, 616, 'Timothy Namukasa', 46, '+256753896806', 'Farmer', 'Secondary', 'Joy Akello', 43, '+256776607411', 'Farmer', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(617, 617, 'Mark Namukasa', 66, '+256702552047', 'Teacher', 'Secondary', 'Rebecca Ssemwogerere', 38, '+256702341513', 'Entrepreneur', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(618, 618, 'Paul Mugabe', 32, '+256784401752', 'Farmer', 'Master’s Degree', 'Ritah Nalubega', 32, '+256706917702', 'Trader', 'Diploma', 'Alice Mugabe', 'Grandparent', 71, '+256701250147', 'Carpenter', 'Bachelor’s Degree', 'Kampala', 'Prefect'),
(619, 619, 'John Nantogo', 35, '+256754965757', 'Engineer', 'Secondary', 'Rebecca Opio', 31, '+256781124257', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(620, 620, 'David Okello', 45, '+256702533296', 'Engineer', 'Bachelor’s Degree', 'Rebecca Lwanga', 33, '+256776005759', 'Nurse', 'Bachelor’s Degree', 'Lillian Okello', 'Other', 63, '+256773970519', 'Civil Servant', 'Secondary', 'Fort Portal', 'Choir member'),
(621, 621, 'Isaac Lwanga', 60, '+256782074778', 'Driver', 'Primary', 'Rebecca Opio', 41, '+256788575066', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(622, 622, 'Isaac Aine', 47, '+256784391682', 'Teacher', 'Bachelor’s Degree', 'Rebecca Nantogo', 58, '+256751921371', 'Housewife', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(623, 623, 'Peter Kato', 65, '+256704032497', 'Engineer', 'Diploma', 'Winnie Lwanga', 59, '+256755796193', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(624, 624, 'Timothy Ochieng', 55, '+256701090912', 'Teacher', 'Bachelor’s Degree', 'Winnie Tumusiime', 53, '+256785163161', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(625, 625, 'John Busingye', 31, '+256786939971', 'Doctor', 'Primary', 'Alice Waiswa', 30, '+256783475996', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(626, 626, 'Ivan Mukasa', 35, '+256758522813', 'Farmer', 'Diploma', 'Pritah Waiswa', 41, '+256701627023', 'Trader', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(627, 627, 'Ivan Namukasa', 37, '+256774094509', 'Mechanic', 'Primary', 'Brenda Mukasa', 28, '+256755054672', 'Civil Servant', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(628, 628, 'Daniel Byaruhanga', 60, '+256778662512', 'Doctor', 'Master’s Degree', 'Alice Lwanga', 59, '+256776297166', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(629, 629, 'Paul Ochieng', 69, '+256787019880', 'Mechanic', 'Master’s Degree', 'Pritah Okello', 63, '+256753714311', 'Housewife', 'Secondary', 'Charles Ochieng', 'Aunt', 74, '+256781805585', 'Shopkeeper', 'Secondary', 'Kampala', 'Football team'),
(630, 630, 'Daniel Mugabe', 51, '+256704356227', 'Shopkeeper', 'Diploma', 'Sandra Okello', 28, '+256775684322', 'Trader', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(631, 631, 'Paul Mugabe', 38, '+256758310593', 'Shopkeeper', 'Secondary', 'Grace Aine', 55, '+256758177311', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(632, 632, 'Joseph Mukasa', 47, '+256756592335', 'Engineer', 'Diploma', 'Sarah Namukasa', 42, '+256788450101', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(633, 633, 'Moses Waiswa', 47, '+256707705634', 'Mechanic', 'Secondary', 'Brenda Opio', 42, '+256709023552', 'Teacher', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(634, 634, 'Andrew Mukasa', 60, '+256774192260', 'Civil Servant', 'Diploma', 'Winnie Nantogo', 48, '+256773894583', 'Civil Servant', 'Primary', 'James Mukasa', 'Mother', 77, '+256702156950', 'Mechanic', 'Master’s Degree', 'Mbarara', 'Choir member'),
(635, 635, 'Moses Ochieng', 62, '+256786964058', 'Teacher', 'Master’s Degree', 'Mercy Mugabe', 39, '+256753221985', 'Housewife', 'Primary', 'Susan Ochieng', 'Mother', 54, '+256789917669', 'Civil Servant', 'Primary', 'Jinja', 'Football team'),
(636, 636, 'Brian Aine', 42, '+256775742652', 'Teacher', 'Primary', 'Ritah Kyomuhendo', 42, '+256778058955', 'Civil Servant', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(637, 637, 'Paul Mukasa', 37, '+256702951023', 'Doctor', 'Master’s Degree', 'Alice Musoke', 37, '+256786181425', 'Trader', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(638, 638, 'Moses Ochieng', 47, '+256752191358', 'Civil Servant', 'Diploma', 'Ritah Tumusiime', 60, '+256771834809', 'Nurse', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(639, 639, 'David Lwanga', 43, '+256707332886', 'Driver', 'Bachelor’s Degree', 'Grace Aine', 41, '+256755391255', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(640, 640, 'Paul Byaruhanga', 38, '+256771830170', 'Civil Servant', 'Primary', 'Mary Byaruhanga', 33, '+256759559044', 'Entrepreneur', 'Master’s Degree', 'Alice Byaruhanga', 'Aunt', 61, '+256755160460', 'Driver', 'Secondary', 'Masaka', 'Choir member'),
(641, 641, 'Timothy Namukasa', 49, '+256752802538', 'Carpenter', 'Master’s Degree', 'Brenda Busingye', 41, '+256782681983', 'Farmer', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(642, 642, 'Paul Nalubega', 40, '+256771820256', 'Mechanic', 'Primary', 'Winnie Kyomuhendo', 32, '+256782154315', 'Farmer', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(643, 643, 'Isaac Nalubega', 55, '+256776054400', 'Driver', 'Diploma', 'Rebecca Lwanga', 28, '+256707805147', 'Housewife', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(644, 644, 'Peter Kyomuhendo', 44, '+256758213546', 'Engineer', 'Bachelor’s Degree', 'Joan Mukasa', 39, '+256776098648', 'Entrepreneur', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(645, 645, 'Mark Byaruhanga', 51, '+256776786344', 'Civil Servant', 'Master’s Degree', 'Rebecca Tumusiime', 48, '+256758649896', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(646, 646, 'Ivan Okello', 41, '+256751702987', 'Farmer', 'Primary', 'Sandra Lwanga', 30, '+256773973534', 'Teacher', 'Bachelor’s Degree', 'Patrick Okello', 'Aunt', 50, '+256775944912', 'Driver', 'Master’s Degree', 'Soroti', 'Science fair participant'),
(647, 647, 'Peter Musoke', 57, '+256703621402', 'Shopkeeper', 'Master’s Degree', 'Alice Nalubega', 57, '+256759556086', 'Nurse', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(648, 648, 'Timothy Okello', 46, '+256753784924', 'Teacher', 'Primary', 'Mercy Nantogo', 37, '+256783206841', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(649, 649, 'Daniel Nantogo', 57, '+256704790625', 'Farmer', 'Diploma', 'Esther Akello', 60, '+256787165875', 'Teacher', 'Primary', 'Lillian Nantogo', 'Uncle', 72, '+256705170796', 'Mechanic', 'Primary', 'Mbale', 'Football team'),
(650, 650, 'Peter Akello', 55, '+256787034256', 'Farmer', 'Master’s Degree', 'Mary Kyomuhendo', 41, '+256787561721', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(651, 651, 'Samuel Waiswa', 45, '+256784316570', 'Mechanic', 'Secondary', 'Doreen Nantogo', 60, '+256751118643', 'Teacher', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(652, 652, 'Samuel Tumusiime', 33, '+256785705802', 'Carpenter', 'Master’s Degree', 'Winnie Mugabe', 54, '+256756839462', 'Trader', 'Master’s Degree', 'Charles Tumusiime', 'Mother', 78, '+256787948829', 'Teacher', 'Diploma', 'Jinja', 'Active in debate club'),
(653, 653, 'John Musoke', 69, '+256777229178', 'Mechanic', 'Diploma', 'Alice Nantogo', 38, '+256705784556', 'Housewife', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(654, 654, 'Peter Waiswa', 51, '+256706431417', 'Mechanic', 'Master’s Degree', 'Winnie Tumusiime', 53, '+256774454115', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(655, 655, 'Joseph Namukasa', 55, '+256778514092', 'Civil Servant', 'Diploma', 'Joy Byaruhanga', 48, '+256784689517', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(656, 656, 'Brian Kato', 39, '+256759976469', 'Farmer', 'Primary', 'Alice Byaruhanga', 54, '+256705529419', 'Nurse', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(657, 657, 'Timothy Nantogo', 56, '+256788476149', 'Carpenter', 'Primary', 'Rebecca Ssemwogerere', 28, '+256755936969', 'Teacher', 'Master’s Degree', 'James Nantogo', 'Uncle', 65, '+256755634108', 'Doctor', 'Secondary', 'Jinja', 'Prefect'),
(658, 658, 'Peter Busingye', 62, '+256759181159', 'Doctor', 'Primary', 'Pritah Kyomuhendo', 39, '+256784548773', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(659, 659, 'John Mugabe', 37, '+256789307741', 'Farmer', 'Diploma', 'Sandra Namukasa', 57, '+256753806458', 'Entrepreneur', 'Diploma', 'Robert Mugabe', 'Other', 50, '+256757323241', 'Shopkeeper', 'Diploma', 'Gulu', 'Choir member'),
(660, 660, 'Joseph Kyomuhendo', 66, '+256785786665', 'Teacher', 'Secondary', 'Joy Lwanga', 30, '+256783385844', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(661, 661, 'Moses Kyomuhendo', 30, '+256753978871', 'Teacher', 'Secondary', 'Ritah Nakato', 41, '+256703509884', 'Entrepreneur', 'Diploma', 'Robert Kyomuhendo', 'Other', 70, '+256788606143', 'Driver', 'Primary', 'Masaka', 'Choir member'),
(662, 662, 'Paul Byaruhanga', 38, '+256751433286', 'Mechanic', 'Primary', 'Esther Ssemwogerere', 34, '+256785484420', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(663, 663, 'Peter Lwanga', 59, '+256778488769', 'Farmer', 'Diploma', 'Joy Opio', 35, '+256706475049', 'Farmer', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(664, 664, 'Solomon Musoke', 41, '+256788694644', 'Mechanic', 'Diploma', 'Joy Ochieng', 38, '+256756562870', 'Trader', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(665, 665, 'John Busingye', 39, '+256784430355', 'Teacher', 'Diploma', 'Grace Lwanga', 62, '+256773684614', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(666, 666, 'Timothy Musoke', 50, '+256701515346', 'Engineer', 'Diploma', 'Grace Nalubega', 50, '+256752257076', 'Civil Servant', 'Diploma', 'Florence Musoke', 'Other', 54, '+256756421016', 'Teacher', 'Bachelor’s Degree', 'Mbarara', 'Prefect'),
(667, 667, 'Moses Akello', 42, '+256705431546', 'Teacher', 'Diploma', 'Joan Ochieng', 64, '+256775632027', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(668, 668, 'Paul Ssemwogerere', 58, '+256785660912', 'Mechanic', 'Bachelor’s Degree', 'Sandra Lwanga', 59, '+256778338787', 'Housewife', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(669, 669, 'Isaac Namukasa', 59, '+256776231308', 'Carpenter', 'Secondary', 'Ritah Okello', 39, '+256789849603', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(670, 670, 'Timothy Mugabe', 31, '+256771532349', 'Mechanic', 'Bachelor’s Degree', 'Sandra Nantogo', 29, '+256776015986', 'Trader', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(671, 671, 'Solomon Byaruhanga', 53, '+256753868733', 'Teacher', 'Secondary', 'Rebecca Ssemwogerere', 50, '+256753023951', 'Teacher', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(672, 672, 'Brian Ochieng', 63, '+256758352523', 'Carpenter', 'Diploma', 'Rebecca Opio', 64, '+256758574594', 'Tailor', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(673, 673, 'Samuel Akello', 68, '+256705905769', 'Farmer', 'Master’s Degree', 'Mercy Aine', 32, '+256757835655', 'Teacher', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(674, 674, 'Solomon Lwanga', 47, '+256753600026', 'Doctor', 'Primary', 'Esther Nakato', 43, '+256785308112', 'Trader', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(675, 675, 'Solomon Namukasa', 68, '+256755649597', 'Doctor', 'Diploma', 'Ritah Mugabe', 64, '+256789977455', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(676, 676, 'Peter Namukasa', 42, '+256779646773', 'Civil Servant', 'Bachelor’s Degree', 'Joan Nakato', 42, '+256775284118', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(677, 677, 'Paul Aine', 63, '+256759585268', 'Engineer', 'Secondary', 'Grace Okello', 49, '+256772668952', 'Tailor', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(678, 678, 'Peter Ssemwogerere', 32, '+256759683976', 'Driver', 'Primary', 'Alice Kato', 35, '+256753177092', 'Teacher', 'Primary', 'Lillian Ssemwogerere', 'Grandparent', 52, '+256778652398', 'Teacher', 'Master’s Degree', 'Masaka', 'Prefect'),
(679, 679, 'Solomon Nantogo', 52, '+256707628289', 'Driver', 'Primary', 'Mercy Mukasa', 34, '+256702093447', 'Trader', 'Primary', 'Alice Nantogo', 'Aunt', 79, '+256787524204', 'Teacher', 'Primary', 'Masaka', 'Science fair participant'),
(680, 680, 'Isaac Nalubega', 61, '+256709572456', 'Teacher', 'Master’s Degree', 'Joan Musoke', 62, '+256771863114', 'Teacher', 'Master’s Degree', 'Lillian Nalubega', 'Uncle', 45, '+256755375982', 'Civil Servant', 'Bachelor’s Degree', 'Lira', 'Active in debate club'),
(681, 681, 'Mark Byaruhanga', 47, '+256777405748', 'Teacher', 'Primary', 'Esther Nantogo', 40, '+256754957069', 'Teacher', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(682, 682, 'Paul Nalubega', 45, '+256785823612', 'Engineer', 'Bachelor’s Degree', 'Mary Kyomuhendo', 49, '+256756017625', 'Farmer', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(683, 683, 'Mark Mukasa', 48, '+256784242162', 'Doctor', 'Master’s Degree', 'Sarah Nantogo', 44, '+256708103438', 'Entrepreneur', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(684, 684, 'Moses Aine', 34, '+256789600150', 'Shopkeeper', 'Primary', 'Mary Mukasa', 54, '+256701861811', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(685, 685, 'Peter Kyomuhendo', 69, '+256759372241', 'Farmer', 'Bachelor’s Degree', 'Esther Opio', 62, '+256772789825', 'Nurse', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(686, 686, 'Peter Lwanga', 51, '+256702496767', 'Doctor', 'Diploma', 'Alice Busingye', 54, '+256776870686', 'Civil Servant', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(687, 687, 'Mark Nalubega', 40, '+256759558320', 'Engineer', 'Secondary', 'Sarah Busingye', 32, '+256702622147', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(688, 688, 'Solomon Busingye', 64, '+256756529708', 'Engineer', 'Bachelor’s Degree', 'Alice Kyomuhendo', 31, '+256702528741', 'Entrepreneur', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(689, 689, 'Peter Aine', 59, '+256778415740', 'Doctor', 'Primary', 'Joan Mukasa', 31, '+256778390137', 'Nurse', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(690, 690, 'Moses Ssemwogerere', 55, '+256755422704', 'Civil Servant', 'Bachelor’s Degree', 'Mary Akello', 59, '+256784952085', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(691, 691, 'Peter Aine', 54, '+256771269906', 'Teacher', 'Secondary', 'Joy Kyomuhendo', 62, '+256777134008', 'Trader', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(692, 692, 'Ivan Mugabe', 56, '+256759449694', 'Driver', 'Secondary', 'Grace Waiswa', 36, '+256785842967', 'Trader', 'Master’s Degree', 'Florence Mugabe', 'Mother', 27, '+256777766397', 'Driver', 'Secondary', 'Lira', 'Football team'),
(693, 693, 'Mark Nalubega', 57, '+256786661145', 'Shopkeeper', 'Master’s Degree', 'Alice Musoke', 45, '+256773883313', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(694, 694, 'Andrew Waiswa', 69, '+256771752463', 'Civil Servant', 'Diploma', 'Rebecca Namukasa', 41, '+256756988643', 'Housewife', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(695, 695, 'Paul Opio', 63, '+256773055380', 'Driver', 'Master’s Degree', 'Sandra Nalubega', 56, '+256752528055', 'Teacher', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(696, 696, 'David Namukasa', 59, '+256706238156', 'Mechanic', 'Secondary', 'Doreen Ssemwogerere', 29, '+256757951940', 'Entrepreneur', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member');
INSERT INTO `parents` (`ParentId`, `StudentID`, `father_name`, `father_age`, `father_contact`, `father_occupation`, `father_education`, `mother_name`, `mother_age`, `mother_contact`, `mother_occupation`, `mother_education`, `guardian_name`, `guardian_relation`, `guardian_age`, `guardian_contact`, `guardian_occupation`, `guardian_education`, `guardian_address`, `MoreInformation`) VALUES
(697, 697, 'John Waiswa', 58, '+256757108758', 'Driver', 'Diploma', 'Joy Mugabe', 51, '+256787096733', 'Farmer', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(698, 698, 'Isaac Kato', 34, '+256779043640', 'Mechanic', 'Primary', 'Grace Mugabe', 62, '+256772819052', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(699, 699, 'Brian Nalubega', 63, '+256709840825', 'Farmer', 'Diploma', 'Brenda Waiswa', 40, '+256786223749', 'Entrepreneur', 'Master’s Degree', 'Hellen Nalubega', 'Grandparent', 67, '+256709602323', 'Shopkeeper', 'Master’s Degree', 'Jinja', 'Active in debate club'),
(700, 700, 'Timothy Aine', 62, '+256775020836', 'Civil Servant', 'Master’s Degree', 'Doreen Lwanga', 52, '+256757566519', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(701, 701, 'David Nakato', 56, '+256701817679', 'Teacher', 'Secondary', 'Brenda Byaruhanga', 39, '+256786234616', 'Housewife', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(702, 702, 'Solomon Musoke', 58, '+256701841005', 'Doctor', 'Secondary', 'Ritah Okello', 53, '+256786543129', 'Civil Servant', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(703, 703, 'Joseph Okello', 65, '+256754501227', 'Doctor', 'Diploma', 'Sarah Aine', 55, '+256776582998', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(704, 704, 'Brian Lwanga', 62, '+256787398502', 'Mechanic', 'Secondary', 'Esther Okello', 47, '+256755054767', 'Teacher', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(705, 705, 'Andrew Lwanga', 67, '+256774667796', 'Driver', 'Diploma', 'Sandra Ssemwogerere', 31, '+256706946815', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(706, 706, 'Daniel Waiswa', 56, '+256774337813', 'Doctor', 'Secondary', 'Esther Mukasa', 37, '+256707139200', 'Farmer', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(707, 707, 'Mark Nantogo', 43, '+256772191936', 'Doctor', 'Secondary', 'Doreen Ochieng', 33, '+256705121356', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(708, 708, 'Peter Kato', 50, '+256709372270', 'Carpenter', 'Secondary', 'Sandra Nalubega', 46, '+256758950431', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(709, 709, 'Peter Busingye', 67, '+256771966531', 'Engineer', 'Primary', 'Brenda Opio', 34, '+256708580524', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(710, 710, 'Solomon Nantogo', 52, '+256705512234', 'Doctor', 'Bachelor’s Degree', 'Ritah Busingye', 45, '+256784962134', 'Entrepreneur', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(711, 711, 'Brian Nakato', 33, '+256786067369', 'Carpenter', 'Bachelor’s Degree', 'Winnie Tumusiime', 55, '+256783228684', 'Nurse', 'Master’s Degree', 'Hellen Nakato', 'Uncle', 70, '+256772902731', 'Shopkeeper', 'Bachelor’s Degree', 'Arua', 'Science fair participant'),
(712, 712, 'Timothy Busingye', 57, '+256708091074', 'Teacher', 'Primary', 'Rebecca Musoke', 52, '+256771425508', 'Farmer', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(713, 713, 'Isaac Lwanga', 69, '+256705976810', 'Doctor', 'Diploma', 'Joan Waiswa', 45, '+256777684913', 'Nurse', 'Primary', 'Charles Lwanga', 'Grandparent', 58, '+256759316151', 'Mechanic', 'Primary', 'Lira', 'Football team'),
(714, 714, 'David Byaruhanga', 57, '+256706057387', 'Civil Servant', 'Bachelor’s Degree', 'Grace Ssemwogerere', 53, '+256706087809', 'Housewife', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(715, 715, 'Daniel Tumusiime', 41, '+256782400963', 'Mechanic', 'Primary', 'Joan Byaruhanga', 35, '+256708499232', 'Trader', 'Master’s Degree', 'Charles Tumusiime', 'Aunt', 43, '+256774655883', 'Farmer', 'Bachelor’s Degree', 'Mbarara', 'Active in debate club'),
(716, 716, 'Andrew Tumusiime', 59, '+256789035586', 'Teacher', 'Master’s Degree', 'Joan Lwanga', 35, '+256701342412', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(717, 717, 'Isaac Nalubega', 38, '+256775042541', 'Civil Servant', 'Master’s Degree', 'Esther Namukasa', 54, '+256782053838', 'Farmer', 'Master’s Degree', 'Lillian Nalubega', 'Uncle', 31, '+256709023756', 'Driver', 'Secondary', 'Fort Portal', 'Science fair participant'),
(718, 718, 'Moses Okello', 51, '+256704077575', 'Civil Servant', 'Master’s Degree', 'Joan Nantogo', 63, '+256702969073', 'Farmer', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(719, 719, 'Samuel Nantogo', 62, '+256783188267', 'Engineer', 'Diploma', 'Pritah Okello', 55, '+256755369542', 'Teacher', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(720, 720, 'John Musoke', 55, '+256781175135', 'Farmer', 'Master’s Degree', 'Winnie Kato', 45, '+256705301812', 'Housewife', 'Master’s Degree', 'Patrick Musoke', 'Other', 57, '+256706996388', 'Farmer', 'Primary', 'Kampala', 'Prefect'),
(721, 721, 'Peter Kyomuhendo', 53, '+256706528918', 'Teacher', 'Diploma', 'Mercy Ochieng', 29, '+256754156956', 'Farmer', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(722, 722, 'John Mugabe', 60, '+256703138136', 'Teacher', 'Secondary', 'Brenda Ssemwogerere', 40, '+256776219394', 'Nurse', 'Primary', 'Robert Mugabe', 'Aunt', 66, '+256705482365', 'Carpenter', 'Master’s Degree', 'Lira', 'Science fair participant'),
(723, 723, 'Joseph Kato', 37, '+256777734685', 'Civil Servant', 'Primary', 'Sandra Tumusiime', 41, '+256704142589', 'Housewife', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(724, 724, 'John Mukasa', 43, '+256771782527', 'Engineer', 'Primary', 'Esther Kyomuhendo', 52, '+256783389030', 'Trader', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(725, 725, 'Daniel Ssemwogerere', 32, '+256779187274', 'Driver', 'Diploma', 'Grace Okello', 29, '+256773580040', 'Teacher', 'Bachelor’s Degree', 'Hellen Ssemwogerere', 'Mother', 44, '+256701443693', 'Carpenter', 'Secondary', 'Jinja', 'Choir member'),
(726, 726, 'Joseph Lwanga', 62, '+256779856829', 'Teacher', 'Primary', 'Grace Ochieng', 34, '+256789618561', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(727, 727, 'Paul Ssemwogerere', 64, '+256786769199', 'Engineer', 'Secondary', 'Winnie Musoke', 53, '+256702573921', 'Entrepreneur', 'Diploma', 'Florence Ssemwogerere', 'Other', 64, '+256772684186', 'Teacher', 'Master’s Degree', 'Gulu', 'Prefect'),
(728, 728, 'Ivan Ochieng', 58, '+256704296169', 'Engineer', 'Primary', 'Brenda Nalubega', 33, '+256702118317', 'Teacher', 'Secondary', 'Patrick Ochieng', 'Mother', 45, '+256758933700', 'Doctor', 'Primary', 'Kampala', 'Choir member'),
(729, 729, 'Solomon Nakato', 65, '+256703364297', 'Shopkeeper', 'Bachelor’s Degree', 'Sarah Busingye', 62, '+256704366912', 'Trader', 'Bachelor’s Degree', 'Charles Nakato', 'Grandparent', 53, '+256783852609', 'Driver', 'Master’s Degree', 'Jinja', 'Science fair participant'),
(730, 730, 'Moses Mugabe', 56, '+256759428663', 'Driver', 'Bachelor’s Degree', 'Ritah Mukasa', 43, '+256758720610', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(731, 731, 'Mark Kato', 39, '+256779050120', 'Driver', 'Bachelor’s Degree', 'Rebecca Nakato', 57, '+256786796313', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(732, 732, 'Daniel Opio', 36, '+256705688194', 'Doctor', 'Master’s Degree', 'Sandra Byaruhanga', 52, '+256774037258', 'Teacher', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(733, 733, 'Brian Nantogo', 46, '+256782607999', 'Driver', 'Diploma', 'Doreen Mukasa', 56, '+256702001317', 'Trader', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(734, 734, 'Mark Ssemwogerere', 69, '+256775699600', 'Doctor', 'Bachelor’s Degree', 'Pritah Nantogo', 44, '+256788474094', 'Civil Servant', 'Secondary', 'Charles Ssemwogerere', 'Mother', 49, '+256776148516', 'Driver', 'Secondary', 'Kampala', 'Science fair participant'),
(735, 735, 'Samuel Busingye', 63, '+256754039304', 'Farmer', 'Primary', 'Pritah Kato', 64, '+256704372331', 'Housewife', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(736, 736, 'John Kato', 62, '+256759234679', 'Doctor', 'Primary', 'Brenda Kato', 28, '+256706383200', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(737, 737, 'Samuel Aine', 34, '+256705352306', 'Teacher', 'Master’s Degree', 'Rebecca Tumusiime', 32, '+256757731903', 'Teacher', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(738, 738, 'Isaac Busingye', 64, '+256781228730', 'Farmer', 'Diploma', 'Doreen Tumusiime', 39, '+256786471956', 'Civil Servant', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(739, 739, 'Solomon Nantogo', 48, '+256789731335', 'Engineer', 'Secondary', 'Rebecca Ssemwogerere', 56, '+256755426701', 'Teacher', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(740, 740, 'John Namukasa', 38, '+256786446539', 'Doctor', 'Bachelor’s Degree', 'Pritah Aine', 37, '+256704024888', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(741, 741, 'David Lwanga', 57, '+256752364927', 'Mechanic', 'Bachelor’s Degree', 'Joan Akello', 35, '+256752400912', 'Trader', 'Primary', 'Charles Lwanga', 'Uncle', 69, '+256705832869', 'Shopkeeper', 'Diploma', 'Fort Portal', 'Choir member'),
(742, 742, 'Paul Ssemwogerere', 59, '+256788706823', 'Farmer', 'Diploma', 'Joy Ochieng', 64, '+256753155284', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(743, 743, 'Daniel Ochieng', 69, '+256779139084', 'Farmer', 'Primary', 'Rebecca Nantogo', 61, '+256754171921', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(744, 744, 'Timothy Okello', 59, '+256706243821', 'Mechanic', 'Secondary', 'Doreen Nakato', 35, '+256789739540', 'Nurse', 'Master’s Degree', 'Charles Okello', 'Uncle', 66, '+256705959228', 'Engineer', 'Diploma', 'Gulu', 'Prefect'),
(745, 745, 'Peter Namukasa', 30, '+256704184121', 'Teacher', 'Primary', 'Mary Okello', 31, '+256754131367', 'Tailor', 'Master’s Degree', 'Susan Namukasa', 'Uncle', 54, '+256705342869', 'Driver', 'Master’s Degree', 'Gulu', 'Science fair participant'),
(746, 746, 'Isaac Nalubega', 43, '+256703702701', 'Civil Servant', 'Bachelor’s Degree', 'Sarah Nantogo', 51, '+256706385181', 'Tailor', 'Primary', 'Lillian Nalubega', 'Other', 60, '+256783592143', 'Driver', 'Bachelor’s Degree', 'Lira', 'Active in debate club'),
(747, 747, 'Brian Akello', 51, '+256774091439', 'Shopkeeper', 'Bachelor’s Degree', 'Joy Akello', 49, '+256776917357', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(748, 748, 'Moses Ssemwogerere', 39, '+256776970060', 'Farmer', 'Secondary', 'Mercy Nalubega', 29, '+256775429120', 'Civil Servant', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(749, 749, 'Paul Nakato', 48, '+256776282040', 'Driver', 'Secondary', 'Rebecca Byaruhanga', 39, '+256708651080', 'Entrepreneur', 'Primary', 'Alice Nakato', 'Mother', 35, '+256779971901', 'Doctor', 'Bachelor’s Degree', 'Mbale', 'Football team'),
(750, 750, 'Brian Ssemwogerere', 59, '+256774491305', 'Driver', 'Secondary', 'Ritah Musoke', 47, '+256755547023', 'Nurse', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(751, 751, 'Solomon Kato', 39, '+256779786280', 'Farmer', 'Secondary', 'Mary Musoke', 40, '+256704788327', 'Tailor', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(752, 752, 'Mark Kyomuhendo', 48, '+256772508758', 'Carpenter', 'Bachelor’s Degree', 'Joan Busingye', 40, '+256702385641', 'Farmer', 'Master’s Degree', 'Robert Kyomuhendo', 'Mother', 67, '+256753286882', 'Mechanic', 'Diploma', 'Jinja', 'Prefect'),
(753, 753, 'Daniel Kato', 39, '+256775470956', 'Civil Servant', 'Primary', 'Alice Namukasa', 61, '+256752061437', 'Farmer', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(754, 754, 'David Nalubega', 59, '+256774964004', 'Engineer', 'Bachelor’s Degree', 'Winnie Kato', 48, '+256778317981', 'Teacher', 'Master’s Degree', 'Florence Nalubega', 'Other', 49, '+256757235692', 'Driver', 'Secondary', 'Mbarara', 'Active in debate club'),
(755, 755, 'Samuel Byaruhanga', 38, '+256707587254', 'Carpenter', 'Bachelor’s Degree', 'Grace Nalubega', 33, '+256753246244', 'Entrepreneur', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(756, 756, 'Andrew Byaruhanga', 33, '+256705274965', 'Teacher', 'Master’s Degree', 'Grace Musoke', 40, '+256784309543', 'Civil Servant', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(757, 757, 'Peter Kyomuhendo', 68, '+256787889330', 'Driver', 'Master’s Degree', 'Sandra Okello', 60, '+256771217464', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(758, 758, 'Isaac Nalubega', 34, '+256707354210', 'Engineer', 'Bachelor’s Degree', 'Doreen Akello', 40, '+256758846745', 'Nurse', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(759, 759, 'Timothy Kato', 38, '+256758344462', 'Shopkeeper', 'Secondary', 'Sarah Ochieng', 54, '+256785824748', 'Entrepreneur', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(760, 760, 'Mark Opio', 58, '+256759525625', 'Civil Servant', 'Diploma', 'Mercy Ochieng', 35, '+256707205907', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(761, 761, 'Joseph Tumusiime', 56, '+256703580233', 'Engineer', 'Secondary', 'Alice Ochieng', 33, '+256785394009', 'Farmer', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(762, 762, 'John Musoke', 46, '+256704405867', 'Mechanic', 'Diploma', 'Sarah Nantogo', 63, '+256756295236', 'Entrepreneur', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(763, 763, 'John Opio', 42, '+256704193197', 'Driver', 'Diploma', 'Winnie Musoke', 37, '+256705719850', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(764, 764, 'Solomon Opio', 67, '+256785892879', 'Teacher', 'Diploma', 'Sarah Musoke', 55, '+256789245874', 'Nurse', 'Master’s Degree', 'Robert Opio', 'Grandparent', 64, '+256771907295', 'Farmer', 'Bachelor’s Degree', 'Gulu', 'Prefect'),
(765, 765, 'Peter Tumusiime', 45, '+256779914837', 'Teacher', 'Master’s Degree', 'Ritah Mukasa', 62, '+256752819561', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(766, 766, 'Solomon Namukasa', 51, '+256785193843', 'Doctor', 'Bachelor’s Degree', 'Doreen Mugabe', 47, '+256751632569', 'Teacher', 'Secondary', 'Robert Namukasa', 'Mother', 68, '+256771388194', 'Engineer', 'Bachelor’s Degree', 'Lira', 'Science fair participant'),
(767, 767, 'Daniel Nantogo', 60, '+256758180641', 'Driver', 'Primary', 'Rebecca Aine', 56, '+256772524298', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(768, 768, 'Daniel Tumusiime', 62, '+256785407490', 'Shopkeeper', 'Diploma', 'Doreen Tumusiime', 36, '+256784305074', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(769, 769, 'David Ochieng', 64, '+256706426644', 'Driver', 'Bachelor’s Degree', 'Joy Mukasa', 30, '+256759998647', 'Teacher', 'Secondary', 'Rose Ochieng', 'Grandparent', 26, '+256773018743', 'Mechanic', 'Diploma', 'Masaka', 'Active in debate club'),
(770, 770, 'Isaac Akello', 31, '+256754326635', 'Teacher', 'Primary', 'Grace Opio', 41, '+256757371667', 'Civil Servant', 'Diploma', 'James Akello', 'Mother', 76, '+256776053046', 'Civil Servant', 'Master’s Degree', 'Arua', 'Active in debate club'),
(771, 771, 'Andrew Kato', 45, '+256755179470', 'Shopkeeper', 'Bachelor’s Degree', 'Joan Namukasa', 39, '+256781310266', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(772, 772, 'Ivan Okello', 58, '+256785854952', 'Teacher', 'Master’s Degree', 'Joy Busingye', 35, '+256782448010', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(773, 773, 'Daniel Byaruhanga', 67, '+256787799733', 'Engineer', 'Secondary', 'Mary Mugabe', 53, '+256758892508', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(774, 774, 'Isaac Nantogo', 31, '+256774927790', 'Mechanic', 'Diploma', 'Pritah Namukasa', 54, '+256709471776', 'Civil Servant', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(775, 775, 'Joseph Nantogo', 32, '+256756966429', 'Engineer', 'Bachelor’s Degree', 'Winnie Kato', 45, '+256771234384', 'Farmer', 'Bachelor’s Degree', 'Florence Nantogo', 'Uncle', 25, '+256753287386', 'Teacher', 'Primary', 'Fort Portal', 'Prefect'),
(776, 776, 'David Ochieng', 53, '+256757159660', 'Mechanic', 'Bachelor’s Degree', 'Joy Ssemwogerere', 39, '+256774055241', 'Trader', 'Master’s Degree', 'Robert Ochieng', 'Other', 79, '+256705208181', 'Engineer', 'Bachelor’s Degree', 'Lira', 'Football team'),
(777, 777, 'Timothy Okello', 65, '+256775153738', 'Teacher', 'Diploma', 'Alice Namukasa', 44, '+256782358691', 'Housewife', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(778, 778, 'Paul Waiswa', 57, '+256786540263', 'Driver', 'Bachelor’s Degree', 'Winnie Ssemwogerere', 52, '+256781517525', 'Farmer', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(779, 779, 'Moses Opio', 36, '+256772035419', 'Engineer', 'Diploma', 'Mercy Nantogo', 31, '+256787790921', 'Farmer', 'Diploma', 'Hellen Opio', 'Aunt', 70, '+256783672324', 'Driver', 'Master’s Degree', 'Lira', 'Prefect'),
(780, 780, 'Isaac Musoke', 30, '+256701069784', 'Teacher', 'Primary', 'Mercy Opio', 41, '+256706941734', 'Entrepreneur', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(781, 781, 'Joseph Namukasa', 37, '+256786493247', 'Teacher', 'Master’s Degree', 'Winnie Mugabe', 54, '+256788195302', 'Farmer', 'Bachelor’s Degree', 'Susan Namukasa', 'Mother', 49, '+256779023526', 'Driver', 'Secondary', 'Fort Portal', 'Prefect'),
(782, 782, 'Ivan Nakato', 56, '+256775946795', 'Civil Servant', 'Diploma', 'Joy Waiswa', 34, '+256754551342', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(783, 783, 'David Akello', 58, '+256772764305', 'Mechanic', 'Diploma', 'Mercy Nakato', 49, '+256772736309', 'Teacher', 'Master’s Degree', 'Rose Akello', 'Mother', 48, '+256701396683', 'Farmer', 'Bachelor’s Degree', 'Gulu', 'Active in debate club'),
(784, 784, 'Peter Akello', 51, '+256702326612', 'Doctor', 'Bachelor’s Degree', 'Pritah Busingye', 49, '+256786138926', 'Farmer', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(785, 785, 'Mark Ochieng', 43, '+256751786873', 'Driver', 'Secondary', 'Doreen Nakato', 40, '+256777135807', 'Trader', 'Primary', 'Patrick Ochieng', 'Aunt', 72, '+256702355701', 'Doctor', 'Master’s Degree', 'Gulu', 'Choir member'),
(786, 786, 'Solomon Nalubega', 46, '+256751483228', 'Mechanic', 'Diploma', 'Doreen Waiswa', 50, '+256704296810', 'Entrepreneur', 'Master’s Degree', 'Lillian Nalubega', 'Other', 47, '+256787609387', 'Doctor', 'Secondary', 'Mbale', 'Choir member'),
(787, 787, 'Daniel Busingye', 34, '+256701517681', 'Engineer', 'Diploma', 'Sandra Nakato', 45, '+256752149738', 'Entrepreneur', 'Secondary', 'Lillian Busingye', 'Mother', 46, '+256784456048', 'Teacher', 'Primary', 'Arua', 'Science fair participant'),
(788, 788, 'Samuel Ochieng', 59, '+256789073151', 'Mechanic', 'Diploma', 'Mary Ochieng', 47, '+256776631915', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(789, 789, 'Paul Aine', 37, '+256779817318', 'Mechanic', 'Secondary', 'Joan Musoke', 36, '+256772550533', 'Civil Servant', 'Bachelor’s Degree', 'Lillian Aine', 'Other', 57, '+256705851973', 'Engineer', 'Secondary', 'Mbale', 'Choir member'),
(790, 790, 'Daniel Kyomuhendo', 63, '+256782466505', 'Shopkeeper', 'Bachelor’s Degree', 'Brenda Namukasa', 54, '+256704534476', 'Tailor', 'Master’s Degree', 'Lillian Kyomuhendo', 'Aunt', 41, '+256758639425', 'Carpenter', 'Primary', 'Kampala', 'Active in debate club'),
(791, 791, 'Brian Nakato', 33, '+256781811915', 'Farmer', 'Diploma', 'Sarah Mukasa', 42, '+256786953549', 'Entrepreneur', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(792, 792, 'Andrew Musoke', 37, '+256706293819', 'Farmer', 'Secondary', 'Joy Namukasa', 60, '+256707655579', 'Farmer', 'Primary', 'Robert Musoke', 'Other', 33, '+256779034182', 'Carpenter', 'Master’s Degree', 'Jinja', 'Active in debate club'),
(793, 793, 'John Mugabe', 42, '+256775782089', 'Mechanic', 'Master’s Degree', 'Joan Aine', 57, '+256789589969', 'Nurse', 'Primary', 'Hellen Mugabe', 'Other', 43, '+256709730548', 'Teacher', 'Diploma', 'Lira', 'Prefect'),
(794, 794, 'Timothy Waiswa', 44, '+256785885138', 'Farmer', 'Master’s Degree', 'Doreen Nakato', 44, '+256772519358', 'Civil Servant', 'Secondary', 'Susan Waiswa', 'Aunt', 66, '+256755292758', 'Mechanic', 'Primary', 'Masaka', 'Active in debate club'),
(795, 795, 'Solomon Kato', 64, '+256759388804', 'Driver', 'Primary', 'Sarah Okello', 51, '+256776788857', 'Teacher', 'Secondary', 'Susan Kato', 'Mother', 57, '+256753470367', 'Teacher', 'Bachelor’s Degree', 'Lira', 'Prefect'),
(796, 796, 'Moses Musoke', 68, '+256758138480', 'Engineer', 'Secondary', 'Alice Nalubega', 40, '+256753701950', 'Housewife', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(797, 797, 'Solomon Byaruhanga', 45, '+256776064141', 'Doctor', 'Primary', 'Mercy Byaruhanga', 64, '+256758466919', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(798, 798, 'Paul Mukasa', 58, '+256752393781', 'Teacher', 'Diploma', 'Doreen Mugabe', 50, '+256704654322', 'Housewife', 'Secondary', 'James Mukasa', 'Mother', 36, '+256702096104', 'Farmer', 'Primary', 'Gulu', 'Football team'),
(799, 799, 'Daniel Opio', 68, '+256708256445', 'Engineer', 'Primary', 'Joan Waiswa', 55, '+256781987837', 'Teacher', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(800, 800, 'Paul Busingye', 68, '+256789134688', 'Teacher', 'Diploma', 'Winnie Aine', 51, '+256707599287', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club');

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `StudentID` int(11) NOT NULL,
  `AdmissionYear` year(4) NOT NULL,
  `Name` varchar(100) DEFAULT NULL,
  `Surname` varchar(100) NOT NULL,
  `DateOfBirth` date NOT NULL,
  `Gender` varchar(10) NOT NULL,
  `CurrentAddress` text DEFAULT NULL,
  `PhotoPath` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`StudentID`, `AdmissionYear`, `Name`, `Surname`, `DateOfBirth`, `Gender`, `CurrentAddress`, `PhotoPath`) VALUES
(1, '2025', 'Brenda', 'Akello', '2009-05-09', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(2, '2024', 'Esther', 'Kyomuhendo', '2008-06-19', 'Female', 'Jinja', 'static/images/default_profile.png'),
(3, '2024', 'Brian', 'Musoke', '2008-11-16', 'Male', 'Lira', 'static/images/default_profile.png'),
(4, '2024', 'Doreen', 'Aine', '2007-09-18', 'Female', 'Arua', 'static/images/default_profile.png'),
(5, '2024', 'Mercy', 'Okello', '2009-05-14', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(6, '2025', 'Joseph', 'Namukasa', '2005-09-19', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(7, '2024', 'Daniel', 'Ochieng', '2008-07-17', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(8, '2025', 'Sandra', 'Kyomuhendo', '2006-11-07', 'Female', 'Jinja', 'static/images/default_profile.png'),
(9, '2024', 'John', 'Nalubega', '2008-05-27', 'Male', 'Jinja', 'static/images/default_profile.png'),
(10, '2024', 'Winnie', 'Kato', '2008-05-14', 'Female', 'Arua', 'static/images/default_profile.png'),
(11, '2024', 'Joseph', 'Nalubega', '2008-06-19', 'Male', 'Jinja', 'static/images/default_profile.png'),
(12, '2024', 'Joan', 'Byaruhanga', '2006-03-02', 'Female', 'Lira', 'static/images/default_profile.png'),
(13, '2024', 'Samuel', 'Kato', '2009-02-06', 'Male', 'Jinja', 'static/images/default_profile.png'),
(14, '2024', 'Sandra', 'Byaruhanga', '2007-12-11', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(15, '2025', 'Moses', 'Kato', '2008-03-31', 'Male', 'Soroti', 'static/images/default_profile.png'),
(16, '2024', 'Joan', 'Tumusiime', '2006-11-18', 'Female', 'Arua', 'static/images/default_profile.png'),
(17, '2024', 'Timothy', 'Opio', '2005-10-06', 'Male', 'Jinja', 'static/images/default_profile.png'),
(18, '2025', 'Alice', 'Kato', '2009-11-14', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(19, '2025', 'Paul', 'Byaruhanga', '2006-10-15', 'Male', 'Mbarara', 'static/images/default_profile.png'),
(20, '2025', 'Ivan', 'Opio', '2008-04-05', 'Male', 'Masaka', 'static/images/default_profile.png'),
(21, '2025', 'Solomon', 'Mugabe', '2007-07-05', 'Male', 'Mbarara', 'static/images/default_profile.png'),
(22, '2025', 'Pritah', 'Aine', '2007-08-04', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(23, '2024', 'Sandra', 'Kato', '2007-09-16', 'Female', 'Gulu', 'static/images/default_profile.png'),
(24, '2024', 'Moses', 'Namukasa', '2006-01-09', 'Male', 'Mbarara', 'static/images/default_profile.png'),
(25, '2024', 'Paul', 'Mugabe', '2006-06-07', 'Male', 'Kampala', 'static/images/default_profile.png'),
(26, '2024', 'Timothy', 'Okello', '2007-07-07', 'Male', 'Gulu', 'static/images/default_profile.png'),
(27, '2025', 'Ivan', 'Namukasa', '2009-08-16', 'Male', 'Kampala', 'static/images/default_profile.png'),
(28, '2024', 'Ritah', 'Opio', '2009-02-24', 'Female', 'Arua', 'static/images/default_profile.png'),
(29, '2025', 'Samuel', 'Waiswa', '2006-08-10', 'Male', 'Soroti', 'static/images/default_profile.png'),
(30, '2024', 'Brian', 'Namukasa', '2009-02-19', 'Male', 'Mbale', 'static/images/default_profile.png'),
(31, '2024', 'Alice', 'Aine', '2005-02-13', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(32, '2024', 'John', 'Ssemwogerere', '2008-09-20', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(33, '2025', 'Joan', 'Nantogo', '2007-09-23', 'Female', 'Jinja', 'static/images/default_profile.png'),
(34, '2024', 'Winnie', 'Lwanga', '2005-08-28', 'Female', 'Soroti', 'static/images/default_profile.png'),
(35, '2024', 'Timothy', 'Waiswa', '2005-12-12', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(36, '2024', 'Isaac', 'Kyomuhendo', '2009-12-13', 'Male', 'Jinja', 'static/images/default_profile.png'),
(37, '2024', 'Brenda', 'Nakato', '2009-11-17', 'Female', 'Mbale', 'static/images/default_profile.png'),
(38, '2024', 'Grace', 'Busingye', '2007-12-11', 'Female', 'Arua', 'static/images/default_profile.png'),
(39, '2025', 'Rebecca', 'Namukasa', '2005-04-22', 'Female', 'Kampala', 'static/images/default_profile.png'),
(40, '2024', 'Joseph', 'Opio', '2009-05-10', 'Male', 'Jinja', 'static/images/default_profile.png'),
(41, '2025', 'Mark', 'Akello', '2007-07-08', 'Male', 'Kampala', 'static/images/default_profile.png'),
(42, '2025', 'Doreen', 'Musoke', '2007-04-14', 'Female', 'Mbale', 'static/images/default_profile.png'),
(43, '2024', 'Isaac', 'Akello', '2007-11-08', 'Male', 'Gulu', 'static/images/default_profile.png'),
(44, '2025', 'Joan', 'Ochieng', '2008-10-14', 'Female', 'Arua', 'static/images/default_profile.png'),
(45, '2024', 'Paul', 'Nalubega', '2009-10-17', 'Male', 'Mbarara', 'static/images/default_profile.png'),
(46, '2025', 'Brian', 'Nalubega', '2005-03-19', 'Male', 'Jinja', 'static/images/default_profile.png'),
(47, '2025', 'Esther', 'Tumusiime', '2009-05-07', 'Female', 'Mbale', 'static/images/default_profile.png'),
(48, '2025', 'Alice', 'Nakato', '2008-07-18', 'Female', 'Kampala', 'static/images/default_profile.png'),
(49, '2025', 'Grace', 'Nantogo', '2005-07-24', 'Female', 'Kampala', 'static/images/default_profile.png'),
(50, '2025', 'Brian', 'Lwanga', '2008-10-08', 'Male', 'Lira', 'static/images/default_profile.png'),
(51, '2024', 'Mary', 'Lwanga', '2007-12-26', 'Female', 'Lira', 'static/images/default_profile.png'),
(52, '2025', 'Daniel', 'Nakato', '2007-11-21', 'Male', 'Kampala', 'static/images/default_profile.png'),
(53, '2025', 'Brenda', 'Waiswa', '2009-05-18', 'Female', 'Masaka', 'static/images/default_profile.png'),
(54, '2025', 'David', 'Musoke', '2008-11-24', 'Male', 'Arua', 'static/images/default_profile.png'),
(55, '2024', 'Esther', 'Ochieng', '2007-03-02', 'Female', 'Kampala', 'static/images/default_profile.png'),
(56, '2024', 'John', 'Nalubega', '2009-06-06', 'Male', 'Jinja', 'static/images/default_profile.png'),
(57, '2024', 'Andrew', 'Nantogo', '2008-10-26', 'Male', 'Gulu', 'static/images/default_profile.png'),
(58, '2025', 'Paul', 'Nalubega', '2005-02-05', 'Male', 'Masaka', 'static/images/default_profile.png'),
(59, '2025', 'Moses', 'Kyomuhendo', '2008-04-05', 'Male', 'Soroti', 'static/images/default_profile.png'),
(60, '2025', 'Joan', 'Tumusiime', '2006-01-13', 'Female', 'Masaka', 'static/images/default_profile.png'),
(61, '2025', 'Joy', 'Aine', '2006-03-05', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(62, '2024', 'Alice', 'Opio', '2005-12-09', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(63, '2025', 'Samuel', 'Opio', '2005-07-29', 'Male', 'Soroti', 'static/images/default_profile.png'),
(64, '2024', 'Andrew', 'Akello', '2005-05-31', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(65, '2024', 'Rebecca', 'Musoke', '2006-03-14', 'Female', 'Soroti', 'static/images/default_profile.png'),
(66, '2025', 'Joseph', 'Aine', '2008-12-07', 'Male', 'Soroti', 'static/images/default_profile.png'),
(67, '2025', 'Grace', 'Byaruhanga', '2009-12-25', 'Female', 'Arua', 'static/images/default_profile.png'),
(68, '2025', 'Andrew', 'Ssemwogerere', '2006-01-30', 'Male', 'Jinja', 'static/images/default_profile.png'),
(69, '2024', 'Paul', 'Lwanga', '2008-08-30', 'Male', 'Jinja', 'static/images/default_profile.png'),
(70, '2025', 'John', 'Ssemwogerere', '2009-02-05', 'Male', 'Lira', 'static/images/default_profile.png'),
(71, '2025', 'Brian', 'Lwanga', '2009-01-27', 'Male', 'Mbale', 'static/images/default_profile.png'),
(72, '2025', 'Paul', 'Nalubega', '2005-01-16', 'Male', 'Masaka', 'static/images/default_profile.png'),
(73, '2025', 'Brian', 'Opio', '2007-12-18', 'Male', 'Kampala', 'static/images/default_profile.png'),
(74, '2025', 'Mark', 'Okello', '2009-02-21', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(75, '2025', 'Joan', 'Mugabe', '2006-07-12', 'Female', 'Gulu', 'static/images/default_profile.png'),
(76, '2025', 'Paul', 'Namukasa', '2006-12-24', 'Male', 'Masaka', 'static/images/default_profile.png'),
(77, '2025', 'Sandra', 'Mugabe', '2007-11-14', 'Female', 'Jinja', 'static/images/default_profile.png'),
(78, '2025', 'Isaac', 'Ssemwogerere', '2009-03-04', 'Male', 'Mbarara', 'static/images/default_profile.png'),
(79, '2024', 'Peter', 'Waiswa', '2006-11-10', 'Male', 'Soroti', 'static/images/default_profile.png'),
(80, '2024', 'Daniel', 'Opio', '2006-10-16', 'Male', 'Soroti', 'static/images/default_profile.png'),
(81, '2024', 'John', 'Byaruhanga', '2007-03-01', 'Male', 'Kampala', 'static/images/default_profile.png'),
(82, '2024', 'Sandra', 'Musoke', '2008-05-07', 'Female', 'Soroti', 'static/images/default_profile.png'),
(83, '2024', 'Winnie', 'Namukasa', '2009-10-04', 'Female', 'Lira', 'static/images/default_profile.png'),
(84, '2025', 'Mercy', 'Ssemwogerere', '2008-09-01', 'Female', 'Soroti', 'static/images/default_profile.png'),
(85, '2024', 'Daniel', 'Kato', '2009-10-15', 'Male', 'Lira', 'static/images/default_profile.png'),
(86, '2024', 'Joseph', 'Ssemwogerere', '2006-12-03', 'Male', 'Soroti', 'static/images/default_profile.png'),
(87, '2024', 'Sarah', 'Busingye', '2006-10-10', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(88, '2025', 'Pritah', 'Ochieng', '2005-11-01', 'Female', 'Soroti', 'static/images/default_profile.png'),
(89, '2024', 'Rebecca', 'Tumusiime', '2008-11-26', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(90, '2025', 'Brenda', 'Waiswa', '2009-03-27', 'Female', 'Arua', 'static/images/default_profile.png'),
(91, '2024', 'Alice', 'Lwanga', '2007-10-31', 'Female', 'Jinja', 'static/images/default_profile.png'),
(92, '2025', 'Brian', 'Ssemwogerere', '2006-07-16', 'Male', 'Arua', 'static/images/default_profile.png'),
(93, '2024', 'Joan', 'Mugabe', '2006-02-01', 'Female', 'Masaka', 'static/images/default_profile.png'),
(94, '2025', 'Ivan', 'Lwanga', '2005-08-20', 'Male', 'Kampala', 'static/images/default_profile.png'),
(95, '2025', 'Mercy', 'Byaruhanga', '2006-02-06', 'Female', 'Mbale', 'static/images/default_profile.png'),
(96, '2024', 'Brian', 'Tumusiime', '2007-02-07', 'Male', 'Mbale', 'static/images/default_profile.png'),
(97, '2025', 'Joseph', 'Waiswa', '2005-02-19', 'Male', 'Gulu', 'static/images/default_profile.png'),
(98, '2024', 'Winnie', 'Musoke', '2009-04-20', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(99, '2025', 'Pritah', 'Nakato', '2009-03-30', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(100, '2025', 'Daniel', 'Busingye', '2005-04-18', 'Male', 'Jinja', 'static/images/default_profile.png'),
(101, '2025', 'Joseph', 'Mukasa', '2008-10-11', 'Male', 'Arua', 'static/images/default_profile.png'),
(102, '2024', 'Mary', 'Mukasa', '2005-02-18', 'Female', 'Kampala', 'static/images/default_profile.png'),
(103, '2024', 'Samuel', 'Nakato', '2006-05-10', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(104, '2025', 'John', 'Busingye', '2009-10-11', 'Male', 'Masaka', 'static/images/default_profile.png'),
(105, '2025', 'Esther', 'Tumusiime', '2005-06-16', 'Female', 'Mbale', 'static/images/default_profile.png'),
(106, '2025', 'Mercy', 'Waiswa', '2007-04-30', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(107, '2024', 'Brian', 'Opio', '2007-09-26', 'Male', 'Soroti', 'static/images/default_profile.png'),
(108, '2025', 'Brenda', 'Busingye', '2006-02-10', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(109, '2024', 'Mark', 'Musoke', '2006-05-09', 'Male', 'Soroti', 'static/images/default_profile.png'),
(110, '2024', 'Ivan', 'Kato', '2006-09-24', 'Male', 'Mbale', 'static/images/default_profile.png'),
(111, '2024', 'Rebecca', 'Opio', '2008-11-27', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(112, '2025', 'David', 'Ochieng', '2009-11-21', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(113, '2024', 'Mark', 'Aine', '2005-05-14', 'Male', 'Soroti', 'static/images/default_profile.png'),
(114, '2024', 'Pritah', 'Aine', '2007-04-03', 'Female', 'Jinja', 'static/images/default_profile.png'),
(115, '2024', 'Rebecca', 'Ssemwogerere', '2007-03-10', 'Female', 'Soroti', 'static/images/default_profile.png'),
(116, '2024', 'Rebecca', 'Opio', '2005-03-03', 'Female', 'Masaka', 'static/images/default_profile.png'),
(117, '2024', 'Brian', 'Okello', '2005-12-04', 'Male', 'Kampala', 'static/images/default_profile.png'),
(118, '2025', 'Sarah', 'Nakato', '2006-01-02', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(119, '2025', 'Mary', 'Ochieng', '2008-04-14', 'Female', 'Mbale', 'static/images/default_profile.png'),
(120, '2024', 'Mark', 'Opio', '2006-02-15', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(121, '2024', 'Ritah', 'Ssemwogerere', '2007-10-20', 'Female', 'Kampala', 'static/images/default_profile.png'),
(122, '2025', 'Joan', 'Ssemwogerere', '2008-09-28', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(123, '2024', 'Winnie', 'Akello', '2005-07-20', 'Female', 'Masaka', 'static/images/default_profile.png'),
(124, '2025', 'Daniel', 'Ochieng', '2008-12-15', 'Male', 'Kampala', 'static/images/default_profile.png'),
(125, '2025', 'Joan', 'Namukasa', '2007-02-02', 'Female', 'Soroti', 'static/images/default_profile.png'),
(126, '2024', 'Pritah', 'Byaruhanga', '2007-11-19', 'Female', 'Kampala', 'static/images/default_profile.png'),
(127, '2025', 'Alice', 'Mukasa', '2005-01-17', 'Female', 'Arua', 'static/images/default_profile.png'),
(128, '2025', 'Daniel', 'Opio', '2006-08-21', 'Male', 'Masaka', 'static/images/default_profile.png'),
(129, '2024', 'Isaac', 'Ssemwogerere', '2005-01-26', 'Male', 'Mbale', 'static/images/default_profile.png'),
(130, '2025', 'Andrew', 'Namukasa', '2008-12-03', 'Male', 'Mbale', 'static/images/default_profile.png'),
(131, '2025', 'Alice', 'Opio', '2006-07-13', 'Female', 'Kampala', 'static/images/default_profile.png'),
(132, '2025', 'Andrew', 'Aine', '2006-10-06', 'Male', 'Gulu', 'static/images/default_profile.png'),
(133, '2024', 'Andrew', 'Okello', '2005-09-29', 'Male', 'Kampala', 'static/images/default_profile.png'),
(134, '2024', 'Daniel', 'Byaruhanga', '2006-05-12', 'Male', 'Mbarara', 'static/images/default_profile.png'),
(135, '2025', 'Alice', 'Nalubega', '2008-08-28', 'Female', 'Mbale', 'static/images/default_profile.png'),
(136, '2024', 'Joseph', 'Musoke', '2009-11-30', 'Male', 'Soroti', 'static/images/default_profile.png'),
(137, '2025', 'Esther', 'Busingye', '2007-10-01', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(138, '2025', 'Mercy', 'Nantogo', '2007-01-14', 'Female', 'Gulu', 'static/images/default_profile.png'),
(139, '2025', 'Brenda', 'Namukasa', '2009-03-13', 'Female', 'Arua', 'static/images/default_profile.png'),
(140, '2024', 'Pritah', 'Okello', '2005-09-13', 'Female', 'Soroti', 'static/images/default_profile.png'),
(141, '2025', 'Brian', 'Tumusiime', '2007-03-16', 'Male', 'Jinja', 'static/images/default_profile.png'),
(142, '2025', 'Mary', 'Nalubega', '2009-12-07', 'Female', 'Masaka', 'static/images/default_profile.png'),
(143, '2024', 'Sandra', 'Lwanga', '2005-08-21', 'Female', 'Kampala', 'static/images/default_profile.png'),
(144, '2025', 'Timothy', 'Nalubega', '2007-05-14', 'Male', 'Kampala', 'static/images/default_profile.png'),
(145, '2025', 'Pritah', 'Mugabe', '2008-01-10', 'Female', 'Gulu', 'static/images/default_profile.png'),
(146, '2025', 'Brenda', 'Ochieng', '2009-11-02', 'Female', 'Mbale', 'static/images/default_profile.png'),
(147, '2024', 'Mercy', 'Nalubega', '2005-06-26', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(148, '2024', 'Sandra', 'Kyomuhendo', '2007-05-08', 'Female', 'Soroti', 'static/images/default_profile.png'),
(149, '2025', 'Joy', 'Busingye', '2005-01-05', 'Female', 'Jinja', 'static/images/default_profile.png'),
(150, '2025', 'Mary', 'Kyomuhendo', '2006-01-26', 'Female', 'Soroti', 'static/images/default_profile.png'),
(151, '2025', 'Brenda', 'Aine', '2007-09-28', 'Female', 'Kampala', 'static/images/default_profile.png'),
(152, '2024', 'Peter', 'Ssemwogerere', '2007-01-29', 'Male', 'Mbale', 'static/images/default_profile.png'),
(153, '2024', 'Brian', 'Namukasa', '2009-06-20', 'Male', 'Arua', 'static/images/default_profile.png'),
(154, '2025', 'Samuel', 'Nakato', '2006-10-28', 'Male', 'Kampala', 'static/images/default_profile.png'),
(155, '2025', 'Grace', 'Byaruhanga', '2005-11-30', 'Female', 'Jinja', 'static/images/default_profile.png'),
(156, '2024', 'Winnie', 'Aine', '2008-09-28', 'Female', 'Soroti', 'static/images/default_profile.png'),
(157, '2025', 'Timothy', 'Mukasa', '2007-12-30', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(158, '2025', 'Solomon', 'Waiswa', '2008-09-04', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(159, '2025', 'Mercy', 'Kyomuhendo', '2005-10-13', 'Female', 'Soroti', 'static/images/default_profile.png'),
(160, '2025', 'Peter', 'Akello', '2006-05-25', 'Male', 'Arua', 'static/images/default_profile.png'),
(161, '2024', 'David', 'Tumusiime', '2008-06-18', 'Male', 'Gulu', 'static/images/default_profile.png'),
(162, '2025', 'Mary', 'Byaruhanga', '2006-12-08', 'Female', 'Masaka', 'static/images/default_profile.png'),
(163, '2025', 'Grace', 'Namukasa', '2005-05-15', 'Female', 'Soroti', 'static/images/default_profile.png'),
(164, '2024', 'Peter', 'Ochieng', '2007-02-22', 'Male', 'Mbale', 'static/images/default_profile.png'),
(165, '2024', 'Peter', 'Busingye', '2008-08-26', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(166, '2025', 'Daniel', 'Waiswa', '2007-06-28', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(167, '2024', 'John', 'Akello', '2008-02-23', 'Male', 'Kampala', 'static/images/default_profile.png'),
(168, '2024', 'Brian', 'Nalubega', '2006-11-28', 'Male', 'Lira', 'static/images/default_profile.png'),
(169, '2025', 'Mary', 'Ochieng', '2008-08-25', 'Female', 'Arua', 'static/images/default_profile.png'),
(170, '2025', 'Joseph', 'Aine', '2008-07-04', 'Male', 'Mbarara', 'static/images/default_profile.png'),
(171, '2024', 'Peter', 'Mugabe', '2009-08-17', 'Male', 'Masaka', 'static/images/default_profile.png'),
(172, '2025', 'Rebecca', 'Nalubega', '2007-10-12', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(173, '2025', 'Joy', 'Byaruhanga', '2006-08-15', 'Female', 'Lira', 'static/images/default_profile.png'),
(174, '2024', 'Rebecca', 'Byaruhanga', '2009-04-22', 'Female', 'Gulu', 'static/images/default_profile.png'),
(175, '2025', 'Daniel', 'Opio', '2005-10-11', 'Male', 'Lira', 'static/images/default_profile.png'),
(176, '2025', 'Joseph', 'Kato', '2008-04-14', 'Male', 'Mbale', 'static/images/default_profile.png'),
(177, '2025', 'Doreen', 'Busingye', '2007-04-06', 'Female', 'Kampala', 'static/images/default_profile.png'),
(178, '2024', 'Solomon', 'Aine', '2007-12-26', 'Male', 'Soroti', 'static/images/default_profile.png'),
(179, '2024', 'Joy', 'Okello', '2009-05-26', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(180, '2025', 'Solomon', 'Namukasa', '2009-07-03', 'Male', 'Jinja', 'static/images/default_profile.png'),
(181, '2025', 'John', 'Busingye', '2009-05-23', 'Male', 'Jinja', 'static/images/default_profile.png'),
(182, '2025', 'Joseph', 'Tumusiime', '2008-09-30', 'Male', 'Masaka', 'static/images/default_profile.png'),
(183, '2024', 'Daniel', 'Kato', '2005-10-24', 'Male', 'Soroti', 'static/images/default_profile.png'),
(184, '2025', 'Ivan', 'Nakato', '2009-06-29', 'Male', 'Kampala', 'static/images/default_profile.png'),
(185, '2025', 'David', 'Opio', '2007-02-15', 'Male', 'Lira', 'static/images/default_profile.png'),
(186, '2025', 'Andrew', 'Busingye', '2006-05-22', 'Male', 'Masaka', 'static/images/default_profile.png'),
(187, '2025', 'Mercy', 'Musoke', '2006-04-22', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(188, '2024', 'John', 'Byaruhanga', '2007-02-05', 'Male', 'Lira', 'static/images/default_profile.png'),
(189, '2025', 'Joseph', 'Nakato', '2007-03-17', 'Male', 'Kampala', 'static/images/default_profile.png'),
(190, '2025', 'Andrew', 'Tumusiime', '2007-07-26', 'Male', 'Soroti', 'static/images/default_profile.png'),
(191, '2024', 'Isaac', 'Nantogo', '2007-09-23', 'Male', 'Lira', 'static/images/default_profile.png'),
(192, '2025', 'Peter', 'Nantogo', '2005-11-15', 'Male', 'Lira', 'static/images/default_profile.png'),
(193, '2024', 'Mary', 'Nakato', '2007-09-21', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(194, '2025', 'Grace', 'Ssemwogerere', '2007-01-07', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(195, '2025', 'Paul', 'Lwanga', '2008-09-05', 'Male', 'Jinja', 'static/images/default_profile.png'),
(196, '2025', 'Esther', 'Okello', '2006-07-08', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(197, '2025', 'Timothy', 'Lwanga', '2005-05-09', 'Male', 'Gulu', 'static/images/default_profile.png'),
(198, '2024', 'Doreen', 'Busingye', '2006-10-30', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(199, '2025', 'Ritah', 'Lwanga', '2006-06-28', 'Female', 'Masaka', 'static/images/default_profile.png'),
(200, '2024', 'Samuel', 'Akello', '2006-08-06', 'Male', 'Soroti', 'static/images/default_profile.png'),
(201, '2024', 'Esther', 'Kyomuhendo', '2008-10-26', 'Female', 'Masaka', 'static/images/default_profile.png'),
(202, '2024', 'Isaac', 'Tumusiime', '2006-05-18', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(203, '2025', 'Andrew', 'Ochieng', '2005-11-20', 'Male', 'Gulu', 'static/images/default_profile.png'),
(204, '2024', 'Andrew', 'Byaruhanga', '2008-03-16', 'Male', 'Arua', 'static/images/default_profile.png'),
(205, '2024', 'Samuel', 'Ochieng', '2006-12-27', 'Male', 'Jinja', 'static/images/default_profile.png'),
(206, '2024', 'Ritah', 'Akello', '2006-09-19', 'Female', 'Kampala', 'static/images/default_profile.png'),
(207, '2025', 'Brian', 'Byaruhanga', '2008-12-04', 'Male', 'Kampala', 'static/images/default_profile.png'),
(208, '2025', 'Grace', 'Busingye', '2009-05-08', 'Female', 'Masaka', 'static/images/default_profile.png'),
(209, '2024', 'Samuel', 'Kato', '2008-06-11', 'Male', 'Masaka', 'static/images/default_profile.png'),
(210, '2025', 'Solomon', 'Tumusiime', '2008-01-15', 'Male', 'Lira', 'static/images/default_profile.png'),
(211, '2024', 'Peter', 'Waiswa', '2006-05-11', 'Male', 'Mbarara', 'static/images/default_profile.png'),
(212, '2024', 'Esther', 'Busingye', '2008-11-28', 'Female', 'Masaka', 'static/images/default_profile.png'),
(213, '2024', 'Joan', 'Akello', '2008-05-14', 'Female', 'Kampala', 'static/images/default_profile.png'),
(214, '2025', 'Rebecca', 'Lwanga', '2006-09-01', 'Female', 'Jinja', 'static/images/default_profile.png'),
(215, '2025', 'Joy', 'Busingye', '2009-10-24', 'Female', 'Kampala', 'static/images/default_profile.png'),
(216, '2025', 'Samuel', 'Aine', '2008-12-10', 'Male', 'Mbale', 'static/images/default_profile.png'),
(217, '2025', 'Joy', 'Byaruhanga', '2007-12-12', 'Female', 'Gulu', 'static/images/default_profile.png'),
(218, '2025', 'Timothy', 'Ochieng', '2006-05-29', 'Male', 'Gulu', 'static/images/default_profile.png'),
(219, '2025', 'Moses', 'Mukasa', '2008-01-11', 'Male', 'Arua', 'static/images/default_profile.png'),
(220, '2024', 'Moses', 'Aine', '2009-12-02', 'Male', 'Jinja', 'static/images/default_profile.png'),
(221, '2024', 'Joseph', 'Tumusiime', '2009-10-27', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(222, '2024', 'Andrew', 'Byaruhanga', '2008-09-25', 'Male', 'Lira', 'static/images/default_profile.png'),
(223, '2025', 'Mary', 'Mugabe', '2006-10-13', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(224, '2024', 'Grace', 'Ochieng', '2007-12-22', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(225, '2025', 'Doreen', 'Akello', '2009-10-14', 'Female', 'Masaka', 'static/images/default_profile.png'),
(226, '2025', 'Andrew', 'Byaruhanga', '2009-08-16', 'Male', 'Soroti', 'static/images/default_profile.png'),
(227, '2024', 'Joy', 'Aine', '2009-11-07', 'Female', 'Mbale', 'static/images/default_profile.png'),
(228, '2025', 'Mary', 'Ochieng', '2008-12-18', 'Female', 'Soroti', 'static/images/default_profile.png'),
(229, '2025', 'Sarah', 'Busingye', '2006-05-01', 'Female', 'Kampala', 'static/images/default_profile.png'),
(230, '2024', 'Mary', 'Nakato', '2007-06-14', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(231, '2025', 'Solomon', 'Waiswa', '2005-02-23', 'Male', 'Lira', 'static/images/default_profile.png'),
(232, '2025', 'Paul', 'Musoke', '2005-11-06', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(233, '2024', 'Joan', 'Busingye', '2009-04-13', 'Female', 'Kampala', 'static/images/default_profile.png'),
(234, '2025', 'Peter', 'Kyomuhendo', '2007-09-17', 'Male', 'Soroti', 'static/images/default_profile.png'),
(235, '2025', 'Mercy', 'Kyomuhendo', '2005-12-08', 'Female', 'Lira', 'static/images/default_profile.png'),
(236, '2024', 'Mary', 'Nakato', '2007-10-24', 'Female', 'Masaka', 'static/images/default_profile.png'),
(237, '2024', 'Mary', 'Mukasa', '2005-10-13', 'Female', 'Arua', 'static/images/default_profile.png'),
(238, '2024', 'Solomon', 'Aine', '2007-10-19', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(239, '2024', 'Brian', 'Ssemwogerere', '2005-12-14', 'Male', 'Kampala', 'static/images/default_profile.png'),
(240, '2024', 'Ritah', 'Akello', '2006-01-02', 'Female', 'Jinja', 'static/images/default_profile.png'),
(241, '2025', 'Sandra', 'Busingye', '2007-03-06', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(242, '2025', 'Mark', 'Ochieng', '2008-01-11', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(243, '2024', 'Peter', 'Kato', '2008-05-22', 'Male', 'Arua', 'static/images/default_profile.png'),
(244, '2024', 'Ivan', 'Mukasa', '2006-10-04', 'Male', 'Mbale', 'static/images/default_profile.png'),
(245, '2024', 'Joy', 'Aine', '2006-05-23', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(246, '2024', 'Alice', 'Akello', '2009-02-17', 'Female', 'Arua', 'static/images/default_profile.png'),
(247, '2024', 'David', 'Okello', '2006-05-23', 'Male', 'Kampala', 'static/images/default_profile.png'),
(248, '2024', 'Winnie', 'Musoke', '2009-12-29', 'Female', 'Gulu', 'static/images/default_profile.png'),
(249, '2025', 'Brenda', 'Kyomuhendo', '2006-01-05', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(250, '2024', 'Doreen', 'Namukasa', '2008-10-20', 'Female', 'Masaka', 'static/images/default_profile.png'),
(251, '2025', 'Mark', 'Aine', '2005-08-28', 'Male', 'Gulu', 'static/images/default_profile.png'),
(252, '2024', 'Solomon', 'Byaruhanga', '2009-04-25', 'Male', 'Gulu', 'static/images/default_profile.png'),
(253, '2025', 'Daniel', 'Busingye', '2005-07-02', 'Male', 'Arua', 'static/images/default_profile.png'),
(254, '2024', 'Brenda', 'Waiswa', '2009-01-29', 'Female', 'Jinja', 'static/images/default_profile.png'),
(255, '2025', 'David', 'Tumusiime', '2008-07-16', 'Male', 'Gulu', 'static/images/default_profile.png'),
(256, '2025', 'Ivan', 'Musoke', '2008-05-13', 'Male', 'Soroti', 'static/images/default_profile.png'),
(257, '2025', 'Sandra', 'Nalubega', '2005-02-15', 'Female', 'Masaka', 'static/images/default_profile.png'),
(258, '2025', 'Mercy', 'Akello', '2007-05-20', 'Female', 'Arua', 'static/images/default_profile.png'),
(259, '2025', 'Moses', 'Nalubega', '2008-02-19', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(260, '2025', 'Brenda', 'Namukasa', '2008-08-16', 'Female', 'Lira', 'static/images/default_profile.png'),
(261, '2025', 'Doreen', 'Mukasa', '2005-11-21', 'Female', 'Soroti', 'static/images/default_profile.png'),
(262, '2025', 'Moses', 'Akello', '2006-04-29', 'Male', 'Soroti', 'static/images/default_profile.png'),
(263, '2024', 'Joy', 'Waiswa', '2007-05-09', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(264, '2024', 'Mary', 'Namukasa', '2006-10-02', 'Female', 'Masaka', 'static/images/default_profile.png'),
(265, '2025', 'Samuel', 'Mugabe', '2008-07-04', 'Male', 'Soroti', 'static/images/default_profile.png'),
(266, '2024', 'Paul', 'Opio', '2006-11-20', 'Male', 'Arua', 'static/images/default_profile.png'),
(267, '2024', 'Peter', 'Lwanga', '2006-01-29', 'Male', 'Mbale', 'static/images/default_profile.png'),
(268, '2024', 'Esther', 'Kyomuhendo', '2008-12-04', 'Female', 'Masaka', 'static/images/default_profile.png'),
(269, '2025', 'Sandra', 'Nakato', '2005-12-19', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(270, '2024', 'Sarah', 'Aine', '2007-11-05', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(271, '2024', 'Daniel', 'Kyomuhendo', '2009-09-22', 'Male', 'Soroti', 'static/images/default_profile.png'),
(272, '2024', 'Andrew', 'Mukasa', '2006-08-25', 'Male', 'Soroti', 'static/images/default_profile.png'),
(273, '2025', 'Sandra', 'Musoke', '2009-03-28', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(274, '2024', 'Grace', 'Opio', '2009-07-25', 'Female', 'Kampala', 'static/images/default_profile.png'),
(275, '2024', 'Grace', 'Aine', '2008-05-19', 'Female', 'Lira', 'static/images/default_profile.png'),
(276, '2024', 'Alice', 'Kyomuhendo', '2009-09-04', 'Female', 'Mbale', 'static/images/default_profile.png'),
(277, '2024', 'Doreen', 'Lwanga', '2008-10-21', 'Female', 'Masaka', 'static/images/default_profile.png'),
(278, '2024', 'John', 'Kato', '2005-01-21', 'Male', 'Lira', 'static/images/default_profile.png'),
(279, '2024', 'Solomon', 'Lwanga', '2005-07-11', 'Male', 'Jinja', 'static/images/default_profile.png'),
(280, '2025', 'Sandra', 'Lwanga', '2009-08-28', 'Female', 'Gulu', 'static/images/default_profile.png'),
(281, '2025', 'Peter', 'Namukasa', '2005-06-27', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(282, '2024', 'Doreen', 'Mukasa', '2006-08-28', 'Female', 'Arua', 'static/images/default_profile.png'),
(283, '2025', 'Winnie', 'Namukasa', '2006-02-14', 'Female', 'Mbale', 'static/images/default_profile.png'),
(284, '2024', 'Mary', 'Ochieng', '2008-07-16', 'Female', 'Arua', 'static/images/default_profile.png'),
(285, '2025', 'Ritah', 'Byaruhanga', '2005-03-29', 'Female', 'Arua', 'static/images/default_profile.png'),
(286, '2025', 'Paul', 'Waiswa', '2007-07-23', 'Male', 'Mbale', 'static/images/default_profile.png'),
(287, '2024', 'Mercy', 'Waiswa', '2007-08-01', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(288, '2024', 'Andrew', 'Ssemwogerere', '2006-06-28', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(289, '2024', 'Mercy', 'Busingye', '2009-10-03', 'Female', 'Soroti', 'static/images/default_profile.png'),
(290, '2024', 'Doreen', 'Namukasa', '2008-07-23', 'Female', 'Arua', 'static/images/default_profile.png'),
(291, '2024', 'Ritah', 'Musoke', '2005-07-11', 'Female', 'Masaka', 'static/images/default_profile.png'),
(292, '2024', 'Moses', 'Ssemwogerere', '2007-01-14', 'Male', 'Arua', 'static/images/default_profile.png'),
(293, '2024', 'Joy', 'Ochieng', '2008-02-24', 'Female', 'Arua', 'static/images/default_profile.png'),
(294, '2025', 'Brian', 'Opio', '2008-01-21', 'Male', 'Gulu', 'static/images/default_profile.png'),
(295, '2024', 'Brenda', 'Kato', '2007-02-26', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(296, '2025', 'Alice', 'Ssemwogerere', '2009-09-15', 'Female', 'Gulu', 'static/images/default_profile.png'),
(297, '2025', 'Mary', 'Busingye', '2009-11-13', 'Female', 'Masaka', 'static/images/default_profile.png'),
(298, '2025', 'Mark', 'Ochieng', '2008-03-13', 'Male', 'Masaka', 'static/images/default_profile.png'),
(299, '2024', 'Peter', 'Kyomuhendo', '2009-05-03', 'Male', 'Jinja', 'static/images/default_profile.png'),
(300, '2024', 'Esther', 'Ochieng', '2007-09-22', 'Female', 'Arua', 'static/images/default_profile.png'),
(301, '2024', 'Pritah', 'Ssemwogerere', '2006-02-05', 'Female', 'Mbale', 'static/images/default_profile.png'),
(302, '2025', 'Daniel', 'Aine', '2006-08-09', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(303, '2024', 'Paul', 'Musoke', '2007-03-08', 'Male', 'Soroti', 'static/images/default_profile.png'),
(304, '2025', 'Ivan', 'Ssemwogerere', '2005-01-22', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(305, '2025', 'Ivan', 'Namukasa', '2009-09-01', 'Male', 'Kampala', 'static/images/default_profile.png'),
(306, '2025', 'Brian', 'Nantogo', '2009-04-26', 'Male', 'Jinja', 'static/images/default_profile.png'),
(307, '2024', 'Rebecca', 'Kato', '2008-04-25', 'Female', 'Kampala', 'static/images/default_profile.png'),
(308, '2025', 'Solomon', 'Okello', '2009-12-27', 'Male', 'Lira', 'static/images/default_profile.png'),
(309, '2025', 'Solomon', 'Nakato', '2009-12-05', 'Male', 'Soroti', 'static/images/default_profile.png'),
(310, '2025', 'Rebecca', 'Ochieng', '2006-05-03', 'Female', 'Kampala', 'static/images/default_profile.png'),
(311, '2024', 'David', 'Kato', '2007-08-30', 'Male', 'Mbale', 'static/images/default_profile.png'),
(312, '2024', 'David', 'Namukasa', '2008-12-05', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(313, '2025', 'Rebecca', 'Akello', '2006-02-10', 'Female', 'Soroti', 'static/images/default_profile.png'),
(314, '2025', 'Pritah', 'Lwanga', '2005-03-05', 'Female', 'Mbale', 'static/images/default_profile.png'),
(315, '2024', 'Samuel', 'Waiswa', '2006-01-23', 'Male', 'Jinja', 'static/images/default_profile.png'),
(316, '2024', 'Solomon', 'Busingye', '2006-02-18', 'Male', 'Kampala', 'static/images/default_profile.png'),
(317, '2024', 'Mark', 'Mugabe', '2006-07-28', 'Male', 'Kampala', 'static/images/default_profile.png'),
(318, '2025', 'David', 'Opio', '2009-01-10', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(319, '2024', 'Joseph', 'Opio', '2009-04-24', 'Male', 'Mbale', 'static/images/default_profile.png'),
(320, '2024', 'Peter', 'Ssemwogerere', '2008-01-27', 'Male', 'Kampala', 'static/images/default_profile.png'),
(321, '2025', 'Esther', 'Kyomuhendo', '2009-07-25', 'Female', 'Jinja', 'static/images/default_profile.png'),
(322, '2024', 'Peter', 'Nakato', '2006-10-05', 'Male', 'Soroti', 'static/images/default_profile.png'),
(323, '2025', 'Moses', 'Namukasa', '2005-07-26', 'Male', 'Gulu', 'static/images/default_profile.png'),
(324, '2025', 'Mercy', 'Ssemwogerere', '2008-09-11', 'Female', 'Soroti', 'static/images/default_profile.png'),
(325, '2024', 'Brian', 'Ssemwogerere', '2005-12-31', 'Male', 'Gulu', 'static/images/default_profile.png'),
(326, '2025', 'Mercy', 'Mukasa', '2009-03-08', 'Female', 'Jinja', 'static/images/default_profile.png'),
(327, '2024', 'Brian', 'Kato', '2006-04-01', 'Male', 'Mbarara', 'static/images/default_profile.png'),
(328, '2025', 'Mary', 'Ssemwogerere', '2009-08-07', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(329, '2024', 'John', 'Lwanga', '2007-05-22', 'Male', 'Jinja', 'static/images/default_profile.png'),
(330, '2025', 'Pritah', 'Lwanga', '2009-12-03', 'Female', 'Lira', 'static/images/default_profile.png'),
(331, '2024', 'Isaac', 'Nakato', '2009-02-03', 'Male', 'Jinja', 'static/images/default_profile.png'),
(332, '2025', 'Sarah', 'Busingye', '2006-03-20', 'Female', 'Lira', 'static/images/default_profile.png'),
(333, '2024', 'Grace', 'Aine', '2008-09-11', 'Female', 'Mbale', 'static/images/default_profile.png'),
(334, '2024', 'Timothy', 'Lwanga', '2006-10-22', 'Male', 'Mbarara', 'static/images/default_profile.png'),
(335, '2025', 'Joy', 'Musoke', '2006-07-28', 'Female', 'Lira', 'static/images/default_profile.png'),
(336, '2024', 'Ivan', 'Tumusiime', '2007-12-25', 'Male', 'Arua', 'static/images/default_profile.png'),
(337, '2025', 'Rebecca', 'Ssemwogerere', '2007-08-11', 'Female', 'Mbale', 'static/images/default_profile.png'),
(338, '2025', 'Doreen', 'Nakato', '2005-08-22', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(339, '2024', 'Brian', 'Kyomuhendo', '2007-04-15', 'Male', 'Mbale', 'static/images/default_profile.png'),
(340, '2025', 'Brian', 'Akello', '2009-09-03', 'Male', 'Soroti', 'static/images/default_profile.png'),
(341, '2025', 'Esther', 'Aine', '2008-10-20', 'Female', 'Masaka', 'static/images/default_profile.png'),
(342, '2025', 'Mercy', 'Ssemwogerere', '2009-10-26', 'Female', 'Soroti', 'static/images/default_profile.png'),
(343, '2024', 'Isaac', 'Nakato', '2008-01-02', 'Male', 'Jinja', 'static/images/default_profile.png'),
(344, '2025', 'Mark', 'Waiswa', '2007-12-22', 'Male', 'Mbarara', 'static/images/default_profile.png'),
(345, '2025', 'Rebecca', 'Mukasa', '2008-03-16', 'Female', 'Lira', 'static/images/default_profile.png'),
(346, '2025', 'Daniel', 'Waiswa', '2007-09-17', 'Male', 'Soroti', 'static/images/default_profile.png'),
(347, '2025', 'Peter', 'Byaruhanga', '2005-04-08', 'Male', 'Mbarara', 'static/images/default_profile.png'),
(348, '2024', 'Ivan', 'Kato', '2007-02-19', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(349, '2025', 'Esther', 'Akello', '2006-12-12', 'Female', 'Soroti', 'static/images/default_profile.png'),
(350, '2025', 'Sarah', 'Mukasa', '2006-02-11', 'Female', 'Soroti', 'static/images/default_profile.png'),
(351, '2024', 'Sarah', 'Mukasa', '2006-05-24', 'Female', 'Kampala', 'static/images/default_profile.png'),
(352, '2024', 'Mark', 'Tumusiime', '2005-09-28', 'Male', 'Mbale', 'static/images/default_profile.png'),
(353, '2025', 'Sarah', 'Ssemwogerere', '2005-11-02', 'Female', 'Arua', 'static/images/default_profile.png'),
(354, '2024', 'Rebecca', 'Tumusiime', '2009-06-11', 'Female', 'Gulu', 'static/images/default_profile.png'),
(355, '2024', 'Ritah', 'Opio', '2009-12-01', 'Female', 'Mbale', 'static/images/default_profile.png'),
(356, '2025', 'Joan', 'Busingye', '2005-03-15', 'Female', 'Soroti', 'static/images/default_profile.png'),
(357, '2025', 'David', 'Okello', '2005-12-12', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(358, '2025', 'Sandra', 'Okello', '2005-12-11', 'Female', 'Jinja', 'static/images/default_profile.png'),
(359, '2025', 'Solomon', 'Nalubega', '2006-10-31', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(360, '2025', 'Joseph', 'Byaruhanga', '2005-07-30', 'Male', 'Mbarara', 'static/images/default_profile.png'),
(361, '2025', 'Peter', 'Nalubega', '2008-08-30', 'Male', 'Masaka', 'static/images/default_profile.png'),
(362, '2024', 'Joseph', 'Tumusiime', '2008-09-28', 'Male', 'Masaka', 'static/images/default_profile.png'),
(363, '2024', 'Pritah', 'Ochieng', '2005-12-03', 'Female', 'Lira', 'static/images/default_profile.png'),
(364, '2024', 'Moses', 'Nalubega', '2008-10-31', 'Male', 'Mbale', 'static/images/default_profile.png'),
(365, '2024', 'Ritah', 'Lwanga', '2005-08-20', 'Female', 'Kampala', 'static/images/default_profile.png'),
(366, '2025', 'Mercy', 'Nakato', '2008-10-22', 'Female', 'Soroti', 'static/images/default_profile.png'),
(367, '2024', 'Winnie', 'Musoke', '2005-10-05', 'Female', 'Masaka', 'static/images/default_profile.png'),
(368, '2025', 'Rebecca', 'Nalubega', '2007-07-15', 'Female', 'Mbale', 'static/images/default_profile.png'),
(369, '2024', 'Joseph', 'Lwanga', '2005-12-18', 'Male', 'Lira', 'static/images/default_profile.png'),
(370, '2025', 'Isaac', 'Kyomuhendo', '2006-01-11', 'Male', 'Mbale', 'static/images/default_profile.png'),
(371, '2024', 'Samuel', 'Lwanga', '2006-11-15', 'Male', 'Gulu', 'static/images/default_profile.png'),
(372, '2025', 'John', 'Tumusiime', '2006-03-27', 'Male', 'Gulu', 'static/images/default_profile.png'),
(373, '2024', 'Brenda', 'Lwanga', '2008-11-16', 'Female', 'Mbale', 'static/images/default_profile.png'),
(374, '2025', 'Ritah', 'Waiswa', '2006-06-26', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(375, '2024', 'Sandra', 'Waiswa', '2009-06-07', 'Female', 'Lira', 'static/images/default_profile.png'),
(376, '2024', 'Joan', 'Lwanga', '2008-02-20', 'Female', 'Masaka', 'static/images/default_profile.png'),
(377, '2024', 'Sarah', 'Namukasa', '2009-12-01', 'Female', 'Arua', 'static/images/default_profile.png'),
(378, '2025', 'Mary', 'Tumusiime', '2006-06-28', 'Female', 'Jinja', 'static/images/default_profile.png'),
(379, '2025', 'Sandra', 'Tumusiime', '2006-10-23', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(380, '2024', 'Moses', 'Byaruhanga', '2009-09-11', 'Male', 'Mbale', 'static/images/default_profile.png'),
(381, '2025', 'Timothy', 'Byaruhanga', '2009-11-24', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(382, '2025', 'Joseph', 'Mugabe', '2008-04-15', 'Male', 'Mbale', 'static/images/default_profile.png'),
(383, '2025', 'John', 'Akello', '2007-08-12', 'Male', 'Arua', 'static/images/default_profile.png'),
(384, '2024', 'Ivan', 'Nalubega', '2006-05-29', 'Male', 'Soroti', 'static/images/default_profile.png'),
(385, '2024', 'Samuel', 'Byaruhanga', '2005-09-23', 'Male', 'Lira', 'static/images/default_profile.png'),
(386, '2025', 'Paul', 'Kato', '2005-11-28', 'Male', 'Arua', 'static/images/default_profile.png'),
(387, '2025', 'Rebecca', 'Waiswa', '2005-01-26', 'Female', 'Soroti', 'static/images/default_profile.png'),
(388, '2024', 'Rebecca', 'Kyomuhendo', '2009-03-08', 'Female', 'Soroti', 'static/images/default_profile.png'),
(389, '2025', 'Daniel', 'Ochieng', '2009-01-28', 'Male', 'Gulu', 'static/images/default_profile.png'),
(390, '2025', 'Mary', 'Mukasa', '2005-09-09', 'Female', 'Arua', 'static/images/default_profile.png'),
(391, '2025', 'John', 'Nalubega', '2005-05-30', 'Male', 'Mbale', 'static/images/default_profile.png'),
(392, '2024', 'Timothy', 'Opio', '2009-03-03', 'Male', 'Lira', 'static/images/default_profile.png'),
(393, '2024', 'Joseph', 'Tumusiime', '2009-08-18', 'Male', 'Arua', 'static/images/default_profile.png'),
(394, '2024', 'Rebecca', 'Waiswa', '2005-05-12', 'Female', 'Gulu', 'static/images/default_profile.png'),
(395, '2025', 'Peter', 'Busingye', '2008-04-30', 'Male', 'Mbarara', 'static/images/default_profile.png'),
(396, '2024', 'Samuel', 'Namukasa', '2009-11-24', 'Male', 'Mbale', 'static/images/default_profile.png'),
(397, '2024', 'Joy', 'Busingye', '2009-01-14', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(398, '2025', 'Joy', 'Nakato', '2008-04-18', 'Female', 'Arua', 'static/images/default_profile.png'),
(399, '2024', 'Mercy', 'Okello', '2009-03-22', 'Female', 'Mbale', 'static/images/default_profile.png'),
(400, '2025', 'Daniel', 'Waiswa', '2008-01-03', 'Male', 'Gulu', 'static/images/default_profile.png'),
(401, '2025', 'Alice', 'Kato', '2009-06-21', 'Female', 'Kampala', 'static/images/default_profile.png'),
(402, '2025', 'Grace', 'Nalubega', '2007-02-14', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(403, '2024', 'John', 'Byaruhanga', '2007-05-23', 'Male', 'Mbale', 'static/images/default_profile.png'),
(404, '2024', 'Paul', 'Nalubega', '2009-11-06', 'Male', 'Mbarara', 'static/images/default_profile.png'),
(405, '2024', 'Esther', 'Nakato', '2006-09-03', 'Female', 'Arua', 'static/images/default_profile.png'),
(406, '2024', 'Ritah', 'Mugabe', '2008-12-08', 'Female', 'Jinja', 'static/images/default_profile.png'),
(407, '2025', 'Joan', 'Nantogo', '2006-06-02', 'Female', 'Mbale', 'static/images/default_profile.png'),
(408, '2025', 'Ivan', 'Akello', '2009-06-13', 'Male', 'Kampala', 'static/images/default_profile.png'),
(409, '2024', 'Timothy', 'Ochieng', '2007-09-01', 'Male', 'Jinja', 'static/images/default_profile.png'),
(410, '2024', 'Daniel', 'Mugabe', '2006-05-12', 'Male', 'Jinja', 'static/images/default_profile.png'),
(411, '2024', 'Joseph', 'Kyomuhendo', '2007-08-02', 'Male', 'Arua', 'static/images/default_profile.png'),
(412, '2024', 'Joan', 'Akello', '2007-08-06', 'Female', 'Jinja', 'static/images/default_profile.png'),
(413, '2025', 'Andrew', 'Tumusiime', '2008-01-25', 'Male', 'Jinja', 'static/images/default_profile.png'),
(414, '2024', 'Ivan', 'Nakato', '2009-02-18', 'Male', 'Masaka', 'static/images/default_profile.png'),
(415, '2025', 'Ritah', 'Busingye', '2008-06-21', 'Female', 'Masaka', 'static/images/default_profile.png'),
(416, '2024', 'Sandra', 'Namukasa', '2009-08-05', 'Female', 'Kampala', 'static/images/default_profile.png'),
(417, '2024', 'Isaac', 'Nakato', '2008-08-28', 'Male', 'Lira', 'static/images/default_profile.png'),
(418, '2024', 'Andrew', 'Nantogo', '2008-12-01', 'Male', 'Mbale', 'static/images/default_profile.png'),
(419, '2024', 'Grace', 'Waiswa', '2006-01-26', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(420, '2024', 'Esther', 'Musoke', '2009-10-19', 'Female', 'Masaka', 'static/images/default_profile.png'),
(421, '2025', 'Samuel', 'Byaruhanga', '2005-02-12', 'Male', 'Mbarara', 'static/images/default_profile.png'),
(422, '2025', 'Joan', 'Busingye', '2005-07-18', 'Female', 'Mbale', 'static/images/default_profile.png'),
(423, '2025', 'Paul', 'Ochieng', '2008-09-25', 'Male', 'Mbarara', 'static/images/default_profile.png'),
(424, '2024', 'Andrew', 'Akello', '2009-01-22', 'Male', 'Mbarara', 'static/images/default_profile.png'),
(425, '2024', 'Isaac', 'Busingye', '2005-01-20', 'Male', 'Jinja', 'static/images/default_profile.png'),
(426, '2024', 'Sandra', 'Waiswa', '2008-11-12', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(427, '2024', 'Timothy', 'Nantogo', '2005-12-01', 'Male', 'Arua', 'static/images/default_profile.png'),
(428, '2024', 'Esther', 'Okello', '2007-09-13', 'Female', 'Arua', 'static/images/default_profile.png'),
(429, '2025', 'Brenda', 'Kato', '2006-12-02', 'Female', 'Mbale', 'static/images/default_profile.png'),
(430, '2024', 'Paul', 'Nalubega', '2009-07-27', 'Male', 'Mbale', 'static/images/default_profile.png'),
(431, '2025', 'Mercy', 'Nantogo', '2006-09-24', 'Female', 'Soroti', 'static/images/default_profile.png'),
(432, '2024', 'Grace', 'Musoke', '2009-12-23', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(433, '2025', 'Timothy', 'Kyomuhendo', '2008-05-02', 'Male', 'Kampala', 'static/images/default_profile.png'),
(434, '2025', 'Doreen', 'Kato', '2007-10-12', 'Female', 'Arua', 'static/images/default_profile.png'),
(435, '2025', 'Sandra', 'Okello', '2005-05-13', 'Female', 'Soroti', 'static/images/default_profile.png'),
(436, '2025', 'Alice', 'Namukasa', '2008-01-22', 'Female', 'Arua', 'static/images/default_profile.png'),
(437, '2025', 'Andrew', 'Tumusiime', '2007-06-14', 'Male', 'Soroti', 'static/images/default_profile.png'),
(438, '2024', 'Daniel', 'Musoke', '2006-09-01', 'Male', 'Masaka', 'static/images/default_profile.png'),
(439, '2024', 'Esther', 'Aine', '2009-03-10', 'Female', 'Gulu', 'static/images/default_profile.png'),
(440, '2025', 'Isaac', 'Mugabe', '2009-11-05', 'Male', 'Mbale', 'static/images/default_profile.png'),
(441, '2025', 'Solomon', 'Okello', '2005-08-21', 'Male', 'Arua', 'static/images/default_profile.png'),
(442, '2025', 'David', 'Byaruhanga', '2009-04-29', 'Male', 'Lira', 'static/images/default_profile.png'),
(443, '2025', 'Joy', 'Waiswa', '2008-07-12', 'Female', 'Masaka', 'static/images/default_profile.png'),
(444, '2024', 'Doreen', 'Tumusiime', '2007-03-23', 'Female', 'Gulu', 'static/images/default_profile.png'),
(445, '2024', 'Brian', 'Ochieng', '2009-07-29', 'Male', 'Masaka', 'static/images/default_profile.png'),
(446, '2024', 'John', 'Waiswa', '2008-01-06', 'Male', 'Lira', 'static/images/default_profile.png'),
(447, '2025', 'Samuel', 'Mukasa', '2007-07-29', 'Male', 'Lira', 'static/images/default_profile.png'),
(448, '2024', 'Mark', 'Busingye', '2005-09-26', 'Male', 'Gulu', 'static/images/default_profile.png'),
(449, '2024', 'Doreen', 'Mugabe', '2006-12-29', 'Female', 'Lira', 'static/images/default_profile.png'),
(450, '2025', 'Moses', 'Tumusiime', '2009-03-14', 'Male', 'Masaka', 'static/images/default_profile.png'),
(451, '2024', 'Joseph', 'Nantogo', '2005-03-09', 'Male', 'Kampala', 'static/images/default_profile.png'),
(452, '2025', 'Joy', 'Busingye', '2005-03-07', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(453, '2025', 'David', 'Kato', '2007-05-05', 'Male', 'Kampala', 'static/images/default_profile.png'),
(454, '2025', 'Andrew', 'Mugabe', '2007-05-07', 'Male', 'Masaka', 'static/images/default_profile.png'),
(455, '2024', 'Ritah', 'Lwanga', '2005-12-25', 'Female', 'Jinja', 'static/images/default_profile.png'),
(456, '2025', 'Winnie', 'Ochieng', '2007-01-01', 'Female', 'Gulu', 'static/images/default_profile.png'),
(457, '2025', 'Brenda', 'Ssemwogerere', '2006-02-15', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(458, '2024', 'Alice', 'Byaruhanga', '2006-11-30', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(459, '2024', 'Mary', 'Akello', '2008-01-09', 'Female', 'Lira', 'static/images/default_profile.png'),
(460, '2024', 'Sandra', 'Nalubega', '2005-08-21', 'Female', 'Mbale', 'static/images/default_profile.png'),
(461, '2025', 'Peter', 'Akello', '2006-12-03', 'Male', 'Kampala', 'static/images/default_profile.png'),
(462, '2025', 'Winnie', 'Okello', '2007-01-16', 'Female', 'Gulu', 'static/images/default_profile.png'),
(463, '2024', 'Solomon', 'Aine', '2007-01-25', 'Male', 'Lira', 'static/images/default_profile.png'),
(464, '2025', 'Sarah', 'Ochieng', '2009-12-12', 'Female', 'Masaka', 'static/images/default_profile.png'),
(465, '2025', 'Daniel', 'Busingye', '2005-08-24', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(466, '2025', 'Alice', 'Ssemwogerere', '2008-07-05', 'Female', 'Kampala', 'static/images/default_profile.png'),
(467, '2025', 'Joy', 'Okello', '2009-04-20', 'Female', 'Arua', 'static/images/default_profile.png'),
(468, '2025', 'Ivan', 'Waiswa', '2009-11-21', 'Male', 'Jinja', 'static/images/default_profile.png'),
(469, '2024', 'Sarah', 'Okello', '2009-11-17', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(470, '2024', 'Joy', 'Ochieng', '2008-05-19', 'Female', 'Masaka', 'static/images/default_profile.png'),
(471, '2025', 'Sandra', 'Opio', '2008-01-10', 'Female', 'Arua', 'static/images/default_profile.png'),
(472, '2025', 'Rebecca', 'Nalubega', '2007-08-04', 'Female', 'Mbale', 'static/images/default_profile.png'),
(473, '2025', 'Winnie', 'Mugabe', '2008-09-15', 'Female', 'Soroti', 'static/images/default_profile.png'),
(474, '2025', 'Joan', 'Busingye', '2009-06-30', 'Female', 'Mbale', 'static/images/default_profile.png'),
(475, '2025', 'Sarah', 'Mugabe', '2007-11-19', 'Female', 'Arua', 'static/images/default_profile.png'),
(476, '2025', 'David', 'Kato', '2006-07-29', 'Male', 'Jinja', 'static/images/default_profile.png'),
(477, '2024', 'Timothy', 'Busingye', '2008-03-13', 'Male', 'Soroti', 'static/images/default_profile.png'),
(478, '2024', 'Doreen', 'Musoke', '2009-04-15', 'Female', 'Gulu', 'static/images/default_profile.png'),
(479, '2025', 'Winnie', 'Nalubega', '2007-10-26', 'Female', 'Soroti', 'static/images/default_profile.png'),
(480, '2024', 'Ritah', 'Ssemwogerere', '2007-06-20', 'Female', 'Masaka', 'static/images/default_profile.png'),
(481, '2024', 'Peter', 'Tumusiime', '2008-12-11', 'Male', 'Gulu', 'static/images/default_profile.png'),
(482, '2025', 'Paul', 'Kyomuhendo', '2005-07-26', 'Male', 'Mbale', 'static/images/default_profile.png'),
(483, '2025', 'Brenda', 'Ssemwogerere', '2005-09-23', 'Female', 'Kampala', 'static/images/default_profile.png');
INSERT INTO `students` (`StudentID`, `AdmissionYear`, `Name`, `Surname`, `DateOfBirth`, `Gender`, `CurrentAddress`, `PhotoPath`) VALUES
(484, '2024', 'Sarah', 'Ssemwogerere', '2006-04-10', 'Female', 'Lira', 'static/images/default_profile.png'),
(485, '2025', 'Timothy', 'Kato', '2007-10-20', 'Male', 'Arua', 'static/images/default_profile.png'),
(486, '2024', 'Joseph', 'Namukasa', '2009-12-25', 'Male', 'Lira', 'static/images/default_profile.png'),
(487, '2024', 'Ivan', 'Byaruhanga', '2008-10-19', 'Male', 'Mbale', 'static/images/default_profile.png'),
(488, '2025', 'Esther', 'Tumusiime', '2005-01-25', 'Female', 'Lira', 'static/images/default_profile.png'),
(489, '2025', 'Alice', 'Nalubega', '2009-04-19', 'Female', 'Soroti', 'static/images/default_profile.png'),
(490, '2024', 'Mary', 'Aine', '2005-12-18', 'Female', 'Soroti', 'static/images/default_profile.png'),
(491, '2024', 'Andrew', 'Opio', '2007-08-27', 'Male', 'Lira', 'static/images/default_profile.png'),
(492, '2025', 'Mercy', 'Kato', '2006-01-24', 'Female', 'Gulu', 'static/images/default_profile.png'),
(493, '2024', 'Doreen', 'Musoke', '2007-08-30', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(494, '2025', 'Rebecca', 'Nantogo', '2005-04-21', 'Female', 'Kampala', 'static/images/default_profile.png'),
(495, '2025', 'Brenda', 'Aine', '2008-01-09', 'Female', 'Mbale', 'static/images/default_profile.png'),
(496, '2024', 'Peter', 'Ssemwogerere', '2006-10-16', 'Male', 'Lira', 'static/images/default_profile.png'),
(497, '2024', 'Mark', 'Tumusiime', '2006-04-19', 'Male', 'Soroti', 'static/images/default_profile.png'),
(498, '2025', 'Brenda', 'Ssemwogerere', '2006-07-15', 'Female', 'Masaka', 'static/images/default_profile.png'),
(499, '2024', 'Daniel', 'Aine', '2006-01-11', 'Male', 'Gulu', 'static/images/default_profile.png'),
(500, '2025', 'Paul', 'Akello', '2008-06-06', 'Male', 'Kampala', 'static/images/default_profile.png'),
(501, '2024', 'Timothy', 'Mugabe', '2008-08-21', 'Male', 'Mbarara', 'static/images/default_profile.png'),
(502, '2024', 'Brenda', 'Kato', '2006-10-26', 'Female', 'Gulu', 'static/images/default_profile.png'),
(503, '2025', 'Joseph', 'Opio', '2009-09-27', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(504, '2024', 'Isaac', 'Nantogo', '2007-12-03', 'Male', 'Gulu', 'static/images/default_profile.png'),
(505, '2025', 'Brenda', 'Mukasa', '2005-11-05', 'Female', 'Mbale', 'static/images/default_profile.png'),
(506, '2024', 'Mercy', 'Akello', '2008-03-31', 'Female', 'Jinja', 'static/images/default_profile.png'),
(507, '2025', 'Sarah', 'Nalubega', '2005-09-28', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(508, '2024', 'Doreen', 'Okello', '2005-06-23', 'Female', 'Jinja', 'static/images/default_profile.png'),
(509, '2024', 'Brian', 'Aine', '2008-03-10', 'Male', 'Mbale', 'static/images/default_profile.png'),
(510, '2025', 'John', 'Nantogo', '2006-09-06', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(511, '2024', 'Doreen', 'Ssemwogerere', '2005-05-30', 'Female', 'Jinja', 'static/images/default_profile.png'),
(512, '2024', 'Mercy', 'Waiswa', '2007-03-15', 'Female', 'Jinja', 'static/images/default_profile.png'),
(513, '2024', 'Andrew', 'Akello', '2009-07-15', 'Male', 'Soroti', 'static/images/default_profile.png'),
(514, '2024', 'Mary', 'Musoke', '2007-01-05', 'Female', 'Lira', 'static/images/default_profile.png'),
(515, '2025', 'Ivan', 'Lwanga', '2009-05-03', 'Male', 'Lira', 'static/images/default_profile.png'),
(516, '2024', 'Mark', 'Nakato', '2007-10-21', 'Male', 'Jinja', 'static/images/default_profile.png'),
(517, '2024', 'John', 'Namukasa', '2008-05-10', 'Male', 'Gulu', 'static/images/default_profile.png'),
(518, '2025', 'Winnie', 'Namukasa', '2006-04-02', 'Female', 'Mbale', 'static/images/default_profile.png'),
(519, '2024', 'John', 'Tumusiime', '2006-05-23', 'Male', 'Mbale', 'static/images/default_profile.png'),
(520, '2025', 'Andrew', 'Nakato', '2009-08-28', 'Male', 'Kampala', 'static/images/default_profile.png'),
(521, '2024', 'Sandra', 'Ssemwogerere', '2009-10-22', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(522, '2025', 'Sandra', 'Mugabe', '2007-02-12', 'Female', 'Masaka', 'static/images/default_profile.png'),
(523, '2024', 'Timothy', 'Mukasa', '2008-10-13', 'Male', 'Mbarara', 'static/images/default_profile.png'),
(524, '2024', 'Isaac', 'Opio', '2006-05-18', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(525, '2024', 'Ritah', 'Mugabe', '2005-02-23', 'Female', 'Jinja', 'static/images/default_profile.png'),
(526, '2025', 'John', 'Tumusiime', '2006-05-09', 'Male', 'Gulu', 'static/images/default_profile.png'),
(527, '2025', 'Daniel', 'Lwanga', '2007-12-20', 'Male', 'Kampala', 'static/images/default_profile.png'),
(528, '2024', 'Ritah', 'Opio', '2009-04-24', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(529, '2025', 'Mercy', 'Busingye', '2009-11-28', 'Female', 'Lira', 'static/images/default_profile.png'),
(530, '2025', 'Mary', 'Byaruhanga', '2007-04-21', 'Female', 'Gulu', 'static/images/default_profile.png'),
(531, '2024', 'Andrew', 'Kato', '2007-12-14', 'Male', 'Gulu', 'static/images/default_profile.png'),
(532, '2025', 'Mark', 'Waiswa', '2007-01-22', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(533, '2025', 'Grace', 'Waiswa', '2005-04-18', 'Female', 'Soroti', 'static/images/default_profile.png'),
(534, '2025', 'Joy', 'Opio', '2006-02-23', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(535, '2025', 'Alice', 'Nalubega', '2009-09-10', 'Female', 'Gulu', 'static/images/default_profile.png'),
(536, '2025', 'Andrew', 'Nalubega', '2005-10-24', 'Male', 'Gulu', 'static/images/default_profile.png'),
(537, '2024', 'Alice', 'Akello', '2008-05-13', 'Female', 'Soroti', 'static/images/default_profile.png'),
(538, '2024', 'Ritah', 'Busingye', '2007-11-04', 'Female', 'Mbale', 'static/images/default_profile.png'),
(539, '2024', 'Brian', 'Nakato', '2005-05-10', 'Male', 'Mbarara', 'static/images/default_profile.png'),
(540, '2024', 'Peter', 'Opio', '2009-07-28', 'Male', 'Masaka', 'static/images/default_profile.png'),
(541, '2024', 'Ritah', 'Opio', '2005-07-12', 'Female', 'Masaka', 'static/images/default_profile.png'),
(542, '2024', 'Joan', 'Busingye', '2005-02-09', 'Female', 'Masaka', 'static/images/default_profile.png'),
(543, '2025', 'Isaac', 'Nantogo', '2006-11-18', 'Male', 'Mbale', 'static/images/default_profile.png'),
(544, '2025', 'Joseph', 'Kyomuhendo', '2007-11-18', 'Male', 'Soroti', 'static/images/default_profile.png'),
(545, '2024', 'Ritah', 'Mugabe', '2009-08-07', 'Female', 'Soroti', 'static/images/default_profile.png'),
(546, '2024', 'Joan', 'Nantogo', '2007-10-01', 'Female', 'Jinja', 'static/images/default_profile.png'),
(547, '2025', 'Doreen', 'Ochieng', '2005-05-29', 'Female', 'Jinja', 'static/images/default_profile.png'),
(548, '2024', 'John', 'Byaruhanga', '2005-12-18', 'Male', 'Lira', 'static/images/default_profile.png'),
(549, '2025', 'David', 'Byaruhanga', '2008-01-22', 'Male', 'Soroti', 'static/images/default_profile.png'),
(550, '2024', 'Mercy', 'Lwanga', '2007-12-12', 'Female', 'Kampala', 'static/images/default_profile.png'),
(551, '2025', 'Ivan', 'Ochieng', '2009-11-18', 'Male', 'Mbarara', 'static/images/default_profile.png'),
(552, '2025', 'Mary', 'Namukasa', '2007-04-28', 'Female', 'Mbale', 'static/images/default_profile.png'),
(553, '2024', 'Joan', 'Aine', '2005-03-07', 'Female', 'Soroti', 'static/images/default_profile.png'),
(554, '2025', 'Esther', 'Musoke', '2009-12-03', 'Female', 'Soroti', 'static/images/default_profile.png'),
(555, '2024', 'Mark', 'Aine', '2009-08-26', 'Male', 'Mbale', 'static/images/default_profile.png'),
(556, '2025', 'Joy', 'Mukasa', '2005-03-30', 'Female', 'Arua', 'static/images/default_profile.png'),
(557, '2024', 'Moses', 'Musoke', '2005-09-13', 'Male', 'Gulu', 'static/images/default_profile.png'),
(558, '2024', 'Winnie', 'Nakato', '2006-02-06', 'Female', 'Mbale', 'static/images/default_profile.png'),
(559, '2024', 'Esther', 'Akello', '2006-08-02', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(560, '2024', 'David', 'Kyomuhendo', '2006-04-06', 'Male', 'Kampala', 'static/images/default_profile.png'),
(561, '2024', 'Samuel', 'Mukasa', '2008-01-25', 'Male', 'Jinja', 'static/images/default_profile.png'),
(562, '2024', 'Joan', 'Okello', '2008-06-29', 'Female', 'Mbale', 'static/images/default_profile.png'),
(563, '2025', 'Ritah', 'Akello', '2005-09-29', 'Female', 'Gulu', 'static/images/default_profile.png'),
(564, '2025', 'Ritah', 'Aine', '2008-05-21', 'Female', 'Masaka', 'static/images/default_profile.png'),
(565, '2025', 'Samuel', 'Busingye', '2009-01-06', 'Male', 'Mbale', 'static/images/default_profile.png'),
(566, '2024', 'Sarah', 'Nakato', '2005-07-18', 'Female', 'Gulu', 'static/images/default_profile.png'),
(567, '2024', 'Pritah', 'Okello', '2005-10-19', 'Female', 'Soroti', 'static/images/default_profile.png'),
(568, '2025', 'Joseph', 'Tumusiime', '2009-04-24', 'Male', 'Mbale', 'static/images/default_profile.png'),
(569, '2024', 'Brenda', 'Okello', '2005-10-16', 'Female', 'Kampala', 'static/images/default_profile.png'),
(570, '2024', 'Sarah', 'Aine', '2006-12-01', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(571, '2025', 'Mercy', 'Akello', '2008-10-02', 'Female', 'Soroti', 'static/images/default_profile.png'),
(572, '2024', 'Sandra', 'Byaruhanga', '2008-07-08', 'Female', 'Kampala', 'static/images/default_profile.png'),
(573, '2024', 'Doreen', 'Mugabe', '2007-11-06', 'Female', 'Masaka', 'static/images/default_profile.png'),
(574, '2024', 'John', 'Lwanga', '2007-01-02', 'Male', 'Lira', 'static/images/default_profile.png'),
(575, '2024', 'Sarah', 'Busingye', '2006-12-21', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(576, '2025', 'Daniel', 'Ochieng', '2009-02-02', 'Male', 'Gulu', 'static/images/default_profile.png'),
(577, '2024', 'Joan', 'Namukasa', '2007-03-06', 'Female', 'Soroti', 'static/images/default_profile.png'),
(578, '2025', 'Samuel', 'Akello', '2007-01-18', 'Male', 'Mbale', 'static/images/default_profile.png'),
(579, '2024', 'Esther', 'Byaruhanga', '2005-04-13', 'Female', 'Gulu', 'static/images/default_profile.png'),
(580, '2024', 'Pritah', 'Tumusiime', '2008-05-12', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(581, '2024', 'Daniel', 'Okello', '2009-03-22', 'Male', 'Jinja', 'static/images/default_profile.png'),
(582, '2024', 'Solomon', 'Musoke', '2008-06-02', 'Male', 'Jinja', 'static/images/default_profile.png'),
(583, '2025', 'Isaac', 'Namukasa', '2007-07-08', 'Male', 'Soroti', 'static/images/default_profile.png'),
(584, '2025', 'Sandra', 'Mugabe', '2007-10-31', 'Female', 'Jinja', 'static/images/default_profile.png'),
(585, '2025', 'Brian', 'Nantogo', '2009-04-11', 'Male', 'Mbale', 'static/images/default_profile.png'),
(586, '2024', 'Sandra', 'Tumusiime', '2008-07-04', 'Female', 'Lira', 'static/images/default_profile.png'),
(587, '2024', 'Solomon', 'Kato', '2006-08-31', 'Male', 'Arua', 'static/images/default_profile.png'),
(588, '2025', 'Timothy', 'Waiswa', '2005-11-02', 'Male', 'Arua', 'static/images/default_profile.png'),
(589, '2025', 'Mercy', 'Namukasa', '2008-02-12', 'Female', 'Gulu', 'static/images/default_profile.png'),
(590, '2025', 'David', 'Mukasa', '2007-05-14', 'Male', 'Lira', 'static/images/default_profile.png'),
(591, '2024', 'Ritah', 'Namukasa', '2006-01-15', 'Female', 'Jinja', 'static/images/default_profile.png'),
(592, '2024', 'Mary', 'Aine', '2005-11-23', 'Female', 'Masaka', 'static/images/default_profile.png'),
(593, '2024', 'Doreen', 'Tumusiime', '2008-01-04', 'Female', 'Soroti', 'static/images/default_profile.png'),
(594, '2024', 'Sarah', 'Musoke', '2007-11-20', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(595, '2025', 'Sarah', 'Aine', '2007-06-07', 'Female', 'Gulu', 'static/images/default_profile.png'),
(596, '2024', 'Ritah', 'Musoke', '2009-08-16', 'Female', 'Lira', 'static/images/default_profile.png'),
(597, '2025', 'Ivan', 'Lwanga', '2009-05-21', 'Male', 'Lira', 'static/images/default_profile.png'),
(598, '2025', 'Joseph', 'Ochieng', '2006-10-28', 'Male', 'Masaka', 'static/images/default_profile.png'),
(599, '2025', 'Joy', 'Ssemwogerere', '2008-12-26', 'Female', 'Jinja', 'static/images/default_profile.png'),
(600, '2024', 'Mary', 'Kato', '2005-02-19', 'Female', 'Gulu', 'static/images/default_profile.png'),
(601, '2024', 'Mercy', 'Namukasa', '2008-06-13', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(602, '2025', 'Mercy', 'Ochieng', '2009-01-07', 'Female', 'Gulu', 'static/images/default_profile.png'),
(603, '2025', 'Isaac', 'Ssemwogerere', '2008-05-14', 'Male', 'Masaka', 'static/images/default_profile.png'),
(604, '2025', 'Moses', 'Nakato', '2007-04-03', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(605, '2024', 'Pritah', 'Aine', '2008-01-31', 'Female', 'Kampala', 'static/images/default_profile.png'),
(606, '2025', 'Ivan', 'Aine', '2006-07-28', 'Male', 'Gulu', 'static/images/default_profile.png'),
(607, '2025', 'Brian', 'Kyomuhendo', '2006-06-18', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(608, '2025', 'Daniel', 'Mugabe', '2005-10-08', 'Male', 'Soroti', 'static/images/default_profile.png'),
(609, '2024', 'Esther', 'Nalubega', '2007-01-21', 'Female', 'Kampala', 'static/images/default_profile.png'),
(610, '2025', 'Rebecca', 'Busingye', '2009-04-02', 'Female', 'Soroti', 'static/images/default_profile.png'),
(611, '2024', 'Andrew', 'Akello', '2009-09-08', 'Male', 'Kampala', 'static/images/default_profile.png'),
(612, '2024', 'Brian', 'Opio', '2008-02-13', 'Male', 'Gulu', 'static/images/default_profile.png'),
(613, '2024', 'Pritah', 'Nantogo', '2008-12-03', 'Female', 'Kampala', 'static/images/default_profile.png'),
(614, '2025', 'Sarah', 'Okello', '2006-07-17', 'Female', 'Gulu', 'static/images/default_profile.png'),
(615, '2025', 'Isaac', 'Tumusiime', '2006-04-13', 'Male', 'Arua', 'static/images/default_profile.png'),
(616, '2025', 'Pritah', 'Namukasa', '2009-09-13', 'Female', 'Masaka', 'static/images/default_profile.png'),
(617, '2025', 'Joseph', 'Namukasa', '2006-10-02', 'Male', 'Arua', 'static/images/default_profile.png'),
(618, '2025', 'Alice', 'Mugabe', '2006-09-02', 'Female', 'Kampala', 'static/images/default_profile.png'),
(619, '2025', 'Solomon', 'Nantogo', '2009-03-21', 'Male', 'Gulu', 'static/images/default_profile.png'),
(620, '2024', 'John', 'Okello', '2008-09-06', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(621, '2025', 'Mary', 'Lwanga', '2008-02-28', 'Female', 'Kampala', 'static/images/default_profile.png'),
(622, '2024', 'Mark', 'Aine', '2005-08-25', 'Male', 'Gulu', 'static/images/default_profile.png'),
(623, '2024', 'Rebecca', 'Kato', '2009-03-26', 'Female', 'Lira', 'static/images/default_profile.png'),
(624, '2025', 'Brian', 'Ochieng', '2009-12-19', 'Male', 'Gulu', 'static/images/default_profile.png'),
(625, '2024', 'Joan', 'Busingye', '2009-05-31', 'Female', 'Gulu', 'static/images/default_profile.png'),
(626, '2024', 'Joy', 'Mukasa', '2005-01-09', 'Female', 'Jinja', 'static/images/default_profile.png'),
(627, '2025', 'Joseph', 'Namukasa', '2005-03-10', 'Male', 'Gulu', 'static/images/default_profile.png'),
(628, '2024', 'David', 'Byaruhanga', '2008-09-17', 'Male', 'Jinja', 'static/images/default_profile.png'),
(629, '2024', 'Samuel', 'Ochieng', '2006-10-18', 'Male', 'Kampala', 'static/images/default_profile.png'),
(630, '2024', 'Grace', 'Mugabe', '2005-02-01', 'Female', 'Arua', 'static/images/default_profile.png'),
(631, '2025', 'Isaac', 'Mugabe', '2005-02-25', 'Male', 'Arua', 'static/images/default_profile.png'),
(632, '2024', 'Ritah', 'Mukasa', '2008-02-24', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(633, '2024', 'Mary', 'Waiswa', '2007-02-20', 'Female', 'Kampala', 'static/images/default_profile.png'),
(634, '2024', 'Esther', 'Mukasa', '2007-07-06', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(635, '2025', 'Esther', 'Ochieng', '2007-07-05', 'Female', 'Jinja', 'static/images/default_profile.png'),
(636, '2025', 'Esther', 'Aine', '2009-05-01', 'Female', 'Gulu', 'static/images/default_profile.png'),
(637, '2025', 'Ivan', 'Mukasa', '2006-01-08', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(638, '2024', 'Esther', 'Ochieng', '2006-05-31', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(639, '2025', 'Sarah', 'Lwanga', '2008-11-24', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(640, '2024', 'Moses', 'Byaruhanga', '2005-03-23', 'Male', 'Masaka', 'static/images/default_profile.png'),
(641, '2024', 'Brenda', 'Namukasa', '2009-02-14', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(642, '2025', 'Alice', 'Nalubega', '2008-10-12', 'Female', 'Jinja', 'static/images/default_profile.png'),
(643, '2024', 'Daniel', 'Nalubega', '2005-01-20', 'Male', 'Kampala', 'static/images/default_profile.png'),
(644, '2024', 'Brenda', 'Kyomuhendo', '2007-03-11', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(645, '2024', 'Mark', 'Byaruhanga', '2007-11-19', 'Male', 'Jinja', 'static/images/default_profile.png'),
(646, '2025', 'Mark', 'Okello', '2008-05-07', 'Male', 'Soroti', 'static/images/default_profile.png'),
(647, '2024', 'Joy', 'Musoke', '2006-12-24', 'Female', 'Mbale', 'static/images/default_profile.png'),
(648, '2024', 'Joseph', 'Okello', '2007-10-23', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(649, '2024', 'Solomon', 'Nantogo', '2009-06-13', 'Male', 'Mbale', 'static/images/default_profile.png'),
(650, '2024', 'Esther', 'Akello', '2007-06-20', 'Female', 'Mbale', 'static/images/default_profile.png'),
(651, '2024', 'Solomon', 'Waiswa', '2009-02-12', 'Male', 'Kampala', 'static/images/default_profile.png'),
(652, '2024', 'Daniel', 'Tumusiime', '2005-02-22', 'Male', 'Jinja', 'static/images/default_profile.png'),
(653, '2025', 'Esther', 'Musoke', '2009-05-10', 'Female', 'Jinja', 'static/images/default_profile.png'),
(654, '2025', 'Solomon', 'Waiswa', '2009-02-19', 'Male', 'Kampala', 'static/images/default_profile.png'),
(655, '2025', 'Isaac', 'Namukasa', '2007-03-03', 'Male', 'Arua', 'static/images/default_profile.png'),
(656, '2024', 'Brenda', 'Kato', '2007-09-25', 'Female', 'Lira', 'static/images/default_profile.png'),
(657, '2024', 'Ivan', 'Nantogo', '2009-12-11', 'Male', 'Jinja', 'static/images/default_profile.png'),
(658, '2024', 'Solomon', 'Busingye', '2006-02-21', 'Male', 'Gulu', 'static/images/default_profile.png'),
(659, '2024', 'Sandra', 'Mugabe', '2007-08-30', 'Female', 'Gulu', 'static/images/default_profile.png'),
(660, '2025', 'Winnie', 'Kyomuhendo', '2008-11-24', 'Female', 'Lira', 'static/images/default_profile.png'),
(661, '2025', 'Daniel', 'Kyomuhendo', '2005-09-04', 'Male', 'Masaka', 'static/images/default_profile.png'),
(662, '2024', 'Grace', 'Byaruhanga', '2005-10-01', 'Female', 'Gulu', 'static/images/default_profile.png'),
(663, '2025', 'Mark', 'Lwanga', '2008-01-13', 'Male', 'Arua', 'static/images/default_profile.png'),
(664, '2024', 'Joseph', 'Musoke', '2005-04-23', 'Male', 'Gulu', 'static/images/default_profile.png'),
(665, '2024', 'Joseph', 'Busingye', '2007-10-24', 'Male', 'Masaka', 'static/images/default_profile.png'),
(666, '2025', 'Isaac', 'Musoke', '2006-02-21', 'Male', 'Mbarara', 'static/images/default_profile.png'),
(667, '2025', 'Grace', 'Akello', '2006-03-15', 'Female', 'Masaka', 'static/images/default_profile.png'),
(668, '2024', 'Mercy', 'Ssemwogerere', '2009-04-07', 'Female', 'Jinja', 'static/images/default_profile.png'),
(669, '2024', 'Isaac', 'Namukasa', '2006-08-27', 'Male', 'Kampala', 'static/images/default_profile.png'),
(670, '2025', 'Sandra', 'Mugabe', '2007-10-29', 'Female', 'Mbale', 'static/images/default_profile.png'),
(671, '2024', 'Samuel', 'Byaruhanga', '2005-03-22', 'Male', 'Arua', 'static/images/default_profile.png'),
(672, '2025', 'Brian', 'Ochieng', '2009-05-29', 'Male', 'Arua', 'static/images/default_profile.png'),
(673, '2024', 'Brenda', 'Akello', '2005-04-08', 'Female', 'Arua', 'static/images/default_profile.png'),
(674, '2024', 'Doreen', 'Lwanga', '2009-05-12', 'Female', 'Mbale', 'static/images/default_profile.png'),
(675, '2025', 'Brenda', 'Namukasa', '2005-03-01', 'Female', 'Jinja', 'static/images/default_profile.png'),
(676, '2025', 'Solomon', 'Namukasa', '2008-11-23', 'Male', 'Soroti', 'static/images/default_profile.png'),
(677, '2025', 'Brian', 'Aine', '2007-10-12', 'Male', 'Soroti', 'static/images/default_profile.png'),
(678, '2024', 'Brenda', 'Ssemwogerere', '2006-07-21', 'Female', 'Masaka', 'static/images/default_profile.png'),
(679, '2024', 'Rebecca', 'Nantogo', '2009-12-07', 'Female', 'Masaka', 'static/images/default_profile.png'),
(680, '2024', 'Moses', 'Nalubega', '2007-06-05', 'Male', 'Lira', 'static/images/default_profile.png'),
(681, '2025', 'Ritah', 'Byaruhanga', '2009-12-25', 'Female', 'Jinja', 'static/images/default_profile.png'),
(682, '2024', 'Solomon', 'Nalubega', '2005-11-07', 'Male', 'Masaka', 'static/images/default_profile.png'),
(683, '2025', 'Ivan', 'Mukasa', '2005-11-22', 'Male', 'Mbarara', 'static/images/default_profile.png'),
(684, '2024', 'Alice', 'Aine', '2005-02-09', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(685, '2025', 'Isaac', 'Kyomuhendo', '2005-01-16', 'Male', 'Jinja', 'static/images/default_profile.png'),
(686, '2024', 'Moses', 'Lwanga', '2005-12-09', 'Male', 'Arua', 'static/images/default_profile.png'),
(687, '2025', 'Alice', 'Nalubega', '2005-02-16', 'Female', 'Arua', 'static/images/default_profile.png'),
(688, '2025', 'Mercy', 'Busingye', '2009-09-29', 'Female', 'Lira', 'static/images/default_profile.png'),
(689, '2025', 'Isaac', 'Aine', '2005-07-04', 'Male', 'Soroti', 'static/images/default_profile.png'),
(690, '2024', 'Sandra', 'Ssemwogerere', '2005-07-12', 'Female', 'Kampala', 'static/images/default_profile.png'),
(691, '2025', 'Daniel', 'Aine', '2005-01-02', 'Male', 'Gulu', 'static/images/default_profile.png'),
(692, '2025', 'Sandra', 'Mugabe', '2008-07-05', 'Female', 'Lira', 'static/images/default_profile.png'),
(693, '2025', 'Joan', 'Nalubega', '2009-05-18', 'Female', 'Kampala', 'static/images/default_profile.png'),
(694, '2025', 'Alice', 'Waiswa', '2007-07-11', 'Female', 'Kampala', 'static/images/default_profile.png'),
(695, '2025', 'John', 'Opio', '2006-01-15', 'Male', 'Kampala', 'static/images/default_profile.png'),
(696, '2025', 'Rebecca', 'Namukasa', '2006-01-17', 'Female', 'Masaka', 'static/images/default_profile.png'),
(697, '2024', 'Pritah', 'Waiswa', '2009-06-25', 'Female', 'Arua', 'static/images/default_profile.png'),
(698, '2024', 'David', 'Kato', '2006-12-09', 'Male', 'Fort Portal', 'static/images/default_profile.png'),
(699, '2025', 'Esther', 'Nalubega', '2007-05-08', 'Female', 'Jinja', 'static/images/default_profile.png'),
(700, '2025', 'Mark', 'Aine', '2009-12-21', 'Male', 'Arua', 'static/images/default_profile.png'),
(701, '2025', 'Joy', 'Nakato', '2007-12-24', 'Female', 'Jinja', 'static/images/default_profile.png'),
(702, '2024', 'Alice', 'Musoke', '2005-11-22', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(703, '2024', 'Joy', 'Okello', '2009-01-12', 'Female', 'Jinja', 'static/images/default_profile.png'),
(704, '2024', 'Mark', 'Lwanga', '2007-08-16', 'Male', 'Gulu', 'static/images/default_profile.png'),
(705, '2024', 'John', 'Lwanga', '2008-05-07', 'Male', 'Gulu', 'static/images/default_profile.png'),
(706, '2024', 'Alice', 'Waiswa', '2008-04-05', 'Female', 'Masaka', 'static/images/default_profile.png'),
(707, '2024', 'Joy', 'Nantogo', '2007-05-01', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(708, '2024', 'Joseph', 'Kato', '2008-03-30', 'Male', 'Gulu', 'static/images/default_profile.png'),
(709, '2025', 'Isaac', 'Busingye', '2005-09-03', 'Male', 'Soroti', 'static/images/default_profile.png'),
(710, '2024', 'Sandra', 'Nantogo', '2008-03-04', 'Female', 'Masaka', 'static/images/default_profile.png'),
(711, '2025', 'Peter', 'Nakato', '2007-07-16', 'Male', 'Arua', 'static/images/default_profile.png'),
(712, '2024', 'David', 'Busingye', '2007-02-16', 'Male', 'Soroti', 'static/images/default_profile.png'),
(713, '2024', 'Sandra', 'Lwanga', '2009-07-08', 'Female', 'Lira', 'static/images/default_profile.png'),
(714, '2024', 'Isaac', 'Byaruhanga', '2007-06-11', 'Male', 'Masaka', 'static/images/default_profile.png'),
(715, '2025', 'Sandra', 'Tumusiime', '2008-01-09', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(716, '2025', 'Ritah', 'Tumusiime', '2009-12-03', 'Female', 'Gulu', 'static/images/default_profile.png'),
(717, '2025', 'Alice', 'Nalubega', '2005-03-24', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(718, '2024', 'Winnie', 'Okello', '2007-06-17', 'Female', 'Arua', 'static/images/default_profile.png'),
(719, '2025', 'Winnie', 'Nantogo', '2005-12-29', 'Female', 'Kampala', 'static/images/default_profile.png'),
(720, '2024', 'Joseph', 'Musoke', '2009-02-12', 'Male', 'Kampala', 'static/images/default_profile.png'),
(721, '2024', 'Sandra', 'Kyomuhendo', '2006-12-24', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(722, '2025', 'Timothy', 'Mugabe', '2009-03-26', 'Male', 'Lira', 'static/images/default_profile.png'),
(723, '2024', 'Winnie', 'Kato', '2008-02-05', 'Female', 'Mbale', 'static/images/default_profile.png'),
(724, '2024', 'Moses', 'Mukasa', '2008-07-18', 'Male', 'Kampala', 'static/images/default_profile.png'),
(725, '2024', 'Joy', 'Ssemwogerere', '2005-02-12', 'Female', 'Jinja', 'static/images/default_profile.png'),
(726, '2025', 'Doreen', 'Lwanga', '2009-10-10', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(727, '2024', 'Alice', 'Ssemwogerere', '2008-07-28', 'Female', 'Gulu', 'static/images/default_profile.png'),
(728, '2025', 'Solomon', 'Ochieng', '2006-03-20', 'Male', 'Kampala', 'static/images/default_profile.png'),
(729, '2024', 'Brenda', 'Nakato', '2005-01-23', 'Female', 'Jinja', 'static/images/default_profile.png'),
(730, '2025', 'Solomon', 'Mugabe', '2008-03-09', 'Male', 'Kampala', 'static/images/default_profile.png'),
(731, '2025', 'Ivan', 'Kato', '2006-02-11', 'Male', 'Masaka', 'static/images/default_profile.png'),
(732, '2024', 'Brian', 'Opio', '2008-07-12', 'Male', 'Arua', 'static/images/default_profile.png'),
(733, '2024', 'Daniel', 'Nantogo', '2008-03-30', 'Male', 'Mbale', 'static/images/default_profile.png'),
(734, '2025', 'Isaac', 'Ssemwogerere', '2008-08-17', 'Male', 'Kampala', 'static/images/default_profile.png'),
(735, '2024', 'Sandra', 'Busingye', '2006-07-30', 'Female', 'Gulu', 'static/images/default_profile.png'),
(736, '2025', 'Paul', 'Kato', '2005-02-13', 'Male', 'Soroti', 'static/images/default_profile.png'),
(737, '2025', 'Mercy', 'Aine', '2005-09-30', 'Female', 'Soroti', 'static/images/default_profile.png'),
(738, '2025', 'Sandra', 'Busingye', '2007-02-07', 'Female', 'Arua', 'static/images/default_profile.png'),
(739, '2025', 'Moses', 'Nantogo', '2009-12-08', 'Male', 'Arua', 'static/images/default_profile.png'),
(740, '2025', 'Timothy', 'Namukasa', '2006-01-25', 'Male', 'Masaka', 'static/images/default_profile.png'),
(741, '2025', 'Sarah', 'Lwanga', '2009-11-29', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(742, '2025', 'Ritah', 'Ssemwogerere', '2008-03-28', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(743, '2025', 'Brenda', 'Ochieng', '2006-07-05', 'Female', 'Masaka', 'static/images/default_profile.png'),
(744, '2025', 'Mark', 'Okello', '2008-08-24', 'Male', 'Gulu', 'static/images/default_profile.png'),
(745, '2025', 'Peter', 'Namukasa', '2005-01-08', 'Male', 'Gulu', 'static/images/default_profile.png'),
(746, '2024', 'Mark', 'Nalubega', '2005-06-27', 'Male', 'Lira', 'static/images/default_profile.png'),
(747, '2024', 'Moses', 'Akello', '2007-01-28', 'Male', 'Arua', 'static/images/default_profile.png'),
(748, '2025', 'Ivan', 'Ssemwogerere', '2006-11-05', 'Male', 'Mbale', 'static/images/default_profile.png'),
(749, '2025', 'John', 'Nakato', '2008-05-14', 'Male', 'Mbale', 'static/images/default_profile.png'),
(750, '2024', 'Pritah', 'Ssemwogerere', '2005-05-27', 'Female', 'Arua', 'static/images/default_profile.png'),
(751, '2024', 'Sarah', 'Kato', '2006-05-07', 'Female', 'Gulu', 'static/images/default_profile.png'),
(752, '2024', 'Ritah', 'Kyomuhendo', '2007-12-20', 'Female', 'Jinja', 'static/images/default_profile.png'),
(753, '2025', 'Esther', 'Kato', '2009-03-02', 'Female', 'Kampala', 'static/images/default_profile.png'),
(754, '2025', 'Paul', 'Nalubega', '2008-09-16', 'Male', 'Mbarara', 'static/images/default_profile.png'),
(755, '2024', 'Samuel', 'Byaruhanga', '2005-06-28', 'Male', 'Masaka', 'static/images/default_profile.png'),
(756, '2024', 'Brenda', 'Byaruhanga', '2008-01-04', 'Female', 'Jinja', 'static/images/default_profile.png'),
(757, '2025', 'John', 'Kyomuhendo', '2005-02-15', 'Male', 'Kampala', 'static/images/default_profile.png'),
(758, '2025', 'Isaac', 'Nalubega', '2009-02-28', 'Male', 'Arua', 'static/images/default_profile.png'),
(759, '2024', 'Grace', 'Kato', '2008-03-12', 'Female', 'Masaka', 'static/images/default_profile.png'),
(760, '2024', 'Samuel', 'Opio', '2009-02-02', 'Male', 'Mbarara', 'static/images/default_profile.png'),
(761, '2025', 'Mark', 'Tumusiime', '2005-08-03', 'Male', 'Gulu', 'static/images/default_profile.png'),
(762, '2024', 'Samuel', 'Musoke', '2005-08-08', 'Male', 'Soroti', 'static/images/default_profile.png'),
(763, '2025', 'Ivan', 'Opio', '2007-05-01', 'Male', 'Soroti', 'static/images/default_profile.png'),
(764, '2024', 'Joan', 'Opio', '2005-05-23', 'Female', 'Gulu', 'static/images/default_profile.png'),
(765, '2024', 'Isaac', 'Tumusiime', '2006-12-27', 'Male', 'Mbale', 'static/images/default_profile.png'),
(766, '2024', 'Andrew', 'Namukasa', '2009-09-12', 'Male', 'Lira', 'static/images/default_profile.png'),
(767, '2025', 'Alice', 'Nantogo', '2007-05-05', 'Female', 'Soroti', 'static/images/default_profile.png'),
(768, '2024', 'Mark', 'Tumusiime', '2005-11-18', 'Male', 'Mbarara', 'static/images/default_profile.png'),
(769, '2024', 'Doreen', 'Ochieng', '2005-11-02', 'Female', 'Masaka', 'static/images/default_profile.png'),
(770, '2024', 'Brian', 'Akello', '2005-06-21', 'Male', 'Arua', 'static/images/default_profile.png'),
(771, '2025', 'Brenda', 'Kato', '2006-08-29', 'Female', 'Lira', 'static/images/default_profile.png'),
(772, '2024', 'Mark', 'Okello', '2008-07-25', 'Male', 'Gulu', 'static/images/default_profile.png'),
(773, '2025', 'Grace', 'Byaruhanga', '2005-12-30', 'Female', 'Mbarara', 'static/images/default_profile.png'),
(774, '2025', 'Mercy', 'Nantogo', '2007-01-01', 'Female', 'Kampala', 'static/images/default_profile.png'),
(775, '2025', 'Mary', 'Nantogo', '2006-10-03', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(776, '2024', 'Moses', 'Ochieng', '2006-06-14', 'Male', 'Lira', 'static/images/default_profile.png'),
(777, '2024', 'Isaac', 'Okello', '2008-03-06', 'Male', 'Arua', 'static/images/default_profile.png'),
(778, '2024', 'Sandra', 'Waiswa', '2005-01-26', 'Female', 'Arua', 'static/images/default_profile.png'),
(779, '2024', 'Andrew', 'Opio', '2007-07-31', 'Male', 'Lira', 'static/images/default_profile.png'),
(780, '2025', 'Sarah', 'Musoke', '2008-07-31', 'Female', 'Mbale', 'static/images/default_profile.png'),
(781, '2024', 'Alice', 'Namukasa', '2008-03-26', 'Female', 'Fort Portal', 'static/images/default_profile.png'),
(782, '2024', 'Andrew', 'Nakato', '2005-04-07', 'Male', 'Arua', 'static/images/default_profile.png'),
(783, '2025', 'Solomon', 'Akello', '2009-03-03', 'Male', 'Gulu', 'static/images/default_profile.png'),
(784, '2024', 'Isaac', 'Akello', '2007-09-24', 'Male', 'Gulu', 'static/images/default_profile.png'),
(785, '2025', 'Ritah', 'Ochieng', '2007-11-10', 'Female', 'Gulu', 'static/images/default_profile.png'),
(786, '2024', 'Brenda', 'Nalubega', '2005-12-21', 'Female', 'Mbale', 'static/images/default_profile.png'),
(787, '2025', 'Daniel', 'Busingye', '2005-07-28', 'Male', 'Arua', 'static/images/default_profile.png'),
(788, '2024', 'Ivan', 'Ochieng', '2005-06-22', 'Male', 'Lira', 'static/images/default_profile.png'),
(789, '2024', 'Grace', 'Aine', '2009-11-07', 'Female', 'Mbale', 'static/images/default_profile.png'),
(790, '2024', 'Isaac', 'Kyomuhendo', '2005-09-27', 'Male', 'Kampala', 'static/images/default_profile.png'),
(791, '2024', 'Solomon', 'Nakato', '2005-09-24', 'Male', 'Arua', 'static/images/default_profile.png'),
(792, '2024', 'Samuel', 'Musoke', '2005-02-26', 'Male', 'Jinja', 'static/images/default_profile.png'),
(793, '2024', 'Rebecca', 'Mugabe', '2008-03-13', 'Female', 'Lira', 'static/images/default_profile.png'),
(794, '2024', 'Paul', 'Waiswa', '2008-01-21', 'Male', 'Masaka', 'static/images/default_profile.png'),
(795, '2024', 'Moses', 'Kato', '2008-05-15', 'Male', 'Lira', 'static/images/default_profile.png'),
(796, '2024', 'Joseph', 'Musoke', '2005-12-10', 'Male', 'Masaka', 'static/images/default_profile.png'),
(797, '2025', 'Brian', 'Byaruhanga', '2009-06-19', 'Male', 'Mbarara', 'static/images/default_profile.png'),
(798, '2024', 'Paul', 'Mukasa', '2005-07-09', 'Male', 'Gulu', 'static/images/default_profile.png'),
(799, '2025', 'Moses', 'Opio', '2009-10-26', 'Male', 'Jinja', 'static/images/default_profile.png'),
(800, '2025', 'Winnie', 'Busingye', '2007-08-28', 'Female', 'Soroti', 'static/images/default_profile.png');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `academichistory`
--
ALTER TABLE `academichistory`
  ADD PRIMARY KEY (`HistoryID`),
  ADD KEY `StudentID` (`StudentID`);

--
-- Indexes for table `enrollment`
--
ALTER TABLE `enrollment`
  ADD PRIMARY KEY (`EnrollmentID`),
  ADD KEY `StudentID` (`StudentID`);

--
-- Indexes for table `enrollmenthistory`
--
ALTER TABLE `enrollmenthistory`
  ADD PRIMARY KEY (`HistoryID`),
  ADD KEY `StudentID` (`StudentID`);

--
-- Indexes for table `parents`
--
ALTER TABLE `parents`
  ADD PRIMARY KEY (`ParentId`),
  ADD KEY `StudentID` (`StudentID`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`StudentID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `academichistory`
--
ALTER TABLE `academichistory`
  MODIFY `HistoryID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=801;

--
-- AUTO_INCREMENT for table `enrollment`
--
ALTER TABLE `enrollment`
  MODIFY `EnrollmentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=801;

--
-- AUTO_INCREMENT for table `enrollmenthistory`
--
ALTER TABLE `enrollmenthistory`
  MODIFY `HistoryID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `parents`
--
ALTER TABLE `parents`
  MODIFY `ParentId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=801;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `StudentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=801;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `academichistory`
--
ALTER TABLE `academichistory`
  ADD CONSTRAINT `academichistory_ibfk_1` FOREIGN KEY (`StudentID`) REFERENCES `students` (`StudentID`) ON DELETE CASCADE;

--
-- Constraints for table `enrollment`
--
ALTER TABLE `enrollment`
  ADD CONSTRAINT `enrollment_ibfk_1` FOREIGN KEY (`StudentID`) REFERENCES `students` (`StudentID`) ON DELETE CASCADE;

--
-- Constraints for table `enrollmenthistory`
--
ALTER TABLE `enrollmenthistory`
  ADD CONSTRAINT `enrollmenthistory_ibfk_1` FOREIGN KEY (`StudentID`) REFERENCES `students` (`StudentID`) ON DELETE CASCADE;

--
-- Constraints for table `parents`
--
ALTER TABLE `parents`
  ADD CONSTRAINT `parents_ibfk_1` FOREIGN KEY (`StudentID`) REFERENCES `students` (`StudentID`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
