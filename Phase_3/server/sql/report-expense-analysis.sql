SELECT vendor, SUM(amount) AS total_expense
FROM `Expense`
GROUP BY vendor
ORDER BY total_expense DESC