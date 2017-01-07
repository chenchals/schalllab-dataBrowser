
-- Schema for schalllab metadata
CREATE TABLE `subject`(
  `subject_id` INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(50) NOT NULL,
  `initials` VARCHAR(5) NOT NULL,
  `species` VARCHAR(100) DEFAULT NULL,
  `data_dir` VARCHAR(50) DEFAULT NULL,
  `is_active` VARCHAR(1) DEFAULT NULL,
  `dob` DATE DEFAULT NULL,
  `acquisition_date` DATE DEFAULT NULL,
  `dod` DATE DEFAULT NULL,
  `gender` VARCHAR(1) DEFAULT NULL,
  UNIQUE KEY `ak_subject_initials`(`initials`)
);
CREATE TABLE `person`(
  `person_id` INT(10) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `initials` VARCHAR(5) NOT NULL,
  `firstname` VARCHAR(100) NOT NULL,
  `lastname` VARCHAR(100) NOT NULL,
  `email` VARCHAR(100) DEFAULT NULL,
  UNIQUE KEY `ak_person_initials`(`initials`)
);
CREATE TABLE `study`(
  `study_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `subject_initials` VARCHAR(5) NOT NULL,
  `person_initials` VARCHAR(5) DEFAULT NULL,
  `data_dir` VARCHAR(100) NOT NULL,
  `data_file` VARCHAR(100) NOT NULL,
  `file_date` DATE NOT NULL,
  `study_date` DATE DEFAULT NULL,
  `description` VARCHAR(100) DEFAULT NULL,
  `comment` VARCHAR(200) DEFAULT NULL,
  UNIQUE KEY `ak_data_file`(`data_file`)
);
CREATE TABLE `publication`(
  `publication_id` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `category` VARCHAR(255) DEFAULT NULL,
  `citation` VARCHAR(255) NOT NULL,
  `pdf_url` VARCHAR(255) DEFAULT NULL,
  `year` INT(10) DEFAULT NULL
 );