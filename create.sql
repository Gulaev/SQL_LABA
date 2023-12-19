CREATE TABLE lawyers_office (
    office_id INT PRIMARY KEY,
    street_address VARCHAR(255)
);

CREATE TABLE passports (
    passport_id INT PRIMARY KEY,
    TIN VARCHAR(255),
    date_of_issue DATE,
    issued_by VARCHAR(255)
);

CREATE TABLE lawyers (
    lawyer_id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    username VARCHAR(255),
    password VARCHAR(255),
    cabinet_number INT,
    passport_id INT,
    FOREIGN KEY (passport_id) REFERENCES passports(passport_id)
);

CREATE TABLE clients (
    client_id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    passport_id INT,
    password VARCHAR(255),
    FOREIGN KEY (passport_id) REFERENCES passports(passport_id)
);

CREATE TABLE bank_cards (
    bank_card_id INT PRIMARY KEY,
    card_number VARCHAR(255),
    date_end DATE,
    CVV INT,
    name_on_card VARCHAR(255),
    client_id INT,
    FOREIGN KEY (client_id) REFERENCES clients(client_id)
    ON DELETE CASCADE
);

CREATE TABLE case_types (
    case_type_id INT PRIMARY KEY,
    case_type_name VARCHAR(255),
    category VARCHAR(255),
    legal_requirements TEXT,
    fees_structure TEXT,
    average_case_cost INT
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    date_of_payment DATE,
    client_id INT,
    lawyers_id INT,
    lawyer_amount INT,
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (lawyers_id) REFERENCES lawyers(lawyer_id)
);

CREATE TABLE cabinet (
    cabinet_id INT PRIMARY KEY,
    cabinet_number INT,
    floor_number INT,
    office_id INT,
    FOREIGN KEY (office_id) REFERENCES lawyers_office(office_id)
);

CREATE TABLE meetings (
    meeting_id INT PRIMARY KEY,
    lawyers_id INT,
    client_id INT,
    cabinet_id INT,
    FOREIGN KEY (lawyers_id) REFERENCES lawyers(lawyer_id),
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (cabinet_id) REFERENCES cabinet(cabinet_id)
);


CREATE TABLE contract (
    contract_id INT PRIMARY KEY,
    start_date DATE,
    payments_id INT,
    case_type_id INT,
    client_id INT,
    passport_lawyers INT,
    lawyer_id INT,
    FOREIGN KEY (payments_id) REFERENCES payments(payment_id),
    FOREIGN KEY (case_type_id) REFERENCES case_types(case_type_id),
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (passport_lawyers) REFERENCES passports(passport_id),
    FOREIGN KEY (lawyer_id) REFERENCES lawyers(lawyer_id)
);


CREATE TABLE lawyer_client_contracts (
    client_id INT,
    lawyer_id INT,
    contract_id INT,
    PRIMARY KEY (client_id, lawyer_id, contract_id),
    FOREIGN KEY (client_id) REFERENCES clients(client_id),
    FOREIGN KEY (lawyer_id) REFERENCES lawyers(lawyer_id),
    FOREIGN KEY (contract_id) REFERENCES contract(contract_id)
);
