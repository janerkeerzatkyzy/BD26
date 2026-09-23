--task1
CREATE DATABASE fitness_template (
      WITH
    TEMPLATE = "template0",
    CONNECTION = 5
);

CREATE DATABASE fitness_db (
    WITH
    TEMPLATE = fitness_template
);
--task2
CREATE TABLE members (
    member_id SERIAL PRIMARY KEY,
    full_name VARCHAR(80),
    card_number CHAR(12),
    birth_date DATE,
    weight_kg INT,
    membership_fee DECIMAL(7, 2),
    is_premium BOOLEAN,
    joined_at TIMESTAMP WITH TIMEZONE;
);
--task3
CREATE TABLE sessions (
    session_id SMALLINT, PRIMARY KEY,
    member_id INT,
    trainer_id SMALLINT,
    session_date DATE,
    start_time TIME WITHOUT TIMEZONE,
    duration INTERVAL,
    calories_burned
);
--task4
ALTER TABLE members ALTER COLUMN card_number TYPE VARCHAR(16);
ALTER TABLE members ADD COLUMN phone VARCHAR(20);
ALTER TABLE members ALTER COLUMN membership_fee SET DEFAULT 15000.00;
