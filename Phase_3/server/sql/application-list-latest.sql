SELECT * FROM (
SELECT MAX(apply_date) AS apply_date, MAX(application_number) AS application_number, 
      coApp_first_name, coApp_last_name, adopter_email,  adopted_date, approval_state
FROM AdoptionApplication
WHERE approval_state='approved' AND adopted_date IS NULL
GROUP BY adopter_email) AS AP LEFT JOIN Adopter on Adopter.email=AP.adopter_email;