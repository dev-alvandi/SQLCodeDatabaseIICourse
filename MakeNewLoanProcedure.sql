DELIMITER //

CREATE PROCEDURE MakeNewLoan(
    IN p_userID INT,
    IN p_itemType ENUM('book', 'dvd'),
    IN p_itemID BIGINT, -- Refers to either ISBN on BookCopy table or dvdNo on DVDCopy table
    OUT p_loanID INT
)
BEGIN
    -- Declare variables
    DECLARE itemAvailable INT DEFAULT 0;
    DECLARE itemCopyID INT;
    DECLARE bookCat INT;
    DECLARE returnDate DATE;
    DECLARE isReference INT;

    -- Check if user exists
    IF (SELECT COUNT(*) FROM User WHERE userID = p_userID) = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User does not exist';
    END IF;

    -- Check the item type and its availability
    IF p_itemType = 'book' THEN
        -- Retrieve the bookCopyID, bookCategory, and isReferenceCopy
        SELECT bookCopyID, bookCategory, isReferenceCopy INTO itemCopyID, bookCat, isReference
        FROM BookCopy 
        WHERE ISBN = p_itemID AND onLoan = 0 
        LIMIT 1;
        
        IF itemCopyID IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No available copy of the book';
		ELSEIF isReference = 1 THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'All copies of the named book is borrowed except reference book which cannot be borrowed';
        ELSE
            SET itemAvailable = 1;

            -- Determine the loan duration based on bookCategory
            IF bookCat = 1 THEN
                SET returnDate = ADDDATE(CURDATE(), INTERVAL 2 MONTH);
            ELSEIF bookCat = 2 THEN
                SET returnDate = ADDDATE(CURDATE(), INTERVAL 1 MONTH);
            ELSE
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid book category';
            END IF;
        END IF;

    ELSEIF p_itemType = 'dvd' THEN
        -- Retrieve the dvdCopyID
        SELECT dvdCopyID INTO itemCopyID 
        FROM DVDCopy 
        WHERE dvdNo = p_itemID AND onLoan = 0 
        LIMIT 1;
        
        IF itemCopyID IS NULL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No available copy of the DVD';
        ELSE
            SET itemAvailable = 1;
            SET returnDate = ADDDATE(CURDATE(), INTERVAL 14 DAY);
        END IF;
    END IF;

    -- If item is available, create a new loan
    IF itemAvailable = 1 THEN
        INSERT INTO Loan (userID, loanDate) VALUES (p_userID, CURDATE());
        SET p_loanID = LAST_INSERT_ID();
        
        -- Invoke the function to increment active loans
        SET @newActiveLoans = incrementActiveLoans(p_userID);
        
        -- Insert item into ItemLoan
        IF p_itemType = 'book' THEN
            INSERT INTO ItemLoan (itemLoanNo, loanID, userID, bookCopyID, returnDate) 
            VALUES (NULL, p_loanID, p_userID, itemCopyID, returnDate);
        ELSEIF p_itemType = 'dvd' THEN
            INSERT INTO ItemLoan (itemLoanNo, loanID, userID, dvdCopyID, returnDate) 
            VALUES (NULL, p_loanID, p_userID, itemCopyID, returnDate);
        END IF;
        
        -- Update item onLoan status
        IF p_itemType = 'book' THEN
            UPDATE BookCopy SET onLoan = 1 WHERE bookCopyID = itemCopyID;
        ELSEIF p_itemType = 'dvd' THEN
            UPDATE DVDCopy SET onLoan = 1 WHERE dvdCopyID = itemCopyID;
        END IF;
    END IF;

END //

DELIMITER ;
