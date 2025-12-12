-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 09, 2025 at 07:12 AM
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
                
                -- Photo Path: /static/uploads/Class/Stream/Surname_Name_Rand.jpg
                SET v_photo_path = CONCAT('/static/uploads/', v_class, '/', v_stream, '/', v_surname, '_', v_name, '_', FLOOR(RAND()*1000), '.jpg');

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
                    AdmissionNo, 
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

                INSERT INTO academichistory (AdmissionNo, FormerSchool, PLEIndexNumber, PLEAggregate, UCEIndexNumber, UCEResult)
                VALUES (v_student_id, v_former_school, v_ple_idx, v_ple_agg, v_uce_idx, v_uce_res);

                -- --- ENROLLMENT ---
                SET v_reg_year = IF(RAND() > 0.5, 2025, 2026);
                SET v_term = ELT(FLOOR(1 + (RAND() * 3)), 'Term I', 'Term II', 'Term III');
                SET v_residence = IF(RAND() > 0.5, 'Boarding', 'Day');
                SET v_entry_status = IF(RAND() > 0.5, 'New', 'Continuing');

                INSERT INTO enrollment (AdmissionNo, RegistrationYear, Level, Class, Term, Stream, Residence, EntryStatus)
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
                    AdmissionNo, 
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
                INSERT INTO academichistory (AdmissionNo, FormerSchool, PLEIndexNumber, PLEAggregate, UCEIndexNumber, UCEResult)
                VALUES (
                    v_student_id,
                    ELT(FLOOR(1 + (RAND() * 5)), 'Buddo Junior', 'Kampala Parents', 'Greenhill Academy', 'City Parents', 'Hillside Primary'),
                    v_ple_idx, v_ple_agg, v_uce_idx, v_uce_res
                );

                -- D. Generate Enrollment Record
                -- INSERT INTO enrollment Table
                INSERT INTO enrollment (AdmissionNo, RegistrationYear, Level, Class, Term, Stream, Residence, EntryStatus)
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
                    AdmissionNo, 
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

                INSERT INTO academichistory (AdmissionNo, FormerSchool, PLEIndexNumber, PLEAggregate, UCEIndexNumber, UCEResult)
                VALUES (v_student_id, v_former_school, v_ple_idx, v_ple_agg, v_uce_idx, v_uce_res);

                -- E. ENROLLMENT (Strict Allocation)
                SET v_reg_year = IF(RAND() > 0.5, 2025, 2026);
                SET v_term = ELT(FLOOR(1 + (RAND() * 3)), 'Term I', 'Term II', 'Term III');
                SET v_residence = IF(RAND() > 0.5, 'Boarding', 'Day');
                SET v_entry_status = IF(RAND() > 0.5, 'New', 'Continuing');

                INSERT INTO enrollment (AdmissionNo, RegistrationYear, Level, Class, Term, Stream, Residence, EntryStatus)
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
    
    -- Counters
    DECLARE c_idx INT DEFAULT 1;
    DECLARE s_idx INT DEFAULT 1;
    DECLARE stu_idx INT DEFAULT 1;
    
    -- Student Data
    DECLARE v_student_id INT;
    DECLARE v_class VARCHAR(10);
    DECLARE v_level VARCHAR(20);
    DECLARE v_stream VARCHAR(1);
    DECLARE v_gender VARCHAR(10);
    DECLARE v_surname VARCHAR(50);
    DECLARE v_name VARCHAR(50);
    DECLARE v_dob DATE;
    DECLARE v_photo VARCHAR(255);

    -- NEW: Split Address Variables (Replacing v_address)
    DECLARE v_houseNo VARCHAR(50);
    DECLARE v_street VARCHAR(100);
    DECLARE v_village VARCHAR(100);
    DECLARE v_town VARCHAR(100);
    DECLARE v_district VARCHAR(100);
    DECLARE v_state VARCHAR(100);
    DECLARE v_country VARCHAR(100) DEFAULT 'Uganda';
    
    -- Parent Data (Mandatory)
    DECLARE v_father_name VARCHAR(100);
    DECLARE v_father_contact VARCHAR(20);
    DECLARE v_father_email VARCHAR(150); -- NEW
    DECLARE v_father_age INT;
    DECLARE v_father_occ VARCHAR(50);
    DECLARE v_father_edu VARCHAR(50);
    
    DECLARE v_mother_name VARCHAR(100);
    DECLARE v_mother_contact VARCHAR(20);
    DECLARE v_mother_email VARCHAR(150); -- NEW
    DECLARE v_mother_age INT;
    DECLARE v_mother_occ VARCHAR(50);
    DECLARE v_mother_edu VARCHAR(50);
    
    -- Guardian Data (Optional: All-or-Nothing)
    DECLARE v_has_guardian INT;
    DECLARE v_guardian_name VARCHAR(100);
    DECLARE v_guardian_contact VARCHAR(20);
    DECLARE v_guardian_email VARCHAR(150); -- NEW
    DECLARE v_guardian_rel VARCHAR(20);
    DECLARE v_guardian_age INT;
    DECLARE v_guardian_occ VARCHAR(50);
    DECLARE v_guardian_edu VARCHAR(50);
    DECLARE v_guardian_addr TEXT; -- Kept as TEXT in Parents table
    
    -- Academic & Enrollment
    DECLARE v_former_school VARCHAR(100);
    DECLARE v_ple_idx VARCHAR(50);
    DECLARE v_ple_agg INT;
    DECLARE v_uce_idx VARCHAR(50);
    DECLARE v_uce_res VARCHAR(20);
    
    -- Fixed/Calculated Fields
    DECLARE v_adm_year INT DEFAULT 2025;
    DECLARE v_academic_year VARCHAR(20); 
    DECLARE v_term VARCHAR(20);
    DECLARE v_residence VARCHAR(20);
    DECLARE v_entry_status VARCHAR(20);
    DECLARE v_more_info TEXT;

    -- Set Academic Year String (2025 -> 2025-26)
    SET v_academic_year = CONCAT(v_adm_year, '-', SUBSTRING(v_adm_year + 1, 3, 2));

    -- =========================================================================
    -- 2. GENERATION LOGIC
    -- =========================================================================
    
    -- LOOP CLASSES (PP1 to S6 = 16 Classes) [cite: 14]
    SET c_idx = 1;
    WHILE c_idx <= 16 DO
        
        -- Map Index to Class/Level
        IF c_idx = 1 THEN SET v_class = 'PP.1'; SET v_level = 'Pre-Primary';
        ELSEIF c_idx = 2 THEN SET v_class = 'PP.2'; SET v_level = 'Pre-Primary';
        ELSEIF c_idx = 3 THEN SET v_class = 'PP.3'; SET v_level = 'Pre-Primary';
        ELSEIF c_idx = 4 THEN SET v_class = 'P.1'; SET v_level = 'Primary';
        ELSEIF c_idx = 5 THEN SET v_class = 'P.2'; SET v_level = 'Primary';
        ELSEIF c_idx = 6 THEN SET v_class = 'P.3'; SET v_level = 'Primary';
        ELSEIF c_idx = 7 THEN SET v_class = 'P.4'; SET v_level = 'Primary';
        ELSEIF c_idx = 8 THEN SET v_class = 'P.5'; SET v_level = 'Primary';
        ELSEIF c_idx = 9 THEN SET v_class = 'P.6'; SET v_level = 'Primary';
        ELSEIF c_idx = 10 THEN SET v_class = 'P.7'; SET v_level = 'Primary';
        ELSEIF c_idx = 11 THEN SET v_class = 'S.1'; SET v_level = 'Secondary';
        ELSEIF c_idx = 12 THEN SET v_class = 'S.2'; SET v_level = 'Secondary';
        ELSEIF c_idx = 13 THEN SET v_class = 'S.3'; SET v_level = 'Secondary';
        ELSEIF c_idx = 14 THEN SET v_class = 'S.4'; SET v_level = 'Secondary';
        ELSEIF c_idx = 15 THEN SET v_class = 'S.5'; SET v_level = 'Secondary';
        ELSEIF c_idx = 16 THEN SET v_class = 'S.6'; SET v_level = 'Secondary';
        END IF;

        -- LOOP STREAMS (A, B, C, D, E) [cite: 31]
        SET s_idx = 1;
        WHILE s_idx <= 5 DO
            SET v_stream = ELT(s_idx, 'A', 'B', 'C', 'D', 'E');

            -- LOOP STUDENTS (Exactly 10 per stream) [cite: 33]
            SET stu_idx = 1;
            WHILE stu_idx <= 10 DO
                
                -- A. STUDENT IDENTITY
                SET v_gender = IF(FLOOR(RAND()*2)=1, 'Male', 'Female');
                SET v_surname = ELT(FLOOR(1 + (RAND() * 20)), 'Kato', 'Mukasa', 'Okello', 'Akello', 'Namukasa', 'Musoke', 'Mugabe', 'Kyomuhendo', 'Nalubega', 'Ochieng', 'Lwanga', 'Nantogo', 'Opio', 'Aine', 'Busingye', 'Ssemwogerere', 'Nakato', 'Waiswa', 'Byaruhanga', 'Tumusiime');
                
                IF v_gender = 'Male' THEN
                    SET v_name = ELT(FLOOR(1 + (RAND() * 15)), 'John', 'David', 'Moses', 'Isaac', 'Brian', 'Joseph', 'Paul', 'Ivan', 'Samuel', 'Daniel', 'Solomon', 'Timothy', 'Mark', 'Andrew', 'Peter');
                ELSE
                    SET v_name = ELT(FLOOR(1 + (RAND() * 15)), 'Mary', 'Sarah', 'Grace', 'Joy', 'Pritah', 'Esther', 'Joan', 'Sandra', 'Ritah', 'Mercy', 'Doreen', 'Rebecca', 'Alice', 'Brenda', 'Winnie');
                END IF;

                -- DOB between 2005 and 2010
                SET v_dob = DATE_ADD('2005-01-01', INTERVAL FLOOR(RAND() * 1825) DAY);
                
                -- NEW: Generate Split Address Data
                SET v_houseNo = FLOOR(1 + (RAND() * 500));
                SET v_street = ELT(FLOOR(1 + (RAND() * 6)), 'Main Street', 'Church Road', 'Market Lane', 'School Road', 'Hospital View', 'Central Avenue');
                SET v_town = ELT(FLOOR(1 + (RAND() * 10)), 'Kampala', 'Gulu', 'Mbale', 'Jinja', 'Mbarara', 'Arua', 'Fort Portal', 'Masaka', 'Soroti', 'Lira');
                SET v_village = CONCAT(v_town, ' Central'); 
                SET v_district = v_town; 
                SET v_state = 'Central Region'; 
                SET v_country = 'Uganda';

                SET v_photo = 'static/images/default_profile.png';

                -- INSERT STUDENT (Updated Columns)
                INSERT INTO students (
                    AdmissionYear, Name, Surname, DateOfBirth, Gender, 
                    HouseNo, Street, Village, Town, District, State, Country, 
                    PhotoPath
                ) VALUES (
                    v_adm_year, v_name, v_surname, v_dob, v_gender, 
                    v_houseNo, v_street, v_village, v_town, v_district, v_state, v_country, 
                    v_photo
                );
                
                SET v_student_id = LAST_INSERT_ID();

                -- B. PARENT DETAILS (Mandatory)
                
                -- Father
                SET v_father_name = CONCAT(ELT(FLOOR(1 + (RAND() * 15)), 'John', 'David', 'Moses', 'Isaac', 'Brian', 'Joseph', 'Paul', 'Ivan', 'Samuel', 'Daniel', 'Solomon', 'Timothy', 'Mark', 'Andrew', 'Peter'), ' ', v_surname);
                SET v_father_contact = CONCAT('+2567', ELT(FLOOR(1 + (RAND() * 4)), '7', '0', '5', '8'), FLOOR(1000000 + (RAND() * 8999999)));
                -- Generate Email
                SET v_father_email = CONCAT(REPLACE(LOWER(SUBSTRING_INDEX(v_father_name, ' ', 1)), ' ', ''), '.', LOWER(v_surname), FLOOR(RAND()*99), '@gmail.com');
                
                SET v_father_age = FLOOR(30 + (RAND() * 40)); 
                SET v_father_occ = ELT(FLOOR(1 + (RAND() * 9)), 'Teacher', 'Farmer', 'Doctor', 'Engineer', 'Driver', 'Shopkeeper', 'Civil Servant', 'Carpenter', 'Mechanic');
                SET v_father_edu = ELT(FLOOR(1 + (RAND() * 5)), 'Primary', 'Secondary', 'Diploma', 'Bachelor’s Degree', 'Master’s Degree');
                
                -- Mother
                SET v_mother_name = CONCAT(ELT(FLOOR(1 + (RAND() * 15)), 'Mary', 'Sarah', 'Grace', 'Joy', 'Pritah', 'Esther', 'Joan', 'Sandra', 'Ritah', 'Mercy', 'Doreen', 'Rebecca', 'Alice', 'Brenda', 'Winnie'), ' ', ELT(FLOOR(1 + (RAND() * 20)), 'Kato', 'Mukasa', 'Okello', 'Akello', 'Namukasa', 'Musoke', 'Mugabe', 'Kyomuhendo', 'Nalubega', 'Ochieng', 'Lwanga', 'Nantogo', 'Opio', 'Aine', 'Busingye', 'Ssemwogerere', 'Nakato', 'Waiswa', 'Byaruhanga', 'Tumusiime'));
                SET v_mother_contact = CONCAT('+2567', ELT(FLOOR(1 + (RAND() * 4)), '7', '0', '5', '8'), FLOOR(1000000 + (RAND() * 8999999)));
                -- Generate Email
                SET v_mother_email = CONCAT(REPLACE(LOWER(SUBSTRING_INDEX(v_mother_name, ' ', 1)), ' ', ''), '.', FLOOR(RAND()*999), '@gmail.com');

                SET v_mother_age = FLOOR(28 + (RAND() * 37));
                SET v_mother_occ = ELT(FLOOR(1 + (RAND() * 8)), 'Nurse', 'Farmer', 'Teacher', 'Tailor', 'Trader', 'Civil Servant', 'Housewife', 'Entrepreneur');
                SET v_mother_edu = ELT(FLOOR(1 + (RAND() * 5)), 'Primary', 'Secondary', 'Diploma', 'Bachelor’s Degree', 'Master’s Degree');
                
                -- C. GUARDIAN (30% chance)
                IF RAND() < 0.3 THEN
                    SET v_guardian_name = CONCAT(ELT(FLOOR(1 + (RAND() * 10)), 'James', 'Charles', 'Patrick', 'Robert', 'Susan', 'Hellen', 'Florence', 'Alice', 'Rose', 'Lillian'), ' ', v_surname);
                    SET v_guardian_contact = CONCAT('+2567', ELT(FLOOR(1 + (RAND() * 4)), '7', '0', '5', '8'), FLOOR(1000000 + (RAND() * 8999999)));
                    SET v_guardian_email = CONCAT(REPLACE(LOWER(SUBSTRING_INDEX(v_guardian_name, ' ', 1)), ' ', ''), '.', FLOOR(RAND()*99), '@yahoo.com');
                    SET v_guardian_rel = ELT(FLOOR(1 + (RAND() * 6)), 'Father', 'Mother', 'Uncle', 'Aunt', 'Grandparent', 'Other');
                    SET v_guardian_age = FLOOR(25 + (RAND() * 55));
                    SET v_guardian_occ = ELT(FLOOR(1 + (RAND() * 9)), 'Teacher', 'Farmer', 'Doctor', 'Engineer', 'Driver', 'Shopkeeper', 'Civil Servant', 'Carpenter', 'Mechanic');
                    SET v_guardian_edu = ELT(FLOOR(1 + (RAND() * 5)), 'Primary', 'Secondary', 'Diploma', 'Bachelor’s Degree', 'Master’s Degree');
                    -- Concatenate split address for Guardian (since Parent table still uses 'text' for guardian address)
                    SET v_guardian_addr = CONCAT(v_houseNo, ' ', v_street, ', ', v_town, ', ', v_district);
                ELSE
                    SET v_guardian_name = NULL;
                    SET v_guardian_contact = NULL;
                    SET v_guardian_email = NULL;
                    SET v_guardian_rel = NULL;
                    SET v_guardian_age = NULL;
                    SET v_guardian_occ = NULL;
                    SET v_guardian_edu = NULL;
                    SET v_guardian_addr = NULL;
                END IF;

                SET v_more_info = ELT(FLOOR(1 + (RAND() * 5)), 'Active in debate club', 'Prefect', 'Choir member', 'Football team', 'Science fair participant');
                
                -- INSERT PARENTS (Updated with Emails)
                INSERT INTO parents (
                    AdmissionNo, 
                    father_name, father_age, father_contact, father_email, father_occupation, father_education,
                    mother_name, mother_age, mother_contact, mother_email, mother_occupation, mother_education,
                    guardian_name, guardian_relation, guardian_contact, guardian_email, guardian_age, guardian_occupation, guardian_education, guardian_address,
                    MoreInformation
                ) VALUES (
                    v_student_id,
                    v_father_name, v_father_age, v_father_contact, v_father_email, v_father_occ, v_father_edu,
                    v_mother_name, v_mother_age, v_mother_contact, v_mother_email, v_mother_occ, v_mother_edu,
                    v_guardian_name, v_guardian_rel, v_guardian_contact, v_guardian_email, v_guardian_age, v_guardian_occ, v_guardian_edu, v_guardian_addr,
                    v_more_info
                );

                -- D. ACADEMIC RECORDS (Mandatory) [cite: 61]
                SET v_former_school = ELT(FLOOR(1 + (RAND() * 5)), 'Namilyango School', 'Gayaza High School', 'Ntare School', 'Buddo Junior', 'Greenhill Academy');
                
                SET v_ple_idx = CONCAT('PLE/UG/20', FLOOR(10 + (RAND() * 14)), '/', LPAD(FLOOR(RAND() * 100000), 5, '0'));
                SET v_ple_agg = FLOOR(4 + (RAND() * 32)); 
                
                SET v_uce_idx = CONCAT('UCE/UG/20', FLOOR(10 + (RAND() * 14)), '/', LPAD(FLOOR(RAND() * 100000), 5, '0'));
                SET v_uce_res = ELT(FLOOR(1 + (RAND() * 4)), 'Division I', 'Division II', 'Division III', 'Division IV');

                INSERT INTO academichistory (AdmissionNo, FormerSchool, PLEIndexNumber, PLEAggregate, UCEIndexNumber, UCEResult)
                VALUES (v_student_id, v_former_school, v_ple_idx, v_ple_agg, v_uce_idx, v_uce_res);

                -- E. ENROLLMENT [cite: 66]
                SET v_term = ELT(FLOOR(1 + (RAND() * 3)), 'Term 1', 'Term 2', 'Term 3');
                SET v_residence = IF(RAND() > 0.5, 'Boarding', 'Day');
                SET v_entry_status = IF(v_class = 'P.1' OR v_class = 'S.1' OR v_class = 'PP.1', 'New', 'Continuing');

                INSERT INTO enrollment (AdmissionNo, AcademicYear, Level, Class, Term, Stream, Residence, EntryStatus)
                VALUES (v_student_id, v_academic_year, v_level, v_class, v_term, v_stream, v_residence, v_entry_status);

                SET stu_idx = stu_idx + 1;
            END WHILE; -- End Student Loop

            SET s_idx = s_idx + 1;
        END WHILE; -- End Stream Loop

        SET c_idx = c_idx + 1;
    END WHILE; -- End Class Loop

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `academichistory`
--

CREATE TABLE `academichistory` (
  `HistoryID` int(11) NOT NULL,
  `AdmissionNo` int(11) NOT NULL,
  `FormerSchool` varchar(255) DEFAULT NULL,
  `PLEIndexNumber` varchar(50) DEFAULT NULL,
  `PLEAggregate` int(11) DEFAULT NULL,
  `UCEIndexNumber` varchar(50) DEFAULT NULL,
  `UCEResult` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `academichistory`
--

INSERT INTO `academichistory` (`HistoryID`, `AdmissionNo`, `FormerSchool`, `PLEIndexNumber`, `PLEAggregate`, `UCEIndexNumber`, `UCEResult`) VALUES
(1, 1, 'Ntare School', 'PLE/UG/2018/61395', 8, 'UCE/UG/2022/02605', 'Division II'),
(2, 2, 'Greenhill Academy', 'PLE/UG/2020/28304', 6, 'UCE/UG/2017/35801', 'Division I'),
(3, 3, 'Greenhill Academy', 'PLE/UG/2017/81723', 22, 'UCE/UG/2016/60307', 'Division III'),
(4, 4, 'Greenhill Academy', 'PLE/UG/2021/71973', 8, 'UCE/UG/2016/96579', 'Division II'),
(5, 5, 'Buddo Junior', 'PLE/UG/2013/87717', 27, 'UCE/UG/2023/81540', 'Division I'),
(6, 6, 'Ntare School', 'PLE/UG/2012/20425', 19, 'UCE/UG/2021/63837', 'Division III'),
(7, 7, 'Gayaza High School', 'PLE/UG/2020/07153', 4, 'UCE/UG/2022/31189', 'Division IV'),
(8, 8, 'Greenhill Academy', 'PLE/UG/2020/02876', 35, 'UCE/UG/2021/16863', 'Division II'),
(9, 9, 'Gayaza High School', 'PLE/UG/2017/06825', 27, 'UCE/UG/2016/10748', 'Division I'),
(10, 10, 'Namilyango School', 'PLE/UG/2010/82164', 35, 'UCE/UG/2017/63547', 'Division III'),
(11, 11, 'Greenhill Academy', 'PLE/UG/2018/09286', 25, 'UCE/UG/2011/60115', 'Division III'),
(12, 12, 'Namilyango School', 'PLE/UG/2012/73939', 7, 'UCE/UG/2014/21663', 'Division I'),
(13, 13, 'Gayaza High School', 'PLE/UG/2021/06325', 31, 'UCE/UG/2012/13821', 'Division I'),
(14, 14, 'Namilyango School', 'PLE/UG/2023/56924', 34, 'UCE/UG/2011/70695', 'Division I'),
(15, 15, 'Buddo Junior', 'PLE/UG/2018/78826', 4, 'UCE/UG/2020/82139', 'Division IV'),
(16, 16, 'Ntare School', 'PLE/UG/2012/15165', 13, 'UCE/UG/2023/97363', 'Division IV'),
(17, 17, 'Gayaza High School', 'PLE/UG/2020/61613', 33, 'UCE/UG/2020/98138', 'Division III'),
(18, 18, 'Gayaza High School', 'PLE/UG/2012/09961', 31, 'UCE/UG/2010/58463', 'Division IV'),
(19, 19, 'Namilyango School', 'PLE/UG/2010/99635', 33, 'UCE/UG/2019/48074', 'Division II'),
(20, 20, 'Gayaza High School', 'PLE/UG/2011/46695', 7, 'UCE/UG/2011/19379', 'Division III'),
(21, 21, 'Greenhill Academy', 'PLE/UG/2018/57887', 5, 'UCE/UG/2016/34921', 'Division II'),
(22, 22, 'Ntare School', 'PLE/UG/2014/10266', 19, 'UCE/UG/2012/25973', 'Division IV'),
(23, 23, 'Greenhill Academy', 'PLE/UG/2020/16162', 23, 'UCE/UG/2018/21757', 'Division I'),
(24, 24, 'Namilyango School', 'PLE/UG/2015/52365', 21, 'UCE/UG/2012/11291', 'Division I'),
(25, 25, 'Gayaza High School', 'PLE/UG/2012/74512', 11, 'UCE/UG/2023/20030', 'Division I'),
(26, 26, 'Buddo Junior', 'PLE/UG/2016/08795', 8, 'UCE/UG/2015/50557', 'Division II'),
(27, 27, 'Gayaza High School', 'PLE/UG/2021/33314', 11, 'UCE/UG/2012/16317', 'Division II'),
(28, 28, 'Gayaza High School', 'PLE/UG/2013/37579', 9, 'UCE/UG/2019/94236', 'Division III'),
(29, 29, 'Greenhill Academy', 'PLE/UG/2017/84081', 22, 'UCE/UG/2015/16211', 'Division III'),
(30, 30, 'Ntare School', 'PLE/UG/2020/00770', 30, 'UCE/UG/2012/43455', 'Division III'),
(31, 31, 'Gayaza High School', 'PLE/UG/2015/01943', 35, 'UCE/UG/2022/59301', 'Division I'),
(32, 32, 'Greenhill Academy', 'PLE/UG/2021/51181', 9, 'UCE/UG/2014/06089', 'Division II'),
(33, 33, 'Greenhill Academy', 'PLE/UG/2014/95258', 32, 'UCE/UG/2019/62634', 'Division I'),
(34, 34, 'Ntare School', 'PLE/UG/2023/26212', 15, 'UCE/UG/2010/96157', 'Division IV'),
(35, 35, 'Gayaza High School', 'PLE/UG/2018/91825', 27, 'UCE/UG/2022/13540', 'Division I'),
(36, 36, 'Ntare School', 'PLE/UG/2016/91707', 12, 'UCE/UG/2018/24337', 'Division II'),
(37, 37, 'Namilyango School', 'PLE/UG/2016/83049', 27, 'UCE/UG/2011/35992', 'Division II'),
(38, 38, 'Namilyango School', 'PLE/UG/2013/73128', 35, 'UCE/UG/2020/67898', 'Division I'),
(39, 39, 'Ntare School', 'PLE/UG/2017/45850', 23, 'UCE/UG/2018/25774', 'Division II'),
(40, 40, 'Greenhill Academy', 'PLE/UG/2012/97199', 13, 'UCE/UG/2016/61686', 'Division III'),
(41, 41, 'Greenhill Academy', 'PLE/UG/2015/41358', 33, 'UCE/UG/2014/89786', 'Division III'),
(42, 42, 'Greenhill Academy', 'PLE/UG/2017/12320', 33, 'UCE/UG/2014/66705', 'Division II'),
(43, 43, 'Namilyango School', 'PLE/UG/2013/96772', 6, 'UCE/UG/2017/45491', 'Division III'),
(44, 44, 'Buddo Junior', 'PLE/UG/2016/12178', 13, 'UCE/UG/2012/85735', 'Division IV'),
(45, 45, 'Ntare School', 'PLE/UG/2012/09049', 4, 'UCE/UG/2021/15617', 'Division I'),
(46, 46, 'Ntare School', 'PLE/UG/2012/12279', 9, 'UCE/UG/2016/92641', 'Division I'),
(47, 47, 'Greenhill Academy', 'PLE/UG/2019/65375', 8, 'UCE/UG/2020/24478', 'Division I'),
(48, 48, 'Buddo Junior', 'PLE/UG/2019/31647', 22, 'UCE/UG/2022/68170', 'Division IV'),
(49, 49, 'Buddo Junior', 'PLE/UG/2017/04906', 21, 'UCE/UG/2017/03008', 'Division III'),
(50, 50, 'Namilyango School', 'PLE/UG/2016/37958', 18, 'UCE/UG/2010/97126', 'Division III'),
(51, 51, 'Gayaza High School', 'PLE/UG/2022/65296', 19, 'UCE/UG/2016/75437', 'Division II'),
(52, 52, 'Greenhill Academy', 'PLE/UG/2020/00859', 30, 'UCE/UG/2012/37951', 'Division II'),
(53, 53, 'Namilyango School', 'PLE/UG/2015/67153', 12, 'UCE/UG/2014/81643', 'Division I'),
(54, 54, 'Buddo Junior', 'PLE/UG/2013/55950', 34, 'UCE/UG/2012/88708', 'Division IV'),
(55, 55, 'Greenhill Academy', 'PLE/UG/2021/27327', 4, 'UCE/UG/2013/05291', 'Division III'),
(56, 56, 'Namilyango School', 'PLE/UG/2016/21172', 23, 'UCE/UG/2016/50211', 'Division I'),
(57, 57, 'Namilyango School', 'PLE/UG/2022/46873', 23, 'UCE/UG/2019/46814', 'Division II'),
(58, 58, 'Ntare School', 'PLE/UG/2012/82909', 20, 'UCE/UG/2011/86997', 'Division I'),
(59, 59, 'Buddo Junior', 'PLE/UG/2011/82763', 27, 'UCE/UG/2012/61499', 'Division III'),
(60, 60, 'Gayaza High School', 'PLE/UG/2016/19397', 22, 'UCE/UG/2014/95997', 'Division IV'),
(61, 61, 'Greenhill Academy', 'PLE/UG/2021/43559', 27, 'UCE/UG/2015/73714', 'Division III'),
(62, 62, 'Buddo Junior', 'PLE/UG/2010/05730', 9, 'UCE/UG/2020/18661', 'Division III'),
(63, 63, 'Namilyango School', 'PLE/UG/2020/57960', 27, 'UCE/UG/2023/56772', 'Division IV'),
(64, 64, 'Greenhill Academy', 'PLE/UG/2021/39713', 23, 'UCE/UG/2022/69423', 'Division III'),
(65, 65, 'Namilyango School', 'PLE/UG/2022/16459', 11, 'UCE/UG/2020/88961', 'Division II'),
(66, 66, 'Ntare School', 'PLE/UG/2020/98858', 26, 'UCE/UG/2018/80231', 'Division II'),
(67, 67, 'Greenhill Academy', 'PLE/UG/2021/73847', 9, 'UCE/UG/2019/88930', 'Division II'),
(68, 68, 'Greenhill Academy', 'PLE/UG/2017/10102', 33, 'UCE/UG/2014/81430', 'Division I'),
(69, 69, 'Gayaza High School', 'PLE/UG/2011/35952', 22, 'UCE/UG/2021/36143', 'Division II'),
(70, 70, 'Gayaza High School', 'PLE/UG/2016/60628', 24, 'UCE/UG/2015/15384', 'Division III'),
(71, 71, 'Ntare School', 'PLE/UG/2022/03721', 18, 'UCE/UG/2011/13437', 'Division II'),
(72, 72, 'Ntare School', 'PLE/UG/2018/42398', 13, 'UCE/UG/2012/89328', 'Division I'),
(73, 73, 'Greenhill Academy', 'PLE/UG/2017/85583', 27, 'UCE/UG/2011/40730', 'Division III'),
(74, 74, 'Ntare School', 'PLE/UG/2011/42934', 28, 'UCE/UG/2017/46475', 'Division III'),
(75, 75, 'Namilyango School', 'PLE/UG/2021/69161', 35, 'UCE/UG/2022/37034', 'Division II'),
(76, 76, 'Buddo Junior', 'PLE/UG/2020/75416', 20, 'UCE/UG/2015/28399', 'Division II'),
(77, 77, 'Buddo Junior', 'PLE/UG/2022/47339', 29, 'UCE/UG/2017/39137', 'Division II'),
(78, 78, 'Buddo Junior', 'PLE/UG/2018/11740', 29, 'UCE/UG/2018/54253', 'Division IV'),
(79, 79, 'Ntare School', 'PLE/UG/2018/53149', 33, 'UCE/UG/2010/24911', 'Division I'),
(80, 80, 'Ntare School', 'PLE/UG/2011/87064', 34, 'UCE/UG/2013/18140', 'Division II'),
(81, 81, 'Namilyango School', 'PLE/UG/2011/27172', 5, 'UCE/UG/2015/99603', 'Division III'),
(82, 82, 'Ntare School', 'PLE/UG/2022/84953', 22, 'UCE/UG/2014/92049', 'Division III'),
(83, 83, 'Ntare School', 'PLE/UG/2011/98389', 21, 'UCE/UG/2021/40175', 'Division III'),
(84, 84, 'Greenhill Academy', 'PLE/UG/2020/05419', 4, 'UCE/UG/2023/59164', 'Division I'),
(85, 85, 'Gayaza High School', 'PLE/UG/2010/83039', 8, 'UCE/UG/2012/62662', 'Division III'),
(86, 86, 'Greenhill Academy', 'PLE/UG/2011/62091', 32, 'UCE/UG/2017/07282', 'Division III'),
(87, 87, 'Namilyango School', 'PLE/UG/2023/49382', 22, 'UCE/UG/2015/11915', 'Division II'),
(88, 88, 'Gayaza High School', 'PLE/UG/2010/46853', 12, 'UCE/UG/2023/14049', 'Division III'),
(89, 89, 'Buddo Junior', 'PLE/UG/2018/21227', 10, 'UCE/UG/2015/32125', 'Division II'),
(90, 90, 'Gayaza High School', 'PLE/UG/2022/87403', 22, 'UCE/UG/2014/78893', 'Division I'),
(91, 91, 'Namilyango School', 'PLE/UG/2012/72510', 4, 'UCE/UG/2021/22991', 'Division III'),
(92, 92, 'Buddo Junior', 'PLE/UG/2017/21294', 20, 'UCE/UG/2023/23323', 'Division II'),
(93, 93, 'Greenhill Academy', 'PLE/UG/2016/78980', 22, 'UCE/UG/2017/85270', 'Division III'),
(94, 94, 'Gayaza High School', 'PLE/UG/2016/13194', 15, 'UCE/UG/2015/82778', 'Division I'),
(95, 95, 'Greenhill Academy', 'PLE/UG/2019/72498', 26, 'UCE/UG/2014/35911', 'Division IV'),
(96, 96, 'Ntare School', 'PLE/UG/2019/93039', 20, 'UCE/UG/2021/39186', 'Division III'),
(97, 97, 'Gayaza High School', 'PLE/UG/2022/71796', 31, 'UCE/UG/2011/89775', 'Division I'),
(98, 98, 'Gayaza High School', 'PLE/UG/2022/47891', 27, 'UCE/UG/2012/86420', 'Division III'),
(99, 99, 'Buddo Junior', 'PLE/UG/2010/19882', 34, 'UCE/UG/2013/21484', 'Division II'),
(100, 100, 'Gayaza High School', 'PLE/UG/2022/37402', 8, 'UCE/UG/2018/50109', 'Division IV'),
(101, 101, 'Buddo Junior', 'PLE/UG/2011/11941', 16, 'UCE/UG/2017/47447', 'Division IV'),
(102, 102, 'Ntare School', 'PLE/UG/2022/15768', 6, 'UCE/UG/2023/49621', 'Division III'),
(103, 103, 'Greenhill Academy', 'PLE/UG/2015/42248', 35, 'UCE/UG/2019/38321', 'Division IV'),
(104, 104, 'Greenhill Academy', 'PLE/UG/2023/17395', 33, 'UCE/UG/2010/49837', 'Division II'),
(105, 105, 'Greenhill Academy', 'PLE/UG/2021/44352', 29, 'UCE/UG/2019/94923', 'Division III'),
(106, 106, 'Gayaza High School', 'PLE/UG/2023/13825', 30, 'UCE/UG/2020/25821', 'Division I'),
(107, 107, 'Gayaza High School', 'PLE/UG/2021/86806', 33, 'UCE/UG/2010/43603', 'Division I'),
(108, 108, 'Namilyango School', 'PLE/UG/2011/20254', 26, 'UCE/UG/2022/23461', 'Division III'),
(109, 109, 'Buddo Junior', 'PLE/UG/2013/16887', 9, 'UCE/UG/2014/17225', 'Division IV'),
(110, 110, 'Greenhill Academy', 'PLE/UG/2015/23153', 6, 'UCE/UG/2019/17735', 'Division IV'),
(111, 111, 'Buddo Junior', 'PLE/UG/2016/24352', 31, 'UCE/UG/2018/58891', 'Division I'),
(112, 112, 'Ntare School', 'PLE/UG/2012/29708', 35, 'UCE/UG/2010/10479', 'Division II'),
(113, 113, 'Namilyango School', 'PLE/UG/2015/77488', 24, 'UCE/UG/2023/77787', 'Division I'),
(114, 114, 'Greenhill Academy', 'PLE/UG/2018/11587', 31, 'UCE/UG/2022/05941', 'Division III'),
(115, 115, 'Ntare School', 'PLE/UG/2018/29881', 26, 'UCE/UG/2018/91688', 'Division IV'),
(116, 116, 'Greenhill Academy', 'PLE/UG/2011/60723', 27, 'UCE/UG/2021/98929', 'Division II'),
(117, 117, 'Buddo Junior', 'PLE/UG/2010/96871', 28, 'UCE/UG/2023/45450', 'Division II'),
(118, 118, 'Greenhill Academy', 'PLE/UG/2012/03059', 24, 'UCE/UG/2010/42851', 'Division IV'),
(119, 119, 'Buddo Junior', 'PLE/UG/2013/76087', 8, 'UCE/UG/2016/99540', 'Division III'),
(120, 120, 'Greenhill Academy', 'PLE/UG/2010/51864', 16, 'UCE/UG/2016/01096', 'Division III'),
(121, 121, 'Gayaza High School', 'PLE/UG/2011/74377', 14, 'UCE/UG/2016/17857', 'Division III'),
(122, 122, 'Ntare School', 'PLE/UG/2017/97785', 11, 'UCE/UG/2014/76811', 'Division IV'),
(123, 123, 'Buddo Junior', 'PLE/UG/2020/35244', 21, 'UCE/UG/2019/88996', 'Division II'),
(124, 124, 'Gayaza High School', 'PLE/UG/2012/72243', 6, 'UCE/UG/2013/85106', 'Division III'),
(125, 125, 'Buddo Junior', 'PLE/UG/2012/50929', 7, 'UCE/UG/2023/54984', 'Division IV'),
(126, 126, 'Gayaza High School', 'PLE/UG/2013/45355', 22, 'UCE/UG/2016/71452', 'Division I'),
(127, 127, 'Gayaza High School', 'PLE/UG/2015/87325', 9, 'UCE/UG/2012/49818', 'Division IV'),
(128, 128, 'Greenhill Academy', 'PLE/UG/2021/25223', 28, 'UCE/UG/2010/05632', 'Division I'),
(129, 129, 'Greenhill Academy', 'PLE/UG/2018/09513', 28, 'UCE/UG/2016/12463', 'Division I'),
(130, 130, 'Namilyango School', 'PLE/UG/2015/59905', 27, 'UCE/UG/2021/05111', 'Division III'),
(131, 131, 'Gayaza High School', 'PLE/UG/2018/44389', 14, 'UCE/UG/2015/82869', 'Division I'),
(132, 132, 'Namilyango School', 'PLE/UG/2023/56800', 33, 'UCE/UG/2022/58795', 'Division II'),
(133, 133, 'Ntare School', 'PLE/UG/2021/47924', 35, 'UCE/UG/2016/45876', 'Division IV'),
(134, 134, 'Buddo Junior', 'PLE/UG/2016/24231', 29, 'UCE/UG/2013/96274', 'Division IV'),
(135, 135, 'Greenhill Academy', 'PLE/UG/2015/35637', 23, 'UCE/UG/2023/86920', 'Division III'),
(136, 136, 'Ntare School', 'PLE/UG/2014/14195', 27, 'UCE/UG/2013/91863', 'Division IV'),
(137, 137, 'Buddo Junior', 'PLE/UG/2021/38334', 16, 'UCE/UG/2020/58618', 'Division III'),
(138, 138, 'Ntare School', 'PLE/UG/2015/39751', 31, 'UCE/UG/2010/60322', 'Division IV'),
(139, 139, 'Greenhill Academy', 'PLE/UG/2021/00392', 24, 'UCE/UG/2011/78437', 'Division III'),
(140, 140, 'Gayaza High School', 'PLE/UG/2016/78371', 19, 'UCE/UG/2010/63283', 'Division I'),
(141, 141, 'Buddo Junior', 'PLE/UG/2018/93097', 33, 'UCE/UG/2020/12844', 'Division II'),
(142, 142, 'Greenhill Academy', 'PLE/UG/2011/45237', 35, 'UCE/UG/2018/16264', 'Division IV'),
(143, 143, 'Buddo Junior', 'PLE/UG/2021/95004', 15, 'UCE/UG/2022/37239', 'Division I'),
(144, 144, 'Ntare School', 'PLE/UG/2019/61294', 6, 'UCE/UG/2017/49254', 'Division IV'),
(145, 145, 'Buddo Junior', 'PLE/UG/2018/24851', 16, 'UCE/UG/2013/12321', 'Division IV'),
(146, 146, 'Buddo Junior', 'PLE/UG/2014/37833', 32, 'UCE/UG/2014/93851', 'Division III'),
(147, 147, 'Buddo Junior', 'PLE/UG/2023/08556', 19, 'UCE/UG/2012/53826', 'Division I'),
(148, 148, 'Ntare School', 'PLE/UG/2023/26069', 17, 'UCE/UG/2013/06946', 'Division III'),
(149, 149, 'Gayaza High School', 'PLE/UG/2018/86215', 21, 'UCE/UG/2011/01552', 'Division III'),
(150, 150, 'Buddo Junior', 'PLE/UG/2011/66414', 5, 'UCE/UG/2012/76956', 'Division II'),
(151, 151, 'Gayaza High School', 'PLE/UG/2015/82053', 4, 'UCE/UG/2019/36235', 'Division III'),
(152, 152, 'Namilyango School', 'PLE/UG/2019/25037', 10, 'UCE/UG/2013/61707', 'Division II'),
(153, 153, 'Greenhill Academy', 'PLE/UG/2010/30910', 18, 'UCE/UG/2013/07528', 'Division III'),
(154, 154, 'Buddo Junior', 'PLE/UG/2020/71623', 16, 'UCE/UG/2021/07589', 'Division IV'),
(155, 155, 'Ntare School', 'PLE/UG/2019/94615', 23, 'UCE/UG/2012/04842', 'Division III'),
(156, 156, 'Ntare School', 'PLE/UG/2012/23222', 27, 'UCE/UG/2022/38527', 'Division I'),
(157, 157, 'Namilyango School', 'PLE/UG/2022/28331', 29, 'UCE/UG/2011/02082', 'Division IV'),
(158, 158, 'Buddo Junior', 'PLE/UG/2017/92307', 35, 'UCE/UG/2011/56508', 'Division III'),
(159, 159, 'Gayaza High School', 'PLE/UG/2014/87714', 15, 'UCE/UG/2011/40690', 'Division IV'),
(160, 160, 'Ntare School', 'PLE/UG/2022/92188', 5, 'UCE/UG/2015/93574', 'Division II'),
(161, 161, 'Ntare School', 'PLE/UG/2020/44524', 33, 'UCE/UG/2014/72255', 'Division III'),
(162, 162, 'Greenhill Academy', 'PLE/UG/2015/98939', 31, 'UCE/UG/2015/34273', 'Division III'),
(163, 163, 'Ntare School', 'PLE/UG/2014/18758', 32, 'UCE/UG/2021/55868', 'Division II'),
(164, 164, 'Gayaza High School', 'PLE/UG/2018/16177', 5, 'UCE/UG/2020/56567', 'Division III'),
(165, 165, 'Gayaza High School', 'PLE/UG/2015/21177', 31, 'UCE/UG/2018/55977', 'Division IV'),
(166, 166, 'Buddo Junior', 'PLE/UG/2012/74195', 12, 'UCE/UG/2010/48964', 'Division II'),
(167, 167, 'Greenhill Academy', 'PLE/UG/2011/96817', 19, 'UCE/UG/2016/96098', 'Division II'),
(168, 168, 'Namilyango School', 'PLE/UG/2010/25977', 7, 'UCE/UG/2021/66883', 'Division IV'),
(169, 169, 'Greenhill Academy', 'PLE/UG/2022/49865', 33, 'UCE/UG/2011/68959', 'Division I'),
(170, 170, 'Namilyango School', 'PLE/UG/2023/47629', 18, 'UCE/UG/2022/15223', 'Division I'),
(171, 171, 'Ntare School', 'PLE/UG/2014/85177', 14, 'UCE/UG/2010/11875', 'Division III'),
(172, 172, 'Greenhill Academy', 'PLE/UG/2012/54906', 8, 'UCE/UG/2011/18851', 'Division III'),
(173, 173, 'Buddo Junior', 'PLE/UG/2016/40423', 21, 'UCE/UG/2017/06621', 'Division III'),
(174, 174, 'Gayaza High School', 'PLE/UG/2022/52762', 34, 'UCE/UG/2013/26977', 'Division III'),
(175, 175, 'Buddo Junior', 'PLE/UG/2016/29469', 35, 'UCE/UG/2011/51808', 'Division II'),
(176, 176, 'Gayaza High School', 'PLE/UG/2020/82169', 28, 'UCE/UG/2015/65457', 'Division I'),
(177, 177, 'Namilyango School', 'PLE/UG/2020/31816', 12, 'UCE/UG/2014/95164', 'Division III'),
(178, 178, 'Ntare School', 'PLE/UG/2016/87545', 4, 'UCE/UG/2017/48559', 'Division IV'),
(179, 179, 'Gayaza High School', 'PLE/UG/2015/13596', 20, 'UCE/UG/2011/17739', 'Division II'),
(180, 180, 'Ntare School', 'PLE/UG/2011/05885', 35, 'UCE/UG/2021/04518', 'Division IV'),
(181, 181, 'Greenhill Academy', 'PLE/UG/2011/05302', 30, 'UCE/UG/2010/70583', 'Division II'),
(182, 182, 'Namilyango School', 'PLE/UG/2010/30509', 14, 'UCE/UG/2020/82550', 'Division IV'),
(183, 183, 'Namilyango School', 'PLE/UG/2019/33297', 22, 'UCE/UG/2022/84963', 'Division II'),
(184, 184, 'Buddo Junior', 'PLE/UG/2013/32489', 31, 'UCE/UG/2013/80121', 'Division I'),
(185, 185, 'Ntare School', 'PLE/UG/2022/08536', 28, 'UCE/UG/2018/67822', 'Division III'),
(186, 186, 'Gayaza High School', 'PLE/UG/2010/36188', 26, 'UCE/UG/2015/91249', 'Division II'),
(187, 187, 'Buddo Junior', 'PLE/UG/2015/03912', 33, 'UCE/UG/2017/87321', 'Division IV'),
(188, 188, 'Gayaza High School', 'PLE/UG/2011/37252', 23, 'UCE/UG/2022/75926', 'Division I'),
(189, 189, 'Ntare School', 'PLE/UG/2017/26298', 28, 'UCE/UG/2011/23767', 'Division IV'),
(190, 190, 'Namilyango School', 'PLE/UG/2022/28697', 27, 'UCE/UG/2021/78231', 'Division III'),
(191, 191, 'Buddo Junior', 'PLE/UG/2013/40391', 13, 'UCE/UG/2013/29486', 'Division IV'),
(192, 192, 'Gayaza High School', 'PLE/UG/2013/57786', 5, 'UCE/UG/2017/45682', 'Division III'),
(193, 193, 'Gayaza High School', 'PLE/UG/2016/32695', 10, 'UCE/UG/2010/41301', 'Division I'),
(194, 194, 'Ntare School', 'PLE/UG/2023/41704', 11, 'UCE/UG/2022/90846', 'Division IV'),
(195, 195, 'Gayaza High School', 'PLE/UG/2020/30838', 10, 'UCE/UG/2010/52379', 'Division III'),
(196, 196, 'Greenhill Academy', 'PLE/UG/2020/28756', 10, 'UCE/UG/2012/40902', 'Division II'),
(197, 197, 'Gayaza High School', 'PLE/UG/2014/65259', 12, 'UCE/UG/2014/88343', 'Division II'),
(198, 198, 'Ntare School', 'PLE/UG/2015/61956', 33, 'UCE/UG/2020/99678', 'Division III'),
(199, 199, 'Namilyango School', 'PLE/UG/2016/93011', 8, 'UCE/UG/2023/36371', 'Division IV'),
(200, 200, 'Gayaza High School', 'PLE/UG/2015/06887', 7, 'UCE/UG/2013/05091', 'Division II'),
(201, 201, 'Ntare School', 'PLE/UG/2019/90469', 20, 'UCE/UG/2022/88574', 'Division IV'),
(202, 202, 'Namilyango School', 'PLE/UG/2022/09952', 32, 'UCE/UG/2011/86758', 'Division I'),
(203, 203, 'Gayaza High School', 'PLE/UG/2017/87296', 29, 'UCE/UG/2016/73486', 'Division II'),
(204, 204, 'Ntare School', 'PLE/UG/2012/40808', 20, 'UCE/UG/2015/46981', 'Division I'),
(205, 205, 'Buddo Junior', 'PLE/UG/2015/92536', 16, 'UCE/UG/2011/46386', 'Division IV'),
(206, 206, 'Greenhill Academy', 'PLE/UG/2013/47553', 22, 'UCE/UG/2015/38198', 'Division III'),
(207, 207, 'Gayaza High School', 'PLE/UG/2020/52084', 17, 'UCE/UG/2016/15472', 'Division II'),
(208, 208, 'Gayaza High School', 'PLE/UG/2016/75015', 12, 'UCE/UG/2010/42301', 'Division IV'),
(209, 209, 'Namilyango School', 'PLE/UG/2012/46534', 26, 'UCE/UG/2012/67181', 'Division IV'),
(210, 210, 'Ntare School', 'PLE/UG/2023/47958', 22, 'UCE/UG/2016/53592', 'Division II'),
(211, 211, 'Gayaza High School', 'PLE/UG/2016/53077', 10, 'UCE/UG/2014/19318', 'Division IV'),
(212, 212, 'Greenhill Academy', 'PLE/UG/2011/03080', 29, 'UCE/UG/2021/76345', 'Division II'),
(213, 213, 'Ntare School', 'PLE/UG/2017/11249', 4, 'UCE/UG/2021/99828', 'Division III'),
(214, 214, 'Ntare School', 'PLE/UG/2013/40567', 14, 'UCE/UG/2015/14355', 'Division II'),
(215, 215, 'Namilyango School', 'PLE/UG/2012/45684', 28, 'UCE/UG/2016/08571', 'Division IV'),
(216, 216, 'Buddo Junior', 'PLE/UG/2015/82755', 35, 'UCE/UG/2015/08524', 'Division I'),
(217, 217, 'Namilyango School', 'PLE/UG/2013/09181', 25, 'UCE/UG/2011/48491', 'Division I'),
(218, 218, 'Namilyango School', 'PLE/UG/2019/16828', 29, 'UCE/UG/2016/00542', 'Division III'),
(219, 219, 'Greenhill Academy', 'PLE/UG/2010/62917', 34, 'UCE/UG/2022/60047', 'Division II'),
(220, 220, 'Ntare School', 'PLE/UG/2017/38013', 11, 'UCE/UG/2023/13582', 'Division IV'),
(221, 221, 'Ntare School', 'PLE/UG/2023/38239', 34, 'UCE/UG/2017/91250', 'Division IV'),
(222, 222, 'Namilyango School', 'PLE/UG/2023/67395', 17, 'UCE/UG/2010/90239', 'Division II'),
(223, 223, 'Namilyango School', 'PLE/UG/2010/69025', 15, 'UCE/UG/2021/89108', 'Division I'),
(224, 224, 'Gayaza High School', 'PLE/UG/2010/96200', 29, 'UCE/UG/2010/82318', 'Division I'),
(225, 225, 'Buddo Junior', 'PLE/UG/2016/11527', 9, 'UCE/UG/2016/72632', 'Division II'),
(226, 226, 'Namilyango School', 'PLE/UG/2014/03273', 10, 'UCE/UG/2023/16710', 'Division IV'),
(227, 227, 'Namilyango School', 'PLE/UG/2023/65900', 19, 'UCE/UG/2016/74799', 'Division II'),
(228, 228, 'Gayaza High School', 'PLE/UG/2019/47049', 11, 'UCE/UG/2020/98023', 'Division III'),
(229, 229, 'Buddo Junior', 'PLE/UG/2017/55128', 9, 'UCE/UG/2013/81573', 'Division II'),
(230, 230, 'Buddo Junior', 'PLE/UG/2020/45253', 7, 'UCE/UG/2012/61336', 'Division III'),
(231, 231, 'Ntare School', 'PLE/UG/2020/10879', 13, 'UCE/UG/2012/05432', 'Division III'),
(232, 232, 'Namilyango School', 'PLE/UG/2015/26000', 10, 'UCE/UG/2013/55380', 'Division I'),
(233, 233, 'Namilyango School', 'PLE/UG/2022/28089', 30, 'UCE/UG/2013/75245', 'Division I'),
(234, 234, 'Namilyango School', 'PLE/UG/2014/51138', 20, 'UCE/UG/2010/61996', 'Division I'),
(235, 235, 'Gayaza High School', 'PLE/UG/2018/23043', 16, 'UCE/UG/2012/89032', 'Division IV'),
(236, 236, 'Namilyango School', 'PLE/UG/2012/20334', 22, 'UCE/UG/2014/71673', 'Division III'),
(237, 237, 'Gayaza High School', 'PLE/UG/2020/88664', 10, 'UCE/UG/2014/90136', 'Division III'),
(238, 238, 'Buddo Junior', 'PLE/UG/2013/18189', 10, 'UCE/UG/2016/84842', 'Division IV'),
(239, 239, 'Ntare School', 'PLE/UG/2021/75483', 16, 'UCE/UG/2019/17379', 'Division IV'),
(240, 240, 'Buddo Junior', 'PLE/UG/2021/39608', 18, 'UCE/UG/2010/94875', 'Division III'),
(241, 241, 'Namilyango School', 'PLE/UG/2010/77044', 27, 'UCE/UG/2014/35777', 'Division IV'),
(242, 242, 'Gayaza High School', 'PLE/UG/2023/19163', 4, 'UCE/UG/2017/71832', 'Division IV'),
(243, 243, 'Ntare School', 'PLE/UG/2017/31695', 5, 'UCE/UG/2013/00870', 'Division II'),
(244, 244, 'Buddo Junior', 'PLE/UG/2013/20409', 9, 'UCE/UG/2013/60869', 'Division II'),
(245, 245, 'Gayaza High School', 'PLE/UG/2016/17833', 23, 'UCE/UG/2016/58977', 'Division III'),
(246, 246, 'Buddo Junior', 'PLE/UG/2011/39997', 28, 'UCE/UG/2018/66500', 'Division III'),
(247, 247, 'Ntare School', 'PLE/UG/2011/77054', 23, 'UCE/UG/2019/61712', 'Division I'),
(248, 248, 'Gayaza High School', 'PLE/UG/2021/55135', 12, 'UCE/UG/2018/29893', 'Division III'),
(249, 249, 'Greenhill Academy', 'PLE/UG/2018/00678', 13, 'UCE/UG/2017/69407', 'Division IV'),
(250, 250, 'Ntare School', 'PLE/UG/2019/05996', 10, 'UCE/UG/2021/62149', 'Division III'),
(251, 251, 'Ntare School', 'PLE/UG/2019/04691', 11, 'UCE/UG/2011/66504', 'Division I'),
(252, 252, 'Ntare School', 'PLE/UG/2015/09920', 16, 'UCE/UG/2019/15687', 'Division IV'),
(253, 253, 'Buddo Junior', 'PLE/UG/2023/81705', 8, 'UCE/UG/2014/01155', 'Division I'),
(254, 254, 'Greenhill Academy', 'PLE/UG/2019/33811', 28, 'UCE/UG/2020/63236', 'Division IV'),
(255, 255, 'Ntare School', 'PLE/UG/2023/17125', 35, 'UCE/UG/2015/94589', 'Division III'),
(256, 256, 'Gayaza High School', 'PLE/UG/2012/65877', 29, 'UCE/UG/2010/69647', 'Division II'),
(257, 257, 'Ntare School', 'PLE/UG/2011/72815', 15, 'UCE/UG/2018/81522', 'Division II'),
(258, 258, 'Buddo Junior', 'PLE/UG/2022/71996', 31, 'UCE/UG/2011/84185', 'Division IV'),
(259, 259, 'Ntare School', 'PLE/UG/2012/03072', 25, 'UCE/UG/2014/62316', 'Division I'),
(260, 260, 'Ntare School', 'PLE/UG/2016/02831', 28, 'UCE/UG/2020/37163', 'Division III'),
(261, 261, 'Namilyango School', 'PLE/UG/2010/69123', 18, 'UCE/UG/2012/49977', 'Division IV'),
(262, 262, 'Greenhill Academy', 'PLE/UG/2016/58456', 22, 'UCE/UG/2012/10348', 'Division I'),
(263, 263, 'Gayaza High School', 'PLE/UG/2016/51235', 6, 'UCE/UG/2022/18843', 'Division II'),
(264, 264, 'Greenhill Academy', 'PLE/UG/2016/24354', 33, 'UCE/UG/2022/83671', 'Division II'),
(265, 265, 'Buddo Junior', 'PLE/UG/2014/48611', 16, 'UCE/UG/2016/24162', 'Division IV'),
(266, 266, 'Gayaza High School', 'PLE/UG/2010/95656', 28, 'UCE/UG/2010/75213', 'Division III'),
(267, 267, 'Namilyango School', 'PLE/UG/2014/36848', 33, 'UCE/UG/2017/86625', 'Division III'),
(268, 268, 'Gayaza High School', 'PLE/UG/2016/29654', 9, 'UCE/UG/2023/19517', 'Division I'),
(269, 269, 'Gayaza High School', 'PLE/UG/2019/52321', 22, 'UCE/UG/2013/66437', 'Division II'),
(270, 270, 'Namilyango School', 'PLE/UG/2012/73170', 9, 'UCE/UG/2018/60660', 'Division I'),
(271, 271, 'Namilyango School', 'PLE/UG/2013/66780', 25, 'UCE/UG/2014/49388', 'Division III'),
(272, 272, 'Greenhill Academy', 'PLE/UG/2010/35760', 28, 'UCE/UG/2020/57218', 'Division III'),
(273, 273, 'Gayaza High School', 'PLE/UG/2015/16470', 26, 'UCE/UG/2023/88613', 'Division II'),
(274, 274, 'Namilyango School', 'PLE/UG/2021/04028', 24, 'UCE/UG/2011/62064', 'Division IV'),
(275, 275, 'Namilyango School', 'PLE/UG/2022/32806', 34, 'UCE/UG/2020/06130', 'Division IV'),
(276, 276, 'Ntare School', 'PLE/UG/2019/11703', 21, 'UCE/UG/2014/00899', 'Division I'),
(277, 277, 'Namilyango School', 'PLE/UG/2018/81496', 15, 'UCE/UG/2014/48568', 'Division III'),
(278, 278, 'Namilyango School', 'PLE/UG/2013/84963', 17, 'UCE/UG/2018/76311', 'Division IV'),
(279, 279, 'Ntare School', 'PLE/UG/2016/81382', 22, 'UCE/UG/2016/52960', 'Division II'),
(280, 280, 'Namilyango School', 'PLE/UG/2014/24686', 15, 'UCE/UG/2023/94638', 'Division III'),
(281, 281, 'Ntare School', 'PLE/UG/2012/40252', 18, 'UCE/UG/2010/69198', 'Division II'),
(282, 282, 'Namilyango School', 'PLE/UG/2018/92758', 26, 'UCE/UG/2021/86290', 'Division IV'),
(283, 283, 'Gayaza High School', 'PLE/UG/2021/10818', 5, 'UCE/UG/2022/25202', 'Division III'),
(284, 284, 'Gayaza High School', 'PLE/UG/2023/23542', 10, 'UCE/UG/2014/04747', 'Division I'),
(285, 285, 'Gayaza High School', 'PLE/UG/2013/48405', 28, 'UCE/UG/2014/44667', 'Division I'),
(286, 286, 'Namilyango School', 'PLE/UG/2013/09856', 25, 'UCE/UG/2011/61448', 'Division III'),
(287, 287, 'Gayaza High School', 'PLE/UG/2016/62021', 23, 'UCE/UG/2012/04263', 'Division III'),
(288, 288, 'Ntare School', 'PLE/UG/2010/72682', 23, 'UCE/UG/2021/33625', 'Division I'),
(289, 289, 'Namilyango School', 'PLE/UG/2014/54424', 29, 'UCE/UG/2014/11409', 'Division III'),
(290, 290, 'Greenhill Academy', 'PLE/UG/2012/40321', 19, 'UCE/UG/2013/70141', 'Division IV'),
(291, 291, 'Greenhill Academy', 'PLE/UG/2010/07848', 15, 'UCE/UG/2018/85895', 'Division III'),
(292, 292, 'Ntare School', 'PLE/UG/2014/88322', 18, 'UCE/UG/2018/81629', 'Division I'),
(293, 293, 'Ntare School', 'PLE/UG/2019/89029', 17, 'UCE/UG/2015/78494', 'Division III'),
(294, 294, 'Gayaza High School', 'PLE/UG/2022/81502', 17, 'UCE/UG/2018/77965', 'Division I'),
(295, 295, 'Gayaza High School', 'PLE/UG/2016/55443', 15, 'UCE/UG/2012/80001', 'Division II'),
(296, 296, 'Buddo Junior', 'PLE/UG/2022/18948', 10, 'UCE/UG/2017/96478', 'Division II'),
(297, 297, 'Namilyango School', 'PLE/UG/2011/49686', 8, 'UCE/UG/2012/44201', 'Division III'),
(298, 298, 'Greenhill Academy', 'PLE/UG/2013/39049', 13, 'UCE/UG/2014/63325', 'Division II'),
(299, 299, 'Buddo Junior', 'PLE/UG/2021/61722', 26, 'UCE/UG/2018/87780', 'Division III'),
(300, 300, 'Buddo Junior', 'PLE/UG/2022/75123', 35, 'UCE/UG/2019/51152', 'Division II'),
(301, 301, 'Gayaza High School', 'PLE/UG/2011/74840', 17, 'UCE/UG/2022/06601', 'Division III'),
(302, 302, 'Greenhill Academy', 'PLE/UG/2014/94169', 24, 'UCE/UG/2015/98966', 'Division IV'),
(303, 303, 'Namilyango School', 'PLE/UG/2019/22747', 9, 'UCE/UG/2012/25781', 'Division IV'),
(304, 304, 'Buddo Junior', 'PLE/UG/2020/69070', 9, 'UCE/UG/2020/26568', 'Division I'),
(305, 305, 'Ntare School', 'PLE/UG/2012/32775', 4, 'UCE/UG/2011/53414', 'Division II'),
(306, 306, 'Greenhill Academy', 'PLE/UG/2021/71394', 6, 'UCE/UG/2013/88859', 'Division IV'),
(307, 307, 'Gayaza High School', 'PLE/UG/2011/78287', 23, 'UCE/UG/2018/39123', 'Division I'),
(308, 308, 'Greenhill Academy', 'PLE/UG/2021/47895', 34, 'UCE/UG/2015/02384', 'Division IV'),
(309, 309, 'Namilyango School', 'PLE/UG/2018/84182', 18, 'UCE/UG/2021/57722', 'Division III'),
(310, 310, 'Ntare School', 'PLE/UG/2013/50672', 30, 'UCE/UG/2019/80306', 'Division I'),
(311, 311, 'Ntare School', 'PLE/UG/2019/02434', 6, 'UCE/UG/2015/58049', 'Division IV'),
(312, 312, 'Ntare School', 'PLE/UG/2015/19604', 31, 'UCE/UG/2019/83404', 'Division I'),
(313, 313, 'Ntare School', 'PLE/UG/2020/33394', 20, 'UCE/UG/2017/08890', 'Division IV'),
(314, 314, 'Buddo Junior', 'PLE/UG/2019/59601', 33, 'UCE/UG/2022/57813', 'Division II'),
(315, 315, 'Greenhill Academy', 'PLE/UG/2017/24906', 23, 'UCE/UG/2015/97484', 'Division IV'),
(316, 316, 'Ntare School', 'PLE/UG/2023/32567', 29, 'UCE/UG/2010/86743', 'Division I'),
(317, 317, 'Buddo Junior', 'PLE/UG/2012/82497', 19, 'UCE/UG/2023/25194', 'Division II'),
(318, 318, 'Ntare School', 'PLE/UG/2020/48286', 8, 'UCE/UG/2014/07803', 'Division II'),
(319, 319, 'Greenhill Academy', 'PLE/UG/2020/92366', 17, 'UCE/UG/2014/50852', 'Division II'),
(320, 320, 'Gayaza High School', 'PLE/UG/2015/25876', 8, 'UCE/UG/2023/24770', 'Division II'),
(321, 321, 'Buddo Junior', 'PLE/UG/2012/90079', 4, 'UCE/UG/2015/93434', 'Division II'),
(322, 322, 'Gayaza High School', 'PLE/UG/2021/39035', 21, 'UCE/UG/2018/33251', 'Division IV'),
(323, 323, 'Greenhill Academy', 'PLE/UG/2019/53687', 26, 'UCE/UG/2021/10208', 'Division I'),
(324, 324, 'Gayaza High School', 'PLE/UG/2012/64657', 28, 'UCE/UG/2022/22055', 'Division II'),
(325, 325, 'Ntare School', 'PLE/UG/2014/01982', 7, 'UCE/UG/2016/11768', 'Division I'),
(326, 326, 'Greenhill Academy', 'PLE/UG/2014/51350', 25, 'UCE/UG/2022/27775', 'Division IV'),
(327, 327, 'Gayaza High School', 'PLE/UG/2010/88875', 18, 'UCE/UG/2017/36973', 'Division I'),
(328, 328, 'Gayaza High School', 'PLE/UG/2013/41495', 17, 'UCE/UG/2021/96995', 'Division II'),
(329, 329, 'Gayaza High School', 'PLE/UG/2021/96824', 15, 'UCE/UG/2021/07036', 'Division IV'),
(330, 330, 'Greenhill Academy', 'PLE/UG/2013/42176', 13, 'UCE/UG/2013/31616', 'Division IV'),
(331, 331, 'Namilyango School', 'PLE/UG/2016/23865', 30, 'UCE/UG/2015/48601', 'Division II'),
(332, 332, 'Greenhill Academy', 'PLE/UG/2017/17345', 12, 'UCE/UG/2020/96173', 'Division III'),
(333, 333, 'Ntare School', 'PLE/UG/2023/18308', 33, 'UCE/UG/2011/87003', 'Division IV'),
(334, 334, 'Ntare School', 'PLE/UG/2011/81768', 31, 'UCE/UG/2021/51127', 'Division I'),
(335, 335, 'Buddo Junior', 'PLE/UG/2016/23767', 27, 'UCE/UG/2023/66047', 'Division II'),
(336, 336, 'Namilyango School', 'PLE/UG/2012/46619', 29, 'UCE/UG/2017/34838', 'Division I'),
(337, 337, 'Namilyango School', 'PLE/UG/2019/98500', 29, 'UCE/UG/2010/64812', 'Division I'),
(338, 338, 'Buddo Junior', 'PLE/UG/2019/52494', 20, 'UCE/UG/2023/15339', 'Division IV'),
(339, 339, 'Gayaza High School', 'PLE/UG/2013/39033', 13, 'UCE/UG/2013/36748', 'Division I'),
(340, 340, 'Ntare School', 'PLE/UG/2011/90550', 11, 'UCE/UG/2015/33130', 'Division II'),
(341, 341, 'Greenhill Academy', 'PLE/UG/2016/23069', 30, 'UCE/UG/2016/81112', 'Division III'),
(342, 342, 'Ntare School', 'PLE/UG/2011/73924', 16, 'UCE/UG/2020/49684', 'Division II'),
(343, 343, 'Buddo Junior', 'PLE/UG/2012/96251', 10, 'UCE/UG/2011/96351', 'Division II'),
(344, 344, 'Ntare School', 'PLE/UG/2018/25660', 22, 'UCE/UG/2010/62197', 'Division IV'),
(345, 345, 'Gayaza High School', 'PLE/UG/2020/05779', 34, 'UCE/UG/2018/28991', 'Division III'),
(346, 346, 'Namilyango School', 'PLE/UG/2022/49693', 26, 'UCE/UG/2011/29112', 'Division I'),
(347, 347, 'Greenhill Academy', 'PLE/UG/2016/66984', 32, 'UCE/UG/2016/51848', 'Division II'),
(348, 348, 'Greenhill Academy', 'PLE/UG/2010/83031', 4, 'UCE/UG/2017/63931', 'Division III'),
(349, 349, 'Ntare School', 'PLE/UG/2010/91464', 19, 'UCE/UG/2019/97075', 'Division IV'),
(350, 350, 'Greenhill Academy', 'PLE/UG/2018/27478', 24, 'UCE/UG/2015/89863', 'Division II'),
(351, 351, 'Greenhill Academy', 'PLE/UG/2011/50488', 13, 'UCE/UG/2023/00307', 'Division I'),
(352, 352, 'Greenhill Academy', 'PLE/UG/2022/85124', 23, 'UCE/UG/2016/53233', 'Division II'),
(353, 353, 'Greenhill Academy', 'PLE/UG/2023/35474', 29, 'UCE/UG/2023/45270', 'Division II'),
(354, 354, 'Gayaza High School', 'PLE/UG/2013/41447', 13, 'UCE/UG/2012/15422', 'Division I'),
(355, 355, 'Greenhill Academy', 'PLE/UG/2022/98672', 11, 'UCE/UG/2013/56020', 'Division I'),
(356, 356, 'Ntare School', 'PLE/UG/2018/44745', 17, 'UCE/UG/2019/22933', 'Division I'),
(357, 357, 'Namilyango School', 'PLE/UG/2011/25292', 33, 'UCE/UG/2021/22563', 'Division IV'),
(358, 358, 'Ntare School', 'PLE/UG/2016/68105', 5, 'UCE/UG/2013/14979', 'Division IV'),
(359, 359, 'Buddo Junior', 'PLE/UG/2020/62415', 34, 'UCE/UG/2021/28838', 'Division IV'),
(360, 360, 'Gayaza High School', 'PLE/UG/2012/73267', 8, 'UCE/UG/2017/30631', 'Division IV'),
(361, 361, 'Ntare School', 'PLE/UG/2018/35805', 5, 'UCE/UG/2013/96557', 'Division I'),
(362, 362, 'Buddo Junior', 'PLE/UG/2016/98305', 21, 'UCE/UG/2020/97781', 'Division III'),
(363, 363, 'Ntare School', 'PLE/UG/2010/95895', 24, 'UCE/UG/2014/61376', 'Division I'),
(364, 364, 'Gayaza High School', 'PLE/UG/2021/20909', 21, 'UCE/UG/2011/03941', 'Division IV'),
(365, 365, 'Namilyango School', 'PLE/UG/2010/54692', 27, 'UCE/UG/2023/76347', 'Division IV'),
(366, 366, 'Namilyango School', 'PLE/UG/2017/55413', 6, 'UCE/UG/2020/51761', 'Division II'),
(367, 367, 'Namilyango School', 'PLE/UG/2020/06529', 8, 'UCE/UG/2018/43017', 'Division II'),
(368, 368, 'Namilyango School', 'PLE/UG/2023/49712', 21, 'UCE/UG/2012/37109', 'Division II'),
(369, 369, 'Buddo Junior', 'PLE/UG/2021/39509', 18, 'UCE/UG/2010/95756', 'Division III'),
(370, 370, 'Gayaza High School', 'PLE/UG/2021/06109', 32, 'UCE/UG/2013/67016', 'Division III'),
(371, 371, 'Buddo Junior', 'PLE/UG/2016/00930', 27, 'UCE/UG/2017/67722', 'Division III'),
(372, 372, 'Greenhill Academy', 'PLE/UG/2018/13998', 31, 'UCE/UG/2022/91360', 'Division IV'),
(373, 373, 'Gayaza High School', 'PLE/UG/2017/81750', 20, 'UCE/UG/2011/97055', 'Division III'),
(374, 374, 'Buddo Junior', 'PLE/UG/2020/83252', 30, 'UCE/UG/2018/43136', 'Division II'),
(375, 375, 'Greenhill Academy', 'PLE/UG/2010/84724', 4, 'UCE/UG/2018/81614', 'Division II'),
(376, 376, 'Gayaza High School', 'PLE/UG/2021/11841', 11, 'UCE/UG/2020/14556', 'Division II'),
(377, 377, 'Buddo Junior', 'PLE/UG/2022/35346', 4, 'UCE/UG/2023/90583', 'Division III'),
(378, 378, 'Buddo Junior', 'PLE/UG/2015/57922', 30, 'UCE/UG/2015/43418', 'Division I'),
(379, 379, 'Buddo Junior', 'PLE/UG/2017/68360', 30, 'UCE/UG/2011/93519', 'Division II'),
(380, 380, 'Buddo Junior', 'PLE/UG/2023/84911', 12, 'UCE/UG/2020/91979', 'Division II'),
(381, 381, 'Gayaza High School', 'PLE/UG/2023/93152', 25, 'UCE/UG/2017/71599', 'Division IV'),
(382, 382, 'Buddo Junior', 'PLE/UG/2019/31871', 19, 'UCE/UG/2016/93763', 'Division I'),
(383, 383, 'Gayaza High School', 'PLE/UG/2019/12980', 26, 'UCE/UG/2011/41909', 'Division IV'),
(384, 384, 'Buddo Junior', 'PLE/UG/2010/70489', 19, 'UCE/UG/2013/82096', 'Division II'),
(385, 385, 'Greenhill Academy', 'PLE/UG/2017/93889', 6, 'UCE/UG/2018/84349', 'Division II'),
(386, 386, 'Greenhill Academy', 'PLE/UG/2019/56092', 29, 'UCE/UG/2014/27666', 'Division II'),
(387, 387, 'Buddo Junior', 'PLE/UG/2014/73167', 24, 'UCE/UG/2010/26521', 'Division I'),
(388, 388, 'Gayaza High School', 'PLE/UG/2011/86241', 35, 'UCE/UG/2015/00648', 'Division IV'),
(389, 389, 'Gayaza High School', 'PLE/UG/2022/42370', 18, 'UCE/UG/2023/51826', 'Division III'),
(390, 390, 'Buddo Junior', 'PLE/UG/2023/85386', 12, 'UCE/UG/2021/33247', 'Division I'),
(391, 391, 'Gayaza High School', 'PLE/UG/2021/46434', 29, 'UCE/UG/2017/36999', 'Division I'),
(392, 392, 'Greenhill Academy', 'PLE/UG/2010/45942', 12, 'UCE/UG/2023/07659', 'Division II'),
(393, 393, 'Gayaza High School', 'PLE/UG/2021/46287', 29, 'UCE/UG/2017/44109', 'Division III'),
(394, 394, 'Namilyango School', 'PLE/UG/2016/15319', 17, 'UCE/UG/2019/09461', 'Division II'),
(395, 395, 'Ntare School', 'PLE/UG/2017/98589', 17, 'UCE/UG/2011/21311', 'Division IV'),
(396, 396, 'Buddo Junior', 'PLE/UG/2017/85912', 24, 'UCE/UG/2019/35006', 'Division IV'),
(397, 397, 'Greenhill Academy', 'PLE/UG/2010/32222', 22, 'UCE/UG/2023/09927', 'Division III'),
(398, 398, 'Namilyango School', 'PLE/UG/2021/03987', 25, 'UCE/UG/2014/48865', 'Division III'),
(399, 399, 'Namilyango School', 'PLE/UG/2016/97577', 17, 'UCE/UG/2011/40009', 'Division III'),
(400, 400, 'Buddo Junior', 'PLE/UG/2011/24626', 32, 'UCE/UG/2021/23212', 'Division IV'),
(401, 401, 'Gayaza High School', 'PLE/UG/2020/24435', 32, 'UCE/UG/2020/00524', 'Division IV'),
(402, 402, 'Gayaza High School', 'PLE/UG/2010/37303', 31, 'UCE/UG/2012/37728', 'Division II'),
(403, 403, 'Buddo Junior', 'PLE/UG/2018/08670', 22, 'UCE/UG/2018/41082', 'Division I'),
(404, 404, 'Gayaza High School', 'PLE/UG/2020/96008', 24, 'UCE/UG/2013/41978', 'Division II'),
(405, 405, 'Greenhill Academy', 'PLE/UG/2023/91562', 27, 'UCE/UG/2022/14546', 'Division I'),
(406, 406, 'Namilyango School', 'PLE/UG/2014/71223', 20, 'UCE/UG/2015/52803', 'Division II'),
(407, 407, 'Greenhill Academy', 'PLE/UG/2011/00254', 25, 'UCE/UG/2014/75006', 'Division III'),
(408, 408, 'Buddo Junior', 'PLE/UG/2020/48495', 8, 'UCE/UG/2013/96171', 'Division IV'),
(409, 409, 'Buddo Junior', 'PLE/UG/2015/76831', 28, 'UCE/UG/2016/03353', 'Division IV'),
(410, 410, 'Ntare School', 'PLE/UG/2022/30869', 30, 'UCE/UG/2013/68620', 'Division III'),
(411, 411, 'Namilyango School', 'PLE/UG/2012/33436', 10, 'UCE/UG/2023/30181', 'Division III'),
(412, 412, 'Namilyango School', 'PLE/UG/2017/47041', 28, 'UCE/UG/2015/82390', 'Division IV'),
(413, 413, 'Buddo Junior', 'PLE/UG/2013/14644', 6, 'UCE/UG/2022/40385', 'Division I'),
(414, 414, 'Greenhill Academy', 'PLE/UG/2010/58749', 27, 'UCE/UG/2023/53604', 'Division IV'),
(415, 415, 'Namilyango School', 'PLE/UG/2022/90830', 31, 'UCE/UG/2018/34322', 'Division IV'),
(416, 416, 'Gayaza High School', 'PLE/UG/2019/45043', 8, 'UCE/UG/2015/37171', 'Division IV'),
(417, 417, 'Namilyango School', 'PLE/UG/2023/50257', 23, 'UCE/UG/2018/10559', 'Division III'),
(418, 418, 'Gayaza High School', 'PLE/UG/2010/37320', 27, 'UCE/UG/2017/57911', 'Division I'),
(419, 419, 'Ntare School', 'PLE/UG/2011/67188', 8, 'UCE/UG/2019/98838', 'Division IV'),
(420, 420, 'Namilyango School', 'PLE/UG/2012/74511', 12, 'UCE/UG/2011/63769', 'Division IV'),
(421, 421, 'Namilyango School', 'PLE/UG/2017/35300', 6, 'UCE/UG/2014/32598', 'Division III'),
(422, 422, 'Namilyango School', 'PLE/UG/2016/86901', 35, 'UCE/UG/2014/57881', 'Division IV'),
(423, 423, 'Greenhill Academy', 'PLE/UG/2011/91963', 9, 'UCE/UG/2011/95935', 'Division III'),
(424, 424, 'Greenhill Academy', 'PLE/UG/2021/08206', 4, 'UCE/UG/2022/29598', 'Division IV'),
(425, 425, 'Ntare School', 'PLE/UG/2010/59830', 32, 'UCE/UG/2020/93761', 'Division II'),
(426, 426, 'Ntare School', 'PLE/UG/2023/99140', 7, 'UCE/UG/2017/46943', 'Division III'),
(427, 427, 'Ntare School', 'PLE/UG/2012/29060', 4, 'UCE/UG/2011/68370', 'Division I'),
(428, 428, 'Ntare School', 'PLE/UG/2018/60617', 9, 'UCE/UG/2010/67363', 'Division II'),
(429, 429, 'Gayaza High School', 'PLE/UG/2013/49379', 25, 'UCE/UG/2022/58166', 'Division I'),
(430, 430, 'Gayaza High School', 'PLE/UG/2016/10965', 9, 'UCE/UG/2017/26347', 'Division III'),
(431, 431, 'Buddo Junior', 'PLE/UG/2018/13505', 29, 'UCE/UG/2017/16368', 'Division II'),
(432, 432, 'Buddo Junior', 'PLE/UG/2011/45949', 5, 'UCE/UG/2022/36868', 'Division I'),
(433, 433, 'Ntare School', 'PLE/UG/2021/36609', 18, 'UCE/UG/2012/58971', 'Division II'),
(434, 434, 'Greenhill Academy', 'PLE/UG/2012/24813', 28, 'UCE/UG/2011/33126', 'Division II'),
(435, 435, 'Ntare School', 'PLE/UG/2020/17796', 26, 'UCE/UG/2010/02178', 'Division I'),
(436, 436, 'Gayaza High School', 'PLE/UG/2021/41766', 23, 'UCE/UG/2021/39758', 'Division II'),
(437, 437, 'Gayaza High School', 'PLE/UG/2020/74327', 19, 'UCE/UG/2012/44441', 'Division III'),
(438, 438, 'Buddo Junior', 'PLE/UG/2022/56255', 8, 'UCE/UG/2023/56420', 'Division IV'),
(439, 439, 'Buddo Junior', 'PLE/UG/2015/54063', 24, 'UCE/UG/2017/72350', 'Division I'),
(440, 440, 'Greenhill Academy', 'PLE/UG/2010/87778', 10, 'UCE/UG/2016/52185', 'Division II'),
(441, 441, 'Ntare School', 'PLE/UG/2011/95268', 19, 'UCE/UG/2018/69886', 'Division III'),
(442, 442, 'Namilyango School', 'PLE/UG/2018/90165', 23, 'UCE/UG/2014/66639', 'Division II'),
(443, 443, 'Ntare School', 'PLE/UG/2017/55206', 6, 'UCE/UG/2019/34395', 'Division III'),
(444, 444, 'Buddo Junior', 'PLE/UG/2013/02637', 13, 'UCE/UG/2016/25952', 'Division IV'),
(445, 445, 'Gayaza High School', 'PLE/UG/2013/37824', 5, 'UCE/UG/2011/40027', 'Division III'),
(446, 446, 'Greenhill Academy', 'PLE/UG/2014/75685', 30, 'UCE/UG/2021/64093', 'Division III'),
(447, 447, 'Gayaza High School', 'PLE/UG/2021/47495', 32, 'UCE/UG/2023/21479', 'Division I'),
(448, 448, 'Buddo Junior', 'PLE/UG/2018/28805', 20, 'UCE/UG/2020/21163', 'Division IV'),
(449, 449, 'Buddo Junior', 'PLE/UG/2019/67462', 11, 'UCE/UG/2012/16168', 'Division II'),
(450, 450, 'Namilyango School', 'PLE/UG/2021/90387', 35, 'UCE/UG/2011/79980', 'Division III'),
(451, 451, 'Namilyango School', 'PLE/UG/2021/41538', 25, 'UCE/UG/2011/64735', 'Division IV'),
(452, 452, 'Greenhill Academy', 'PLE/UG/2019/44599', 11, 'UCE/UG/2022/74726', 'Division I'),
(453, 453, 'Namilyango School', 'PLE/UG/2021/71178', 8, 'UCE/UG/2017/39625', 'Division II'),
(454, 454, 'Namilyango School', 'PLE/UG/2013/29966', 24, 'UCE/UG/2014/66223', 'Division II'),
(455, 455, 'Gayaza High School', 'PLE/UG/2014/83676', 13, 'UCE/UG/2023/88188', 'Division III'),
(456, 456, 'Gayaza High School', 'PLE/UG/2020/50036', 13, 'UCE/UG/2023/00354', 'Division I'),
(457, 457, 'Greenhill Academy', 'PLE/UG/2011/86431', 6, 'UCE/UG/2021/77696', 'Division II'),
(458, 458, 'Namilyango School', 'PLE/UG/2014/43430', 13, 'UCE/UG/2012/92314', 'Division I'),
(459, 459, 'Buddo Junior', 'PLE/UG/2013/78113', 11, 'UCE/UG/2020/10042', 'Division I'),
(460, 460, 'Ntare School', 'PLE/UG/2010/81000', 31, 'UCE/UG/2022/86179', 'Division III'),
(461, 461, 'Gayaza High School', 'PLE/UG/2012/72393', 6, 'UCE/UG/2013/10210', 'Division III'),
(462, 462, 'Ntare School', 'PLE/UG/2012/59772', 18, 'UCE/UG/2016/83078', 'Division IV'),
(463, 463, 'Ntare School', 'PLE/UG/2015/15090', 25, 'UCE/UG/2022/39305', 'Division II'),
(464, 464, 'Gayaza High School', 'PLE/UG/2022/19424', 14, 'UCE/UG/2011/61170', 'Division III'),
(465, 465, 'Buddo Junior', 'PLE/UG/2017/68249', 32, 'UCE/UG/2014/05785', 'Division II'),
(466, 466, 'Buddo Junior', 'PLE/UG/2016/28211', 34, 'UCE/UG/2022/65815', 'Division III'),
(467, 467, 'Ntare School', 'PLE/UG/2015/30561', 12, 'UCE/UG/2016/53135', 'Division I'),
(468, 468, 'Greenhill Academy', 'PLE/UG/2018/17410', 7, 'UCE/UG/2023/54342', 'Division IV'),
(469, 469, 'Gayaza High School', 'PLE/UG/2015/01559', 35, 'UCE/UG/2022/38261', 'Division II'),
(470, 470, 'Namilyango School', 'PLE/UG/2023/36864', 32, 'UCE/UG/2014/04103', 'Division I'),
(471, 471, 'Gayaza High School', 'PLE/UG/2011/36544', 20, 'UCE/UG/2016/71398', 'Division I'),
(472, 472, 'Buddo Junior', 'PLE/UG/2021/86056', 32, 'UCE/UG/2023/01551', 'Division I'),
(473, 473, 'Namilyango School', 'PLE/UG/2011/94591', 19, 'UCE/UG/2017/40960', 'Division II'),
(474, 474, 'Namilyango School', 'PLE/UG/2016/27879', 32, 'UCE/UG/2019/75312', 'Division III'),
(475, 475, 'Gayaza High School', 'PLE/UG/2011/83373', 32, 'UCE/UG/2010/38747', 'Division IV'),
(476, 476, 'Greenhill Academy', 'PLE/UG/2010/14748', 26, 'UCE/UG/2011/29277', 'Division I'),
(477, 477, 'Ntare School', 'PLE/UG/2010/74765', 21, 'UCE/UG/2017/06149', 'Division III'),
(478, 478, 'Ntare School', 'PLE/UG/2016/83994', 31, 'UCE/UG/2021/56328', 'Division II'),
(479, 479, 'Buddo Junior', 'PLE/UG/2016/22705', 28, 'UCE/UG/2012/48451', 'Division IV'),
(480, 480, 'Buddo Junior', 'PLE/UG/2018/09620', 23, 'UCE/UG/2019/76733', 'Division III'),
(481, 481, 'Namilyango School', 'PLE/UG/2022/94647', 4, 'UCE/UG/2013/06311', 'Division III'),
(482, 482, 'Ntare School', 'PLE/UG/2010/57581', 26, 'UCE/UG/2021/09458', 'Division IV'),
(483, 483, 'Gayaza High School', 'PLE/UG/2016/49850', 35, 'UCE/UG/2016/47274', 'Division IV'),
(484, 484, 'Buddo Junior', 'PLE/UG/2023/05633', 14, 'UCE/UG/2016/25336', 'Division IV'),
(485, 485, 'Ntare School', 'PLE/UG/2021/55464', 13, 'UCE/UG/2022/54085', 'Division I'),
(486, 486, 'Gayaza High School', 'PLE/UG/2010/01793', 5, 'UCE/UG/2011/43824', 'Division IV'),
(487, 487, 'Greenhill Academy', 'PLE/UG/2023/11568', 26, 'UCE/UG/2012/71274', 'Division I'),
(488, 488, 'Gayaza High School', 'PLE/UG/2012/99752', 18, 'UCE/UG/2013/04675', 'Division II'),
(489, 489, 'Greenhill Academy', 'PLE/UG/2023/20051', 6, 'UCE/UG/2021/95006', 'Division I'),
(490, 490, 'Ntare School', 'PLE/UG/2016/65722', 32, 'UCE/UG/2016/52673', 'Division II'),
(491, 491, 'Namilyango School', 'PLE/UG/2013/26252', 20, 'UCE/UG/2020/25014', 'Division IV'),
(492, 492, 'Namilyango School', 'PLE/UG/2012/83612', 24, 'UCE/UG/2020/85693', 'Division IV'),
(493, 493, 'Ntare School', 'PLE/UG/2013/65345', 23, 'UCE/UG/2011/57008', 'Division III'),
(494, 494, 'Greenhill Academy', 'PLE/UG/2010/15696', 27, 'UCE/UG/2011/49797', 'Division I'),
(495, 495, 'Gayaza High School', 'PLE/UG/2020/80227', 31, 'UCE/UG/2023/04854', 'Division II'),
(496, 496, 'Buddo Junior', 'PLE/UG/2017/35367', 8, 'UCE/UG/2019/00673', 'Division IV'),
(497, 497, 'Buddo Junior', 'PLE/UG/2023/82678', 14, 'UCE/UG/2012/05258', 'Division III'),
(498, 498, 'Namilyango School', 'PLE/UG/2014/04921', 14, 'UCE/UG/2016/41732', 'Division III'),
(499, 499, 'Buddo Junior', 'PLE/UG/2016/23398', 30, 'UCE/UG/2015/58062', 'Division III'),
(500, 500, 'Greenhill Academy', 'PLE/UG/2020/22699', 29, 'UCE/UG/2013/04850', 'Division II'),
(501, 501, 'Greenhill Academy', 'PLE/UG/2016/69323', 5, 'UCE/UG/2011/41741', 'Division IV'),
(502, 502, 'Buddo Junior', 'PLE/UG/2010/96041', 25, 'UCE/UG/2016/18223', 'Division III'),
(503, 503, 'Gayaza High School', 'PLE/UG/2012/83495', 27, 'UCE/UG/2013/89204', 'Division IV'),
(504, 504, 'Namilyango School', 'PLE/UG/2017/26689', 29, 'UCE/UG/2013/78255', 'Division I'),
(505, 505, 'Gayaza High School', 'PLE/UG/2014/63424', 9, 'UCE/UG/2022/09338', 'Division III'),
(506, 506, 'Buddo Junior', 'PLE/UG/2021/98703', 18, 'UCE/UG/2013/94744', 'Division IV'),
(507, 507, 'Greenhill Academy', 'PLE/UG/2022/75039', 6, 'UCE/UG/2012/51046', 'Division I'),
(508, 508, 'Ntare School', 'PLE/UG/2020/18112', 28, 'UCE/UG/2013/84370', 'Division III'),
(509, 509, 'Buddo Junior', 'PLE/UG/2011/40050', 25, 'UCE/UG/2013/02476', 'Division II'),
(510, 510, 'Namilyango School', 'PLE/UG/2023/62912', 14, 'UCE/UG/2021/02853', 'Division III'),
(511, 511, 'Greenhill Academy', 'PLE/UG/2010/24027', 10, 'UCE/UG/2013/71403', 'Division IV'),
(512, 512, 'Greenhill Academy', 'PLE/UG/2010/41463', 34, 'UCE/UG/2018/06622', 'Division III'),
(513, 513, 'Greenhill Academy', 'PLE/UG/2014/68381', 17, 'UCE/UG/2010/83384', 'Division I'),
(514, 514, 'Greenhill Academy', 'PLE/UG/2018/27355', 23, 'UCE/UG/2013/45298', 'Division II'),
(515, 515, 'Namilyango School', 'PLE/UG/2017/43176', 20, 'UCE/UG/2014/00010', 'Division I'),
(516, 516, 'Greenhill Academy', 'PLE/UG/2010/50637', 14, 'UCE/UG/2011/41671', 'Division IV'),
(517, 517, 'Buddo Junior', 'PLE/UG/2017/82050', 18, 'UCE/UG/2020/34481', 'Division III'),
(518, 518, 'Greenhill Academy', 'PLE/UG/2021/51476', 6, 'UCE/UG/2022/08414', 'Division IV'),
(519, 519, 'Greenhill Academy', 'PLE/UG/2018/42105', 13, 'UCE/UG/2012/14992', 'Division I'),
(520, 520, 'Gayaza High School', 'PLE/UG/2022/58038', 10, 'UCE/UG/2014/06293', 'Division II'),
(521, 521, 'Greenhill Academy', 'PLE/UG/2018/99305', 10, 'UCE/UG/2010/43097', 'Division I'),
(522, 522, 'Buddo Junior', 'PLE/UG/2015/15201', 19, 'UCE/UG/2023/33956', 'Division IV'),
(523, 523, 'Greenhill Academy', 'PLE/UG/2016/67591', 4, 'UCE/UG/2011/49802', 'Division I'),
(524, 524, 'Gayaza High School', 'PLE/UG/2017/18502', 10, 'UCE/UG/2017/95374', 'Division I'),
(525, 525, 'Gayaza High School', 'PLE/UG/2016/52773', 12, 'UCE/UG/2020/05715', 'Division IV'),
(526, 526, 'Buddo Junior', 'PLE/UG/2011/44432', 34, 'UCE/UG/2015/26335', 'Division I'),
(527, 527, 'Ntare School', 'PLE/UG/2019/90449', 19, 'UCE/UG/2020/21265', 'Division IV'),
(528, 528, 'Greenhill Academy', 'PLE/UG/2021/65790', 30, 'UCE/UG/2011/10343', 'Division I'),
(529, 529, 'Gayaza High School', 'PLE/UG/2018/17552', 35, 'UCE/UG/2016/19505', 'Division III'),
(530, 530, 'Namilyango School', 'PLE/UG/2021/16190', 11, 'UCE/UG/2020/04876', 'Division IV'),
(531, 531, 'Ntare School', 'PLE/UG/2015/10115', 15, 'UCE/UG/2018/73238', 'Division IV'),
(532, 532, 'Namilyango School', 'PLE/UG/2021/86889', 31, 'UCE/UG/2019/95057', 'Division III'),
(533, 533, 'Ntare School', 'PLE/UG/2021/39751', 22, 'UCE/UG/2020/01083', 'Division IV'),
(534, 534, 'Ntare School', 'PLE/UG/2013/73476', 33, 'UCE/UG/2016/39103', 'Division III'),
(535, 535, 'Gayaza High School', 'PLE/UG/2019/33242', 25, 'UCE/UG/2014/61274', 'Division I'),
(536, 536, 'Ntare School', 'PLE/UG/2022/79431', 13, 'UCE/UG/2011/48923', 'Division I'),
(537, 537, 'Ntare School', 'PLE/UG/2010/84798', 9, 'UCE/UG/2013/84004', 'Division II'),
(538, 538, 'Greenhill Academy', 'PLE/UG/2020/96502', 24, 'UCE/UG/2014/72636', 'Division III'),
(539, 539, 'Greenhill Academy', 'PLE/UG/2011/92635', 16, 'UCE/UG/2012/66969', 'Division IV'),
(540, 540, 'Greenhill Academy', 'PLE/UG/2015/17169', 27, 'UCE/UG/2012/65006', 'Division III'),
(541, 541, 'Gayaza High School', 'PLE/UG/2013/01270', 17, 'UCE/UG/2010/87508', 'Division II'),
(542, 542, 'Gayaza High School', 'PLE/UG/2019/79762', 31, 'UCE/UG/2022/91485', 'Division IV'),
(543, 543, 'Namilyango School', 'PLE/UG/2022/95913', 9, 'UCE/UG/2022/08761', 'Division III'),
(544, 544, 'Greenhill Academy', 'PLE/UG/2020/16264', 20, 'UCE/UG/2011/96242', 'Division III'),
(545, 545, 'Ntare School', 'PLE/UG/2018/78174', 6, 'UCE/UG/2011/13402', 'Division II'),
(546, 546, 'Gayaza High School', 'PLE/UG/2015/06557', 8, 'UCE/UG/2017/34163', 'Division I'),
(547, 547, 'Gayaza High School', 'PLE/UG/2013/23832', 20, 'UCE/UG/2021/49211', 'Division I'),
(548, 548, 'Namilyango School', 'PLE/UG/2015/74495', 20, 'UCE/UG/2014/16545', 'Division IV'),
(549, 549, 'Namilyango School', 'PLE/UG/2014/24775', 12, 'UCE/UG/2018/31643', 'Division III'),
(550, 550, 'Greenhill Academy', 'PLE/UG/2022/85211', 24, 'UCE/UG/2019/43392', 'Division I'),
(551, 551, 'Gayaza High School', 'PLE/UG/2017/93819', 35, 'UCE/UG/2011/69500', 'Division I'),
(552, 552, 'Namilyango School', 'PLE/UG/2014/13256', 25, 'UCE/UG/2022/47561', 'Division III'),
(553, 553, 'Buddo Junior', 'PLE/UG/2016/47303', 35, 'UCE/UG/2017/59504', 'Division II'),
(554, 554, 'Namilyango School', 'PLE/UG/2018/54543', 4, 'UCE/UG/2015/99595', 'Division IV'),
(555, 555, 'Namilyango School', 'PLE/UG/2017/29083', 29, 'UCE/UG/2011/04162', 'Division IV');
INSERT INTO `academichistory` (`HistoryID`, `AdmissionNo`, `FormerSchool`, `PLEIndexNumber`, `PLEAggregate`, `UCEIndexNumber`, `UCEResult`) VALUES
(556, 556, 'Gayaza High School', 'PLE/UG/2022/42773', 19, 'UCE/UG/2012/49414', 'Division IV'),
(557, 557, 'Namilyango School', 'PLE/UG/2020/64008', 34, 'UCE/UG/2020/03121', 'Division IV'),
(558, 558, 'Greenhill Academy', 'PLE/UG/2016/49539', 7, 'UCE/UG/2010/92446', 'Division II'),
(559, 559, 'Greenhill Academy', 'PLE/UG/2014/00501', 6, 'UCE/UG/2014/46125', 'Division II'),
(560, 560, 'Gayaza High School', 'PLE/UG/2020/76683', 25, 'UCE/UG/2010/10670', 'Division II'),
(561, 561, 'Buddo Junior', 'PLE/UG/2022/17032', 11, 'UCE/UG/2019/70063', 'Division II'),
(562, 562, 'Gayaza High School', 'PLE/UG/2018/26648', 20, 'UCE/UG/2021/39240', 'Division III'),
(563, 563, 'Buddo Junior', 'PLE/UG/2020/27672', 10, 'UCE/UG/2013/64050', 'Division II'),
(564, 564, 'Namilyango School', 'PLE/UG/2013/77590', 6, 'UCE/UG/2011/36576', 'Division II'),
(565, 565, 'Greenhill Academy', 'PLE/UG/2018/49776', 24, 'UCE/UG/2019/52352', 'Division III'),
(566, 566, 'Gayaza High School', 'PLE/UG/2011/87273', 5, 'UCE/UG/2018/88763', 'Division III'),
(567, 567, 'Greenhill Academy', 'PLE/UG/2021/55873', 11, 'UCE/UG/2016/52990', 'Division II'),
(568, 568, 'Greenhill Academy', 'PLE/UG/2019/76240', 25, 'UCE/UG/2011/35301', 'Division III'),
(569, 569, 'Buddo Junior', 'PLE/UG/2013/98509', 11, 'UCE/UG/2012/08506', 'Division IV'),
(570, 570, 'Namilyango School', 'PLE/UG/2019/97680', 33, 'UCE/UG/2019/73033', 'Division III'),
(571, 571, 'Gayaza High School', 'PLE/UG/2014/95506', 26, 'UCE/UG/2019/17680', 'Division IV'),
(572, 572, 'Namilyango School', 'PLE/UG/2018/90198', 24, 'UCE/UG/2017/71990', 'Division I'),
(573, 573, 'Greenhill Academy', 'PLE/UG/2019/54751', 29, 'UCE/UG/2015/44301', 'Division I'),
(574, 574, 'Ntare School', 'PLE/UG/2014/96535', 34, 'UCE/UG/2022/65795', 'Division III'),
(575, 575, 'Greenhill Academy', 'PLE/UG/2011/67091', 35, 'UCE/UG/2023/82768', 'Division II'),
(576, 576, 'Ntare School', 'PLE/UG/2022/82097', 20, 'UCE/UG/2012/23133', 'Division III'),
(577, 577, 'Gayaza High School', 'PLE/UG/2012/35840', 9, 'UCE/UG/2020/16083', 'Division III'),
(578, 578, 'Gayaza High School', 'PLE/UG/2014/88486', 17, 'UCE/UG/2017/34105', 'Division I'),
(579, 579, 'Buddo Junior', 'PLE/UG/2018/87336', 23, 'UCE/UG/2015/15354', 'Division III'),
(580, 580, 'Ntare School', 'PLE/UG/2015/81687', 30, 'UCE/UG/2018/74300', 'Division IV'),
(581, 581, 'Ntare School', 'PLE/UG/2019/69004', 18, 'UCE/UG/2012/41792', 'Division III'),
(582, 582, 'Buddo Junior', 'PLE/UG/2012/90639', 35, 'UCE/UG/2012/01121', 'Division II'),
(583, 583, 'Ntare School', 'PLE/UG/2012/06922', 32, 'UCE/UG/2012/22113', 'Division III'),
(584, 584, 'Ntare School', 'PLE/UG/2017/23871', 22, 'UCE/UG/2012/03664', 'Division III'),
(585, 585, 'Greenhill Academy', 'PLE/UG/2012/97352', 14, 'UCE/UG/2019/30476', 'Division III'),
(586, 586, 'Gayaza High School', 'PLE/UG/2013/17345', 6, 'UCE/UG/2022/11872', 'Division IV'),
(587, 587, 'Greenhill Academy', 'PLE/UG/2017/24197', 23, 'UCE/UG/2014/86117', 'Division II'),
(588, 588, 'Buddo Junior', 'PLE/UG/2014/22990', 12, 'UCE/UG/2019/57949', 'Division IV'),
(589, 589, 'Greenhill Academy', 'PLE/UG/2020/23652', 30, 'UCE/UG/2015/64413', 'Division IV'),
(590, 590, 'Buddo Junior', 'PLE/UG/2021/62953', 28, 'UCE/UG/2022/11060', 'Division IV'),
(591, 591, 'Ntare School', 'PLE/UG/2020/33598', 18, 'UCE/UG/2013/94003', 'Division IV'),
(592, 592, 'Ntare School', 'PLE/UG/2014/80704', 7, 'UCE/UG/2011/26978', 'Division IV'),
(593, 593, 'Buddo Junior', 'PLE/UG/2010/07514', 11, 'UCE/UG/2023/24256', 'Division I'),
(594, 594, 'Greenhill Academy', 'PLE/UG/2021/39020', 17, 'UCE/UG/2023/49591', 'Division III'),
(595, 595, 'Greenhill Academy', 'PLE/UG/2017/92977', 5, 'UCE/UG/2015/98575', 'Division III'),
(596, 596, 'Namilyango School', 'PLE/UG/2016/91015', 12, 'UCE/UG/2017/93573', 'Division I'),
(597, 597, 'Ntare School', 'PLE/UG/2013/72739', 35, 'UCE/UG/2020/74504', 'Division III'),
(598, 598, 'Gayaza High School', 'PLE/UG/2019/31821', 22, 'UCE/UG/2023/94184', 'Division IV'),
(599, 599, 'Ntare School', 'PLE/UG/2022/10861', 28, 'UCE/UG/2017/41285', 'Division II'),
(600, 600, 'Gayaza High School', 'PLE/UG/2022/22999', 19, 'UCE/UG/2021/51574', 'Division I'),
(601, 601, 'Buddo Junior', 'PLE/UG/2012/58201', 19, 'UCE/UG/2019/80570', 'Division I'),
(602, 602, 'Ntare School', 'PLE/UG/2021/86129', 31, 'UCE/UG/2019/79295', 'Division IV'),
(603, 603, 'Ntare School', 'PLE/UG/2018/44211', 18, 'UCE/UG/2022/28118', 'Division III'),
(604, 604, 'Ntare School', 'PLE/UG/2020/03275', 4, 'UCE/UG/2023/83721', 'Division II'),
(605, 605, 'Gayaza High School', 'PLE/UG/2017/75544', 10, 'UCE/UG/2020/19200', 'Division III'),
(606, 606, 'Buddo Junior', 'PLE/UG/2023/72121', 28, 'UCE/UG/2018/86523', 'Division II'),
(607, 607, 'Gayaza High School', 'PLE/UG/2022/62370', 17, 'UCE/UG/2013/03907', 'Division II'),
(608, 608, 'Greenhill Academy', 'PLE/UG/2021/32704', 9, 'UCE/UG/2022/88015', 'Division IV'),
(609, 609, 'Greenhill Academy', 'PLE/UG/2020/83062', 34, 'UCE/UG/2012/16755', 'Division I'),
(610, 610, 'Namilyango School', 'PLE/UG/2012/04164', 22, 'UCE/UG/2020/08885', 'Division I'),
(611, 611, 'Greenhill Academy', 'PLE/UG/2015/53745', 17, 'UCE/UG/2016/11832', 'Division I'),
(612, 612, 'Namilyango School', 'PLE/UG/2013/28622', 24, 'UCE/UG/2015/89734', 'Division II'),
(613, 613, 'Ntare School', 'PLE/UG/2018/51531', 25, 'UCE/UG/2021/12129', 'Division I'),
(614, 614, 'Gayaza High School', 'PLE/UG/2011/38448', 23, 'UCE/UG/2022/70215', 'Division IV'),
(615, 615, 'Namilyango School', 'PLE/UG/2020/08895', 11, 'UCE/UG/2022/86221', 'Division III'),
(616, 616, 'Namilyango School', 'PLE/UG/2015/55691', 24, 'UCE/UG/2017/75153', 'Division I'),
(617, 617, 'Greenhill Academy', 'PLE/UG/2016/66352', 35, 'UCE/UG/2023/86993', 'Division II'),
(618, 618, 'Greenhill Academy', 'PLE/UG/2017/33224', 35, 'UCE/UG/2023/75066', 'Division IV'),
(619, 619, 'Ntare School', 'PLE/UG/2022/94498', 6, 'UCE/UG/2016/28820', 'Division IV'),
(620, 620, 'Namilyango School', 'PLE/UG/2012/48774', 32, 'UCE/UG/2023/06315', 'Division II'),
(621, 621, 'Greenhill Academy', 'PLE/UG/2020/06234', 8, 'UCE/UG/2017/18164', 'Division II'),
(622, 622, 'Ntare School', 'PLE/UG/2020/97882', 24, 'UCE/UG/2014/71636', 'Division III'),
(623, 623, 'Ntare School', 'PLE/UG/2017/43594', 19, 'UCE/UG/2011/21566', 'Division III'),
(624, 624, 'Greenhill Academy', 'PLE/UG/2020/37485', 21, 'UCE/UG/2018/25937', 'Division III'),
(625, 625, 'Buddo Junior', 'PLE/UG/2011/80430', 23, 'UCE/UG/2018/18449', 'Division I'),
(626, 626, 'Gayaza High School', 'PLE/UG/2011/81111', 26, 'UCE/UG/2010/21598', 'Division IV'),
(627, 627, 'Buddo Junior', 'PLE/UG/2018/92301', 30, 'UCE/UG/2014/07970', 'Division II'),
(628, 628, 'Greenhill Academy', 'PLE/UG/2013/43750', 18, 'UCE/UG/2022/25465', 'Division III'),
(629, 629, 'Gayaza High School', 'PLE/UG/2021/22377', 26, 'UCE/UG/2022/19729', 'Division II'),
(630, 630, 'Gayaza High School', 'PLE/UG/2017/86764', 26, 'UCE/UG/2023/59939', 'Division I'),
(631, 631, 'Buddo Junior', 'PLE/UG/2011/56499', 16, 'UCE/UG/2014/45274', 'Division II'),
(632, 632, 'Buddo Junior', 'PLE/UG/2013/36453', 4, 'UCE/UG/2023/78029', 'Division I'),
(633, 633, 'Ntare School', 'PLE/UG/2021/41734', 22, 'UCE/UG/2018/39326', 'Division I'),
(634, 634, 'Gayaza High School', 'PLE/UG/2019/72629', 24, 'UCE/UG/2023/97425', 'Division IV'),
(635, 635, 'Gayaza High School', 'PLE/UG/2013/44681', 18, 'UCE/UG/2023/53252', 'Division III'),
(636, 636, 'Namilyango School', 'PLE/UG/2022/98631', 11, 'UCE/UG/2012/19884', 'Division II'),
(637, 637, 'Namilyango School', 'PLE/UG/2012/65553', 26, 'UCE/UG/2018/83113', 'Division II'),
(638, 638, 'Greenhill Academy', 'PLE/UG/2015/99408', 30, 'UCE/UG/2012/29531', 'Division I'),
(639, 639, 'Namilyango School', 'PLE/UG/2022/07248', 27, 'UCE/UG/2015/86669', 'Division I'),
(640, 640, 'Gayaza High School', 'PLE/UG/2023/86889', 21, 'UCE/UG/2012/19985', 'Division II'),
(641, 641, 'Greenhill Academy', 'PLE/UG/2022/94530', 5, 'UCE/UG/2015/87548', 'Division I'),
(642, 642, 'Buddo Junior', 'PLE/UG/2021/94280', 9, 'UCE/UG/2011/88530', 'Division I'),
(643, 643, 'Ntare School', 'PLE/UG/2020/48504', 7, 'UCE/UG/2011/23996', 'Division IV'),
(644, 644, 'Buddo Junior', 'PLE/UG/2015/24847', 35, 'UCE/UG/2012/04642', 'Division III'),
(645, 645, 'Gayaza High School', 'PLE/UG/2017/91093', 34, 'UCE/UG/2010/31363', 'Division II'),
(646, 646, 'Ntare School', 'PLE/UG/2021/91219', 6, 'UCE/UG/2020/36890', 'Division III'),
(647, 647, 'Gayaza High School', 'PLE/UG/2022/57676', 8, 'UCE/UG/2022/10913', 'Division IV'),
(648, 648, 'Buddo Junior', 'PLE/UG/2015/60381', 31, 'UCE/UG/2017/92077', 'Division I'),
(649, 649, 'Greenhill Academy', 'PLE/UG/2016/52119', 10, 'UCE/UG/2016/56827', 'Division III'),
(650, 650, 'Greenhill Academy', 'PLE/UG/2023/90460', 26, 'UCE/UG/2021/91369', 'Division I'),
(651, 651, 'Gayaza High School', 'PLE/UG/2017/53892', 9, 'UCE/UG/2013/66582', 'Division III'),
(652, 652, 'Namilyango School', 'PLE/UG/2018/06653', 17, 'UCE/UG/2023/47843', 'Division III'),
(653, 653, 'Ntare School', 'PLE/UG/2012/41222', 23, 'UCE/UG/2021/17805', 'Division II'),
(654, 654, 'Gayaza High School', 'PLE/UG/2016/69369', 4, 'UCE/UG/2010/10097', 'Division II'),
(655, 655, 'Ntare School', 'PLE/UG/2018/17341', 7, 'UCE/UG/2023/58790', 'Division I'),
(656, 656, 'Ntare School', 'PLE/UG/2018/45976', 16, 'UCE/UG/2019/02754', 'Division I'),
(657, 657, 'Buddo Junior', 'PLE/UG/2020/33386', 20, 'UCE/UG/2017/00673', 'Division III'),
(658, 658, 'Ntare School', 'PLE/UG/2023/06890', 21, 'UCE/UG/2018/20033', 'Division II'),
(659, 659, 'Greenhill Academy', 'PLE/UG/2021/69755', 35, 'UCE/UG/2021/07948', 'Division IV'),
(660, 660, 'Namilyango School', 'PLE/UG/2016/93498', 14, 'UCE/UG/2022/47732', 'Division III'),
(661, 661, 'Buddo Junior', 'PLE/UG/2010/00463', 34, 'UCE/UG/2020/87372', 'Division I'),
(662, 662, 'Gayaza High School', 'PLE/UG/2010/16738', 25, 'UCE/UG/2021/06465', 'Division IV'),
(663, 663, 'Greenhill Academy', 'PLE/UG/2019/84291', 10, 'UCE/UG/2016/66354', 'Division IV'),
(664, 664, 'Namilyango School', 'PLE/UG/2019/20706', 33, 'UCE/UG/2023/21758', 'Division I'),
(665, 665, 'Greenhill Academy', 'PLE/UG/2019/79057', 31, 'UCE/UG/2022/79158', 'Division II'),
(666, 666, 'Buddo Junior', 'PLE/UG/2019/22158', 9, 'UCE/UG/2011/22180', 'Division III'),
(667, 667, 'Greenhill Academy', 'PLE/UG/2012/98741', 19, 'UCE/UG/2017/16858', 'Division I'),
(668, 668, 'Namilyango School', 'PLE/UG/2019/01113', 4, 'UCE/UG/2010/07799', 'Division II'),
(669, 669, 'Buddo Junior', 'PLE/UG/2014/76598', 28, 'UCE/UG/2018/63407', 'Division II'),
(670, 670, 'Namilyango School', 'PLE/UG/2014/14746', 28, 'UCE/UG/2016/96613', 'Division II'),
(671, 671, 'Buddo Junior', 'PLE/UG/2020/32765', 18, 'UCE/UG/2013/91613', 'Division IV'),
(672, 672, 'Buddo Junior', 'PLE/UG/2016/25635', 34, 'UCE/UG/2023/95595', 'Division IV'),
(673, 673, 'Ntare School', 'PLE/UG/2018/64597', 13, 'UCE/UG/2018/10686', 'Division III'),
(674, 674, 'Buddo Junior', 'PLE/UG/2018/03490', 16, 'UCE/UG/2022/16544', 'Division I'),
(675, 675, 'Ntare School', 'PLE/UG/2020/31393', 17, 'UCE/UG/2012/49695', 'Division I'),
(676, 676, 'Namilyango School', 'PLE/UG/2020/41222', 31, 'UCE/UG/2010/56644', 'Division IV'),
(677, 677, 'Ntare School', 'PLE/UG/2015/45951', 6, 'UCE/UG/2023/70366', 'Division III'),
(678, 678, 'Gayaza High School', 'PLE/UG/2014/69970', 17, 'UCE/UG/2011/08607', 'Division I'),
(679, 679, 'Gayaza High School', 'PLE/UG/2021/11307', 10, 'UCE/UG/2019/72388', 'Division III'),
(680, 680, 'Gayaza High School', 'PLE/UG/2019/70822', 18, 'UCE/UG/2013/66821', 'Division III'),
(681, 681, 'Buddo Junior', 'PLE/UG/2016/95979', 16, 'UCE/UG/2011/38744', 'Division III'),
(682, 682, 'Buddo Junior', 'PLE/UG/2015/72314', 21, 'UCE/UG/2017/09455', 'Division IV'),
(683, 683, 'Buddo Junior', 'PLE/UG/2012/71987', 4, 'UCE/UG/2022/27627', 'Division IV'),
(684, 684, 'Ntare School', 'PLE/UG/2018/21636', 13, 'UCE/UG/2020/97859', 'Division III'),
(685, 685, 'Greenhill Academy', 'PLE/UG/2012/21006', 22, 'UCE/UG/2013/49668', 'Division IV'),
(686, 686, 'Greenhill Academy', 'PLE/UG/2015/15691', 22, 'UCE/UG/2015/30632', 'Division II'),
(687, 687, 'Gayaza High School', 'PLE/UG/2014/91571', 23, 'UCE/UG/2013/50737', 'Division III'),
(688, 688, 'Buddo Junior', 'PLE/UG/2015/58714', 30, 'UCE/UG/2016/63945', 'Division IV'),
(689, 689, 'Namilyango School', 'PLE/UG/2011/14120', 17, 'UCE/UG/2019/21753', 'Division IV'),
(690, 690, 'Greenhill Academy', 'PLE/UG/2015/39171', 30, 'UCE/UG/2022/02198', 'Division II'),
(691, 691, 'Buddo Junior', 'PLE/UG/2013/99144', 11, 'UCE/UG/2012/09814', 'Division I'),
(692, 692, 'Buddo Junior', 'PLE/UG/2017/34547', 9, 'UCE/UG/2020/28196', 'Division I'),
(693, 693, 'Namilyango School', 'PLE/UG/2017/40686', 18, 'UCE/UG/2011/01855', 'Division IV'),
(694, 694, 'Buddo Junior', 'PLE/UG/2018/80784', 11, 'UCE/UG/2020/14740', 'Division II'),
(695, 695, 'Ntare School', 'PLE/UG/2014/32145', 25, 'UCE/UG/2014/67799', 'Division II'),
(696, 696, 'Namilyango School', 'PLE/UG/2020/47547', 8, 'UCE/UG/2013/94146', 'Division IV'),
(697, 697, 'Greenhill Academy', 'PLE/UG/2021/36686', 13, 'UCE/UG/2014/68718', 'Division III'),
(698, 698, 'Gayaza High School', 'PLE/UG/2011/62256', 29, 'UCE/UG/2012/50366', 'Division IV'),
(699, 699, 'Gayaza High School', 'PLE/UG/2019/50076', 19, 'UCE/UG/2023/21443', 'Division II'),
(700, 700, 'Namilyango School', 'PLE/UG/2013/89137', 29, 'UCE/UG/2015/46034', 'Division I'),
(701, 701, 'Ntare School', 'PLE/UG/2020/44268', 34, 'UCE/UG/2016/33245', 'Division II'),
(702, 702, 'Buddo Junior', 'PLE/UG/2016/08745', 7, 'UCE/UG/2013/84761', 'Division III'),
(703, 703, 'Buddo Junior', 'PLE/UG/2016/19403', 24, 'UCE/UG/2019/35091', 'Division IV'),
(704, 704, 'Buddo Junior', 'PLE/UG/2022/49464', 32, 'UCE/UG/2022/93644', 'Division IV'),
(705, 705, 'Ntare School', 'PLE/UG/2018/22471', 14, 'UCE/UG/2010/08474', 'Division II'),
(706, 706, 'Ntare School', 'PLE/UG/2020/35870', 20, 'UCE/UG/2016/76909', 'Division II'),
(707, 707, 'Ntare School', 'PLE/UG/2019/55469', 28, 'UCE/UG/2012/72169', 'Division IV'),
(708, 708, 'Buddo Junior', 'PLE/UG/2018/65630', 18, 'UCE/UG/2014/17282', 'Division IV'),
(709, 709, 'Buddo Junior', 'PLE/UG/2012/65438', 30, 'UCE/UG/2011/06823', 'Division I'),
(710, 710, 'Greenhill Academy', 'PLE/UG/2012/07154', 28, 'UCE/UG/2018/69699', 'Division III'),
(711, 711, 'Ntare School', 'PLE/UG/2016/80731', 21, 'UCE/UG/2014/81038', 'Division I'),
(712, 712, 'Namilyango School', 'PLE/UG/2011/00176', 27, 'UCE/UG/2020/45088', 'Division I'),
(713, 713, 'Namilyango School', 'PLE/UG/2016/14982', 13, 'UCE/UG/2011/52626', 'Division II'),
(714, 714, 'Gayaza High School', 'PLE/UG/2020/70364', 11, 'UCE/UG/2010/55935', 'Division III'),
(715, 715, 'Greenhill Academy', 'PLE/UG/2023/22942', 14, 'UCE/UG/2023/84382', 'Division II'),
(716, 716, 'Gayaza High School', 'PLE/UG/2020/20143', 25, 'UCE/UG/2019/56515', 'Division III'),
(717, 717, 'Gayaza High School', 'PLE/UG/2010/47965', 13, 'UCE/UG/2010/34627', 'Division III'),
(718, 718, 'Gayaza High School', 'PLE/UG/2016/39909', 21, 'UCE/UG/2017/89216', 'Division IV'),
(719, 719, 'Namilyango School', 'PLE/UG/2010/78252', 29, 'UCE/UG/2019/11273', 'Division II'),
(720, 720, 'Greenhill Academy', 'PLE/UG/2021/64220', 29, 'UCE/UG/2023/61075', 'Division I'),
(721, 721, 'Gayaza High School', 'PLE/UG/2023/51461', 28, 'UCE/UG/2012/81334', 'Division II'),
(722, 722, 'Greenhill Academy', 'PLE/UG/2017/62683', 23, 'UCE/UG/2011/73903', 'Division II'),
(723, 723, 'Gayaza High School', 'PLE/UG/2022/82320', 17, 'UCE/UG/2018/80928', 'Division I'),
(724, 724, 'Namilyango School', 'PLE/UG/2023/43338', 11, 'UCE/UG/2022/80829', 'Division II'),
(725, 725, 'Ntare School', 'PLE/UG/2011/32997', 12, 'UCE/UG/2014/69895', 'Division III'),
(726, 726, 'Ntare School', 'PLE/UG/2016/62841', 29, 'UCE/UG/2011/14429', 'Division II'),
(727, 727, 'Ntare School', 'PLE/UG/2022/25764', 22, 'UCE/UG/2010/51765', 'Division II'),
(728, 728, 'Gayaza High School', 'PLE/UG/2023/24902', 13, 'UCE/UG/2020/86021', 'Division I'),
(729, 729, 'Greenhill Academy', 'PLE/UG/2010/58405', 26, 'UCE/UG/2021/88807', 'Division I'),
(730, 730, 'Gayaza High School', 'PLE/UG/2013/16857', 4, 'UCE/UG/2018/06822', 'Division II'),
(731, 731, 'Ntare School', 'PLE/UG/2010/71303', 20, 'UCE/UG/2015/31389', 'Division II'),
(732, 732, 'Ntare School', 'PLE/UG/2017/42644', 20, 'UCE/UG/2014/93273', 'Division IV'),
(733, 733, 'Buddo Junior', 'PLE/UG/2011/33126', 14, 'UCE/UG/2019/35448', 'Division IV'),
(734, 734, 'Gayaza High School', 'PLE/UG/2014/87225', 13, 'UCE/UG/2022/66425', 'Division III'),
(735, 735, 'Buddo Junior', 'PLE/UG/2017/46531', 25, 'UCE/UG/2023/89162', 'Division III'),
(736, 736, 'Namilyango School', 'PLE/UG/2016/96327', 15, 'UCE/UG/2022/23811', 'Division III'),
(737, 737, 'Ntare School', 'PLE/UG/2023/54598', 31, 'UCE/UG/2020/04059', 'Division I'),
(738, 738, 'Buddo Junior', 'PLE/UG/2011/32265', 15, 'UCE/UG/2022/19697', 'Division II'),
(739, 739, 'Greenhill Academy', 'PLE/UG/2012/39739', 17, 'UCE/UG/2023/60556', 'Division I'),
(740, 740, 'Buddo Junior', 'PLE/UG/2010/97050', 26, 'UCE/UG/2018/99979', 'Division I'),
(741, 741, 'Greenhill Academy', 'PLE/UG/2011/86124', 32, 'UCE/UG/2021/54455', 'Division I'),
(742, 742, 'Ntare School', 'PLE/UG/2010/28381', 16, 'UCE/UG/2012/58324', 'Division II'),
(743, 743, 'Buddo Junior', 'PLE/UG/2019/18201', 29, 'UCE/UG/2015/74358', 'Division II'),
(744, 744, 'Greenhill Academy', 'PLE/UG/2014/78865', 33, 'UCE/UG/2013/38601', 'Division I'),
(745, 745, 'Namilyango School', 'PLE/UG/2020/29381', 12, 'UCE/UG/2015/34429', 'Division II'),
(746, 746, 'Namilyango School', 'PLE/UG/2020/30139', 11, 'UCE/UG/2014/80185', 'Division I'),
(747, 747, 'Buddo Junior', 'PLE/UG/2018/20476', 9, 'UCE/UG/2012/48926', 'Division IV'),
(748, 748, 'Gayaza High School', 'PLE/UG/2019/81488', 35, 'UCE/UG/2015/15071', 'Division III'),
(749, 749, 'Buddo Junior', 'PLE/UG/2023/51010', 26, 'UCE/UG/2023/78971', 'Division I'),
(750, 750, 'Namilyango School', 'PLE/UG/2012/65314', 27, 'UCE/UG/2020/58761', 'Division III'),
(751, 751, 'Buddo Junior', 'PLE/UG/2018/01171', 8, 'UCE/UG/2019/95096', 'Division III'),
(752, 752, 'Gayaza High School', 'PLE/UG/2013/33369', 32, 'UCE/UG/2017/90293', 'Division IV'),
(753, 753, 'Greenhill Academy', 'PLE/UG/2022/87262', 26, 'UCE/UG/2022/35772', 'Division I'),
(754, 754, 'Ntare School', 'PLE/UG/2020/38262', 24, 'UCE/UG/2011/48075', 'Division I'),
(755, 755, 'Ntare School', 'PLE/UG/2023/15870', 30, 'UCE/UG/2019/95296', 'Division III'),
(756, 756, 'Greenhill Academy', 'PLE/UG/2020/10641', 13, 'UCE/UG/2013/15605', 'Division I'),
(757, 757, 'Ntare School', 'PLE/UG/2012/54962', 12, 'UCE/UG/2019/47600', 'Division II'),
(758, 758, 'Ntare School', 'PLE/UG/2017/15096', 7, 'UCE/UG/2011/15787', 'Division II'),
(759, 759, 'Gayaza High School', 'PLE/UG/2023/54985', 33, 'UCE/UG/2023/16270', 'Division IV'),
(760, 760, 'Namilyango School', 'PLE/UG/2022/25612', 20, 'UCE/UG/2021/55350', 'Division II'),
(761, 761, 'Greenhill Academy', 'PLE/UG/2019/52648', 25, 'UCE/UG/2019/56626', 'Division III'),
(762, 762, 'Greenhill Academy', 'PLE/UG/2012/16351', 10, 'UCE/UG/2016/73974', 'Division II'),
(763, 763, 'Namilyango School', 'PLE/UG/2023/30027', 22, 'UCE/UG/2023/02937', 'Division II'),
(764, 764, 'Ntare School', 'PLE/UG/2017/20511', 14, 'UCE/UG/2011/35302', 'Division III'),
(765, 765, 'Greenhill Academy', 'PLE/UG/2021/77212', 13, 'UCE/UG/2012/96485', 'Division II'),
(766, 766, 'Greenhill Academy', 'PLE/UG/2011/78803', 27, 'UCE/UG/2013/13537', 'Division IV'),
(767, 767, 'Namilyango School', 'PLE/UG/2012/61533', 20, 'UCE/UG/2019/89086', 'Division II'),
(768, 768, 'Namilyango School', 'PLE/UG/2017/64065', 23, 'UCE/UG/2011/67410', 'Division I'),
(769, 769, 'Ntare School', 'PLE/UG/2010/09846', 13, 'UCE/UG/2012/93740', 'Division I'),
(770, 770, 'Buddo Junior', 'PLE/UG/2019/31324', 23, 'UCE/UG/2011/70617', 'Division I'),
(771, 771, 'Namilyango School', 'PLE/UG/2010/49987', 18, 'UCE/UG/2021/57621', 'Division III'),
(772, 772, 'Gayaza High School', 'PLE/UG/2023/13525', 30, 'UCE/UG/2020/18119', 'Division III'),
(773, 773, 'Namilyango School', 'PLE/UG/2020/64650', 35, 'UCE/UG/2010/10596', 'Division II'),
(774, 774, 'Buddo Junior', 'PLE/UG/2013/52776', 30, 'UCE/UG/2017/27250', 'Division III'),
(775, 775, 'Greenhill Academy', 'PLE/UG/2012/18735', 13, 'UCE/UG/2022/72362', 'Division IV'),
(776, 776, 'Buddo Junior', 'PLE/UG/2019/28890', 14, 'UCE/UG/2020/81264', 'Division IV'),
(777, 777, 'Greenhill Academy', 'PLE/UG/2014/86020', 15, 'UCE/UG/2012/89131', 'Division IV'),
(778, 778, 'Gayaza High School', 'PLE/UG/2022/76831', 6, 'UCE/UG/2010/02208', 'Division IV'),
(779, 779, 'Buddo Junior', 'PLE/UG/2012/74674', 7, 'UCE/UG/2015/44309', 'Division I'),
(780, 780, 'Buddo Junior', 'PLE/UG/2018/33726', 29, 'UCE/UG/2010/61761', 'Division I'),
(781, 781, 'Gayaza High School', 'PLE/UG/2014/96519', 31, 'UCE/UG/2015/40572', 'Division IV'),
(782, 782, 'Namilyango School', 'PLE/UG/2021/74958', 16, 'UCE/UG/2018/04929', 'Division II'),
(783, 783, 'Greenhill Academy', 'PLE/UG/2019/65028', 13, 'UCE/UG/2016/56477', 'Division II'),
(784, 784, 'Ntare School', 'PLE/UG/2022/65733', 24, 'UCE/UG/2013/31786', 'Division IV'),
(785, 785, 'Namilyango School', 'PLE/UG/2015/93900', 20, 'UCE/UG/2020/25659', 'Division I'),
(786, 786, 'Gayaza High School', 'PLE/UG/2022/45799', 24, 'UCE/UG/2021/15149', 'Division II'),
(787, 787, 'Namilyango School', 'PLE/UG/2010/24740', 6, 'UCE/UG/2019/23726', 'Division I'),
(788, 788, 'Namilyango School', 'PLE/UG/2010/84312', 9, 'UCE/UG/2014/09196', 'Division II'),
(789, 789, 'Greenhill Academy', 'PLE/UG/2021/21856', 23, 'UCE/UG/2014/83781', 'Division I'),
(790, 790, 'Greenhill Academy', 'PLE/UG/2015/40796', 34, 'UCE/UG/2017/69541', 'Division IV'),
(791, 791, 'Greenhill Academy', 'PLE/UG/2019/85097', 10, 'UCE/UG/2015/53088', 'Division II'),
(792, 792, 'Ntare School', 'PLE/UG/2017/07616', 28, 'UCE/UG/2018/83789', 'Division II'),
(793, 793, 'Ntare School', 'PLE/UG/2014/31746', 23, 'UCE/UG/2012/88975', 'Division IV'),
(794, 794, 'Ntare School', 'PLE/UG/2021/59315', 22, 'UCE/UG/2010/50595', 'Division II'),
(795, 795, 'Greenhill Academy', 'PLE/UG/2011/15223', 15, 'UCE/UG/2014/68336', 'Division II'),
(796, 796, 'Ntare School', 'PLE/UG/2023/10638', 25, 'UCE/UG/2010/06512', 'Division II'),
(797, 797, 'Namilyango School', 'PLE/UG/2012/72958', 7, 'UCE/UG/2014/16026', 'Division IV'),
(798, 798, 'Namilyango School', 'PLE/UG/2013/84326', 17, 'UCE/UG/2017/32967', 'Division I'),
(799, 799, 'Gayaza High School', 'PLE/UG/2016/18265', 19, 'UCE/UG/2023/21260', 'Division I'),
(806, 814, 'VDP', '123', 6, '2333', '56'),
(807, 818, 'VDP', '123', 6, '2333', '56'),
(808, 819, 'VDP', '123', 6, '2333', '56'),
(809, 821, 'VDP', '123', 6, '2333', '56');

-- --------------------------------------------------------

--
-- Table structure for table `enrollment`
--

CREATE TABLE `enrollment` (
  `EnrollmentID` int(11) NOT NULL,
  `AdmissionNo` int(11) NOT NULL,
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

INSERT INTO `enrollment` (`EnrollmentID`, `AdmissionNo`, `AcademicYear`, `Level`, `Class`, `Term`, `Stream`, `Residence`, `EntryStatus`) VALUES
(1, 1, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'A', 'Boarding', 'New'),
(2, 2, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'A', 'Boarding', 'New'),
(3, 3, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'A', 'Day', 'New'),
(4, 4, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'A', 'Boarding', 'New'),
(5, 5, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'A', 'Boarding', 'New'),
(6, 6, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'A', 'Boarding', 'New'),
(7, 7, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'A', 'Day', 'New'),
(8, 8, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'A', 'Boarding', 'New'),
(9, 9, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'A', 'Boarding', 'New'),
(10, 10, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'A', 'Boarding', 'New'),
(11, 11, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'B', 'Boarding', 'New'),
(12, 12, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'B', 'Day', 'New'),
(13, 13, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'B', 'Day', 'New'),
(14, 14, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'B', 'Day', 'New'),
(15, 15, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'B', 'Day', 'New'),
(16, 16, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'B', 'Boarding', 'New'),
(17, 17, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'B', 'Boarding', 'New'),
(18, 18, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'B', 'Day', 'New'),
(19, 19, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'B', 'Boarding', 'New'),
(20, 20, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'B', 'Boarding', 'New'),
(21, 21, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'C', 'Day', 'New'),
(22, 22, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'C', 'Day', 'New'),
(23, 23, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'C', 'Day', 'New'),
(24, 24, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'C', 'Boarding', 'New'),
(25, 25, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'C', 'Boarding', 'New'),
(26, 26, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'C', 'Day', 'New'),
(27, 27, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'C', 'Day', 'New'),
(28, 28, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'C', 'Day', 'New'),
(29, 29, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'C', 'Day', 'New'),
(30, 30, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'C', 'Boarding', 'New'),
(31, 31, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'D', 'Boarding', 'New'),
(32, 32, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'D', 'Day', 'New'),
(33, 33, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'D', 'Day', 'New'),
(34, 34, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'D', 'Boarding', 'New'),
(35, 35, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'D', 'Day', 'New'),
(36, 36, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'D', 'Boarding', 'New'),
(37, 37, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'D', 'Day', 'New'),
(38, 38, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'D', 'Boarding', 'New'),
(39, 39, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'D', 'Day', 'New'),
(40, 40, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'D', 'Day', 'New'),
(41, 41, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'E', 'Boarding', 'New'),
(42, 42, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'E', 'Day', 'New'),
(43, 43, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'E', 'Day', 'New'),
(44, 44, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'E', 'Day', 'New'),
(45, 45, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'E', 'Day', 'New'),
(46, 46, '2025-26', 'Pre-Primary', 'PP.1', 'Term 1', 'E', 'Boarding', 'New'),
(47, 47, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'E', 'Boarding', 'New'),
(48, 48, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'E', 'Boarding', 'New'),
(49, 49, '2025-26', 'Pre-Primary', 'PP.1', 'Term 3', 'E', 'Day', 'New'),
(50, 50, '2025-26', 'Pre-Primary', 'PP.1', 'Term 2', 'E', 'Day', 'New'),
(51, 51, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'A', 'Boarding', 'Continuing'),
(52, 52, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'A', 'Day', 'Continuing'),
(53, 53, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'A', 'Day', 'Continuing'),
(54, 54, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'A', 'Boarding', 'Continuing'),
(55, 55, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'A', 'Boarding', 'Continuing'),
(56, 56, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'A', 'Day', 'Continuing'),
(57, 57, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'A', 'Boarding', 'Continuing'),
(58, 58, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'A', 'Day', 'Continuing'),
(59, 59, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'A', 'Boarding', 'Continuing'),
(60, 60, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'A', 'Boarding', 'Continuing'),
(61, 61, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'B', 'Day', 'Continuing'),
(62, 62, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'B', 'Day', 'Continuing'),
(63, 63, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'B', 'Boarding', 'Continuing'),
(64, 64, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'B', 'Boarding', 'Continuing'),
(65, 65, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'B', 'Boarding', 'Continuing'),
(66, 66, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'B', 'Day', 'Continuing'),
(67, 67, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'B', 'Day', 'Continuing'),
(68, 68, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'B', 'Day', 'Continuing'),
(69, 69, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'B', 'Day', 'Continuing'),
(70, 70, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'B', 'Boarding', 'Continuing'),
(71, 71, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'C', 'Boarding', 'Continuing'),
(72, 72, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'C', 'Day', 'Continuing'),
(73, 73, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'C', 'Day', 'Continuing'),
(74, 74, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'C', 'Boarding', 'Continuing'),
(75, 75, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'C', 'Boarding', 'Continuing'),
(76, 76, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'C', 'Day', 'Continuing'),
(77, 77, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'C', 'Boarding', 'Continuing'),
(78, 78, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'C', 'Day', 'Continuing'),
(79, 79, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'C', 'Boarding', 'Continuing'),
(80, 80, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'C', 'Day', 'Continuing'),
(81, 81, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'D', 'Day', 'Continuing'),
(82, 82, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'D', 'Boarding', 'Continuing'),
(83, 83, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'D', 'Boarding', 'Continuing'),
(84, 84, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'D', 'Boarding', 'Continuing'),
(85, 85, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'D', 'Boarding', 'Continuing'),
(86, 86, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'D', 'Day', 'Continuing'),
(87, 87, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'D', 'Day', 'Continuing'),
(88, 88, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'D', 'Boarding', 'Continuing'),
(89, 89, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'D', 'Boarding', 'Continuing'),
(90, 90, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'D', 'Boarding', 'Continuing'),
(91, 91, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'E', 'Boarding', 'Continuing'),
(92, 92, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'E', 'Boarding', 'Continuing'),
(93, 93, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'E', 'Boarding', 'Continuing'),
(94, 94, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'E', 'Boarding', 'Continuing'),
(95, 95, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'E', 'Day', 'Continuing'),
(96, 96, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'E', 'Day', 'Continuing'),
(97, 97, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'E', 'Day', 'Continuing'),
(98, 98, '2025-26', 'Pre-Primary', 'PP.2', 'Term 3', 'E', 'Day', 'Continuing'),
(99, 99, '2025-26', 'Pre-Primary', 'PP.2', 'Term 2', 'E', 'Boarding', 'Continuing'),
(100, 100, '2025-26', 'Pre-Primary', 'PP.2', 'Term 1', 'E', 'Boarding', 'Continuing'),
(101, 101, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'A', 'Boarding', 'Continuing'),
(102, 102, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'A', 'Day', 'Continuing'),
(103, 103, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'A', 'Day', 'Continuing'),
(104, 104, '2025-26', 'Pre-Primary', 'PP.3', 'Term 1', 'A', 'Day', 'Continuing'),
(105, 105, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'A', 'Boarding', 'Continuing'),
(106, 106, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'A', 'Boarding', 'Continuing'),
(107, 107, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'A', 'Day', 'Continuing'),
(108, 108, '2025-26', 'Pre-Primary', 'PP.3', 'Term 1', 'A', 'Day', 'Continuing'),
(109, 109, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'A', 'Day', 'Continuing'),
(110, 110, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'A', 'Boarding', 'Continuing'),
(111, 111, '2025-26', 'Pre-Primary', 'PP.3', 'Term 1', 'B', 'Boarding', 'Continuing'),
(112, 112, '2025-26', 'Pre-Primary', 'PP.3', 'Term 1', 'B', 'Day', 'Continuing'),
(113, 113, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'B', 'Day', 'Continuing'),
(114, 114, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'B', 'Boarding', 'Continuing'),
(115, 115, '2025-26', 'Pre-Primary', 'PP.3', 'Term 1', 'B', 'Day', 'Continuing'),
(116, 116, '2025-26', 'Pre-Primary', 'PP.3', 'Term 1', 'B', 'Boarding', 'Continuing'),
(117, 117, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'B', 'Day', 'Continuing'),
(118, 118, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'B', 'Day', 'Continuing'),
(119, 119, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'B', 'Day', 'Continuing'),
(120, 120, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'B', 'Boarding', 'Continuing'),
(121, 121, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'C', 'Day', 'Continuing'),
(122, 122, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'C', 'Day', 'Continuing'),
(123, 123, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'C', 'Boarding', 'Continuing'),
(124, 124, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'C', 'Boarding', 'Continuing'),
(125, 125, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'C', 'Day', 'Continuing'),
(126, 126, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'C', 'Boarding', 'Continuing'),
(127, 127, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'C', 'Day', 'Continuing'),
(128, 128, '2025-26', 'Pre-Primary', 'PP.3', 'Term 1', 'C', 'Boarding', 'Continuing'),
(129, 129, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'C', 'Day', 'Continuing'),
(130, 130, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'C', 'Boarding', 'Continuing'),
(131, 131, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'D', 'Day', 'Continuing'),
(132, 132, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'D', 'Boarding', 'Continuing'),
(133, 133, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'D', 'Boarding', 'Continuing'),
(134, 134, '2025-26', 'Pre-Primary', 'PP.3', 'Term 1', 'D', 'Day', 'Continuing'),
(135, 135, '2025-26', 'Pre-Primary', 'PP.3', 'Term 1', 'D', 'Boarding', 'Continuing'),
(136, 136, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'D', 'Boarding', 'Continuing'),
(137, 137, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'D', 'Boarding', 'Continuing'),
(138, 138, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'D', 'Boarding', 'Continuing'),
(139, 139, '2025-26', 'Pre-Primary', 'PP.3', 'Term 1', 'D', 'Boarding', 'Continuing'),
(140, 140, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'D', 'Day', 'Continuing'),
(141, 141, '2025-26', 'Pre-Primary', 'PP.3', 'Term 1', 'E', 'Day', 'Continuing'),
(142, 142, '2025-26', 'Pre-Primary', 'PP.3', 'Term 1', 'E', 'Boarding', 'Continuing'),
(143, 143, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'E', 'Day', 'Continuing'),
(144, 144, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'E', 'Boarding', 'Continuing'),
(145, 145, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'E', 'Day', 'Continuing'),
(146, 146, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'E', 'Boarding', 'Continuing'),
(147, 147, '2025-26', 'Pre-Primary', 'PP.3', 'Term 3', 'E', 'Boarding', 'Continuing'),
(148, 148, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'E', 'Boarding', 'Continuing'),
(149, 149, '2025-26', 'Pre-Primary', 'PP.3', 'Term 2', 'E', 'Boarding', 'Continuing'),
(150, 150, '2025-26', 'Pre-Primary', 'PP.3', 'Term 1', 'E', 'Boarding', 'Continuing'),
(151, 151, '2025-26', 'pre-primary', 'P.1', 'Term 2', 'A', 'Boarding', 'New'),
(152, 152, '2025-26', 'Primary', 'P.1', 'Term 3', 'A', 'Boarding', 'New'),
(153, 153, '2025-26', 'Primary', 'P.1', 'Term 2', 'A', 'Boarding', 'New'),
(154, 154, '2025-26', 'Primary', 'P.1', 'Term 3', 'A', 'Boarding', 'New'),
(155, 155, '2025-26', 'Primary', 'P.1', 'Term 2', 'A', 'Day', 'New'),
(156, 156, '2025-26', 'Primary', 'P.1', 'Term 3', 'A', 'Boarding', 'New'),
(157, 157, '2025-26', 'Primary', 'P.1', 'Term 1', 'A', 'Day', 'New'),
(158, 158, '2025-26', 'Primary', 'P.1', 'Term 3', 'A', 'Day', 'New'),
(159, 159, '2025-26', 'Primary', 'P.1', 'Term 2', 'A', 'Boarding', 'New'),
(160, 160, '2025-26', 'Primary', 'P.1', 'Term 2', 'A', 'Boarding', 'New'),
(161, 161, '2025-26', 'Primary', 'P.1', 'Term 2', 'B', 'Boarding', 'New'),
(162, 162, '2025-26', 'Primary', 'P.1', 'Term 2', 'B', 'Boarding', 'New'),
(163, 163, '2025-26', 'Primary', 'P.1', 'Term 3', 'B', 'Boarding', 'New'),
(164, 164, '2025-26', 'Primary', 'P.1', 'Term 2', 'B', 'Boarding', 'New'),
(165, 165, '2025-26', 'Primary', 'P.1', 'Term 3', 'B', 'Day', 'New'),
(166, 166, '2025-26', 'Primary', 'P.1', 'Term 1', 'B', 'Day', 'New'),
(167, 167, '2025-26', 'Primary', 'P.1', 'Term 3', 'B', 'Boarding', 'New'),
(168, 168, '2025-26', 'Primary', 'P.1', 'Term 2', 'B', 'Day', 'New'),
(169, 169, '2025-26', 'Primary', 'P.1', 'Term 3', 'B', 'Boarding', 'New'),
(170, 170, '2025-26', 'Primary', 'P.1', 'Term 3', 'B', 'Day', 'New'),
(171, 171, '2025-26', 'Primary', 'P.1', 'Term 2', 'C', 'Boarding', 'New'),
(172, 172, '2025-26', 'Primary', 'P.1', 'Term 1', 'C', 'Day', 'New'),
(173, 173, '2025-26', 'Primary', 'P.1', 'Term 1', 'C', 'Day', 'New'),
(174, 174, '2025-26', 'Primary', 'P.1', 'Term 2', 'C', 'Day', 'New'),
(175, 175, '2025-26', 'Primary', 'P.1', 'Term 3', 'C', 'Day', 'New'),
(176, 176, '2025-26', 'Primary', 'P.1', 'Term 2', 'C', 'Day', 'New'),
(177, 177, '2025-26', 'Primary', 'P.1', 'Term 3', 'C', 'Boarding', 'New'),
(178, 178, '2025-26', 'Primary', 'P.1', 'Term 3', 'C', 'Day', 'New'),
(179, 179, '2025-26', 'Primary', 'P.1', 'Term 3', 'C', 'Boarding', 'New'),
(180, 180, '2025-26', 'Primary', 'P.1', 'Term 3', 'C', 'Day', 'New'),
(181, 181, '2025-26', 'Primary', 'P.1', 'Term 3', 'D', 'Day', 'New'),
(182, 182, '2025-26', 'Primary', 'P.1', 'Term 2', 'D', 'Boarding', 'New'),
(183, 183, '2025-26', 'Primary', 'P.1', 'Term 3', 'D', 'Boarding', 'New'),
(184, 184, '2025-26', 'Primary', 'P.1', 'Term 2', 'D', 'Day', 'New'),
(185, 185, '2025-26', 'Primary', 'P.1', 'Term 3', 'D', 'Boarding', 'New'),
(186, 186, '2025-26', 'Primary', 'P.1', 'Term 1', 'D', 'Day', 'New'),
(187, 187, '2025-26', 'Primary', 'P.1', 'Term 1', 'D', 'Boarding', 'New'),
(188, 188, '2025-26', 'Primary', 'P.1', 'Term 3', 'D', 'Boarding', 'New'),
(189, 189, '2025-26', 'Primary', 'P.1', 'Term 2', 'D', 'Boarding', 'New'),
(190, 190, '2025-26', 'Primary', 'P.1', 'Term 1', 'D', 'Boarding', 'New'),
(191, 191, '2025-26', 'Primary', 'P.1', 'Term 1', 'E', 'Boarding', 'New'),
(192, 192, '2025-26', 'Primary', 'P.1', 'Term 1', 'E', 'Boarding', 'New'),
(193, 193, '2025-26', 'Primary', 'P.1', 'Term 1', 'E', 'Day', 'New'),
(194, 194, '2025-26', 'Primary', 'P.1', 'Term 1', 'E', 'Day', 'New'),
(195, 195, '2025-26', 'Primary', 'P.1', 'Term 1', 'E', 'Boarding', 'New'),
(196, 196, '2025-26', 'Primary', 'P.1', 'Term 3', 'E', 'Boarding', 'New'),
(197, 197, '2025-26', 'Primary', 'P.1', 'Term 2', 'E', 'Day', 'New'),
(198, 198, '2025-26', 'Primary', 'P.1', 'Term 2', 'E', 'Day', 'New'),
(199, 199, '2025-26', 'Primary', 'P.1', 'Term 2', 'E', 'Boarding', 'New'),
(200, 200, '2025-26', 'Primary', 'P.1', 'Term 1', 'E', 'Day', 'New'),
(201, 201, '2025-26', 'Primary', 'P.2', 'Term 1', 'A', 'Day', 'Continuing'),
(202, 202, '2025-26', 'Primary', 'P.2', 'Term 2', 'A', 'Boarding', 'Continuing'),
(203, 203, '2025-26', 'Primary', 'P.2', 'Term 3', 'A', 'Day', 'Continuing'),
(204, 204, '2025-26', 'Primary', 'P.2', 'Term 1', 'A', 'Boarding', 'Continuing'),
(205, 205, '2025-26', 'Primary', 'P.2', 'Term 2', 'A', 'Day', 'Continuing'),
(206, 206, '2025-26', 'Primary', 'P.2', 'Term 1', 'A', 'Boarding', 'Continuing'),
(207, 207, '2025-26', 'Primary', 'P.2', 'Term 1', 'A', 'Day', 'Continuing'),
(208, 208, '2025-26', 'Primary', 'P.2', 'Term 3', 'A', 'Boarding', 'Continuing'),
(209, 209, '2025-26', 'Primary', 'P.2', 'Term 2', 'A', 'Day', 'Continuing'),
(210, 210, '2025-26', 'Primary', 'P.2', 'Term 3', 'A', 'Boarding', 'Continuing'),
(211, 211, '2025-26', 'Primary', 'P.2', 'Term 3', 'B', 'Day', 'Continuing'),
(212, 212, '2025-26', 'Primary', 'P.2', 'Term 2', 'B', 'Day', 'Continuing'),
(213, 213, '2025-26', 'Primary', 'P.2', 'Term 3', 'B', 'Boarding', 'Continuing'),
(214, 214, '2025-26', 'Primary', 'P.2', 'Term 3', 'B', 'Boarding', 'Continuing'),
(215, 215, '2025-26', 'Primary', 'P.2', 'Term 3', 'B', 'Boarding', 'Continuing'),
(216, 216, '2025-26', 'Primary', 'P.2', 'Term 3', 'B', 'Day', 'Continuing'),
(217, 217, '2025-26', 'Primary', 'P.2', 'Term 1', 'B', 'Day', 'Continuing'),
(218, 218, '2025-26', 'Primary', 'P.2', 'Term 3', 'B', 'Boarding', 'Continuing'),
(219, 219, '2025-26', 'Primary', 'P.2', 'Term 3', 'B', 'Day', 'Continuing'),
(220, 220, '2025-26', 'Primary', 'P.2', 'Term 2', 'B', 'Boarding', 'Continuing'),
(221, 221, '2025-26', 'Primary', 'P.2', 'Term 3', 'C', 'Boarding', 'Continuing'),
(222, 222, '2025-26', 'Primary', 'P.2', 'Term 2', 'C', 'Boarding', 'Continuing'),
(223, 223, '2025-26', 'Primary', 'P.2', 'Term 2', 'C', 'Boarding', 'Continuing'),
(224, 224, '2025-26', 'Primary', 'P.2', 'Term 2', 'C', 'Boarding', 'Continuing'),
(225, 225, '2025-26', 'Primary', 'P.2', 'Term 2', 'C', 'Boarding', 'Continuing'),
(226, 226, '2025-26', 'Primary', 'P.2', 'Term 1', 'C', 'Day', 'Continuing'),
(227, 227, '2025-26', 'Primary', 'P.2', 'Term 3', 'C', 'Day', 'Continuing'),
(228, 228, '2025-26', 'Primary', 'P.2', 'Term 2', 'C', 'Boarding', 'Continuing'),
(229, 229, '2025-26', 'Primary', 'P.2', 'Term 3', 'C', 'Day', 'Continuing'),
(230, 230, '2025-26', 'Primary', 'P.2', 'Term 3', 'C', 'Boarding', 'Continuing'),
(231, 231, '2025-26', 'Primary', 'P.2', 'Term 1', 'D', 'Day', 'Continuing'),
(232, 232, '2025-26', 'Primary', 'P.2', 'Term 3', 'D', 'Day', 'Continuing'),
(233, 233, '2025-26', 'Primary', 'P.2', 'Term 3', 'D', 'Boarding', 'Continuing'),
(234, 234, '2025-26', 'Primary', 'P.2', 'Term 1', 'D', 'Boarding', 'Continuing'),
(235, 235, '2025-26', 'Primary', 'P.2', 'Term 2', 'D', 'Day', 'Continuing'),
(236, 236, '2025-26', 'Primary', 'P.2', 'Term 2', 'D', 'Boarding', 'Continuing'),
(237, 237, '2025-26', 'Primary', 'P.2', 'Term 2', 'D', 'Day', 'Continuing'),
(238, 238, '2025-26', 'Primary', 'P.2', 'Term 1', 'D', 'Boarding', 'Continuing'),
(239, 239, '2025-26', 'Primary', 'P.2', 'Term 3', 'D', 'Boarding', 'Continuing'),
(240, 240, '2025-26', 'Primary', 'P.2', 'Term 3', 'D', 'Day', 'Continuing'),
(241, 241, '2025-26', 'Primary', 'P.2', 'Term 1', 'E', 'Boarding', 'Continuing'),
(242, 242, '2025-26', 'Primary', 'P.2', 'Term 2', 'E', 'Day', 'Continuing'),
(243, 243, '2025-26', 'Primary', 'P.2', 'Term 3', 'E', 'Day', 'Continuing'),
(244, 244, '2025-26', 'Primary', 'P.2', 'Term 1', 'E', 'Day', 'Continuing'),
(245, 245, '2025-26', 'Primary', 'P.2', 'Term 3', 'E', 'Day', 'Continuing'),
(246, 246, '2025-26', 'Primary', 'P.2', 'Term 3', 'E', 'Day', 'Continuing'),
(247, 247, '2025-26', 'Primary', 'P.2', 'Term 2', 'E', 'Boarding', 'Continuing'),
(248, 248, '2025-26', 'Primary', 'P.2', 'Term 2', 'E', 'Day', 'Continuing'),
(249, 249, '2025-26', 'Primary', 'P.2', 'Term 2', 'E', 'Day', 'Continuing'),
(250, 250, '2025-26', 'Primary', 'P.2', 'Term 3', 'E', 'Day', 'Continuing'),
(251, 251, '2025-26', 'Primary', 'P.3', 'Term 2', 'A', 'Boarding', 'Continuing'),
(252, 252, '2025-26', 'Primary', 'P.3', 'Term 2', 'A', 'Boarding', 'Continuing'),
(253, 253, '2025-26', 'Primary', 'P.3', 'Term 3', 'A', 'Boarding', 'Continuing'),
(254, 254, '2025-26', 'Primary', 'P.3', 'Term 1', 'A', 'Day', 'Continuing'),
(255, 255, '2025-26', 'Primary', 'P.3', 'Term 1', 'A', 'Day', 'Continuing'),
(256, 256, '2025-26', 'Primary', 'P.3', 'Term 1', 'A', 'Boarding', 'Continuing'),
(257, 257, '2025-26', 'Primary', 'P.3', 'Term 1', 'A', 'Boarding', 'Continuing'),
(258, 258, '2025-26', 'Primary', 'P.3', 'Term 2', 'A', 'Boarding', 'Continuing'),
(259, 259, '2025-26', 'Primary', 'P.3', 'Term 3', 'A', 'Day', 'Continuing'),
(260, 260, '2025-26', 'Primary', 'P.3', 'Term 1', 'A', 'Boarding', 'Continuing'),
(261, 261, '2025-26', 'Primary', 'P.3', 'Term 2', 'B', 'Day', 'Continuing'),
(262, 262, '2025-26', 'Primary', 'P.3', 'Term 3', 'B', 'Day', 'Continuing'),
(263, 263, '2025-26', 'Primary', 'P.3', 'Term 3', 'B', 'Day', 'Continuing'),
(264, 264, '2025-26', 'Primary', 'P.3', 'Term 2', 'B', 'Day', 'Continuing'),
(265, 265, '2025-26', 'Primary', 'P.3', 'Term 1', 'B', 'Day', 'Continuing'),
(266, 266, '2025-26', 'Primary', 'P.3', 'Term 1', 'B', 'Day', 'Continuing'),
(267, 267, '2025-26', 'Primary', 'P.3', 'Term 1', 'B', 'Day', 'Continuing'),
(268, 268, '2025-26', 'Primary', 'P.3', 'Term 1', 'B', 'Boarding', 'Continuing'),
(269, 269, '2025-26', 'Primary', 'P.3', 'Term 2', 'B', 'Day', 'Continuing'),
(270, 270, '2025-26', 'Primary', 'P.3', 'Term 1', 'B', 'Boarding', 'Continuing'),
(271, 271, '2025-26', 'Primary', 'P.3', 'Term 2', 'C', 'Day', 'Continuing'),
(272, 272, '2025-26', 'Primary', 'P.3', 'Term 3', 'C', 'Day', 'Continuing'),
(273, 273, '2025-26', 'Primary', 'P.3', 'Term 2', 'C', 'Day', 'Continuing'),
(274, 274, '2025-26', 'Primary', 'P.3', 'Term 3', 'C', 'Boarding', 'Continuing'),
(275, 275, '2025-26', 'Primary', 'P.3', 'Term 2', 'C', 'Day', 'Continuing'),
(276, 276, '2025-26', 'Primary', 'P.3', 'Term 2', 'C', 'Boarding', 'Continuing'),
(277, 277, '2025-26', 'Primary', 'P.3', 'Term 1', 'C', 'Boarding', 'Continuing'),
(278, 278, '2025-26', 'Primary', 'P.3', 'Term 2', 'C', 'Day', 'Continuing'),
(279, 279, '2025-26', 'Primary', 'P.3', 'Term 3', 'C', 'Day', 'Continuing'),
(280, 280, '2025-26', 'Primary', 'P.3', 'Term 3', 'C', 'Day', 'Continuing'),
(281, 281, '2025-26', 'Primary', 'P.3', 'Term 1', 'D', 'Day', 'Continuing'),
(282, 282, '2025-26', 'Primary', 'P.3', 'Term 3', 'D', 'Boarding', 'Continuing'),
(283, 283, '2025-26', 'Primary', 'P.3', 'Term 2', 'D', 'Day', 'Continuing'),
(284, 284, '2025-26', 'Primary', 'P.3', 'Term 1', 'D', 'Day', 'Continuing'),
(285, 285, '2025-26', 'Primary', 'P.3', 'Term 2', 'D', 'Boarding', 'Continuing'),
(286, 286, '2025-26', 'Primary', 'P.3', 'Term 2', 'D', 'Day', 'Continuing'),
(287, 287, '2025-26', 'Primary', 'P.3', 'Term 2', 'D', 'Boarding', 'Continuing'),
(288, 288, '2025-26', 'Primary', 'P.3', 'Term 3', 'D', 'Day', 'Continuing'),
(289, 289, '2025-26', 'Primary', 'P.3', 'Term 1', 'D', 'Day', 'Continuing'),
(290, 290, '2025-26', 'Primary', 'P.3', 'Term 3', 'D', 'Day', 'Continuing'),
(291, 291, '2025-26', 'Primary', 'P.3', 'Term 1', 'E', 'Boarding', 'Continuing'),
(292, 292, '2025-26', 'Primary', 'P.3', 'Term 2', 'E', 'Day', 'Continuing'),
(293, 293, '2025-26', 'Primary', 'P.3', 'Term 1', 'E', 'Boarding', 'Continuing'),
(294, 294, '2025-26', 'Primary', 'P.3', 'Term 1', 'E', 'Day', 'Continuing'),
(295, 295, '2025-26', 'Primary', 'P.3', 'Term 3', 'E', 'Day', 'Continuing'),
(296, 296, '2025-26', 'Primary', 'P.3', 'Term 2', 'E', 'Day', 'Continuing'),
(297, 297, '2025-26', 'Primary', 'P.3', 'Term 1', 'E', 'Boarding', 'Continuing'),
(298, 298, '2025-26', 'Primary', 'P.3', 'Term 2', 'E', 'Day', 'Continuing'),
(299, 299, '2025-26', 'Primary', 'P.3', 'Term 2', 'E', 'Boarding', 'Continuing'),
(300, 300, '2025-26', 'Primary', 'P.3', 'Term 3', 'E', 'Boarding', 'Continuing'),
(301, 301, '2025-26', 'Primary', 'P.4', 'Term 2', 'A', 'Day', 'Continuing'),
(302, 302, '2025-26', 'Primary', 'P.4', 'Term 1', 'A', 'Boarding', 'Continuing'),
(303, 303, '2025-26', 'Primary', 'P.4', 'Term 2', 'A', 'Day', 'Continuing'),
(304, 304, '2025-26', 'Primary', 'P.4', 'Term 2', 'A', 'Boarding', 'Continuing'),
(305, 305, '2025-26', 'Primary', 'P.4', 'Term 3', 'A', 'Boarding', 'Continuing'),
(306, 306, '2025-26', 'Primary', 'P.4', 'Term 1', 'A', 'Boarding', 'Continuing'),
(307, 307, '2025-26', 'Primary', 'P.4', 'Term 1', 'A', 'Day', 'Continuing'),
(308, 308, '2025-26', 'Primary', 'P.4', 'Term 3', 'A', 'Boarding', 'Continuing'),
(309, 309, '2025-26', 'Primary', 'P.4', 'Term 3', 'A', 'Day', 'Continuing'),
(310, 310, '2025-26', 'Primary', 'P.4', 'Term 3', 'A', 'Boarding', 'Continuing'),
(311, 311, '2025-26', 'Primary', 'P.4', 'Term 1', 'B', 'Boarding', 'Continuing'),
(312, 312, '2025-26', 'Primary', 'P.4', 'Term 1', 'B', 'Day', 'Continuing'),
(313, 313, '2025-26', 'Primary', 'P.4', 'Term 1', 'B', 'Day', 'Continuing'),
(314, 314, '2025-26', 'Primary', 'P.4', 'Term 2', 'B', 'Day', 'Continuing'),
(315, 315, '2025-26', 'Primary', 'P.4', 'Term 3', 'B', 'Day', 'Continuing'),
(316, 316, '2025-26', 'Primary', 'P.4', 'Term 1', 'B', 'Boarding', 'Continuing'),
(317, 317, '2025-26', 'Primary', 'P.4', 'Term 2', 'B', 'Boarding', 'Continuing'),
(318, 318, '2025-26', 'Primary', 'P.4', 'Term 1', 'B', 'Day', 'Continuing'),
(319, 319, '2025-26', 'Primary', 'P.4', 'Term 3', 'B', 'Boarding', 'Continuing'),
(320, 320, '2025-26', 'Primary', 'P.4', 'Term 2', 'B', 'Boarding', 'Continuing'),
(321, 321, '2025-26', 'Primary', 'P.4', 'Term 2', 'C', 'Day', 'Continuing'),
(322, 322, '2025-26', 'Primary', 'P.4', 'Term 1', 'C', 'Day', 'Continuing'),
(323, 323, '2025-26', 'Primary', 'P.4', 'Term 3', 'C', 'Boarding', 'Continuing'),
(324, 324, '2025-26', 'Primary', 'P.4', 'Term 1', 'C', 'Day', 'Continuing'),
(325, 325, '2025-26', 'Primary', 'P.4', 'Term 1', 'C', 'Boarding', 'Continuing'),
(326, 326, '2025-26', 'Primary', 'P.4', 'Term 1', 'C', 'Day', 'Continuing'),
(327, 327, '2025-26', 'Primary', 'P.4', 'Term 1', 'C', 'Boarding', 'Continuing'),
(328, 328, '2025-26', 'Primary', 'P.4', 'Term 3', 'C', 'Day', 'Continuing'),
(329, 329, '2025-26', 'Primary', 'P.4', 'Term 1', 'C', 'Day', 'Continuing'),
(330, 330, '2025-26', 'Primary', 'P.4', 'Term 1', 'C', 'Boarding', 'Continuing'),
(331, 331, '2025-26', 'Primary', 'P.4', 'Term 3', 'D', 'Day', 'Continuing'),
(332, 332, '2025-26', 'Primary', 'P.4', 'Term 3', 'D', 'Day', 'Continuing'),
(333, 333, '2025-26', 'Primary', 'P.4', 'Term 1', 'D', 'Boarding', 'Continuing'),
(334, 334, '2025-26', 'Primary', 'P.4', 'Term 1', 'D', 'Boarding', 'Continuing'),
(335, 335, '2025-26', 'Primary', 'P.4', 'Term 3', 'D', 'Day', 'Continuing'),
(336, 336, '2025-26', 'Primary', 'P.4', 'Term 2', 'D', 'Day', 'Continuing'),
(337, 337, '2025-26', 'Primary', 'P.4', 'Term 1', 'D', 'Day', 'Continuing'),
(338, 338, '2025-26', 'Primary', 'P.4', 'Term 2', 'D', 'Day', 'Continuing'),
(339, 339, '2025-26', 'Primary', 'P.4', 'Term 2', 'D', 'Boarding', 'Continuing'),
(340, 340, '2025-26', 'Primary', 'P.4', 'Term 1', 'D', 'Day', 'Continuing'),
(341, 341, '2025-26', 'Primary', 'P.4', 'Term 3', 'E', 'Boarding', 'Continuing'),
(342, 342, '2025-26', 'Primary', 'P.4', 'Term 3', 'E', 'Boarding', 'Continuing'),
(343, 343, '2025-26', 'Primary', 'P.4', 'Term 2', 'E', 'Day', 'Continuing'),
(344, 344, '2025-26', 'Primary', 'P.4', 'Term 3', 'E', 'Boarding', 'Continuing'),
(345, 345, '2025-26', 'Primary', 'P.4', 'Term 3', 'E', 'Boarding', 'Continuing'),
(346, 346, '2025-26', 'Primary', 'P.4', 'Term 1', 'E', 'Boarding', 'Continuing'),
(347, 347, '2025-26', 'Primary', 'P.4', 'Term 3', 'E', 'Day', 'Continuing'),
(348, 348, '2025-26', 'Primary', 'P.4', 'Term 1', 'E', 'Boarding', 'Continuing'),
(349, 349, '2025-26', 'Primary', 'P.4', 'Term 1', 'E', 'Boarding', 'Continuing'),
(350, 350, '2025-26', 'Primary', 'P.4', 'Term 2', 'E', 'Day', 'Continuing'),
(351, 351, '2025-26', 'Primary', 'P.5', 'Term 2', 'A', 'Boarding', 'Continuing'),
(352, 352, '2025-26', 'Primary', 'P.5', 'Term 3', 'A', 'Boarding', 'Continuing'),
(353, 353, '2025-26', 'Primary', 'P.5', 'Term 1', 'A', 'Boarding', 'Continuing'),
(354, 354, '2025-26', 'Primary', 'P.5', 'Term 1', 'A', 'Day', 'Continuing'),
(355, 355, '2025-26', 'Primary', 'P.5', 'Term 2', 'A', 'Day', 'Continuing'),
(356, 356, '2025-26', 'Primary', 'P.5', 'Term 3', 'A', 'Day', 'Continuing'),
(357, 357, '2025-26', 'Primary', 'P.5', 'Term 1', 'A', 'Day', 'Continuing'),
(358, 358, '2025-26', 'Primary', 'P.5', 'Term 1', 'A', 'Boarding', 'Continuing'),
(359, 359, '2025-26', 'Primary', 'P.5', 'Term 1', 'A', 'Day', 'Continuing'),
(360, 360, '2025-26', 'Primary', 'P.5', 'Term 2', 'A', 'Boarding', 'Continuing'),
(361, 361, '2025-26', 'Primary', 'P.5', 'Term 3', 'B', 'Boarding', 'Continuing'),
(362, 362, '2025-26', 'Primary', 'P.5', 'Term 3', 'B', 'Boarding', 'Continuing'),
(363, 363, '2025-26', 'Primary', 'P.5', 'Term 3', 'B', 'Day', 'Continuing'),
(364, 364, '2025-26', 'Primary', 'P.5', 'Term 3', 'B', 'Boarding', 'Continuing'),
(365, 365, '2025-26', 'Primary', 'P.5', 'Term 3', 'B', 'Day', 'Continuing'),
(366, 366, '2025-26', 'Primary', 'P.5', 'Term 1', 'B', 'Day', 'Continuing'),
(367, 367, '2025-26', 'Primary', 'P.5', 'Term 3', 'B', 'Boarding', 'Continuing'),
(368, 368, '2025-26', 'Primary', 'P.5', 'Term 1', 'B', 'Day', 'Continuing'),
(369, 369, '2025-26', 'Primary', 'P.5', 'Term 1', 'B', 'Boarding', 'Continuing'),
(370, 370, '2025-26', 'Primary', 'P.5', 'Term 3', 'B', 'Boarding', 'Continuing'),
(371, 371, '2025-26', 'Primary', 'P.5', 'Term 2', 'C', 'Boarding', 'Continuing'),
(372, 372, '2025-26', 'Primary', 'P.5', 'Term 2', 'C', 'Day', 'Continuing'),
(373, 373, '2025-26', 'Primary', 'P.5', 'Term 3', 'C', 'Boarding', 'Continuing'),
(374, 374, '2025-26', 'Primary', 'P.5', 'Term 3', 'C', 'Day', 'Continuing'),
(375, 375, '2025-26', 'Primary', 'P.5', 'Term 1', 'C', 'Day', 'Continuing'),
(376, 376, '2025-26', 'Primary', 'P.5', 'Term 3', 'C', 'Day', 'Continuing'),
(377, 377, '2025-26', 'Primary', 'P.5', 'Term 1', 'C', 'Boarding', 'Continuing'),
(378, 378, '2025-26', 'Primary', 'P.5', 'Term 3', 'C', 'Day', 'Continuing'),
(379, 379, '2025-26', 'Primary', 'P.5', 'Term 1', 'C', 'Day', 'Continuing'),
(380, 380, '2025-26', 'Primary', 'P.5', 'Term 1', 'C', 'Boarding', 'Continuing'),
(381, 381, '2025-26', 'Primary', 'P.5', 'Term 2', 'D', 'Day', 'Continuing'),
(382, 382, '2025-26', 'Primary', 'P.5', 'Term 2', 'D', 'Day', 'Continuing'),
(383, 383, '2025-26', 'Primary', 'P.5', 'Term 3', 'D', 'Day', 'Continuing'),
(384, 384, '2025-26', 'Primary', 'P.5', 'Term 2', 'D', 'Boarding', 'Continuing'),
(385, 385, '2025-26', 'Primary', 'P.5', 'Term 1', 'D', 'Day', 'Continuing'),
(386, 386, '2025-26', 'Primary', 'P.5', 'Term 1', 'D', 'Boarding', 'Continuing'),
(387, 387, '2025-26', 'Primary', 'P.5', 'Term 1', 'D', 'Day', 'Continuing'),
(388, 388, '2025-26', 'Primary', 'P.5', 'Term 1', 'D', 'Day', 'Continuing'),
(389, 389, '2025-26', 'Primary', 'P.5', 'Term 3', 'D', 'Day', 'Continuing'),
(390, 390, '2025-26', 'Primary', 'P.5', 'Term 3', 'D', 'Boarding', 'Continuing'),
(391, 391, '2025-26', 'Primary', 'P.5', 'Term 3', 'E', 'Day', 'Continuing'),
(392, 392, '2025-26', 'Primary', 'P.5', 'Term 1', 'E', 'Boarding', 'Continuing'),
(393, 393, '2025-26', 'Primary', 'P.5', 'Term 1', 'E', 'Boarding', 'Continuing'),
(394, 394, '2025-26', 'Primary', 'P.5', 'Term 3', 'E', 'Day', 'Continuing'),
(395, 395, '2025-26', 'Primary', 'P.5', 'Term 2', 'E', 'Day', 'Continuing'),
(396, 396, '2025-26', 'Primary', 'P.5', 'Term 3', 'E', 'Boarding', 'Continuing'),
(397, 397, '2025-26', 'Primary', 'P.5', 'Term 2', 'E', 'Day', 'Continuing'),
(398, 398, '2025-26', 'Primary', 'P.5', 'Term 1', 'E', 'Day', 'Continuing'),
(399, 399, '2025-26', 'Primary', 'P.5', 'Term 3', 'E', 'Boarding', 'Continuing'),
(400, 400, '2025-26', 'Primary', 'P.5', 'Term 1', 'E', 'Boarding', 'Continuing'),
(401, 401, '2025-26', 'Primary', 'P.6', 'Term 1', 'A', 'Boarding', 'Continuing'),
(402, 402, '2025-26', 'Primary', 'P.6', 'Term 2', 'A', 'Day', 'Continuing'),
(403, 403, '2025-26', 'Primary', 'P.6', 'Term 2', 'A', 'Boarding', 'Continuing'),
(404, 404, '2025-26', 'Primary', 'P.6', 'Term 1', 'A', 'Boarding', 'Continuing'),
(405, 405, '2025-26', 'Primary', 'P.6', 'Term 1', 'A', 'Boarding', 'Continuing'),
(406, 406, '2025-26', 'Primary', 'P.6', 'Term 2', 'A', 'Day', 'Continuing'),
(407, 407, '2025-26', 'Primary', 'P.6', 'Term 1', 'A', 'Boarding', 'Continuing'),
(408, 408, '2025-26', 'Primary', 'P.6', 'Term 3', 'A', 'Boarding', 'Continuing'),
(409, 409, '2025-26', 'Primary', 'P.6', 'Term 3', 'A', 'Boarding', 'Continuing'),
(410, 410, '2025-26', 'Primary', 'P.6', 'Term 2', 'A', 'Boarding', 'Continuing'),
(411, 411, '2025-26', 'Primary', 'P.6', 'Term 3', 'B', 'Day', 'Continuing'),
(412, 412, '2025-26', 'Primary', 'P.6', 'Term 3', 'B', 'Day', 'Continuing'),
(413, 413, '2025-26', 'Primary', 'P.6', 'Term 1', 'B', 'Day', 'Continuing'),
(414, 414, '2025-26', 'Primary', 'P.6', 'Term 2', 'B', 'Day', 'Continuing'),
(415, 415, '2025-26', 'Primary', 'P.6', 'Term 3', 'B', 'Boarding', 'Continuing'),
(416, 416, '2025-26', 'Primary', 'P.6', 'Term 3', 'B', 'Boarding', 'Continuing'),
(417, 417, '2025-26', 'Primary', 'P.6', 'Term 2', 'B', 'Boarding', 'Continuing'),
(418, 418, '2025-26', 'Primary', 'P.6', 'Term 2', 'B', 'Day', 'Continuing'),
(419, 419, '2025-26', 'Primary', 'P.6', 'Term 2', 'B', 'Boarding', 'Continuing'),
(420, 420, '2025-26', 'Primary', 'P.6', 'Term 3', 'B', 'Boarding', 'Continuing'),
(421, 421, '2025-26', 'Primary', 'P.6', 'Term 2', 'C', 'Boarding', 'Continuing'),
(422, 422, '2025-26', 'Primary', 'P.6', 'Term 1', 'C', 'Boarding', 'Continuing'),
(423, 423, '2025-26', 'Primary', 'P.6', 'Term 3', 'C', 'Boarding', 'Continuing'),
(424, 424, '2025-26', 'Primary', 'P.6', 'Term 2', 'C', 'Day', 'Continuing'),
(425, 425, '2025-26', 'Primary', 'P.6', 'Term 3', 'C', 'Boarding', 'Continuing'),
(426, 426, '2025-26', 'Primary', 'P.6', 'Term 3', 'C', 'Boarding', 'Continuing'),
(427, 427, '2025-26', 'Primary', 'P.6', 'Term 3', 'C', 'Boarding', 'Continuing'),
(428, 428, '2025-26', 'Primary', 'P.6', 'Term 1', 'C', 'Boarding', 'Continuing'),
(429, 429, '2025-26', 'Primary', 'P.6', 'Term 3', 'C', 'Day', 'Continuing'),
(430, 430, '2025-26', 'Primary', 'P.6', 'Term 2', 'C', 'Day', 'Continuing'),
(431, 431, '2025-26', 'Primary', 'P.6', 'Term 1', 'D', 'Day', 'Continuing'),
(432, 432, '2025-26', 'Primary', 'P.6', 'Term 2', 'D', 'Day', 'Continuing'),
(433, 433, '2025-26', 'Primary', 'P.6', 'Term 1', 'D', 'Day', 'Continuing'),
(434, 434, '2025-26', 'Primary', 'P.6', 'Term 1', 'D', 'Boarding', 'Continuing'),
(435, 435, '2025-26', 'Primary', 'P.6', 'Term 3', 'D', 'Boarding', 'Continuing'),
(436, 436, '2025-26', 'Primary', 'P.6', 'Term 3', 'D', 'Boarding', 'Continuing'),
(437, 437, '2025-26', 'Primary', 'P.6', 'Term 1', 'D', 'Day', 'Continuing'),
(438, 438, '2025-26', 'Primary', 'P.6', 'Term 2', 'D', 'Boarding', 'Continuing'),
(439, 439, '2025-26', 'Primary', 'P.6', 'Term 1', 'D', 'Day', 'Continuing'),
(440, 440, '2025-26', 'Primary', 'P.6', 'Term 3', 'D', 'Day', 'Continuing'),
(441, 441, '2025-26', 'Primary', 'P.6', 'Term 3', 'E', 'Day', 'Continuing'),
(442, 442, '2025-26', 'Primary', 'P.6', 'Term 1', 'E', 'Boarding', 'Continuing'),
(443, 443, '2025-26', 'Primary', 'P.6', 'Term 3', 'E', 'Boarding', 'Continuing'),
(444, 444, '2025-26', 'Primary', 'P.6', 'Term 1', 'E', 'Day', 'Continuing'),
(445, 445, '2025-26', 'Primary', 'P.6', 'Term 1', 'E', 'Boarding', 'Continuing'),
(446, 446, '2025-26', 'Primary', 'P.6', 'Term 3', 'E', 'Boarding', 'Continuing'),
(447, 447, '2025-26', 'Primary', 'P.6', 'Term 1', 'E', 'Day', 'Continuing'),
(448, 448, '2025-26', 'Primary', 'P.6', 'Term 1', 'E', 'Day', 'Continuing'),
(449, 449, '2025-26', 'Primary', 'P.6', 'Term 3', 'E', 'Boarding', 'Continuing'),
(450, 450, '2025-26', 'Primary', 'P.6', 'Term 2', 'E', 'Boarding', 'Continuing'),
(451, 451, '2025-26', 'Primary', 'P.7', 'Term 1', 'A', 'Boarding', 'Continuing'),
(452, 452, '2025-26', 'Primary', 'P.7', 'Term 3', 'A', 'Boarding', 'Continuing'),
(453, 453, '2025-26', 'Primary', 'P.7', 'Term 1', 'A', 'Day', 'Continuing'),
(454, 454, '2025-26', 'Primary', 'P.7', 'Term 3', 'A', 'Boarding', 'Continuing'),
(455, 455, '2025-26', 'Primary', 'P.7', 'Term 1', 'A', 'Boarding', 'Continuing'),
(456, 456, '2025-26', 'Primary', 'P.7', 'Term 2', 'A', 'Boarding', 'Continuing'),
(457, 457, '2025-26', 'Primary', 'P.7', 'Term 1', 'A', 'Boarding', 'Continuing'),
(458, 458, '2025-26', 'Primary', 'P.7', 'Term 3', 'A', 'Day', 'Continuing'),
(459, 459, '2025-26', 'Primary', 'P.7', 'Term 3', 'A', 'Boarding', 'Continuing'),
(460, 460, '2025-26', 'Primary', 'P.7', 'Term 2', 'A', 'Day', 'Continuing'),
(461, 461, '2025-26', 'Primary', 'P.7', 'Term 1', 'B', 'Boarding', 'Continuing'),
(462, 462, '2025-26', 'Primary', 'P.7', 'Term 3', 'B', 'Day', 'Continuing'),
(463, 463, '2025-26', 'Primary', 'P.7', 'Term 2', 'B', 'Day', 'Continuing'),
(464, 464, '2025-26', 'Primary', 'P.7', 'Term 2', 'B', 'Boarding', 'Continuing'),
(465, 465, '2025-26', 'Primary', 'P.7', 'Term 1', 'B', 'Day', 'Continuing'),
(466, 466, '2025-26', 'Primary', 'P.7', 'Term 3', 'B', 'Day', 'Continuing'),
(467, 467, '2025-26', 'Primary', 'P.7', 'Term 2', 'B', 'Day', 'Continuing'),
(468, 468, '2025-26', 'Primary', 'P.7', 'Term 2', 'B', 'Boarding', 'Continuing'),
(469, 469, '2025-26', 'Primary', 'P.7', 'Term 2', 'B', 'Day', 'Continuing'),
(470, 470, '2025-26', 'Primary', 'P.7', 'Term 3', 'B', 'Day', 'Continuing'),
(471, 471, '2025-26', 'Primary', 'P.7', 'Term 3', 'C', 'Day', 'Continuing'),
(472, 472, '2025-26', 'Primary', 'P.7', 'Term 1', 'C', 'Day', 'Continuing'),
(473, 473, '2025-26', 'Primary', 'P.7', 'Term 2', 'C', 'Day', 'Continuing'),
(474, 474, '2025-26', 'Primary', 'P.7', 'Term 1', 'C', 'Boarding', 'Continuing'),
(475, 475, '2025-26', 'Primary', 'P.7', 'Term 1', 'C', 'Day', 'Continuing'),
(476, 476, '2025-26', 'Primary', 'P.7', 'Term 1', 'C', 'Day', 'Continuing'),
(477, 477, '2025-26', 'Primary', 'P.7', 'Term 1', 'C', 'Boarding', 'Continuing'),
(478, 478, '2025-26', 'Primary', 'P.7', 'Term 3', 'C', 'Day', 'Continuing'),
(479, 479, '2025-26', 'Primary', 'P.7', 'Term 1', 'C', 'Boarding', 'Continuing'),
(480, 480, '2025-26', 'Primary', 'P.7', 'Term 1', 'C', 'Boarding', 'Continuing'),
(481, 481, '2025-26', 'Primary', 'P.7', 'Term 1', 'D', 'Day', 'Continuing'),
(482, 482, '2025-26', 'Primary', 'P.7', 'Term 2', 'D', 'Day', 'Continuing'),
(483, 483, '2025-26', 'Primary', 'P.7', 'Term 1', 'D', 'Day', 'Continuing'),
(484, 484, '2025-26', 'Primary', 'P.7', 'Term 3', 'D', 'Boarding', 'Continuing'),
(485, 485, '2025-26', 'Primary', 'P.7', 'Term 2', 'D', 'Day', 'Continuing'),
(486, 486, '2025-26', 'Primary', 'P.7', 'Term 1', 'D', 'Boarding', 'Continuing'),
(487, 487, '2025-26', 'Primary', 'P.7', 'Term 1', 'D', 'Boarding', 'Continuing'),
(488, 488, '2025-26', 'Primary', 'P.7', 'Term 3', 'D', 'Boarding', 'Continuing'),
(489, 489, '2025-26', 'Primary', 'P.7', 'Term 1', 'D', 'Boarding', 'Continuing'),
(490, 490, '2025-26', 'Primary', 'P.7', 'Term 1', 'D', 'Day', 'Continuing'),
(491, 491, '2025-26', 'Primary', 'P.7', 'Term 1', 'E', 'Boarding', 'Continuing'),
(492, 492, '2025-26', 'Primary', 'P.7', 'Term 2', 'E', 'Boarding', 'Continuing'),
(493, 493, '2025-26', 'Primary', 'P.7', 'Term 2', 'E', 'Boarding', 'Continuing'),
(494, 494, '2025-26', 'Primary', 'P.7', 'Term 3', 'E', 'Boarding', 'Continuing'),
(495, 495, '2025-26', 'Primary', 'P.7', 'Term 1', 'E', 'Day', 'Continuing'),
(496, 496, '2025-26', 'Primary', 'P.7', 'Term 3', 'E', 'Boarding', 'Continuing'),
(497, 497, '2025-26', 'Primary', 'P.7', 'Term 3', 'E', 'Boarding', 'Continuing'),
(498, 498, '2025-26', 'Primary', 'P.7', 'Term 1', 'E', 'Day', 'Continuing'),
(499, 499, '2025-26', 'Primary', 'P.7', 'Term 2', 'E', 'Day', 'Continuing'),
(500, 500, '2025-26', 'Primary', 'P.7', 'Term 3', 'E', 'Boarding', 'Continuing'),
(501, 501, '2025-26', 'Secondary', 'S.1', 'Term 2', 'A', 'Boarding', 'New'),
(502, 502, '2025-26', 'Secondary', 'S.1', 'Term 2', 'A', 'Boarding', 'New'),
(503, 503, '2025-26', 'Secondary', 'S.1', 'Term 1', 'A', 'Boarding', 'New'),
(504, 504, '2025-26', 'Secondary', 'S.1', 'Term 2', 'A', 'Day', 'New'),
(505, 505, '2025-26', 'Secondary', 'S.1', 'Term 1', 'A', 'Day', 'New'),
(506, 506, '2025-26', 'Secondary', 'S.1', 'Term 1', 'A', 'Day', 'New'),
(507, 507, '2025-26', 'Secondary', 'S.1', 'Term 3', 'A', 'Boarding', 'New'),
(508, 508, '2025-26', 'Secondary', 'S.1', 'Term 1', 'A', 'Boarding', 'New'),
(509, 509, '2025-26', 'Secondary', 'S.1', 'Term 1', 'A', 'Day', 'New'),
(510, 510, '2025-26', 'Secondary', 'S.1', 'Term 2', 'A', 'Day', 'New'),
(511, 511, '2025-26', 'Secondary', 'S.1', 'Term 3', 'B', 'Boarding', 'New'),
(512, 512, '2025-26', 'Secondary', 'S.1', 'Term 2', 'B', 'Day', 'New'),
(513, 513, '2025-26', 'Secondary', 'S.1', 'Term 1', 'B', 'Day', 'New'),
(514, 514, '2025-26', 'Secondary', 'S.1', 'Term 1', 'B', 'Boarding', 'New'),
(515, 515, '2025-26', 'Secondary', 'S.1', 'Term 1', 'B', 'Day', 'New'),
(516, 516, '2025-26', 'Secondary', 'S.1', 'Term 1', 'B', 'Boarding', 'New'),
(517, 517, '2025-26', 'Secondary', 'S.1', 'Term 2', 'B', 'Day', 'New'),
(518, 518, '2025-26', 'Secondary', 'S.1', 'Term 3', 'B', 'Boarding', 'New'),
(519, 519, '2025-26', 'Secondary', 'S.1', 'Term 1', 'B', 'Boarding', 'New'),
(520, 520, '2025-26', 'Secondary', 'S.1', 'Term 1', 'B', 'Day', 'New'),
(521, 521, '2025-26', 'Secondary', 'S.1', 'Term 2', 'C', 'Boarding', 'New'),
(522, 522, '2025-26', 'Secondary', 'S.1', 'Term 1', 'C', 'Day', 'New'),
(523, 523, '2025-26', 'Secondary', 'S.1', 'Term 1', 'C', 'Boarding', 'New'),
(524, 524, '2025-26', 'Secondary', 'S.1', 'Term 1', 'C', 'Day', 'New'),
(525, 525, '2025-26', 'Secondary', 'S.1', 'Term 2', 'C', 'Day', 'New'),
(526, 526, '2025-26', 'Secondary', 'S.1', 'Term 2', 'C', 'Day', 'New'),
(527, 527, '2025-26', 'Secondary', 'S.1', 'Term 2', 'C', 'Boarding', 'New'),
(528, 528, '2025-26', 'Secondary', 'S.1', 'Term 2', 'C', 'Boarding', 'New'),
(529, 529, '2025-26', 'Secondary', 'S.1', 'Term 3', 'C', 'Boarding', 'New'),
(530, 530, '2025-26', 'Secondary', 'S.1', 'Term 3', 'C', 'Boarding', 'New'),
(531, 531, '2025-26', 'Secondary', 'S.1', 'Term 2', 'D', 'Boarding', 'New'),
(532, 532, '2025-26', 'Secondary', 'S.1', 'Term 1', 'D', 'Boarding', 'New'),
(533, 533, '2025-26', 'Secondary', 'S.1', 'Term 3', 'D', 'Day', 'New'),
(534, 534, '2025-26', 'Secondary', 'S.1', 'Term 1', 'D', 'Day', 'New'),
(535, 535, '2025-26', 'Secondary', 'S.1', 'Term 3', 'D', 'Day', 'New'),
(536, 536, '2025-26', 'Secondary', 'S.1', 'Term 3', 'D', 'Boarding', 'New'),
(537, 537, '2025-26', 'Secondary', 'S.1', 'Term 2', 'D', 'Day', 'New'),
(538, 538, '2025-26', 'Secondary', 'S.1', 'Term 3', 'D', 'Day', 'New'),
(539, 539, '2025-26', 'Secondary', 'S.1', 'Term 1', 'D', 'Boarding', 'New'),
(540, 540, '2025-26', 'Secondary', 'S.1', 'Term 3', 'D', 'Day', 'New'),
(541, 541, '2025-26', 'Secondary', 'S.1', 'Term 3', 'E', 'Boarding', 'New'),
(542, 542, '2025-26', 'Secondary', 'S.1', 'Term 2', 'E', 'Boarding', 'New'),
(543, 543, '2025-26', 'Secondary', 'S.1', 'Term 1', 'E', 'Day', 'New'),
(544, 544, '2025-26', 'Secondary', 'S.1', 'Term 2', 'E', 'Boarding', 'New'),
(545, 545, '2025-26', 'Secondary', 'S.1', 'Term 3', 'E', 'Boarding', 'New'),
(546, 546, '2025-26', 'Secondary', 'S.1', 'Term 1', 'E', 'Boarding', 'New'),
(547, 547, '2025-26', 'Secondary', 'S.1', 'Term 3', 'E', 'Boarding', 'New'),
(548, 548, '2025-26', 'Secondary', 'S.1', 'Term 2', 'E', 'Day', 'New'),
(549, 549, '2025-26', 'Secondary', 'S.1', 'Term 2', 'E', 'Boarding', 'New'),
(550, 550, '2025-26', 'Secondary', 'S.1', 'Term 2', 'E', 'Boarding', 'New'),
(551, 551, '2025-26', 'Secondary', 'S.2', 'Term 1', 'A', 'Day', 'Continuing'),
(552, 552, '2025-26', 'Secondary', 'S.2', 'Term 1', 'A', 'Day', 'Continuing'),
(553, 553, '2025-26', 'Secondary', 'S.2', 'Term 2', 'A', 'Boarding', 'Continuing'),
(554, 554, '2025-26', 'Secondary', 'S.2', 'Term 3', 'A', 'Boarding', 'Continuing'),
(555, 555, '2025-26', 'Secondary', 'S.2', 'Term 3', 'A', 'Day', 'Continuing'),
(556, 556, '2025-26', 'Secondary', 'S.2', 'Term 3', 'A', 'Boarding', 'Continuing'),
(557, 557, '2025-26', 'Secondary', 'S.2', 'Term 1', 'A', 'Day', 'Continuing'),
(558, 558, '2025-26', 'Secondary', 'S.2', 'Term 2', 'A', 'Boarding', 'Continuing'),
(559, 559, '2025-26', 'Secondary', 'S.2', 'Term 1', 'A', 'Boarding', 'Continuing'),
(560, 560, '2025-26', 'Secondary', 'S.2', 'Term 1', 'A', 'Boarding', 'Continuing'),
(561, 561, '2025-26', 'Secondary', 'S.2', 'Term 1', 'B', 'Day', 'Continuing'),
(562, 562, '2025-26', 'Secondary', 'S.2', 'Term 3', 'B', 'Day', 'Continuing'),
(563, 563, '2025-26', 'Secondary', 'S.2', 'Term 1', 'B', 'Boarding', 'Continuing'),
(564, 564, '2025-26', 'Secondary', 'S.2', 'Term 1', 'B', 'Day', 'Continuing'),
(565, 565, '2025-26', 'Secondary', 'S.2', 'Term 1', 'B', 'Day', 'Continuing'),
(566, 566, '2025-26', 'Secondary', 'S.2', 'Term 2', 'B', 'Day', 'Continuing'),
(567, 567, '2025-26', 'Secondary', 'S.2', 'Term 1', 'B', 'Day', 'Continuing'),
(568, 568, '2025-26', 'Secondary', 'S.2', 'Term 2', 'B', 'Boarding', 'Continuing'),
(569, 569, '2025-26', 'Secondary', 'S.2', 'Term 2', 'B', 'Day', 'Continuing'),
(570, 570, '2025-26', 'Secondary', 'S.2', 'Term 2', 'B', 'Day', 'Continuing'),
(571, 571, '2025-26', 'Secondary', 'S.2', 'Term 1', 'C', 'Day', 'Continuing'),
(572, 572, '2025-26', 'Secondary', 'S.2', 'Term 3', 'C', 'Day', 'Continuing'),
(573, 573, '2025-26', 'Secondary', 'S.2', 'Term 1', 'C', 'Boarding', 'Continuing'),
(574, 574, '2025-26', 'Secondary', 'S.2', 'Term 3', 'C', 'Boarding', 'Continuing'),
(575, 575, '2025-26', 'Secondary', 'S.2', 'Term 3', 'C', 'Day', 'Continuing'),
(576, 576, '2025-26', 'Secondary', 'S.2', 'Term 3', 'C', 'Day', 'Continuing'),
(577, 577, '2025-26', 'Secondary', 'S.2', 'Term 2', 'C', 'Day', 'Continuing'),
(578, 578, '2025-26', 'Secondary', 'S.2', 'Term 2', 'C', 'Day', 'Continuing'),
(579, 579, '2025-26', 'Secondary', 'S.2', 'Term 2', 'C', 'Boarding', 'Continuing'),
(580, 580, '2025-26', 'Secondary', 'S.2', 'Term 3', 'C', 'Day', 'Continuing'),
(581, 581, '2025-26', 'Secondary', 'S.2', 'Term 3', 'D', 'Boarding', 'Continuing'),
(582, 582, '2025-26', 'Secondary', 'S.2', 'Term 2', 'D', 'Day', 'Continuing'),
(583, 583, '2025-26', 'Secondary', 'S.2', 'Term 1', 'D', 'Boarding', 'Continuing'),
(584, 584, '2025-26', 'Secondary', 'S.2', 'Term 2', 'D', 'Day', 'Continuing'),
(585, 585, '2025-26', 'Secondary', 'S.2', 'Term 3', 'D', 'Day', 'Continuing'),
(586, 586, '2025-26', 'Secondary', 'S.2', 'Term 2', 'D', 'Boarding', 'Continuing'),
(587, 587, '2025-26', 'Secondary', 'S.2', 'Term 3', 'D', 'Day', 'Continuing'),
(588, 588, '2025-26', 'Secondary', 'S.2', 'Term 2', 'D', 'Day', 'Continuing'),
(589, 589, '2025-26', 'Secondary', 'S.2', 'Term 3', 'D', 'Day', 'Continuing'),
(590, 590, '2025-26', 'Secondary', 'S.2', 'Term 1', 'D', 'Boarding', 'Continuing'),
(591, 591, '2025-26', 'Secondary', 'S.2', 'Term 3', 'E', 'Day', 'Continuing'),
(592, 592, '2025-26', 'Secondary', 'S.2', 'Term 1', 'E', 'Boarding', 'Continuing'),
(593, 593, '2025-26', 'Secondary', 'S.2', 'Term 2', 'E', 'Day', 'Continuing'),
(594, 594, '2025-26', 'Secondary', 'S.2', 'Term 2', 'E', 'Day', 'Continuing'),
(595, 595, '2025-26', 'Secondary', 'S.2', 'Term 2', 'E', 'Boarding', 'Continuing'),
(596, 596, '2025-26', 'Secondary', 'S.2', 'Term 2', 'E', 'Day', 'Continuing'),
(597, 597, '2025-26', 'Secondary', 'S.2', 'Term 1', 'E', 'Boarding', 'Continuing'),
(598, 598, '2025-26', 'Secondary', 'S.2', 'Term 3', 'E', 'Boarding', 'Continuing'),
(599, 599, '2025-26', 'Secondary', 'S.2', 'Term 3', 'E', 'Day', 'Continuing'),
(600, 600, '2025-26', 'Secondary', 'S.2', 'Term 1', 'E', 'Day', 'Continuing'),
(601, 601, '2025-26', 'Secondary', 'S.3', 'Term 3', 'A', 'Boarding', 'Continuing'),
(602, 602, '2025-26', 'Secondary', 'S.3', 'Term 2', 'A', 'Day', 'Continuing'),
(603, 603, '2025-26', 'Secondary', 'S.3', 'Term 1', 'A', 'Boarding', 'Continuing'),
(604, 604, '2025-26', 'Secondary', 'S.3', 'Term 3', 'A', 'Day', 'Continuing'),
(605, 605, '2025-26', 'Secondary', 'S.3', 'Term 3', 'A', 'Boarding', 'Continuing'),
(606, 606, '2025-26', 'Secondary', 'S.3', 'Term 2', 'A', 'Boarding', 'Continuing'),
(607, 607, '2025-26', 'Secondary', 'S.3', 'Term 3', 'A', 'Day', 'Continuing'),
(608, 608, '2025-26', 'Secondary', 'S.3', 'Term 1', 'A', 'Boarding', 'Continuing'),
(609, 609, '2025-26', 'Secondary', 'S.3', 'Term 3', 'A', 'Boarding', 'Continuing'),
(610, 610, '2025-26', 'Secondary', 'S.3', 'Term 2', 'A', 'Boarding', 'Continuing'),
(611, 611, '2025-26', 'Secondary', 'S.3', 'Term 2', 'B', 'Boarding', 'Continuing'),
(612, 612, '2025-26', 'Secondary', 'S.3', 'Term 1', 'B', 'Day', 'Continuing'),
(613, 613, '2025-26', 'Secondary', 'S.3', 'Term 1', 'B', 'Boarding', 'Continuing'),
(614, 614, '2025-26', 'Secondary', 'S.3', 'Term 3', 'B', 'Boarding', 'Continuing'),
(615, 615, '2025-26', 'Secondary', 'S.3', 'Term 1', 'B', 'Boarding', 'Continuing'),
(616, 616, '2025-26', 'Secondary', 'S.3', 'Term 2', 'B', 'Day', 'Continuing'),
(617, 617, '2025-26', 'Secondary', 'S.3', 'Term 2', 'B', 'Boarding', 'Continuing'),
(618, 618, '2025-26', 'Secondary', 'S.3', 'Term 2', 'B', 'Day', 'Continuing'),
(619, 619, '2025-26', 'Secondary', 'S.3', 'Term 3', 'B', 'Boarding', 'Continuing'),
(620, 620, '2025-26', 'Secondary', 'S.3', 'Term 1', 'B', 'Boarding', 'Continuing'),
(621, 621, '2025-26', 'Secondary', 'S.3', 'Term 1', 'C', 'Boarding', 'Continuing'),
(622, 622, '2025-26', 'Secondary', 'S.3', 'Term 3', 'C', 'Boarding', 'Continuing'),
(623, 623, '2025-26', 'Secondary', 'S.3', 'Term 3', 'C', 'Day', 'Continuing'),
(624, 624, '2025-26', 'Secondary', 'S.3', 'Term 1', 'C', 'Boarding', 'Continuing'),
(625, 625, '2025-26', 'Secondary', 'S.3', 'Term 1', 'C', 'Day', 'Continuing'),
(626, 626, '2025-26', 'Secondary', 'S.3', 'Term 3', 'C', 'Day', 'Continuing'),
(627, 627, '2025-26', 'Secondary', 'S.3', 'Term 1', 'C', 'Day', 'Continuing'),
(628, 628, '2025-26', 'Secondary', 'S.3', 'Term 3', 'C', 'Boarding', 'Continuing'),
(629, 629, '2025-26', 'Secondary', 'S.3', 'Term 2', 'C', 'Boarding', 'Continuing'),
(630, 630, '2025-26', 'Secondary', 'S.3', 'Term 1', 'C', 'Boarding', 'Continuing'),
(631, 631, '2025-26', 'Secondary', 'S.3', 'Term 3', 'D', 'Boarding', 'Continuing'),
(632, 632, '2025-26', 'Secondary', 'S.3', 'Term 3', 'D', 'Boarding', 'Continuing'),
(633, 633, '2025-26', 'Secondary', 'S.3', 'Term 1', 'D', 'Day', 'Continuing'),
(634, 634, '2025-26', 'Secondary', 'S.3', 'Term 3', 'D', 'Day', 'Continuing'),
(635, 635, '2025-26', 'Secondary', 'S.3', 'Term 3', 'D', 'Boarding', 'Continuing'),
(636, 636, '2025-26', 'Secondary', 'S.3', 'Term 3', 'D', 'Day', 'Continuing'),
(637, 637, '2025-26', 'Secondary', 'S.3', 'Term 2', 'D', 'Boarding', 'Continuing'),
(638, 638, '2025-26', 'Secondary', 'S.3', 'Term 1', 'D', 'Boarding', 'Continuing'),
(639, 639, '2025-26', 'Secondary', 'S.3', 'Term 3', 'D', 'Day', 'Continuing'),
(640, 640, '2025-26', 'Secondary', 'S.3', 'Term 3', 'D', 'Boarding', 'Continuing'),
(641, 641, '2025-26', 'Secondary', 'S.3', 'Term 1', 'E', 'Boarding', 'Continuing'),
(642, 642, '2025-26', 'Secondary', 'S.3', 'Term 1', 'E', 'Day', 'Continuing'),
(643, 643, '2025-26', 'Secondary', 'S.3', 'Term 2', 'E', 'Day', 'Continuing'),
(644, 644, '2025-26', 'Secondary', 'S.3', 'Term 3', 'E', 'Day', 'Continuing'),
(645, 645, '2025-26', 'Secondary', 'S.3', 'Term 2', 'E', 'Day', 'Continuing');
INSERT INTO `enrollment` (`EnrollmentID`, `AdmissionNo`, `AcademicYear`, `Level`, `Class`, `Term`, `Stream`, `Residence`, `EntryStatus`) VALUES
(646, 646, '2025-26', 'Secondary', 'S.3', 'Term 1', 'E', 'Boarding', 'Continuing'),
(647, 647, '2025-26', 'Secondary', 'S.3', 'Term 3', 'E', 'Day', 'Continuing'),
(648, 648, '2025-26', 'Secondary', 'S.3', 'Term 3', 'E', 'Day', 'Continuing'),
(649, 649, '2025-26', 'Secondary', 'S.3', 'Term 1', 'E', 'Day', 'Continuing'),
(650, 650, '2025-26', 'Secondary', 'S.3', 'Term 1', 'E', 'Boarding', 'Continuing'),
(651, 651, '2025-26', 'Secondary', 'S.4', 'Term 1', 'A', 'Boarding', 'Continuing'),
(652, 652, '2025-26', 'Secondary', 'S.4', 'Term 1', 'A', 'Day', 'Continuing'),
(653, 653, '2025-26', 'Secondary', 'S.4', 'Term 3', 'A', 'Day', 'Continuing'),
(654, 654, '2025-26', 'Secondary', 'S.4', 'Term 3', 'A', 'Day', 'Continuing'),
(655, 655, '2025-26', 'Secondary', 'S.4', 'Term 1', 'A', 'Day', 'Continuing'),
(656, 656, '2025-26', 'Secondary', 'S.4', 'Term 3', 'A', 'Boarding', 'Continuing'),
(657, 657, '2025-26', 'Secondary', 'S.4', 'Term 2', 'A', 'Boarding', 'Continuing'),
(658, 658, '2025-26', 'Secondary', 'S.4', 'Term 3', 'A', 'Day', 'Continuing'),
(659, 659, '2025-26', 'Secondary', 'S.4', 'Term 3', 'A', 'Boarding', 'Continuing'),
(660, 660, '2025-26', 'Secondary', 'S.4', 'Term 1', 'A', 'Boarding', 'Continuing'),
(661, 661, '2025-26', 'Secondary', 'S.4', 'Term 1', 'B', 'Boarding', 'Continuing'),
(662, 662, '2025-26', 'Secondary', 'S.4', 'Term 1', 'B', 'Boarding', 'Continuing'),
(663, 663, '2025-26', 'Secondary', 'S.4', 'Term 3', 'B', 'Day', 'Continuing'),
(664, 664, '2025-26', 'Secondary', 'S.4', 'Term 3', 'B', 'Boarding', 'Continuing'),
(665, 665, '2025-26', 'Secondary', 'S.4', 'Term 2', 'B', 'Boarding', 'Continuing'),
(666, 666, '2025-26', 'Secondary', 'S.4', 'Term 3', 'B', 'Boarding', 'Continuing'),
(667, 667, '2025-26', 'Secondary', 'S.4', 'Term 3', 'B', 'Boarding', 'Continuing'),
(668, 668, '2025-26', 'Secondary', 'S.4', 'Term 2', 'B', 'Boarding', 'Continuing'),
(669, 669, '2025-26', 'Secondary', 'S.4', 'Term 1', 'B', 'Day', 'Continuing'),
(670, 670, '2025-26', 'Secondary', 'S.4', 'Term 1', 'B', 'Day', 'Continuing'),
(671, 671, '2025-26', 'Secondary', 'S.4', 'Term 2', 'C', 'Day', 'Continuing'),
(672, 672, '2025-26', 'Secondary', 'S.4', 'Term 2', 'C', 'Boarding', 'Continuing'),
(673, 673, '2025-26', 'Secondary', 'S.4', 'Term 1', 'C', 'Day', 'Continuing'),
(674, 674, '2025-26', 'Secondary', 'S.4', 'Term 2', 'C', 'Day', 'Continuing'),
(675, 675, '2025-26', 'Secondary', 'S.4', 'Term 3', 'C', 'Day', 'Continuing'),
(676, 676, '2025-26', 'Secondary', 'S.4', 'Term 1', 'C', 'Day', 'Continuing'),
(677, 677, '2025-26', 'Secondary', 'S.4', 'Term 3', 'C', 'Boarding', 'Continuing'),
(678, 678, '2025-26', 'Secondary', 'S.4', 'Term 3', 'C', 'Boarding', 'Continuing'),
(679, 679, '2025-26', 'Secondary', 'S.4', 'Term 3', 'C', 'Boarding', 'Continuing'),
(680, 680, '2025-26', 'Secondary', 'S.4', 'Term 2', 'C', 'Day', 'Continuing'),
(681, 681, '2025-26', 'Secondary', 'S.4', 'Term 3', 'D', 'Day', 'Continuing'),
(682, 682, '2025-26', 'Secondary', 'S.4', 'Term 3', 'D', 'Day', 'Continuing'),
(683, 683, '2025-26', 'Secondary', 'S.4', 'Term 1', 'D', 'Boarding', 'Continuing'),
(684, 684, '2025-26', 'Secondary', 'S.4', 'Term 1', 'D', 'Day', 'Continuing'),
(685, 685, '2025-26', 'Secondary', 'S.4', 'Term 1', 'D', 'Day', 'Continuing'),
(686, 686, '2025-26', 'Secondary', 'S.4', 'Term 2', 'D', 'Day', 'Continuing'),
(687, 687, '2025-26', 'Secondary', 'S.4', 'Term 1', 'D', 'Boarding', 'Continuing'),
(688, 688, '2025-26', 'Secondary', 'S.4', 'Term 2', 'D', 'Day', 'Continuing'),
(689, 689, '2025-26', 'Secondary', 'S.4', 'Term 1', 'D', 'Boarding', 'Continuing'),
(690, 690, '2025-26', 'Secondary', 'S.4', 'Term 1', 'D', 'Day', 'Continuing'),
(691, 691, '2025-26', 'Secondary', 'S.4', 'Term 3', 'E', 'Day', 'Continuing'),
(692, 692, '2025-26', 'Secondary', 'S.4', 'Term 3', 'E', 'Day', 'Continuing'),
(693, 693, '2025-26', 'Secondary', 'S.4', 'Term 1', 'E', 'Day', 'Continuing'),
(694, 694, '2025-26', 'Secondary', 'S.4', 'Term 2', 'E', 'Boarding', 'Continuing'),
(695, 695, '2025-26', 'Secondary', 'S.4', 'Term 3', 'E', 'Boarding', 'Continuing'),
(696, 696, '2025-26', 'Secondary', 'S.4', 'Term 2', 'E', 'Day', 'Continuing'),
(697, 697, '2025-26', 'Secondary', 'S.4', 'Term 2', 'E', 'Day', 'Continuing'),
(698, 698, '2025-26', 'Secondary', 'S.4', 'Term 1', 'E', 'Day', 'Continuing'),
(699, 699, '2025-26', 'Secondary', 'S.4', 'Term 3', 'E', 'Boarding', 'Continuing'),
(700, 700, '2025-26', 'Secondary', 'S.4', 'Term 2', 'E', 'Boarding', 'Continuing'),
(701, 701, '2025-26', 'Secondary', 'S.5', 'Term 3', 'A', 'Boarding', 'Continuing'),
(702, 702, '2025-26', 'Secondary', 'S.5', 'Term 1', 'A', 'Day', 'Continuing'),
(703, 703, '2025-26', 'Secondary', 'S.5', 'Term 3', 'A', 'Boarding', 'Continuing'),
(704, 704, '2025-26', 'Secondary', 'S.5', 'Term 3', 'A', 'Boarding', 'Continuing'),
(705, 705, '2025-26', 'Secondary', 'S.5', 'Term 2', 'A', 'Boarding', 'Continuing'),
(706, 706, '2025-26', 'Secondary', 'S.5', 'Term 1', 'A', 'Boarding', 'Continuing'),
(707, 707, '2025-26', 'Secondary', 'S.5', 'Term 3', 'A', 'Boarding', 'Continuing'),
(708, 708, '2025-26', 'Secondary', 'S.5', 'Term 1', 'A', 'Day', 'Continuing'),
(709, 709, '2025-26', 'Secondary', 'S.5', 'Term 3', 'A', 'Boarding', 'Continuing'),
(710, 710, '2025-26', 'Secondary', 'S.5', 'Term 2', 'A', 'Boarding', 'Continuing'),
(711, 711, '2025-26', 'Secondary', 'S.5', 'Term 2', 'B', 'Day', 'Continuing'),
(712, 712, '2025-26', 'Secondary', 'S.5', 'Term 3', 'B', 'Day', 'Continuing'),
(713, 713, '2025-26', 'Secondary', 'S.5', 'Term 1', 'B', 'Day', 'Continuing'),
(714, 714, '2025-26', 'Secondary', 'S.5', 'Term 2', 'B', 'Boarding', 'Continuing'),
(715, 715, '2025-26', 'Secondary', 'S.5', 'Term 1', 'B', 'Day', 'Continuing'),
(716, 716, '2025-26', 'Secondary', 'S.5', 'Term 3', 'B', 'Boarding', 'Continuing'),
(717, 717, '2025-26', 'Secondary', 'S.5', 'Term 3', 'B', 'Boarding', 'Continuing'),
(718, 718, '2025-26', 'Secondary', 'S.5', 'Term 1', 'B', 'Boarding', 'Continuing'),
(719, 719, '2025-26', 'Secondary', 'S.5', 'Term 3', 'B', 'Boarding', 'Continuing'),
(720, 720, '2025-26', 'Secondary', 'S.5', 'Term 2', 'B', 'Boarding', 'Continuing'),
(721, 721, '2025-26', 'Secondary', 'S.5', 'Term 3', 'C', 'Day', 'Continuing'),
(722, 722, '2025-26', 'Secondary', 'S.5', 'Term 2', 'C', 'Day', 'Continuing'),
(723, 723, '2025-26', 'Secondary', 'S.5', 'Term 2', 'C', 'Boarding', 'Continuing'),
(724, 724, '2025-26', 'Secondary', 'S.5', 'Term 1', 'C', 'Boarding', 'Continuing'),
(725, 725, '2025-26', 'Secondary', 'S.5', 'Term 3', 'C', 'Day', 'Continuing'),
(726, 726, '2025-26', 'Secondary', 'S.5', 'Term 2', 'C', 'Boarding', 'Continuing'),
(727, 727, '2025-26', 'Secondary', 'S.5', 'Term 3', 'C', 'Day', 'Continuing'),
(728, 728, '2025-26', 'Secondary', 'S.5', 'Term 2', 'C', 'Day', 'Continuing'),
(729, 729, '2025-26', 'Secondary', 'S.5', 'Term 2', 'C', 'Day', 'Continuing'),
(730, 730, '2025-26', 'Secondary', 'S.5', 'Term 1', 'C', 'Boarding', 'Continuing'),
(731, 731, '2025-26', 'Secondary', 'S.5', 'Term 2', 'D', 'Boarding', 'Continuing'),
(732, 732, '2025-26', 'Secondary', 'S.5', 'Term 1', 'D', 'Day', 'Continuing'),
(733, 733, '2025-26', 'Secondary', 'S.5', 'Term 3', 'D', 'Day', 'Continuing'),
(734, 734, '2025-26', 'Secondary', 'S.5', 'Term 3', 'D', 'Boarding', 'Continuing'),
(735, 735, '2025-26', 'Secondary', 'S.5', 'Term 3', 'D', 'Boarding', 'Continuing'),
(736, 736, '2025-26', 'Secondary', 'S.5', 'Term 2', 'D', 'Day', 'Continuing'),
(737, 737, '2025-26', 'Secondary', 'S.5', 'Term 3', 'D', 'Boarding', 'Continuing'),
(738, 738, '2025-26', 'Secondary', 'S.5', 'Term 2', 'D', 'Day', 'Continuing'),
(739, 739, '2025-26', 'Secondary', 'S.5', 'Term 2', 'D', 'Boarding', 'Continuing'),
(740, 740, '2025-26', 'Secondary', 'S.5', 'Term 2', 'D', 'Boarding', 'Continuing'),
(741, 741, '2025-26', 'Secondary', 'S.5', 'Term 2', 'E', 'Day', 'Continuing'),
(742, 742, '2025-26', 'Secondary', 'S.5', 'Term 2', 'E', 'Boarding', 'Continuing'),
(743, 743, '2025-26', 'Secondary', 'S.5', 'Term 3', 'E', 'Boarding', 'Continuing'),
(744, 744, '2025-26', 'Secondary', 'S.5', 'Term 1', 'E', 'Boarding', 'Continuing'),
(745, 745, '2025-26', 'Secondary', 'S.5', 'Term 1', 'E', 'Boarding', 'Continuing'),
(746, 746, '2025-26', 'Secondary', 'S.5', 'Term 1', 'E', 'Day', 'Continuing'),
(747, 747, '2025-26', 'Secondary', 'S.5', 'Term 3', 'E', 'Boarding', 'Continuing'),
(748, 748, '2025-26', 'Secondary', 'S.5', 'Term 1', 'E', 'Day', 'Continuing'),
(749, 749, '2025-26', 'Secondary', 'S.5', 'Term 3', 'E', 'Day', 'Continuing'),
(750, 750, '2025-26', 'Secondary', 'S.5', 'Term 2', 'E', 'Day', 'Continuing'),
(751, 751, '2025-26', 'Secondary', 'S.6', 'Term 3', 'A', 'Boarding', 'Continuing'),
(752, 752, '2025-26', 'Secondary', 'S.6', 'Term 1', 'A', 'Day', 'Continuing'),
(753, 753, '2025-26', 'Secondary', 'S.6', 'Term 2', 'A', 'Day', 'Continuing'),
(754, 754, '2025-26', 'Secondary', 'S.6', 'Term 1', 'A', 'Day', 'Continuing'),
(755, 755, '2025-26', 'Secondary', 'S.6', 'Term 2', 'A', 'Boarding', 'Continuing'),
(756, 756, '2025-26', 'Secondary', 'S.6', 'Term 1', 'A', 'Boarding', 'Continuing'),
(757, 757, '2025-26', 'Secondary', 'S.6', 'Term 3', 'A', 'Day', 'Continuing'),
(758, 758, '2025-26', 'Secondary', 'S.6', 'Term 1', 'A', 'Boarding', 'Continuing'),
(759, 759, '2025-26', 'Secondary', 'S.6', 'Term 3', 'A', 'Day', 'Continuing'),
(760, 760, '2025-26', 'Secondary', 'S.6', 'Term 3', 'A', 'Day', 'Continuing'),
(761, 761, '2025-26', 'Secondary', 'S.6', 'Term 3', 'B', 'Day', 'Continuing'),
(762, 762, '2025-26', 'Secondary', 'S.6', 'Term 2', 'B', 'Boarding', 'Continuing'),
(763, 763, '2025-26', 'Secondary', 'S.6', 'Term 2', 'B', 'Day', 'Continuing'),
(764, 764, '2025-26', 'Secondary', 'S.6', 'Term 3', 'B', 'Boarding', 'Continuing'),
(765, 765, '2025-26', 'Secondary', 'S.6', 'Term 2', 'B', 'Day', 'Continuing'),
(766, 766, '2025-26', 'Secondary', 'S.6', 'Term 1', 'B', 'Boarding', 'Continuing'),
(767, 767, '2025-26', 'Secondary', 'S.6', 'Term 2', 'B', 'Boarding', 'Continuing'),
(768, 768, '2025-26', 'Secondary', 'S.6', 'Term 2', 'B', 'Boarding', 'Continuing'),
(769, 769, '2025-26', 'Secondary', 'S.6', 'Term 1', 'B', 'Day', 'Continuing'),
(770, 770, '2025-26', 'Secondary', 'S.6', 'Term 3', 'B', 'Day', 'Continuing'),
(771, 771, '2025-26', 'Secondary', 'S.6', 'Term 3', 'C', 'Boarding', 'Continuing'),
(772, 772, '2025-26', 'Secondary', 'S.6', 'Term 3', 'C', 'Boarding', 'Continuing'),
(773, 773, '2025-26', 'Secondary', 'S.6', 'Term 1', 'C', 'Day', 'Continuing'),
(774, 774, '2025-26', 'Secondary', 'S.6', 'Term 3', 'C', 'Boarding', 'Continuing'),
(775, 775, '2025-26', 'Secondary', 'S.6', 'Term 1', 'C', 'Boarding', 'Continuing'),
(776, 776, '2025-26', 'Secondary', 'S.6', 'Term 2', 'C', 'Day', 'Continuing'),
(777, 777, '2025-26', 'Secondary', 'S.6', 'Term 3', 'C', 'Day', 'Continuing'),
(778, 778, '2025-26', 'Secondary', 'S.6', 'Term 3', 'C', 'Day', 'Continuing'),
(779, 779, '2025-26', 'Secondary', 'S.6', 'Term 2', 'C', 'Day', 'Continuing'),
(780, 780, '2025-26', 'Secondary', 'S.6', 'Term 2', 'C', 'Day', 'Continuing'),
(781, 781, '2025-26', 'Secondary', 'S.6', 'Term 3', 'D', 'Day', 'Continuing'),
(782, 782, '2025-26', 'Secondary', 'S.6', 'Term 2', 'D', 'Boarding', 'Continuing'),
(783, 783, '2025-26', 'Secondary', 'S.6', 'Term 1', 'D', 'Boarding', 'Continuing'),
(784, 784, '2025-26', 'Secondary', 'S.6', 'Term 1', 'D', 'Boarding', 'Continuing'),
(785, 785, '2025-26', 'Secondary', 'S.6', 'Term 1', 'D', 'Day', 'Continuing'),
(786, 786, '2025-26', 'Secondary', 'S.6', 'Term 1', 'D', 'Boarding', 'Continuing'),
(787, 787, '2025-26', 'Secondary', 'S.6', 'Term 3', 'D', 'Day', 'Continuing'),
(788, 788, '2025-26', 'Secondary', 'S.6', 'Term 1', 'D', 'Boarding', 'Continuing'),
(789, 789, '2025-26', 'Secondary', 'S.6', 'Term 2', 'D', 'Day', 'Continuing'),
(790, 790, '2025-26', 'Secondary', 'S.6', 'Term 3', 'D', 'Boarding', 'Continuing'),
(791, 791, '2025-26', 'Secondary', 'S.6', 'Term 1', 'E', 'Day', 'Continuing'),
(792, 792, '2025-26', 'Secondary', 'S.6', 'Term 3', 'E', 'Boarding', 'Continuing'),
(793, 793, '2025-26', 'Secondary', 'S.6', 'Term 1', 'E', 'Boarding', 'Continuing'),
(794, 794, '2025-26', 'Secondary', 'S.6', 'Term 2', 'E', 'Day', 'Continuing'),
(795, 795, '2025-26', 'Secondary', 'S.6', 'Term 3', 'E', 'Boarding', 'Continuing'),
(796, 796, '2025-26', 'Secondary', 'S.6', 'Term 1', 'E', 'Day', 'Continuing'),
(797, 797, '2025-26', 'Secondary', 'S.6', 'Term 1', 'E', 'Day', 'Continuing'),
(798, 798, '2025-26', 'Secondary', 'S.6', 'Term 2', 'E', 'Boarding', 'Continuing'),
(799, 799, '2025-26', 'Secondary', 'S.6', 'Term 2', 'E', 'Day', 'Continuing'),
(806, 814, '2025-26', 'pre-primary', 'PP.1', 'Term 1', 'B', 'Day', 'New'),
(807, 818, '2025-26', 'pre-primary', 'PP.2', 'Term 1', 'A', 'Day', 'New'),
(808, 819, '2025-26', 'primary', 'P.3', 'Term 1', 'E', 'Day', 'New'),
(809, 821, '2025-26', 'secondary', 'S.1', 'Term 1', 'A', 'Day', 'New');

-- --------------------------------------------------------

--
-- Table structure for table `enrollmenthistory`
--

CREATE TABLE `enrollmenthistory` (
  `HistoryID` int(11) NOT NULL,
  `AdmissionNo` int(11) NOT NULL,
  `AcademicYear` varchar(20) NOT NULL,
  `Level` varchar(50) NOT NULL,
  `Class` varchar(50) NOT NULL,
  `Term` varchar(50) NOT NULL,
  `Stream` varchar(50) DEFAULT NULL,
  `Residence` varchar(50) NOT NULL,
  `EntryStatus` varchar(50) NOT NULL,
  `DateMoved` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `parents`
--

CREATE TABLE `parents` (
  `ParentId` int(11) NOT NULL,
  `AdmissionNo` int(11) NOT NULL,
  `father_name` varchar(255) NOT NULL,
  `father_age` int(11) DEFAULT NULL,
  `father_contact` varchar(50) DEFAULT NULL,
  `father_email` varchar(150) DEFAULT NULL,
  `father_occupation` varchar(100) DEFAULT NULL,
  `father_education` varchar(100) DEFAULT NULL,
  `mother_name` varchar(255) NOT NULL,
  `mother_age` int(11) DEFAULT NULL,
  `mother_contact` varchar(50) DEFAULT NULL,
  `mother_email` varchar(150) DEFAULT NULL,
  `mother_occupation` varchar(100) DEFAULT NULL,
  `mother_education` varchar(100) DEFAULT NULL,
  `guardian_name` varchar(255) DEFAULT NULL,
  `guardian_relation` enum('Father','Mother','Uncle','Aunt','Grandparent','Other') DEFAULT NULL,
  `guardian_age` int(11) DEFAULT NULL,
  `guardian_contact` varchar(50) DEFAULT NULL,
  `guardian_email` varchar(150) DEFAULT NULL,
  `guardian_occupation` varchar(100) DEFAULT NULL,
  `guardian_education` varchar(100) DEFAULT NULL,
  `guardian_address` text DEFAULT NULL,
  `MoreInformation` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `parents`
--

INSERT INTO `parents` (`ParentId`, `AdmissionNo`, `father_name`, `father_age`, `father_contact`, `father_email`, `father_occupation`, `father_education`, `mother_name`, `mother_age`, `mother_contact`, `mother_email`, `mother_occupation`, `mother_education`, `guardian_name`, `guardian_relation`, `guardian_age`, `guardian_contact`, `guardian_email`, `guardian_occupation`, `guardian_education`, `guardian_address`, `MoreInformation`) VALUES
(1, 1, 'Andrew Ochieng', 66, '+256788948221', 'andrew.ochieng70@gmail.com', 'Driver', 'Diploma', 'Joan Kyomuhendo', 62, '+256752101713', 'joan.657@gmail.com', 'Civil Servant', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(2, 2, 'Ivan Nantogo', 51, '+256757781279', 'ivan.nantogo75@gmail.com', 'Driver', 'Bachelor’s Degree', 'Doreen Aine', 36, '+256772522056', 'doreen.144@gmail.com', 'Civil Servant', 'Bachelor’s Degree', 'Hellen Nantogo', 'Grandparent', 44, '+256705971104', 'hellen.47@yahoo.com', 'Driver', 'Diploma', '234 Market Lane, Lira, Lira', 'Science fair participant'),
(3, 3, 'Isaac Ssemwogerere', 63, '+256782049326', 'isaac.ssemwogerere23@gmail.com', 'Driver', 'Master’s Degree', 'Sandra Kyomuhendo', 41, '+256709349270', 'sandra.426@gmail.com', 'Tailor', 'Secondary', 'Susan Ssemwogerere', 'Other', 28, '+256704276983', 'susan.78@yahoo.com', 'Civil Servant', 'Primary', '497 Main Street, Arua, Arua', 'Football team'),
(4, 4, 'John Kato', 65, '+256754496335', 'john.kato40@gmail.com', 'Farmer', 'Secondary', 'Doreen Waiswa', 52, '+256772149725', 'doreen.208@gmail.com', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(5, 5, 'Brian Tumusiime', 57, '+256752496853', 'brian.tumusiime3@gmail.com', 'Doctor', 'Diploma', 'Sandra Akello', 50, '+256702087036', 'sandra.595@gmail.com', 'Teacher', 'Bachelor’s Degree', 'Charles Tumusiime', 'Uncle', 72, '+256771806693', 'charles.14@yahoo.com', 'Mechanic', 'Primary', '130 Main Street, Mbale, Mbale', 'Science fair participant'),
(6, 6, 'David Aine', 31, '+256779862412', 'david.aine19@gmail.com', 'Shopkeeper', 'Bachelor’s Degree', 'Grace Lwanga', 64, '+256776952980', 'grace.193@gmail.com', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(7, 7, 'Andrew Byaruhanga', 48, '+256753753546', 'andrew.byaruhanga66@gmail.com', 'Doctor', 'Master’s Degree', 'Doreen Nakato', 56, '+256784347689', 'doreen.978@gmail.com', 'Entrepreneur', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(8, 8, 'Brian Byaruhanga', 53, '+256771616560', 'brian.byaruhanga75@gmail.com', 'Civil Servant', 'Bachelor’s Degree', 'Grace Ssemwogerere', 32, '+256753479999', 'grace.788@gmail.com', 'Farmer', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(9, 9, 'Ivan Akello', 32, '+256775124986', 'ivan.akello28@gmail.com', 'Driver', 'Secondary', 'Alice Namukasa', 49, '+256782764551', 'alice.634@gmail.com', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(10, 10, 'Joseph Tumusiime', 66, '+256782977817', 'joseph.tumusiime50@gmail.com', 'Mechanic', 'Secondary', 'Joy Mugabe', 30, '+256774870340', 'joy.869@gmail.com', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(11, 11, 'Timothy Kato', 30, '+256776231501', 'timothy.kato34@gmail.com', 'Teacher', 'Primary', 'Pritah Musoke', 41, '+256703712275', 'pritah.255@gmail.com', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(12, 12, 'David Nantogo', 47, '+256753963706', 'david.nantogo8@gmail.com', 'Mechanic', 'Diploma', 'Sandra Byaruhanga', 35, '+256706039387', 'sandra.977@gmail.com', 'Nurse', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(13, 13, 'Joseph Ochieng', 59, '+256756298553', 'joseph.ochieng69@gmail.com', 'Shopkeeper', 'Bachelor’s Degree', 'Sandra Lwanga', 45, '+256773954031', 'sandra.89@gmail.com', 'Nurse', 'Master’s Degree', 'Charles Ochieng', 'Father', 40, '+256706554441', 'charles.78@yahoo.com', 'Mechanic', 'Primary', '74 Church Road, Kampala, Kampala', 'Prefect'),
(14, 14, 'Timothy Nalubega', 35, '+256777310778', 'timothy.nalubega44@gmail.com', 'Engineer', 'Secondary', 'Ritah Byaruhanga', 43, '+256784121354', 'ritah.290@gmail.com', 'Farmer', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(15, 15, 'John Kato', 35, '+256757969146', 'john.kato9@gmail.com', 'Engineer', 'Bachelor’s Degree', 'Winnie Byaruhanga', 39, '+256758892236', 'winnie.187@gmail.com', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(16, 16, 'John Musoke', 48, '+256709384221', 'john.musoke44@gmail.com', 'Mechanic', 'Secondary', 'Ritah Okello', 54, '+256785570992', 'ritah.247@gmail.com', 'Housewife', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(17, 17, 'John Kyomuhendo', 51, '+256785316918', 'john.kyomuhendo58@gmail.com', 'Carpenter', 'Bachelor’s Degree', 'Pritah Mukasa', 47, '+256703440080', 'pritah.868@gmail.com', 'Nurse', 'Bachelor’s Degree', 'James Kyomuhendo', 'Uncle', 41, '+256751470084', 'james.31@yahoo.com', 'Farmer', 'Bachelor’s Degree', '400 School Road, Masaka, Masaka', 'Prefect'),
(18, 18, 'Daniel Aine', 47, '+256773449210', 'daniel.aine64@gmail.com', 'Doctor', 'Master’s Degree', 'Sarah Lwanga', 59, '+256704629712', 'sarah.809@gmail.com', 'Housewife', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(19, 19, 'Peter Namukasa', 65, '+256757537284', 'peter.namukasa41@gmail.com', 'Farmer', 'Diploma', 'Sandra Okello', 38, '+256771568686', 'sandra.96@gmail.com', 'Farmer', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(20, 20, 'Peter Opio', 62, '+256757738644', 'peter.opio20@gmail.com', 'Engineer', 'Diploma', 'Esther Namukasa', 64, '+256772021712', 'esther.64@gmail.com', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(21, 21, 'Ivan Tumusiime', 59, '+256708718546', 'ivan.tumusiime45@gmail.com', 'Doctor', 'Secondary', 'Joan Mugabe', 41, '+256707266410', 'joan.491@gmail.com', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(22, 22, 'Solomon Nantogo', 53, '+256779034777', 'solomon.nantogo44@gmail.com', 'Shopkeeper', 'Primary', 'Mary Nantogo', 42, '+256783570660', 'mary.48@gmail.com', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(23, 23, 'Isaac Nalubega', 39, '+256783875346', 'isaac.nalubega63@gmail.com', 'Doctor', 'Diploma', 'Ritah Ochieng', 28, '+256757713329', 'ritah.849@gmail.com', 'Trader', 'Diploma', 'Alice Nalubega', 'Mother', 61, '+256784904573', 'alice.32@yahoo.com', 'Doctor', 'Bachelor’s Degree', '88 Church Road, Jinja, Jinja', 'Active in debate club'),
(24, 24, 'Andrew Opio', 40, '+256707873690', 'andrew.opio90@gmail.com', 'Shopkeeper', 'Secondary', 'Joan Kyomuhendo', 31, '+256755884841', 'joan.142@gmail.com', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(25, 25, 'Solomon Byaruhanga', 67, '+256753538578', 'solomon.byaruhanga35@gmail.com', 'Shopkeeper', 'Diploma', 'Pritah Namukasa', 49, '+256777829784', 'pritah.569@gmail.com', 'Farmer', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(26, 26, 'Brian Nakato', 58, '+256785371458', 'brian.nakato82@gmail.com', 'Teacher', 'Secondary', 'Winnie Akello', 37, '+256789399209', 'winnie.10@gmail.com', 'Farmer', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(27, 27, 'Andrew Nakato', 64, '+256705186386', 'andrew.nakato4@gmail.com', 'Farmer', 'Primary', 'Brenda Kyomuhendo', 50, '+256772794687', 'brenda.842@gmail.com', 'Trader', 'Master’s Degree', 'Patrick Nakato', 'Grandparent', 50, '+256702584185', 'patrick.63@yahoo.com', 'Doctor', 'Master’s Degree', '73 Hospital View, Fort Portal, Fort Portal', 'Football team'),
(28, 28, 'Solomon Ochieng', 31, '+256709707646', 'solomon.ochieng58@gmail.com', 'Engineer', 'Master’s Degree', 'Brenda Tumusiime', 58, '+256706080804', 'brenda.904@gmail.com', 'Tailor', 'Bachelor’s Degree', 'Lillian Ochieng', 'Other', 63, '+256705698377', 'lillian.69@yahoo.com', 'Shopkeeper', 'Master’s Degree', '240 Market Lane, Kampala, Kampala', 'Active in debate club'),
(29, 29, 'David Busingye', 54, '+256703559044', 'david.busingye48@gmail.com', 'Driver', 'Master’s Degree', 'Doreen Byaruhanga', 37, '+256706912319', 'doreen.842@gmail.com', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(30, 30, 'Andrew Mukasa', 66, '+256781929165', 'andrew.mukasa63@gmail.com', 'Civil Servant', 'Diploma', 'Winnie Byaruhanga', 47, '+256786701103', 'winnie.485@gmail.com', 'Farmer', 'Secondary', 'Florence Mukasa', 'Uncle', 61, '+256785420356', 'florence.76@yahoo.com', 'Farmer', 'Bachelor’s Degree', '442 Main Street, Soroti, Soroti', 'Football team'),
(31, 31, 'Solomon Namukasa', 46, '+256707852752', 'solomon.namukasa73@gmail.com', 'Carpenter', 'Primary', 'Rebecca Lwanga', 31, '+256702766418', 'rebecca.934@gmail.com', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(32, 32, 'Ivan Nalubega', 37, '+256704761547', 'ivan.nalubega87@gmail.com', 'Doctor', 'Bachelor’s Degree', 'Winnie Ochieng', 60, '+256701476627', 'winnie.804@gmail.com', 'Entrepreneur', 'Master’s Degree', 'Florence Nalubega', 'Aunt', 44, '+256758100157', 'florence.77@yahoo.com', 'Farmer', 'Bachelor’s Degree', '378 Market Lane, Masaka, Masaka', 'Choir member'),
(33, 33, 'Solomon Busingye', 44, '+256776980198', 'solomon.busingye86@gmail.com', 'Doctor', 'Primary', 'Ritah Busingye', 58, '+256789136581', 'ritah.108@gmail.com', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(34, 34, 'Peter Namukasa', 42, '+256755808639', 'peter.namukasa57@gmail.com', 'Civil Servant', 'Master’s Degree', 'Joan Akello', 62, '+256758829233', 'joan.310@gmail.com', 'Housewife', 'Primary', 'Rose Namukasa', 'Mother', 70, '+256772805369', 'rose.57@yahoo.com', 'Farmer', 'Diploma', '20 School Road, Masaka, Masaka', 'Prefect'),
(35, 35, 'Daniel Mukasa', 43, '+256755405035', 'daniel.mukasa35@gmail.com', 'Shopkeeper', 'Secondary', 'Sarah Byaruhanga', 49, '+256775178138', 'sarah.595@gmail.com', 'Farmer', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(36, 36, 'Andrew Waiswa', 67, '+256709570676', 'andrew.waiswa75@gmail.com', 'Driver', 'Diploma', 'Winnie Mugabe', 29, '+256757068559', 'winnie.210@gmail.com', 'Trader', 'Diploma', 'Lillian Waiswa', 'Uncle', 31, '+256756774380', 'lillian.66@yahoo.com', 'Doctor', 'Secondary', '420 Church Road, Masaka, Masaka', 'Prefect'),
(37, 37, 'John Kato', 37, '+256709777689', 'john.kato61@gmail.com', 'Teacher', 'Bachelor’s Degree', 'Joan Okello', 55, '+256777055134', 'joan.751@gmail.com', 'Tailor', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(38, 38, 'Timothy Opio', 55, '+256753526720', 'timothy.opio88@gmail.com', 'Driver', 'Diploma', 'Mary Ssemwogerere', 38, '+256759580912', 'mary.827@gmail.com', 'Entrepreneur', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(39, 39, 'Mark Tumusiime', 43, '+256779806950', 'mark.tumusiime64@gmail.com', 'Civil Servant', 'Diploma', 'Joy Aine', 39, '+256755880747', 'joy.588@gmail.com', 'Housewife', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(40, 40, 'Solomon Nalubega', 48, '+256754772867', 'solomon.nalubega54@gmail.com', 'Civil Servant', 'Primary', 'Doreen Byaruhanga', 44, '+256758405758', 'doreen.579@gmail.com', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(41, 41, 'Solomon Lwanga', 30, '+256774892145', 'solomon.lwanga85@gmail.com', 'Driver', 'Secondary', 'Sarah Aine', 51, '+256788869343', 'sarah.453@gmail.com', 'Housewife', 'Secondary', 'Patrick Lwanga', 'Other', 76, '+256759264838', 'patrick.93@yahoo.com', 'Carpenter', 'Secondary', '395 Church Road, Gulu, Gulu', 'Science fair participant'),
(42, 42, 'Timothy Kato', 48, '+256773936660', 'timothy.kato28@gmail.com', 'Driver', 'Primary', 'Alice Waiswa', 41, '+256782067662', 'alice.743@gmail.com', 'Trader', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(43, 43, 'Ivan Opio', 69, '+256775103344', 'ivan.opio26@gmail.com', 'Teacher', 'Diploma', 'Sandra Byaruhanga', 39, '+256777510713', 'sandra.293@gmail.com', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(44, 44, 'Mark Musoke', 30, '+256788268023', 'mark.musoke48@gmail.com', 'Shopkeeper', 'Primary', 'Rebecca Lwanga', 35, '+256773228096', 'rebecca.786@gmail.com', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(45, 45, 'Solomon Musoke', 49, '+256773621614', 'solomon.musoke27@gmail.com', 'Civil Servant', 'Master’s Degree', 'Pritah Tumusiime', 29, '+256789493131', 'pritah.775@gmail.com', 'Entrepreneur', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(46, 46, 'Isaac Ssemwogerere', 50, '+256754479450', 'isaac.ssemwogerere13@gmail.com', 'Farmer', 'Diploma', 'Sandra Akello', 37, '+256751013916', 'sandra.452@gmail.com', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(47, 47, 'Brian Opio', 38, '+256751528369', 'brian.opio47@gmail.com', 'Shopkeeper', 'Diploma', 'Mary Musoke', 35, '+256703785090', 'mary.227@gmail.com', 'Teacher', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(48, 48, 'Andrew Ochieng', 41, '+256785437615', 'andrew.ochieng94@gmail.com', 'Shopkeeper', 'Secondary', 'Joan Musoke', 39, '+256775553254', 'joan.365@gmail.com', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(49, 49, 'Samuel Ssemwogerere', 64, '+256706628458', 'samuel.ssemwogerere34@gmail.com', 'Doctor', 'Master’s Degree', 'Doreen Ssemwogerere', 55, '+256752722193', 'doreen.864@gmail.com', 'Farmer', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(50, 50, 'David Nalubega', 58, '+256789800084', 'david.nalubega32@gmail.com', 'Shopkeeper', 'Bachelor’s Degree', 'Joy Busingye', 53, '+256779224208', 'joy.483@gmail.com', 'Entrepreneur', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(51, 51, 'Solomon Nalubega', 50, '+256705656828', 'solomon.nalubega60@gmail.com', 'Civil Servant', 'Master’s Degree', 'Joan Nantogo', 36, '+256751233930', 'joan.459@gmail.com', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(52, 52, 'Brian Nantogo', 51, '+256702662164', 'brian.nantogo61@gmail.com', 'Carpenter', 'Secondary', 'Esther Waiswa', 53, '+256708456271', 'esther.237@gmail.com', 'Housewife', 'Master’s Degree', 'Robert Nantogo', 'Mother', 67, '+256783683089', 'robert.82@yahoo.com', 'Teacher', 'Primary', '498 Main Street, Kampala, Kampala', 'Prefect'),
(53, 53, 'Solomon Musoke', 57, '+256789999938', 'solomon.musoke52@gmail.com', 'Civil Servant', 'Master’s Degree', 'Brenda Okello', 40, '+256754462457', 'brenda.697@gmail.com', 'Trader', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(54, 54, 'Daniel Ochieng', 48, '+256773099385', 'daniel.ochieng3@gmail.com', 'Farmer', 'Bachelor’s Degree', 'Mercy Okello', 31, '+256788271403', 'mercy.505@gmail.com', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(55, 55, 'Paul Aine', 44, '+256753942084', 'paul.aine46@gmail.com', 'Driver', 'Primary', 'Sandra Mukasa', 58, '+256782756577', 'sandra.284@gmail.com', 'Teacher', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(56, 56, 'Andrew Aine', 35, '+256774782644', 'andrew.aine7@gmail.com', 'Driver', 'Master’s Degree', 'Rebecca Mugabe', 35, '+256707187783', 'rebecca.451@gmail.com', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(57, 57, 'Paul Ssemwogerere', 45, '+256785010231', 'paul.ssemwogerere34@gmail.com', 'Mechanic', 'Secondary', 'Alice Kyomuhendo', 54, '+256779468381', 'alice.105@gmail.com', 'Farmer', 'Master’s Degree', 'Susan Ssemwogerere', 'Uncle', 34, '+256777800872', 'susan.74@yahoo.com', 'Engineer', 'Diploma', '92 Market Lane, Masaka, Masaka', 'Active in debate club'),
(58, 58, 'Brian Byaruhanga', 49, '+256704064355', 'brian.byaruhanga29@gmail.com', 'Shopkeeper', 'Secondary', 'Brenda Lwanga', 41, '+256774903606', 'brenda.135@gmail.com', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(59, 59, 'Joseph Okello', 46, '+256702789982', 'joseph.okello59@gmail.com', 'Doctor', 'Primary', 'Brenda Okello', 34, '+256784544708', 'brenda.70@gmail.com', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(60, 60, 'Moses Waiswa', 52, '+256708176366', 'moses.waiswa58@gmail.com', 'Teacher', 'Diploma', 'Mercy Opio', 42, '+256778106038', 'mercy.549@gmail.com', 'Teacher', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(61, 61, 'John Busingye', 40, '+256775874573', 'john.busingye37@gmail.com', 'Farmer', 'Master’s Degree', 'Sandra Nantogo', 57, '+256703425164', 'sandra.122@gmail.com', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(62, 62, 'Joseph Kyomuhendo', 32, '+256774611663', 'joseph.kyomuhendo64@gmail.com', 'Doctor', 'Secondary', 'Alice Kato', 46, '+256753683056', 'alice.476@gmail.com', 'Nurse', 'Bachelor’s Degree', 'Robert Kyomuhendo', 'Aunt', 67, '+256781220388', 'robert.72@yahoo.com', 'Teacher', 'Master’s Degree', '262 Church Road, Fort Portal, Fort Portal', 'Choir member'),
(63, 63, 'David Kato', 44, '+256778683756', 'david.kato57@gmail.com', 'Teacher', 'Secondary', 'Winnie Kato', 51, '+256703743888', 'winnie.708@gmail.com', 'Nurse', 'Secondary', 'Florence Kato', 'Mother', 46, '+256706218279', 'florence.0@yahoo.com', 'Farmer', 'Diploma', '372 Church Road, Mbarara, Mbarara', 'Active in debate club'),
(64, 64, 'Isaac Waiswa', 46, '+256784154865', 'isaac.waiswa29@gmail.com', 'Doctor', 'Master’s Degree', 'Mercy Aine', 61, '+256708043101', 'mercy.850@gmail.com', 'Entrepreneur', 'Secondary', 'Susan Waiswa', 'Grandparent', 66, '+256705934935', 'susan.67@yahoo.com', 'Driver', 'Primary', '141 Central Avenue, Soroti, Soroti', 'Choir member'),
(65, 65, 'Solomon Waiswa', 40, '+256771362473', 'solomon.waiswa7@gmail.com', 'Teacher', 'Bachelor’s Degree', 'Joy Byaruhanga', 64, '+256775949252', 'joy.526@gmail.com', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(66, 66, 'Isaac Musoke', 35, '+256785517798', 'isaac.musoke92@gmail.com', 'Mechanic', 'Secondary', 'Joy Nantogo', 37, '+256705565474', 'joy.756@gmail.com', 'Nurse', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(67, 67, 'Solomon Okello', 40, '+256772633895', 'solomon.okello75@gmail.com', 'Teacher', 'Diploma', 'Ritah Akello', 34, '+256772755764', 'ritah.551@gmail.com', 'Farmer', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(68, 68, 'Peter Nalubega', 46, '+256775837803', 'peter.nalubega40@gmail.com', 'Mechanic', 'Primary', 'Pritah Byaruhanga', 29, '+256755366385', 'pritah.500@gmail.com', 'Civil Servant', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(69, 69, 'Peter Nakato', 56, '+256754029878', 'peter.nakato72@gmail.com', 'Farmer', 'Bachelor’s Degree', 'Pritah Okello', 56, '+256789539213', 'pritah.121@gmail.com', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(70, 70, 'Paul Nakato', 42, '+256708141023', 'paul.nakato73@gmail.com', 'Doctor', 'Bachelor’s Degree', 'Mercy Mukasa', 58, '+256709300546', 'mercy.316@gmail.com', 'Farmer', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(71, 71, 'Samuel Namukasa', 37, '+256777720218', 'samuel.namukasa48@gmail.com', 'Driver', 'Master’s Degree', 'Rebecca Musoke', 29, '+256773521270', 'rebecca.374@gmail.com', 'Nurse', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(72, 72, 'Moses Nantogo', 66, '+256708252356', 'moses.nantogo26@gmail.com', 'Carpenter', 'Primary', 'Ritah Musoke', 41, '+256757602944', 'ritah.514@gmail.com', 'Teacher', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(73, 73, 'Andrew Okello', 35, '+256702909163', 'andrew.okello94@gmail.com', 'Carpenter', 'Bachelor’s Degree', 'Alice Okello', 60, '+256777196919', 'alice.788@gmail.com', 'Nurse', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(74, 74, 'Samuel Mukasa', 55, '+256703183144', 'samuel.mukasa7@gmail.com', 'Mechanic', 'Master’s Degree', 'Joan Opio', 51, '+256758144463', 'joan.800@gmail.com', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(75, 75, 'Timothy Namukasa', 41, '+256788292415', 'timothy.namukasa53@gmail.com', 'Carpenter', 'Secondary', 'Brenda Aine', 36, '+256758620126', 'brenda.554@gmail.com', 'Trader', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(76, 76, 'John Waiswa', 40, '+256771210967', 'john.waiswa6@gmail.com', 'Farmer', 'Primary', 'Ritah Aine', 40, '+256757335286', 'ritah.286@gmail.com', 'Housewife', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(77, 77, 'Paul Mukasa', 41, '+256704957515', 'paul.mukasa11@gmail.com', 'Teacher', 'Secondary', 'Doreen Lwanga', 49, '+256705369265', 'doreen.205@gmail.com', 'Farmer', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(78, 78, 'Paul Nalubega', 65, '+256785153315', 'paul.nalubega5@gmail.com', 'Doctor', 'Master’s Degree', 'Pritah Kato', 60, '+256776686664', 'pritah.756@gmail.com', 'Farmer', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(79, 79, 'Paul Aine', 66, '+256778464645', 'paul.aine7@gmail.com', 'Doctor', 'Master’s Degree', 'Sarah Akello', 36, '+256707465335', 'sarah.277@gmail.com', 'Teacher', 'Primary', 'James Aine', 'Aunt', 74, '+256705447012', 'james.41@yahoo.com', 'Shopkeeper', 'Secondary', '262 Central Avenue, Kampala, Kampala', 'Science fair participant'),
(80, 80, 'Solomon Nakato', 69, '+256786454601', 'solomon.nakato75@gmail.com', 'Shopkeeper', 'Primary', 'Brenda Byaruhanga', 57, '+256789995520', 'brenda.159@gmail.com', 'Trader', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(81, 81, 'Daniel Ssemwogerere', 64, '+256703123258', 'daniel.ssemwogerere90@gmail.com', 'Driver', 'Primary', 'Mercy Akello', 44, '+256782969107', 'mercy.219@gmail.com', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(82, 82, 'Joseph Mugabe', 68, '+256788604262', 'joseph.mugabe29@gmail.com', 'Mechanic', 'Bachelor’s Degree', 'Sandra Aine', 42, '+256782682871', 'sandra.388@gmail.com', 'Civil Servant', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(83, 83, 'Daniel Nakato', 38, '+256754297713', 'daniel.nakato85@gmail.com', 'Driver', 'Bachelor’s Degree', 'Grace Busingye', 59, '+256772565144', 'grace.673@gmail.com', 'Farmer', 'Diploma', 'Hellen Nakato', 'Father', 29, '+256775876402', 'hellen.54@yahoo.com', 'Mechanic', 'Bachelor’s Degree', '153 Market Lane, Gulu, Gulu', 'Choir member'),
(84, 84, 'Samuel Ssemwogerere', 62, '+256789846480', 'samuel.ssemwogerere14@gmail.com', 'Shopkeeper', 'Diploma', 'Rebecca Nalubega', 59, '+256785590494', 'rebecca.276@gmail.com', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(85, 85, 'Mark Tumusiime', 41, '+256759463936', 'mark.tumusiime61@gmail.com', 'Driver', 'Master’s Degree', 'Sandra Okello', 38, '+256774610602', 'sandra.497@gmail.com', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(86, 86, 'David Byaruhanga', 30, '+256783941118', 'david.byaruhanga79@gmail.com', 'Civil Servant', 'Secondary', 'Alice Akello', 34, '+256776992050', 'alice.632@gmail.com', 'Entrepreneur', 'Primary', 'Hellen Byaruhanga', 'Other', 47, '+256758482643', 'hellen.8@yahoo.com', 'Doctor', 'Master’s Degree', '52 School Road, Arua, Arua', 'Active in debate club'),
(87, 87, 'Solomon Nantogo', 34, '+256703921855', 'solomon.nantogo81@gmail.com', 'Farmer', 'Diploma', 'Mercy Byaruhanga', 53, '+256754222355', 'mercy.949@gmail.com', 'Trader', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(88, 88, 'David Musoke', 69, '+256785677080', 'david.musoke30@gmail.com', 'Mechanic', 'Master’s Degree', 'Winnie Nakato', 50, '+256703484704', 'winnie.286@gmail.com', 'Farmer', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(89, 89, 'Paul Ssemwogerere', 56, '+256772352033', 'paul.ssemwogerere41@gmail.com', 'Teacher', 'Secondary', 'Sandra Ochieng', 48, '+256784329850', 'sandra.931@gmail.com', 'Entrepreneur', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(90, 90, 'Joseph Nalubega', 44, '+256776099540', 'joseph.nalubega40@gmail.com', 'Shopkeeper', 'Master’s Degree', 'Rebecca Namukasa', 34, '+256751107381', 'rebecca.841@gmail.com', 'Teacher', 'Secondary', 'Patrick Nalubega', 'Grandparent', 35, '+256752865558', 'patrick.28@yahoo.com', 'Driver', 'Master’s Degree', '422 Central Avenue, Mbale, Mbale', 'Choir member'),
(91, 91, 'David Aine', 34, '+256786724175', 'david.aine19@gmail.com', 'Mechanic', 'Secondary', 'Pritah Waiswa', 50, '+256751755998', 'pritah.769@gmail.com', 'Civil Servant', 'Bachelor’s Degree', 'Patrick Aine', 'Uncle', 51, '+256779758797', 'patrick.45@yahoo.com', 'Doctor', 'Master’s Degree', '325 Market Lane, Arua, Arua', 'Football team'),
(92, 92, 'Samuel Mukasa', 34, '+256702867892', 'samuel.mukasa93@gmail.com', 'Civil Servant', 'Primary', 'Sandra Musoke', 53, '+256784442915', 'sandra.367@gmail.com', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(93, 93, 'Isaac Aine', 57, '+256753763415', 'isaac.aine71@gmail.com', 'Doctor', 'Secondary', 'Mary Mukasa', 39, '+256702455631', 'mary.956@gmail.com', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(94, 94, 'Peter Lwanga', 45, '+256773334515', 'peter.lwanga23@gmail.com', 'Doctor', 'Primary', 'Rebecca Kyomuhendo', 64, '+256754531400', 'rebecca.834@gmail.com', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(95, 95, 'Paul Lwanga', 65, '+256786634187', 'paul.lwanga74@gmail.com', 'Farmer', 'Secondary', 'Alice Namukasa', 59, '+256755120767', 'alice.441@gmail.com', 'Housewife', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(96, 96, 'Paul Lwanga', 62, '+256709800258', 'paul.lwanga54@gmail.com', 'Engineer', 'Diploma', 'Joy Opio', 33, '+256751447496', 'joy.457@gmail.com', 'Teacher', 'Secondary', 'Alice Lwanga', 'Aunt', 57, '+256753546165', 'alice.89@yahoo.com', 'Mechanic', 'Primary', '38 Central Avenue, Mbale, Mbale', 'Prefect'),
(97, 97, 'Timothy Tumusiime', 65, '+256779827611', 'timothy.tumusiime75@gmail.com', 'Farmer', 'Master’s Degree', 'Joan Kyomuhendo', 47, '+256702304894', 'joan.391@gmail.com', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(98, 98, 'Isaac Musoke', 66, '+256777075516', 'isaac.musoke18@gmail.com', 'Mechanic', 'Primary', 'Alice Waiswa', 35, '+256758532327', 'alice.141@gmail.com', 'Trader', 'Primary', 'Rose Musoke', 'Aunt', 71, '+256708271344', 'rose.58@yahoo.com', 'Shopkeeper', 'Bachelor’s Degree', '72 Main Street, Jinja, Jinja', 'Prefect'),
(99, 99, 'Brian Aine', 51, '+256753434784', 'brian.aine46@gmail.com', 'Doctor', 'Master’s Degree', 'Esther Okello', 32, '+256752139331', 'esther.499@gmail.com', 'Nurse', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(100, 100, 'Andrew Waiswa', 51, '+256751641594', 'andrew.waiswa14@gmail.com', 'Doctor', 'Bachelor’s Degree', 'Mercy Tumusiime', 47, '+256774927604', 'mercy.963@gmail.com', 'Civil Servant', 'Master’s Degree', 'Susan Waiswa', 'Uncle', 60, '+256787100846', 'susan.89@yahoo.com', 'Carpenter', 'Primary', '376 Hospital View, Soroti, Soroti', 'Football team'),
(101, 101, 'Ivan Kato', 49, '+256756824704', 'ivan.kato28@gmail.com', 'Shopkeeper', 'Bachelor’s Degree', 'Joy Nalubega', 60, '+256707554354', 'joy.410@gmail.com', 'Nurse', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(102, 102, 'Ivan Opio', 40, '+256708007457', 'ivan.opio51@gmail.com', 'Civil Servant', 'Master’s Degree', 'Joan Musoke', 56, '+256778207020', 'joan.635@gmail.com', 'Entrepreneur', 'Bachelor’s Degree', 'Susan Opio', 'Grandparent', 69, '+256778439020', 'susan.5@yahoo.com', 'Civil Servant', 'Primary', '348 Main Street, Jinja, Jinja', 'Active in debate club'),
(103, 103, 'Andrew Aine', 62, '+256706298070', 'andrew.aine51@gmail.com', 'Driver', 'Primary', 'Esther Okello', 64, '+256751109978', 'esther.2@gmail.com', 'Housewife', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(104, 104, 'David Nantogo', 53, '+256753610736', 'david.nantogo28@gmail.com', 'Teacher', 'Secondary', 'Doreen Mugabe', 38, '+256752534245', 'doreen.956@gmail.com', 'Trader', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(105, 105, 'David Akello', 41, '+256703915595', 'david.akello64@gmail.com', 'Engineer', 'Secondary', 'Sandra Nalubega', 54, '+256754477954', 'sandra.374@gmail.com', 'Tailor', 'Primary', 'Rose Akello', 'Uncle', 79, '+256702263374', 'rose.76@yahoo.com', 'Shopkeeper', 'Master’s Degree', '40 Main Street, Kampala, Kampala', 'Active in debate club'),
(106, 106, 'Peter Aine', 37, '+256772265035', 'peter.aine12@gmail.com', 'Shopkeeper', 'Secondary', 'Brenda Lwanga', 52, '+256782154744', 'brenda.808@gmail.com', 'Entrepreneur', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(107, 107, 'Isaac Namukasa', 55, '+256757425623', 'isaac.namukasa55@gmail.com', 'Shopkeeper', 'Master’s Degree', 'Mercy Ochieng', 46, '+256709326271', 'mercy.252@gmail.com', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(108, 108, 'Mark Kato', 61, '+256776828877', 'mark.kato53@gmail.com', 'Doctor', 'Master’s Degree', 'Sarah Nantogo', 47, '+256752282284', 'sarah.988@gmail.com', 'Civil Servant', 'Bachelor’s Degree', 'James Kato', 'Other', 66, '+256758588787', 'james.46@yahoo.com', 'Doctor', 'Secondary', '489 Church Road, Jinja, Jinja', 'Active in debate club'),
(109, 109, 'Ivan Ochieng', 55, '+256772560529', 'ivan.ochieng42@gmail.com', 'Mechanic', 'Bachelor’s Degree', 'Doreen Lwanga', 34, '+256703224045', 'doreen.182@gmail.com', 'Teacher', 'Primary', 'Alice Ochieng', 'Mother', 35, '+256703874691', 'alice.62@yahoo.com', 'Doctor', 'Master’s Degree', '295 School Road, Soroti, Soroti', 'Football team'),
(110, 110, 'Andrew Ochieng', 41, '+256703932198', 'andrew.ochieng44@gmail.com', 'Teacher', 'Secondary', 'Doreen Musoke', 32, '+256709317220', 'doreen.579@gmail.com', 'Entrepreneur', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(111, 111, 'Peter Akello', 62, '+256772675619', 'peter.akello26@gmail.com', 'Farmer', 'Diploma', 'Sarah Tumusiime', 59, '+256756488383', 'sarah.536@gmail.com', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(112, 112, 'Joseph Mukasa', 62, '+256701089556', 'joseph.mukasa76@gmail.com', 'Civil Servant', 'Secondary', 'Joy Musoke', 61, '+256752508907', 'joy.83@gmail.com', 'Teacher', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(113, 113, 'Samuel Nalubega', 65, '+256782376113', 'samuel.nalubega85@gmail.com', 'Carpenter', 'Secondary', 'Grace Kato', 58, '+256704757251', 'grace.615@gmail.com', 'Teacher', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(114, 114, 'Peter Nalubega', 49, '+256705796074', 'peter.nalubega21@gmail.com', 'Civil Servant', 'Secondary', 'Mary Lwanga', 34, '+256707594543', 'mary.275@gmail.com', 'Nurse', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(115, 115, 'David Akello', 46, '+256772673975', 'david.akello58@gmail.com', 'Doctor', 'Master’s Degree', 'Grace Tumusiime', 47, '+256707782913', 'grace.756@gmail.com', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(116, 116, 'Paul Kyomuhendo', 53, '+256771725267', 'paul.kyomuhendo16@gmail.com', 'Engineer', 'Secondary', 'Mary Nantogo', 53, '+256755634379', 'mary.644@gmail.com', 'Tailor', 'Secondary', 'Florence Kyomuhendo', 'Mother', 48, '+256789916236', 'florence.64@yahoo.com', 'Doctor', 'Secondary', '352 Market Lane, Masaka, Masaka', 'Choir member'),
(117, 117, 'Moses Musoke', 37, '+256706125540', 'moses.musoke57@gmail.com', 'Farmer', 'Secondary', 'Brenda Opio', 53, '+256757375182', 'brenda.960@gmail.com', 'Trader', 'Diploma', 'Florence Musoke', 'Aunt', 64, '+256758449187', 'florence.41@yahoo.com', 'Carpenter', 'Master’s Degree', '75 School Road, Soroti, Soroti', 'Science fair participant'),
(118, 118, 'Timothy Namukasa', 47, '+256773451962', 'timothy.namukasa5@gmail.com', 'Teacher', 'Primary', 'Mary Kato', 31, '+256785784902', 'mary.936@gmail.com', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(119, 119, 'Joseph Okello', 59, '+256703520258', 'joseph.okello50@gmail.com', 'Farmer', 'Diploma', 'Alice Waiswa', 59, '+256781446026', 'alice.399@gmail.com', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(120, 120, 'Moses Akello', 64, '+256708359277', 'moses.akello25@gmail.com', 'Driver', 'Master’s Degree', 'Pritah Lwanga', 54, '+256783568920', 'pritah.114@gmail.com', 'Farmer', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(121, 121, 'Moses Kato', 51, '+256752069488', 'moses.kato96@gmail.com', 'Civil Servant', 'Primary', 'Ritah Ochieng', 40, '+256754113714', 'ritah.77@gmail.com', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(122, 122, 'Peter Opio', 60, '+256706544440', 'peter.opio12@gmail.com', 'Driver', 'Primary', 'Alice Byaruhanga', 55, '+256774392681', 'alice.174@gmail.com', 'Farmer', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(123, 123, 'Paul Ochieng', 35, '+256701597009', 'paul.ochieng46@gmail.com', 'Doctor', 'Master’s Degree', 'Mercy Nantogo', 39, '+256788780992', 'mercy.580@gmail.com', 'Housewife', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(124, 124, 'David Mukasa', 45, '+256706399694', 'david.mukasa82@gmail.com', 'Engineer', 'Bachelor’s Degree', 'Rebecca Nalubega', 30, '+256781417535', 'rebecca.639@gmail.com', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(125, 125, 'Isaac Nantogo', 61, '+256777959579', 'isaac.nantogo61@gmail.com', 'Teacher', 'Bachelor’s Degree', 'Rebecca Aine', 52, '+256787470426', 'rebecca.763@gmail.com', 'Nurse', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(126, 126, 'David Byaruhanga', 65, '+256773239105', 'david.byaruhanga91@gmail.com', 'Civil Servant', 'Master’s Degree', 'Winnie Musoke', 59, '+256754084279', 'winnie.774@gmail.com', 'Entrepreneur', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(127, 127, 'Ivan Mugabe', 41, '+256751928063', 'ivan.mugabe31@gmail.com', 'Driver', 'Diploma', 'Alice Ssemwogerere', 61, '+256701968273', 'alice.47@gmail.com', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(128, 128, 'Daniel Akello', 49, '+256785302246', 'daniel.akello77@gmail.com', 'Farmer', 'Primary', 'Grace Aine', 33, '+256754320473', 'grace.850@gmail.com', 'Farmer', 'Diploma', 'Charles Akello', 'Mother', 42, '+256775450203', 'charles.93@yahoo.com', 'Carpenter', 'Diploma', '128 Hospital View, Masaka, Masaka', 'Football team'),
(129, 129, 'Ivan Nantogo', 44, '+256772442270', 'ivan.nantogo36@gmail.com', 'Civil Servant', 'Diploma', 'Joy Waiswa', 30, '+256708935352', 'joy.943@gmail.com', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(130, 130, 'John Waiswa', 57, '+256788545519', 'john.waiswa23@gmail.com', 'Civil Servant', 'Diploma', 'Rebecca Mukasa', 39, '+256775356795', 'rebecca.954@gmail.com', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(131, 131, 'Brian Tumusiime', 40, '+256782819021', 'brian.tumusiime56@gmail.com', 'Shopkeeper', 'Secondary', 'Alice Okello', 30, '+256774924716', 'alice.676@gmail.com', 'Teacher', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(132, 132, 'Joseph Nantogo', 53, '+256706591564', 'joseph.nantogo9@gmail.com', 'Civil Servant', 'Master’s Degree', 'Alice Nakato', 46, '+256758145681', 'alice.975@gmail.com', 'Trader', 'Secondary', 'Robert Nantogo', 'Mother', 27, '+256703512478', 'robert.1@yahoo.com', 'Shopkeeper', 'Bachelor’s Degree', '434 Main Street, Mbarara, Mbarara', 'Science fair participant'),
(133, 133, 'Timothy Namukasa', 33, '+256752424107', 'timothy.namukasa70@gmail.com', 'Doctor', 'Primary', 'Ritah Opio', 41, '+256704827680', 'ritah.727@gmail.com', 'Civil Servant', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(134, 134, 'Daniel Nakato', 35, '+256782678220', 'daniel.nakato93@gmail.com', 'Carpenter', 'Master’s Degree', 'Pritah Opio', 32, '+256779888856', 'pritah.414@gmail.com', 'Teacher', 'Secondary', 'James Nakato', 'Other', 57, '+256787473779', 'james.60@yahoo.com', 'Doctor', 'Bachelor’s Degree', '354 Hospital View, Jinja, Jinja', 'Active in debate club'),
(135, 135, 'Paul Mukasa', 59, '+256778262924', 'paul.mukasa42@gmail.com', 'Engineer', 'Bachelor’s Degree', 'Mary Akello', 28, '+256782321733', 'mary.892@gmail.com', 'Tailor', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(136, 136, 'Brian Ochieng', 64, '+256781393306', 'brian.ochieng78@gmail.com', 'Mechanic', 'Master’s Degree', 'Doreen Kato', 57, '+256784283796', 'doreen.178@gmail.com', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(137, 137, 'Daniel Okello', 43, '+256787113596', 'daniel.okello66@gmail.com', 'Shopkeeper', 'Primary', 'Mercy Nakato', 39, '+256701879160', 'mercy.519@gmail.com', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(138, 138, 'Brian Mukasa', 30, '+256774071290', 'brian.mukasa60@gmail.com', 'Farmer', 'Primary', 'Mercy Kato', 47, '+256776486037', 'mercy.670@gmail.com', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(139, 139, 'Joseph Nantogo', 40, '+256773674168', 'joseph.nantogo23@gmail.com', 'Shopkeeper', 'Diploma', 'Joan Opio', 49, '+256787280876', 'joan.733@gmail.com', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(140, 140, 'Andrew Nantogo', 62, '+256708661889', 'andrew.nantogo26@gmail.com', 'Farmer', 'Diploma', 'Joy Lwanga', 63, '+256786464944', 'joy.553@gmail.com', 'Nurse', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(141, 141, 'Solomon Opio', 52, '+256703724427', 'solomon.opio9@gmail.com', 'Driver', 'Bachelor’s Degree', 'Sandra Mukasa', 57, '+256781159389', 'sandra.569@gmail.com', 'Teacher', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(142, 142, 'Mark Ssemwogerere', 36, '+256754680318', 'mark.ssemwogerere27@gmail.com', 'Mechanic', 'Secondary', 'Joy Aine', 41, '+256758775560', 'joy.590@gmail.com', 'Nurse', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(143, 143, 'John Waiswa', 62, '+256787792660', 'john.waiswa80@gmail.com', 'Shopkeeper', 'Bachelor’s Degree', 'Mercy Okello', 38, '+256752651704', 'mercy.763@gmail.com', 'Nurse', 'Diploma', 'Rose Waiswa', 'Uncle', 27, '+256707202941', 'rose.10@yahoo.com', 'Carpenter', 'Primary', '442 Main Street, Gulu, Gulu', 'Choir member'),
(144, 144, 'Daniel Busingye', 69, '+256758059021', 'daniel.busingye26@gmail.com', 'Farmer', 'Master’s Degree', 'Ritah Mugabe', 45, '+256787294620', 'ritah.715@gmail.com', 'Teacher', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(145, 145, 'Isaac Ssemwogerere', 65, '+256783721834', 'isaac.ssemwogerere55@gmail.com', 'Carpenter', 'Secondary', 'Sarah Aine', 43, '+256773161834', 'sarah.28@gmail.com', 'Nurse', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(146, 146, 'Joseph Nalubega', 67, '+256755834217', 'joseph.nalubega50@gmail.com', 'Farmer', 'Primary', 'Ritah Byaruhanga', 39, '+256784614376', 'ritah.500@gmail.com', 'Nurse', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(147, 147, 'Moses Byaruhanga', 59, '+256703389691', 'moses.byaruhanga30@gmail.com', 'Civil Servant', 'Bachelor’s Degree', 'Brenda Aine', 46, '+256758825661', 'brenda.621@gmail.com', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(148, 148, 'Samuel Lwanga', 52, '+256753115535', 'samuel.lwanga45@gmail.com', 'Driver', 'Bachelor’s Degree', 'Sandra Tumusiime', 44, '+256703454796', 'sandra.52@gmail.com', 'Nurse', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(149, 149, 'David Busingye', 48, '+256759230848', 'david.busingye63@gmail.com', 'Engineer', 'Bachelor’s Degree', 'Alice Nalubega', 28, '+256755640697', 'alice.908@gmail.com', 'Teacher', 'Secondary', 'Lillian Busingye', 'Uncle', 66, '+256789106537', 'lillian.23@yahoo.com', 'Doctor', 'Primary', '453 Hospital View, Fort Portal, Fort Portal', 'Football team'),
(150, 150, 'Mark Mukasa', 30, '+256772116444', 'mark.mukasa27@gmail.com', 'Farmer', 'Master’s Degree', 'Mary Musoke', 43, '+256703366072', 'mary.39@gmail.com', 'Entrepreneur', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(151, 151, 'Andrew Mukasa', 50, '+256773744822', 'andrew.mukasa47@gmail.com', 'Teacher', 'Master’s Degree', 'Sarah Byaruhanga', 49, '+256707579407', 'sarah.754@gmail.com', 'Civil Servant', 'Diploma', '', '', NULL, '', '', NULL, NULL, '', 'Choir member'),
(152, 152, 'Andrew Akello', 43, '+256774483293', 'andrew.akello29@gmail.com', 'Civil Servant', 'Master’s Degree', 'Alice Opio', 61, '+256755031731', 'alice.248@gmail.com', 'Housewife', 'Primary', 'Lillian Akello', 'Aunt', 59, '+256784180745', 'lillian.31@yahoo.com', 'Shopkeeper', 'Master’s Degree', '464 Church Road, Kampala, Kampala', 'Prefect'),
(153, 153, 'Joseph Musoke', 61, '+256784500469', 'joseph.musoke19@gmail.com', 'Engineer', 'Bachelor’s Degree', 'Sarah Opio', 37, '+256758525741', 'sarah.950@gmail.com', 'Tailor', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(154, 154, 'Peter Kato', 53, '+256773540105', 'peter.kato68@gmail.com', 'Mechanic', 'Bachelor’s Degree', 'Alice Byaruhanga', 42, '+256774191443', 'alice.89@gmail.com', 'Civil Servant', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(155, 155, 'Samuel Opio', 39, '+256776830776', 'samuel.opio3@gmail.com', 'Teacher', 'Bachelor’s Degree', 'Joy Mukasa', 58, '+256755097738', 'joy.39@gmail.com', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(156, 156, 'Samuel Aine', 39, '+256702445721', 'samuel.aine73@gmail.com', 'Mechanic', 'Secondary', 'Grace Okello', 62, '+256779465313', 'grace.549@gmail.com', 'Nurse', 'Secondary', 'Florence Aine', 'Father', 47, '+256703049956', 'florence.35@yahoo.com', 'Carpenter', 'Bachelor’s Degree', '241 Market Lane, Masaka, Masaka', 'Active in debate club'),
(157, 157, 'Brian Busingye', 39, '+256754672158', 'brian.busingye9@gmail.com', 'Mechanic', 'Master’s Degree', 'Alice Nalubega', 42, '+256751170051', 'alice.90@gmail.com', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(158, 158, 'Samuel Nalubega', 60, '+256709923170', 'samuel.nalubega94@gmail.com', 'Teacher', 'Bachelor’s Degree', 'Alice Tumusiime', 42, '+256772925259', 'alice.408@gmail.com', 'Housewife', 'Bachelor’s Degree', 'Charles Nalubega', 'Mother', 60, '+256776048911', 'charles.76@yahoo.com', 'Shopkeeper', 'Secondary', '316 Market Lane, Gulu, Gulu', 'Choir member'),
(159, 159, 'Joseph Nantogo', 53, '+256772346359', 'joseph.nantogo0@gmail.com', 'Mechanic', 'Master’s Degree', 'Sandra Tumusiime', 39, '+256704735821', 'sandra.309@gmail.com', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(160, 160, 'John Nantogo', 33, '+256788726693', 'john.nantogo92@gmail.com', 'Shopkeeper', 'Master’s Degree', 'Esther Namukasa', 63, '+256776663293', 'esther.970@gmail.com', 'Entrepreneur', 'Bachelor’s Degree', 'Charles Nantogo', 'Aunt', 50, '+256705621332', 'charles.41@yahoo.com', 'Civil Servant', 'Primary', '391 School Road, Masaka, Masaka', 'Science fair participant'),
(161, 161, 'Peter Mugabe', 32, '+256757417036', 'peter.mugabe43@gmail.com', 'Mechanic', 'Master’s Degree', 'Mary Aine', 61, '+256709600568', 'mary.554@gmail.com', 'Entrepreneur', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(162, 162, 'John Ochieng', 41, '+256752776335', 'john.ochieng96@gmail.com', 'Driver', 'Master’s Degree', 'Doreen Byaruhanga', 31, '+256757846524', 'doreen.277@gmail.com', 'Civil Servant', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(163, 163, 'Isaac Nantogo', 53, '+256707602039', 'isaac.nantogo74@gmail.com', 'Shopkeeper', 'Diploma', 'Joy Nakato', 51, '+256708599921', 'joy.831@gmail.com', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(164, 164, 'Paul Lwanga', 46, '+256758187032', 'paul.lwanga16@gmail.com', 'Shopkeeper', 'Master’s Degree', 'Joan Nalubega', 45, '+256786399401', 'joan.53@gmail.com', 'Farmer', 'Diploma', 'Florence Lwanga', 'Uncle', 50, '+256781494077', 'florence.32@yahoo.com', 'Carpenter', 'Master’s Degree', '263 Main Street, Mbarara, Mbarara', 'Prefect'),
(165, 165, 'Peter Kyomuhendo', 42, '+256785630344', 'peter.kyomuhendo96@gmail.com', 'Shopkeeper', 'Secondary', 'Doreen Lwanga', 41, '+256752022129', 'doreen.939@gmail.com', 'Entrepreneur', 'Master’s Degree', 'Rose Kyomuhendo', 'Uncle', 75, '+256705323505', 'rose.18@yahoo.com', 'Farmer', 'Master’s Degree', '468 Hospital View, Mbale, Mbale', 'Science fair participant'),
(166, 166, 'Joseph Nakato', 54, '+256705759820', 'joseph.nakato63@gmail.com', 'Teacher', 'Bachelor’s Degree', 'Mary Musoke', 38, '+256772777298', 'mary.375@gmail.com', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(167, 167, 'Isaac Tumusiime', 50, '+256785513867', 'isaac.tumusiime0@gmail.com', 'Driver', 'Primary', 'Joy Ssemwogerere', 43, '+256776021385', 'joy.218@gmail.com', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(168, 168, 'Moses Aine', 50, '+256757187294', 'moses.aine50@gmail.com', 'Mechanic', 'Secondary', 'Doreen Ochieng', 29, '+256709616915', 'doreen.979@gmail.com', 'Farmer', 'Master’s Degree', 'Robert Aine', 'Uncle', 53, '+256786899657', 'robert.46@yahoo.com', 'Driver', 'Bachelor’s Degree', '119 School Road, Mbarara, Mbarara', 'Active in debate club'),
(169, 169, 'Timothy Tumusiime', 63, '+256776108039', 'timothy.tumusiime30@gmail.com', 'Doctor', 'Bachelor’s Degree', 'Winnie Lwanga', 61, '+256785113233', 'winnie.852@gmail.com', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(170, 170, 'John Busingye', 50, '+256754316268', 'john.busingye71@gmail.com', 'Engineer', 'Bachelor’s Degree', 'Doreen Busingye', 60, '+256709621844', 'doreen.549@gmail.com', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(171, 171, 'Mark Nakato', 62, '+256703085995', 'mark.nakato9@gmail.com', 'Civil Servant', 'Secondary', 'Brenda Busingye', 31, '+256772303420', 'brenda.507@gmail.com', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(172, 172, 'Joseph Lwanga', 50, '+256704128648', 'joseph.lwanga30@gmail.com', 'Shopkeeper', 'Secondary', 'Joy Waiswa', 64, '+256757475199', 'joy.629@gmail.com', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(173, 173, 'Daniel Byaruhanga', 46, '+256709560579', 'daniel.byaruhanga64@gmail.com', 'Farmer', 'Secondary', 'Pritah Lwanga', 61, '+256784222207', 'pritah.395@gmail.com', 'Teacher', 'Primary', 'Patrick Byaruhanga', 'Uncle', 52, '+256774617287', 'patrick.92@yahoo.com', 'Teacher', 'Primary', '123 Church Road, Lira, Lira', 'Science fair participant'),
(174, 174, 'Brian Tumusiime', 64, '+256754586943', 'brian.tumusiime1@gmail.com', 'Doctor', 'Master’s Degree', 'Alice Akello', 48, '+256751598950', 'alice.750@gmail.com', 'Trader', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(175, 175, 'Joseph Lwanga', 57, '+256789384844', 'joseph.lwanga69@gmail.com', 'Engineer', 'Bachelor’s Degree', 'Mercy Mukasa', 32, '+256705127591', 'mercy.301@gmail.com', 'Housewife', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect');
INSERT INTO `parents` (`ParentId`, `AdmissionNo`, `father_name`, `father_age`, `father_contact`, `father_email`, `father_occupation`, `father_education`, `mother_name`, `mother_age`, `mother_contact`, `mother_email`, `mother_occupation`, `mother_education`, `guardian_name`, `guardian_relation`, `guardian_age`, `guardian_contact`, `guardian_email`, `guardian_occupation`, `guardian_education`, `guardian_address`, `MoreInformation`) VALUES
(176, 176, 'Ivan Ssemwogerere', 37, '+256759898957', 'ivan.ssemwogerere42@gmail.com', 'Shopkeeper', 'Diploma', 'Alice Nalubega', 41, '+256754907616', 'alice.932@gmail.com', 'Nurse', 'Primary', 'Alice Ssemwogerere', 'Uncle', 32, '+256702148559', 'alice.76@yahoo.com', 'Farmer', 'Bachelor’s Degree', '362 Central Avenue, Fort Portal, Fort Portal', 'Football team'),
(177, 177, 'Brian Opio', 33, '+256756604157', 'brian.opio58@gmail.com', 'Shopkeeper', 'Master’s Degree', 'Doreen Nakato', 38, '+256782226136', 'doreen.935@gmail.com', 'Trader', 'Master’s Degree', 'Lillian Opio', 'Aunt', 32, '+256707288028', 'lillian.52@yahoo.com', 'Teacher', 'Master’s Degree', '498 Market Lane, Jinja, Jinja', 'Prefect'),
(178, 178, 'Daniel Nakato', 60, '+256776975411', 'daniel.nakato94@gmail.com', 'Mechanic', 'Bachelor’s Degree', 'Esther Ssemwogerere', 51, '+256781855607', 'esther.784@gmail.com', 'Housewife', 'Secondary', 'Robert Nakato', 'Other', 62, '+256752069179', 'robert.65@yahoo.com', 'Shopkeeper', 'Master’s Degree', '278 Market Lane, Jinja, Jinja', 'Football team'),
(179, 179, 'Solomon Kato', 36, '+256754196643', 'solomon.kato24@gmail.com', 'Farmer', 'Primary', 'Grace Nantogo', 47, '+256706953582', 'grace.499@gmail.com', 'Nurse', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(180, 180, 'John Busingye', 36, '+256756022368', 'john.busingye16@gmail.com', 'Engineer', 'Primary', 'Alice Aine', 47, '+256784615749', 'alice.343@gmail.com', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(181, 181, 'Daniel Namukasa', 34, '+256786124240', 'daniel.namukasa16@gmail.com', 'Teacher', 'Primary', 'Alice Okello', 45, '+256772679908', 'alice.607@gmail.com', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(182, 182, 'Brian Okello', 64, '+256757381578', 'brian.okello0@gmail.com', 'Engineer', 'Secondary', 'Sarah Aine', 36, '+256776817571', 'sarah.830@gmail.com', 'Trader', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(183, 183, 'Moses Nakato', 37, '+256755014831', 'moses.nakato50@gmail.com', 'Engineer', 'Diploma', 'Sandra Nakato', 39, '+256752403934', 'sandra.555@gmail.com', 'Entrepreneur', 'Diploma', 'Lillian Nakato', 'Mother', 41, '+256703806637', 'lillian.22@yahoo.com', 'Mechanic', 'Bachelor’s Degree', '314 Church Road, Jinja, Jinja', 'Science fair participant'),
(184, 184, 'Peter Namukasa', 59, '+256772696219', 'peter.namukasa84@gmail.com', 'Teacher', 'Primary', 'Esther Opio', 62, '+256785447778', 'esther.883@gmail.com', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(185, 185, 'Daniel Nalubega', 47, '+256772114192', 'daniel.nalubega55@gmail.com', 'Driver', 'Primary', 'Sarah Okello', 30, '+256707318938', 'sarah.236@gmail.com', 'Civil Servant', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(186, 186, 'Peter Busingye', 69, '+256759487669', 'peter.busingye95@gmail.com', 'Teacher', 'Primary', 'Joan Ssemwogerere', 60, '+256758965577', 'joan.508@gmail.com', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(187, 187, 'Daniel Okello', 41, '+256789079789', 'daniel.okello19@gmail.com', 'Mechanic', 'Diploma', 'Sarah Tumusiime', 28, '+256704673753', 'sarah.647@gmail.com', 'Farmer', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(188, 188, 'Joseph Musoke', 43, '+256707422677', 'joseph.musoke49@gmail.com', 'Farmer', 'Master’s Degree', 'Joy Mugabe', 41, '+256783459164', 'joy.836@gmail.com', 'Teacher', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(189, 189, 'Andrew Lwanga', 39, '+256783444096', 'andrew.lwanga40@gmail.com', 'Mechanic', 'Secondary', 'Sarah Waiswa', 58, '+256784579564', 'sarah.3@gmail.com', 'Nurse', 'Primary', 'Patrick Lwanga', 'Mother', 59, '+256773645527', 'patrick.40@yahoo.com', 'Shopkeeper', 'Secondary', '277 Hospital View, Mbarara, Mbarara', 'Prefect'),
(190, 190, 'Timothy Ssemwogerere', 68, '+256777656372', 'timothy.ssemwogerere3@gmail.com', 'Civil Servant', 'Bachelor’s Degree', 'Joy Mukasa', 32, '+256753723346', 'joy.403@gmail.com', 'Teacher', 'Diploma', 'James Ssemwogerere', 'Aunt', 40, '+256774387071', 'james.53@yahoo.com', 'Shopkeeper', 'Secondary', '426 Main Street, Arua, Arua', 'Science fair participant'),
(191, 191, 'David Akello', 49, '+256702727173', 'david.akello1@gmail.com', 'Engineer', 'Secondary', 'Ritah Tumusiime', 55, '+256774521062', 'ritah.781@gmail.com', 'Teacher', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(192, 192, 'Brian Tumusiime', 32, '+256774552663', 'brian.tumusiime84@gmail.com', 'Carpenter', 'Master’s Degree', 'Mercy Nakato', 52, '+256773387995', 'mercy.889@gmail.com', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(193, 193, 'Joseph Ochieng', 55, '+256776061765', 'joseph.ochieng46@gmail.com', 'Carpenter', 'Primary', 'Joy Busingye', 55, '+256787791308', 'joy.798@gmail.com', 'Teacher', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(194, 194, 'Solomon Ochieng', 34, '+256782997347', 'solomon.ochieng54@gmail.com', 'Carpenter', 'Primary', 'Ritah Nakato', 64, '+256706960804', 'ritah.992@gmail.com', 'Entrepreneur', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(195, 195, 'Brian Tumusiime', 64, '+256781318459', 'brian.tumusiime78@gmail.com', 'Mechanic', 'Primary', 'Esther Opio', 47, '+256778194049', 'esther.582@gmail.com', 'Housewife', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(196, 196, 'Joseph Waiswa', 63, '+256756699514', 'joseph.waiswa54@gmail.com', 'Driver', 'Secondary', 'Sandra Waiswa', 53, '+256787465394', 'sandra.966@gmail.com', 'Trader', 'Diploma', 'Hellen Waiswa', 'Mother', 40, '+256751387924', 'hellen.67@yahoo.com', 'Shopkeeper', 'Secondary', '220 Hospital View, Kampala, Kampala', 'Football team'),
(197, 197, 'Peter Ochieng', 55, '+256783437572', 'peter.ochieng88@gmail.com', 'Shopkeeper', 'Master’s Degree', 'Sandra Okello', 51, '+256779926024', 'sandra.721@gmail.com', 'Nurse', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(198, 198, 'Timothy Namukasa', 34, '+256777268280', 'timothy.namukasa82@gmail.com', 'Mechanic', 'Bachelor’s Degree', 'Pritah Nalubega', 63, '+256704246100', 'pritah.808@gmail.com', 'Tailor', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(199, 199, 'Ivan Busingye', 32, '+256755139990', 'ivan.busingye48@gmail.com', 'Carpenter', 'Master’s Degree', 'Sarah Busingye', 53, '+256705814547', 'sarah.656@gmail.com', 'Tailor', 'Primary', 'Florence Busingye', 'Uncle', 71, '+256756388363', 'florence.84@yahoo.com', 'Carpenter', 'Diploma', '485 Main Street, Jinja, Jinja', 'Active in debate club'),
(200, 200, 'Samuel Mugabe', 53, '+256705537511', 'samuel.mugabe21@gmail.com', 'Doctor', 'Bachelor’s Degree', 'Rebecca Ochieng', 63, '+256777324038', 'rebecca.814@gmail.com', 'Tailor', 'Primary', 'Lillian Mugabe', 'Father', 71, '+256788792842', 'lillian.53@yahoo.com', 'Mechanic', 'Secondary', '243 Market Lane, Masaka, Masaka', 'Choir member'),
(201, 201, 'Brian Tumusiime', 33, '+256789369782', 'brian.tumusiime37@gmail.com', 'Engineer', 'Diploma', 'Grace Nalubega', 44, '+256785472189', 'grace.187@gmail.com', 'Civil Servant', 'Primary', 'James Tumusiime', 'Uncle', 46, '+256759115824', 'james.62@yahoo.com', 'Driver', 'Diploma', '454 Hospital View, Soroti, Soroti', 'Prefect'),
(202, 202, 'Samuel Kyomuhendo', 48, '+256701240681', 'samuel.kyomuhendo10@gmail.com', 'Mechanic', 'Diploma', 'Doreen Ssemwogerere', 39, '+256784052166', 'doreen.865@gmail.com', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(203, 203, 'Andrew Kyomuhendo', 35, '+256757687482', 'andrew.kyomuhendo66@gmail.com', 'Shopkeeper', 'Master’s Degree', 'Joy Ssemwogerere', 36, '+256774462796', 'joy.475@gmail.com', 'Civil Servant', 'Master’s Degree', 'Florence Kyomuhendo', 'Other', 39, '+256776042770', 'florence.52@yahoo.com', 'Engineer', 'Secondary', '62 Main Street, Mbale, Mbale', 'Prefect'),
(204, 204, 'Timothy Ssemwogerere', 32, '+256788499602', 'timothy.ssemwogerere70@gmail.com', 'Farmer', 'Master’s Degree', 'Sandra Okello', 36, '+256773622061', 'sandra.20@gmail.com', 'Nurse', 'Bachelor’s Degree', 'Rose Ssemwogerere', 'Grandparent', 67, '+256755314705', 'rose.62@yahoo.com', 'Shopkeeper', 'Master’s Degree', '434 Hospital View, Lira, Lira', 'Choir member'),
(205, 205, 'Timothy Busingye', 32, '+256757129396', 'timothy.busingye61@gmail.com', 'Driver', 'Primary', 'Winnie Opio', 57, '+256779152966', 'winnie.100@gmail.com', 'Trader', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(206, 206, 'Brian Busingye', 43, '+256787112112', 'brian.busingye66@gmail.com', 'Civil Servant', 'Secondary', 'Rebecca Opio', 62, '+256787906816', 'rebecca.45@gmail.com', 'Tailor', 'Bachelor’s Degree', 'James Busingye', 'Aunt', 79, '+256776724735', 'james.69@yahoo.com', 'Teacher', 'Diploma', '447 Church Road, Soroti, Soroti', 'Science fair participant'),
(207, 207, 'Daniel Ssemwogerere', 52, '+256785503283', 'daniel.ssemwogerere80@gmail.com', 'Engineer', 'Primary', 'Doreen Mukasa', 32, '+256701885626', 'doreen.682@gmail.com', 'Trader', 'Secondary', 'Charles Ssemwogerere', 'Father', 31, '+256782574166', 'charles.12@yahoo.com', 'Doctor', 'Master’s Degree', '483 Main Street, Gulu, Gulu', 'Active in debate club'),
(208, 208, 'Solomon Waiswa', 31, '+256772091828', 'solomon.waiswa47@gmail.com', 'Civil Servant', 'Bachelor’s Degree', 'Joan Nakato', 47, '+256784398809', 'joan.932@gmail.com', 'Entrepreneur', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(209, 209, 'Moses Akello', 50, '+256706333978', 'moses.akello65@gmail.com', 'Shopkeeper', 'Bachelor’s Degree', 'Joy Mugabe', 52, '+256784575839', 'joy.369@gmail.com', 'Farmer', 'Master’s Degree', 'Lillian Akello', 'Grandparent', 79, '+256779545352', 'lillian.32@yahoo.com', 'Shopkeeper', 'Primary', '107 School Road, Gulu, Gulu', 'Prefect'),
(210, 210, 'Moses Nantogo', 30, '+256772274855', 'moses.nantogo28@gmail.com', 'Farmer', 'Master’s Degree', 'Grace Byaruhanga', 53, '+256778543393', 'grace.841@gmail.com', 'Entrepreneur', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(211, 211, 'Solomon Busingye', 31, '+256707877618', 'solomon.busingye65@gmail.com', 'Farmer', 'Bachelor’s Degree', 'Alice Mugabe', 37, '+256772012192', 'alice.519@gmail.com', 'Housewife', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(212, 212, 'David Akello', 51, '+256783640392', 'david.akello67@gmail.com', 'Shopkeeper', 'Secondary', 'Mary Kato', 35, '+256772121018', 'mary.516@gmail.com', 'Trader', 'Master’s Degree', 'Lillian Akello', 'Grandparent', 36, '+256771472521', 'lillian.76@yahoo.com', 'Mechanic', 'Primary', '123 Central Avenue, Mbale, Mbale', 'Prefect'),
(213, 213, 'Mark Lwanga', 42, '+256759337885', 'mark.lwanga61@gmail.com', 'Civil Servant', 'Diploma', 'Joy Ssemwogerere', 34, '+256702122774', 'joy.711@gmail.com', 'Housewife', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(214, 214, 'Peter Waiswa', 65, '+256788788100', 'peter.waiswa49@gmail.com', 'Mechanic', 'Secondary', 'Pritah Busingye', 28, '+256755034418', 'pritah.72@gmail.com', 'Entrepreneur', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(215, 215, 'Mark Okello', 62, '+256771012226', 'mark.okello75@gmail.com', 'Civil Servant', 'Diploma', 'Rebecca Opio', 34, '+256781845138', 'rebecca.90@gmail.com', 'Trader', 'Secondary', 'Lillian Okello', 'Grandparent', 51, '+256786658697', 'lillian.53@yahoo.com', 'Mechanic', 'Secondary', '489 Church Road, Jinja, Jinja', 'Science fair participant'),
(216, 216, 'Andrew Kato', 44, '+256781270964', 'andrew.kato28@gmail.com', 'Mechanic', 'Diploma', 'Rebecca Nalubega', 29, '+256787136378', 'rebecca.18@gmail.com', 'Farmer', 'Bachelor’s Degree', 'Alice Kato', 'Aunt', 73, '+256774957588', 'alice.78@yahoo.com', 'Driver', 'Bachelor’s Degree', '125 Church Road, Arua, Arua', 'Football team'),
(217, 217, 'Andrew Mukasa', 54, '+256787579698', 'andrew.mukasa95@gmail.com', 'Farmer', 'Primary', 'Rebecca Ssemwogerere', 50, '+256706859904', 'rebecca.114@gmail.com', 'Housewife', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(218, 218, 'Peter Byaruhanga', 47, '+256758095912', 'peter.byaruhanga75@gmail.com', 'Carpenter', 'Primary', 'Alice Ssemwogerere', 60, '+256707030022', 'alice.179@gmail.com', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(219, 219, 'Daniel Opio', 42, '+256705657538', 'daniel.opio17@gmail.com', 'Teacher', 'Secondary', 'Mary Nantogo', 59, '+256759069212', 'mary.305@gmail.com', 'Teacher', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(220, 220, 'Joseph Mukasa', 62, '+256756681197', 'joseph.mukasa53@gmail.com', 'Engineer', 'Bachelor’s Degree', 'Sandra Mukasa', 45, '+256779189231', 'sandra.438@gmail.com', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(221, 221, 'Paul Namukasa', 68, '+256753913471', 'paul.namukasa97@gmail.com', 'Carpenter', 'Secondary', 'Winnie Kato', 55, '+256777109561', 'winnie.952@gmail.com', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(222, 222, 'Moses Lwanga', 58, '+256779094261', 'moses.lwanga27@gmail.com', 'Civil Servant', 'Diploma', 'Winnie Nantogo', 52, '+256775266984', 'winnie.219@gmail.com', 'Civil Servant', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(223, 223, 'Joseph Tumusiime', 41, '+256783094006', 'joseph.tumusiime59@gmail.com', 'Civil Servant', 'Diploma', 'Alice Ochieng', 52, '+256789544169', 'alice.101@gmail.com', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(224, 224, 'Mark Byaruhanga', 53, '+256776849526', 'mark.byaruhanga50@gmail.com', 'Driver', 'Diploma', 'Brenda Mukasa', 47, '+256752935199', 'brenda.32@gmail.com', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(225, 225, 'John Opio', 51, '+256707103624', 'john.opio31@gmail.com', 'Carpenter', 'Secondary', 'Joy Okello', 58, '+256776688476', 'joy.143@gmail.com', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(226, 226, 'David Mukasa', 65, '+256757175914', 'david.mukasa58@gmail.com', 'Shopkeeper', 'Diploma', 'Ritah Musoke', 46, '+256755153446', 'ritah.376@gmail.com', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(227, 227, 'Ivan Opio', 51, '+256789585751', 'ivan.opio8@gmail.com', 'Driver', 'Bachelor’s Degree', 'Sandra Namukasa', 44, '+256708260849', 'sandra.572@gmail.com', 'Trader', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(228, 228, 'Brian Mukasa', 41, '+256708540191', 'brian.mukasa15@gmail.com', 'Mechanic', 'Primary', 'Joy Mukasa', 56, '+256757284111', 'joy.774@gmail.com', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(229, 229, 'Ivan Musoke', 57, '+256785717211', 'ivan.musoke25@gmail.com', 'Civil Servant', 'Diploma', 'Joy Waiswa', 57, '+256752718873', 'joy.275@gmail.com', 'Farmer', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(230, 230, 'Paul Nakato', 33, '+256773232206', 'paul.nakato95@gmail.com', 'Driver', 'Diploma', 'Doreen Tumusiime', 49, '+256787893326', 'doreen.975@gmail.com', 'Entrepreneur', 'Primary', 'Hellen Nakato', 'Father', 37, '+256759866474', 'hellen.40@yahoo.com', 'Carpenter', 'Diploma', '98 Market Lane, Jinja, Jinja', 'Prefect'),
(231, 231, 'Isaac Opio', 67, '+256758642750', 'isaac.opio69@gmail.com', 'Shopkeeper', 'Secondary', 'Joy Aine', 58, '+256756578648', 'joy.535@gmail.com', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(232, 232, 'John Lwanga', 49, '+256786456791', 'john.lwanga26@gmail.com', 'Civil Servant', 'Master’s Degree', 'Doreen Aine', 51, '+256704686375', 'doreen.170@gmail.com', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(233, 233, 'Solomon Ssemwogerere', 62, '+256789091852', 'solomon.ssemwogerere10@gmail.com', 'Carpenter', 'Diploma', 'Joan Kyomuhendo', 48, '+256756562524', 'joan.482@gmail.com', 'Teacher', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(234, 234, 'Timothy Musoke', 39, '+256751970635', 'timothy.musoke50@gmail.com', 'Shopkeeper', 'Secondary', 'Mary Okello', 48, '+256752306938', 'mary.196@gmail.com', 'Farmer', 'Primary', 'Florence Musoke', 'Uncle', 38, '+256754042650', 'florence.68@yahoo.com', 'Carpenter', 'Diploma', '114 Main Street, Kampala, Kampala', 'Football team'),
(235, 235, 'Paul Tumusiime', 56, '+256755924549', 'paul.tumusiime5@gmail.com', 'Farmer', 'Bachelor’s Degree', 'Alice Akello', 41, '+256703751131', 'alice.456@gmail.com', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(236, 236, 'Brian Nantogo', 47, '+256779093487', 'brian.nantogo2@gmail.com', 'Teacher', 'Primary', 'Mary Mukasa', 50, '+256704548916', 'mary.959@gmail.com', 'Farmer', 'Primary', 'Lillian Nantogo', 'Father', 58, '+256758258961', 'lillian.88@yahoo.com', 'Carpenter', 'Secondary', '49 Main Street, Gulu, Gulu', 'Prefect'),
(237, 237, 'Joseph Busingye', 55, '+256755320785', 'joseph.busingye21@gmail.com', 'Driver', 'Bachelor’s Degree', 'Grace Lwanga', 47, '+256772527141', 'grace.406@gmail.com', 'Tailor', 'Diploma', 'Florence Busingye', 'Aunt', 54, '+256756614937', 'florence.89@yahoo.com', 'Civil Servant', 'Primary', '52 School Road, Mbarara, Mbarara', 'Choir member'),
(238, 238, 'Andrew Opio', 58, '+256789855619', 'andrew.opio13@gmail.com', 'Farmer', 'Bachelor’s Degree', 'Pritah Mukasa', 56, '+256758865871', 'pritah.477@gmail.com', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(239, 239, 'Daniel Ochieng', 34, '+256773752481', 'daniel.ochieng79@gmail.com', 'Farmer', 'Diploma', 'Ritah Busingye', 60, '+256785545874', 'ritah.677@gmail.com', 'Teacher', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(240, 240, 'Moses Okello', 34, '+256703790942', 'moses.okello40@gmail.com', 'Doctor', 'Primary', 'Alice Waiswa', 42, '+256758599324', 'alice.184@gmail.com', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(241, 241, 'Mark Nakato', 42, '+256706725388', 'mark.nakato83@gmail.com', 'Teacher', 'Secondary', 'Sandra Lwanga', 34, '+256774372335', 'sandra.261@gmail.com', 'Farmer', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(242, 242, 'Moses Busingye', 57, '+256784875307', 'moses.busingye78@gmail.com', 'Teacher', 'Secondary', 'Mercy Waiswa', 53, '+256755599092', 'mercy.646@gmail.com', 'Trader', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(243, 243, 'Mark Mugabe', 63, '+256784477723', 'mark.mugabe59@gmail.com', 'Engineer', 'Secondary', 'Mary Opio', 44, '+256788101805', 'mary.162@gmail.com', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(244, 244, 'Mark Musoke', 52, '+256779968190', 'mark.musoke70@gmail.com', 'Civil Servant', 'Master’s Degree', 'Joan Ochieng', 51, '+256778083368', 'joan.795@gmail.com', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(245, 245, 'Ivan Okello', 66, '+256783648327', 'ivan.okello55@gmail.com', 'Carpenter', 'Diploma', 'Esther Akello', 51, '+256784521654', 'esther.563@gmail.com', 'Trader', 'Bachelor’s Degree', 'Susan Okello', 'Grandparent', 49, '+256755063984', 'susan.1@yahoo.com', 'Farmer', 'Diploma', '280 Church Road, Mbale, Mbale', 'Football team'),
(246, 246, 'Mark Kyomuhendo', 32, '+256759326092', 'mark.kyomuhendo56@gmail.com', 'Shopkeeper', 'Master’s Degree', 'Alice Mugabe', 37, '+256773361922', 'alice.210@gmail.com', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(247, 247, 'David Nantogo', 37, '+256706206068', 'david.nantogo77@gmail.com', 'Shopkeeper', 'Secondary', 'Winnie Nakato', 29, '+256775953404', 'winnie.140@gmail.com', 'Housewife', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(248, 248, 'Isaac Nalubega', 69, '+256757678089', 'isaac.nalubega63@gmail.com', 'Teacher', 'Secondary', 'Mary Mugabe', 32, '+256752929675', 'mary.151@gmail.com', 'Farmer', 'Secondary', 'Robert Nalubega', 'Grandparent', 55, '+256758939150', 'robert.66@yahoo.com', 'Shopkeeper', 'Secondary', '38 Hospital View, Mbarara, Mbarara', 'Active in debate club'),
(249, 249, 'Moses Nantogo', 57, '+256754281236', 'moses.nantogo15@gmail.com', 'Mechanic', 'Bachelor’s Degree', 'Alice Mukasa', 60, '+256754024013', 'alice.575@gmail.com', 'Civil Servant', 'Diploma', 'Robert Nantogo', 'Mother', 76, '+256758134309', 'robert.30@yahoo.com', 'Farmer', 'Primary', '257 School Road, Jinja, Jinja', 'Active in debate club'),
(250, 250, 'Andrew Nalubega', 44, '+256771120723', 'andrew.nalubega67@gmail.com', 'Carpenter', 'Master’s Degree', 'Winnie Kyomuhendo', 36, '+256787817445', 'winnie.502@gmail.com', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(251, 251, 'Peter Nakato', 51, '+256786233605', 'peter.nakato25@gmail.com', 'Mechanic', 'Primary', 'Mary Busingye', 45, '+256707553333', 'mary.528@gmail.com', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(252, 252, 'Isaac Kato', 57, '+256774716570', 'isaac.kato97@gmail.com', 'Driver', 'Diploma', 'Sarah Tumusiime', 64, '+256705105889', 'sarah.872@gmail.com', 'Teacher', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(253, 253, 'John Lwanga', 67, '+256786464429', 'john.lwanga74@gmail.com', 'Driver', 'Diploma', 'Alice Nakato', 40, '+256754118284', 'alice.77@gmail.com', 'Trader', 'Diploma', 'Lillian Lwanga', 'Mother', 32, '+256708869106', 'lillian.37@yahoo.com', 'Mechanic', 'Secondary', '381 Church Road, Gulu, Gulu', 'Choir member'),
(254, 254, 'Brian Ssemwogerere', 69, '+256777935666', 'brian.ssemwogerere45@gmail.com', 'Shopkeeper', 'Master’s Degree', 'Alice Ochieng', 38, '+256788375186', 'alice.546@gmail.com', 'Civil Servant', 'Master’s Degree', 'James Ssemwogerere', 'Grandparent', 64, '+256754717001', 'james.98@yahoo.com', 'Engineer', 'Diploma', '169 Market Lane, Gulu, Gulu', 'Football team'),
(255, 255, 'John Nalubega', 55, '+256752257234', 'john.nalubega80@gmail.com', 'Civil Servant', 'Master’s Degree', 'Winnie Namukasa', 50, '+256707457987', 'winnie.751@gmail.com', 'Housewife', 'Primary', 'Susan Nalubega', 'Aunt', 78, '+256787986291', 'susan.38@yahoo.com', 'Teacher', 'Primary', '99 School Road, Gulu, Gulu', 'Choir member'),
(256, 256, 'Andrew Ochieng', 62, '+256759604578', 'andrew.ochieng53@gmail.com', 'Driver', 'Primary', 'Ritah Ssemwogerere', 49, '+256775974133', 'ritah.245@gmail.com', 'Nurse', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(257, 257, 'Solomon Nakato', 56, '+256785699886', 'solomon.nakato83@gmail.com', 'Carpenter', 'Primary', 'Mary Nakato', 30, '+256776882308', 'mary.202@gmail.com', 'Civil Servant', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(258, 258, 'Paul Nalubega', 59, '+256774039946', 'paul.nalubega34@gmail.com', 'Civil Servant', 'Primary', 'Mercy Opio', 51, '+256701671055', 'mercy.173@gmail.com', 'Civil Servant', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(259, 259, 'Paul Ochieng', 35, '+256785834504', 'paul.ochieng74@gmail.com', 'Engineer', 'Bachelor’s Degree', 'Ritah Nantogo', 36, '+256777793070', 'ritah.500@gmail.com', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(260, 260, 'Andrew Ochieng', 51, '+256706987982', 'andrew.ochieng50@gmail.com', 'Farmer', 'Secondary', 'Joy Akello', 43, '+256774400444', 'joy.307@gmail.com', 'Nurse', 'Secondary', 'Charles Ochieng', 'Uncle', 67, '+256785989491', 'charles.81@yahoo.com', 'Shopkeeper', 'Diploma', '231 Market Lane, Kampala, Kampala', 'Choir member'),
(261, 261, 'Isaac Nalubega', 39, '+256752626582', 'isaac.nalubega15@gmail.com', 'Civil Servant', 'Master’s Degree', 'Joan Nalubega', 32, '+256782494148', 'joan.124@gmail.com', 'Teacher', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(262, 262, 'Solomon Okello', 34, '+256757880457', 'solomon.okello7@gmail.com', 'Doctor', 'Primary', 'Ritah Busingye', 48, '+256788091734', 'ritah.581@gmail.com', 'Entrepreneur', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(263, 263, 'John Kyomuhendo', 33, '+256756381120', 'john.kyomuhendo37@gmail.com', 'Engineer', 'Diploma', 'Grace Opio', 30, '+256705989946', 'grace.343@gmail.com', 'Farmer', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(264, 264, 'Daniel Mukasa', 44, '+256781939581', 'daniel.mukasa53@gmail.com', 'Doctor', 'Primary', 'Joan Mukasa', 40, '+256777271156', 'joan.886@gmail.com', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(265, 265, 'Mark Namukasa', 32, '+256706078473', 'mark.namukasa54@gmail.com', 'Shopkeeper', 'Primary', 'Pritah Namukasa', 47, '+256703231905', 'pritah.53@gmail.com', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(266, 266, 'Solomon Kato', 60, '+256771907194', 'solomon.kato80@gmail.com', 'Engineer', 'Diploma', 'Esther Nalubega', 34, '+256787161456', 'esther.447@gmail.com', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(267, 267, 'Brian Okello', 45, '+256786633543', 'brian.okello44@gmail.com', 'Driver', 'Bachelor’s Degree', 'Joan Musoke', 48, '+256776684887', 'joan.887@gmail.com', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(268, 268, 'Moses Tumusiime', 41, '+256754213124', 'moses.tumusiime7@gmail.com', 'Doctor', 'Diploma', 'Joan Waiswa', 28, '+256777129934', 'joan.210@gmail.com', 'Tailor', 'Primary', 'Lillian Tumusiime', 'Uncle', 64, '+256775358485', 'lillian.17@yahoo.com', 'Farmer', 'Master’s Degree', '318 School Road, Masaka, Masaka', 'Active in debate club'),
(269, 269, 'Peter Mukasa', 50, '+256771656092', 'peter.mukasa34@gmail.com', 'Driver', 'Master’s Degree', 'Pritah Busingye', 59, '+256753584798', 'pritah.341@gmail.com', 'Farmer', 'Diploma', 'Hellen Mukasa', 'Aunt', 34, '+256759640801', 'hellen.29@yahoo.com', 'Teacher', 'Bachelor’s Degree', '159 Central Avenue, Jinja, Jinja', 'Prefect'),
(270, 270, 'Ivan Byaruhanga', 69, '+256783235621', 'ivan.byaruhanga34@gmail.com', 'Mechanic', 'Diploma', 'Grace Kato', 43, '+256754640226', 'grace.923@gmail.com', 'Teacher', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(271, 271, 'Peter Mukasa', 58, '+256771301306', 'peter.mukasa15@gmail.com', 'Teacher', 'Primary', 'Grace Busingye', 53, '+256772984177', 'grace.869@gmail.com', 'Housewife', 'Primary', 'Hellen Mukasa', 'Mother', 69, '+256701275215', 'hellen.5@yahoo.com', 'Driver', 'Master’s Degree', '190 Hospital View, Fort Portal, Fort Portal', 'Active in debate club'),
(272, 272, 'Daniel Waiswa', 58, '+256774575364', 'daniel.waiswa77@gmail.com', 'Farmer', 'Bachelor’s Degree', 'Grace Ssemwogerere', 37, '+256709610136', 'grace.23@gmail.com', 'Farmer', 'Primary', 'Charles Waiswa', 'Mother', 47, '+256753300715', 'charles.59@yahoo.com', 'Engineer', 'Diploma', '486 Church Road, Masaka, Masaka', 'Choir member'),
(273, 273, 'Samuel Ochieng', 35, '+256776694125', 'samuel.ochieng0@gmail.com', 'Civil Servant', 'Primary', 'Winnie Busingye', 63, '+256787859400', 'winnie.449@gmail.com', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(274, 274, 'Mark Ochieng', 46, '+256756209642', 'mark.ochieng2@gmail.com', 'Mechanic', 'Diploma', 'Brenda Nakato', 45, '+256751022267', 'brenda.496@gmail.com', 'Entrepreneur', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(275, 275, 'Solomon Nakato', 59, '+256776211787', 'solomon.nakato48@gmail.com', 'Farmer', 'Bachelor’s Degree', 'Rebecca Waiswa', 40, '+256783842267', 'rebecca.654@gmail.com', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(276, 276, 'Solomon Mugabe', 36, '+256755476761', 'solomon.mugabe92@gmail.com', 'Teacher', 'Diploma', 'Brenda Nakato', 30, '+256704557297', 'brenda.847@gmail.com', 'Civil Servant', 'Diploma', 'Susan Mugabe', 'Other', 38, '+256788205924', 'susan.46@yahoo.com', 'Engineer', 'Secondary', '333 School Road, Fort Portal, Fort Portal', 'Choir member'),
(277, 277, 'Solomon Byaruhanga', 60, '+256755700869', 'solomon.byaruhanga6@gmail.com', 'Shopkeeper', 'Master’s Degree', 'Sandra Byaruhanga', 48, '+256779551213', 'sandra.281@gmail.com', 'Entrepreneur', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(278, 278, 'Samuel Opio', 65, '+256777064387', 'samuel.opio17@gmail.com', 'Carpenter', 'Bachelor’s Degree', 'Ritah Tumusiime', 29, '+256775554136', 'ritah.309@gmail.com', 'Farmer', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(279, 279, 'Ivan Musoke', 49, '+256773285212', 'ivan.musoke84@gmail.com', 'Mechanic', 'Primary', 'Rebecca Ochieng', 29, '+256778176927', 'rebecca.883@gmail.com', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(280, 280, 'Daniel Byaruhanga', 50, '+256773490797', 'daniel.byaruhanga66@gmail.com', 'Driver', 'Primary', 'Alice Mukasa', 42, '+256755742914', 'alice.396@gmail.com', 'Housewife', 'Master’s Degree', 'Rose Byaruhanga', 'Father', 35, '+256777725380', 'rose.46@yahoo.com', 'Shopkeeper', 'Secondary', '65 Church Road, Fort Portal, Fort Portal', 'Active in debate club'),
(281, 281, 'John Namukasa', 56, '+256706709711', 'john.namukasa11@gmail.com', 'Mechanic', 'Master’s Degree', 'Esther Akello', 58, '+256753468537', 'esther.131@gmail.com', 'Housewife', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(282, 282, 'John Musoke', 55, '+256707255747', 'john.musoke34@gmail.com', 'Farmer', 'Master’s Degree', 'Mercy Busingye', 44, '+256788651952', 'mercy.797@gmail.com', 'Housewife', 'Bachelor’s Degree', 'Robert Musoke', 'Grandparent', 52, '+256751130679', 'robert.16@yahoo.com', 'Teacher', 'Master’s Degree', '329 Hospital View, Fort Portal, Fort Portal', 'Football team'),
(283, 283, 'Timothy Opio', 64, '+256773338702', 'timothy.opio92@gmail.com', 'Shopkeeper', 'Secondary', 'Joan Nantogo', 39, '+256705898666', 'joan.387@gmail.com', 'Teacher', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(284, 284, 'Moses Nakato', 57, '+256755456653', 'moses.nakato62@gmail.com', 'Driver', 'Diploma', 'Brenda Okello', 64, '+256782030164', 'brenda.865@gmail.com', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(285, 285, 'Timothy Musoke', 67, '+256771926312', 'timothy.musoke24@gmail.com', 'Mechanic', 'Bachelor’s Degree', 'Mary Kato', 31, '+256782942407', 'mary.546@gmail.com', 'Housewife', 'Bachelor’s Degree', 'Charles Musoke', 'Father', 59, '+256782112693', 'charles.87@yahoo.com', 'Mechanic', 'Primary', '171 Central Avenue, Mbale, Mbale', 'Prefect'),
(286, 286, 'Timothy Nakato', 46, '+256705471740', 'timothy.nakato37@gmail.com', 'Mechanic', 'Secondary', 'Rebecca Tumusiime', 42, '+256752088022', 'rebecca.749@gmail.com', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(287, 287, 'Timothy Nalubega', 55, '+256772597705', 'timothy.nalubega62@gmail.com', 'Doctor', 'Secondary', 'Winnie Aine', 31, '+256759156756', 'winnie.764@gmail.com', 'Farmer', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(288, 288, 'Solomon Kyomuhendo', 68, '+256759707624', 'solomon.kyomuhendo96@gmail.com', 'Mechanic', 'Bachelor’s Degree', 'Rebecca Busingye', 62, '+256707927908', 'rebecca.645@gmail.com', 'Civil Servant', 'Bachelor’s Degree', 'Robert Kyomuhendo', 'Other', 76, '+256758522798', 'robert.47@yahoo.com', 'Teacher', 'Diploma', '168 Market Lane, Lira, Lira', 'Choir member'),
(289, 289, 'Samuel Ochieng', 57, '+256759034265', 'samuel.ochieng86@gmail.com', 'Carpenter', 'Master’s Degree', 'Joan Okello', 55, '+256707570441', 'joan.385@gmail.com', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(290, 290, 'Mark Kato', 62, '+256707316719', 'mark.kato17@gmail.com', 'Driver', 'Master’s Degree', 'Joy Kyomuhendo', 53, '+256776188024', 'joy.481@gmail.com', 'Entrepreneur', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(291, 291, 'Andrew Kato', 33, '+256784302535', 'andrew.kato82@gmail.com', 'Mechanic', 'Secondary', 'Sandra Opio', 38, '+256783433834', 'sandra.819@gmail.com', 'Entrepreneur', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(292, 292, 'David Opio', 58, '+256757542730', 'david.opio76@gmail.com', 'Farmer', 'Master’s Degree', 'Doreen Tumusiime', 47, '+256781686064', 'doreen.951@gmail.com', 'Housewife', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(293, 293, 'Brian Akello', 33, '+256757664605', 'brian.akello6@gmail.com', 'Doctor', 'Master’s Degree', 'Brenda Aine', 57, '+256757121455', 'brenda.166@gmail.com', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(294, 294, 'Isaac Kato', 43, '+256783641188', 'isaac.kato4@gmail.com', 'Shopkeeper', 'Master’s Degree', 'Mercy Nantogo', 62, '+256782503575', 'mercy.886@gmail.com', 'Nurse', 'Secondary', 'James Kato', 'Father', 76, '+256784735144', 'james.27@yahoo.com', 'Doctor', 'Secondary', '89 Church Road, Soroti, Soroti', 'Active in debate club'),
(295, 295, 'Timothy Okello', 31, '+256708022506', 'timothy.okello66@gmail.com', 'Farmer', 'Bachelor’s Degree', 'Rebecca Tumusiime', 46, '+256756803755', 'rebecca.687@gmail.com', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(296, 296, 'Timothy Ochieng', 34, '+256779186029', 'timothy.ochieng36@gmail.com', 'Driver', 'Primary', 'Joy Nakato', 45, '+256704291416', 'joy.715@gmail.com', 'Teacher', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(297, 297, 'David Tumusiime', 61, '+256776906937', 'david.tumusiime74@gmail.com', 'Civil Servant', 'Primary', 'Pritah Akello', 57, '+256783931664', 'pritah.756@gmail.com', 'Housewife', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(298, 298, 'Brian Opio', 67, '+256752264017', 'brian.opio86@gmail.com', 'Teacher', 'Bachelor’s Degree', 'Brenda Lwanga', 41, '+256776316078', 'brenda.823@gmail.com', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(299, 299, 'Ivan Byaruhanga', 47, '+256784280462', 'ivan.byaruhanga89@gmail.com', 'Engineer', 'Master’s Degree', 'Joy Ochieng', 28, '+256752162647', 'joy.481@gmail.com', 'Civil Servant', 'Secondary', 'Robert Byaruhanga', 'Mother', 73, '+256778849125', 'robert.76@yahoo.com', 'Civil Servant', 'Master’s Degree', '224 Church Road, Soroti, Soroti', 'Active in debate club'),
(300, 300, 'Ivan Kato', 34, '+256777785776', 'ivan.kato7@gmail.com', 'Engineer', 'Diploma', 'Sandra Kato', 57, '+256758627692', 'sandra.467@gmail.com', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(301, 301, 'David Byaruhanga', 31, '+256785693673', 'david.byaruhanga71@gmail.com', 'Teacher', 'Primary', 'Esther Kyomuhendo', 43, '+256787150689', 'esther.493@gmail.com', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(302, 302, 'David Nakato', 58, '+256785633770', 'david.nakato64@gmail.com', 'Driver', 'Bachelor’s Degree', 'Doreen Ochieng', 47, '+256709915379', 'doreen.101@gmail.com', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(303, 303, 'John Tumusiime', 42, '+256788434539', 'john.tumusiime15@gmail.com', 'Teacher', 'Diploma', 'Brenda Kyomuhendo', 46, '+256779883363', 'brenda.893@gmail.com', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(304, 304, 'Samuel Aine', 46, '+256779646947', 'samuel.aine45@gmail.com', 'Civil Servant', 'Secondary', 'Joy Namukasa', 38, '+256708224419', 'joy.537@gmail.com', 'Housewife', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(305, 305, 'John Waiswa', 59, '+256774468805', 'john.waiswa57@gmail.com', 'Mechanic', 'Diploma', 'Ritah Ochieng', 43, '+256757481709', 'ritah.713@gmail.com', 'Entrepreneur', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(306, 306, 'Ivan Byaruhanga', 32, '+256708257334', 'ivan.byaruhanga69@gmail.com', 'Doctor', 'Primary', 'Mercy Tumusiime', 43, '+256772610559', 'mercy.791@gmail.com', 'Civil Servant', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(307, 307, 'Peter Nalubega', 63, '+256789256977', 'peter.nalubega31@gmail.com', 'Doctor', 'Bachelor’s Degree', 'Ritah Nakato', 40, '+256708959594', 'ritah.0@gmail.com', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(308, 308, 'Mark Opio', 60, '+256753366243', 'mark.opio70@gmail.com', 'Shopkeeper', 'Primary', 'Mary Musoke', 41, '+256773788990', 'mary.855@gmail.com', 'Farmer', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(309, 309, 'Joseph Nakato', 66, '+256759014917', 'joseph.nakato70@gmail.com', 'Engineer', 'Primary', 'Joan Waiswa', 44, '+256772204636', 'joan.170@gmail.com', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(310, 310, 'Samuel Tumusiime', 33, '+256779268964', 'samuel.tumusiime16@gmail.com', 'Mechanic', 'Secondary', 'Sandra Waiswa', 47, '+256784495067', 'sandra.539@gmail.com', 'Nurse', 'Bachelor’s Degree', 'Susan Tumusiime', 'Aunt', 40, '+256779372084', 'susan.46@yahoo.com', 'Carpenter', 'Primary', '438 Hospital View, Lira, Lira', 'Active in debate club'),
(311, 311, 'Solomon Ochieng', 49, '+256756610213', 'solomon.ochieng46@gmail.com', 'Teacher', 'Bachelor’s Degree', 'Sandra Namukasa', 51, '+256783307665', 'sandra.879@gmail.com', 'Trader', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(312, 312, 'John Busingye', 56, '+256702822735', 'john.busingye64@gmail.com', 'Engineer', 'Master’s Degree', 'Joy Aine', 58, '+256752428373', 'joy.859@gmail.com', 'Trader', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(313, 313, 'Daniel Tumusiime', 38, '+256704608261', 'daniel.tumusiime67@gmail.com', 'Mechanic', 'Secondary', 'Esther Akello', 42, '+256758047196', 'esther.945@gmail.com', 'Nurse', 'Secondary', 'Hellen Tumusiime', 'Uncle', 55, '+256705296126', 'hellen.16@yahoo.com', 'Driver', 'Master’s Degree', '212 Church Road, Soroti, Soroti', 'Science fair participant'),
(314, 314, 'Isaac Waiswa', 66, '+256788650128', 'isaac.waiswa48@gmail.com', 'Teacher', 'Bachelor’s Degree', 'Joan Kato', 48, '+256754127721', 'joan.719@gmail.com', 'Civil Servant', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(315, 315, 'Peter Opio', 66, '+256759249003', 'peter.opio92@gmail.com', 'Civil Servant', 'Master’s Degree', 'Grace Mugabe', 39, '+256773945360', 'grace.460@gmail.com', 'Farmer', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(316, 316, 'Peter Mukasa', 41, '+256752756287', 'peter.mukasa17@gmail.com', 'Mechanic', 'Master’s Degree', 'Esther Nalubega', 55, '+256777976366', 'esther.814@gmail.com', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(317, 317, 'Brian Tumusiime', 31, '+256709362410', 'brian.tumusiime55@gmail.com', 'Driver', 'Secondary', 'Brenda Nakato', 28, '+256709674845', 'brenda.982@gmail.com', 'Farmer', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(318, 318, 'Timothy Ssemwogerere', 54, '+256776841193', 'timothy.ssemwogerere70@gmail.com', 'Mechanic', 'Master’s Degree', 'Brenda Ochieng', 45, '+256788059503', 'brenda.365@gmail.com', 'Teacher', 'Master’s Degree', 'Patrick Ssemwogerere', 'Grandparent', 60, '+256773892431', 'patrick.92@yahoo.com', 'Farmer', 'Master’s Degree', '444 School Road, Soroti, Soroti', 'Football team'),
(319, 319, 'John Aine', 57, '+256755265761', 'john.aine21@gmail.com', 'Civil Servant', 'Bachelor’s Degree', 'Alice Nalubega', 55, '+256751363829', 'alice.171@gmail.com', 'Farmer', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(320, 320, 'John Waiswa', 41, '+256785675271', 'john.waiswa76@gmail.com', 'Farmer', 'Bachelor’s Degree', 'Pritah Akello', 61, '+256778818658', 'pritah.102@gmail.com', 'Farmer', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(321, 321, 'Mark Waiswa', 65, '+256781271832', 'mark.waiswa39@gmail.com', 'Doctor', 'Bachelor’s Degree', 'Ritah Ssemwogerere', 44, '+256776876870', 'ritah.678@gmail.com', 'Farmer', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(322, 322, 'Timothy Nakato', 30, '+256786709574', 'timothy.nakato18@gmail.com', 'Driver', 'Diploma', 'Brenda Akello', 53, '+256772604481', 'brenda.445@gmail.com', 'Farmer', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(323, 323, 'Paul Kyomuhendo', 43, '+256774509652', 'paul.kyomuhendo49@gmail.com', 'Farmer', 'Bachelor’s Degree', 'Winnie Waiswa', 42, '+256702459631', 'winnie.776@gmail.com', 'Civil Servant', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(324, 324, 'Samuel Aine', 45, '+256788839095', 'samuel.aine59@gmail.com', 'Farmer', 'Bachelor’s Degree', 'Joy Nakato', 64, '+256706342059', 'joy.750@gmail.com', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(325, 325, 'Solomon Mukasa', 59, '+256704472646', 'solomon.mukasa96@gmail.com', 'Civil Servant', 'Diploma', 'Mary Waiswa', 64, '+256773214465', 'mary.742@gmail.com', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(326, 326, 'Peter Opio', 60, '+256773460280', 'peter.opio31@gmail.com', 'Carpenter', 'Master’s Degree', 'Sarah Aine', 62, '+256778656652', 'sarah.697@gmail.com', 'Trader', 'Primary', 'Lillian Opio', 'Father', 29, '+256753360328', 'lillian.36@yahoo.com', 'Doctor', 'Primary', '124 Market Lane, Mbale, Mbale', 'Science fair participant'),
(327, 327, 'David Nantogo', 57, '+256786007465', 'david.nantogo46@gmail.com', 'Teacher', 'Primary', 'Winnie Byaruhanga', 45, '+256751752823', 'winnie.745@gmail.com', 'Farmer', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(328, 328, 'Solomon Tumusiime', 38, '+256788295632', 'solomon.tumusiime12@gmail.com', 'Civil Servant', 'Master’s Degree', 'Sandra Aine', 28, '+256783846974', 'sandra.989@gmail.com', 'Nurse', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(329, 329, 'Daniel Opio', 47, '+256752979517', 'daniel.opio21@gmail.com', 'Driver', 'Diploma', 'Joan Kato', 48, '+256754127830', 'joan.716@gmail.com', 'Trader', 'Primary', 'Charles Opio', 'Father', 47, '+256759885323', 'charles.41@yahoo.com', 'Shopkeeper', 'Master’s Degree', '52 Main Street, Gulu, Gulu', 'Prefect'),
(330, 330, 'Daniel Musoke', 47, '+256774909854', 'daniel.musoke93@gmail.com', 'Engineer', 'Diploma', 'Sandra Waiswa', 33, '+256788080109', 'sandra.302@gmail.com', 'Housewife', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(331, 331, 'Samuel Nantogo', 37, '+256757892757', 'samuel.nantogo68@gmail.com', 'Carpenter', 'Diploma', 'Mary Nantogo', 52, '+256786611968', 'mary.503@gmail.com', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(332, 332, 'Ivan Tumusiime', 55, '+256788179676', 'ivan.tumusiime40@gmail.com', 'Teacher', 'Primary', 'Ritah Ochieng', 62, '+256759635038', 'ritah.763@gmail.com', 'Tailor', 'Secondary', 'Florence Tumusiime', 'Aunt', 79, '+256778061259', 'florence.39@yahoo.com', 'Teacher', 'Primary', '106 Church Road, Soroti, Soroti', 'Science fair participant'),
(333, 333, 'Daniel Aine', 60, '+256757308863', 'daniel.aine96@gmail.com', 'Carpenter', 'Primary', 'Brenda Akello', 60, '+256776473212', 'brenda.337@gmail.com', 'Teacher', 'Master’s Degree', 'Charles Aine', 'Uncle', 78, '+256757943019', 'charles.92@yahoo.com', 'Carpenter', 'Secondary', '453 Hospital View, Gulu, Gulu', 'Football team'),
(334, 334, 'Samuel Mukasa', 40, '+256706511181', 'samuel.mukasa21@gmail.com', 'Shopkeeper', 'Secondary', 'Brenda Kyomuhendo', 45, '+256779933945', 'brenda.289@gmail.com', 'Tailor', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(335, 335, 'Isaac Opio', 30, '+256787708687', 'isaac.opio4@gmail.com', 'Carpenter', 'Secondary', 'Joy Mukasa', 61, '+256753704443', 'joy.362@gmail.com', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(336, 336, 'David Nantogo', 39, '+256751931281', 'david.nantogo50@gmail.com', 'Shopkeeper', 'Secondary', 'Grace Lwanga', 37, '+256775766626', 'grace.970@gmail.com', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(337, 337, 'Samuel Kyomuhendo', 51, '+256774635787', 'samuel.kyomuhendo34@gmail.com', 'Shopkeeper', 'Secondary', 'Winnie Ssemwogerere', 55, '+256787034655', 'winnie.352@gmail.com', 'Civil Servant', 'Secondary', 'Patrick Kyomuhendo', 'Grandparent', 25, '+256756254587', 'patrick.88@yahoo.com', 'Carpenter', 'Master’s Degree', '83 Church Road, Soroti, Soroti', 'Choir member'),
(338, 338, 'David Nakato', 55, '+256758801100', 'david.nakato44@gmail.com', 'Carpenter', 'Secondary', 'Alice Namukasa', 42, '+256784132400', 'alice.286@gmail.com', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(339, 339, 'John Okello', 57, '+256756125021', 'john.okello27@gmail.com', 'Driver', 'Bachelor’s Degree', 'Mary Waiswa', 38, '+256708124328', 'mary.129@gmail.com', 'Entrepreneur', 'Primary', 'James Okello', 'Other', 25, '+256756858066', 'james.57@yahoo.com', 'Farmer', 'Master’s Degree', '111 Central Avenue, Gulu, Gulu', 'Science fair participant'),
(340, 340, 'Andrew Kyomuhendo', 59, '+256788871827', 'andrew.kyomuhendo66@gmail.com', 'Civil Servant', 'Secondary', 'Joy Nalubega', 64, '+256705126200', 'joy.270@gmail.com', 'Nurse', 'Diploma', 'Rose Kyomuhendo', 'Uncle', 79, '+256773952487', 'rose.8@yahoo.com', 'Shopkeeper', 'Master’s Degree', '136 Central Avenue, Mbarara, Mbarara', 'Science fair participant'),
(341, 341, 'Isaac Tumusiime', 67, '+256789523457', 'isaac.tumusiime94@gmail.com', 'Carpenter', 'Diploma', 'Rebecca Kyomuhendo', 50, '+256758554097', 'rebecca.424@gmail.com', 'Housewife', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(342, 342, 'Moses Ochieng', 41, '+256775223129', 'moses.ochieng33@gmail.com', 'Engineer', 'Secondary', 'Sarah Nantogo', 57, '+256759133740', 'sarah.299@gmail.com', 'Nurse', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(343, 343, 'Mark Nalubega', 60, '+256755397197', 'mark.nalubega64@gmail.com', 'Mechanic', 'Secondary', 'Mercy Nalubega', 30, '+256774711455', 'mercy.659@gmail.com', 'Teacher', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(344, 344, 'Daniel Ochieng', 52, '+256771471380', 'daniel.ochieng73@gmail.com', 'Shopkeeper', 'Primary', 'Grace Namukasa', 45, '+256756907426', 'grace.289@gmail.com', 'Trader', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(345, 345, 'Samuel Lwanga', 45, '+256775928448', 'samuel.lwanga60@gmail.com', 'Farmer', 'Diploma', 'Mary Aine', 47, '+256771665431', 'mary.748@gmail.com', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(346, 346, 'Brian Okello', 48, '+256773889967', 'brian.okello87@gmail.com', 'Shopkeeper', 'Master’s Degree', 'Sandra Nakato', 41, '+256757550524', 'sandra.707@gmail.com', 'Civil Servant', 'Secondary', 'Rose Okello', 'Father', 39, '+256785461984', 'rose.12@yahoo.com', 'Mechanic', 'Master’s Degree', '11 Main Street, Kampala, Kampala', 'Football team'),
(347, 347, 'Isaac Waiswa', 46, '+256755875717', 'isaac.waiswa79@gmail.com', 'Shopkeeper', 'Master’s Degree', 'Alice Akello', 32, '+256753314050', 'alice.576@gmail.com', 'Housewife', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(348, 348, 'Ivan Byaruhanga', 44, '+256775687287', 'ivan.byaruhanga97@gmail.com', 'Mechanic', 'Diploma', 'Pritah Nalubega', 42, '+256772469657', 'pritah.574@gmail.com', 'Farmer', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant');
INSERT INTO `parents` (`ParentId`, `AdmissionNo`, `father_name`, `father_age`, `father_contact`, `father_email`, `father_occupation`, `father_education`, `mother_name`, `mother_age`, `mother_contact`, `mother_email`, `mother_occupation`, `mother_education`, `guardian_name`, `guardian_relation`, `guardian_age`, `guardian_contact`, `guardian_email`, `guardian_occupation`, `guardian_education`, `guardian_address`, `MoreInformation`) VALUES
(349, 349, 'Brian Kyomuhendo', 33, '+256701427634', 'brian.kyomuhendo4@gmail.com', 'Doctor', 'Primary', 'Doreen Mukasa', 52, '+256705892004', 'doreen.658@gmail.com', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(350, 350, 'Joseph Akello', 37, '+256702671612', 'joseph.akello14@gmail.com', 'Driver', 'Primary', 'Joan Mugabe', 43, '+256779165486', 'joan.29@gmail.com', 'Nurse', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(351, 351, 'Mark Musoke', 56, '+256701612142', 'mark.musoke37@gmail.com', 'Farmer', 'Primary', 'Alice Ssemwogerere', 30, '+256709565113', 'alice.384@gmail.com', 'Farmer', 'Bachelor’s Degree', 'Rose Musoke', 'Father', 44, '+256707333409', 'rose.22@yahoo.com', 'Carpenter', 'Master’s Degree', '193 Central Avenue, Jinja, Jinja', 'Science fair participant'),
(352, 352, 'John Tumusiime', 39, '+256754056990', 'john.tumusiime64@gmail.com', 'Doctor', 'Bachelor’s Degree', 'Pritah Aine', 47, '+256709269304', 'pritah.453@gmail.com', 'Farmer', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(353, 353, 'Peter Akello', 60, '+256705090866', 'peter.akello81@gmail.com', 'Engineer', 'Secondary', 'Winnie Lwanga', 39, '+256787221603', 'winnie.875@gmail.com', 'Entrepreneur', 'Diploma', 'Robert Akello', 'Father', 71, '+256773447162', 'robert.17@yahoo.com', 'Mechanic', 'Secondary', '150 Market Lane, Mbarara, Mbarara', 'Football team'),
(354, 354, 'Brian Mukasa', 41, '+256704771304', 'brian.mukasa30@gmail.com', 'Driver', 'Bachelor’s Degree', 'Alice Namukasa', 54, '+256756654964', 'alice.118@gmail.com', 'Farmer', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(355, 355, 'Paul Kyomuhendo', 40, '+256702838128', 'paul.kyomuhendo17@gmail.com', 'Civil Servant', 'Master’s Degree', 'Esther Akello', 39, '+256759447519', 'esther.627@gmail.com', 'Civil Servant', 'Bachelor’s Degree', 'Lillian Kyomuhendo', 'Aunt', 49, '+256708879825', 'lillian.25@yahoo.com', 'Doctor', 'Secondary', '317 Market Lane, Arua, Arua', 'Active in debate club'),
(356, 356, 'Andrew Mukasa', 59, '+256784371071', 'andrew.mukasa36@gmail.com', 'Driver', 'Diploma', 'Mercy Nakato', 47, '+256774214015', 'mercy.320@gmail.com', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(357, 357, 'Peter Kyomuhendo', 40, '+256785367790', 'peter.kyomuhendo73@gmail.com', 'Teacher', 'Diploma', 'Winnie Opio', 38, '+256777972839', 'winnie.518@gmail.com', 'Housewife', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(358, 358, 'Samuel Nalubega', 33, '+256754775408', 'samuel.nalubega26@gmail.com', 'Shopkeeper', 'Master’s Degree', 'Brenda Ochieng', 30, '+256752536965', 'brenda.713@gmail.com', 'Farmer', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(359, 359, 'Moses Ssemwogerere', 41, '+256774651492', 'moses.ssemwogerere49@gmail.com', 'Mechanic', 'Bachelor’s Degree', 'Sarah Mukasa', 47, '+256772435537', 'sarah.598@gmail.com', 'Housewife', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(360, 360, 'Solomon Mugabe', 36, '+256773135054', 'solomon.mugabe96@gmail.com', 'Mechanic', 'Primary', 'Winnie Nalubega', 53, '+256775951641', 'winnie.266@gmail.com', 'Trader', 'Primary', 'Charles Mugabe', 'Uncle', 33, '+256778497783', 'charles.97@yahoo.com', 'Driver', 'Master’s Degree', '81 Market Lane, Soroti, Soroti', 'Prefect'),
(361, 361, 'Mark Nakato', 31, '+256757434590', 'mark.nakato62@gmail.com', 'Doctor', 'Secondary', 'Joy Nantogo', 35, '+256777726461', 'joy.486@gmail.com', 'Tailor', 'Master’s Degree', 'Susan Nakato', 'Uncle', 42, '+256772587328', 'susan.58@yahoo.com', 'Engineer', 'Master’s Degree', '158 Main Street, Gulu, Gulu', 'Science fair participant'),
(362, 362, 'Mark Busingye', 66, '+256755129198', 'mark.busingye45@gmail.com', 'Doctor', 'Diploma', 'Pritah Kyomuhendo', 55, '+256787265048', 'pritah.567@gmail.com', 'Nurse', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(363, 363, 'Isaac Musoke', 50, '+256758514326', 'isaac.musoke0@gmail.com', 'Shopkeeper', 'Secondary', 'Alice Akello', 41, '+256751073557', 'alice.477@gmail.com', 'Tailor', 'Master’s Degree', 'James Musoke', 'Aunt', 42, '+256753633091', 'james.48@yahoo.com', 'Mechanic', 'Bachelor’s Degree', '313 Market Lane, Soroti, Soroti', 'Football team'),
(364, 364, 'Samuel Nantogo', 42, '+256751178815', 'samuel.nantogo46@gmail.com', 'Farmer', 'Bachelor’s Degree', 'Brenda Lwanga', 51, '+256782600352', 'brenda.35@gmail.com', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(365, 365, 'Peter Aine', 43, '+256774238309', 'peter.aine8@gmail.com', 'Driver', 'Secondary', 'Brenda Nakato', 40, '+256705664792', 'brenda.379@gmail.com', 'Trader', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(366, 366, 'Samuel Namukasa', 50, '+256708766428', 'samuel.namukasa81@gmail.com', 'Teacher', 'Bachelor’s Degree', 'Doreen Namukasa', 57, '+256781810795', 'doreen.610@gmail.com', 'Nurse', 'Primary', 'Hellen Namukasa', 'Father', 30, '+256705467222', 'hellen.11@yahoo.com', 'Farmer', 'Bachelor’s Degree', '495 School Road, Kampala, Kampala', 'Prefect'),
(367, 367, 'Solomon Lwanga', 67, '+256754881301', 'solomon.lwanga63@gmail.com', 'Civil Servant', 'Bachelor’s Degree', 'Rebecca Ochieng', 39, '+256779800612', 'rebecca.648@gmail.com', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(368, 368, 'Mark Opio', 60, '+256709635899', 'mark.opio32@gmail.com', 'Carpenter', 'Master’s Degree', 'Ritah Ochieng', 36, '+256755929027', 'ritah.975@gmail.com', 'Teacher', 'Bachelor’s Degree', 'Susan Opio', 'Father', 55, '+256705644685', 'susan.50@yahoo.com', 'Civil Servant', 'Bachelor’s Degree', '76 Central Avenue, Soroti, Soroti', 'Science fair participant'),
(369, 369, 'Isaac Aine', 49, '+256789350343', 'isaac.aine84@gmail.com', 'Carpenter', 'Bachelor’s Degree', 'Sarah Ochieng', 33, '+256784495315', 'sarah.64@gmail.com', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(370, 370, 'Brian Kyomuhendo', 66, '+256708807048', 'brian.kyomuhendo29@gmail.com', 'Shopkeeper', 'Diploma', 'Joy Nakato', 48, '+256708560386', 'joy.815@gmail.com', 'Teacher', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(371, 371, 'Isaac Kyomuhendo', 30, '+256705399110', 'isaac.kyomuhendo9@gmail.com', 'Civil Servant', 'Master’s Degree', 'Alice Aine', 31, '+256782464543', 'alice.318@gmail.com', 'Trader', 'Diploma', 'Rose Kyomuhendo', 'Father', 70, '+256784257371', 'rose.82@yahoo.com', 'Mechanic', 'Secondary', '318 Main Street, Mbale, Mbale', 'Football team'),
(372, 372, 'Daniel Nalubega', 36, '+256758098965', 'daniel.nalubega69@gmail.com', 'Civil Servant', 'Master’s Degree', 'Mercy Ochieng', 56, '+256707705071', 'mercy.402@gmail.com', 'Civil Servant', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(373, 373, 'Brian Mukasa', 69, '+256785682183', 'brian.mukasa89@gmail.com', 'Farmer', 'Master’s Degree', 'Esther Tumusiime', 32, '+256753724416', 'esther.606@gmail.com', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(374, 374, 'Mark Byaruhanga', 33, '+256776563356', 'mark.byaruhanga97@gmail.com', 'Driver', 'Primary', 'Esther Kyomuhendo', 54, '+256755270357', 'esther.225@gmail.com', 'Housewife', 'Primary', 'Florence Byaruhanga', 'Other', 27, '+256751356659', 'florence.38@yahoo.com', 'Civil Servant', 'Diploma', '390 School Road, Masaka, Masaka', 'Prefect'),
(375, 375, 'Andrew Busingye', 47, '+256777984989', 'andrew.busingye54@gmail.com', 'Driver', 'Diploma', 'Sandra Okello', 39, '+256776917455', 'sandra.655@gmail.com', 'Trader', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(376, 376, 'Isaac Ssemwogerere', 40, '+256771572859', 'isaac.ssemwogerere88@gmail.com', 'Shopkeeper', 'Diploma', 'Grace Aine', 60, '+256784382122', 'grace.203@gmail.com', 'Housewife', 'Diploma', 'James Ssemwogerere', 'Aunt', 39, '+256789959885', 'james.50@yahoo.com', 'Shopkeeper', 'Secondary', '175 Market Lane, Fort Portal, Fort Portal', 'Science fair participant'),
(377, 377, 'Isaac Nantogo', 66, '+256782290204', 'isaac.nantogo46@gmail.com', 'Teacher', 'Master’s Degree', 'Rebecca Mugabe', 56, '+256705995550', 'rebecca.886@gmail.com', 'Farmer', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(378, 378, 'Timothy Nalubega', 65, '+256785743327', 'timothy.nalubega68@gmail.com', 'Engineer', 'Primary', 'Brenda Busingye', 42, '+256774848767', 'brenda.734@gmail.com', 'Housewife', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(379, 379, 'Timothy Nantogo', 62, '+256773576866', 'timothy.nantogo13@gmail.com', 'Shopkeeper', 'Master’s Degree', 'Sarah Kato', 37, '+256782156958', 'sarah.129@gmail.com', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(380, 380, 'Timothy Tumusiime', 52, '+256779257234', 'timothy.tumusiime85@gmail.com', 'Farmer', 'Secondary', 'Doreen Ssemwogerere', 55, '+256787075672', 'doreen.954@gmail.com', 'Entrepreneur', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(381, 381, 'Timothy Kato', 60, '+256701450768', 'timothy.kato37@gmail.com', 'Civil Servant', 'Primary', 'Mercy Busingye', 62, '+256754499470', 'mercy.818@gmail.com', 'Farmer', 'Primary', 'Alice Kato', 'Grandparent', 76, '+256778838457', 'alice.26@yahoo.com', 'Engineer', 'Secondary', '306 Hospital View, Arua, Arua', 'Prefect'),
(382, 382, 'Isaac Byaruhanga', 53, '+256783596011', 'isaac.byaruhanga8@gmail.com', 'Shopkeeper', 'Diploma', 'Sandra Okello', 33, '+256777713531', 'sandra.674@gmail.com', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(383, 383, 'Moses Ochieng', 57, '+256776354057', 'moses.ochieng88@gmail.com', 'Civil Servant', 'Bachelor’s Degree', 'Grace Opio', 50, '+256783099855', 'grace.660@gmail.com', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(384, 384, 'David Kyomuhendo', 68, '+256787681681', 'david.kyomuhendo23@gmail.com', 'Farmer', 'Bachelor’s Degree', 'Joy Byaruhanga', 49, '+256774814503', 'joy.968@gmail.com', 'Entrepreneur', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(385, 385, 'Paul Kato', 60, '+256782674486', 'paul.kato26@gmail.com', 'Teacher', 'Master’s Degree', 'Sandra Aine', 35, '+256788309821', 'sandra.127@gmail.com', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(386, 386, 'Brian Musoke', 58, '+256788708320', 'brian.musoke45@gmail.com', 'Farmer', 'Master’s Degree', 'Ritah Musoke', 58, '+256757273121', 'ritah.380@gmail.com', 'Entrepreneur', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(387, 387, 'Peter Nalubega', 39, '+256701870870', 'peter.nalubega30@gmail.com', 'Doctor', 'Diploma', 'Mary Nantogo', 64, '+256755730854', 'mary.710@gmail.com', 'Housewife', 'Master’s Degree', 'Alice Nalubega', 'Other', 63, '+256703207743', 'alice.73@yahoo.com', 'Shopkeeper', 'Bachelor’s Degree', '356 Main Street, Mbarara, Mbarara', 'Science fair participant'),
(388, 388, 'David Tumusiime', 64, '+256757632418', 'david.tumusiime80@gmail.com', 'Carpenter', 'Master’s Degree', 'Joan Busingye', 40, '+256771802174', 'joan.719@gmail.com', 'Tailor', 'Diploma', 'Hellen Tumusiime', 'Uncle', 53, '+256756817774', 'hellen.27@yahoo.com', 'Farmer', 'Primary', '432 Church Road, Jinja, Jinja', 'Prefect'),
(389, 389, 'Peter Byaruhanga', 36, '+256773680538', 'peter.byaruhanga80@gmail.com', 'Engineer', 'Diploma', 'Ritah Okello', 63, '+256788995334', 'ritah.925@gmail.com', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(390, 390, 'Samuel Kyomuhendo', 67, '+256756576869', 'samuel.kyomuhendo15@gmail.com', 'Farmer', 'Primary', 'Alice Kato', 59, '+256759589747', 'alice.940@gmail.com', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(391, 391, 'Andrew Waiswa', 55, '+256751465317', 'andrew.waiswa55@gmail.com', 'Driver', 'Diploma', 'Doreen Musoke', 62, '+256705951158', 'doreen.917@gmail.com', 'Entrepreneur', 'Master’s Degree', 'Patrick Waiswa', 'Mother', 69, '+256777852877', 'patrick.50@yahoo.com', 'Doctor', 'Master’s Degree', '144 School Road, Fort Portal, Fort Portal', 'Science fair participant'),
(392, 392, 'Andrew Musoke', 61, '+256773411720', 'andrew.musoke31@gmail.com', 'Mechanic', 'Diploma', 'Doreen Byaruhanga', 40, '+256752825183', 'doreen.191@gmail.com', 'Farmer', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(393, 393, 'Moses Busingye', 66, '+256779630110', 'moses.busingye55@gmail.com', 'Carpenter', 'Bachelor’s Degree', 'Doreen Lwanga', 57, '+256706862228', 'doreen.949@gmail.com', 'Farmer', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(394, 394, 'Daniel Mugabe', 43, '+256754897412', 'daniel.mugabe12@gmail.com', 'Engineer', 'Bachelor’s Degree', 'Joy Akello', 36, '+256771751997', 'joy.94@gmail.com', 'Housewife', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(395, 395, 'Timothy Akello', 46, '+256787443264', 'timothy.akello11@gmail.com', 'Civil Servant', 'Diploma', 'Esther Okello', 43, '+256755957490', 'esther.11@gmail.com', 'Entrepreneur', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(396, 396, 'Joseph Tumusiime', 51, '+256703858722', 'joseph.tumusiime9@gmail.com', 'Engineer', 'Diploma', 'Pritah Waiswa', 30, '+256759976217', 'pritah.412@gmail.com', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(397, 397, 'Moses Kyomuhendo', 39, '+256751799712', 'moses.kyomuhendo29@gmail.com', 'Doctor', 'Bachelor’s Degree', 'Mercy Kato', 34, '+256772106930', 'mercy.907@gmail.com', 'Farmer', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(398, 398, 'Brian Kyomuhendo', 60, '+256787992844', 'brian.kyomuhendo61@gmail.com', 'Mechanic', 'Diploma', 'Winnie Mukasa', 53, '+256702094243', 'winnie.209@gmail.com', 'Housewife', 'Master’s Degree', 'Hellen Kyomuhendo', 'Aunt', 55, '+256786363561', 'hellen.47@yahoo.com', 'Mechanic', 'Secondary', '204 Central Avenue, Lira, Lira', 'Active in debate club'),
(399, 399, 'Paul Aine', 60, '+256701818148', 'paul.aine60@gmail.com', 'Teacher', 'Master’s Degree', 'Esther Namukasa', 62, '+256774353189', 'esther.809@gmail.com', 'Farmer', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(400, 400, 'Andrew Tumusiime', 63, '+256706778927', 'andrew.tumusiime34@gmail.com', 'Farmer', 'Primary', 'Sarah Musoke', 62, '+256776941341', 'sarah.980@gmail.com', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(401, 401, 'Peter Kyomuhendo', 48, '+256752023246', 'peter.kyomuhendo75@gmail.com', 'Teacher', 'Bachelor’s Degree', 'Esther Waiswa', 35, '+256708709273', 'esther.355@gmail.com', 'Entrepreneur', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(402, 402, 'Joseph Musoke', 52, '+256779529521', 'joseph.musoke67@gmail.com', 'Carpenter', 'Secondary', 'Doreen Byaruhanga', 51, '+256705190022', 'doreen.3@gmail.com', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(403, 403, 'Isaac Mugabe', 34, '+256775923915', 'isaac.mugabe54@gmail.com', 'Carpenter', 'Primary', 'Joan Akello', 31, '+256757086955', 'joan.422@gmail.com', 'Farmer', 'Diploma', 'Lillian Mugabe', 'Aunt', 75, '+256703415024', 'lillian.8@yahoo.com', 'Civil Servant', 'Bachelor’s Degree', '183 Main Street, Kampala, Kampala', 'Choir member'),
(404, 404, 'David Ochieng', 31, '+256751458077', 'david.ochieng23@gmail.com', 'Driver', 'Secondary', 'Doreen Tumusiime', 35, '+256751843845', 'doreen.695@gmail.com', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(405, 405, 'Andrew Busingye', 50, '+256755524725', 'andrew.busingye59@gmail.com', 'Civil Servant', 'Secondary', 'Winnie Akello', 53, '+256788655171', 'winnie.646@gmail.com', 'Tailor', 'Secondary', 'Florence Busingye', 'Aunt', 47, '+256789576574', 'florence.48@yahoo.com', 'Engineer', 'Diploma', '312 Hospital View, Mbale, Mbale', 'Prefect'),
(406, 406, 'Paul Okello', 39, '+256776358615', 'paul.okello39@gmail.com', 'Mechanic', 'Master’s Degree', 'Sarah Opio', 64, '+256789316171', 'sarah.350@gmail.com', 'Housewife', 'Secondary', 'Patrick Okello', 'Mother', 65, '+256778296155', 'patrick.71@yahoo.com', 'Farmer', 'Bachelor’s Degree', '425 Hospital View, Jinja, Jinja', 'Choir member'),
(407, 407, 'Mark Nantogo', 40, '+256757904234', 'mark.nantogo90@gmail.com', 'Driver', 'Master’s Degree', 'Alice Nantogo', 62, '+256708122069', 'alice.61@gmail.com', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(408, 408, 'Peter Nantogo', 60, '+256753989749', 'peter.nantogo74@gmail.com', 'Shopkeeper', 'Bachelor’s Degree', 'Ritah Busingye', 56, '+256785335973', 'ritah.642@gmail.com', 'Entrepreneur', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(409, 409, 'Brian Mugabe', 69, '+256706098688', 'brian.mugabe92@gmail.com', 'Farmer', 'Master’s Degree', 'Doreen Byaruhanga', 40, '+256751791651', 'doreen.717@gmail.com', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(410, 410, 'John Aine', 37, '+256782781445', 'john.aine35@gmail.com', 'Carpenter', 'Diploma', 'Joan Mugabe', 46, '+256708261893', 'joan.983@gmail.com', 'Trader', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(411, 411, 'Mark Akello', 31, '+256751698610', 'mark.akello84@gmail.com', 'Shopkeeper', 'Primary', 'Esther Ssemwogerere', 39, '+256759609428', 'esther.835@gmail.com', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(412, 412, 'John Mukasa', 56, '+256781366599', 'john.mukasa74@gmail.com', 'Teacher', 'Primary', 'Joan Kato', 51, '+256755662574', 'joan.438@gmail.com', 'Entrepreneur', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(413, 413, 'Daniel Nalubega', 51, '+256777396539', 'daniel.nalubega13@gmail.com', 'Doctor', 'Master’s Degree', 'Grace Nalubega', 52, '+256756389205', 'grace.293@gmail.com', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(414, 414, 'Andrew Lwanga', 48, '+256786360421', 'andrew.lwanga44@gmail.com', 'Mechanic', 'Secondary', 'Pritah Tumusiime', 35, '+256782787537', 'pritah.558@gmail.com', 'Teacher', 'Primary', 'Hellen Lwanga', 'Grandparent', 67, '+256709768591', 'hellen.91@yahoo.com', 'Civil Servant', 'Diploma', '194 Hospital View, Gulu, Gulu', 'Science fair participant'),
(415, 415, 'Timothy Kato', 47, '+256752705348', 'timothy.kato79@gmail.com', 'Carpenter', 'Bachelor’s Degree', 'Sarah Musoke', 34, '+256771327310', 'sarah.655@gmail.com', 'Entrepreneur', 'Master’s Degree', 'Robert Kato', 'Father', 62, '+256755922854', 'robert.53@yahoo.com', 'Farmer', 'Primary', '201 Central Avenue, Masaka, Masaka', 'Football team'),
(416, 416, 'Mark Okello', 55, '+256781920562', 'mark.okello77@gmail.com', 'Civil Servant', 'Master’s Degree', 'Ritah Kato', 29, '+256701218694', 'ritah.823@gmail.com', 'Housewife', 'Bachelor’s Degree', 'Susan Okello', 'Aunt', 39, '+256777973061', 'susan.75@yahoo.com', 'Carpenter', 'Primary', '394 Market Lane, Kampala, Kampala', 'Prefect'),
(417, 417, 'Peter Byaruhanga', 48, '+256778126711', 'peter.byaruhanga56@gmail.com', 'Shopkeeper', 'Diploma', 'Alice Busingye', 44, '+256787526321', 'alice.723@gmail.com', 'Nurse', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(418, 418, 'Joseph Tumusiime', 36, '+256774964798', 'joseph.tumusiime88@gmail.com', 'Teacher', 'Primary', 'Rebecca Waiswa', 53, '+256779429173', 'rebecca.302@gmail.com', 'Trader', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(419, 419, 'Samuel Ssemwogerere', 48, '+256776904568', 'samuel.ssemwogerere8@gmail.com', 'Teacher', 'Master’s Degree', 'Sarah Mukasa', 57, '+256784939663', 'sarah.420@gmail.com', 'Civil Servant', 'Primary', 'Rose Ssemwogerere', 'Mother', 73, '+256784432258', 'rose.47@yahoo.com', 'Shopkeeper', 'Secondary', '341 Central Avenue, Lira, Lira', 'Science fair participant'),
(420, 420, 'Paul Nantogo', 39, '+256755931224', 'paul.nantogo96@gmail.com', 'Doctor', 'Diploma', 'Grace Kato', 59, '+256759509273', 'grace.937@gmail.com', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(421, 421, 'Solomon Aine', 68, '+256703145281', 'solomon.aine33@gmail.com', 'Carpenter', 'Primary', 'Esther Mugabe', 58, '+256751422661', 'esther.392@gmail.com', 'Entrepreneur', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(422, 422, 'David Mukasa', 41, '+256754387744', 'david.mukasa28@gmail.com', 'Shopkeeper', 'Primary', 'Alice Busingye', 50, '+256775764484', 'alice.237@gmail.com', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(423, 423, 'Paul Akello', 59, '+256786945783', 'paul.akello33@gmail.com', 'Shopkeeper', 'Master’s Degree', 'Mercy Nalubega', 44, '+256704528820', 'mercy.924@gmail.com', 'Tailor', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(424, 424, 'Timothy Nakato', 63, '+256788426406', 'timothy.nakato65@gmail.com', 'Farmer', 'Secondary', 'Grace Waiswa', 63, '+256787577475', 'grace.30@gmail.com', 'Civil Servant', 'Bachelor’s Degree', 'Charles Nakato', 'Aunt', 26, '+256753370116', 'charles.8@yahoo.com', 'Farmer', 'Bachelor’s Degree', '393 Main Street, Lira, Lira', 'Active in debate club'),
(425, 425, 'Isaac Mukasa', 55, '+256709021582', 'isaac.mukasa45@gmail.com', 'Carpenter', 'Primary', 'Alice Kato', 32, '+256751621194', 'alice.463@gmail.com', 'Farmer', 'Diploma', 'Patrick Mukasa', 'Uncle', 40, '+256784732071', 'patrick.51@yahoo.com', 'Doctor', 'Bachelor’s Degree', '371 Main Street, Jinja, Jinja', 'Choir member'),
(426, 426, 'Andrew Ssemwogerere', 42, '+256701156845', 'andrew.ssemwogerere7@gmail.com', 'Engineer', 'Bachelor’s Degree', 'Brenda Namukasa', 46, '+256707307536', 'brenda.721@gmail.com', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(427, 427, 'Moses Waiswa', 37, '+256783725820', 'moses.waiswa21@gmail.com', 'Doctor', 'Bachelor’s Degree', 'Mercy Akello', 49, '+256782952382', 'mercy.244@gmail.com', 'Farmer', 'Master’s Degree', 'Patrick Waiswa', 'Mother', 60, '+256755503901', 'patrick.54@yahoo.com', 'Driver', 'Diploma', '89 Market Lane, Masaka, Masaka', 'Football team'),
(428, 428, 'Andrew Okello', 33, '+256759497552', 'andrew.okello57@gmail.com', 'Shopkeeper', 'Master’s Degree', 'Mary Akello', 61, '+256759651930', 'mary.754@gmail.com', 'Farmer', 'Secondary', 'Susan Okello', 'Father', 30, '+256786103056', 'susan.56@yahoo.com', 'Mechanic', 'Bachelor’s Degree', '80 Hospital View, Mbale, Mbale', 'Prefect'),
(429, 429, 'Isaac Aine', 59, '+256759580109', 'isaac.aine11@gmail.com', 'Engineer', 'Diploma', 'Mercy Opio', 51, '+256704537441', 'mercy.164@gmail.com', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(430, 430, 'Brian Opio', 59, '+256705462098', 'brian.opio4@gmail.com', 'Driver', 'Secondary', 'Pritah Mugabe', 30, '+256781019252', 'pritah.615@gmail.com', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(431, 431, 'Samuel Ochieng', 62, '+256758126946', 'samuel.ochieng43@gmail.com', 'Civil Servant', 'Secondary', 'Esther Tumusiime', 29, '+256789534132', 'esther.377@gmail.com', 'Nurse', 'Secondary', 'Robert Ochieng', 'Aunt', 70, '+256779847327', 'robert.88@yahoo.com', 'Civil Servant', 'Master’s Degree', '428 Market Lane, Masaka, Masaka', 'Prefect'),
(432, 432, 'Paul Aine', 51, '+256779335492', 'paul.aine46@gmail.com', 'Engineer', 'Primary', 'Esther Aine', 49, '+256703250068', 'esther.466@gmail.com', 'Trader', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(433, 433, 'Brian Opio', 44, '+256752875202', 'brian.opio19@gmail.com', 'Doctor', 'Secondary', 'Pritah Ssemwogerere', 57, '+256787032260', 'pritah.363@gmail.com', 'Entrepreneur', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(434, 434, 'Joseph Namukasa', 44, '+256775093593', 'joseph.namukasa93@gmail.com', 'Mechanic', 'Master’s Degree', 'Joan Kyomuhendo', 41, '+256754708898', 'joan.919@gmail.com', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(435, 435, 'Daniel Waiswa', 62, '+256772706633', 'daniel.waiswa27@gmail.com', 'Farmer', 'Bachelor’s Degree', 'Mercy Akello', 37, '+256781784141', 'mercy.700@gmail.com', 'Nurse', 'Master’s Degree', 'Hellen Waiswa', 'Other', 30, '+256752240786', 'hellen.5@yahoo.com', 'Mechanic', 'Secondary', '338 Hospital View, Jinja, Jinja', 'Science fair participant'),
(436, 436, 'David Busingye', 60, '+256779495261', 'david.busingye51@gmail.com', 'Doctor', 'Master’s Degree', 'Alice Ochieng', 53, '+256786614925', 'alice.709@gmail.com', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(437, 437, 'David Akello', 53, '+256779652919', 'david.akello9@gmail.com', 'Shopkeeper', 'Diploma', 'Doreen Ssemwogerere', 28, '+256782461028', 'doreen.98@gmail.com', 'Civil Servant', 'Bachelor’s Degree', 'James Akello', 'Grandparent', 72, '+256755068666', 'james.2@yahoo.com', 'Mechanic', 'Primary', '499 Church Road, Jinja, Jinja', 'Science fair participant'),
(438, 438, 'Ivan Kato', 67, '+256707487282', 'ivan.kato21@gmail.com', 'Teacher', 'Diploma', 'Mary Nakato', 37, '+256776013141', 'mary.782@gmail.com', 'Entrepreneur', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(439, 439, 'Timothy Ochieng', 58, '+256707828263', 'timothy.ochieng58@gmail.com', 'Civil Servant', 'Diploma', 'Esther Nalubega', 33, '+256781369627', 'esther.655@gmail.com', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(440, 440, 'David Byaruhanga', 68, '+256787912744', 'david.byaruhanga44@gmail.com', 'Driver', 'Secondary', 'Joan Akello', 50, '+256707147522', 'joan.129@gmail.com', 'Trader', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(441, 441, 'Peter Okello', 40, '+256704811929', 'peter.okello69@gmail.com', 'Farmer', 'Primary', 'Rebecca Busingye', 50, '+256706835784', 'rebecca.112@gmail.com', 'Housewife', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(442, 442, 'Joseph Kyomuhendo', 53, '+256709104911', 'joseph.kyomuhendo25@gmail.com', 'Farmer', 'Master’s Degree', 'Pritah Busingye', 57, '+256754014078', 'pritah.561@gmail.com', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(443, 443, 'Moses Musoke', 48, '+256759473507', 'moses.musoke65@gmail.com', 'Engineer', 'Secondary', 'Alice Tumusiime', 38, '+256701969253', 'alice.320@gmail.com', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(444, 444, 'Moses Kyomuhendo', 52, '+256707701872', 'moses.kyomuhendo94@gmail.com', 'Mechanic', 'Master’s Degree', 'Sarah Ochieng', 37, '+256771685756', 'sarah.96@gmail.com', 'Entrepreneur', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(445, 445, 'David Tumusiime', 51, '+256758670529', 'david.tumusiime41@gmail.com', 'Engineer', 'Secondary', 'Joan Musoke', 51, '+256777770593', 'joan.378@gmail.com', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(446, 446, 'John Mugabe', 49, '+256707434008', 'john.mugabe51@gmail.com', 'Carpenter', 'Bachelor’s Degree', 'Mary Akello', 28, '+256751309688', 'mary.25@gmail.com', 'Nurse', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(447, 447, 'Ivan Namukasa', 52, '+256705326051', 'ivan.namukasa19@gmail.com', 'Farmer', 'Primary', 'Joan Lwanga', 51, '+256709126367', 'joan.667@gmail.com', 'Farmer', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(448, 448, 'David Kyomuhendo', 69, '+256783384536', 'david.kyomuhendo55@gmail.com', 'Doctor', 'Diploma', 'Mary Namukasa', 63, '+256773911460', 'mary.982@gmail.com', 'Housewife', 'Primary', 'Rose Kyomuhendo', 'Uncle', 56, '+256772893050', 'rose.61@yahoo.com', 'Engineer', 'Primary', '438 Main Street, Soroti, Soroti', 'Science fair participant'),
(449, 449, 'Brian Nakato', 53, '+256751744997', 'brian.nakato56@gmail.com', 'Farmer', 'Secondary', 'Mary Mukasa', 37, '+256706697556', 'mary.30@gmail.com', 'Farmer', 'Primary', 'Robert Nakato', 'Mother', 58, '+256705024496', 'robert.32@yahoo.com', 'Teacher', 'Bachelor’s Degree', '260 Central Avenue, Kampala, Kampala', 'Active in debate club'),
(450, 450, 'Isaac Akello', 60, '+256784111300', 'isaac.akello35@gmail.com', 'Civil Servant', 'Primary', 'Brenda Waiswa', 60, '+256758451826', 'brenda.74@gmail.com', 'Farmer', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(451, 451, 'Moses Waiswa', 45, '+256781787969', 'moses.waiswa72@gmail.com', 'Civil Servant', 'Diploma', 'Mercy Ochieng', 50, '+256752924544', 'mercy.448@gmail.com', 'Civil Servant', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(452, 452, 'Moses Nalubega', 33, '+256702164881', 'moses.nalubega68@gmail.com', 'Doctor', 'Secondary', 'Winnie Ssemwogerere', 53, '+256788820947', 'winnie.856@gmail.com', 'Housewife', 'Primary', 'Rose Nalubega', 'Father', 36, '+256784013006', 'rose.82@yahoo.com', 'Shopkeeper', 'Diploma', '288 Church Road, Soroti, Soroti', 'Football team'),
(453, 453, 'David Aine', 48, '+256756925080', 'david.aine48@gmail.com', 'Carpenter', 'Master’s Degree', 'Ritah Mugabe', 58, '+256771883414', 'ritah.422@gmail.com', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(454, 454, 'Isaac Lwanga', 63, '+256705200935', 'isaac.lwanga4@gmail.com', 'Teacher', 'Diploma', 'Alice Lwanga', 59, '+256776446877', 'alice.932@gmail.com', 'Tailor', 'Bachelor’s Degree', 'Patrick Lwanga', 'Grandparent', 48, '+256707082761', 'patrick.56@yahoo.com', 'Shopkeeper', 'Master’s Degree', '261 Main Street, Lira, Lira', 'Prefect'),
(455, 455, 'Andrew Aine', 33, '+256787805194', 'andrew.aine7@gmail.com', 'Doctor', 'Primary', 'Joy Musoke', 30, '+256754621868', 'joy.52@gmail.com', 'Nurse', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(456, 456, 'Timothy Namukasa', 57, '+256788386055', 'timothy.namukasa62@gmail.com', 'Driver', 'Bachelor’s Degree', 'Joan Mugabe', 49, '+256706911330', 'joan.312@gmail.com', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(457, 457, 'Joseph Byaruhanga', 60, '+256754690742', 'joseph.byaruhanga98@gmail.com', 'Civil Servant', 'Bachelor’s Degree', 'Doreen Opio', 63, '+256777006201', 'doreen.991@gmail.com', 'Housewife', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(458, 458, 'Samuel Mugabe', 44, '+256705424062', 'samuel.mugabe16@gmail.com', 'Engineer', 'Bachelor’s Degree', 'Grace Waiswa', 40, '+256785765274', 'grace.184@gmail.com', 'Nurse', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(459, 459, 'John Akello', 63, '+256778665051', 'john.akello67@gmail.com', 'Farmer', 'Secondary', 'Mary Mugabe', 45, '+256705483724', 'mary.994@gmail.com', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(460, 460, 'Moses Aine', 49, '+256708960596', 'moses.aine2@gmail.com', 'Engineer', 'Diploma', 'Winnie Opio', 31, '+256777907963', 'winnie.479@gmail.com', 'Nurse', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(461, 461, 'John Aine', 31, '+256752485660', 'john.aine89@gmail.com', 'Driver', 'Diploma', 'Rebecca Kyomuhendo', 63, '+256755794980', 'rebecca.109@gmail.com', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(462, 462, 'Ivan Opio', 47, '+256771399917', 'ivan.opio90@gmail.com', 'Driver', 'Primary', 'Alice Byaruhanga', 56, '+256772477249', 'alice.254@gmail.com', 'Farmer', 'Secondary', 'Susan Opio', 'Father', 47, '+256706783318', 'susan.0@yahoo.com', 'Carpenter', 'Bachelor’s Degree', '115 Market Lane, Gulu, Gulu', 'Prefect'),
(463, 463, 'Brian Ochieng', 46, '+256781961691', 'brian.ochieng53@gmail.com', 'Engineer', 'Bachelor’s Degree', 'Sarah Opio', 63, '+256789778165', 'sarah.576@gmail.com', 'Nurse', 'Diploma', 'Alice Ochieng', 'Uncle', 33, '+256781767163', 'alice.73@yahoo.com', 'Doctor', 'Primary', '146 Central Avenue, Soroti, Soroti', 'Science fair participant'),
(464, 464, 'Isaac Mukasa', 64, '+256756727168', 'isaac.mukasa15@gmail.com', 'Carpenter', 'Bachelor’s Degree', 'Sandra Aine', 60, '+256784771931', 'sandra.428@gmail.com', 'Farmer', 'Primary', 'Charles Mukasa', 'Grandparent', 25, '+256752096636', 'charles.3@yahoo.com', 'Shopkeeper', 'Master’s Degree', '198 Main Street, Soroti, Soroti', 'Prefect'),
(465, 465, 'Moses Mukasa', 55, '+256783553959', 'moses.mukasa9@gmail.com', 'Carpenter', 'Secondary', 'Pritah Kyomuhendo', 38, '+256779400408', 'pritah.618@gmail.com', 'Trader', 'Primary', 'Alice Mukasa', 'Uncle', 61, '+256701449851', 'alice.91@yahoo.com', 'Carpenter', 'Primary', '493 Church Road, Mbarara, Mbarara', 'Prefect'),
(466, 466, 'Peter Mugabe', 63, '+256753511855', 'peter.mugabe53@gmail.com', 'Shopkeeper', 'Diploma', 'Rebecca Akello', 57, '+256753935971', 'rebecca.955@gmail.com', 'Farmer', 'Secondary', 'Robert Mugabe', 'Grandparent', 50, '+256784252523', 'robert.17@yahoo.com', 'Mechanic', 'Primary', '402 Central Avenue, Jinja, Jinja', 'Active in debate club'),
(467, 467, 'Solomon Kyomuhendo', 50, '+256758010157', 'solomon.kyomuhendo16@gmail.com', 'Teacher', 'Bachelor’s Degree', 'Winnie Kato', 42, '+256702757593', 'winnie.194@gmail.com', 'Teacher', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(468, 468, 'Moses Busingye', 44, '+256786690982', 'moses.busingye64@gmail.com', 'Carpenter', 'Primary', 'Esther Namukasa', 41, '+256771275339', 'esther.689@gmail.com', 'Civil Servant', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(469, 469, 'Joseph Kyomuhendo', 67, '+256774513759', 'joseph.kyomuhendo61@gmail.com', 'Carpenter', 'Secondary', 'Joy Mukasa', 42, '+256751445981', 'joy.309@gmail.com', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(470, 470, 'Peter Busingye', 44, '+256779036400', 'peter.busingye0@gmail.com', 'Civil Servant', 'Master’s Degree', 'Doreen Kato', 34, '+256789648348', 'doreen.809@gmail.com', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(471, 471, 'Solomon Opio', 58, '+256778591941', 'solomon.opio64@gmail.com', 'Shopkeeper', 'Master’s Degree', 'Joan Busingye', 40, '+256778930958', 'joan.797@gmail.com', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(472, 472, 'Andrew Ssemwogerere', 32, '+256708055526', 'andrew.ssemwogerere8@gmail.com', 'Farmer', 'Secondary', 'Joan Mukasa', 58, '+256773139193', 'joan.909@gmail.com', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(473, 473, 'Samuel Tumusiime', 47, '+256703480798', 'samuel.tumusiime24@gmail.com', 'Engineer', 'Bachelor’s Degree', 'Doreen Kato', 35, '+256778403764', 'doreen.532@gmail.com', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(474, 474, 'Daniel Mugabe', 53, '+256782141876', 'daniel.mugabe19@gmail.com', 'Engineer', 'Primary', 'Pritah Musoke', 48, '+256759163781', 'pritah.852@gmail.com', 'Farmer', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(475, 475, 'Samuel Nantogo', 45, '+256705469792', 'samuel.nantogo17@gmail.com', 'Engineer', 'Master’s Degree', 'Sandra Lwanga', 47, '+256706856281', 'sandra.496@gmail.com', 'Farmer', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(476, 476, 'Samuel Kyomuhendo', 68, '+256773484129', 'samuel.kyomuhendo35@gmail.com', 'Civil Servant', 'Bachelor’s Degree', 'Joy Mukasa', 37, '+256787187777', 'joy.64@gmail.com', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(477, 477, 'Joseph Kyomuhendo', 40, '+256779396097', 'joseph.kyomuhendo60@gmail.com', 'Engineer', 'Diploma', 'Rebecca Aine', 31, '+256789101647', 'rebecca.560@gmail.com', 'Housewife', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(478, 478, 'Timothy Byaruhanga', 39, '+256752991606', 'timothy.byaruhanga97@gmail.com', 'Doctor', 'Bachelor’s Degree', 'Ritah Busingye', 49, '+256785762202', 'ritah.833@gmail.com', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(479, 479, 'Solomon Ochieng', 61, '+256703297918', 'solomon.ochieng90@gmail.com', 'Doctor', 'Master’s Degree', 'Ritah Musoke', 53, '+256756331778', 'ritah.894@gmail.com', 'Housewife', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(480, 480, 'Mark Nalubega', 30, '+256787022669', 'mark.nalubega79@gmail.com', 'Shopkeeper', 'Primary', 'Joan Tumusiime', 34, '+256758021783', 'joan.303@gmail.com', 'Entrepreneur', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(481, 481, 'Moses Busingye', 42, '+256752222742', 'moses.busingye14@gmail.com', 'Farmer', 'Master’s Degree', 'Mary Nantogo', 42, '+256753071552', 'mary.417@gmail.com', 'Civil Servant', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(482, 482, 'Moses Ochieng', 42, '+256776026605', 'moses.ochieng19@gmail.com', 'Mechanic', 'Master’s Degree', 'Grace Ochieng', 46, '+256789454101', 'grace.65@gmail.com', 'Teacher', 'Secondary', 'Susan Ochieng', 'Aunt', 54, '+256774590599', 'susan.56@yahoo.com', 'Civil Servant', 'Primary', '26 Main Street, Arua, Arua', 'Science fair participant'),
(483, 483, 'John Kato', 63, '+256701926623', 'john.kato22@gmail.com', 'Driver', 'Primary', 'Alice Waiswa', 53, '+256788831478', 'alice.659@gmail.com', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(484, 484, 'John Waiswa', 45, '+256701892538', 'john.waiswa13@gmail.com', 'Driver', 'Diploma', 'Ritah Lwanga', 28, '+256789824990', 'ritah.189@gmail.com', 'Tailor', 'Secondary', 'James Waiswa', 'Father', 33, '+256757811677', 'james.6@yahoo.com', 'Shopkeeper', 'Diploma', '451 School Road, Fort Portal, Fort Portal', 'Prefect'),
(485, 485, 'Andrew Nakato', 44, '+256781129370', 'andrew.nakato27@gmail.com', 'Mechanic', 'Bachelor’s Degree', 'Alice Tumusiime', 38, '+256706676034', 'alice.234@gmail.com', 'Civil Servant', 'Bachelor’s Degree', 'Robert Nakato', 'Uncle', 62, '+256783595323', 'robert.85@yahoo.com', 'Teacher', 'Primary', '168 School Road, Gulu, Gulu', 'Choir member'),
(486, 486, 'Solomon Nalubega', 44, '+256701189837', 'solomon.nalubega87@gmail.com', 'Farmer', 'Bachelor’s Degree', 'Mercy Mugabe', 29, '+256754699107', 'mercy.52@gmail.com', 'Entrepreneur', 'Master’s Degree', 'Hellen Nalubega', 'Grandparent', 53, '+256782563159', 'hellen.5@yahoo.com', 'Engineer', 'Diploma', '423 Central Avenue, Jinja, Jinja', 'Science fair participant'),
(487, 487, 'Ivan Mukasa', 55, '+256757253217', 'ivan.mukasa54@gmail.com', 'Shopkeeper', 'Primary', 'Joan Byaruhanga', 40, '+256701265858', 'joan.83@gmail.com', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(488, 488, 'David Kyomuhendo', 40, '+256702542673', 'david.kyomuhendo94@gmail.com', 'Driver', 'Diploma', 'Brenda Namukasa', 48, '+256703171406', 'brenda.53@gmail.com', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(489, 489, 'David Waiswa', 42, '+256784479257', 'david.waiswa9@gmail.com', 'Doctor', 'Diploma', 'Mary Ochieng', 39, '+256701858529', 'mary.520@gmail.com', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(490, 490, 'Ivan Musoke', 56, '+256752888348', 'ivan.musoke85@gmail.com', 'Carpenter', 'Master’s Degree', 'Sarah Nakato', 63, '+256786860534', 'sarah.782@gmail.com', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(491, 491, 'Paul Ochieng', 41, '+256754753738', 'paul.ochieng89@gmail.com', 'Civil Servant', 'Diploma', 'Rebecca Akello', 41, '+256751876054', 'rebecca.928@gmail.com', 'Entrepreneur', 'Master’s Degree', 'Alice Ochieng', 'Uncle', 52, '+256786773422', 'alice.27@yahoo.com', 'Farmer', 'Primary', '454 Market Lane, Kampala, Kampala', 'Prefect'),
(492, 492, 'Isaac Aine', 39, '+256785981506', 'isaac.aine17@gmail.com', 'Shopkeeper', 'Diploma', 'Winnie Namukasa', 51, '+256775002239', 'winnie.193@gmail.com', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(493, 493, 'Ivan Aine', 66, '+256707835973', 'ivan.aine43@gmail.com', 'Doctor', 'Diploma', 'Mary Kyomuhendo', 35, '+256781257822', 'mary.657@gmail.com', 'Nurse', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(494, 494, 'John Ssemwogerere', 62, '+256777780482', 'john.ssemwogerere21@gmail.com', 'Driver', 'Bachelor’s Degree', 'Ritah Lwanga', 45, '+256785258804', 'ritah.979@gmail.com', 'Tailor', 'Master’s Degree', 'Alice Ssemwogerere', 'Grandparent', 65, '+256759485807', 'alice.71@yahoo.com', 'Engineer', 'Bachelor’s Degree', '374 Central Avenue, Jinja, Jinja', 'Science fair participant'),
(495, 495, 'David Nantogo', 65, '+256708610042', 'david.nantogo87@gmail.com', 'Carpenter', 'Diploma', 'Brenda Akello', 43, '+256772471983', 'brenda.381@gmail.com', 'Entrepreneur', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(496, 496, 'Brian Akello', 58, '+256773005246', 'brian.akello7@gmail.com', 'Engineer', 'Bachelor’s Degree', 'Pritah Nalubega', 31, '+256779489689', 'pritah.986@gmail.com', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(497, 497, 'Paul Akello', 60, '+256785690627', 'paul.akello65@gmail.com', 'Carpenter', 'Bachelor’s Degree', 'Sarah Kyomuhendo', 29, '+256752688616', 'sarah.919@gmail.com', 'Tailor', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(498, 498, 'Daniel Namukasa', 55, '+256771723262', 'daniel.namukasa37@gmail.com', 'Teacher', 'Bachelor’s Degree', 'Doreen Nantogo', 45, '+256786534390', 'doreen.460@gmail.com', 'Entrepreneur', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(499, 499, 'Samuel Namukasa', 43, '+256703506282', 'samuel.namukasa23@gmail.com', 'Mechanic', 'Master’s Degree', 'Rebecca Byaruhanga', 52, '+256709491617', 'rebecca.696@gmail.com', 'Farmer', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(500, 500, 'David Ochieng', 45, '+256709724321', 'david.ochieng45@gmail.com', 'Driver', 'Diploma', 'Alice Nakato', 46, '+256757209383', 'alice.512@gmail.com', 'Entrepreneur', 'Primary', 'Florence Ochieng', 'Other', 64, '+256789678599', 'florence.95@yahoo.com', 'Carpenter', 'Master’s Degree', '15 Main Street, Kampala, Kampala', 'Science fair participant'),
(501, 501, 'Brian Nakato', 56, '+256706869270', 'brian.nakato31@gmail.com', 'Doctor', 'Bachelor’s Degree', 'Sarah Ssemwogerere', 33, '+256753448368', 'sarah.793@gmail.com', 'Tailor', 'Diploma', 'Robert Nakato', 'Other', 29, '+256706291231', 'robert.94@yahoo.com', 'Engineer', 'Master’s Degree', '370 Hospital View, Masaka, Masaka', 'Prefect'),
(502, 502, 'David Byaruhanga', 54, '+256758865833', 'david.byaruhanga44@gmail.com', 'Civil Servant', 'Master’s Degree', 'Ritah Byaruhanga', 32, '+256786860393', 'ritah.613@gmail.com', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(503, 503, 'Timothy Nakato', 30, '+256752008872', 'timothy.nakato46@gmail.com', 'Shopkeeper', 'Primary', 'Joan Kato', 61, '+256783991503', 'joan.981@gmail.com', 'Civil Servant', 'Diploma', 'Rose Nakato', 'Grandparent', 61, '+256709622795', 'rose.31@yahoo.com', 'Farmer', 'Master’s Degree', '295 Market Lane, Mbarara, Mbarara', 'Football team'),
(504, 504, 'David Lwanga', 31, '+256752952662', 'david.lwanga92@gmail.com', 'Engineer', 'Master’s Degree', 'Winnie Mugabe', 53, '+256754521648', 'winnie.969@gmail.com', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(505, 505, 'Samuel Waiswa', 52, '+256701361764', 'samuel.waiswa13@gmail.com', 'Engineer', 'Secondary', 'Esther Byaruhanga', 42, '+256705546924', 'esther.180@gmail.com', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(506, 506, 'Peter Okello', 60, '+256704901576', 'peter.okello40@gmail.com', 'Shopkeeper', 'Bachelor’s Degree', 'Doreen Kyomuhendo', 53, '+256756663645', 'doreen.912@gmail.com', 'Civil Servant', 'Secondary', 'Robert Okello', 'Other', 72, '+256786539145', 'robert.36@yahoo.com', 'Doctor', 'Master’s Degree', '90 Central Avenue, Gulu, Gulu', 'Science fair participant'),
(507, 507, 'Andrew Kato', 62, '+256776277018', 'andrew.kato70@gmail.com', 'Mechanic', 'Secondary', 'Winnie Nakato', 51, '+256776321363', 'winnie.282@gmail.com', 'Teacher', 'Master’s Degree', 'Robert Kato', 'Other', 58, '+256777562695', 'robert.20@yahoo.com', 'Driver', 'Diploma', '467 Central Avenue, Gulu, Gulu', 'Choir member'),
(508, 508, 'Andrew Kato', 52, '+256786603861', 'andrew.kato48@gmail.com', 'Doctor', 'Master’s Degree', 'Brenda Aine', 35, '+256757709286', 'brenda.87@gmail.com', 'Civil Servant', 'Primary', 'Hellen Kato', 'Uncle', 30, '+256706114540', 'hellen.43@yahoo.com', 'Teacher', 'Master’s Degree', '168 Church Road, Arua, Arua', 'Prefect'),
(509, 509, 'Moses Ochieng', 53, '+256751086456', 'moses.ochieng91@gmail.com', 'Farmer', 'Secondary', 'Mercy Lwanga', 55, '+256758365045', 'mercy.39@gmail.com', 'Trader', 'Bachelor’s Degree', 'Rose Ochieng', 'Other', 50, '+256701960710', 'rose.45@yahoo.com', 'Engineer', 'Bachelor’s Degree', '448 Market Lane, Masaka, Masaka', 'Active in debate club'),
(510, 510, 'Ivan Waiswa', 45, '+256775079417', 'ivan.waiswa74@gmail.com', 'Civil Servant', 'Secondary', 'Joan Mugabe', 55, '+256771220377', 'joan.560@gmail.com', 'Entrepreneur', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(511, 511, 'Isaac Namukasa', 42, '+256755566882', 'isaac.namukasa56@gmail.com', 'Mechanic', 'Bachelor’s Degree', 'Joy Lwanga', 55, '+256752550871', 'joy.649@gmail.com', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(512, 512, 'David Tumusiime', 47, '+256754945076', 'david.tumusiime54@gmail.com', 'Driver', 'Primary', 'Sandra Waiswa', 57, '+256787437587', 'sandra.985@gmail.com', 'Entrepreneur', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(513, 513, 'Andrew Tumusiime', 44, '+256708714884', 'andrew.tumusiime78@gmail.com', 'Driver', 'Secondary', 'Joan Waiswa', 50, '+256779697602', 'joan.499@gmail.com', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(514, 514, 'Isaac Lwanga', 55, '+256785502273', 'isaac.lwanga2@gmail.com', 'Teacher', 'Diploma', 'Brenda Akello', 48, '+256775294412', 'brenda.797@gmail.com', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(515, 515, 'John Waiswa', 54, '+256773769420', 'john.waiswa30@gmail.com', 'Teacher', 'Bachelor’s Degree', 'Winnie Ssemwogerere', 59, '+256772380595', 'winnie.460@gmail.com', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(516, 516, 'David Okello', 39, '+256751189017', 'david.okello5@gmail.com', 'Mechanic', 'Secondary', 'Grace Mukasa', 62, '+256778481984', 'grace.85@gmail.com', 'Tailor', 'Secondary', 'Susan Okello', 'Aunt', 64, '+256708897850', 'susan.3@yahoo.com', 'Mechanic', 'Secondary', '6 School Road, Lira, Lira', 'Prefect'),
(517, 517, 'Peter Byaruhanga', 66, '+256784467833', 'peter.byaruhanga40@gmail.com', 'Doctor', 'Master’s Degree', 'Pritah Tumusiime', 52, '+256785379508', 'pritah.821@gmail.com', 'Housewife', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(518, 518, 'Mark Nalubega', 54, '+256776313211', 'mark.nalubega27@gmail.com', 'Farmer', 'Primary', 'Winnie Nantogo', 36, '+256788254047', 'winnie.328@gmail.com', 'Farmer', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(519, 519, 'John Nalubega', 59, '+256774422150', 'john.nalubega56@gmail.com', 'Mechanic', 'Secondary', 'Grace Ssemwogerere', 42, '+256778657573', 'grace.587@gmail.com', 'Farmer', 'Bachelor’s Degree', 'Alice Nalubega', 'Other', 30, '+256771715864', 'alice.23@yahoo.com', 'Shopkeeper', 'Bachelor’s Degree', '109 Hospital View, Kampala, Kampala', 'Choir member'),
(520, 520, 'Paul Busingye', 66, '+256708547297', 'paul.busingye87@gmail.com', 'Carpenter', 'Diploma', 'Esther Tumusiime', 43, '+256789057664', 'esther.220@gmail.com', 'Tailor', 'Master’s Degree', 'Robert Busingye', 'Mother', 41, '+256787154300', 'robert.65@yahoo.com', 'Civil Servant', 'Master’s Degree', '129 Hospital View, Lira, Lira', 'Active in debate club');
INSERT INTO `parents` (`ParentId`, `AdmissionNo`, `father_name`, `father_age`, `father_contact`, `father_email`, `father_occupation`, `father_education`, `mother_name`, `mother_age`, `mother_contact`, `mother_email`, `mother_occupation`, `mother_education`, `guardian_name`, `guardian_relation`, `guardian_age`, `guardian_contact`, `guardian_email`, `guardian_occupation`, `guardian_education`, `guardian_address`, `MoreInformation`) VALUES
(521, 521, 'Peter Mugabe', 67, '+256785050278', 'peter.mugabe65@gmail.com', 'Civil Servant', 'Bachelor’s Degree', 'Sandra Musoke', 45, '+256788575156', 'sandra.398@gmail.com', 'Farmer', 'Secondary', 'Susan Mugabe', 'Uncle', 63, '+256773665663', 'susan.5@yahoo.com', 'Engineer', 'Master’s Degree', '184 Hospital View, Fort Portal, Fort Portal', 'Active in debate club'),
(522, 522, 'Daniel Kyomuhendo', 32, '+256751940085', 'daniel.kyomuhendo66@gmail.com', 'Doctor', 'Secondary', 'Ritah Waiswa', 59, '+256759370829', 'ritah.527@gmail.com', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(523, 523, 'Isaac Busingye', 41, '+256759380826', 'isaac.busingye41@gmail.com', 'Farmer', 'Secondary', 'Joan Nantogo', 52, '+256706047763', 'joan.467@gmail.com', 'Entrepreneur', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(524, 524, 'John Tumusiime', 33, '+256787288308', 'john.tumusiime23@gmail.com', 'Civil Servant', 'Secondary', 'Mary Opio', 48, '+256772105379', 'mary.585@gmail.com', 'Nurse', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(525, 525, 'Daniel Waiswa', 40, '+256778573264', 'daniel.waiswa74@gmail.com', 'Teacher', 'Secondary', 'Rebecca Busingye', 56, '+256772018710', 'rebecca.822@gmail.com', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(526, 526, 'Samuel Ochieng', 66, '+256783381440', 'samuel.ochieng33@gmail.com', 'Driver', 'Bachelor’s Degree', 'Joan Byaruhanga', 63, '+256773460615', 'joan.753@gmail.com', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(527, 527, 'Joseph Byaruhanga', 66, '+256784965643', 'joseph.byaruhanga44@gmail.com', 'Farmer', 'Secondary', 'Winnie Nakato', 61, '+256708738758', 'winnie.494@gmail.com', 'Entrepreneur', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(528, 528, 'Mark Nantogo', 47, '+256783922434', 'mark.nantogo67@gmail.com', 'Farmer', 'Diploma', 'Brenda Okello', 47, '+256781790116', 'brenda.758@gmail.com', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(529, 529, 'Solomon Mukasa', 61, '+256772560486', 'solomon.mukasa65@gmail.com', 'Mechanic', 'Primary', 'Joy Busingye', 35, '+256788891629', 'joy.965@gmail.com', 'Nurse', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(530, 530, 'Peter Kyomuhendo', 66, '+256779938536', 'peter.kyomuhendo37@gmail.com', 'Engineer', 'Secondary', 'Brenda Waiswa', 44, '+256757297942', 'brenda.506@gmail.com', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(531, 531, 'Solomon Kyomuhendo', 61, '+256751111092', 'solomon.kyomuhendo16@gmail.com', 'Driver', 'Master’s Degree', 'Grace Namukasa', 38, '+256755021135', 'grace.323@gmail.com', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(532, 532, 'Isaac Ssemwogerere', 40, '+256707872163', 'isaac.ssemwogerere90@gmail.com', 'Shopkeeper', 'Primary', 'Rebecca Opio', 62, '+256784198350', 'rebecca.197@gmail.com', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(533, 533, 'Moses Ochieng', 64, '+256759324047', 'moses.ochieng52@gmail.com', 'Civil Servant', 'Master’s Degree', 'Mercy Mugabe', 45, '+256754939297', 'mercy.159@gmail.com', 'Entrepreneur', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(534, 534, 'Timothy Ochieng', 39, '+256702392873', 'timothy.ochieng33@gmail.com', 'Farmer', 'Master’s Degree', 'Pritah Busingye', 28, '+256754580760', 'pritah.840@gmail.com', 'Trader', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(535, 535, 'David Nantogo', 35, '+256703242347', 'david.nantogo37@gmail.com', 'Driver', 'Secondary', 'Ritah Mukasa', 55, '+256751591415', 'ritah.387@gmail.com', 'Trader', 'Diploma', 'Susan Nantogo', 'Father', 73, '+256777654209', 'susan.4@yahoo.com', 'Engineer', 'Secondary', '130 Church Road, Jinja, Jinja', 'Science fair participant'),
(536, 536, 'Mark Byaruhanga', 33, '+256751711364', 'mark.byaruhanga26@gmail.com', 'Shopkeeper', 'Master’s Degree', 'Mary Mukasa', 59, '+256705027809', 'mary.237@gmail.com', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(537, 537, 'Solomon Mukasa', 55, '+256755150714', 'solomon.mukasa20@gmail.com', 'Shopkeeper', 'Primary', 'Doreen Mukasa', 39, '+256771842868', 'doreen.719@gmail.com', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(538, 538, 'Isaac Namukasa', 52, '+256782375958', 'isaac.namukasa79@gmail.com', 'Engineer', 'Secondary', 'Sarah Nakato', 61, '+256753010768', 'sarah.911@gmail.com', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(539, 539, 'Joseph Mugabe', 40, '+256755508320', 'joseph.mugabe35@gmail.com', 'Doctor', 'Diploma', 'Sarah Ssemwogerere', 40, '+256701046624', 'sarah.667@gmail.com', 'Civil Servant', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(540, 540, 'Paul Mukasa', 61, '+256785112987', 'paul.mukasa3@gmail.com', 'Carpenter', 'Bachelor’s Degree', 'Esther Nantogo', 43, '+256759319810', 'esther.439@gmail.com', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(541, 541, 'Paul Nalubega', 34, '+256754200819', 'paul.nalubega23@gmail.com', 'Carpenter', 'Master’s Degree', 'Doreen Waiswa', 36, '+256703446325', 'doreen.206@gmail.com', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(542, 542, 'Samuel Nakato', 62, '+256702408094', 'samuel.nakato64@gmail.com', 'Teacher', 'Master’s Degree', 'Winnie Nalubega', 29, '+256775644756', 'winnie.120@gmail.com', 'Entrepreneur', 'Secondary', 'Florence Nakato', 'Grandparent', 76, '+256787115447', 'florence.54@yahoo.com', 'Driver', 'Bachelor’s Degree', '432 Hospital View, Gulu, Gulu', 'Science fair participant'),
(543, 543, 'Samuel Ochieng', 58, '+256772326435', 'samuel.ochieng23@gmail.com', 'Mechanic', 'Secondary', 'Joy Mukasa', 62, '+256759848025', 'joy.975@gmail.com', 'Civil Servant', 'Master’s Degree', 'Patrick Ochieng', 'Other', 48, '+256752341039', 'patrick.7@yahoo.com', 'Doctor', 'Secondary', '147 Central Avenue, Soroti, Soroti', 'Football team'),
(544, 544, 'Solomon Nakato', 40, '+256784965392', 'solomon.nakato51@gmail.com', 'Carpenter', 'Primary', 'Sandra Nakato', 28, '+256751673621', 'sandra.249@gmail.com', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(545, 545, 'Mark Byaruhanga', 65, '+256789849532', 'mark.byaruhanga16@gmail.com', 'Mechanic', 'Master’s Degree', 'Winnie Waiswa', 57, '+256708333467', 'winnie.645@gmail.com', 'Entrepreneur', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(546, 546, 'Isaac Busingye', 67, '+256778631573', 'isaac.busingye88@gmail.com', 'Mechanic', 'Primary', 'Alice Busingye', 29, '+256774615857', 'alice.650@gmail.com', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(547, 547, 'Daniel Kyomuhendo', 54, '+256752631237', 'daniel.kyomuhendo3@gmail.com', 'Mechanic', 'Master’s Degree', 'Sarah Ochieng', 34, '+256773160348', 'sarah.780@gmail.com', 'Trader', 'Secondary', 'James Kyomuhendo', 'Grandparent', 59, '+256773368688', 'james.11@yahoo.com', 'Civil Servant', 'Master’s Degree', '52 Church Road, Soroti, Soroti', 'Choir member'),
(548, 548, 'Mark Namukasa', 49, '+256701848382', 'mark.namukasa54@gmail.com', 'Civil Servant', 'Secondary', 'Joan Namukasa', 43, '+256783615359', 'joan.60@gmail.com', 'Entrepreneur', 'Diploma', 'Robert Namukasa', 'Other', 60, '+256757536790', 'robert.2@yahoo.com', 'Engineer', 'Master’s Degree', '341 School Road, Lira, Lira', 'Prefect'),
(549, 549, 'Ivan Okello', 47, '+256786258901', 'ivan.okello43@gmail.com', 'Mechanic', 'Primary', 'Grace Akello', 30, '+256751348017', 'grace.633@gmail.com', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(550, 550, 'Brian Nantogo', 38, '+256756687143', 'brian.nantogo61@gmail.com', 'Farmer', 'Diploma', 'Sandra Musoke', 60, '+256783034439', 'sandra.708@gmail.com', 'Farmer', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(551, 551, 'Brian Okello', 39, '+256773377407', 'brian.okello59@gmail.com', 'Engineer', 'Master’s Degree', 'Winnie Nakato', 41, '+256702427342', 'winnie.769@gmail.com', 'Trader', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(552, 552, 'Daniel Nalubega', 40, '+256774225836', 'daniel.nalubega65@gmail.com', 'Doctor', 'Bachelor’s Degree', 'Esther Nakato', 64, '+256785358828', 'esther.488@gmail.com', 'Tailor', 'Diploma', 'Rose Nalubega', 'Mother', 76, '+256771026115', 'rose.62@yahoo.com', 'Farmer', 'Master’s Degree', '495 Central Avenue, Fort Portal, Fort Portal', 'Active in debate club'),
(553, 553, 'Mark Lwanga', 44, '+256759894040', 'mark.lwanga85@gmail.com', 'Farmer', 'Master’s Degree', 'Sandra Akello', 53, '+256704519596', 'sandra.772@gmail.com', 'Farmer', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(554, 554, 'Paul Nakato', 41, '+256785875163', 'paul.nakato77@gmail.com', 'Teacher', 'Bachelor’s Degree', 'Brenda Nantogo', 38, '+256773622281', 'brenda.832@gmail.com', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(555, 555, 'John Okello', 30, '+256785323929', 'john.okello68@gmail.com', 'Teacher', 'Primary', 'Grace Aine', 36, '+256788345324', 'grace.137@gmail.com', 'Housewife', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(556, 556, 'Mark Nalubega', 46, '+256753705579', 'mark.nalubega26@gmail.com', 'Doctor', 'Secondary', 'Grace Mugabe', 28, '+256771886077', 'grace.461@gmail.com', 'Civil Servant', 'Diploma', 'Lillian Nalubega', 'Other', 40, '+256706321374', 'lillian.54@yahoo.com', 'Engineer', 'Secondary', '30 Main Street, Mbarara, Mbarara', 'Prefect'),
(557, 557, 'Solomon Busingye', 59, '+256782367120', 'solomon.busingye23@gmail.com', 'Teacher', 'Master’s Degree', 'Mary Aine', 44, '+256704045506', 'mary.892@gmail.com', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(558, 558, 'Peter Nalubega', 31, '+256754637976', 'peter.nalubega4@gmail.com', 'Teacher', 'Master’s Degree', 'Doreen Ssemwogerere', 34, '+256753466858', 'doreen.201@gmail.com', 'Teacher', 'Primary', 'Rose Nalubega', 'Mother', 44, '+256756091483', 'rose.98@yahoo.com', 'Mechanic', 'Bachelor’s Degree', '257 Central Avenue, Jinja, Jinja', 'Active in debate club'),
(559, 559, 'Paul Ssemwogerere', 55, '+256704158178', 'paul.ssemwogerere73@gmail.com', 'Teacher', 'Primary', 'Esther Busingye', 53, '+256755465174', 'esther.834@gmail.com', 'Entrepreneur', 'Diploma', 'Rose Ssemwogerere', 'Aunt', 48, '+256786231564', 'rose.45@yahoo.com', 'Engineer', 'Master’s Degree', '482 Central Avenue, Fort Portal, Fort Portal', 'Prefect'),
(560, 560, 'Mark Ssemwogerere', 39, '+256755108036', 'mark.ssemwogerere51@gmail.com', 'Civil Servant', 'Diploma', 'Winnie Mukasa', 35, '+256701407034', 'winnie.865@gmail.com', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(561, 561, 'Ivan Lwanga', 66, '+256774561186', 'ivan.lwanga41@gmail.com', 'Engineer', 'Master’s Degree', 'Mercy Ochieng', 38, '+256703556357', 'mercy.426@gmail.com', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(562, 562, 'Daniel Lwanga', 34, '+256757562513', 'daniel.lwanga6@gmail.com', 'Engineer', 'Master’s Degree', 'Rebecca Musoke', 38, '+256777471192', 'rebecca.288@gmail.com', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(563, 563, 'Ivan Kyomuhendo', 31, '+256751866930', 'ivan.kyomuhendo26@gmail.com', 'Engineer', 'Bachelor’s Degree', 'Doreen Okello', 53, '+256756620505', 'doreen.314@gmail.com', 'Trader', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(564, 564, 'David Ssemwogerere', 55, '+256756475824', 'david.ssemwogerere29@gmail.com', 'Doctor', 'Bachelor’s Degree', 'Mercy Tumusiime', 28, '+256772843184', 'mercy.926@gmail.com', 'Teacher', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(565, 565, 'Mark Byaruhanga', 39, '+256777126921', 'mark.byaruhanga25@gmail.com', 'Engineer', 'Secondary', 'Winnie Kato', 45, '+256708505461', 'winnie.994@gmail.com', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(566, 566, 'Joseph Kyomuhendo', 63, '+256709115987', 'joseph.kyomuhendo30@gmail.com', 'Doctor', 'Master’s Degree', 'Joy Ssemwogerere', 29, '+256777699088', 'joy.53@gmail.com', 'Nurse', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(567, 567, 'Joseph Waiswa', 49, '+256774106193', 'joseph.waiswa50@gmail.com', 'Mechanic', 'Secondary', 'Joan Ochieng', 47, '+256771943937', 'joan.166@gmail.com', 'Nurse', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(568, 568, 'Brian Nakato', 43, '+256751455237', 'brian.nakato49@gmail.com', 'Farmer', 'Master’s Degree', 'Doreen Waiswa', 28, '+256709920528', 'doreen.997@gmail.com', 'Nurse', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(569, 569, 'Peter Nantogo', 37, '+256788637083', 'peter.nantogo34@gmail.com', 'Carpenter', 'Master’s Degree', 'Mercy Aine', 53, '+256707429136', 'mercy.564@gmail.com', 'Civil Servant', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(570, 570, 'Ivan Akello', 42, '+256752817172', 'ivan.akello77@gmail.com', 'Doctor', 'Secondary', 'Doreen Aine', 35, '+256779113639', 'doreen.978@gmail.com', 'Nurse', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(571, 571, 'John Mukasa', 68, '+256703539858', 'john.mukasa95@gmail.com', 'Mechanic', 'Bachelor’s Degree', 'Esther Tumusiime', 40, '+256758583197', 'esther.970@gmail.com', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(572, 572, 'Solomon Opio', 61, '+256773468318', 'solomon.opio12@gmail.com', 'Shopkeeper', 'Diploma', 'Brenda Kato', 49, '+256704153337', 'brenda.927@gmail.com', 'Farmer', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(573, 573, 'Solomon Lwanga', 42, '+256701399275', 'solomon.lwanga88@gmail.com', 'Mechanic', 'Bachelor’s Degree', 'Rebecca Nantogo', 41, '+256758427921', 'rebecca.968@gmail.com', 'Entrepreneur', 'Bachelor’s Degree', 'Charles Lwanga', 'Mother', 60, '+256778724584', 'charles.15@yahoo.com', 'Shopkeeper', 'Master’s Degree', '261 School Road, Kampala, Kampala', 'Science fair participant'),
(574, 574, 'David Nantogo', 32, '+256752959146', 'david.nantogo53@gmail.com', 'Civil Servant', 'Diploma', 'Alice Mukasa', 41, '+256787154267', 'alice.81@gmail.com', 'Trader', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(575, 575, 'Samuel Ssemwogerere', 54, '+256701682537', 'samuel.ssemwogerere36@gmail.com', 'Mechanic', 'Primary', 'Pritah Ochieng', 59, '+256706280380', 'pritah.720@gmail.com', 'Nurse', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(576, 576, 'Daniel Aine', 59, '+256788771648', 'daniel.aine6@gmail.com', 'Driver', 'Secondary', 'Sarah Nalubega', 31, '+256788940898', 'sarah.945@gmail.com', 'Trader', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(577, 577, 'Andrew Nalubega', 59, '+256755612563', 'andrew.nalubega64@gmail.com', 'Civil Servant', 'Diploma', 'Brenda Akello', 63, '+256709370447', 'brenda.746@gmail.com', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(578, 578, 'John Mukasa', 62, '+256709541713', 'john.mukasa52@gmail.com', 'Driver', 'Primary', 'Brenda Musoke', 49, '+256754815867', 'brenda.170@gmail.com', 'Tailor', 'Secondary', 'Lillian Mukasa', 'Other', 33, '+256778657976', 'lillian.89@yahoo.com', 'Carpenter', 'Bachelor’s Degree', '303 Church Road, Arua, Arua', 'Prefect'),
(579, 579, 'John Nalubega', 46, '+256789312438', 'john.nalubega23@gmail.com', 'Engineer', 'Bachelor’s Degree', 'Sarah Ochieng', 33, '+256774555841', 'sarah.466@gmail.com', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(580, 580, 'Timothy Kato', 52, '+256775524363', 'timothy.kato1@gmail.com', 'Civil Servant', 'Master’s Degree', 'Ritah Kato', 54, '+256754387718', 'ritah.369@gmail.com', 'Trader', 'Secondary', 'Lillian Kato', 'Mother', 61, '+256774566160', 'lillian.88@yahoo.com', 'Driver', 'Bachelor’s Degree', '23 Market Lane, Mbale, Mbale', 'Science fair participant'),
(581, 581, 'Paul Okello', 34, '+256759661628', 'paul.okello79@gmail.com', 'Farmer', 'Secondary', 'Pritah Lwanga', 29, '+256782360752', 'pritah.496@gmail.com', 'Civil Servant', 'Secondary', 'Florence Okello', 'Father', 69, '+256781801866', 'florence.45@yahoo.com', 'Mechanic', 'Secondary', '415 School Road, Mbale, Mbale', 'Football team'),
(582, 582, 'Joseph Ochieng', 37, '+256777849606', 'joseph.ochieng29@gmail.com', 'Teacher', 'Master’s Degree', 'Pritah Waiswa', 45, '+256709138702', 'pritah.637@gmail.com', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(583, 583, 'Joseph Busingye', 62, '+256703889286', 'joseph.busingye15@gmail.com', 'Shopkeeper', 'Bachelor’s Degree', 'Grace Okello', 48, '+256786943218', 'grace.307@gmail.com', 'Entrepreneur', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(584, 584, 'Paul Namukasa', 44, '+256778598597', 'paul.namukasa57@gmail.com', 'Teacher', 'Secondary', 'Mary Lwanga', 62, '+256703578874', 'mary.357@gmail.com', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(585, 585, 'Daniel Aine', 65, '+256788044135', 'daniel.aine64@gmail.com', 'Driver', 'Master’s Degree', 'Joy Musoke', 37, '+256758518271', 'joy.951@gmail.com', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(586, 586, 'Isaac Opio', 33, '+256777107482', 'isaac.opio22@gmail.com', 'Civil Servant', 'Diploma', 'Ritah Kato', 49, '+256709331517', 'ritah.468@gmail.com', 'Tailor', 'Diploma', 'Robert Opio', 'Father', 32, '+256702994155', 'robert.33@yahoo.com', 'Shopkeeper', 'Diploma', '16 Market Lane, Fort Portal, Fort Portal', 'Choir member'),
(587, 587, 'Isaac Opio', 61, '+256706968528', 'isaac.opio54@gmail.com', 'Doctor', 'Bachelor’s Degree', 'Pritah Okello', 43, '+256759733308', 'pritah.867@gmail.com', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(588, 588, 'Andrew Musoke', 40, '+256775871366', 'andrew.musoke96@gmail.com', 'Engineer', 'Master’s Degree', 'Rebecca Kato', 58, '+256781557871', 'rebecca.801@gmail.com', 'Civil Servant', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(589, 589, 'Mark Akello', 45, '+256759377552', 'mark.akello62@gmail.com', 'Mechanic', 'Master’s Degree', 'Grace Kyomuhendo', 35, '+256709394380', 'grace.400@gmail.com', 'Housewife', 'Diploma', 'Robert Akello', 'Father', 57, '+256779644653', 'robert.18@yahoo.com', 'Carpenter', 'Bachelor’s Degree', '62 Main Street, Mbarara, Mbarara', 'Choir member'),
(590, 590, 'Daniel Namukasa', 37, '+256757661803', 'daniel.namukasa47@gmail.com', 'Driver', 'Master’s Degree', 'Joy Nalubega', 61, '+256702695283', 'joy.92@gmail.com', 'Farmer', 'Secondary', 'Florence Namukasa', 'Aunt', 50, '+256789689189', 'florence.49@yahoo.com', 'Driver', 'Secondary', '107 School Road, Arua, Arua', 'Football team'),
(591, 591, 'Timothy Ssemwogerere', 52, '+256784630394', 'timothy.ssemwogerere74@gmail.com', 'Shopkeeper', 'Primary', 'Mary Busingye', 37, '+256709788287', 'mary.635@gmail.com', 'Teacher', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(592, 592, 'Daniel Namukasa', 61, '+256702559784', 'daniel.namukasa65@gmail.com', 'Mechanic', 'Secondary', 'Rebecca Ssemwogerere', 36, '+256784511343', 'rebecca.680@gmail.com', 'Nurse', 'Master’s Degree', 'Susan Namukasa', 'Uncle', 42, '+256754596190', 'susan.32@yahoo.com', 'Farmer', 'Primary', '229 Market Lane, Arua, Arua', 'Choir member'),
(593, 593, 'Paul Okello', 57, '+256778911726', 'paul.okello25@gmail.com', 'Shopkeeper', 'Master’s Degree', 'Alice Kyomuhendo', 55, '+256708145674', 'alice.823@gmail.com', 'Farmer', 'Master’s Degree', 'Patrick Okello', 'Father', 78, '+256778115706', 'patrick.66@yahoo.com', 'Carpenter', 'Diploma', '399 Church Road, Kampala, Kampala', 'Science fair participant'),
(594, 594, 'Ivan Mukasa', 35, '+256789867232', 'ivan.mukasa21@gmail.com', 'Teacher', 'Master’s Degree', 'Winnie Musoke', 45, '+256758545365', 'winnie.595@gmail.com', 'Trader', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(595, 595, 'Ivan Mukasa', 53, '+256709612513', 'ivan.mukasa28@gmail.com', 'Teacher', 'Bachelor’s Degree', 'Brenda Aine', 59, '+256753363856', 'brenda.328@gmail.com', 'Teacher', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(596, 596, 'Timothy Nalubega', 66, '+256752460714', 'timothy.nalubega27@gmail.com', 'Civil Servant', 'Master’s Degree', 'Ritah Nakato', 29, '+256753636451', 'ritah.785@gmail.com', 'Entrepreneur', 'Secondary', 'Lillian Nalubega', 'Grandparent', 67, '+256787137100', 'lillian.76@yahoo.com', 'Engineer', 'Bachelor’s Degree', '83 Church Road, Gulu, Gulu', 'Science fair participant'),
(597, 597, 'Daniel Waiswa', 35, '+256754368462', 'daniel.waiswa84@gmail.com', 'Farmer', 'Secondary', 'Sarah Nalubega', 36, '+256778233032', 'sarah.929@gmail.com', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(598, 598, 'Moses Ssemwogerere', 66, '+256709297073', 'moses.ssemwogerere13@gmail.com', 'Farmer', 'Master’s Degree', 'Grace Akello', 32, '+256701790814', 'grace.474@gmail.com', 'Nurse', 'Secondary', 'Robert Ssemwogerere', 'Uncle', 26, '+256758306829', 'robert.36@yahoo.com', 'Carpenter', 'Primary', '41 School Road, Soroti, Soroti', 'Football team'),
(599, 599, 'Solomon Namukasa', 35, '+256706352605', 'solomon.namukasa97@gmail.com', 'Civil Servant', 'Primary', 'Doreen Kato', 34, '+256788268281', 'doreen.122@gmail.com', 'Trader', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(600, 600, 'Ivan Kato', 62, '+256751687540', 'ivan.kato20@gmail.com', 'Driver', 'Master’s Degree', 'Esther Nakato', 62, '+256771168383', 'esther.798@gmail.com', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(601, 601, 'David Kyomuhendo', 32, '+256758165151', 'david.kyomuhendo8@gmail.com', 'Teacher', 'Primary', 'Grace Lwanga', 42, '+256776298370', 'grace.231@gmail.com', 'Teacher', 'Primary', 'Lillian Kyomuhendo', 'Aunt', 58, '+256752187951', 'lillian.79@yahoo.com', 'Farmer', 'Secondary', '118 Central Avenue, Lira, Lira', 'Choir member'),
(602, 602, 'Paul Mugabe', 64, '+256758075149', 'paul.mugabe4@gmail.com', 'Farmer', 'Secondary', 'Mary Musoke', 49, '+256773374157', 'mary.674@gmail.com', 'Entrepreneur', 'Bachelor’s Degree', 'James Mugabe', 'Uncle', 61, '+256777698852', 'james.12@yahoo.com', 'Teacher', 'Diploma', '355 Central Avenue, Mbale, Mbale', 'Choir member'),
(603, 603, 'Timothy Nakato', 52, '+256701790414', 'timothy.nakato95@gmail.com', 'Mechanic', 'Primary', 'Joan Okello', 59, '+256776146300', 'joan.310@gmail.com', 'Teacher', 'Bachelor’s Degree', 'Charles Nakato', 'Other', 52, '+256752590015', 'charles.27@yahoo.com', 'Mechanic', 'Primary', '225 Market Lane, Soroti, Soroti', 'Prefect'),
(604, 604, 'Mark Tumusiime', 55, '+256778506886', 'mark.tumusiime42@gmail.com', 'Mechanic', 'Bachelor’s Degree', 'Rebecca Busingye', 36, '+256779311728', 'rebecca.2@gmail.com', 'Farmer', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(605, 605, 'Daniel Nalubega', 53, '+256789594437', 'daniel.nalubega48@gmail.com', 'Engineer', 'Diploma', 'Brenda Mugabe', 60, '+256756955124', 'brenda.170@gmail.com', 'Housewife', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(606, 606, 'Moses Namukasa', 32, '+256778248136', 'moses.namukasa29@gmail.com', 'Engineer', 'Master’s Degree', 'Esther Mukasa', 31, '+256702330679', 'esther.907@gmail.com', 'Housewife', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(607, 607, 'John Akello', 37, '+256704081356', 'john.akello24@gmail.com', 'Doctor', 'Bachelor’s Degree', 'Ritah Tumusiime', 31, '+256773258460', 'ritah.171@gmail.com', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(608, 608, 'Ivan Nakato', 43, '+256783637623', 'ivan.nakato63@gmail.com', 'Civil Servant', 'Bachelor’s Degree', 'Doreen Kato', 52, '+256777673731', 'doreen.178@gmail.com', 'Housewife', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(609, 609, 'David Namukasa', 56, '+256701320954', 'david.namukasa74@gmail.com', 'Teacher', 'Secondary', 'Winnie Namukasa', 30, '+256775831007', 'winnie.933@gmail.com', 'Tailor', 'Secondary', 'Patrick Namukasa', 'Uncle', 35, '+256775940400', 'patrick.60@yahoo.com', 'Civil Servant', 'Primary', '173 Main Street, Kampala, Kampala', 'Active in debate club'),
(610, 610, 'Peter Mugabe', 61, '+256781702450', 'peter.mugabe39@gmail.com', 'Civil Servant', 'Primary', 'Pritah Nalubega', 32, '+256775252572', 'pritah.906@gmail.com', 'Housewife', 'Master’s Degree', 'Hellen Mugabe', 'Mother', 31, '+256785287103', 'hellen.91@yahoo.com', 'Teacher', 'Primary', '56 Church Road, Lira, Lira', 'Prefect'),
(611, 611, 'Isaac Mugabe', 31, '+256751978857', 'isaac.mugabe86@gmail.com', 'Shopkeeper', 'Bachelor’s Degree', 'Joy Ssemwogerere', 62, '+256776166648', 'joy.328@gmail.com', 'Trader', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(612, 612, 'Isaac Opio', 46, '+256754640695', 'isaac.opio12@gmail.com', 'Shopkeeper', 'Primary', 'Sandra Okello', 41, '+256777435468', 'sandra.902@gmail.com', 'Farmer', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(613, 613, 'Isaac Opio', 41, '+256707369009', 'isaac.opio67@gmail.com', 'Engineer', 'Master’s Degree', 'Mercy Musoke', 57, '+256705810305', 'mercy.282@gmail.com', 'Farmer', 'Diploma', 'Patrick Opio', 'Uncle', 70, '+256783354150', 'patrick.84@yahoo.com', 'Civil Servant', 'Primary', '30 Main Street, Jinja, Jinja', 'Prefect'),
(614, 614, 'Paul Tumusiime', 63, '+256778419782', 'paul.tumusiime45@gmail.com', 'Civil Servant', 'Secondary', 'Joy Mugabe', 38, '+256784393704', 'joy.280@gmail.com', 'Trader', 'Bachelor’s Degree', 'Florence Tumusiime', 'Other', 44, '+256757986542', 'florence.62@yahoo.com', 'Farmer', 'Master’s Degree', '420 Market Lane, Jinja, Jinja', 'Prefect'),
(615, 615, 'Peter Byaruhanga', 65, '+256701832627', 'peter.byaruhanga22@gmail.com', 'Civil Servant', 'Bachelor’s Degree', 'Winnie Musoke', 50, '+256753464642', 'winnie.487@gmail.com', 'Civil Servant', 'Secondary', '', '', NULL, '', '', NULL, NULL, '', 'Football team'),
(616, 616, 'Moses Nakato', 36, '+256707525010', 'moses.nakato26@gmail.com', 'Teacher', 'Bachelor’s Degree', 'Winnie Mukasa', 36, '+256701457565', 'winnie.877@gmail.com', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(617, 617, 'Mark Musoke', 52, '+256778173311', 'mark.musoke78@gmail.com', 'Driver', 'Bachelor’s Degree', 'Rebecca Kato', 30, '+256781695166', 'rebecca.859@gmail.com', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(618, 618, 'Samuel Byaruhanga', 42, '+256778645749', 'samuel.byaruhanga96@gmail.com', 'Civil Servant', 'Diploma', 'Grace Ochieng', 60, '+256788599720', 'grace.681@gmail.com', 'Teacher', 'Primary', 'Charles Byaruhanga', 'Grandparent', 40, '+256778711650', 'charles.5@yahoo.com', 'Engineer', 'Master’s Degree', '17 School Road, Soroti, Soroti', 'Choir member'),
(619, 619, 'Isaac Namukasa', 30, '+256781461125', 'isaac.namukasa42@gmail.com', 'Carpenter', 'Master’s Degree', 'Brenda Mukasa', 57, '+256754456538', 'brenda.389@gmail.com', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(620, 620, 'Mark Ssemwogerere', 55, '+256781457994', 'mark.ssemwogerere55@gmail.com', 'Driver', 'Bachelor’s Degree', 'Esther Kyomuhendo', 63, '+256755809293', 'esther.514@gmail.com', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(621, 621, 'Brian Kyomuhendo', 31, '+256788368595', 'brian.kyomuhendo29@gmail.com', 'Doctor', 'Secondary', 'Brenda Kyomuhendo', 46, '+256701929819', 'brenda.763@gmail.com', 'Teacher', 'Bachelor’s Degree', 'Lillian Kyomuhendo', 'Other', 35, '+256703386953', 'lillian.14@yahoo.com', 'Farmer', 'Secondary', '150 Central Avenue, Soroti, Soroti', 'Active in debate club'),
(622, 622, 'Mark Kato', 49, '+256788225227', 'mark.kato37@gmail.com', 'Doctor', 'Primary', 'Joan Mukasa', 54, '+256784911406', 'joan.404@gmail.com', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(623, 623, 'Paul Nantogo', 42, '+256759562905', 'paul.nantogo82@gmail.com', 'Teacher', 'Secondary', 'Doreen Ochieng', 34, '+256774490311', 'doreen.468@gmail.com', 'Trader', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(624, 624, 'David Okello', 53, '+256786919613', 'david.okello30@gmail.com', 'Teacher', 'Secondary', 'Joan Kyomuhendo', 49, '+256756711087', 'joan.496@gmail.com', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(625, 625, 'Brian Nakato', 55, '+256756902220', 'brian.nakato71@gmail.com', 'Teacher', 'Diploma', 'Winnie Ochieng', 30, '+256707223797', 'winnie.225@gmail.com', 'Trader', 'Master’s Degree', 'James Nakato', 'Father', 45, '+256704987500', 'james.27@yahoo.com', 'Civil Servant', 'Diploma', '98 Central Avenue, Kampala, Kampala', 'Football team'),
(626, 626, 'John Aine', 47, '+256779463438', 'john.aine5@gmail.com', 'Teacher', 'Bachelor’s Degree', 'Mercy Okello', 48, '+256754556424', 'mercy.346@gmail.com', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(627, 627, 'Joseph Akello', 42, '+256771658843', 'joseph.akello30@gmail.com', 'Civil Servant', 'Diploma', 'Grace Ochieng', 43, '+256784730387', 'grace.134@gmail.com', 'Civil Servant', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(628, 628, 'Samuel Musoke', 56, '+256778903001', 'samuel.musoke5@gmail.com', 'Teacher', 'Diploma', 'Grace Kyomuhendo', 51, '+256709095563', 'grace.267@gmail.com', 'Tailor', 'Primary', 'Rose Musoke', 'Father', 69, '+256782014845', 'rose.29@yahoo.com', 'Shopkeeper', 'Diploma', '272 Church Road, Soroti, Soroti', 'Active in debate club'),
(629, 629, 'Brian Tumusiime', 41, '+256703032280', 'brian.tumusiime78@gmail.com', 'Teacher', 'Diploma', 'Mercy Lwanga', 58, '+256759369188', 'mercy.521@gmail.com', 'Trader', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(630, 630, 'Samuel Lwanga', 49, '+256706561979', 'samuel.lwanga66@gmail.com', 'Engineer', 'Bachelor’s Degree', 'Sarah Ochieng', 37, '+256771277630', 'sarah.870@gmail.com', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(631, 631, 'David Lwanga', 41, '+256755285565', 'david.lwanga14@gmail.com', 'Mechanic', 'Primary', 'Joy Okello', 44, '+256783200020', 'joy.433@gmail.com', 'Housewife', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(632, 632, 'Andrew Tumusiime', 44, '+256759384505', 'andrew.tumusiime42@gmail.com', 'Driver', 'Diploma', 'Joy Ochieng', 46, '+256755527429', 'joy.798@gmail.com', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(633, 633, 'John Byaruhanga', 69, '+256771991557', 'john.byaruhanga85@gmail.com', 'Engineer', 'Bachelor’s Degree', 'Alice Busingye', 51, '+256775735551', 'alice.241@gmail.com', 'Tailor', 'Secondary', 'Robert Byaruhanga', 'Mother', 45, '+256756279642', 'robert.41@yahoo.com', 'Mechanic', 'Diploma', '150 School Road, Lira, Lira', 'Prefect'),
(634, 634, 'Peter Nakato', 34, '+256772427985', 'peter.nakato70@gmail.com', 'Engineer', 'Bachelor’s Degree', 'Winnie Kato', 59, '+256779113356', 'winnie.909@gmail.com', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(635, 635, 'Moses Busingye', 52, '+256788215409', 'moses.busingye38@gmail.com', 'Shopkeeper', 'Secondary', 'Winnie Nakato', 39, '+256776602164', 'winnie.435@gmail.com', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(636, 636, 'Mark Waiswa', 45, '+256703929816', 'mark.waiswa46@gmail.com', 'Driver', 'Diploma', 'Ritah Ochieng', 30, '+256753539945', 'ritah.184@gmail.com', 'Housewife', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(637, 637, 'Moses Mukasa', 67, '+256752038068', 'moses.mukasa45@gmail.com', 'Doctor', 'Master’s Degree', 'Sarah Akello', 42, '+256752461833', 'sarah.175@gmail.com', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(638, 638, 'Moses Aine', 60, '+256759980751', 'moses.aine94@gmail.com', 'Mechanic', 'Secondary', 'Winnie Waiswa', 41, '+256703918162', 'winnie.465@gmail.com', 'Tailor', 'Master’s Degree', 'Alice Aine', 'Father', 77, '+256751508400', 'alice.26@yahoo.com', 'Doctor', 'Bachelor’s Degree', '181 School Road, Lira, Lira', 'Active in debate club'),
(639, 639, 'Timothy Nakato', 67, '+256707581928', 'timothy.nakato42@gmail.com', 'Engineer', 'Primary', 'Mercy Busingye', 32, '+256753186598', 'mercy.168@gmail.com', 'Nurse', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(640, 640, 'Joseph Namukasa', 47, '+256756199474', 'joseph.namukasa23@gmail.com', 'Driver', 'Primary', 'Mercy Akello', 59, '+256775511631', 'mercy.470@gmail.com', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(641, 641, 'Timothy Busingye', 56, '+256772139592', 'timothy.busingye40@gmail.com', 'Farmer', 'Diploma', 'Joan Opio', 37, '+256782434387', 'joan.344@gmail.com', 'Farmer', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(642, 642, 'Daniel Mugabe', 53, '+256705955363', 'daniel.mugabe84@gmail.com', 'Engineer', 'Secondary', 'Esther Ssemwogerere', 29, '+256781046368', 'esther.409@gmail.com', 'Entrepreneur', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(643, 643, 'Peter Lwanga', 37, '+256706049819', 'peter.lwanga37@gmail.com', 'Carpenter', 'Bachelor’s Degree', 'Winnie Opio', 45, '+256705778217', 'winnie.809@gmail.com', 'Housewife', 'Master’s Degree', 'James Lwanga', 'Aunt', 46, '+256781631225', 'james.73@yahoo.com', 'Engineer', 'Diploma', '331 Hospital View, Kampala, Kampala', 'Science fair participant'),
(644, 644, 'Joseph Musoke', 48, '+256755973607', 'joseph.musoke61@gmail.com', 'Driver', 'Primary', 'Ritah Byaruhanga', 39, '+256788002557', 'ritah.130@gmail.com', 'Farmer', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(645, 645, 'Timothy Ochieng', 61, '+256704787942', 'timothy.ochieng1@gmail.com', 'Mechanic', 'Secondary', 'Mary Mukasa', 43, '+256771045804', 'mary.285@gmail.com', 'Farmer', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(646, 646, 'John Namukasa', 36, '+256705947259', 'john.namukasa75@gmail.com', 'Driver', 'Primary', 'Joy Aine', 45, '+256787506379', 'joy.327@gmail.com', 'Teacher', 'Diploma', 'Patrick Namukasa', 'Aunt', 64, '+256785142447', 'patrick.79@yahoo.com', 'Civil Servant', 'Diploma', '255 Central Avenue, Lira, Lira', 'Prefect'),
(647, 647, 'Mark Waiswa', 30, '+256709632827', 'mark.waiswa37@gmail.com', 'Mechanic', 'Diploma', 'Mary Nantogo', 47, '+256782338211', 'mary.391@gmail.com', 'Tailor', 'Diploma', 'Charles Waiswa', 'Other', 67, '+256778469099', 'charles.46@yahoo.com', 'Engineer', 'Diploma', '237 School Road, Arua, Arua', 'Choir member'),
(648, 648, 'Timothy Mugabe', 37, '+256758541767', 'timothy.mugabe33@gmail.com', 'Mechanic', 'Master’s Degree', 'Winnie Mukasa', 38, '+256702432141', 'winnie.352@gmail.com', 'Teacher', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(649, 649, 'Brian Byaruhanga', 34, '+256772836996', 'brian.byaruhanga34@gmail.com', 'Driver', 'Secondary', 'Winnie Tumusiime', 29, '+256771952162', 'winnie.469@gmail.com', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(650, 650, 'Mark Lwanga', 52, '+256702973330', 'mark.lwanga4@gmail.com', 'Civil Servant', 'Bachelor’s Degree', 'Joan Tumusiime', 33, '+256751360460', 'joan.451@gmail.com', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(651, 651, 'Isaac Kyomuhendo', 59, '+256773168394', 'isaac.kyomuhendo68@gmail.com', 'Shopkeeper', 'Bachelor’s Degree', 'Ritah Waiswa', 57, '+256755522732', 'ritah.658@gmail.com', 'Entrepreneur', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(652, 652, 'Joseph Tumusiime', 51, '+256756555972', 'joseph.tumusiime86@gmail.com', 'Teacher', 'Bachelor’s Degree', 'Mary Musoke', 43, '+256707640433', 'mary.726@gmail.com', 'Entrepreneur', 'Diploma', 'Charles Tumusiime', 'Uncle', 51, '+256786956092', 'charles.87@yahoo.com', 'Farmer', 'Primary', '417 Central Avenue, Kampala, Kampala', 'Choir member'),
(653, 653, 'Ivan Mugabe', 48, '+256789638126', 'ivan.mugabe6@gmail.com', 'Farmer', 'Secondary', 'Mary Mugabe', 64, '+256704711991', 'mary.641@gmail.com', 'Entrepreneur', 'Master’s Degree', 'Alice Mugabe', 'Father', 74, '+256786093658', 'alice.96@yahoo.com', 'Teacher', 'Secondary', '247 Hospital View, Lira, Lira', 'Football team'),
(654, 654, 'Samuel Ssemwogerere', 65, '+256779055612', 'samuel.ssemwogerere11@gmail.com', 'Teacher', 'Bachelor’s Degree', 'Mercy Ssemwogerere', 59, '+256786093798', 'mercy.911@gmail.com', 'Trader', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(655, 655, 'Solomon Tumusiime', 34, '+256755801436', 'solomon.tumusiime14@gmail.com', 'Farmer', 'Diploma', 'Doreen Okello', 45, '+256758468514', 'doreen.193@gmail.com', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(656, 656, 'Moses Nantogo', 41, '+256789045780', 'moses.nantogo78@gmail.com', 'Teacher', 'Diploma', 'Mercy Ochieng', 64, '+256705815671', 'mercy.519@gmail.com', 'Tailor', 'Primary', 'Hellen Nantogo', 'Aunt', 31, '+256779562148', 'hellen.46@yahoo.com', 'Teacher', 'Primary', '301 Central Avenue, Kampala, Kampala', 'Prefect'),
(657, 657, 'Andrew Musoke', 41, '+256779765048', 'andrew.musoke43@gmail.com', 'Teacher', 'Bachelor’s Degree', 'Winnie Nakato', 56, '+256777224355', 'winnie.768@gmail.com', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(658, 658, 'David Namukasa', 37, '+256704839727', 'david.namukasa9@gmail.com', 'Civil Servant', 'Master’s Degree', 'Esther Musoke', 42, '+256778444557', 'esther.775@gmail.com', 'Civil Servant', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(659, 659, 'Paul Opio', 42, '+256779106042', 'paul.opio40@gmail.com', 'Engineer', 'Primary', 'Brenda Mugabe', 49, '+256787318325', 'brenda.738@gmail.com', 'Civil Servant', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(660, 660, 'Paul Mukasa', 58, '+256785205997', 'paul.mukasa42@gmail.com', 'Engineer', 'Diploma', 'Doreen Nakato', 42, '+256785594384', 'doreen.586@gmail.com', 'Teacher', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(661, 661, 'Moses Busingye', 65, '+256757793928', 'moses.busingye82@gmail.com', 'Mechanic', 'Primary', 'Esther Aine', 45, '+256703577562', 'esther.667@gmail.com', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(662, 662, 'David Lwanga', 46, '+256788811763', 'david.lwanga79@gmail.com', 'Civil Servant', 'Primary', 'Rebecca Ochieng', 58, '+256784342771', 'rebecca.989@gmail.com', 'Farmer', 'Diploma', 'Alice Lwanga', 'Other', 79, '+256702228649', 'alice.27@yahoo.com', 'Teacher', 'Diploma', '88 Market Lane, Lira, Lira', 'Science fair participant'),
(663, 663, 'Daniel Kyomuhendo', 61, '+256707763328', 'daniel.kyomuhendo80@gmail.com', 'Shopkeeper', 'Diploma', 'Esther Busingye', 45, '+256709511716', 'esther.463@gmail.com', 'Nurse', 'Bachelor’s Degree', 'Patrick Kyomuhendo', 'Other', 62, '+256755004003', 'patrick.24@yahoo.com', 'Civil Servant', 'Bachelor’s Degree', '332 Central Avenue, Lira, Lira', 'Active in debate club'),
(664, 664, 'Isaac Ochieng', 44, '+256704918600', 'isaac.ochieng92@gmail.com', 'Teacher', 'Master’s Degree', 'Mercy Ochieng', 47, '+256704645928', 'mercy.948@gmail.com', 'Housewife', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(665, 665, 'Samuel Aine', 36, '+256774339797', 'samuel.aine25@gmail.com', 'Teacher', 'Diploma', 'Winnie Kato', 50, '+256777468108', 'winnie.150@gmail.com', 'Trader', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(666, 666, 'Mark Nalubega', 36, '+256709720875', 'mark.nalubega1@gmail.com', 'Carpenter', 'Diploma', 'Brenda Okello', 49, '+256783226207', 'brenda.466@gmail.com', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(667, 667, 'John Mugabe', 43, '+256704107838', 'john.mugabe27@gmail.com', 'Carpenter', 'Secondary', 'Winnie Byaruhanga', 56, '+256755240713', 'winnie.434@gmail.com', 'Trader', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(668, 668, 'Moses Lwanga', 33, '+256708246240', 'moses.lwanga69@gmail.com', 'Engineer', 'Diploma', 'Rebecca Mukasa', 42, '+256779003350', 'rebecca.411@gmail.com', 'Civil Servant', 'Diploma', 'Robert Lwanga', 'Father', 45, '+256702201316', 'robert.28@yahoo.com', 'Civil Servant', 'Diploma', '463 School Road, Mbarara, Mbarara', 'Prefect'),
(669, 669, 'Brian Byaruhanga', 50, '+256755244515', 'brian.byaruhanga38@gmail.com', 'Engineer', 'Diploma', 'Pritah Tumusiime', 52, '+256786816603', 'pritah.520@gmail.com', 'Housewife', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(670, 670, 'Andrew Mugabe', 58, '+256703197892', 'andrew.mugabe8@gmail.com', 'Doctor', 'Secondary', 'Pritah Busingye', 49, '+256783524153', 'pritah.685@gmail.com', 'Entrepreneur', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(671, 671, 'Brian Waiswa', 40, '+256758127501', 'brian.waiswa71@gmail.com', 'Teacher', 'Bachelor’s Degree', 'Sandra Akello', 57, '+256708844706', 'sandra.879@gmail.com', 'Teacher', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(672, 672, 'John Tumusiime', 47, '+256756455825', 'john.tumusiime84@gmail.com', 'Shopkeeper', 'Bachelor’s Degree', 'Joan Mugabe', 46, '+256772567633', 'joan.204@gmail.com', 'Entrepreneur', 'Master’s Degree', 'Alice Tumusiime', 'Other', 52, '+256707972764', 'alice.63@yahoo.com', 'Carpenter', 'Bachelor’s Degree', '37 Hospital View, Mbarara, Mbarara', 'Science fair participant'),
(673, 673, 'Paul Nalubega', 47, '+256759076796', 'paul.nalubega61@gmail.com', 'Doctor', 'Primary', 'Pritah Kyomuhendo', 38, '+256787878722', 'pritah.912@gmail.com', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(674, 674, 'Samuel Opio', 51, '+256701871912', 'samuel.opio36@gmail.com', 'Shopkeeper', 'Secondary', 'Joan Nantogo', 46, '+256753303760', 'joan.452@gmail.com', 'Nurse', 'Primary', 'Alice Opio', 'Aunt', 79, '+256709345341', 'alice.85@yahoo.com', 'Driver', 'Secondary', '164 School Road, Soroti, Soroti', 'Science fair participant'),
(675, 675, 'Peter Opio', 55, '+256701734978', 'peter.opio17@gmail.com', 'Civil Servant', 'Diploma', 'Alice Mugabe', 49, '+256771269379', 'alice.532@gmail.com', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(676, 676, 'Moses Kato', 54, '+256783341787', 'moses.kato47@gmail.com', 'Shopkeeper', 'Diploma', 'Pritah Okello', 39, '+256753098487', 'pritah.2@gmail.com', 'Trader', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(677, 677, 'Paul Busingye', 52, '+256753137619', 'paul.busingye64@gmail.com', 'Carpenter', 'Diploma', 'Ritah Busingye', 35, '+256784236354', 'ritah.53@gmail.com', 'Housewife', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(678, 678, 'Joseph Ssemwogerere', 57, '+256788085157', 'joseph.ssemwogerere0@gmail.com', 'Engineer', 'Master’s Degree', 'Grace Namukasa', 29, '+256752365962', 'grace.99@gmail.com', 'Entrepreneur', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(679, 679, 'Moses Okello', 42, '+256777007508', 'moses.okello25@gmail.com', 'Civil Servant', 'Bachelor’s Degree', 'Pritah Ochieng', 34, '+256706870353', 'pritah.27@gmail.com', 'Housewife', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(680, 680, 'Peter Aine', 31, '+256753687141', 'peter.aine58@gmail.com', 'Engineer', 'Primary', 'Alice Akello', 29, '+256704679858', 'alice.851@gmail.com', 'Trader', 'Master’s Degree', 'Patrick Aine', 'Uncle', 75, '+256774265814', 'patrick.10@yahoo.com', 'Doctor', 'Diploma', '430 Central Avenue, Jinja, Jinja', 'Choir member'),
(681, 681, 'Isaac Mukasa', 44, '+256774136096', 'isaac.mukasa67@gmail.com', 'Civil Servant', 'Bachelor’s Degree', 'Winnie Tumusiime', 61, '+256789907666', 'winnie.975@gmail.com', 'Civil Servant', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(682, 682, 'John Musoke', 54, '+256777574613', 'john.musoke16@gmail.com', 'Shopkeeper', 'Primary', 'Sarah Nakato', 32, '+256787816338', 'sarah.277@gmail.com', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(683, 683, 'Isaac Akello', 62, '+256757593963', 'isaac.akello59@gmail.com', 'Doctor', 'Bachelor’s Degree', 'Grace Nalubega', 32, '+256752412915', 'grace.720@gmail.com', 'Trader', 'Primary', 'Florence Akello', 'Uncle', 46, '+256704276301', 'florence.48@yahoo.com', 'Carpenter', 'Master’s Degree', '4 Central Avenue, Soroti, Soroti', 'Science fair participant'),
(684, 684, 'David Kyomuhendo', 43, '+256787797751', 'david.kyomuhendo31@gmail.com', 'Civil Servant', 'Bachelor’s Degree', 'Doreen Kato', 54, '+256779902800', 'doreen.936@gmail.com', 'Housewife', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(685, 685, 'Peter Mukasa', 54, '+256751175529', 'peter.mukasa32@gmail.com', 'Teacher', 'Secondary', 'Esther Byaruhanga', 47, '+256751894566', 'esther.765@gmail.com', 'Teacher', 'Secondary', 'Charles Mukasa', 'Father', 37, '+256708354026', 'charles.29@yahoo.com', 'Teacher', 'Diploma', '141 Main Street, Mbarara, Mbarara', 'Football team'),
(686, 686, 'Timothy Ochieng', 47, '+256771621154', 'timothy.ochieng12@gmail.com', 'Carpenter', 'Bachelor’s Degree', 'Sarah Nalubega', 48, '+256788783464', 'sarah.827@gmail.com', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(687, 687, 'Brian Mugabe', 58, '+256789745779', 'brian.mugabe52@gmail.com', 'Teacher', 'Primary', 'Winnie Waiswa', 28, '+256705700204', 'winnie.314@gmail.com', 'Nurse', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(688, 688, 'Solomon Busingye', 67, '+256704296249', 'solomon.busingye40@gmail.com', 'Driver', 'Diploma', 'Joan Kyomuhendo', 39, '+256755957070', 'joan.191@gmail.com', 'Entrepreneur', 'Master’s Degree', 'Rose Busingye', 'Mother', 54, '+256702734094', 'rose.96@yahoo.com', 'Civil Servant', 'Secondary', '261 Hospital View, Lira, Lira', 'Active in debate club'),
(689, 689, 'Joseph Opio', 60, '+256753321287', 'joseph.opio30@gmail.com', 'Carpenter', 'Primary', 'Mary Aine', 42, '+256707401454', 'mary.506@gmail.com', 'Tailor', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(690, 690, 'Joseph Musoke', 34, '+256757899919', 'joseph.musoke8@gmail.com', 'Engineer', 'Diploma', 'Grace Kyomuhendo', 28, '+256755054236', 'grace.672@gmail.com', 'Nurse', 'Secondary', 'Florence Musoke', 'Aunt', 29, '+256784831966', 'florence.56@yahoo.com', 'Civil Servant', 'Diploma', '473 Market Lane, Gulu, Gulu', 'Prefect'),
(691, 691, 'Solomon Nantogo', 34, '+256782123180', 'solomon.nantogo9@gmail.com', 'Farmer', 'Bachelor’s Degree', 'Pritah Musoke', 40, '+256706495970', 'pritah.232@gmail.com', 'Entrepreneur', 'Master’s Degree', 'Hellen Nantogo', 'Father', 71, '+256772947340', 'hellen.54@yahoo.com', 'Mechanic', 'Primary', '438 Central Avenue, Soroti, Soroti', 'Science fair participant'),
(692, 692, 'Brian Mugabe', 68, '+256703659927', 'brian.mugabe16@gmail.com', 'Engineer', 'Master’s Degree', 'Winnie Lwanga', 48, '+256759710021', 'winnie.690@gmail.com', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club');
INSERT INTO `parents` (`ParentId`, `AdmissionNo`, `father_name`, `father_age`, `father_contact`, `father_email`, `father_occupation`, `father_education`, `mother_name`, `mother_age`, `mother_contact`, `mother_email`, `mother_occupation`, `mother_education`, `guardian_name`, `guardian_relation`, `guardian_age`, `guardian_contact`, `guardian_email`, `guardian_occupation`, `guardian_education`, `guardian_address`, `MoreInformation`) VALUES
(693, 693, 'John Byaruhanga', 54, '+256774687328', 'john.byaruhanga76@gmail.com', 'Carpenter', 'Primary', 'Pritah Akello', 54, '+256787706207', 'pritah.188@gmail.com', 'Entrepreneur', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(694, 694, 'Solomon Nakato', 45, '+256778395862', 'solomon.nakato56@gmail.com', 'Farmer', 'Bachelor’s Degree', 'Grace Aine', 46, '+256785129134', 'grace.574@gmail.com', 'Housewife', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(695, 695, 'Joseph Waiswa', 63, '+256702859481', 'joseph.waiswa68@gmail.com', 'Farmer', 'Primary', 'Sandra Kato', 49, '+256757534789', 'sandra.951@gmail.com', 'Nurse', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(696, 696, 'Joseph Mukasa', 65, '+256759662595', 'joseph.mukasa94@gmail.com', 'Shopkeeper', 'Secondary', 'Rebecca Byaruhanga', 38, '+256708893439', 'rebecca.381@gmail.com', 'Farmer', 'Secondary', 'Robert Mukasa', 'Mother', 29, '+256758373543', 'robert.33@yahoo.com', 'Civil Servant', 'Diploma', '134 Church Road, Mbarara, Mbarara', 'Choir member'),
(697, 697, 'Timothy Mukasa', 57, '+256787921445', 'timothy.mukasa39@gmail.com', 'Farmer', 'Master’s Degree', 'Joy Musoke', 39, '+256752723332', 'joy.179@gmail.com', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(698, 698, 'Timothy Aine', 32, '+256704868639', 'timothy.aine7@gmail.com', 'Farmer', 'Diploma', 'Mercy Kato', 60, '+256779599702', 'mercy.150@gmail.com', 'Entrepreneur', 'Secondary', 'James Aine', 'Grandparent', 57, '+256753252185', 'james.28@yahoo.com', 'Mechanic', 'Bachelor’s Degree', '149 Church Road, Arua, Arua', 'Active in debate club'),
(699, 699, 'David Nantogo', 59, '+256756368024', 'david.nantogo30@gmail.com', 'Civil Servant', 'Diploma', 'Joy Nantogo', 48, '+256707530352', 'joy.744@gmail.com', 'Trader', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(700, 700, 'Moses Aine', 51, '+256759549214', 'moses.aine67@gmail.com', 'Shopkeeper', 'Bachelor’s Degree', 'Joan Tumusiime', 40, '+256755316539', 'joan.352@gmail.com', 'Trader', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(701, 701, 'Peter Byaruhanga', 56, '+256773461147', 'peter.byaruhanga29@gmail.com', 'Engineer', 'Primary', 'Sarah Musoke', 40, '+256774158845', 'sarah.677@gmail.com', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(702, 702, 'Paul Okello', 33, '+256786171601', 'paul.okello95@gmail.com', 'Driver', 'Secondary', 'Winnie Byaruhanga', 63, '+256755301218', 'winnie.479@gmail.com', 'Tailor', 'Primary', 'Hellen Okello', 'Mother', 52, '+256705471390', 'hellen.13@yahoo.com', 'Mechanic', 'Primary', '41 Market Lane, Masaka, Masaka', 'Active in debate club'),
(703, 703, 'Daniel Lwanga', 43, '+256752774733', 'daniel.lwanga18@gmail.com', 'Farmer', 'Bachelor’s Degree', 'Brenda Lwanga', 63, '+256788872093', 'brenda.716@gmail.com', 'Civil Servant', 'Diploma', 'Alice Lwanga', 'Mother', 79, '+256774811304', 'alice.69@yahoo.com', 'Doctor', 'Diploma', '332 Main Street, Gulu, Gulu', 'Football team'),
(704, 704, 'Brian Waiswa', 52, '+256703944501', 'brian.waiswa30@gmail.com', 'Carpenter', 'Bachelor’s Degree', 'Alice Tumusiime', 38, '+256709462268', 'alice.622@gmail.com', 'Trader', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(705, 705, 'Moses Namukasa', 50, '+256701375502', 'moses.namukasa71@gmail.com', 'Engineer', 'Secondary', 'Grace Mukasa', 47, '+256782508285', 'grace.208@gmail.com', 'Nurse', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(706, 706, 'David Musoke', 67, '+256782942530', 'david.musoke31@gmail.com', 'Civil Servant', 'Bachelor’s Degree', 'Doreen Musoke', 43, '+256704770908', 'doreen.334@gmail.com', 'Nurse', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(707, 707, 'John Ssemwogerere', 56, '+256753963915', 'john.ssemwogerere13@gmail.com', 'Mechanic', 'Bachelor’s Degree', 'Brenda Okello', 57, '+256784695874', 'brenda.207@gmail.com', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(708, 708, 'Isaac Nantogo', 60, '+256786039474', 'isaac.nantogo28@gmail.com', 'Mechanic', 'Secondary', 'Mary Okello', 52, '+256755249264', 'mary.614@gmail.com', 'Tailor', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(709, 709, 'Daniel Lwanga', 35, '+256756503972', 'daniel.lwanga98@gmail.com', 'Civil Servant', 'Secondary', 'Alice Aine', 58, '+256781449861', 'alice.794@gmail.com', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(710, 710, 'Ivan Aine', 30, '+256777311279', 'ivan.aine41@gmail.com', 'Carpenter', 'Master’s Degree', 'Sandra Aine', 61, '+256789045190', 'sandra.119@gmail.com', 'Farmer', 'Secondary', 'Charles Aine', 'Aunt', 27, '+256779140433', 'charles.25@yahoo.com', 'Driver', 'Diploma', '405 Hospital View, Gulu, Gulu', 'Science fair participant'),
(711, 711, 'Peter Ochieng', 55, '+256782483828', 'peter.ochieng41@gmail.com', 'Carpenter', 'Secondary', 'Joan Tumusiime', 30, '+256757021519', 'joan.812@gmail.com', 'Housewife', 'Primary', 'Rose Ochieng', 'Grandparent', 25, '+256708934295', 'rose.46@yahoo.com', 'Mechanic', 'Master’s Degree', '263 Church Road, Lira, Lira', 'Choir member'),
(712, 712, 'Joseph Byaruhanga', 62, '+256703346771', 'joseph.byaruhanga90@gmail.com', 'Doctor', 'Master’s Degree', 'Ritah Akello', 49, '+256773369435', 'ritah.871@gmail.com', 'Teacher', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(713, 713, 'Moses Okello', 40, '+256754294917', 'moses.okello7@gmail.com', 'Farmer', 'Bachelor’s Degree', 'Ritah Kyomuhendo', 63, '+256779157465', 'ritah.933@gmail.com', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(714, 714, 'Ivan Nakato', 42, '+256773876293', 'ivan.nakato5@gmail.com', 'Engineer', 'Master’s Degree', 'Ritah Akello', 28, '+256784494096', 'ritah.36@gmail.com', 'Entrepreneur', 'Master’s Degree', 'Susan Nakato', 'Aunt', 46, '+256785661899', 'susan.23@yahoo.com', 'Teacher', 'Secondary', '154 Market Lane, Gulu, Gulu', 'Active in debate club'),
(715, 715, 'Timothy Ochieng', 56, '+256757450842', 'timothy.ochieng75@gmail.com', 'Teacher', 'Primary', 'Doreen Mukasa', 46, '+256776683769', 'doreen.677@gmail.com', 'Tailor', 'Bachelor’s Degree', 'Rose Ochieng', 'Uncle', 79, '+256759115634', 'rose.42@yahoo.com', 'Shopkeeper', 'Primary', '409 Hospital View, Mbarara, Mbarara', 'Prefect'),
(716, 716, 'Peter Mukasa', 54, '+256703042163', 'peter.mukasa84@gmail.com', 'Engineer', 'Diploma', 'Doreen Namukasa', 44, '+256771798868', 'doreen.942@gmail.com', 'Tailor', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(717, 717, 'Joseph Ochieng', 58, '+256756572355', 'joseph.ochieng90@gmail.com', 'Carpenter', 'Primary', 'Mary Busingye', 61, '+256754442308', 'mary.411@gmail.com', 'Teacher', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(718, 718, 'Daniel Tumusiime', 39, '+256707614351', 'daniel.tumusiime68@gmail.com', 'Teacher', 'Bachelor’s Degree', 'Mercy Busingye', 52, '+256781149404', 'mercy.542@gmail.com', 'Civil Servant', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(719, 719, 'Moses Ssemwogerere', 37, '+256702195916', 'moses.ssemwogerere71@gmail.com', 'Carpenter', 'Diploma', 'Joan Musoke', 39, '+256704783164', 'joan.311@gmail.com', 'Trader', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(720, 720, 'Isaac Kato', 36, '+256776224711', 'isaac.kato18@gmail.com', 'Doctor', 'Primary', 'Joan Waiswa', 43, '+256778205975', 'joan.761@gmail.com', 'Housewife', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(721, 721, 'Andrew Namukasa', 31, '+256785735737', 'andrew.namukasa12@gmail.com', 'Carpenter', 'Master’s Degree', 'Sarah Nakato', 56, '+256783883014', 'sarah.347@gmail.com', 'Housewife', 'Master’s Degree', 'Susan Namukasa', 'Father', 39, '+256778562724', 'susan.12@yahoo.com', 'Carpenter', 'Bachelor’s Degree', '291 Church Road, Arua, Arua', 'Football team'),
(722, 722, 'Brian Nalubega', 68, '+256704094001', 'brian.nalubega39@gmail.com', 'Shopkeeper', 'Primary', 'Sarah Nakato', 46, '+256787043998', 'sarah.903@gmail.com', 'Housewife', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(723, 723, 'Brian Kyomuhendo', 45, '+256777639021', 'brian.kyomuhendo31@gmail.com', 'Teacher', 'Master’s Degree', 'Sandra Nakato', 61, '+256754465095', 'sandra.213@gmail.com', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(724, 724, 'Timothy Byaruhanga', 44, '+256771010634', 'timothy.byaruhanga86@gmail.com', 'Doctor', 'Primary', 'Sandra Mugabe', 29, '+256703442580', 'sandra.568@gmail.com', 'Tailor', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(725, 725, 'David Kyomuhendo', 42, '+256783459081', 'david.kyomuhendo61@gmail.com', 'Civil Servant', 'Diploma', 'Joy Byaruhanga', 53, '+256788685531', 'joy.451@gmail.com', 'Farmer', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(726, 726, 'Paul Opio', 51, '+256755867751', 'paul.opio3@gmail.com', 'Shopkeeper', 'Secondary', 'Rebecca Byaruhanga', 64, '+256701677873', 'rebecca.244@gmail.com', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(727, 727, 'Andrew Kyomuhendo', 31, '+256786217742', 'andrew.kyomuhendo35@gmail.com', 'Teacher', 'Secondary', 'Sandra Lwanga', 63, '+256771873045', 'sandra.48@gmail.com', 'Trader', 'Secondary', 'Susan Kyomuhendo', 'Grandparent', 54, '+256751962022', 'susan.41@yahoo.com', 'Engineer', 'Diploma', '327 Main Street, Gulu, Gulu', 'Choir member'),
(728, 728, 'Mark Ochieng', 44, '+256707626911', 'mark.ochieng31@gmail.com', 'Carpenter', 'Primary', 'Esther Mugabe', 39, '+256701478546', 'esther.91@gmail.com', 'Farmer', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(729, 729, 'Andrew Kyomuhendo', 43, '+256774168609', 'andrew.kyomuhendo67@gmail.com', 'Shopkeeper', 'Primary', 'Joan Okello', 34, '+256701182516', 'joan.249@gmail.com', 'Farmer', 'Secondary', 'Rose Kyomuhendo', 'Uncle', 78, '+256757140985', 'rose.50@yahoo.com', 'Engineer', 'Bachelor’s Degree', '31 Hospital View, Soroti, Soroti', 'Science fair participant'),
(730, 730, 'Daniel Kato', 66, '+256701826610', 'daniel.kato23@gmail.com', 'Mechanic', 'Bachelor’s Degree', 'Rebecca Busingye', 36, '+256703659305', 'rebecca.624@gmail.com', 'Teacher', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(731, 731, 'Samuel Akello', 37, '+256782967477', 'samuel.akello16@gmail.com', 'Engineer', 'Diploma', 'Esther Okello', 32, '+256759699887', 'esther.805@gmail.com', 'Farmer', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(732, 732, 'Timothy Kato', 61, '+256759818747', 'timothy.kato93@gmail.com', 'Farmer', 'Secondary', 'Mary Mugabe', 28, '+256751065067', 'mary.204@gmail.com', 'Tailor', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(733, 733, 'Andrew Kato', 33, '+256705430327', 'andrew.kato11@gmail.com', 'Farmer', 'Secondary', 'Sandra Nalubega', 63, '+256751472020', 'sandra.223@gmail.com', 'Farmer', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(734, 734, 'John Kato', 35, '+256703148253', 'john.kato36@gmail.com', 'Shopkeeper', 'Diploma', 'Mary Ochieng', 46, '+256701389571', 'mary.323@gmail.com', 'Tailor', 'Master’s Degree', 'Hellen Kato', 'Grandparent', 25, '+256784974559', 'hellen.79@yahoo.com', 'Mechanic', 'Master’s Degree', '114 Main Street, Fort Portal, Fort Portal', 'Prefect'),
(735, 735, 'Daniel Mukasa', 55, '+256789292416', 'daniel.mukasa27@gmail.com', 'Doctor', 'Bachelor’s Degree', 'Grace Byaruhanga', 45, '+256779391659', 'grace.253@gmail.com', 'Trader', 'Diploma', 'Susan Mukasa', 'Mother', 59, '+256775430486', 'susan.94@yahoo.com', 'Doctor', 'Diploma', '204 Central Avenue, Mbarara, Mbarara', 'Choir member'),
(736, 736, 'Solomon Kato', 61, '+256788077661', 'solomon.kato2@gmail.com', 'Carpenter', 'Master’s Degree', 'Joy Musoke', 39, '+256789041917', 'joy.198@gmail.com', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(737, 737, 'Paul Namukasa', 47, '+256783201263', 'paul.namukasa43@gmail.com', 'Mechanic', 'Secondary', 'Alice Musoke', 33, '+256781731468', 'alice.77@gmail.com', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(738, 738, 'Ivan Nantogo', 56, '+256708535730', 'ivan.nantogo82@gmail.com', 'Carpenter', 'Secondary', 'Doreen Nakato', 43, '+256784727548', 'doreen.132@gmail.com', 'Civil Servant', 'Secondary', 'Susan Nantogo', 'Father', 38, '+256703599905', 'susan.38@yahoo.com', 'Mechanic', 'Master’s Degree', '238 Market Lane, Jinja, Jinja', 'Active in debate club'),
(739, 739, 'Timothy Akello', 64, '+256781873751', 'timothy.akello82@gmail.com', 'Carpenter', 'Secondary', 'Esther Ssemwogerere', 50, '+256753552386', 'esther.289@gmail.com', 'Farmer', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(740, 740, 'Paul Waiswa', 41, '+256777276416', 'paul.waiswa86@gmail.com', 'Civil Servant', 'Master’s Degree', 'Ritah Tumusiime', 37, '+256771552588', 'ritah.687@gmail.com', 'Farmer', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(741, 741, 'Timothy Aine', 44, '+256704851565', 'timothy.aine12@gmail.com', 'Engineer', 'Primary', 'Alice Kato', 58, '+256754347905', 'alice.788@gmail.com', 'Housewife', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(742, 742, 'David Mukasa', 61, '+256787587301', 'david.mukasa19@gmail.com', 'Engineer', 'Diploma', 'Doreen Ssemwogerere', 28, '+256786213540', 'doreen.548@gmail.com', 'Tailor', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(743, 743, 'Moses Tumusiime', 46, '+256701822223', 'moses.tumusiime53@gmail.com', 'Driver', 'Primary', 'Sarah Namukasa', 30, '+256784366093', 'sarah.436@gmail.com', 'Nurse', 'Master’s Degree', 'Robert Tumusiime', 'Mother', 66, '+256779704887', 'robert.23@yahoo.com', 'Mechanic', 'Secondary', '337 Central Avenue, Soroti, Soroti', 'Football team'),
(744, 744, 'Timothy Byaruhanga', 64, '+256774623369', 'timothy.byaruhanga60@gmail.com', 'Driver', 'Master’s Degree', 'Mary Mugabe', 44, '+256759194794', 'mary.834@gmail.com', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(745, 745, 'Joseph Tumusiime', 48, '+256705239605', 'joseph.tumusiime37@gmail.com', 'Farmer', 'Diploma', 'Esther Akello', 55, '+256751169326', 'esther.959@gmail.com', 'Housewife', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(746, 746, 'Andrew Opio', 56, '+256759323697', 'andrew.opio8@gmail.com', 'Teacher', 'Diploma', 'Brenda Musoke', 58, '+256754485358', 'brenda.997@gmail.com', 'Farmer', 'Secondary', 'Lillian Opio', 'Mother', 28, '+256773592637', 'lillian.42@yahoo.com', 'Driver', 'Secondary', '114 Church Road, Mbale, Mbale', 'Active in debate club'),
(747, 747, 'Solomon Kyomuhendo', 33, '+256708339491', 'solomon.kyomuhendo89@gmail.com', 'Civil Servant', 'Secondary', 'Winnie Namukasa', 44, '+256775028547', 'winnie.559@gmail.com', 'Trader', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(748, 748, 'Moses Waiswa', 66, '+256783963368', 'moses.waiswa37@gmail.com', 'Engineer', 'Secondary', 'Grace Okello', 45, '+256773746720', 'grace.75@gmail.com', 'Nurse', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(749, 749, 'Joseph Nalubega', 57, '+256751031267', 'joseph.nalubega13@gmail.com', 'Teacher', 'Master’s Degree', 'Winnie Busingye', 59, '+256781711659', 'winnie.817@gmail.com', 'Housewife', 'Diploma', 'Lillian Nalubega', 'Aunt', 34, '+256753585832', 'lillian.47@yahoo.com', 'Doctor', 'Master’s Degree', '425 Market Lane, Masaka, Masaka', 'Science fair participant'),
(750, 750, 'John Nantogo', 58, '+256708055328', 'john.nantogo80@gmail.com', 'Teacher', 'Secondary', 'Esther Tumusiime', 30, '+256754195281', 'esther.823@gmail.com', 'Housewife', 'Master’s Degree', 'Robert Nantogo', 'Father', 50, '+256783105584', 'robert.53@yahoo.com', 'Farmer', 'Bachelor’s Degree', '461 Market Lane, Mbale, Mbale', 'Active in debate club'),
(751, 751, 'Andrew Mugabe', 57, '+256786188949', 'andrew.mugabe28@gmail.com', 'Shopkeeper', 'Master’s Degree', 'Winnie Tumusiime', 59, '+256786432799', 'winnie.329@gmail.com', 'Farmer', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(752, 752, 'Brian Byaruhanga', 50, '+256703076541', 'brian.byaruhanga83@gmail.com', 'Teacher', 'Bachelor’s Degree', 'Grace Nakato', 44, '+256757073692', 'grace.494@gmail.com', 'Housewife', 'Diploma', 'Patrick Byaruhanga', 'Other', 28, '+256788776168', 'patrick.49@yahoo.com', 'Shopkeeper', 'Bachelor’s Degree', '124 Main Street, Masaka, Masaka', 'Choir member'),
(753, 753, 'Samuel Ssemwogerere', 50, '+256707418902', 'samuel.ssemwogerere12@gmail.com', 'Farmer', 'Primary', 'Sandra Nakato', 63, '+256753107478', 'sandra.929@gmail.com', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(754, 754, 'Peter Okello', 36, '+256701800774', 'peter.okello28@gmail.com', 'Mechanic', 'Primary', 'Doreen Musoke', 46, '+256709144369', 'doreen.441@gmail.com', 'Farmer', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(755, 755, 'Andrew Mukasa', 42, '+256702037837', 'andrew.mukasa52@gmail.com', 'Mechanic', 'Bachelor’s Degree', 'Sarah Musoke', 64, '+256772664499', 'sarah.909@gmail.com', 'Teacher', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(756, 756, 'Joseph Waiswa', 31, '+256706451014', 'joseph.waiswa96@gmail.com', 'Doctor', 'Secondary', 'Mary Waiswa', 43, '+256706447294', 'mary.646@gmail.com', 'Farmer', 'Diploma', 'Lillian Waiswa', 'Mother', 53, '+256708304044', 'lillian.12@yahoo.com', 'Teacher', 'Master’s Degree', '497 Central Avenue, Soroti, Soroti', 'Science fair participant'),
(757, 757, 'Isaac Nalubega', 60, '+256775549532', 'isaac.nalubega45@gmail.com', 'Driver', 'Master’s Degree', 'Esther Byaruhanga', 57, '+256754911902', 'esther.219@gmail.com', 'Teacher', 'Primary', 'Hellen Nalubega', 'Other', 43, '+256708287047', 'hellen.65@yahoo.com', 'Farmer', 'Bachelor’s Degree', '221 Church Road, Lira, Lira', 'Football team'),
(758, 758, 'David Busingye', 51, '+256759204889', 'david.busingye64@gmail.com', 'Civil Servant', 'Master’s Degree', 'Winnie Nantogo', 34, '+256787335850', 'winnie.858@gmail.com', 'Teacher', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(759, 759, 'Samuel Mukasa', 47, '+256703008354', 'samuel.mukasa2@gmail.com', 'Farmer', 'Secondary', 'Pritah Lwanga', 52, '+256783154342', 'pritah.874@gmail.com', 'Civil Servant', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(760, 760, 'David Opio', 50, '+256702033306', 'david.opio17@gmail.com', 'Teacher', 'Master’s Degree', 'Brenda Kato', 59, '+256709050964', 'brenda.304@gmail.com', 'Teacher', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(761, 761, 'Solomon Namukasa', 39, '+256704047529', 'solomon.namukasa24@gmail.com', 'Engineer', 'Diploma', 'Winnie Kyomuhendo', 38, '+256773241922', 'winnie.6@gmail.com', 'Tailor', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(762, 762, 'Moses Musoke', 64, '+256751151646', 'moses.musoke97@gmail.com', 'Engineer', 'Primary', 'Mercy Byaruhanga', 59, '+256751005496', 'mercy.368@gmail.com', 'Nurse', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(763, 763, 'Mark Busingye', 30, '+256776590889', 'mark.busingye96@gmail.com', 'Farmer', 'Master’s Degree', 'Ritah Nalubega', 36, '+256707672972', 'ritah.490@gmail.com', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(764, 764, 'Moses Waiswa', 65, '+256705944658', 'moses.waiswa50@gmail.com', 'Mechanic', 'Primary', 'Pritah Lwanga', 28, '+256759455895', 'pritah.565@gmail.com', 'Teacher', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(765, 765, 'Isaac Ochieng', 38, '+256779734187', 'isaac.ochieng42@gmail.com', 'Carpenter', 'Secondary', 'Ritah Nantogo', 52, '+256775217680', 'ritah.615@gmail.com', 'Trader', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(766, 766, 'David Aine', 46, '+256778267886', 'david.aine36@gmail.com', 'Mechanic', 'Secondary', 'Grace Lwanga', 60, '+256708931471', 'grace.503@gmail.com', 'Entrepreneur', 'Bachelor’s Degree', 'Patrick Aine', 'Uncle', 51, '+256781347332', 'patrick.31@yahoo.com', 'Mechanic', 'Primary', '167 Hospital View, Mbarara, Mbarara', 'Active in debate club'),
(767, 767, 'Brian Ochieng', 58, '+256751292711', 'brian.ochieng35@gmail.com', 'Engineer', 'Primary', 'Sarah Okello', 38, '+256751762715', 'sarah.908@gmail.com', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(768, 768, 'Solomon Ssemwogerere', 59, '+256785720624', 'solomon.ssemwogerere85@gmail.com', 'Farmer', 'Secondary', 'Ritah Aine', 49, '+256756580912', 'ritah.885@gmail.com', 'Farmer', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(769, 769, 'Solomon Musoke', 56, '+256755310514', 'solomon.musoke21@gmail.com', 'Shopkeeper', 'Primary', 'Joan Akello', 59, '+256707816415', 'joan.424@gmail.com', 'Entrepreneur', 'Diploma', 'Lillian Musoke', 'Grandparent', 79, '+256759060006', 'lillian.87@yahoo.com', 'Civil Servant', 'Master’s Degree', '58 Hospital View, Fort Portal, Fort Portal', 'Science fair participant'),
(770, 770, 'Andrew Lwanga', 35, '+256756346155', 'andrew.lwanga97@gmail.com', 'Civil Servant', 'Secondary', 'Joan Akello', 52, '+256757373393', 'joan.557@gmail.com', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(771, 771, 'Samuel Ssemwogerere', 39, '+256752455899', 'samuel.ssemwogerere14@gmail.com', 'Carpenter', 'Secondary', 'Doreen Waiswa', 56, '+256774063809', 'doreen.156@gmail.com', 'Teacher', 'Diploma', 'Charles Ssemwogerere', 'Father', 76, '+256709679604', 'charles.37@yahoo.com', 'Shopkeeper', 'Diploma', '163 Market Lane, Masaka, Masaka', 'Prefect'),
(772, 772, 'Joseph Nakato', 54, '+256777511166', 'joseph.nakato15@gmail.com', 'Shopkeeper', 'Master’s Degree', 'Joy Mugabe', 48, '+256789194244', 'joy.257@gmail.com', 'Nurse', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(773, 773, 'Peter Aine', 48, '+256703887499', 'peter.aine27@gmail.com', 'Engineer', 'Bachelor’s Degree', 'Sarah Nantogo', 59, '+256707593150', 'sarah.208@gmail.com', 'Trader', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(774, 774, 'Paul Mukasa', 40, '+256708992696', 'paul.mukasa18@gmail.com', 'Carpenter', 'Primary', 'Esther Lwanga', 50, '+256703460752', 'esther.286@gmail.com', 'Farmer', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(775, 775, 'David Mukasa', 60, '+256703125989', 'david.mukasa68@gmail.com', 'Civil Servant', 'Secondary', 'Sandra Nalubega', 63, '+256752334232', 'sandra.682@gmail.com', 'Housewife', 'Primary', 'Charles Mukasa', 'Father', 59, '+256704357935', 'charles.82@yahoo.com', 'Teacher', 'Diploma', '218 Church Road, Lira, Lira', 'Choir member'),
(776, 776, 'Samuel Akello', 39, '+256759152082', 'samuel.akello98@gmail.com', 'Farmer', 'Secondary', 'Pritah Mugabe', 42, '+256755864665', 'pritah.601@gmail.com', 'Farmer', 'Diploma', 'Alice Akello', 'Other', 53, '+256781201012', 'alice.57@yahoo.com', 'Teacher', 'Diploma', '486 Hospital View, Masaka, Masaka', 'Football team'),
(777, 777, 'Peter Waiswa', 65, '+256703723609', 'peter.waiswa15@gmail.com', 'Mechanic', 'Primary', 'Mercy Tumusiime', 32, '+256785670753', 'mercy.935@gmail.com', 'Housewife', 'Bachelor’s Degree', 'Rose Waiswa', 'Father', 63, '+256701252969', 'rose.63@yahoo.com', 'Farmer', 'Diploma', '364 Church Road, Gulu, Gulu', 'Active in debate club'),
(778, 778, 'Brian Nantogo', 64, '+256782275610', 'brian.nantogo25@gmail.com', 'Driver', 'Primary', 'Rebecca Busingye', 49, '+256778090473', 'rebecca.389@gmail.com', 'Housewife', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(779, 779, 'Peter Aine', 42, '+256704320226', 'peter.aine47@gmail.com', 'Teacher', 'Diploma', 'Pritah Mukasa', 36, '+256752956163', 'pritah.576@gmail.com', 'Tailor', 'Diploma', 'Patrick Aine', 'Other', 43, '+256785876642', 'patrick.11@yahoo.com', 'Mechanic', 'Diploma', '498 Church Road, Gulu, Gulu', 'Science fair participant'),
(780, 780, 'Brian Namukasa', 63, '+256773594190', 'brian.namukasa73@gmail.com', 'Mechanic', 'Secondary', 'Brenda Kyomuhendo', 50, '+256776142577', 'brenda.464@gmail.com', 'Civil Servant', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(781, 781, 'Mark Okello', 36, '+256704995271', 'mark.okello9@gmail.com', 'Driver', 'Secondary', 'Ritah Tumusiime', 31, '+256773761919', 'ritah.802@gmail.com', 'Nurse', 'Primary', 'Susan Okello', 'Mother', 35, '+256788731414', 'susan.76@yahoo.com', 'Teacher', 'Bachelor’s Degree', '139 School Road, Soroti, Soroti', 'Prefect'),
(782, 782, 'Samuel Tumusiime', 51, '+256777883298', 'samuel.tumusiime55@gmail.com', 'Mechanic', 'Secondary', 'Sarah Kato', 34, '+256787359100', 'sarah.260@gmail.com', 'Farmer', 'Primary', 'Lillian Tumusiime', 'Aunt', 35, '+256775474572', 'lillian.20@yahoo.com', 'Doctor', 'Bachelor’s Degree', '221 School Road, Soroti, Soroti', 'Science fair participant'),
(783, 783, 'Brian Mugabe', 44, '+256783513545', 'brian.mugabe83@gmail.com', 'Doctor', 'Secondary', 'Esther Mukasa', 54, '+256706922656', 'esther.135@gmail.com', 'Nurse', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Choir member'),
(784, 784, 'Peter Nantogo', 63, '+256773059928', 'peter.nantogo10@gmail.com', 'Carpenter', 'Bachelor’s Degree', 'Brenda Kyomuhendo', 51, '+256705372535', 'brenda.419@gmail.com', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(785, 785, 'Moses Kyomuhendo', 43, '+256702213811', 'moses.kyomuhendo74@gmail.com', 'Driver', 'Secondary', 'Alice Ochieng', 60, '+256789135999', 'alice.919@gmail.com', 'Civil Servant', 'Bachelor’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(786, 786, 'Peter Musoke', 64, '+256788824071', 'peter.musoke9@gmail.com', 'Teacher', 'Bachelor’s Degree', 'Winnie Mukasa', 38, '+256709058811', 'winnie.195@gmail.com', 'Entrepreneur', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(787, 787, 'John Nalubega', 56, '+256785219848', 'john.nalubega60@gmail.com', 'Engineer', 'Secondary', 'Alice Nantogo', 54, '+256709986617', 'alice.938@gmail.com', 'Civil Servant', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(788, 788, 'Daniel Tumusiime', 35, '+256772355994', 'daniel.tumusiime11@gmail.com', 'Engineer', 'Secondary', 'Ritah Busingye', 55, '+256774541759', 'ritah.581@gmail.com', 'Entrepreneur', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(789, 789, 'Ivan Ssemwogerere', 56, '+256755788389', 'ivan.ssemwogerere84@gmail.com', 'Civil Servant', 'Bachelor’s Degree', 'Ritah Aine', 63, '+256705181101', 'ritah.870@gmail.com', 'Farmer', 'Primary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(790, 790, 'Moses Nalubega', 30, '+256784095445', 'moses.nalubega40@gmail.com', 'Carpenter', 'Secondary', 'Winnie Waiswa', 30, '+256708567927', 'winnie.715@gmail.com', 'Farmer', 'Diploma', 'Patrick Nalubega', 'Uncle', 73, '+256781051277', 'patrick.8@yahoo.com', 'Farmer', 'Master’s Degree', '186 Hospital View, Fort Portal, Fort Portal', 'Choir member'),
(791, 791, 'Joseph Okello', 33, '+256775529850', 'joseph.okello11@gmail.com', 'Teacher', 'Master’s Degree', 'Rebecca Kato', 51, '+256753227155', 'rebecca.277@gmail.com', 'Tailor', 'Primary', 'Patrick Okello', 'Father', 26, '+256773508119', 'patrick.36@yahoo.com', 'Teacher', 'Primary', '183 School Road, Fort Portal, Fort Portal', 'Prefect'),
(792, 792, 'Mark Byaruhanga', 44, '+256784220802', 'mark.byaruhanga87@gmail.com', 'Farmer', 'Diploma', 'Joan Kyomuhendo', 37, '+256786138418', 'joan.591@gmail.com', 'Tailor', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(793, 793, 'Andrew Waiswa', 44, '+256773974071', 'andrew.waiswa6@gmail.com', 'Shopkeeper', 'Bachelor’s Degree', 'Winnie Busingye', 48, '+256753419346', 'winnie.269@gmail.com', 'Entrepreneur', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(794, 794, 'Paul Nantogo', 36, '+256701962677', 'paul.nantogo9@gmail.com', 'Driver', 'Master’s Degree', 'Sandra Nantogo', 44, '+256707405306', 'sandra.717@gmail.com', 'Farmer', 'Secondary', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(795, 795, 'Isaac Mukasa', 50, '+256786507600', 'isaac.mukasa46@gmail.com', 'Farmer', 'Primary', 'Sarah Mukasa', 52, '+256777819856', 'sarah.189@gmail.com', 'Housewife', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Football team'),
(796, 796, 'Brian Nalubega', 51, '+256781988301', 'brian.nalubega56@gmail.com', 'Mechanic', 'Secondary', 'Grace Musoke', 36, '+256786131825', 'grace.185@gmail.com', 'Trader', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Science fair participant'),
(797, 797, 'Moses Nakato', 49, '+256704707943', 'moses.nakato93@gmail.com', 'Shopkeeper', 'Bachelor’s Degree', 'Esther Waiswa', 30, '+256774181470', 'esther.223@gmail.com', 'Trader', 'Master’s Degree', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Prefect'),
(798, 798, 'John Byaruhanga', 42, '+256709355158', 'john.byaruhanga41@gmail.com', 'Engineer', 'Master’s Degree', 'Winnie Kyomuhendo', 44, '+256771911297', 'winnie.348@gmail.com', 'Farmer', 'Diploma', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active in debate club'),
(799, 799, 'Ivan Ochieng', 49, '+256788049226', 'ivan.ochieng36@gmail.com', 'Engineer', 'Secondary', 'Rebecca Nakato', 44, '+256785260299', 'rebecca.972@gmail.com', 'Teacher', 'Secondary', 'James Ochieng', '', 67, '+256755876181', 'james.53@yahoo.com', 'Shopkeeper', 'Master’s Degree', '327 Hospital View, Gulu, Gulu', 'Active in debate club'),
(806, 814, 'Prabhakar', 44, '+256789098789', 'prabhakar@gmail.com', 'Teacher', 'Master’s Degree', 'Mani', 27, '+256707599287', '0', 'Teacher', 'Master’s Degree', '0', 'Aunt', 23, '+256889087687', 'ramesh@gmail.com', 'Software Developer', NULL, 'Hyderabad', ''),
(807, 818, 'Prabhakar', 44, '+256789098789', 'prabhakar@gmail.com', 'Teacher', 'Master’s Degree', 'Mani', 27, '+256707599287', 'mani@gmail.com', 'Teacher', 'Master’s Degree', 'Ramesh Kethavath', 'Grandparent', 23, '+256889087687', 'ramesh@gmail.com', 'Software Developer', NULL, 'Hyderabad', ''),
(808, 819, 'Prabhakar', 44, '+256789098789', 'prabhakar@gmail.com', 'Teacher', 'Master’s Degree', 'Mani', 27, '+256707599287', 'mani@gmail.com', 'Teacher', 'Master’s Degree', 'Ramesh Kethavath', 'Uncle', 23, '+256889087687', 'ramesh@gmail.com', 'Software Developer', NULL, 'Hyderabad', ''),
(809, 821, 'Prabhakar', 44, '+256789098789', 'prabhakar@gmail.com', 'Teacher', 'Master’s Degree', 'Mani', 27, '+256707599287', 'mani@gmail.com', 'Teacher', 'Master’s Degree', 'Ramesh Kethavath', '', 23, '+256889087687', 'ramesh@gmail.com', 'Software Developer', NULL, 'Hyderabad', '');

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `AdmissionNo` int(11) NOT NULL,
  `AdmissionYear` year(4) NOT NULL,
  `Name` varchar(100) DEFAULT NULL,
  `Surname` varchar(100) NOT NULL,
  `DateOfBirth` date NOT NULL,
  `Gender` varchar(10) NOT NULL,
  `HouseNo` varchar(50) DEFAULT NULL,
  `Street` varchar(100) DEFAULT NULL,
  `Village` varchar(100) DEFAULT NULL,
  `Town` varchar(100) DEFAULT NULL,
  `District` varchar(100) DEFAULT NULL,
  `State` varchar(100) DEFAULT NULL,
  `Country` varchar(100) DEFAULT 'Uganda',
  `PhotoPath` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`AdmissionNo`, `AdmissionYear`, `Name`, `Surname`, `DateOfBirth`, `Gender`, `HouseNo`, `Street`, `Village`, `Town`, `District`, `State`, `Country`, `PhotoPath`) VALUES
(1, '2025', 'Samuel', 'Ochieng', '2007-05-19', 'Male', '318', 'Hospital View', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(2, '2025', 'Brenda', 'Nantogo', '2008-02-06', 'Female', '234', 'Market Lane', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(3, '2025', 'Isaac', 'Ssemwogerere', '2009-10-13', 'Male', '497', 'Main Street', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(4, '2025', 'Grace', 'Kato', '2008-12-16', 'Female', '223', 'Central Avenue', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(5, '2025', 'Joan', 'Tumusiime', '2005-06-23', 'Female', '130', 'Main Street', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(6, '2025', 'Mark', 'Aine', '2006-03-21', 'Male', '312', 'Market Lane', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(7, '2025', 'Moses', 'Byaruhanga', '2009-11-17', 'Male', '197', 'Main Street', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(8, '2025', 'Moses', 'Byaruhanga', '2005-08-06', 'Male', '44', 'Main Street', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(9, '2025', 'Ritah', 'Akello', '2005-10-11', 'Female', '73', 'Church Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(10, '2025', 'Ritah', 'Tumusiime', '2009-06-04', 'Female', '362', 'Central Avenue', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(11, '2025', 'Moses', 'Kato', '2008-04-05', 'Male', '410', 'Main Street', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(12, '2025', 'Ritah', 'Nantogo', '2006-02-22', 'Female', '207', 'Market Lane', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(13, '2025', 'Sandra', 'Ochieng', '2005-09-24', 'Female', '74', 'Church Road', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(14, '2025', 'Joy', 'Nalubega', '2008-10-21', 'Female', '101', 'Hospital View', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(15, '2025', 'Mark', 'Kato', '2006-08-05', 'Male', '1', 'Main Street', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(16, '2025', 'Sarah', 'Musoke', '2007-09-16', 'Female', '236', 'Hospital View', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(17, '2025', 'Esther', 'Kyomuhendo', '2008-12-05', 'Female', '400', 'School Road', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(18, '2025', 'Sandra', 'Aine', '2007-12-14', 'Female', '209', 'Church Road', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(19, '2025', 'Doreen', 'Namukasa', '2008-12-26', 'Female', '441', 'Main Street', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(20, '2025', 'Doreen', 'Opio', '2007-09-02', 'Female', '328', 'Hospital View', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(21, '2025', 'Joan', 'Tumusiime', '2006-11-08', 'Female', '242', 'Church Road', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(22, '2025', 'Moses', 'Nantogo', '2005-11-19', 'Male', '171', 'Church Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(23, '2025', 'Ritah', 'Nalubega', '2007-11-03', 'Female', '88', 'Church Road', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(24, '2025', 'Ivan', 'Opio', '2007-08-23', 'Male', '99', 'Market Lane', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(25, '2025', 'Samuel', 'Byaruhanga', '2009-05-06', 'Male', '364', 'Main Street', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(26, '2025', 'David', 'Nakato', '2009-08-18', 'Male', '176', 'Central Avenue', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(27, '2025', 'Mary', 'Nakato', '2008-03-03', 'Female', '73', 'Hospital View', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(28, '2025', 'Esther', 'Ochieng', '2006-06-30', 'Female', '240', 'Market Lane', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(29, '2025', 'Peter', 'Busingye', '2008-12-11', 'Male', '475', 'Market Lane', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(30, '2025', 'Peter', 'Mukasa', '2008-11-08', 'Male', '442', 'Main Street', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(31, '2025', 'Timothy', 'Namukasa', '2005-10-24', 'Male', '260', 'Main Street', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(32, '2025', 'Brian', 'Nalubega', '2005-08-16', 'Male', '378', 'Market Lane', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(33, '2025', 'Ritah', 'Busingye', '2008-02-24', 'Female', '218', 'Church Road', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(34, '2025', 'David', 'Namukasa', '2009-05-18', 'Male', '20', 'School Road', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(35, '2025', 'Winnie', 'Mukasa', '2008-01-20', 'Female', '85', 'Main Street', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(36, '2025', 'Joan', 'Waiswa', '2008-03-27', 'Female', '420', 'Church Road', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(37, '2025', 'Sarah', 'Kato', '2007-06-21', 'Female', '46', 'Central Avenue', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(38, '2025', 'Peter', 'Opio', '2008-11-15', 'Male', '31', 'Central Avenue', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(39, '2025', 'Samuel', 'Tumusiime', '2009-11-03', 'Male', '73', 'Hospital View', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(40, '2025', 'Isaac', 'Nalubega', '2005-01-01', 'Male', '115', 'Main Street', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(41, '2025', 'Timothy', 'Lwanga', '2006-01-30', 'Male', '395', 'Church Road', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(42, '2025', 'Timothy', 'Kato', '2008-02-21', 'Male', '454', 'School Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(43, '2025', 'Mary', 'Opio', '2006-01-27', 'Female', '25', 'School Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(44, '2025', 'Andrew', 'Musoke', '2008-06-16', 'Male', '382', 'Hospital View', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(45, '2025', 'Andrew', 'Musoke', '2007-08-16', 'Male', '7', 'Market Lane', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(46, '2025', 'Mark', 'Ssemwogerere', '2005-01-24', 'Male', '243', 'Market Lane', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(47, '2025', 'Mark', 'Opio', '2005-07-05', 'Male', '43', 'Main Street', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(48, '2025', 'Brenda', 'Ochieng', '2005-12-09', 'Female', '107', 'School Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(49, '2025', 'Brenda', 'Ssemwogerere', '2005-05-18', 'Female', '356', 'Church Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(50, '2025', 'Doreen', 'Nalubega', '2006-08-13', 'Female', '229', 'Church Road', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(51, '2025', 'Peter', 'Nalubega', '2007-01-06', 'Male', '86', 'School Road', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(52, '2025', 'Isaac', 'Nantogo', '2006-08-12', 'Male', '498', 'Main Street', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(53, '2025', 'David', 'Musoke', '2008-08-29', 'Male', '180', 'School Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(54, '2025', 'Daniel', 'Ochieng', '2008-02-26', 'Male', '150', 'School Road', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(55, '2025', 'Andrew', 'Aine', '2006-07-14', 'Male', '457', 'School Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(56, '2025', 'Winnie', 'Aine', '2009-04-04', 'Female', '180', 'Church Road', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(57, '2025', 'Mercy', 'Ssemwogerere', '2009-01-30', 'Female', '92', 'Market Lane', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(58, '2025', 'John', 'Byaruhanga', '2006-05-09', 'Male', '170', 'Central Avenue', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(59, '2025', 'Ritah', 'Okello', '2006-10-31', 'Female', '98', 'Central Avenue', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(60, '2025', 'Solomon', 'Waiswa', '2008-12-09', 'Male', '454', 'Church Road', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(61, '2025', 'Peter', 'Busingye', '2008-03-18', 'Male', '166', 'Hospital View', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(62, '2025', 'Brenda', 'Kyomuhendo', '2007-04-18', 'Female', '262', 'Church Road', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(63, '2025', 'Sandra', 'Kato', '2007-04-21', 'Female', '372', 'Church Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(64, '2025', 'Grace', 'Waiswa', '2005-10-18', 'Female', '141', 'Central Avenue', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(65, '2025', 'Ritah', 'Waiswa', '2005-07-31', 'Female', '476', 'Market Lane', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(66, '2025', 'Winnie', 'Musoke', '2009-11-18', 'Female', '489', 'Central Avenue', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(67, '2025', 'Mark', 'Okello', '2009-01-06', 'Male', '262', 'Church Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(68, '2025', 'Joan', 'Nalubega', '2005-05-06', 'Female', '477', 'School Road', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(69, '2025', 'Joseph', 'Nakato', '2006-09-19', 'Male', '293', 'Central Avenue', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(70, '2025', 'Alice', 'Nakato', '2008-03-22', 'Female', '385', 'Central Avenue', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(71, '2025', 'Brenda', 'Namukasa', '2008-12-21', 'Female', '148', 'Main Street', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(72, '2025', 'John', 'Nantogo', '2006-07-21', 'Male', '262', 'Hospital View', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(73, '2025', 'David', 'Okello', '2009-12-26', 'Male', '394', 'Central Avenue', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(74, '2025', 'Sarah', 'Mukasa', '2006-11-29', 'Female', '263', 'Market Lane', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(75, '2025', 'Sandra', 'Namukasa', '2008-08-30', 'Female', '122', 'Main Street', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(76, '2025', 'Esther', 'Waiswa', '2005-08-19', 'Female', '287', 'Market Lane', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(77, '2025', 'Andrew', 'Mukasa', '2006-06-03', 'Male', '354', 'Hospital View', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(78, '2025', 'Solomon', 'Nalubega', '2006-05-28', 'Male', '137', 'School Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(79, '2025', 'Winnie', 'Aine', '2009-06-29', 'Female', '262', 'Central Avenue', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(80, '2025', 'Samuel', 'Nakato', '2006-11-10', 'Male', '81', 'Hospital View', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(81, '2025', 'Ivan', 'Ssemwogerere', '2006-01-13', 'Male', '281', 'Church Road', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(82, '2025', 'Rebecca', 'Mugabe', '2009-12-06', 'Female', '282', 'Central Avenue', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(83, '2025', 'Brian', 'Nakato', '2005-03-08', 'Male', '153', 'Market Lane', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(84, '2025', 'Moses', 'Ssemwogerere', '2007-06-14', 'Male', '484', 'Market Lane', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(85, '2025', 'Joan', 'Tumusiime', '2007-02-28', 'Female', '387', 'School Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(86, '2025', 'Mark', 'Byaruhanga', '2006-07-27', 'Male', '52', 'School Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(87, '2025', 'Andrew', 'Nantogo', '2009-11-21', 'Male', '54', 'School Road', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(88, '2025', 'Timothy', 'Musoke', '2009-01-04', 'Male', '401', 'School Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(89, '2025', 'Joseph', 'Ssemwogerere', '2007-01-11', 'Male', '497', 'Hospital View', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(90, '2025', 'Alice', 'Nalubega', '2005-06-09', 'Female', '422', 'Central Avenue', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(91, '2025', 'Winnie', 'Aine', '2009-08-03', 'Female', '325', 'Market Lane', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(92, '2025', 'Winnie', 'Mukasa', '2009-01-11', 'Female', '20', 'Hospital View', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(93, '2025', 'Joan', 'Aine', '2006-05-10', 'Female', '6', 'Church Road', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(94, '2025', 'Esther', 'Lwanga', '2005-08-13', 'Female', '290', 'School Road', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(95, '2025', 'Paul', 'Lwanga', '2008-09-07', 'Male', '164', 'Market Lane', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(96, '2025', 'Doreen', 'Lwanga', '2009-02-19', 'Female', '38', 'Central Avenue', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(97, '2025', 'Timothy', 'Tumusiime', '2008-07-18', 'Male', '172', 'School Road', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(98, '2025', 'Samuel', 'Musoke', '2005-12-10', 'Male', '72', 'Main Street', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(99, '2025', 'Sarah', 'Aine', '2007-01-26', 'Female', '383', 'School Road', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(100, '2025', 'Solomon', 'Waiswa', '2009-11-19', 'Male', '376', 'Hospital View', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(101, '2025', 'Ritah', 'Kato', '2008-06-02', 'Female', '378', 'Hospital View', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(102, '2025', 'Andrew', 'Opio', '2007-04-26', 'Male', '348', 'Main Street', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(103, '2025', 'Rebecca', 'Aine', '2008-11-24', 'Female', '313', 'Hospital View', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(104, '2025', 'Doreen', 'Nantogo', '2008-06-17', 'Female', '205', 'Central Avenue', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(105, '2025', 'Esther', 'Akello', '2007-03-26', 'Female', '40', 'Main Street', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(106, '2025', 'Sandra', 'Aine', '2006-10-17', 'Female', '172', 'School Road', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(107, '2025', 'Winnie', 'Namukasa', '2005-10-31', 'Female', '454', 'Main Street', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(108, '2025', 'Alice', 'Kato', '2009-05-20', 'Female', '489', 'Church Road', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(109, '2025', 'Solomon', 'Ochieng', '2005-09-17', 'Male', '295', 'School Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(110, '2025', 'Peter', 'Ochieng', '2007-04-20', 'Male', '165', 'Church Road', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(111, '2025', 'Moses', 'Akello', '2005-07-26', 'Male', '82', 'Market Lane', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(112, '2025', 'Moses', 'Mukasa', '2007-11-25', 'Male', '209', 'Market Lane', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(113, '2025', 'Grace', 'Nalubega', '2008-03-10', 'Female', '330', 'Market Lane', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(114, '2025', 'Daniel', 'Nalubega', '2008-10-09', 'Male', '457', 'Church Road', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(115, '2025', 'Joseph', 'Akello', '2007-01-30', 'Male', '472', 'Market Lane', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(116, '2025', 'Alice', 'Kyomuhendo', '2005-04-03', 'Female', '352', 'Market Lane', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(117, '2025', 'Sarah', 'Musoke', '2008-06-24', 'Female', '75', 'School Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(118, '2025', 'Moses', 'Namukasa', '2005-05-15', 'Male', '477', 'School Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(119, '2025', 'Mark', 'Okello', '2009-05-17', 'Male', '433', 'Hospital View', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(120, '2025', 'Isaac', 'Akello', '2007-08-29', 'Male', '12', 'School Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(121, '2025', 'Daniel', 'Kato', '2005-04-22', 'Male', '191', 'Hospital View', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(122, '2025', 'Ivan', 'Opio', '2008-12-31', 'Male', '210', 'Hospital View', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(123, '2025', 'Mary', 'Ochieng', '2009-04-10', 'Female', '42', 'Central Avenue', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(124, '2025', 'Paul', 'Mukasa', '2005-04-13', 'Male', '468', 'School Road', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(125, '2025', 'Esther', 'Nantogo', '2006-04-25', 'Female', '82', 'Main Street', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(126, '2025', 'David', 'Byaruhanga', '2008-04-02', 'Male', '490', 'Central Avenue', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(127, '2025', 'Winnie', 'Mugabe', '2009-06-10', 'Female', '264', 'Central Avenue', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(128, '2025', 'Doreen', 'Akello', '2009-04-14', 'Female', '128', 'Hospital View', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(129, '2025', 'Moses', 'Nantogo', '2009-09-09', 'Male', '134', 'School Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(130, '2025', 'Alice', 'Waiswa', '2006-11-16', 'Female', '220', 'Main Street', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(131, '2025', 'Alice', 'Tumusiime', '2005-10-12', 'Female', '172', 'Church Road', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(132, '2025', 'Paul', 'Nantogo', '2007-03-12', 'Male', '434', 'Main Street', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(133, '2025', 'Moses', 'Namukasa', '2005-12-26', 'Male', '220', 'School Road', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(134, '2025', 'Ritah', 'Nakato', '2006-05-28', 'Female', '354', 'Hospital View', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(135, '2025', 'Grace', 'Mukasa', '2007-04-27', 'Female', '437', 'Central Avenue', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(136, '2025', 'Doreen', 'Ochieng', '2009-08-06', 'Female', '290', 'Main Street', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(137, '2025', 'Mark', 'Okello', '2008-11-05', 'Male', '166', 'Market Lane', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(138, '2025', 'Timothy', 'Mukasa', '2008-02-10', 'Male', '397', 'Main Street', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(139, '2025', 'Rebecca', 'Nantogo', '2009-11-23', 'Female', '348', 'School Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(140, '2025', 'Joseph', 'Nantogo', '2005-03-17', 'Male', '78', 'School Road', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(141, '2025', 'Joy', 'Opio', '2005-06-22', 'Female', '426', 'Central Avenue', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(142, '2025', 'Mercy', 'Ssemwogerere', '2005-02-18', 'Female', '83', 'Hospital View', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(143, '2025', 'Paul', 'Waiswa', '2007-02-09', 'Male', '442', 'Main Street', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(144, '2025', 'Moses', 'Busingye', '2007-12-01', 'Male', '228', 'School Road', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(145, '2025', 'Mary', 'Ssemwogerere', '2008-12-04', 'Female', '443', 'Main Street', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(146, '2025', 'Paul', 'Nalubega', '2009-10-13', 'Male', '214', 'Church Road', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(147, '2025', 'Peter', 'Byaruhanga', '2005-04-24', 'Male', '191', 'Hospital View', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(148, '2025', 'Ritah', 'Lwanga', '2006-01-15', 'Female', '186', 'Church Road', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(149, '2025', 'Daniel', 'Busingye', '2009-10-07', 'Male', '453', 'Hospital View', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(150, '2025', 'Solomon', 'Mukasa', '2005-12-12', 'Male', '428', 'Hospital View', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(151, '2025', 'Brenda', 'Mukasa', '2005-09-14', 'Female', '23', 'Hospital View', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'assets/uploads/students/151/151_6937b12b34cc9.jpg'),
(152, '2025', 'Winnie', 'Akello', '2005-10-07', 'Female', '464', 'Church Road', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(153, '2025', 'Rebecca', 'Musoke', '2005-04-25', 'Female', '477', 'School Road', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(154, '2025', 'Sarah', 'Kato', '2007-05-22', 'Female', '24', 'Hospital View', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(155, '2025', 'Mercy', 'Opio', '2006-07-18', 'Female', '316', 'Church Road', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(156, '2025', 'Brenda', 'Aine', '2008-04-07', 'Female', '241', 'Market Lane', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(157, '2025', 'Doreen', 'Busingye', '2007-06-08', 'Female', '134', 'Central Avenue', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(158, '2025', 'Rebecca', 'Nalubega', '2007-11-30', 'Female', '316', 'Market Lane', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(159, '2025', 'Joan', 'Nantogo', '2007-01-22', 'Female', '388', 'School Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(160, '2025', 'Ritah', 'Nantogo', '2005-06-22', 'Female', '391', 'School Road', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(161, '2025', 'Joy', 'Mugabe', '2006-03-10', 'Female', '241', 'Hospital View', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(162, '2025', 'David', 'Ochieng', '2005-06-06', 'Male', '57', 'Church Road', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(163, '2025', 'Moses', 'Nantogo', '2005-11-18', 'Male', '189', 'Market Lane', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(164, '2025', 'Pritah', 'Lwanga', '2009-05-07', 'Female', '263', 'Main Street', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(165, '2025', 'Mercy', 'Kyomuhendo', '2009-10-05', 'Female', '468', 'Hospital View', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(166, '2025', 'Mary', 'Nakato', '2007-10-06', 'Female', '352', 'Central Avenue', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(167, '2025', 'Mark', 'Tumusiime', '2006-10-03', 'Male', '92', 'Central Avenue', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(168, '2025', 'David', 'Aine', '2007-08-05', 'Male', '119', 'School Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(169, '2025', 'Esther', 'Tumusiime', '2009-08-18', 'Female', '268', 'Central Avenue', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(170, '2025', 'Solomon', 'Busingye', '2007-02-22', 'Male', '492', 'School Road', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(171, '2025', 'Joseph', 'Nakato', '2007-10-07', 'Male', '287', 'Church Road', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(172, '2025', 'Mary', 'Lwanga', '2007-05-02', 'Female', '154', 'Main Street', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(173, '2025', 'Paul', 'Byaruhanga', '2006-06-29', 'Male', '123', 'Church Road', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(174, '2025', 'Alice', 'Tumusiime', '2005-09-30', 'Female', '149', 'Main Street', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(175, '2025', 'Mercy', 'Lwanga', '2008-01-10', 'Female', '76', 'Central Avenue', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(176, '2025', 'Isaac', 'Ssemwogerere', '2009-05-28', 'Male', '362', 'Central Avenue', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(177, '2025', 'Doreen', 'Opio', '2009-03-07', 'Female', '498', 'Market Lane', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(178, '2025', 'Ritah', 'Nakato', '2007-04-13', 'Female', '278', 'Market Lane', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(179, '2025', 'Doreen', 'Kato', '2007-06-07', 'Female', '152', 'Main Street', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(180, '2025', 'Brenda', 'Busingye', '2005-12-14', 'Female', '162', 'Main Street', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(181, '2025', 'Alice', 'Namukasa', '2006-12-08', 'Female', '233', 'Main Street', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(182, '2025', 'Timothy', 'Okello', '2006-06-28', 'Male', '132', 'Market Lane', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(183, '2025', 'Winnie', 'Nakato', '2006-06-23', 'Female', '314', 'Church Road', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(184, '2025', 'Sandra', 'Namukasa', '2008-07-24', 'Female', '53', 'Market Lane', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(185, '2025', 'Joseph', 'Nalubega', '2008-10-10', 'Male', '298', 'Hospital View', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(186, '2025', 'Peter', 'Busingye', '2007-05-24', 'Male', '288', 'Market Lane', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(187, '2025', 'Daniel', 'Okello', '2009-07-09', 'Male', '297', 'Church Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(188, '2025', 'Sandra', 'Musoke', '2007-06-09', 'Female', '3', 'School Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(189, '2025', 'David', 'Lwanga', '2009-11-24', 'Male', '277', 'Hospital View', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(190, '2025', 'Mercy', 'Ssemwogerere', '2008-09-17', 'Female', '426', 'Main Street', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(191, '2025', 'Alice', 'Akello', '2008-01-12', 'Female', '285', 'Main Street', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(192, '2025', 'Doreen', 'Tumusiime', '2008-05-12', 'Female', '88', 'Central Avenue', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(193, '2025', 'Sarah', 'Ochieng', '2006-05-20', 'Female', '493', 'Main Street', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(194, '2025', 'Peter', 'Ochieng', '2006-05-05', 'Male', '255', 'Hospital View', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(195, '2025', 'Mark', 'Tumusiime', '2007-01-21', 'Male', '245', 'Church Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(196, '2025', 'Mary', 'Waiswa', '2007-07-11', 'Female', '220', 'Hospital View', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(197, '2025', 'Ritah', 'Ochieng', '2006-12-07', 'Female', '124', 'Main Street', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(198, '2025', 'Samuel', 'Namukasa', '2005-02-08', 'Male', '233', 'Church Road', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(199, '2025', 'Joy', 'Busingye', '2009-08-28', 'Female', '485', 'Main Street', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(200, '2025', 'Winnie', 'Mugabe', '2008-04-19', 'Female', '243', 'Market Lane', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(201, '2025', 'Solomon', 'Tumusiime', '2008-01-10', 'Male', '454', 'Hospital View', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(202, '2025', 'Solomon', 'Kyomuhendo', '2007-05-26', 'Male', '107', 'School Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(203, '2025', 'David', 'Kyomuhendo', '2007-06-25', 'Male', '62', 'Main Street', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(204, '2025', 'Doreen', 'Ssemwogerere', '2006-01-11', 'Female', '434', 'Hospital View', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(205, '2025', 'Doreen', 'Busingye', '2006-09-24', 'Female', '325', 'Church Road', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(206, '2025', 'Joan', 'Busingye', '2005-04-08', 'Female', '447', 'Church Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(207, '2025', 'Joy', 'Ssemwogerere', '2009-09-09', 'Female', '483', 'Main Street', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(208, '2025', 'John', 'Waiswa', '2007-08-17', 'Male', '281', 'Church Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(209, '2025', 'Samuel', 'Akello', '2005-11-04', 'Male', '107', 'School Road', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(210, '2025', 'Brian', 'Nantogo', '2009-09-09', 'Male', '364', 'Hospital View', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(211, '2025', 'Samuel', 'Busingye', '2008-03-25', 'Male', '260', 'School Road', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(212, '2025', 'Solomon', 'Akello', '2005-05-25', 'Male', '123', 'Central Avenue', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(213, '2025', 'Peter', 'Lwanga', '2007-03-18', 'Male', '116', 'Hospital View', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(214, '2025', 'Mary', 'Waiswa', '2008-08-16', 'Female', '231', 'Main Street', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(215, '2025', 'Ritah', 'Okello', '2007-09-21', 'Female', '489', 'Church Road', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(216, '2025', 'Ivan', 'Kato', '2006-08-26', 'Male', '125', 'Church Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(217, '2025', 'Timothy', 'Mukasa', '2007-08-24', 'Male', '179', 'Church Road', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(218, '2025', 'Mary', 'Byaruhanga', '2007-04-23', 'Female', '97', 'School Road', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(219, '2025', 'David', 'Opio', '2007-11-29', 'Male', '332', 'School Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(220, '2025', 'Mark', 'Mukasa', '2009-05-29', 'Male', '477', 'Main Street', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(221, '2025', 'Sandra', 'Namukasa', '2009-09-27', 'Female', '80', 'Central Avenue', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(222, '2025', 'Joseph', 'Lwanga', '2007-05-01', 'Male', '74', 'Market Lane', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(223, '2025', 'Moses', 'Tumusiime', '2009-10-16', 'Male', '114', 'Church Road', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(224, '2025', 'Peter', 'Byaruhanga', '2009-12-07', 'Male', '27', 'Church Road', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(225, '2025', 'Isaac', 'Opio', '2006-05-18', 'Male', '328', 'Market Lane', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(226, '2025', 'Andrew', 'Mukasa', '2006-01-27', 'Male', '218', 'School Road', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(227, '2025', 'Brian', 'Opio', '2007-05-06', 'Male', '271', 'Church Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(228, '2025', 'Ivan', 'Mukasa', '2006-05-05', 'Male', '411', 'Church Road', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(229, '2025', 'Timothy', 'Musoke', '2005-01-19', 'Male', '364', 'School Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(230, '2025', 'Brenda', 'Nakato', '2005-12-27', 'Female', '98', 'Market Lane', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(231, '2025', 'Sandra', 'Opio', '2008-04-02', 'Female', '349', 'School Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(232, '2025', 'Joy', 'Lwanga', '2007-12-28', 'Female', '129', 'Market Lane', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(233, '2025', 'Alice', 'Ssemwogerere', '2008-12-06', 'Female', '251', 'Main Street', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(234, '2025', 'Doreen', 'Musoke', '2008-04-24', 'Female', '114', 'Main Street', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(235, '2025', 'Joan', 'Tumusiime', '2006-03-20', 'Female', '466', 'Central Avenue', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(236, '2025', 'Brian', 'Nantogo', '2009-01-01', 'Male', '49', 'Main Street', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(237, '2025', 'Sandra', 'Busingye', '2006-08-15', 'Female', '52', 'School Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(238, '2025', 'Isaac', 'Opio', '2006-05-19', 'Male', '348', 'School Road', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(239, '2025', 'Sarah', 'Ochieng', '2005-09-05', 'Female', '183', 'Market Lane', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(240, '2025', 'Grace', 'Okello', '2007-08-30', 'Female', '65', 'Main Street', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(241, '2025', 'Brenda', 'Nakato', '2009-12-02', 'Female', '115', 'Church Road', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(242, '2025', 'Brenda', 'Busingye', '2007-02-25', 'Female', '193', 'School Road', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(243, '2025', 'Winnie', 'Mugabe', '2009-06-25', 'Female', '264', 'Central Avenue', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(244, '2025', 'Brenda', 'Musoke', '2008-01-07', 'Female', '199', 'Church Road', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(245, '2025', 'Joseph', 'Okello', '2007-09-09', 'Male', '280', 'Church Road', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(246, '2025', 'Joan', 'Kyomuhendo', '2009-09-13', 'Female', '226', 'Market Lane', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(247, '2025', 'David', 'Nantogo', '2009-05-29', 'Male', '44', 'Hospital View', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(248, '2025', 'Samuel', 'Nalubega', '2007-09-23', 'Male', '38', 'Hospital View', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(249, '2025', 'Moses', 'Nantogo', '2009-12-22', 'Male', '257', 'School Road', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(250, '2025', 'Doreen', 'Nalubega', '2005-10-02', 'Female', '342', 'Central Avenue', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(251, '2025', 'Brian', 'Nakato', '2009-05-06', 'Male', '265', 'Main Street', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(252, '2025', 'Winnie', 'Kato', '2009-07-30', 'Female', '299', 'Church Road', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(253, '2025', 'Sandra', 'Lwanga', '2009-03-06', 'Female', '381', 'Church Road', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(254, '2025', 'Mark', 'Ssemwogerere', '2008-10-06', 'Male', '169', 'Market Lane', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(255, '2025', 'Timothy', 'Nalubega', '2007-05-30', 'Male', '99', 'School Road', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(256, '2025', 'Brian', 'Ochieng', '2009-07-07', 'Male', '345', 'Hospital View', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(257, '2025', 'Daniel', 'Nakato', '2008-06-26', 'Male', '273', 'School Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(258, '2025', 'Daniel', 'Nalubega', '2009-02-23', 'Male', '154', 'Main Street', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(259, '2025', 'Mary', 'Ochieng', '2008-04-07', 'Female', '119', 'Church Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(260, '2025', 'Sarah', 'Ochieng', '2009-09-09', 'Female', '231', 'Market Lane', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(261, '2025', 'Pritah', 'Nalubega', '2005-07-08', 'Female', '359', 'Church Road', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(262, '2025', 'Mary', 'Okello', '2008-09-05', 'Female', '297', 'Hospital View', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(263, '2025', 'Alice', 'Kyomuhendo', '2009-10-23', 'Female', '167', 'Hospital View', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(264, '2025', 'Moses', 'Mukasa', '2008-07-01', 'Male', '452', 'Market Lane', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(265, '2025', 'Pritah', 'Namukasa', '2009-10-23', 'Female', '418', 'Church Road', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(266, '2025', 'Mark', 'Kato', '2006-06-23', 'Male', '444', 'School Road', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(267, '2025', 'Isaac', 'Okello', '2008-02-09', 'Male', '239', 'School Road', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(268, '2025', 'Doreen', 'Tumusiime', '2007-09-26', 'Female', '318', 'School Road', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(269, '2025', 'Pritah', 'Mukasa', '2006-03-24', 'Female', '159', 'Central Avenue', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(270, '2025', 'Andrew', 'Byaruhanga', '2008-10-12', 'Male', '13', 'Central Avenue', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(271, '2025', 'Joseph', 'Mukasa', '2008-07-25', 'Male', '190', 'Hospital View', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(272, '2025', 'Sarah', 'Waiswa', '2009-03-16', 'Female', '486', 'Church Road', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(273, '2025', 'David', 'Ochieng', '2005-10-16', 'Male', '211', 'School Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(274, '2025', 'Samuel', 'Ochieng', '2008-01-06', 'Male', '120', 'Market Lane', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(275, '2025', 'Joseph', 'Nakato', '2006-04-26', 'Male', '154', 'Hospital View', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png');
INSERT INTO `students` (`AdmissionNo`, `AdmissionYear`, `Name`, `Surname`, `DateOfBirth`, `Gender`, `HouseNo`, `Street`, `Village`, `Town`, `District`, `State`, `Country`, `PhotoPath`) VALUES
(276, '2025', 'Sarah', 'Mugabe', '2007-12-30', 'Female', '333', 'School Road', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(277, '2025', 'Ivan', 'Byaruhanga', '2008-07-27', 'Male', '31', 'Main Street', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(278, '2025', 'Brenda', 'Opio', '2008-10-01', 'Female', '11', 'Central Avenue', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(279, '2025', 'David', 'Musoke', '2008-12-25', 'Male', '327', 'Central Avenue', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(280, '2025', 'Pritah', 'Byaruhanga', '2009-01-22', 'Female', '65', 'Church Road', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(281, '2025', 'David', 'Namukasa', '2009-05-04', 'Male', '8', 'Market Lane', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(282, '2025', 'Samuel', 'Musoke', '2009-04-07', 'Male', '329', 'Hospital View', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(283, '2025', 'Doreen', 'Opio', '2008-06-24', 'Female', '183', 'Hospital View', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(284, '2025', 'Paul', 'Nakato', '2008-09-17', 'Male', '180', 'School Road', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(285, '2025', 'Mary', 'Musoke', '2006-05-29', 'Female', '171', 'Central Avenue', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(286, '2025', 'Sarah', 'Nakato', '2009-04-17', 'Female', '40', 'Hospital View', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(287, '2025', 'Moses', 'Nalubega', '2008-03-27', 'Male', '340', 'Market Lane', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(288, '2025', 'Mary', 'Kyomuhendo', '2005-06-17', 'Female', '168', 'Market Lane', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(289, '2025', 'Winnie', 'Ochieng', '2007-09-06', 'Female', '353', 'Central Avenue', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(290, '2025', 'Samuel', 'Kato', '2008-05-08', 'Male', '348', 'Market Lane', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(291, '2025', 'Joy', 'Kato', '2009-05-12', 'Female', '377', 'Main Street', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(292, '2025', 'Samuel', 'Opio', '2009-05-08', 'Male', '335', 'Hospital View', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(293, '2025', 'Joan', 'Akello', '2009-04-21', 'Female', '454', 'Central Avenue', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(294, '2025', 'Esther', 'Kato', '2009-05-14', 'Female', '89', 'Church Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(295, '2025', 'Joy', 'Okello', '2009-11-10', 'Female', '32', 'Market Lane', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(296, '2025', 'Andrew', 'Ochieng', '2005-05-31', 'Male', '339', 'Main Street', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(297, '2025', 'Pritah', 'Tumusiime', '2006-09-28', 'Female', '469', 'School Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(298, '2025', 'Rebecca', 'Opio', '2009-10-01', 'Female', '248', 'School Road', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(299, '2025', 'Pritah', 'Byaruhanga', '2008-04-28', 'Female', '224', 'Church Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(300, '2025', 'Mary', 'Kato', '2006-03-06', 'Female', '6', 'Market Lane', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(301, '2025', 'Brian', 'Byaruhanga', '2008-11-20', 'Male', '482', 'Market Lane', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(302, '2025', 'Grace', 'Nakato', '2006-07-30', 'Female', '37', 'Market Lane', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(303, '2025', 'John', 'Tumusiime', '2006-01-06', 'Male', '450', 'Central Avenue', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(304, '2025', 'Doreen', 'Aine', '2007-01-14', 'Female', '492', 'Hospital View', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(305, '2025', 'Pritah', 'Waiswa', '2009-07-19', 'Female', '327', 'School Road', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(306, '2025', 'Moses', 'Byaruhanga', '2009-10-22', 'Male', '169', 'Hospital View', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(307, '2025', 'Brenda', 'Nalubega', '2007-01-30', 'Female', '150', 'Church Road', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(308, '2025', 'Joseph', 'Opio', '2008-10-09', 'Male', '383', 'School Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(309, '2025', 'Paul', 'Nakato', '2008-05-05', 'Male', '40', 'Market Lane', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(310, '2025', 'Brian', 'Tumusiime', '2007-10-08', 'Male', '438', 'Hospital View', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(311, '2025', 'Joseph', 'Ochieng', '2008-02-15', 'Male', '463', 'Hospital View', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(312, '2025', 'Brenda', 'Busingye', '2006-06-29', 'Female', '425', 'Market Lane', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(313, '2025', 'Andrew', 'Tumusiime', '2008-02-26', 'Male', '212', 'Church Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(314, '2025', 'Joy', 'Waiswa', '2008-02-29', 'Female', '211', 'Church Road', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(315, '2025', 'Mary', 'Opio', '2006-09-14', 'Female', '292', 'Central Avenue', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(316, '2025', 'Solomon', 'Mukasa', '2005-10-05', 'Male', '364', 'Church Road', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(317, '2025', 'Doreen', 'Tumusiime', '2008-04-28', 'Female', '107', 'Main Street', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(318, '2025', 'Mercy', 'Ssemwogerere', '2009-11-18', 'Female', '444', 'School Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(319, '2025', 'Brian', 'Aine', '2008-04-05', 'Male', '143', 'Market Lane', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(320, '2025', 'Doreen', 'Waiswa', '2009-10-02', 'Female', '305', 'Church Road', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(321, '2025', 'Solomon', 'Waiswa', '2009-08-15', 'Male', '258', 'Hospital View', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(322, '2025', 'Alice', 'Nakato', '2008-11-07', 'Female', '156', 'Church Road', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(323, '2025', 'Brenda', 'Kyomuhendo', '2007-09-03', 'Female', '441', 'Hospital View', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(324, '2025', 'Brenda', 'Aine', '2007-10-08', 'Female', '22', 'School Road', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(325, '2025', 'Mary', 'Mukasa', '2009-03-07', 'Female', '69', 'Church Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(326, '2025', 'Moses', 'Opio', '2009-09-27', 'Male', '124', 'Market Lane', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(327, '2025', 'Winnie', 'Nantogo', '2005-12-07', 'Female', '471', 'Main Street', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(328, '2025', 'Samuel', 'Tumusiime', '2005-06-14', 'Male', '330', 'Main Street', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(329, '2025', 'Moses', 'Opio', '2005-09-10', 'Male', '52', 'Main Street', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(330, '2025', 'John', 'Musoke', '2007-08-27', 'Male', '236', 'Hospital View', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(331, '2025', 'Andrew', 'Nantogo', '2008-10-20', 'Male', '57', 'Church Road', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(332, '2025', 'Andrew', 'Tumusiime', '2007-11-30', 'Male', '106', 'Church Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(333, '2025', 'Joan', 'Aine', '2006-03-30', 'Female', '453', 'Hospital View', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(334, '2025', 'Pritah', 'Mukasa', '2006-05-05', 'Female', '234', 'School Road', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(335, '2025', 'Grace', 'Opio', '2009-03-18', 'Female', '373', 'Church Road', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(336, '2025', 'Alice', 'Nantogo', '2006-09-21', 'Female', '131', 'Church Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(337, '2025', 'Isaac', 'Kyomuhendo', '2005-11-29', 'Male', '83', 'Church Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(338, '2025', 'Andrew', 'Nakato', '2009-10-05', 'Male', '74', 'Central Avenue', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(339, '2025', 'Doreen', 'Okello', '2005-03-26', 'Female', '111', 'Central Avenue', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(340, '2025', 'Mark', 'Kyomuhendo', '2005-10-28', 'Male', '136', 'Central Avenue', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(341, '2025', 'Ritah', 'Tumusiime', '2009-01-28', 'Female', '227', 'Hospital View', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(342, '2025', 'Winnie', 'Ochieng', '2006-10-31', 'Female', '466', 'School Road', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(343, '2025', 'Mercy', 'Nalubega', '2009-12-18', 'Female', '3', 'Main Street', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(344, '2025', 'Ivan', 'Ochieng', '2009-12-21', 'Male', '270', 'Hospital View', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(345, '2025', 'Ritah', 'Lwanga', '2007-01-30', 'Female', '148', 'Church Road', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(346, '2025', 'Mark', 'Okello', '2008-06-18', 'Male', '11', 'Main Street', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(347, '2025', 'Winnie', 'Waiswa', '2006-07-02', 'Female', '295', 'Main Street', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(348, '2025', 'Joan', 'Byaruhanga', '2006-12-22', 'Female', '319', 'Main Street', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(349, '2025', 'Alice', 'Kyomuhendo', '2005-11-01', 'Female', '149', 'Central Avenue', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(350, '2025', 'John', 'Akello', '2007-08-03', 'Male', '288', 'Church Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(351, '2025', 'Joan', 'Musoke', '2006-09-20', 'Female', '193', 'Central Avenue', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(352, '2025', 'David', 'Tumusiime', '2006-11-22', 'Male', '337', 'Church Road', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(353, '2025', 'Andrew', 'Akello', '2005-01-10', 'Male', '150', 'Market Lane', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(354, '2025', 'Alice', 'Mukasa', '2009-04-19', 'Female', '417', 'School Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(355, '2025', 'Daniel', 'Kyomuhendo', '2009-06-13', 'Male', '317', 'Market Lane', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(356, '2025', 'Mark', 'Mukasa', '2005-01-01', 'Male', '227', 'Church Road', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(357, '2025', 'Sarah', 'Kyomuhendo', '2006-08-22', 'Female', '204', 'Main Street', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(358, '2025', 'Daniel', 'Nalubega', '2005-04-20', 'Male', '150', 'Church Road', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(359, '2025', 'Ritah', 'Ssemwogerere', '2006-12-22', 'Female', '170', 'School Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(360, '2025', 'Solomon', 'Mugabe', '2007-03-28', 'Male', '81', 'Market Lane', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(361, '2025', 'Sandra', 'Nakato', '2005-11-28', 'Female', '158', 'Main Street', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(362, '2025', 'Joy', 'Busingye', '2009-04-07', 'Female', '312', 'School Road', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(363, '2025', 'Joy', 'Musoke', '2006-04-17', 'Female', '313', 'Market Lane', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(364, '2025', 'Grace', 'Nantogo', '2005-03-08', 'Female', '363', 'School Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(365, '2025', 'Ritah', 'Aine', '2009-05-06', 'Female', '323', 'School Road', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(366, '2025', 'Brian', 'Namukasa', '2008-11-20', 'Male', '495', 'School Road', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(367, '2025', 'Mark', 'Lwanga', '2007-01-10', 'Male', '297', 'Hospital View', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(368, '2025', 'Paul', 'Opio', '2006-06-25', 'Male', '76', 'Central Avenue', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(369, '2025', 'Isaac', 'Aine', '2005-06-18', 'Male', '413', 'Central Avenue', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(370, '2025', 'Grace', 'Kyomuhendo', '2008-10-11', 'Female', '122', 'Central Avenue', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(371, '2025', 'Peter', 'Kyomuhendo', '2008-07-23', 'Male', '318', 'Main Street', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(372, '2025', 'Brenda', 'Nalubega', '2005-04-21', 'Female', '335', 'Church Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(373, '2025', 'John', 'Mukasa', '2009-12-22', 'Male', '406', 'Main Street', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(374, '2025', 'Ritah', 'Byaruhanga', '2005-06-21', 'Female', '390', 'School Road', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(375, '2025', 'Mark', 'Busingye', '2005-05-16', 'Male', '431', 'Main Street', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(376, '2025', 'Joy', 'Ssemwogerere', '2009-01-02', 'Female', '175', 'Market Lane', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(377, '2025', 'Andrew', 'Nantogo', '2008-06-06', 'Male', '403', 'Central Avenue', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(378, '2025', 'Joan', 'Nalubega', '2008-10-18', 'Female', '290', 'School Road', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(379, '2025', 'Andrew', 'Nantogo', '2009-03-10', 'Male', '238', 'Central Avenue', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(380, '2025', 'Paul', 'Tumusiime', '2006-02-24', 'Male', '432', 'School Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(381, '2025', 'Timothy', 'Kato', '2008-12-13', 'Male', '306', 'Hospital View', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(382, '2025', 'Peter', 'Byaruhanga', '2005-06-23', 'Male', '293', 'School Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(383, '2025', 'Moses', 'Ochieng', '2006-11-29', 'Male', '213', 'Central Avenue', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(384, '2025', 'Sandra', 'Kyomuhendo', '2007-06-29', 'Female', '480', 'Church Road', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(385, '2025', 'Joan', 'Kato', '2006-06-20', 'Female', '42', 'School Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(386, '2025', 'Daniel', 'Musoke', '2005-11-09', 'Male', '25', 'Hospital View', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(387, '2025', 'Samuel', 'Nalubega', '2007-05-23', 'Male', '356', 'Main Street', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(388, '2025', 'Timothy', 'Tumusiime', '2005-03-19', 'Male', '432', 'Church Road', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(389, '2025', 'Ivan', 'Byaruhanga', '2009-02-03', 'Male', '253', 'Main Street', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(390, '2025', 'Solomon', 'Kyomuhendo', '2007-10-05', 'Male', '295', 'Church Road', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(391, '2025', 'Sandra', 'Waiswa', '2009-11-12', 'Female', '144', 'School Road', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(392, '2025', 'Mary', 'Musoke', '2005-07-16', 'Female', '269', 'Market Lane', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(393, '2025', 'Mark', 'Busingye', '2009-06-10', 'Male', '20', 'School Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(394, '2025', 'Pritah', 'Mugabe', '2007-05-27', 'Female', '244', 'Central Avenue', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(395, '2025', 'Sarah', 'Akello', '2009-05-04', 'Female', '33', 'Hospital View', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(396, '2025', 'Mercy', 'Tumusiime', '2006-06-12', 'Female', '277', 'Central Avenue', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(397, '2025', 'Brian', 'Kyomuhendo', '2005-11-14', 'Male', '30', 'Hospital View', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(398, '2025', 'Mercy', 'Kyomuhendo', '2005-05-02', 'Female', '204', 'Central Avenue', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(399, '2025', 'David', 'Aine', '2007-06-17', 'Male', '84', 'Market Lane', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(400, '2025', 'Moses', 'Tumusiime', '2008-11-19', 'Male', '223', 'Central Avenue', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(401, '2025', 'Joseph', 'Kyomuhendo', '2008-11-24', 'Male', '382', 'Market Lane', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(402, '2025', 'Daniel', 'Musoke', '2006-03-18', 'Male', '165', 'Central Avenue', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(403, '2025', 'Mercy', 'Mugabe', '2006-04-25', 'Female', '183', 'Main Street', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(404, '2025', 'Andrew', 'Ochieng', '2005-03-19', 'Male', '279', 'School Road', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(405, '2025', 'Sandra', 'Busingye', '2007-02-24', 'Female', '312', 'Hospital View', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(406, '2025', 'Brian', 'Okello', '2005-10-07', 'Male', '425', 'Hospital View', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(407, '2025', 'Solomon', 'Nantogo', '2009-04-23', 'Male', '78', 'Church Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(408, '2025', 'Mercy', 'Nantogo', '2007-11-19', 'Female', '448', 'Hospital View', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(409, '2025', 'Sandra', 'Mugabe', '2008-05-12', 'Female', '383', 'Hospital View', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(410, '2025', 'Grace', 'Aine', '2009-02-20', 'Female', '294', 'Market Lane', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(411, '2025', 'Esther', 'Akello', '2007-02-13', 'Female', '468', 'Market Lane', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(412, '2025', 'Isaac', 'Mukasa', '2005-01-19', 'Male', '173', 'Hospital View', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(413, '2025', 'Daniel', 'Nalubega', '2009-10-21', 'Male', '443', 'School Road', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(414, '2025', 'Paul', 'Lwanga', '2008-10-13', 'Male', '194', 'Hospital View', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(415, '2025', 'Isaac', 'Kato', '2005-01-08', 'Male', '201', 'Central Avenue', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(416, '2025', 'Joan', 'Okello', '2009-02-01', 'Female', '394', 'Market Lane', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(417, '2025', 'Peter', 'Byaruhanga', '2005-09-26', 'Male', '404', 'School Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(418, '2025', 'Joan', 'Tumusiime', '2006-02-17', 'Female', '439', 'Hospital View', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(419, '2025', 'Ritah', 'Ssemwogerere', '2007-05-12', 'Female', '341', 'Central Avenue', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(420, '2025', 'Doreen', 'Nantogo', '2009-02-13', 'Female', '484', 'Market Lane', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(421, '2025', 'Ritah', 'Aine', '2008-10-12', 'Female', '57', 'Church Road', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(422, '2025', 'Mary', 'Mukasa', '2009-07-16', 'Female', '211', 'Market Lane', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(423, '2025', 'Solomon', 'Akello', '2009-08-17', 'Male', '272', 'Central Avenue', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(424, '2025', 'Samuel', 'Nakato', '2006-06-07', 'Male', '393', 'Main Street', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(425, '2025', 'Sarah', 'Mukasa', '2005-12-27', 'Female', '371', 'Main Street', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(426, '2025', 'Mary', 'Ssemwogerere', '2005-01-06', 'Female', '412', 'Main Street', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(427, '2025', 'Pritah', 'Waiswa', '2009-01-24', 'Female', '89', 'Market Lane', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(428, '2025', 'Ritah', 'Okello', '2006-10-05', 'Female', '80', 'Hospital View', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(429, '2025', 'Timothy', 'Aine', '2009-01-17', 'Male', '388', 'Market Lane', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(430, '2025', 'Esther', 'Opio', '2009-09-29', 'Female', '332', 'Market Lane', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(431, '2025', 'Pritah', 'Ochieng', '2009-08-31', 'Female', '428', 'Market Lane', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(432, '2025', 'Joan', 'Aine', '2005-09-22', 'Female', '195', 'School Road', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(433, '2025', 'David', 'Opio', '2008-02-05', 'Male', '422', 'Market Lane', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(434, '2025', 'Sandra', 'Namukasa', '2009-04-14', 'Female', '374', 'Main Street', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(435, '2025', 'Grace', 'Waiswa', '2006-03-05', 'Female', '338', 'Hospital View', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(436, '2025', 'Paul', 'Busingye', '2005-09-29', 'Male', '185', 'Market Lane', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(437, '2025', 'Daniel', 'Akello', '2007-11-09', 'Male', '499', 'Church Road', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(438, '2025', 'Rebecca', 'Kato', '2009-07-07', 'Female', '75', 'Main Street', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(439, '2025', 'Ritah', 'Ochieng', '2006-07-21', 'Female', '465', 'Hospital View', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(440, '2025', 'Sarah', 'Byaruhanga', '2009-01-29', 'Female', '374', 'Church Road', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(441, '2025', 'Rebecca', 'Okello', '2007-10-29', 'Female', '249', 'Hospital View', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(442, '2025', 'David', 'Kyomuhendo', '2006-04-16', 'Male', '40', 'School Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(443, '2025', 'Esther', 'Musoke', '2009-11-10', 'Female', '371', 'Hospital View', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(444, '2025', 'Ritah', 'Kyomuhendo', '2008-09-11', 'Female', '485', 'School Road', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(445, '2025', 'Peter', 'Tumusiime', '2009-04-25', 'Male', '232', 'Hospital View', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(446, '2025', 'Andrew', 'Mugabe', '2008-06-01', 'Male', '322', 'Main Street', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(447, '2025', 'Andrew', 'Namukasa', '2008-07-30', 'Male', '473', 'School Road', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(448, '2025', 'Winnie', 'Kyomuhendo', '2008-10-16', 'Female', '438', 'Main Street', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(449, '2025', 'Samuel', 'Nakato', '2006-02-18', 'Male', '260', 'Central Avenue', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(450, '2025', 'Isaac', 'Akello', '2008-05-11', 'Male', '330', 'Church Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(451, '2025', 'Mark', 'Waiswa', '2007-06-03', 'Male', '475', 'Church Road', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(452, '2025', 'Esther', 'Nalubega', '2007-08-14', 'Female', '288', 'Church Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(453, '2025', 'Peter', 'Aine', '2009-06-22', 'Male', '275', 'Main Street', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(454, '2025', 'Andrew', 'Lwanga', '2009-03-09', 'Male', '261', 'Main Street', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(455, '2025', 'Grace', 'Aine', '2008-10-09', 'Female', '157', 'Church Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(456, '2025', 'Alice', 'Namukasa', '2008-02-15', 'Female', '274', 'Central Avenue', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(457, '2025', 'Timothy', 'Byaruhanga', '2005-06-09', 'Male', '38', 'Main Street', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(458, '2025', 'Solomon', 'Mugabe', '2007-02-27', 'Male', '74', 'Market Lane', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(459, '2025', 'David', 'Akello', '2009-11-19', 'Male', '303', 'Main Street', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(460, '2025', 'Timothy', 'Aine', '2008-04-20', 'Male', '31', 'Church Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(461, '2025', 'Samuel', 'Aine', '2009-06-16', 'Male', '368', 'Main Street', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(462, '2025', 'John', 'Opio', '2006-04-24', 'Male', '115', 'Market Lane', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(463, '2025', 'Sandra', 'Ochieng', '2005-11-08', 'Female', '146', 'Central Avenue', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(464, '2025', 'Winnie', 'Mukasa', '2008-04-13', 'Female', '198', 'Main Street', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(465, '2025', 'Mark', 'Mukasa', '2009-06-02', 'Male', '493', 'Church Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(466, '2025', 'Ritah', 'Mugabe', '2008-06-05', 'Female', '402', 'Central Avenue', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(467, '2025', 'Sarah', 'Kyomuhendo', '2006-02-17', 'Female', '441', 'Hospital View', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(468, '2025', 'Moses', 'Busingye', '2008-07-22', 'Male', '1', 'Central Avenue', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(469, '2025', 'Moses', 'Kyomuhendo', '2009-05-11', 'Male', '395', 'Church Road', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(470, '2025', 'Timothy', 'Busingye', '2007-07-27', 'Male', '158', 'Main Street', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(471, '2025', 'Joy', 'Opio', '2006-03-31', 'Female', '270', 'Central Avenue', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(472, '2025', 'Brenda', 'Ssemwogerere', '2005-08-13', 'Female', '490', 'School Road', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(473, '2025', 'John', 'Tumusiime', '2006-10-06', 'Male', '305', 'Central Avenue', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(474, '2025', 'Brian', 'Mugabe', '2006-09-05', 'Male', '436', 'Market Lane', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(475, '2025', 'Joan', 'Nantogo', '2007-03-21', 'Female', '457', 'Church Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(476, '2025', 'Samuel', 'Kyomuhendo', '2008-01-23', 'Male', '216', 'Church Road', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(477, '2025', 'Isaac', 'Kyomuhendo', '2005-12-28', 'Male', '98', 'Market Lane', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(478, '2025', 'Winnie', 'Byaruhanga', '2005-08-13', 'Female', '331', 'Central Avenue', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(479, '2025', 'Sandra', 'Ochieng', '2005-01-21', 'Female', '276', 'Hospital View', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(480, '2025', 'Esther', 'Nalubega', '2007-10-08', 'Female', '329', 'School Road', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(481, '2025', 'Joan', 'Busingye', '2009-05-11', 'Female', '57', 'Central Avenue', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(482, '2025', 'Alice', 'Ochieng', '2008-07-17', 'Female', '26', 'Main Street', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(483, '2025', 'Mary', 'Kato', '2005-12-16', 'Female', '404', 'Market Lane', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(484, '2025', 'John', 'Waiswa', '2008-01-24', 'Male', '451', 'School Road', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(485, '2025', 'Mary', 'Nakato', '2008-05-27', 'Female', '168', 'School Road', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(486, '2025', 'Alice', 'Nalubega', '2005-06-06', 'Female', '423', 'Central Avenue', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(487, '2025', 'Moses', 'Mukasa', '2008-04-07', 'Male', '351', 'School Road', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(488, '2025', 'Paul', 'Kyomuhendo', '2009-10-15', 'Male', '276', 'Central Avenue', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(489, '2025', 'Joseph', 'Waiswa', '2005-08-31', 'Male', '316', 'Hospital View', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(490, '2025', 'Doreen', 'Musoke', '2008-01-04', 'Female', '491', 'Main Street', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(491, '2025', 'Isaac', 'Ochieng', '2008-08-13', 'Male', '454', 'Market Lane', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(492, '2025', 'Sarah', 'Aine', '2007-12-06', 'Female', '279', 'Main Street', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(493, '2025', 'Isaac', 'Aine', '2005-01-05', 'Male', '199', 'Central Avenue', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(494, '2025', 'Daniel', 'Ssemwogerere', '2009-09-10', 'Male', '374', 'Central Avenue', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(495, '2025', 'Ritah', 'Nantogo', '2005-12-16', 'Female', '120', 'School Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(496, '2025', 'Ivan', 'Akello', '2009-10-03', 'Male', '153', 'Hospital View', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(497, '2025', 'Peter', 'Akello', '2007-04-19', 'Male', '152', 'Main Street', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(498, '2025', 'Brian', 'Namukasa', '2009-05-28', 'Male', '257', 'Central Avenue', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(499, '2025', 'Pritah', 'Namukasa', '2008-08-08', 'Female', '385', 'Hospital View', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(500, '2025', 'Peter', 'Ochieng', '2006-11-12', 'Male', '15', 'Main Street', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(501, '2025', 'Alice', 'Nakato', '2008-03-06', 'Female', '370', 'Hospital View', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(502, '2025', 'Mark', 'Byaruhanga', '2006-06-21', 'Male', '24', 'Market Lane', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(503, '2025', 'Mark', 'Nakato', '2009-03-03', 'Male', '295', 'Market Lane', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(504, '2025', 'Sandra', 'Lwanga', '2008-11-24', 'Female', '235', 'Main Street', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(505, '2025', 'Rebecca', 'Waiswa', '2005-04-16', 'Female', '39', 'Church Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(506, '2025', 'Moses', 'Okello', '2006-08-09', 'Male', '90', 'Central Avenue', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(507, '2025', 'John', 'Kato', '2006-02-13', 'Male', '467', 'Central Avenue', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(508, '2025', 'Brian', 'Kato', '2007-04-08', 'Male', '168', 'Church Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(509, '2025', 'Doreen', 'Ochieng', '2009-12-27', 'Female', '448', 'Market Lane', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(510, '2025', 'Solomon', 'Waiswa', '2009-08-30', 'Male', '274', 'Central Avenue', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(511, '2025', 'Winnie', 'Namukasa', '2006-03-04', 'Female', '131', 'School Road', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(512, '2025', 'Samuel', 'Tumusiime', '2009-06-30', 'Male', '398', 'Church Road', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(513, '2025', 'Paul', 'Tumusiime', '2005-01-28', 'Male', '437', 'Church Road', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(514, '2025', 'John', 'Lwanga', '2007-12-17', 'Male', '439', 'School Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(515, '2025', 'Mary', 'Waiswa', '2007-08-22', 'Female', '295', 'Market Lane', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(516, '2025', 'John', 'Okello', '2009-02-01', 'Male', '6', 'School Road', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(517, '2025', 'Winnie', 'Byaruhanga', '2005-08-27', 'Female', '377', 'Market Lane', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(518, '2025', 'Grace', 'Nalubega', '2007-12-10', 'Female', '194', 'Main Street', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(519, '2025', 'Joseph', 'Nalubega', '2007-03-28', 'Male', '109', 'Hospital View', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(520, '2025', 'Peter', 'Busingye', '2009-03-29', 'Male', '129', 'Hospital View', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(521, '2025', 'Sandra', 'Mugabe', '2006-10-25', 'Female', '184', 'Hospital View', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(522, '2025', 'Mercy', 'Kyomuhendo', '2005-02-05', 'Female', '111', 'Main Street', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(523, '2025', 'Solomon', 'Busingye', '2006-10-18', 'Male', '332', 'Church Road', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(524, '2025', 'Brenda', 'Tumusiime', '2008-04-17', 'Female', '251', 'School Road', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(525, '2025', 'Samuel', 'Waiswa', '2005-07-23', 'Male', '448', 'Main Street', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(526, '2025', 'Joseph', 'Ochieng', '2006-12-08', 'Male', '412', 'Central Avenue', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(527, '2025', 'Mercy', 'Byaruhanga', '2006-01-20', 'Female', '118', 'School Road', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(528, '2025', 'Ritah', 'Nantogo', '2005-12-06', 'Female', '112', 'School Road', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(529, '2025', 'David', 'Mukasa', '2007-01-06', 'Male', '339', 'Church Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(530, '2025', 'Peter', 'Kyomuhendo', '2008-04-28', 'Male', '210', 'Main Street', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(531, '2025', 'John', 'Kyomuhendo', '2005-11-30', 'Male', '373', 'Church Road', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(532, '2025', 'Peter', 'Ssemwogerere', '2007-03-30', 'Male', '168', 'Church Road', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(533, '2025', 'Joy', 'Ochieng', '2007-12-31', 'Female', '199', 'Church Road', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(534, '2025', 'Joseph', 'Ochieng', '2007-12-09', 'Male', '377', 'Main Street', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(535, '2025', 'Peter', 'Nantogo', '2005-02-12', 'Male', '130', 'Church Road', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(536, '2025', 'Winnie', 'Byaruhanga', '2006-01-05', 'Female', '12', 'School Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(537, '2025', 'Grace', 'Mukasa', '2007-10-23', 'Female', '152', 'Hospital View', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(538, '2025', 'Brenda', 'Namukasa', '2005-03-28', 'Female', '224', 'Main Street', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(539, '2025', 'Doreen', 'Mugabe', '2007-10-02', 'Female', '325', 'School Road', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(540, '2025', 'Mary', 'Mukasa', '2008-11-16', 'Female', '420', 'Central Avenue', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(541, '2025', 'John', 'Nalubega', '2008-10-06', 'Male', '375', 'Market Lane', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(542, '2025', 'Ivan', 'Nakato', '2009-04-10', 'Male', '432', 'Hospital View', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(543, '2025', 'Sandra', 'Ochieng', '2005-11-07', 'Female', '147', 'Central Avenue', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(544, '2025', 'Daniel', 'Nakato', '2008-02-07', 'Male', '125', 'Market Lane', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(545, '2025', 'Joy', 'Byaruhanga', '2006-02-18', 'Female', '263', 'Central Avenue', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(546, '2025', 'Samuel', 'Busingye', '2007-09-17', 'Male', '27', 'School Road', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(547, '2025', 'Ritah', 'Kyomuhendo', '2008-10-20', 'Female', '52', 'Church Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png');
INSERT INTO `students` (`AdmissionNo`, `AdmissionYear`, `Name`, `Surname`, `DateOfBirth`, `Gender`, `HouseNo`, `Street`, `Village`, `Town`, `District`, `State`, `Country`, `PhotoPath`) VALUES
(548, '2025', 'Joan', 'Namukasa', '2008-01-09', 'Female', '341', 'School Road', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(549, '2025', 'Pritah', 'Okello', '2006-01-21', 'Female', '56', 'Central Avenue', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(550, '2025', 'Sandra', 'Nantogo', '2008-08-01', 'Female', '41', 'Church Road', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(551, '2025', 'Alice', 'Okello', '2009-07-27', 'Female', '4', 'Church Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(552, '2025', 'Rebecca', 'Nalubega', '2008-05-11', 'Female', '495', 'Central Avenue', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(553, '2025', 'Solomon', 'Lwanga', '2005-02-27', 'Male', '484', 'Hospital View', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(554, '2025', 'Paul', 'Nakato', '2009-06-16', 'Male', '34', 'School Road', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(555, '2025', 'Sarah', 'Okello', '2005-05-19', 'Female', '43', 'Church Road', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(556, '2025', 'Sarah', 'Nalubega', '2005-04-14', 'Female', '30', 'Main Street', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(557, '2025', 'Joy', 'Busingye', '2005-04-29', 'Female', '285', 'School Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(558, '2025', 'Joseph', 'Nalubega', '2007-08-18', 'Male', '257', 'Central Avenue', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(559, '2025', 'Sandra', 'Ssemwogerere', '2006-07-11', 'Female', '482', 'Central Avenue', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(560, '2025', 'Doreen', 'Ssemwogerere', '2006-04-13', 'Female', '46', 'Hospital View', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(561, '2025', 'Mercy', 'Lwanga', '2008-05-08', 'Female', '194', 'Central Avenue', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(562, '2025', 'Isaac', 'Lwanga', '2008-10-11', 'Male', '498', 'Hospital View', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(563, '2025', 'Moses', 'Kyomuhendo', '2008-07-03', 'Male', '489', 'Hospital View', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(564, '2025', 'Joy', 'Ssemwogerere', '2009-03-20', 'Female', '257', 'Main Street', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(565, '2025', 'Mary', 'Byaruhanga', '2007-06-09', 'Female', '153', 'Main Street', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(566, '2025', 'Isaac', 'Kyomuhendo', '2005-04-18', 'Male', '297', 'Hospital View', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(567, '2025', 'Timothy', 'Waiswa', '2006-12-07', 'Male', '273', 'School Road', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(568, '2025', 'Grace', 'Nakato', '2006-12-20', 'Female', '202', 'Central Avenue', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(569, '2025', 'Winnie', 'Nantogo', '2005-08-02', 'Female', '336', 'Main Street', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(570, '2025', 'Esther', 'Akello', '2006-02-27', 'Female', '62', 'Central Avenue', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(571, '2025', 'Samuel', 'Mukasa', '2006-11-20', 'Male', '142', 'Church Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(572, '2025', 'Mark', 'Opio', '2006-04-17', 'Male', '426', 'Market Lane', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(573, '2025', 'Daniel', 'Lwanga', '2008-06-20', 'Male', '261', 'School Road', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(574, '2025', 'Solomon', 'Nantogo', '2008-07-19', 'Male', '258', 'Market Lane', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(575, '2025', 'Winnie', 'Ssemwogerere', '2007-02-10', 'Female', '139', 'Main Street', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(576, '2025', 'Doreen', 'Aine', '2007-08-31', 'Female', '284', 'Church Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(577, '2025', 'Peter', 'Nalubega', '2008-05-27', 'Male', '231', 'Church Road', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(578, '2025', 'Brenda', 'Mukasa', '2006-03-31', 'Female', '303', 'Church Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(579, '2025', 'Joy', 'Nalubega', '2008-08-11', 'Female', '499', 'Hospital View', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(580, '2025', 'Sarah', 'Kato', '2006-04-01', 'Female', '23', 'Market Lane', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(581, '2025', 'Solomon', 'Okello', '2006-01-01', 'Male', '415', 'School Road', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(582, '2025', 'Brenda', 'Ochieng', '2005-04-03', 'Female', '273', 'School Road', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(583, '2025', 'Doreen', 'Busingye', '2005-11-20', 'Female', '427', 'Hospital View', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(584, '2025', 'Rebecca', 'Namukasa', '2005-11-10', 'Female', '262', 'Main Street', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(585, '2025', 'Peter', 'Aine', '2008-01-29', 'Male', '139', 'School Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(586, '2025', 'Paul', 'Opio', '2006-05-05', 'Male', '16', 'Market Lane', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(587, '2025', 'Winnie', 'Opio', '2009-04-20', 'Female', '216', 'School Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(588, '2025', 'Mercy', 'Musoke', '2006-05-06', 'Female', '230', 'Market Lane', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(589, '2025', 'Ritah', 'Akello', '2005-09-30', 'Female', '62', 'Main Street', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(590, '2025', 'Grace', 'Namukasa', '2005-09-20', 'Female', '107', 'School Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(591, '2025', 'Sarah', 'Ssemwogerere', '2006-05-09', 'Female', '488', 'Main Street', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(592, '2025', 'Sarah', 'Namukasa', '2009-10-29', 'Female', '229', 'Market Lane', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(593, '2025', 'David', 'Okello', '2006-02-28', 'Male', '399', 'Church Road', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(594, '2025', 'Samuel', 'Mukasa', '2006-12-30', 'Male', '195', 'Hospital View', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(595, '2025', 'Daniel', 'Mukasa', '2009-04-12', 'Male', '232', 'Hospital View', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(596, '2025', 'Andrew', 'Nalubega', '2005-10-26', 'Male', '83', 'Church Road', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(597, '2025', 'Ivan', 'Waiswa', '2005-01-10', 'Male', '227', 'Church Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(598, '2025', 'Peter', 'Ssemwogerere', '2007-12-28', 'Male', '41', 'School Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(599, '2025', 'John', 'Namukasa', '2006-11-28', 'Male', '442', 'Church Road', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(600, '2025', 'Samuel', 'Kato', '2008-03-07', 'Male', '277', 'Central Avenue', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(601, '2025', 'Mary', 'Kyomuhendo', '2005-05-25', 'Female', '118', 'Central Avenue', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(602, '2025', 'Samuel', 'Mugabe', '2009-06-19', 'Male', '355', 'Central Avenue', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(603, '2025', 'David', 'Nakato', '2009-09-07', 'Male', '225', 'Market Lane', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(604, '2025', 'Peter', 'Tumusiime', '2005-04-22', 'Male', '179', 'School Road', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(605, '2025', 'Alice', 'Nalubega', '2008-07-17', 'Female', '55', 'Market Lane', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(606, '2025', 'Brenda', 'Namukasa', '2009-05-01', 'Female', '292', 'Church Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(607, '2025', 'Brian', 'Akello', '2005-02-04', 'Male', '65', 'School Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(608, '2025', 'Mark', 'Nakato', '2008-03-14', 'Male', '389', 'Central Avenue', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(609, '2025', 'Alice', 'Namukasa', '2007-11-06', 'Female', '173', 'Main Street', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(610, '2025', 'Solomon', 'Mugabe', '2007-02-28', 'Male', '56', 'Church Road', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(611, '2025', 'Pritah', 'Mugabe', '2007-12-22', 'Female', '3', 'Church Road', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(612, '2025', 'Joy', 'Opio', '2006-01-06', 'Female', '188', 'Church Road', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(613, '2025', 'Samuel', 'Opio', '2008-08-28', 'Male', '30', 'Main Street', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(614, '2025', 'Winnie', 'Tumusiime', '2009-09-17', 'Female', '420', 'Market Lane', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(615, '2025', 'Esther', 'Byaruhanga', '2009-08-09', 'Female', '2746', 'Central Avenue', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(616, '2025', 'Rebecca', 'Nakato', '2007-02-10', 'Female', '390', 'School Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(617, '2025', 'Daniel', 'Musoke', '2006-06-05', 'Male', '288', 'Main Street', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(618, '2025', 'Mark', 'Byaruhanga', '2007-08-14', 'Male', '17', 'School Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(619, '2025', 'Pritah', 'Namukasa', '2009-02-08', 'Female', '92', 'Market Lane', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(620, '2025', 'Ritah', 'Ssemwogerere', '2007-12-04', 'Female', '103', 'Church Road', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(621, '2025', 'Peter', 'Kyomuhendo', '2009-04-02', 'Male', '150', 'Central Avenue', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(622, '2025', 'Peter', 'Kato', '2008-06-02', 'Male', '290', 'Central Avenue', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(623, '2025', 'Grace', 'Nantogo', '2005-04-26', 'Female', '420', 'Central Avenue', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(624, '2025', 'Rebecca', 'Okello', '2007-06-20', 'Female', '51', 'Main Street', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(625, '2025', 'Brian', 'Nakato', '2005-02-03', 'Male', '98', 'Central Avenue', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(626, '2025', 'Ivan', 'Aine', '2007-08-09', 'Male', '34', 'Hospital View', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(627, '2025', 'Joan', 'Akello', '2008-06-30', 'Female', '93', 'Hospital View', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(628, '2025', 'Brian', 'Musoke', '2007-05-09', 'Male', '272', 'Church Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(629, '2025', 'Brenda', 'Tumusiime', '2007-06-17', 'Female', '405', 'School Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(630, '2025', 'John', 'Lwanga', '2007-03-18', 'Male', '94', 'School Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(631, '2025', 'Mark', 'Lwanga', '2007-11-02', 'Male', '161', 'Central Avenue', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(632, '2025', 'Andrew', 'Tumusiime', '2008-08-28', 'Male', '439', 'Church Road', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(633, '2025', 'Paul', 'Byaruhanga', '2006-07-19', 'Male', '150', 'School Road', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(634, '2025', 'Alice', 'Nakato', '2007-12-25', 'Female', '287', 'Main Street', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(635, '2025', 'Sarah', 'Busingye', '2007-07-20', 'Female', '84', 'Church Road', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(636, '2025', 'Daniel', 'Waiswa', '2008-03-13', 'Male', '127', 'Market Lane', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(637, '2025', 'Alice', 'Mukasa', '2009-05-14', 'Female', '457', 'Central Avenue', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(638, '2025', 'Andrew', 'Aine', '2006-12-26', 'Male', '181', 'School Road', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(639, '2025', 'Alice', 'Nakato', '2008-08-30', 'Female', '64', 'Market Lane', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(640, '2025', 'Alice', 'Namukasa', '2008-04-01', 'Female', '339', 'Market Lane', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(641, '2025', 'Alice', 'Busingye', '2005-07-25', 'Female', '491', 'School Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(642, '2025', 'Daniel', 'Mugabe', '2005-11-13', 'Male', '6', 'School Road', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(643, '2025', 'Mercy', 'Lwanga', '2007-06-28', 'Female', '331', 'Hospital View', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(644, '2025', 'Daniel', 'Musoke', '2006-01-16', 'Male', '117', 'School Road', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(645, '2025', 'Grace', 'Ochieng', '2006-05-01', 'Female', '444', 'School Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(646, '2025', 'Grace', 'Namukasa', '2006-01-30', 'Female', '255', 'Central Avenue', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(647, '2025', 'Solomon', 'Waiswa', '2009-08-16', 'Male', '237', 'School Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(648, '2025', 'Solomon', 'Mugabe', '2008-06-07', 'Male', '122', 'Main Street', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(649, '2025', 'Andrew', 'Byaruhanga', '2007-09-25', 'Male', '60', 'Central Avenue', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(650, '2025', 'Mark', 'Lwanga', '2007-12-24', 'Male', '233', 'School Road', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(651, '2025', 'Mary', 'Kyomuhendo', '2005-02-10', 'Female', '15', 'Main Street', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(652, '2025', 'Joy', 'Tumusiime', '2005-06-10', 'Female', '417', 'Central Avenue', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(653, '2025', 'Joseph', 'Mugabe', '2009-08-21', 'Male', '247', 'Hospital View', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(654, '2025', 'Brian', 'Ssemwogerere', '2006-04-02', 'Male', '175', 'Central Avenue', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(655, '2025', 'David', 'Tumusiime', '2008-02-07', 'Male', '377', 'Central Avenue', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(656, '2025', 'Moses', 'Nantogo', '2005-01-25', 'Male', '301', 'Central Avenue', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(657, '2025', 'Sandra', 'Musoke', '2007-05-28', 'Female', '493', 'Market Lane', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(658, '2025', 'Timothy', 'Namukasa', '2006-07-06', 'Male', '74', 'Hospital View', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(659, '2025', 'Brenda', 'Opio', '2007-12-21', 'Female', '136', 'School Road', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(660, '2025', 'Mark', 'Mukasa', '2009-04-19', 'Male', '417', 'School Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(661, '2025', 'Joseph', 'Busingye', '2009-06-03', 'Male', '114', 'Market Lane', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(662, '2025', 'Brian', 'Lwanga', '2008-12-22', 'Male', '88', 'Market Lane', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(663, '2025', 'Sandra', 'Kyomuhendo', '2007-03-23', 'Female', '332', 'Central Avenue', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(664, '2025', 'Mary', 'Ochieng', '2009-08-06', 'Female', '205', 'Church Road', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(665, '2025', 'Paul', 'Aine', '2005-10-08', 'Male', '246', 'Central Avenue', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(666, '2025', 'Moses', 'Nalubega', '2007-01-12', 'Male', '304', 'Hospital View', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(667, '2025', 'Peter', 'Mugabe', '2009-10-05', 'Male', '421', 'Market Lane', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(668, '2025', 'Samuel', 'Lwanga', '2006-08-25', 'Male', '463', 'School Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(669, '2025', 'John', 'Byaruhanga', '2006-08-27', 'Male', '285', 'Central Avenue', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(670, '2025', 'Joan', 'Mugabe', '2005-06-22', 'Female', '101', 'Hospital View', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(671, '2025', 'Daniel', 'Waiswa', '2008-06-16', 'Male', '243', 'Market Lane', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(672, '2025', 'Rebecca', 'Tumusiime', '2009-05-21', 'Female', '37', 'Hospital View', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(673, '2025', 'Samuel', 'Nalubega', '2008-04-03', 'Male', '271', 'Hospital View', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(674, '2025', 'Solomon', 'Opio', '2008-06-11', 'Male', '164', 'School Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(675, '2025', 'John', 'Opio', '2006-02-02', 'Male', '18', 'School Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(676, '2025', 'Winnie', 'Kato', '2009-02-13', 'Female', '98', 'School Road', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(677, '2025', 'Samuel', 'Busingye', '2008-10-12', 'Male', '29', 'Main Street', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(678, '2025', 'Brenda', 'Ssemwogerere', '2006-06-07', 'Female', '354', 'Hospital View', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(679, '2025', 'Moses', 'Okello', '2007-12-04', 'Male', '168', 'Central Avenue', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(680, '2025', 'Sarah', 'Aine', '2007-03-01', 'Female', '430', 'Central Avenue', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(681, '2025', 'Rebecca', 'Mukasa', '2008-01-30', 'Female', '379', 'Central Avenue', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(682, '2025', 'Mary', 'Musoke', '2006-05-19', 'Female', '170', 'Central Avenue', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(683, '2025', 'Ritah', 'Akello', '2006-10-09', 'Female', '4', 'Central Avenue', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(684, '2025', 'Timothy', 'Kyomuhendo', '2009-04-25', 'Male', '475', 'Main Street', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(685, '2025', 'Joy', 'Mukasa', '2008-12-02', 'Female', '141', 'Main Street', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(686, '2025', 'Solomon', 'Ochieng', '2009-12-19', 'Male', '481', 'Hospital View', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(687, '2025', 'Joy', 'Mugabe', '2006-09-16', 'Female', '479', 'Hospital View', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(688, '2025', 'Samuel', 'Busingye', '2008-03-04', 'Male', '261', 'Hospital View', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(689, '2025', 'Peter', 'Opio', '2005-08-12', 'Male', '308', 'Hospital View', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(690, '2025', 'Pritah', 'Musoke', '2008-11-22', 'Female', '473', 'Market Lane', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(691, '2025', 'Peter', 'Nantogo', '2005-10-17', 'Male', '438', 'Central Avenue', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(692, '2025', 'Peter', 'Mugabe', '2008-05-19', 'Male', '284', 'Hospital View', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(693, '2025', 'Doreen', 'Byaruhanga', '2008-10-18', 'Female', '328', 'Central Avenue', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(694, '2025', 'Paul', 'Nakato', '2008-08-07', 'Male', '165', 'Market Lane', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(695, '2025', 'Paul', 'Waiswa', '2007-10-02', 'Male', '236', 'Hospital View', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(696, '2025', 'Ivan', 'Mukasa', '2006-10-26', 'Male', '134', 'Church Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(697, '2025', 'Andrew', 'Mukasa', '2006-05-24', 'Male', '338', 'School Road', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(698, '2025', 'John', 'Aine', '2005-05-05', 'Male', '149', 'Church Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(699, '2025', 'Moses', 'Nantogo', '2009-07-09', 'Male', '57', 'Central Avenue', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(700, '2025', 'Brenda', 'Aine', '2008-04-09', 'Female', '255', 'School Road', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(701, '2025', 'Esther', 'Byaruhanga', '2005-06-23', 'Female', '159', 'Church Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(702, '2025', 'Ritah', 'Okello', '2006-09-07', 'Female', '41', 'Market Lane', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(703, '2025', 'Peter', 'Lwanga', '2005-06-24', 'Male', '332', 'Main Street', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(704, '2025', 'Brian', 'Waiswa', '2009-03-28', 'Male', '191', 'Market Lane', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(705, '2025', 'Sandra', 'Namukasa', '2009-11-05', 'Female', '143', 'School Road', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(706, '2025', 'Solomon', 'Musoke', '2008-01-01', 'Male', '483', 'Main Street', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(707, '2025', 'Mercy', 'Ssemwogerere', '2009-07-20', 'Female', '317', 'Market Lane', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(708, '2025', 'Isaac', 'Nantogo', '2006-11-06', 'Male', '83', 'Hospital View', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(709, '2025', 'Timothy', 'Lwanga', '2006-04-09', 'Male', '476', 'Central Avenue', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(710, '2025', 'Esther', 'Aine', '2008-11-24', 'Female', '405', 'Hospital View', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(711, '2025', 'Paul', 'Ochieng', '2008-11-11', 'Male', '263', 'Church Road', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(712, '2025', 'Mark', 'Byaruhanga', '2006-06-12', 'Male', '3', 'Main Street', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(713, '2025', 'Solomon', 'Okello', '2005-06-10', 'Male', '185', 'School Road', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(714, '2025', 'Brian', 'Nakato', '2005-03-16', 'Male', '154', 'Market Lane', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(715, '2025', 'Brenda', 'Ochieng', '2005-07-09', 'Female', '409', 'Hospital View', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(716, '2025', 'Grace', 'Mukasa', '2008-03-01', 'Female', '326', 'Market Lane', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(717, '2025', 'Daniel', 'Ochieng', '2009-06-17', 'Male', '244', 'Hospital View', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(718, '2025', 'Rebecca', 'Tumusiime', '2009-11-21', 'Female', '265', 'Hospital View', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(719, '2025', 'Solomon', 'Ssemwogerere', '2006-05-19', 'Male', '113', 'Church Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(720, '2025', 'Isaac', 'Kato', '2005-04-13', 'Male', '321', 'Main Street', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(721, '2025', 'Moses', 'Namukasa', '2006-01-30', 'Male', '291', 'Church Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(722, '2025', 'Mark', 'Nalubega', '2009-07-25', 'Male', '9', 'Market Lane', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(723, '2025', 'Andrew', 'Kyomuhendo', '2007-01-23', 'Male', '166', 'Market Lane', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(724, '2025', 'Paul', 'Byaruhanga', '2007-11-28', 'Male', '264', 'Central Avenue', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(725, '2025', 'Grace', 'Kyomuhendo', '2007-09-01', 'Female', '134', 'Hospital View', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(726, '2025', 'Doreen', 'Opio', '2008-08-23', 'Female', '245', 'Church Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(727, '2025', 'Joy', 'Kyomuhendo', '2005-05-22', 'Female', '327', 'Main Street', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(728, '2025', 'Ivan', 'Ochieng', '2005-03-20', 'Male', '362', 'Market Lane', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(729, '2025', 'Isaac', 'Kyomuhendo', '2005-10-28', 'Male', '31', 'Hospital View', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(730, '2025', 'David', 'Kato', '2008-02-24', 'Male', '381', 'Central Avenue', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(731, '2025', 'Mercy', 'Akello', '2009-03-18', 'Female', '112', 'School Road', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(732, '2025', 'Brian', 'Kato', '2006-12-27', 'Male', '69', 'Market Lane', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(733, '2025', 'Joy', 'Kato', '2005-07-13', 'Female', '432', 'Central Avenue', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(734, '2025', 'Daniel', 'Kato', '2005-02-10', 'Male', '114', 'Main Street', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(735, '2025', 'Joy', 'Mukasa', '2005-02-25', 'Female', '204', 'Central Avenue', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(736, '2025', 'Pritah', 'Kato', '2006-09-14', 'Female', '438', 'Market Lane', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(737, '2025', 'Alice', 'Namukasa', '2008-01-22', 'Female', '258', 'Hospital View', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(738, '2025', 'Paul', 'Nantogo', '2006-09-18', 'Male', '238', 'Market Lane', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(739, '2025', 'Joseph', 'Akello', '2006-02-01', 'Male', '6', 'Market Lane', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(740, '2025', 'Andrew', 'Waiswa', '2009-05-23', 'Male', '361', 'Central Avenue', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(741, '2025', 'Joan', 'Aine', '2005-02-06', 'Female', '427', 'Church Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(742, '2025', 'Grace', 'Mukasa', '2008-04-19', 'Female', '383', 'Central Avenue', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(743, '2025', 'Peter', 'Tumusiime', '2005-09-02', 'Male', '337', 'Central Avenue', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(744, '2025', 'Timothy', 'Byaruhanga', '2005-01-12', 'Male', '401', 'Central Avenue', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(745, '2025', 'Samuel', 'Tumusiime', '2005-02-23', 'Male', '197', 'Central Avenue', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(746, '2025', 'Ritah', 'Opio', '2009-11-25', 'Female', '114', 'Church Road', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(747, '2025', 'Moses', 'Kyomuhendo', '2009-04-11', 'Male', '354', 'Central Avenue', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(748, '2025', 'Mark', 'Waiswa', '2007-01-25', 'Male', '308', 'Central Avenue', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(749, '2025', 'Joseph', 'Nalubega', '2007-12-21', 'Male', '425', 'Market Lane', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(750, '2025', 'John', 'Nantogo', '2007-01-04', 'Male', '461', 'Market Lane', 'Mbale Central', 'Mbale', 'Mbale', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(751, '2025', 'Sarah', 'Mugabe', '2007-06-25', 'Female', '115', 'School Road', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(752, '2025', 'Joy', 'Byaruhanga', '2006-11-28', 'Female', '124', 'Main Street', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(753, '2025', 'Mercy', 'Ssemwogerere', '2009-05-15', 'Female', '218', 'School Road', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(754, '2025', 'Peter', 'Okello', '2006-12-28', 'Male', '86', 'School Road', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(755, '2025', 'Joseph', 'Mukasa', '2008-05-05', 'Male', '85', 'Central Avenue', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(756, '2025', 'Paul', 'Waiswa', '2008-04-30', 'Male', '497', 'Central Avenue', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(757, '2025', 'Doreen', 'Nalubega', '2006-07-28', 'Female', '221', 'Church Road', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(758, '2025', 'Esther', 'Busingye', '2008-07-25', 'Female', '212', 'Central Avenue', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(759, '2025', 'John', 'Mukasa', '2005-02-03', 'Male', '494', 'Central Avenue', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(760, '2025', 'Isaac', 'Opio', '2006-01-12', 'Male', '199', 'Market Lane', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(761, '2025', 'Joy', 'Namukasa', '2008-01-08', 'Female', '146', 'School Road', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(762, '2025', 'Samuel', 'Musoke', '2005-09-03', 'Male', '464', 'Church Road', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(763, '2025', 'Moses', 'Busingye', '2008-11-09', 'Male', '152', 'Church Road', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(764, '2025', 'Samuel', 'Waiswa', '2006-10-16', 'Male', '5', 'Central Avenue', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(765, '2025', 'Timothy', 'Ochieng', '2007-07-01', 'Male', '81', 'Church Road', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(766, '2025', 'Isaac', 'Aine', '2009-12-18', 'Male', '167', 'Hospital View', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(767, '2025', 'Samuel', 'Ochieng', '2006-10-01', 'Male', '29', 'Church Road', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(768, '2025', 'Esther', 'Ssemwogerere', '2008-03-04', 'Female', '9', 'Church Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(769, '2025', 'Pritah', 'Musoke', '2007-12-21', 'Female', '58', 'Hospital View', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(770, '2025', 'Esther', 'Lwanga', '2006-10-22', 'Female', '304', 'Central Avenue', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(771, '2025', 'Alice', 'Ssemwogerere', '2008-10-23', 'Female', '163', 'Market Lane', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(772, '2025', 'Ivan', 'Nakato', '2005-06-09', 'Male', '459', 'Church Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(773, '2025', 'Mercy', 'Aine', '2005-07-23', 'Female', '344', 'Main Street', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(774, '2025', 'Andrew', 'Mukasa', '2005-10-21', 'Male', '90', 'Market Lane', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(775, '2025', 'Solomon', 'Mukasa', '2006-07-17', 'Male', '218', 'Church Road', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(776, '2025', 'Peter', 'Akello', '2006-11-12', 'Male', '486', 'Hospital View', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(777, '2025', 'Peter', 'Waiswa', '2005-08-13', 'Male', '364', 'Church Road', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(778, '2025', 'Pritah', 'Nantogo', '2009-04-29', 'Female', '203', 'Market Lane', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(779, '2025', 'Moses', 'Aine', '2009-08-02', 'Male', '498', 'Church Road', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(780, '2025', 'Brenda', 'Namukasa', '2008-05-16', 'Female', '384', 'Hospital View', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(781, '2025', 'Ritah', 'Okello', '2008-01-25', 'Female', '139', 'School Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(782, '2025', 'Alice', 'Tumusiime', '2005-12-06', 'Female', '221', 'School Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(783, '2025', 'John', 'Mugabe', '2005-10-01', 'Male', '323', 'Hospital View', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(784, '2025', 'Solomon', 'Nantogo', '2009-03-10', 'Male', '49', 'Central Avenue', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(785, '2025', 'Andrew', 'Kyomuhendo', '2006-05-17', 'Male', '355', 'Hospital View', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(786, '2025', 'Winnie', 'Musoke', '2005-06-04', 'Female', '219', 'Central Avenue', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(787, '2025', 'Joy', 'Nalubega', '2008-06-15', 'Female', '420', 'Main Street', 'Kampala Central', 'Kampala', 'Kampala', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(788, '2025', 'Doreen', 'Tumusiime', '2007-09-17', 'Female', '329', 'School Road', 'Jinja Central', 'Jinja', 'Jinja', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(789, '2025', 'Winnie', 'Ssemwogerere', '2007-05-26', 'Female', '254', 'Main Street', 'Lira Central', 'Lira', 'Lira', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(790, '2025', 'Isaac', 'Nalubega', '2005-03-01', 'Male', '186', 'Hospital View', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(791, '2025', 'Solomon', 'Okello', '2005-06-22', 'Male', '183', 'School Road', 'Fort Portal Central', 'Fort Portal', 'Fort Portal', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(792, '2025', 'Joy', 'Byaruhanga', '2007-04-21', 'Female', '265', 'Church Road', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(793, '2025', 'Paul', 'Waiswa', '2007-05-22', 'Male', '82', 'Market Lane', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(794, '2025', 'Doreen', 'Nantogo', '2008-10-19', 'Female', '341', 'Main Street', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(795, '2025', 'Isaac', 'Mukasa', '2005-01-09', 'Male', '156', 'School Road', 'Masaka Central', 'Masaka', 'Masaka', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(796, '2025', 'Brian', 'Nalubega', '2005-04-15', 'Male', '243', 'Church Road', 'Soroti Central', 'Soroti', 'Soroti', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(797, '2025', 'Isaac', 'Nakato', '2008-11-29', 'Male', '73', 'Market Lane', 'Mbarara Central', 'Mbarara', 'Mbarara', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(798, '2025', 'Joan', 'Byaruhanga', '2007-06-13', 'Female', '44', 'Central Avenue', 'Arua Central', 'Arua', 'Arua', 'Central Region', 'Uganda', 'static/images/default_profile.png'),
(799, '2025', 'Ritah', 'Ochieng', '2007-05-21', 'Female', '327', 'Hospital View', 'Gulu Central', 'Gulu', 'Gulu', 'Central Region', 'Uganda', 'assets/uploads/799/799_6936d497a76f2.png'),
(814, '2025', 'Shiva', 'Kurada', '2025-12-01', 'Male', '401', 'wisely colony', 'Miyapur', 'Miyapur', 'Hyderabad', 'Telanaga', 'Uganda', 'assets/uploads/students/814/814_6937b5fa05f6b.jpeg'),
(818, '2025', 'Shiva', 'Kurada', '2025-12-01', 'Male', '401', 'wisely colony', 'Miyapur', 'Miyapur', 'Hyderabad', 'Telanaga', 'Uganda', 'assets/uploads/students/818/818_6937bb571019e.jpeg'),
(819, '2025', 'Shiva', 'Kurada', '2025-12-01', 'Female', '401', 'wisely colony', 'Miyapur', 'Miyapur', 'Hyderabad', 'Telanaga', 'Uganda', 'assets/uploads/students/819/819_6937bc30cd8fc.jpeg'),
(821, '2025', 'Shiva', 'Kurada', '2025-12-01', 'Male', '401', 'wisely colony', 'Miyapur', 'Miyapur', 'Hyderabad', 'Telanaga', 'Uganda', 'assets/uploads/students/821/821_6937bc870c8a3.jpeg');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `academichistory`
--
ALTER TABLE `academichistory`
  ADD PRIMARY KEY (`HistoryID`),
  ADD KEY `AdmissionNo` (`AdmissionNo`);

--
-- Indexes for table `enrollment`
--
ALTER TABLE `enrollment`
  ADD PRIMARY KEY (`EnrollmentID`),
  ADD KEY `AdmissionNo` (`AdmissionNo`);

--
-- Indexes for table `enrollmenthistory`
--
ALTER TABLE `enrollmenthistory`
  ADD PRIMARY KEY (`HistoryID`),
  ADD KEY `AdmissionNo` (`AdmissionNo`);

--
-- Indexes for table `parents`
--
ALTER TABLE `parents`
  ADD PRIMARY KEY (`ParentId`),
  ADD KEY `AdmissionNo` (`AdmissionNo`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`AdmissionNo`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `academichistory`
--
ALTER TABLE `academichistory`
  MODIFY `HistoryID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=810;

--
-- AUTO_INCREMENT for table `enrollment`
--
ALTER TABLE `enrollment`
  MODIFY `EnrollmentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=810;

--
-- AUTO_INCREMENT for table `enrollmenthistory`
--
ALTER TABLE `enrollmenthistory`
  MODIFY `HistoryID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `parents`
--
ALTER TABLE `parents`
  MODIFY `ParentId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=810;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `AdmissionNo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=822;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `academichistory`
--
ALTER TABLE `academichistory`
  ADD CONSTRAINT `academichistory_ibfk_1` FOREIGN KEY (`AdmissionNo`) REFERENCES `students` (`AdmissionNo`) ON DELETE CASCADE;

--
-- Constraints for table `enrollment`
--
ALTER TABLE `enrollment`
  ADD CONSTRAINT `enrollment_ibfk_1` FOREIGN KEY (`AdmissionNo`) REFERENCES `students` (`AdmissionNo`) ON DELETE CASCADE;

--
-- Constraints for table `enrollmenthistory`
--
ALTER TABLE `enrollmenthistory`
  ADD CONSTRAINT `enrollmenthistory_ibfk_1` FOREIGN KEY (`AdmissionNo`) REFERENCES `students` (`AdmissionNo`) ON DELETE CASCADE;

--
-- Constraints for table `parents`
--
ALTER TABLE `parents`
  ADD CONSTRAINT `parents_ibfk_1` FOREIGN KEY (`AdmissionNo`) REFERENCES `students` (`AdmissionNo`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
