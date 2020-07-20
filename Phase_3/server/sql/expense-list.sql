SELECT CAST(expense_date AS char) AS expense_date, vendor, amount, description 
FROM Expense WHERE dogID = ?