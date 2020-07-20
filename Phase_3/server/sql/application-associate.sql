SET  @fee =(SELECT IF( D.is_animal_control_surrender IS TRUE, SUM( E.amount)*0.15 , SUM( E.amount) 	*1.15) AS fee
  FROM Dog D LEFT JOIN Expense E ON D.dogID = E.dogID
  WHERE E.dogID = ?);

UPDATE AdoptionApplication SET 
        dogID = ?,
        adopted_date = ?,
        fee = @fee
        WHERE application_number = ?;
