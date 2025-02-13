DELIMITER //

CREATE FUNCTION getUserCategory(userID INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE retrievedUserCategory INT;

    -- Retrieve the userCategory from the User table
    SELECT u.userCategory INTO retrievedUserCategory
    FROM User u
    WHERE u.userID = userID;

    -- Check if user exists
    IF retrievedUserCategory IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User does not exist';
    END IF;

    RETURN retrievedUserCategory;  -- Return the userCategory
END //

DELIMITER ;
