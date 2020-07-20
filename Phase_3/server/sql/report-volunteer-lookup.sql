SELECT first_name, last_name, email, cell_phone
FROM `User`
WHERE is_admin = false AND ( LOWER (first_name) like LOWER(?) OR LOWER(last_name) like LOWER(?))
ORDER BY last_name ASC, first_name ASC
