
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
CREATE TABLE study(
  study_id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  subject_id INT(10) UNSIGNED NOT NULL,
  person_id INT(10) UNSIGNED NOT NULL,
  study_datafile VARCHAR(100),
  study_description VARCHAR(100),
  study_date DATE
);
CREATE TABLE person(
  person_id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  person_firstname VARCHAR(100),
  person_lastname VARCHAR(100),
  person_email VARCHAR(100)
);





-- Constraints
--ALTER TABLE
--  study ADD CONSTRAINT subject_fk FOREIGN KEY(subject_id) REFERENCES subject(subject_id) ON DELETE CASCADE ON UPDATE RESTRICT;
--ALTER TABLE
 -- study ADD CONSTRAINT study_person_fk FOREIGN KEY(person_id) REFERENCES person(person_id) ON DELETE CASCADE ON UPDATE RESTRICT;
--ALTER TABLE
--  person_study_role ADD CONSTRAINT person_study_role_person_fk FOREIGN KEY(person_id, study_id) REFERENCES study(person_id, study_id) ON DELETE CASCADE ON UPDATE RESTRICT;
  
  
  