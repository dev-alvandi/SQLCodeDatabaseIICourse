CREATE DATABASE dbb;
USE dbb;

CREATE TABLE Book(
ISBN bigint not null, 
title varchar(200) not null,
author varchar (200) not null,
publisher char(50) not null, 
publishingYear year not null, 
bookCategory int not null, 
primary key(ISBN)
);


CREATE TABLE DVD(
dvdNo int not null, 
title char(50) not null, 
director char(50) not null,
releaseYear year not null, 
genre enum('documentary', 'romance', 'comedy', 'drama', 'thriller', 'horror') not null, 
loanTime int default 14,
primary key (dvdNo)
); 

INSERT INTO Book (`ISBN`, `title`, `author`, `publisher`, `publishingYear`, `bookCategory`) VALUES ('9781292061184', 'Database Systems: A Practical Approach to Design, Implementation, and Management', 'Thomas Connolly, Carolyn Begg, Addison Wesley', 'Pearson', 2014, '2');
INSERT INTO Book (`ISBN`, `title`, `author`, `publisher`, `publishingYear`, `bookCategory`) VALUES ('9781684204519', 'Atlas of Anatomy', 'Anne M Gilroy, Brian R MacPherson, Jamie Wikenheiser, Michael Schuenke, Erik Schulte', 'Thieme Medical Publishers Inc', 2021, '2');
INSERT INTO Book (`ISBN`, `title`, `author`, `publisher`, `publishingYear`, `bookCategory`) VALUES ('9780750662246', 'Contemporary Theory of Conservation', 'Salvador Munoz-Vinas', 'Butterworth-Heinemann Ltd', 2004, '2');
INSERT INTO Book (`ISBN`, `title`, `author`, `publisher`, `publishingYear`, `bookCategory`) VALUES ('9781408883358', 'The Priory of the Orange Tree', 'Samantha Shannon', 'Bloomsburt Publishing PLC', 2020, '1');
INSERT INTO Book (`ISBN`, `title`, `author`, `publisher`, `publishingYear`, `bookCategory`) VALUES ('9780008376116', 'The Hobbit', 'J.R.R Tolkien', 'HarperCollins', 2020, '1');
INSERT INTO Book (`ISBN`, `title`, `author`, `publisher`, `publishingYear`, `bookCategory`) VALUES ('9789132211676', 'Boktjuven', 'Markus Zusak', 'B Wahlströms', 2019, '1');
INSERT INTO Book (`ISBN`, `title`, `author`, `publisher`, `publishingYear`, `bookCategory`) VALUES ('9789178876235', 'Kaka på kaka: godare  fika året runt', 'Camilla Hamid', 'Bonnier Fakta', 2023, '1');

INSERT INTO DVD (`dvdNo`, `title`, `director`, `releaseYear`, `genre`) VALUES ('1', 'Dune: Part Two', 'Denis Villeneuve', 2024, 'drama');
INSERT INTO DVD (`dvdNo`, `title`, `director`, `releaseYear`, `genre`) VALUES ('2', 'The Holiday', 'Nancy Meyers', 2006, 'romance');
INSERT INTO DVD (`dvdNo`, `title`, `director`, `releaseYear`, `genre`) VALUES ('3', 'The Ritual', 'David Bruckner', 2017, 'horror');
INSERT INTO DVD (`dvdNo`, `title`, `director`, `releaseYear`, `genre`) VALUES ('4', 'Modig', 'Mark Andrews, Brenda Chapman, Steve Purcell', 2012, 'drama');
INSERT INTO DVD (`dvdNo`, `title`, `director`, `releaseYear`, `genre`) VALUES ('5', 'Hammarskjöld', 'Per Fly', 2023, 'drama');

CREATE TABLE User(
userID INT PRIMARY KEY AUTO_INCREMENT,
userCategory INT NOT NULL,
email CHAR(40) NOT NULL,
firstName CHAR(30) NOT NULL,
lastName CHAR(30) NOT NULL,
streetName CHAR(30) NOT NULL,
city CHAR(30) NOT NULL,
postCode CHAR(5) NOT NULL,
activeLoans INT NOT NULL DEFAULT 0,
UNIQUE (email)
);

ALTER TABLE User AUTO_INCREMENT = 100000; 

CREATE TABLE Reservation(
reservationNo INT PRIMARY KEY AUTO_INCREMENT,
reservationDate TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
userID INT NOT NULL,
ISBN BIGINT,
dvdNo INT,
CONSTRAINT FK_reservingUser FOREIGN KEY (userID) REFERENCES User(userID),
CONSTRAINT FK_reservedISBN FOREIGN KEY (ISBN) REFERENCES Book(ISBN),
CONSTRAINT FK_reserveDVD FOREIGN KEY (dvdNo) REFERENCES DVD(dvdNo)
);

INSERT INTO User (userCategory, email, firstName, lastName, streetName, city, postCode)
VALUES
      (1, "jorgen.nilsson@ltu.se", "Jörgen", "Nilsson", "Laboratorievägen 14", "Luleå", 97187),
      (3, "kalka-4@ltu.student.se", "Kalle", "Karlsson", "Sommarstigen 35", "Borås", 50330),
      (1, "sara.silvertand@ltu.se", "Sara", "Silvertand", "Hermelinsgatan 10", "Luleå", 97234),
      (2, "solvig.tandberg@ltu.se", "Solvig", "Tandberg", "Laboratorievägen 14", "Luleå", 97187),
      (3, "noora-2@ltu.student.se", "Noora", "Randig", "Arkeologgatan 7", "Västerås", 72353);

CREATE TABLE BookCopy (
    bookCopyID INT AUTO_INCREMENT PRIMARY KEY,
    ISBN BIGINT,
    isReferenceCopy INT, -- 0 för false, 1 för true
    onLoan INT, -- 0 for false, 1 for true
    title VARCHAR(200),
    bookCategory INT, -- 1 för vanlig, 2 för kurslitt
    FOREIGN KEY (ISBN) REFERENCES Book(ISBN)
);

CREATE TABLE DVDCopy (
    dvdCopyID INT AUTO_INCREMENT PRIMARY KEY,
    dvdNo INT,
    title CHAR(50),
    onLoan INT, -- 0 for false, 1 for true
    FOREIGN KEY (dvdNo) REFERENCES DVD(dvdNo)
);

INSERT INTO BookCopy (ISBN, isReferenceCopy, onLoan, title, bookCategory) VALUES 
(9781292061184, 0, 0, 'Database Systems: A Practical Approach to Design, Implementation, and Management', 2),
(9781684204519, 0, 1, 'Atlas of Anatomy', 2),
(9780750662246, 1, 0, 'Contemporary Theory of Conservation', 2),
(9781408883358, 0, 0, 'The Priory of the Orange Tree', 1),
(9780008376116, 1, 1, 'The Hobbit', 1),
(9789132211676, 0, 0, 'Boktjuven', 1),
(9789178876235, 1, 0, 'Kaka på kaka: godare fika året runt', 1),
(9781292061184, 1, 1, 'Database Systems: A Practical Approach to Design, Implementation, and Management', 2),
(9781684204519, 0, 0, 'Atlas of Anatomy', 2),
(9780750662246, 1, 1, 'Contemporary Theory of Conservation', 2),
(9781408883358, 0, 0, 'The Priory of the Orange Tree', 1),
(9780008376116, 1, 1, 'The Hobbit', 1),
(9789132211676, 0, 0, 'Boktjuven', 1),
(9789178876235, 1, 1, 'Kaka på kaka: godare fika året runt', 1),
(9781292061184, 0, 1, 'Database Systems: A Practical Approach to Design, Implementation, and Management', 2),
(9781684204519, 1, 0, 'Atlas of Anatomy', 2),
(9780750662246, 0, 1, 'Contemporary Theory of Conservation', 2),
(9781408883358, 1, 0, 'The Priory of the Orange Tree', 1),
(9780008376116, 0, 0, 'The Hobbit', 1),
(9789132211676, 1, 1, 'Boktjuven', 1);

INSERT INTO DVDCopy (dvdNo, title, onLoan) VALUES 
(1, 'Dune: Part Two', 0),
(1, 'Dune: Part Two', 1),
(2, 'The Holiday', 0),
(2, 'The Holiday', 1),
(3, 'The Ritual', 1),
(4, 'Modig', 0),
(4, 'Modig', 1),
(5, 'Hammarskjöld', 0),
(5, 'Hammarskjöld', 1),
(1, 'Dune: Part Two', 0),
(1, 'Dune: Part Two', 1),
(2, 'The Holiday', 0),
(2, 'The Holiday', 1),
(3, 'The Ritual', 1),
(4, 'Modig', 0),
(4, 'Modig', 1),
(5, 'Hammarskjöld', 0),
(5, 'Hammarskjöld', 1),
(1, 'Dune: Part Two', 0),
(2, 'The Holiday', 1);



CREATE TABLE Loan(
	loanID int NOT NULL AUTO_INCREMENT,
	userID int NOT NULL,
	loanDate date NOT NULL,
	PRIMARY KEY (loanID),
	FOREIGN KEY (userID) REFERENCES User(userID)
);

CREATE TABLE ItemLoan(
	itemLoanNo int NOT NULL AUTO_INCREMENT,
	loanID int NOT NULL,
	bookCopyID int, 
	dvdCopyID int,
	userID int NOT NULL,
	returnDate date NOT NULL,
	PRIMARY KEY (itemLoanNo),
	FOREIGN KEY (loanID) REFERENCES Loan(loanID),
	FOREIGN KEY (bookCopyID) REFERENCES BookCopy(bookCopyID),
	FOREIGN KEY (dvdCopyID) REFERENCES DVDCopy(dvdCopyID)
);
