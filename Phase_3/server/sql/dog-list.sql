SELECT D.dogID, name, sex, altered, microchipID,
    -- The sample data only have age column, we are trying to recreate the same data here
    -- But TIMESTAMPDIFF with NOW() instead of surrender_date should make more sense
    TIMESTAMPDIFF(MONTH, birth_date, surrender_date) AS age, 
    surrender_date,
    (altered AND NOT ISNULL(microchipID)) AS adoptable
FROM Dog D LEFT JOIN AdoptionApplication A
ON D.dogID = A.dogID
WHERE A.application_number IS NULL
ORDER BY surrender_date ASC