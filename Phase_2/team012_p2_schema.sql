-- CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'password';
-- CREATE USER IF NOT EXISTS gatechUser@localhost IDENTIFIED BY 'gatech123';

-- DROP DATABASE IF EXISTS `cs6400_su20_team012`; 
-- SET default_storage_engine=InnoDB;
-- SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CREATE DATABASE IF NOT EXISTS cs6400_su20_team012     
-- DEFAULT CHARACTER SET utf8mb4
-- DEFAULT COLLATE utf8mb4_unicode_ci;
-- USE cs6400_su20_team012;

-- GRANT SELECT, INSERT, UPDATE, DELETE, FILE ON *.* TO 'gatechUser'@'localhost';
-- GRANT ALL PRIVILEGES ON `gatechuser`.* TO 'gatechUser'@'localhost';
-- GRANT ALL PRIVILEGES ON `cs6400_su20_team012`.* TO 'gatechUser'@'localhost';
-- FLUSH PRIVILEGES;

-- Tables 
CREATE TABLE User(
	email varchar(50) NOT NULL,
	password varchar(250) NOT NULL,
	first_name varchar(50) NOT NULL,
	last_name varchar(50) NOT NULL,
	cell_phone varchar(20) NOT NULL,
	started_date date NOT NULL,
	is_admin bool NOT NULL,
	PRIMARY KEY (email)
);

CREATE TABLE Dog(  
	dogID  int(16) unsigned NOT NULL AUTO_INCREMENT,  
	name varchar(50) NOT NULL,  
	sex varchar(7) NOT NULL, 
	altered bool NOT NULL,
	birth_date date NOT NULL,
	description text NOT NULL,
  	is_animal_control_surrender bool NOT NULL,
	surrender_date date NOT NULL,
	surrender_reason text NOT NULL,
	microchipID varchar(25) DEFAULT NULL,
	created_by varchar(50) NOT NULL,
	PRIMARY KEY (dogID),
	UNIQUE KEY (microchipID)
);

CREATE TABLE Expense(
	dogID  int(16) unsigned NOT NULL, 
	expense_date date NOT NULL,
	vendor varchar(250) NOT NULL,  
	amount real NOT NULL,
	description text DEFAULT NULL,
	PRIMARY KEY (dogID, vendor, expense_date)
);

CREATE TABLE Breed(
	breedID int(16) unsigned NOT NULL AUTO_INCREMENT, 
	name varchar(50) NOT NULL,  
	PRIMARY KEY (breedID),
	UNIQUE KEY (name)
);

CREATE TABLE Belong(
	dogID int(16) unsigned NOT NULL, 
	breedID int(16) unsigned NOT NULL, 
	PRIMARY KEY (dogID, breedID)
);

CREATE TABLE Adopter(
	email varchar(50) NOT NULL,
	first_name varchar(50) NOT NULL,
	last_name varchar(50) NOT NULL,
	cell_phone varchar(20) NOT NULL,
	street varchar(250) NOT NULL,
	city varchar(20) NOT NULL,
	state varchar(10) NOT NULL,
	zip_code varchar(12) NOT NULL,
	PRIMARY KEY (email)
);

CREATE TABLE AdoptionApplication(
	application_number int(16) NOT NULL AUTO_INCREMENT,
	adopter_email varchar(50) NOT NULL,
	coApp_first_name varchar(20) DEFAULT NULL,
	coApp_last_name varchar(20) DEFAULT NULL,
	approval_state varchar(20) NOT NULL DEFAULT "pending approval",
	apply_date date NOT NULL,
	dogID int(16) unsigned DEFAULT NULL,
	adopted_date date DEFAULT NULL,
	fee real DEFAULT NULL,
	PRIMARY KEY (application_number),
	UNIQUE KEY (dogID)
);


-- Constraints   Foreign Keys: FK_ChildTable_childColumn_ParentTable_parentColumn
ALTER TABLE Dog
	ADD CONSTRAINT fk_Dog_createdBy_User_email FOREIGN KEY (created_by) REFERENCES `User` (email);

ALTER TABLE Expense
	ADD CONSTRAINT fk_Expense_dogID_Dog_dogID FOREIGN KEY (dogID) REFERENCES `Dog` (dogID);

ALTER TABLE Belong
	ADD CONSTRAINT fk_Belong_dogID_dog_dogID FOREIGN KEY (dogID) REFERENCES `Dog` (dogID),
	ADD CONSTRAINT fk_Belong_breedID_Breed_breedID FOREIGN KEY (breedID) REFERENCES `Breed` (breedID);


ALTER TABLE AdoptionApplication
	ADD CONSTRAINT fk_AdoptionApplication_adopter_email_Adopter_email FOREIGN KEY (adopter_email) REFERENCES `Adopter` (email),
	ADD CONSTRAINT fk_AdoptionApplication_dogID_Dog_dogID FOREIGN KEY (dogID) REFERENCES `Dog` (dogID);
