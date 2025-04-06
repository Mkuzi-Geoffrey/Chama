-- Members Table
CREATE TABLE members (
    member_id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_names VARCHAR(255) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL, -- Store hashed password
    is_cluster_member BOOLEAN NOT NULL DEFAULT 0,
    security_question1 VARCHAR(255) NOT NULL,
    security_answer1 VARCHAR(255) NOT NULL,
    security_question2 VARCHAR(255) NOT NULL,
    security_answer2 VARCHAR(255) NOT NULL,
    security_question3 VARCHAR(255) NOT NULL,
    security_answer3 VARCHAR(255) NOT NULL,
    account_locked BOOLEAN NOT NULL DEFAULT 0,
    login_attempts INTEGER NOT NULL DEFAULT 0
);

-- Clusters Table
CREATE TABLE clusters (
    cluster_id INTEGER PRIMARY KEY AUTOINCREMENT,
    cluster_name VARCHAR(100) UNIQUE NOT NULL,
    chairperson_id INTEGER,
    secretary_id INTEGER,
    contribution_amount DECIMAL(10, 2) NOT NULL,
    contribution_period VARCHAR(50) NOT NULL, -- e.g., "weekly", "monthly"
    FOREIGN KEY (chairperson_id) REFERENCES members(member_id),
    FOREIGN KEY (secretary_id) REFERENCES members(member_id)
);

-- Cluster Memberships Table (Many-to-Many relationship)
CREATE TABLE cluster_memberships (
    membership_id INTEGER PRIMARY KEY AUTOINCREMENT,
    cluster_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL,
    is_approved BOOLEAN NOT NULL DEFAULT 0, -- Chairperson approval
    is_receiving_round BOOLEAN NOT NULL DEFAULT 0, -- For marry-go-round tracking
    FOREIGN KEY (cluster_id) REFERENCES clusters(cluster_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    UNIQUE (cluster_id, member_id)
);

-- Savings Table
CREATE TABLE savings (
    saving_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- Emergency Funds Table
CREATE TABLE emergency_funds (
    emergency_fund_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- Investment Funds Table
CREATE TABLE investment_funds (
    investment_fund_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    investment_option VARCHAR(100), -- Optional: Track specific investments
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- Marry-Go-Round Funds Table
CREATE TABLE marry_go_round_funds (
    marry_go_round_fund_id INTEGER PRIMARY KEY AUTOINCREMENT,
    cluster_id INTEGER NOT NULL,
    member_id INTEGER NOT NULL, -- Member who contributed
    amount DECIMAL(10, 2) NOT NULL,
    collection_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cluster_id) REFERENCES clusters(cluster_id),
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);

-- Loans Table
CREATE TABLE loans (
    loan_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER NOT NULL,
    loan_amount DECIMAL(10, 2) NOT NULL,
    interest_rate DECIMAL(5, 2) NOT NULL,
    loan_term_months INTEGER NOT NULL,
    start_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    due_date DATETIME,
    amount_paid DECIMAL(10, 2) NOT NULL DEFAULT 0,
    is_approved BOOLEAN, -- For cluster loans
    approved_by_chairperson INTEGER,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (approved_by_chairperson) REFERENCES members(member_id)
);

-- Loan Repayments Table
CREATE TABLE loan_repayments (
    repayment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    loan_id INTEGER NOT NULL,
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    amount_paid DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
);

-- OTP Table
CREATE TABLE otp (
    otp_id INTEGER PRIMARY KEY AUTOINCREMENT,
    member_id INTEGER NOT NULL,
    otp_code VARCHAR(6) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES members(member_id)
);