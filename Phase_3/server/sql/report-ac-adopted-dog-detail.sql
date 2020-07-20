-- When a particular month ('$Month_B') in the Adopted Dog Count section is clicked:
-- ◼ Find Dog details for dogs in ('$DogSetB') of ('$Month_B').
-- ◼ For dogs in ('$DogSetB'), calculate the number of days they were in rescue ('$DaysInRescue').
SELECT D.dogID, D.name, D.sex, D.altered, D.microchipID, AA.adopted_date, D.surrender_date,
IFNULL((SELECT GROUP_CONCAT(BR.name SEPARATOR ' / ') 
    FROM Belong BE 
    JOIN Breed BR ON BE.breedID = BR.breedID
    WHERE  D.dogID = BE.dogID),'Unknown') AS breed,
TIMESTAMPDIFF(DAY, D.surrender_date, AA.adopted_date) AS days_in_rescue
FROM `Dog` D
JOIN `AdoptionApplication` AA ON D.dogID = AA.dogID
WHERE D.is_animal_control_surrender = True 
    AND AA.adopted_date IS NOT NULL 
    AND TIMESTAMPDIFF(DAY, D.surrender_date, AA.adopted_date) >= 60 
    AND DATE_FORMAT(AA.adopted_date, '%Y-%m') = ?
ORDER BY days_in_rescue DESC, D.dogID DESC
