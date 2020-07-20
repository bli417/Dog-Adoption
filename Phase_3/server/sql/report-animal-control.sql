-- Find Dog brought in by animal controls in current and last 6 months for each month ('$DogSetA').
-- ◼ Count the number of dogs in ('$DogSetA') as ('$DogCountA') by month. 
SELECT DATE_FORMAT(surrender_date, '%Y-%m') AS surrender_month, COUNT(dogID) AS dog_count
FROM `Dog`
WHERE is_animal_control_surrender = True AND surrender_date >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 6 MONTH) ,'%Y-%m-01 00:00:00')
GROUP BY surrender_month
ORDER BY surrender_month DESC;


-- Among dogs from ('$DogSetA'), find Dog adopted during each month who had spent in the rescue 60 days or more - ('$DogSetB').
-- ◼ Count the number of dogs in ('$DogSetB') as ('$DogCountB') by month.
SELECT DATE_FORMAT(AA.adopted_date , '%Y-%m') AS adopted_month, COUNT(D.dogID) AS dog_count
FROM `Dog` D
JOIN `AdoptionApplication` AA ON D.dogID = AA.dogID
WHERE D.is_animal_control_surrender = True 
AND AA.adopted_date IS NOT NULL AND TIMESTAMPDIFF (DAY, D.surrender_date, AA.adopted_date) >= 60
AND AA.adopted_date >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 6 MONTH) ,'%Y-%m-01 00:00:00')
GROUP BY adopted_month
ORDER BY adopted_month DESC;


-- Calculate total expense for Dog adopted for each month among ('$DogSetA'). Group result by month. 
SELECT DATE_FORMAT(AA.adopted_date, '%Y-%m') AS adopted_month,  SUM(E.amount) AS dog_expense
FROM `Dog` D
JOIN `AdoptionApplication` AA ON D.dogID = AA.dogID
JOIN `Expense` E ON  D.dogID = E.dogID
WHERE D.is_animal_control_surrender = True 
AND AA.adopted_date IS NOT NULL
AND AA.adopted_date >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 6 MONTH) ,'%Y-%m-01 00:00:00')
GROUP BY adopted_month
ORDER BY adopted_month DESC;