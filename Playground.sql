DROP DATABASE bbd;

USE bbd;

-- DROP TABLE LoanItem;

SELECT * FROM Book;
SELECT * FROM DVD;

SELECT * FROM BookCopy;
SELECT * FROM DVDCopy;

SELECT * FROM User;

SELECT * FROM Loan;
SELECT * FROM ItemLoan;

SELECT * FROM Reservation;


-- CALL MakeNewLoan(100002, 'book', 9781292061184, @newLoanID);
-- SELECT @newLoanID;

-- INSERT INTO Loan (userID, loanDate) VALUES (100003, CURDATE());
-- SELECT getUserCategory(100001);

CALL MakeNewLoan(100001, 'book', 9781292061184, @newLoanID);
CALL MakeNewLoan(100001, 'book', 9781684204519, @newLoanID);
CALL MakeNewLoan(100001, 'book', 9781408883358, @newLoanID);
CALL MakeNewLoan(100001, 'book', 9781408883358, @newLoanID);
CALL MakeNewLoan(100001, 'book', 9789132211676, @newLoanID);