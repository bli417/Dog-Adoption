-- When a particular month ('$Month_A') in Animal Control Dog Count section is clicked:
-- ◼ Find Dog details for dogs in ('$DogSetA') of ('$Month_A').
SELECT D.dogID, D.name, D.sex, D.altered, D.microchipID, D.surrender_date,
IFNULL((SELECT GROUP_CONCAT(BR.name SEPARATOR ' / ') 
    FROM Belong BE 
    JOIN Breed BR ON BE.breedID = BR.breedID
    WHERE  D.dogID = BE.dogID),'Unknown') AS breed
-- IF( TIMESTAMPDIFF(DAY, D.surrender_date, AA.adopted_date) >= 60, TIMESTAMPDIFF(DAY, D.surrender_date, AA.adopted_date), NULL) AS days_in_rescue
FROM `Dog` D
-- JOIN `AdoptionApplication` AA ON D.dogID = AA.dogID
WHERE D.is_animal_control_surrender = True AND DATE_FORMAT(D.surrender_date , '%Y-%m') = ?
ORDER BY D.dogID ASC