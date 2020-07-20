UPDATE Dog SET
    name = ?,
    sex = ?,
    altered = ?,
    birth_date = ?,
    description = ?,
    is_animal_control_surrender = ?,
    surrender_date = ?,
    surrender_reason = ?,
    microchipID = ?
WHERE dogID = ?;
DELETE FROM Belong WHERE dogID = ?;
INSERT INTO Belong VALUES