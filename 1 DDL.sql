-- 1. Customer Table
CREATE TABLE customer (
    Customer_ID VARCHAR(8) NOT NULL PRIMARY KEY,
    customer_name VARCHAR(80) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    DOB DATE NOT NULL,
    age INT NOT NULL CHECK (age >= 18),
    address VARCHAR(100) NOT NULL,
    email_ID VARCHAR(80) NOT NULL,
    SSN VARCHAR(30) UNIQUE NOT NULL
);

-- 2. Branch Table
CREATE TABLE branch (
    branch_id INT NOT NULL PRIMARY KEY,  -- New primary key for branch
    sort_code VARCHAR(8) NOT NULL,       -- sort_code is no longer unique
    branch_address VARCHAR(100) NOT NULL,
    phone_No VARCHAR(15) NOT NULL,
    region VARCHAR(50) NOT NULL,
    zip_code VARCHAR(10) NOT NULL
);

-- 3. Departments Table
CREATE TABLE departments (
    dept_id VARCHAR(20) NOT NULL PRIMARY KEY,
    dept_name VARCHAR(80) NOT NULL
);

-- 4. ATM Table
CREATE TABLE atm (
    atm_ID VARCHAR(20) NOT NULL PRIMARY KEY,
    atm_address VARCHAR(100) NOT NULL,
    sort_code VARCHAR(8) NOT NULL  -- Regular column, no FK due to non-unique values
);

-- 5. Lockers Table
CREATE TABLE lockers (
    locker_ID INT NOT NULL PRIMARY KEY,
    customer_id VARCHAR(8) NOT NULL,
    sort_code VARCHAR(8) NOT NULL,  -- Regular column, no FK due to non-unique values
    FOREIGN KEY (customer_ID) REFERENCES customer(customer_ID) ON DELETE CASCADE
);

-- 6. Accounts Table
CREATE TABLE accounts (
    customer_ID VARCHAR(8) NOT NULL,
    acc_no INT NOT NULL PRIMARY KEY,
    acc_type VARCHAR(15) NOT NULL,
    open_date DATE NOT NULL,
    current_balance FLOAT NOT NULL,
    sort_code VARCHAR(8) NOT NULL,  -- Regular column, no FK due to non-unique values
    FOREIGN KEY (customer_ID) REFERENCES customer(customer_ID) ON DELETE CASCADE
);

-- 7. Employee Table
CREATE TABLE employee (
    employee_ID VARCHAR(6) NOT NULL PRIMARY KEY,
    sort_code VARCHAR(8) NOT NULL,  -- Regular column, no FK due to non-unique values
    dept_ID VARCHAR(20) NOT NULL,
    join_date DATE NOT NULL,
    employee_position VARCHAR(50) NOT NULL,
    FOREIGN KEY (dept_ID) REFERENCES departments(dept_id) ON DELETE CASCADE
);

-- 8. Card_Info Table
CREATE TABLE card_info (
    customer_ID VARCHAR(8) NOT NULL,
    card_number BIGINT NOT NULL PRIMARY KEY,
    card_type VARCHAR(20) NOT NULL,
    acc_no INT NOT NULL,
    sort_code VARCHAR(8) NOT NULL,  -- Regular column, no FK due to non-unique values
    issue_date DATE NOT NULL,
    FOREIGN KEY (customer_ID) REFERENCES customer(customer_ID) ON DELETE NO ACTION,
    FOREIGN KEY (acc_no) REFERENCES accounts(acc_no) ON DELETE NO ACTION
);

-- 9. Loan Table
CREATE TABLE loan (
    customer_ID VARCHAR(8) NOT NULL,
    loan_id VARCHAR(10) NOT NULL PRIMARY KEY,
    sort_code VARCHAR(8) NOT NULL,  -- Regular column, no FK due to non-unique values
    date_initiated DATE NOT NULL,
    loan_duration INT NOT NULL,
    interest FLOAT NOT NULL,
    acc_no INT NOT NULL,
    FOREIGN KEY (customer_ID) REFERENCES customer(customer_ID) ON DELETE NO ACTION,
    FOREIGN KEY (acc_no) REFERENCES accounts(acc_no) ON DELETE NO ACTION
);

-- 10. Transactions Table
CREATE TABLE transactions (
    customer_ID VARCHAR(8) NOT NULL,
    acc_no INT NOT NULL,
    transaction_ID VARCHAR(8) NOT NULL PRIMARY KEY,
    amount FLOAT NOT NULL,
    transaction_date DATE NOT NULL,
    transaction_type VARCHAR(15) NOT NULL,
    FOREIGN KEY (customer_ID) REFERENCES customer(customer_ID),
    FOREIGN KEY (acc_no) REFERENCES accounts(acc_no)
);

-- 11. Audit Table
CREATE TABLE Audit (
    Audit_ID INT IDENTITY(1,1) PRIMARY KEY,
    Entity_Type NVARCHAR(50),
    Entity_ID INT,
    Changed_By VARCHAR(6),
    Change_Date DATETIME DEFAULT GETDATE(),
    Change_Type NVARCHAR(50),
    Change_Details NVARCHAR(MAX),
    FOREIGN KEY (Changed_By) REFERENCES employee(employee_ID)
);

-- 12. Role Table
CREATE TABLE Role (
    Role_ID INT IDENTITY(1,1) PRIMARY KEY,
    Role_Name NVARCHAR(50) NOT NULL UNIQUE
);

-- 13. Permission Table
CREATE TABLE Permission (
    Permission_ID INT IDENTITY(1,1) PRIMARY KEY,
    Permission_Name NVARCHAR(50) NOT NULL UNIQUE
);

-- 14. Role_Permission Table
CREATE TABLE Role_Permission (
    Role_ID INT NOT NULL,
    Permission_ID INT NOT NULL,
    PRIMARY KEY (Role_ID, Permission_ID),
    FOREIGN KEY (Role_ID) REFERENCES Role(Role_ID),
    FOREIGN KEY (Permission_ID) REFERENCES Permission(Permission_ID)
);

-- 15. User Table
CREATE TABLE [User] (
    User_ID INT IDENTITY(1,1) PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL UNIQUE,
    Password_Hash NVARCHAR(255) NOT NULL,
    Employee_ID VARCHAR(6),
    Role_ID INT,
    FOREIGN KEY (Employee_ID) REFERENCES employee(employee_ID),
    FOREIGN KEY (Role_ID) REFERENCES Role(Role_ID)
);

-- 16. Service Table
CREATE TABLE Service (
    Service_ID INT IDENTITY(1,1) PRIMARY KEY,
    Service_Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    Fee_Amount DECIMAL(18, 2)
);

-- 17. Service_Transaction Table
CREATE TABLE Service_Transaction (
    Transaction_ID VARCHAR(8) NOT NULL,
    Service_ID INT NOT NULL,
    PRIMARY KEY (Transaction_ID, Service_ID),
    FOREIGN KEY (Transaction_ID) REFERENCES transactions(transaction_ID),
    FOREIGN KEY (Service_ID) REFERENCES Service(Service_ID)
);

-- 18. Offer Table
CREATE TABLE Offer (
    Offer_ID INT IDENTITY(1,1) PRIMARY KEY,
    Description NVARCHAR(MAX),
    Start_Date DATE,
    End_Date DATE,
    Eligible_Customers NVARCHAR(MAX)
);

-- 19. Customer_Offer Table
CREATE TABLE Customer_Offer (
    Customer_ID VARCHAR(8) NOT NULL,
    Offer_ID INT NOT NULL,
    Status NVARCHAR(50),
    PRIMARY KEY (Customer_ID, Offer_ID),
    FOREIGN KEY (Customer_ID) REFERENCES customer(Customer_ID),
    FOREIGN KEY (Offer_ID) REFERENCES Offer(Offer_ID)
);
