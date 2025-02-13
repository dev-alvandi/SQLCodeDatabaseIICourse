DELIMITER //

CREATE FUNCTION getUserLoans(userID INT)
RETURNS JSON
DETERMINISTIC
BEGIN
    DECLARE loanDetails JSON;

    -- Retrieve the loans for the specified user as a JSON array
    SELECT JSON_ARRAYAGG(
               JSON_OBJECT(
                   'loanID', l.loanID,
                   'loanDate', l.loanDate,
                   'returnDate', il.returnDate,
                   'itemType', CASE 
                                   WHEN il.bookCopyID IS NOT NULL THEN 'book' 
                                   ELSE 'dvd' 
                               END,
                   'itemID', COALESCE(il.bookCopyID, il.dvdCopyID)
               )
           ) INTO loanDetails
    FROM Loan l
    JOIN ItemLoan il ON l.loanID = il.loanID
    WHERE l.userID = userID;

    -- Check if user has no loans
    IF loanDetails IS NULL THEN
        SET loanDetails = JSON_ARRAY(); -- Return an empty array if no loans found
    END IF;

    RETURN loanDetails;  -- Return the loans as a JSON array
END //

DELIMITER ;

SELECT getUserLoans(100002);