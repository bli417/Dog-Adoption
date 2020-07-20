SELECT FJ.month, FJ.breed, IFNULL (SC.sur_count,0) AS sur_count, IFNULL(AC.ado_count,0) AS ado_count, IFNULL(TE.expense,0) AS total_expense, IFNULL(AF.ado_fee,0) AS total_adoption_fee,
IFNULL(AF.ado_fee,0) - IFNULL(TE.expense,0) AS net_profit
FROM (
    --  Since MySQL doesn’t support FULL OUTER JOIN, we need union all 'month' and 'breed' combination for all other results to LEFT JOIN with
    SELECT DATE_FORMAT(D.surrender_date, '%Y-%m') AS month, 
    IFNULL((SELECT GROUP_CONCAT( BR.name)
        FROM Belong BE 
        JOIN Breed BR ON BE.breedID = BR.breedID
        WHERE  D.dogID = BE.dogID
        ORDER BY BR.name ASC), 'Unknown') AS breed
    FROM `Dog` D
    WHERE D.surrender_date >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 11 MONTH) ,'%Y-%m-01 00:00:00')
    GROUP BY DATE_FORMAT(D.surrender_date, '%Y-%m'), breed

    UNION

    SELECT DATE_FORMAT(AA.adopted_date, '%Y-%m') AS month, 
    IFNULL((SELECT GROUP_CONCAT( BR.name)
        FROM Belong BE 
        JOIN Breed BR ON BE.breedID = BR.breedID
        WHERE  D.dogID = BE.dogID
        ORDER BY BR.name ASC), 'Unknown') AS breed
    FROM `Dog` D
    JOIN `AdoptionApplication` AA ON D.dogID = AA.dogID
    WHERE AA.adopted_date IS NOT NULL AND AA.adopted_date >=  DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 11 MONTH) ,'%Y-%m-01 00:00:00')
    GROUP BY DATE_FORMAT(AA.adopted_date, '%Y-%m'), breed

    UNION

    SELECT DATE_FORMAT(E.expense_date, '%Y-%m') AS month, 
    IFNULL((SELECT GROUP_CONCAT(BR.name)
        FROM Belong BE 
        JOIN Breed BR ON BE.breedID = BR.breedID
        WHERE  D.dogID = BE.dogID
        ORDER BY BR.name ASC),'Unknown')  AS breed
    FROM `Dog` D
    JOIN `Expense` E ON  D.dogID = E.dogID
    WHERE E.expense_date >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 11 MONTH) ,'%Y-%m-01 00:00:00')
    GROUP BY DATE_FORMAT(D.surrender_date, '%Y-%m'), breed
) AS FJ

LEFT JOIN (
    SELECT DATE_FORMAT(D.surrender_date, '%Y-%m') AS sur_month, 
    IFNULL((SELECT GROUP_CONCAT(BR.name)
        FROM Belong BE 
        JOIN Breed BR ON BE.breedID = BR.breedID
        WHERE  D.dogID = BE.dogID
        ORDER BY BR.name ASC),'Unknown')  AS breed,
    COUNT(D.dogID) AS sur_count 
    FROM `Dog` D
    WHERE D.surrender_date >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 11 MONTH) ,'%Y-%m-01 00:00:00')
    GROUP BY DATE_FORMAT(D.surrender_date, '%Y-%m'), breed
) AS SC
ON SC.sur_month = FJ.month AND SC.breed = FJ.breed

LEFT JOIN (
    SELECT DATE_FORMAT(AA.adopted_date, '%Y-%m') AS ado_month, 
    IFNULL((SELECT GROUP_CONCAT(BR.name)
        FROM Belong BE 
        JOIN Breed BR ON BE.breedID = BR.breedID
        WHERE  D.dogID = BE.dogID
        ORDER BY BR.name ASC),'Unknown')  AS breed,
    COUNT(D.dogID) AS ado_count 
    FROM `Dog` D
    JOIN `AdoptionApplication` AA ON D.dogID = AA.dogID
    WHERE AA.adopted_date IS NOT NULL AND AA.adopted_date >=  DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 11 MONTH) ,'%Y-%m-01 00:00:00')
    GROUP BY DATE_FORMAT(AA.adopted_date, '%Y-%m'), breed
) AS AC 
ON AC.ado_month = FJ.month AND AC.breed = FJ.breed

LEFT JOIN (
    SELECT DATE_FORMAT(E.expense_date, '%Y-%m') AS exp_month, 
    IFNULL((SELECT GROUP_CONCAT(BR.name)
        FROM Belong BE 
        JOIN Breed BR ON BE.breedID = BR.breedID
        WHERE  D.dogID = BE.dogID
        ORDER BY BR.name ASC),'Unknown')  AS breed,
    SUM(E.amount) AS expense
    FROM `Dog` D
    JOIN `Expense` E ON  D.dogID = E.dogID
    WHERE E.expense_date >= DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 11 MONTH) ,'%Y-%m-01 00:00:00')
    GROUP BY DATE_FORMAT(D.surrender_date, '%Y-%m'), breed
) AS TE
ON TE.exp_month = FJ.month AND TE.breed = FJ.breed

LEFT JOIN (
    SELECT DATE_FORMAT(AA.adopted_date, '%Y-%m') AS ado_month, 
    IFNULL((SELECT GROUP_CONCAT(BR.name)
        FROM Belong BE 
        JOIN Breed BR ON BE.breedID = BR.breedID
        WHERE  D.dogID = BE.dogID
        ORDER BY BR.name ASC
    ), 'Unknown') AS breed,
    SUM(E.amount)*1.15 AS ado_fee
    FROM `Dog` D
    JOIN `Expense` E ON  D.dogID = E.dogID
    JOIN `AdoptionApplication` AA ON D.dogID = AA.dogID
    WHERE AA.adopted_date IS NOT NULL AND AA.adopted_date >=  DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 11 MONTH) ,'%Y-%m-01 00:00:00')
    GROUP BY DATE_FORMAT(AA.adopted_date, '%Y-%m'), breed
) AS AF 
ON AF.ado_month = FJ.month AND AF.breed = FJ.breed
ORDER BY FJ.month ASC, FJ.breed ASC
