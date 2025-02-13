DELIMITER //

CREATE TRIGGER CheckLoanLimit
BEFORE INSERT ON Loan
FOR EACH ROW
BEGIN
    DECLARE loanCount INT;
    DECLARE userCat INT;

    -- Get the userCategory for the new loan's userID
    SELECT userCategory INTO userCat
    FROM User
    WHERE userID = NEW.userID;

    -- Check how many loans the user currently has
    SELECT COUNT(*) INTO loanCount
    FROM Loan
    WHERE userID = NEW.userID;

    -- Check the borrowing limits based on user category
    IF userCat = 1 AND loanCount > 20 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User category 1 (Researcher) may not borrow more than 20 items';
    ELSEIF userCat = 2 AND loanCount > 10 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User category 2 (Teacher) may not borrow more than 10 items';
    ELSEIF userCat = 3 AND loanCount > 5 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User category 3 (Student) may not borrow more than 5 items';
    END IF;
END //

DELIMITER ;