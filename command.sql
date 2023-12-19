INSERT INTO lawyers_office (office_id, street_address) VALUES (1, 'Khrehatik street 1');

INSERT INTO passports (passport_id, TIN, date_of_issue, issued_by) VALUES
(1, '123456789', '2023-01-15', 'MDS'),
(2, '987654321', '2022-11-30', 'Passports table'),
(3, '111222333', '2023-03-05', 'Passports table');

INSERT INTO lawyers (lawyer_id, first_name, last_name, username, password, cabinet_number, passport_id) VALUES
(1, 'John', 'Doe', 'john_lawyer', 'qwerty123', 101, 1);

INSERT INTO clients (client_id, first_name, last_name, passport_id, password) VALUES
(1, 'Anna', 'Lanna', 2, 'anna_pass123');
INSERT INTO clients (client_id, first_name, last_name, passport_id, password) VALUES
(2, 'Jana', 'Vana', 3, 'janna_pass123');

INSERT INTO bank_cards (bank_card_id, card_number, date_end, CVV, name_on_card, client_id) VALUES
(1, '1234567890123456', '2024-12-31', 123, 'Anna Lanna', 1);
INSERT INTO bank_cards (bank_card_id, card_number, date_end, CVV, name_on_card, client_id) VALUES
(2, '12345678901234561231', '2024-12-30', 133, 'Anna Lanna', 1);

INSERT INTO case_types (case_type_id, case_type_name, category, legal_requirements, fees_structure, average_case_cost) VALUES
(1, 'Divorce', 'Family Law', 'Specific legal requirements for divorce cases.', 'Fee details for divorce cases.', 500),
(2, 'Corporate Litigation', 'Business Law', 'Legal requirements for corporate litigation.', 'Fees for corporate litigation cases.', 2000),
(3, 'Criminal Defense', 'Criminal Law', 'Legal requirements for criminal defense cases.', 'Fees for criminal defense cases.', 1000);

INSERT INTO payments (payment_id, date_of_payment, client_id, lawyers_id, lawyer_amount) VALUES
(1, '2023-12-15', 1, 1, 500),
(2, '2023-11-28', 1, 1, 750),
(3, '2023-12-05', 1, 1, 1000);

INSERT INTO cabinet (cabinet_id, cabinet_number, floor_number, office_id) VALUES
(1, 101, 1, 1);

INSERT INTO meetings (meeting_id, lawyers_id, client_id, cabinet_id) VALUES
(1, 1, 1, 1);

INSERT INTO contract (contract_id, start_date, payments_id, case_type_id, client_id, passport_lawyers, lawyer_id) VALUES
(1, '2023-10-01', 1, 1, 1, 1, 1);

INSERT INTO lawyer_client_contracts (client_id, lawyer_id, contract_id) VALUES
(1, 1, 1);

----------------------------------------------------------------------------------------------------------------------------------
-- Update

UPDATE lawyers_office SET street_address = 'New Street Address' WHERE office_id = 1;
UPDATE passports SET TIN = '9876543210' WHERE passport_id = 2;
UPDATE lawyers SET cabinet_number = 102 WHERE lawyer_id = 1;
UPDATE clients SET last_name = 'Smith' WHERE client_id = 1;
UPDATE bank_cards SET CVV = 456 WHERE bank_card_id = 1;
UPDATE case_types SET average_case_cost = 600 WHERE case_type_id = 1;
UPDATE payments SET lawyer_amount = 800 WHERE payment_id = 3;
UPDATE cabinet SET floor_number = 2 WHERE cabinet_id = 1;
UPDATE meetings SET client_id = 2 WHERE meeting_id = 1;
UPDATE contract SET start_date = '2023-11-01' WHERE contract_id = 1;
----------------------------------------------------------------------------------------------------------------------------------
--Delete

DELETE FROM lawyers_office WHERE office_id = 1;
DELETE FROM passports WHERE passport_id = 1;
DELETE FROM lawyers WHERE lawyer_id = 1;
DELETE FROM clients WHERE client_id = 1;
DELETE FROM bank_cards WHERE bank_card_id = 1;
DELETE FROM lawyer_client_contracts WHERE client_id = 1 AND lawyer_id = 1 AND contract_id = 1;
DELETE FROM case_types WHERE case_type_id = 1;
DELETE FROM case_types WHERE case_type_id = 2;
DELETE FROM case_types WHERE case_type_id = 3;
DELETE FROM passports WHERE passport_id = 2;
DELETE FROM passports WHERE passport_id = 3;
----------------------------------------------------------------------------------------------------------------------------------
--Alter Table 

ALTER TABLE lawyers ADD COLUMN test_column VARCHAR(50);
ALTER TABLE lawyers DROP COLUMN username;
ALTER TABLE passports CHANGE COLUMN TIN TTN VARCHAR(50);
ALTER TABLE bank_cards MODIFY COLUMN card_number VARCHAR(150);
ALTER TABLE meetings ADD CONSTRAINT fk_lawyers_id FOREIGN KEY (lawyers_id) REFERENCES lawyers(lawyer_id);
----------------------------------------------------------------------------------------------------------------------------------
--Big Join

SELECT * FROM lawyers_office AS lo 
JOIN cabinet AS c ON lo.office_id = c.office_id 
JOIN lawyers AS l ON c.cabinet_number = l.cabinet_number
JOIN passports AS p ON l.passport_id = p.passport_id
JOIN lawyer_client_contracts AS lcc ON l.lawyer_id = lcc.lawyer_id
JOIN clients AS cl ON cl.client_id = lcc.client_id AND lcc.lawyer_id = l.lawyer_id
JOIN bank_cards AS bc ON cl.client_id = bc.client_id
JOIN payments AS pm ON lcc.client_id = cl.client_id AND lcc.lawyer_id = l.lawyer_id
JOIN contract AS ct ON lcc.client_id = cl.client_id AND lcc.lawyer_id = l.lawyer_id AND ct.contract_id = lcc.contract_id
JOIN case_types AS cty ON ct.case_type_id = cty.case_type_id
JOIN meetings mt ON mt.lawyers_id = l.lawyer_id;
----------------------------------------------------------------------------------------------------------------------------------
--Join Statments 

SELECT *
FROM clients
INNER JOIN passports ON clients.passport_id = passports.passport_id;

SELECT *
FROM clients
LEFT JOIN bank_cards ON clients.client_id = bank_cards.client_id;

SELECT *
FROM bank_cards
RIGHT JOIN clients ON clients.client_id = bank_cards.client_id;

SELECT *
FROM clients
LEFT JOIN bank_cards ON clients.client_id = bank_cards.client_id
UNION
SELECT *
FROM clients
RIGHT JOIN bank_cards ON clients.client_id = bank_cards.client_id
WHERE clients.client_id IS NULL OR bank_cards.client_id IS NULL;

SELECT *
FROM clients
INNER JOIN lawyer_client_contracts ON clients.client_id = lawyer_client_contracts.client_id
INNER JOIN lawyers ON lawyer_client_contracts.lawyer_id = lawyers.lawyer_id;
----------------------------------------------------------------------------------------------------------------------------------
--Aggregate Function without having

SELECT client_id, COUNT(*) AS num_of_card
FROM bank_cards 
GROUP BY client_id;

SELECT client_id, COUNT(*) AS num_contracts
FROM lawyer_client_contracts
GROUP BY client_id;

SELECT lawyer_id, SUM(lawyer_amount) AS total_payments
FROM payments
GROUP BY lawyer_id;

SELECT client_id, AVG(lawyer_amount) AS avg_payment
FROM payments
GROUP BY client_id;

SELECT case_type_id, MAX(average_case_cost) AS max_case_cost
FROM case_types
GROUP BY case_type_id;

SELECT office_id, MIN(cabinet_number) AS min_cabinet_number
FROM cabinet
GROUP BY office_id;

SELECT client_id, MAX(CVV) AS max_cvv
FROM bank_cards
GROUP BY client_id;
----------------------------------------------------------------------------------------------------------------------------------
--Aggregate Function with having

SELECT lawyer_id, COUNT(*) AS num_contracts 
FROM lawyer_client_contracts 
GROUP BY lawyer_id
HAVING COUNT(*) >= 2;

SELECT lawyers_id, SUM(lawyer_amount) AS total_payments
FROM payments
GROUP BY lawyers_id
HAVING SUM(lawyer_amount) > 100;

SELECT case_type_id, MAX(average_case_cost) AS max_case_cost
FROM case_types
GROUP BY case_type_id
HAVING MAX(average_case_cost) > 100;

SELECT lawyers_id, MIN(lawyer_amount) AS min_amount 
FROM payments 
GROUP BY lawyers_id
HAVING MIN(lawyer_amount) > 10;

SELECT office_id, SUM(cabinet_number) AS number_of_cabinets_in_office 
FROM cabinet
GROUP BY office_id
HAVING SUM(cabinet_number) >= 1;

SELECT c.office_id, COUNT(*) AS num_lawyers
FROM lawyers l
JOIN cabinet c ON l.cabinet_number = c.cabinet_number
GROUP BY c.office_id
HAVING COUNT(*) >= 1;

SELECT cabinet_id, COUNT(*) AS num_meetings
FROM meetings
GROUP BY cabinet_id
HAVING COUNT(*) > 1;



