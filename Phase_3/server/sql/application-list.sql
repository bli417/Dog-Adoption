SELECT application_number, CAST(apply_date AS char) AS apply_date, coApp_first_name, coApp_last_name, 
    adopter_email, first_name, last_name, cell_phone, street, city, state, zip_code, approval_state
FROM AdoptionApplication AD JOIN Adopter
ON Adopter.email = AD.adopter_email
WHERE approval_state = ? and AD.adopted_date IS NULL
ORDER BY application_number ASC