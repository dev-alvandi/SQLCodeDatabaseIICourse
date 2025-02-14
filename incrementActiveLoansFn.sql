DELIMITER //

CREATE FUNCTION incrementActiveLoans(user_ID INT)
RETURNS INT
DETERMINISTIC
BEGIN
    -- Update activeLoans count for the user
    UPDATE User SET activeLoans = activeLoans + 1 WHERE userID = user_ID;
    
    -- Return the new activeLoans count
    RETURN (SELECT activeLoans FROM User WHERE userID = user_ID);
END //

DELIMITER ;
