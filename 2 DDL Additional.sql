ALTER TABLE customer
ADD CONSTRAINT CHK_Gender CHECK (gender IN ('Male', 'Female', 'Other'));

CREATE INDEX IDX_TransactionDate ON transactions(transaction_date);

ALTER TABLE customer
ADD CONSTRAINT UQ_Email UNIQUE (email_ID);

ALTER TABLE accounts
ADD CONSTRAINT CHK_Balance CHECK (current_balance >= 0);

ALTER TABLE Customer_Offer
ADD CONSTRAINT DF_Status DEFAULT 'Pending' FOR Status;

ALTER TABLE lockers
ADD CONSTRAINT UQ_Locker_SortCode UNIQUE (locker_ID, sort_code);


ALTER TABLE employee
ADD CONSTRAINT DF_JoinDate DEFAULT GETDATE() FOR join_date;





