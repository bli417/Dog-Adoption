SELECT * FROM Dog WHERE dogID = ?;
SELECT BR.breedID, name FROM Belong BE 
LEFT JOIN Breed BR ON BE.BreedID = BR.BreedID 
WHERE dogID = ?;