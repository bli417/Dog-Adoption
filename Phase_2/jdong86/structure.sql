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

INSERT INTO User VALUES
('jdong86@gatech.edu', '', 'Jiatang', 'Dong', '4046001234', '2020-1-1', true),
('blu71@gatech.edu', '', 'Boyan', 'Lu', '4046001235', '2020-1-2', false),
('bli417@gatech.edu', '', 'Ben', 'Li', '4046001236', '2020-1-3', false),
('ptang39@gatech.edu', '', 'Pei', 'Tang', '4046001237', '2020-1-5', false);

INSERT INTO Dog VALUES
(1, 'Fanny', 'Female', true, '2015-6-1', 'Black short hair, bad temper', true, '2019-11-04', 'can not afford', 'FASAAFDDS0011', 'bli417@gatech.edu'),
(2, 'Polly', 'Unknown', true, '2017-3-1', 'Black medium hair, nice', true, '2020-02-04', 'can not afford', 'AEDFAEDS0232', 'ptang39@gatech.edu'),
(3, 'Polly', 'Unknown', true, '2017-3-1', 'Black short hair, nice', true, '2020-02-04', 'can not afford', 'AEBAFDDS0232', 'ptang39@gatech.edu'),
(4, 'Fanny', 'Female', false, '2020-1-1', 'White long hair, nice personality', false, '2020-01-02', 'too small', null, 'jdong86@gatech.edu'),
(5, 'Tony', 'Male', false, '2018-1-1', 'Yellow medium hair, nice', false, '2020-01-03', 'too big', null, 'blu71@gatech.edu'),
(6, 'Boby', 'Unknown', false, '2013-6-1', 'Yellow medium hair, nice', false, '2020-01-04', 'too old', null, 'bli417@gatech.edu'),
(7, 'Polly', 'Male', false, '2015-6-1', 'Black short hair, nice', true, '2020-02-04', 'can not afford', 'FEFFAFDDS6742', 'bli417@gatech.edu'),
(8, 'Naomi', 'Female', false, '2014-6-1', 'Green short hair, nice', false, '2020-02-04', 'can not afford', 'EAAFAFDDS0212', 'bli417@gatech.edu'),
(9, 'Polly', 'Male', false, '2015-6-1', 'White long hair, nice', false, '2020-02-04', 'can not afford', 'BEFAFDDS0010', 'bli417@gatech.edu'),
(10, 'Su', 'Male', true, '2015-6-1', 'White long hair, nice', true, '2020-02-14', 'can not afford', 'BEFAFDDS1010', 'bli417@gatech.edu'),
(11, 'Kami', 'Male', true, '2015-6-1', 'White long hair, nice', true, '2020-01-14', 'can not afford', 'BEFAFDDS1011', 'bli417@gatech.edu');

INSERT INTO Breed VALUES
(1, 'Unknown'),
(2, 'Mixed'),
(3, 'Affenpinscher'),
(4, 'Afghan Hound'),
(5, 'Akbash Dog'),
(6, 'Akita'),
(7, 'Alapaha Blue Blood Bulldog');


INSERT INTO Belong VALUES
(1, 2),
(2, 3),
(3, 4),
(3, 7),
(4, 1),
(5, 5),
(5, 6),
(5, 7),
(6, 2),
(7, 4),
(7, 6),
(7, 7),
(8, 1),
(9, 3),
(9, 4),
(9, 5);

INSERT INTO Expense VALUES
(1, '2020-1-10', 'Pet Smart', 250.11, null),
(1, '2020-1-10', 'Voli Vet', 1250.23, 'leg injury'),
(5, '2020-3-10', 'Pet Smart', 152.11, 'Anti allergy medications'),
(9, '2020-3-12', 'Pet Smart', 52.11, 'Food'),
(9, '2020-3-13', 'Pet Smart', 22.52, 'More Food'),
(9, '2020-3-14', 'Pet Smart', 12.33, 'Even More Food');


INSERT INTO Adopter VALUES
('jiatang.dong@gmail.com','Jia','Don', '5023695114','546 Felt St','Seattle', 'WA','98000'),
('binli10@gmail.com','Bin','Li', '2423695114','5436 Feltdsfsa St','New York', 'NY','10002'),
('lilactp@gmail.com','Lily','Tang', '8325654101','8012 Orleans DR','Nashville', 'TN','37115'),
('blu.wrk@gmail.com', 'Bo', 'Lu', '2322624101','7620 NE Roswell RD','Atlanta', 'GA','30328');

INSERT INTO AdoptionApplication VALUES
(100, 'jiatang.dong@gmail.com', 'Julia','Jin', 'rejected', '2020-01-31', null, null, null),
(101, 'jiatang.dong@gmail.com', 'Julia','Jin', 'approved', '2020-04-11', 1, '2020-05-01',  54.43),
(102, 'binli10@gmail.com', 'Julia','Jin', 'approved', '2020-04-21', null, null, null),
(103, 'lilactp@gmail.com', null, null, 'approved', '2020-05-31', null, null, null),
(104, 'lilactp@gmail.com', null, null, 'approved', '2020-05-31', 10, '2020-06-01',  52.13),
(105, 'blu.wrk@gmail.com', 'Jiayue', 'LY', 'approved', '2020-04-22', 11, '2020-05-01',  152.23);