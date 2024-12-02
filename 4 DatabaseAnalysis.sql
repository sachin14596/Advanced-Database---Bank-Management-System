//************
BASIC QUERIES
************//

--1. Retrieve the basic details of all customers, including their name, gender, and email.

SELECT COUNT(*) AS No_Of_Customers FROM customer;

SELECT customer_name, gender, email_ID
FROM customer;

--2. Retrieve the customer names and addresses who live in a specific city (e.g., "London").

SELECT customer_name, address
FROM customer
WHERE address LIKE '%London%';

--3. Total balance across all accounts

SELECT SUM(current_balance) AS total_balance 
FROM accounts;


//******************
INTERMEDIATE QUERIES
******************//

-- 4. Retrieve the details of customers who have taken out a loan with details.

SELECT c.customer_name, l.loan_id, l.date_initiated, l.loan_duration, l.interest
FROM customer c
JOIN loan l ON c.Customer_ID = l.customer_ID;

--5. Retrieve the top 5 customers with the highest account balances.

SELECT TOP (5) c.customer_name, a.current_balance
FROM customer c
JOIN accounts a ON c.Customer_ID = a.customer_ID
ORDER BY a.current_balance DESC;

--6. Retrieve a summary of the total transaction amount per month for each year.

SELECT YEAR(transaction_date) AS year, MONTH(transaction_date) AS month, SUM(amount) AS total_amount
FROM transactions
GROUP BY YEAR(transaction_date), MONTH(transaction_date)
ORDER BY year, month;

--7. Retrieve a detailed audit trail for all updates made to customer records, 
--	 including who made the changes and when.

SELECT a.Entity_Type, a.Entity_ID, a.Changed_By, a.Change_Date, a.Change_Details
FROM Audit a
WHERE a.Entity_Type = 'Customer' AND a.Change_Type = 'Update'
ORDER BY a.Change_Date DESC;



//******************
ADVANCED QUERIES
******************//

--8. Top 10 Rank customers based on their account balance within each branch 
--   and return their rank along with their details.

SELECT TOP (10)
    c.customer_name, 
    b.branch_address, 
    a.current_balance,
    RANK() OVER (PARTITION BY b.branch_id ORDER BY a.current_balance DESC) AS balance_rank
FROM customer c
JOIN accounts a ON c.Customer_ID = a.customer_ID
JOIN branch b ON a.sort_code = b.sort_code;


--9. Retrieves customer information along with their account type 
--   and a status indicator based on their current balance. 

--   The status should be as follows:
--   "Low Balance" if the balance is below 5000,
--   "Medium Balance" if the balance is between 5000 and 20000,
--   "High Balance" if the balance is above 20000.

SELECT 
    c.customer_name,
    a.acc_type,
    a.current_balance,
    CASE
        WHEN a.current_balance < 5000 THEN 'Low Balance'
        WHEN a.current_balance BETWEEN 5000 AND 20000 THEN 'Medium Balance'
        ELSE 'High Balance'
    END AS balance_status
FROM 
    customer c
INNER JOIN 
    accounts a
    ON c.Customer_ID = a.customer_ID
WHERE 
    a.acc_type = 'Savings';

--10. Transferring Funds Between Two Accounts

CREATE PROCEDURE TransferFunds
    @FromAccountID NVARCHAR(8),
    @ToAccountID NVARCHAR(8),
    @Amount DECIMAL(18, 2)
AS
BEGIN
    BEGIN TRY
        -- Start the transaction
        BEGIN TRANSACTION;

        -- Debit the amount from the sender's account
        UPDATE accounts
        SET current_balance = current_balance - @Amount
        WHERE customer_ID = @FromAccountID;

        -- Credit the amount to the recipient's account
        UPDATE accounts
        SET current_balance = current_balance + @Amount
        WHERE customer_ID = @ToAccountID;

        -- If everything is successful, commit the transaction
        COMMIT TRANSACTION;
        
        PRINT 'Transaction completed successfully.';
    END TRY
    BEGIN CATCH
        -- Rollback the transaction if there is any error
        ROLLBACK TRANSACTION;
        
        PRINT 'Transaction failed. Rolled back.';
    END CATCH
END;


SELECT customer_ID, current_balance 
FROM accounts 
WHERE customer_ID IN ('C000001', 'C000002');

EXEC TransferFunds @FromAccountID = 'C000001', @ToAccountID = 'C000002', @Amount = 1000.00;

SELECT customer_ID, current_balance 
FROM accounts 
WHERE customer_ID IN ('C000001', 'C000002');


