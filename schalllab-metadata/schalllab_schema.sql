DROP TABLE IF EXISTS study;
DROP TABLE IF EXISTS person;
DROP TABLE IF EXISTS subject;


-- Schema for schalllab metadata
CREATE TABLE subject(
  subject_id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  subject_species VARCHAR(100),
  subject_name VARCHAR(50),
  subject_name_abbr VARCHAR(50),
  subject_data_dir VARCHAR(50),
  subject_is_active VARCHAR(1),
  subject_dob DATE,
  subject_acquisition_date DATE,
  subject_dod DATE,
  subject_gender VARCHAR(10)
);

CREATE TABLE person(
  person_id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  person_firstname VARCHAR(100),
  person_lastname VARCHAR(100),
  person_email VARCHAR(100)
);

CREATE TABLE study(
  study_id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  subject_id INT(10) UNSIGNED NOT NULL,
  person_id INT(10) UNSIGNED NOT NULL,
  study_datafile VARCHAR(100),
  study_description VARCHAR(100),
  study_date DATE
);

  

  
  