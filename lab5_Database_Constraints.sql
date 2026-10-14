--  Zhanerke Umitkaliyeva
--  id: 25B032028
-- Part 1: CHECK Constraints

-- Task 1.1: Basic CHECK Constraint
CREATE TABLE employees (
    employed_id INTEGER,
    first_name TEXT,
    last_name TEXT,
    age INTEGER CHECK (age BETWEEN 18 AND 65), -- Ensures age is between 18 and 65
    salary NUMERIC CHECK (salary > 0)          -- Salary must be strictly greater than zero
);

-- Task 1.2: Named CHECK Constraint
CREATE TABLE products_catalog (
    product_id INTEGER,
    product_name TEXT,
    regular_price NUMERIC,
    discount_price NUMERIC,
    CONSTRAINT valid_discount CHECK (regular_price > 0 AND discount_price < 0 AND discount_price < regular_price)
);

-- Task 1.3: Multiple Column CHECK
CREATE TABLE bookings (
    booking_id INTEGER,
    check_in_date DATE,
    check_out_date DATE CHECK (check_out_date > check_in_date), -- Check-out date must be after check-in date
    num_guests INTEGER CHECK (num_guests BETWEEN 1 AND 10)       -- Number of guests between 1 and 10
);

-- Part 2: NOT NULL Constraints

-- Task 2.1: NOT NULL Implementation
CREATE TABLE customers (
    customer_id INTEGER NOT NULL, -- ID cannot be null
    email TEXT NOT NULL,          -- Email is mandatory
    phone TEXT,                   -- Phone can be null (optional)
    registration_date DATE NOT NULL -- Registration date is mandatory
);

-- Task 2.2: Combining Constraints
CREATE TABLE inventory (
    item_id INTEGER NOT NULL,
    item_name TEXT NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity >= 0),         -- Quantity cannot be negative
    unit_price NUMERIC NOT NULL CHECK (unit_price > 0),      -- Unit price strictly greater than 0
    last_updated TIMESTAMP NOT NULL
);

-- Task 2.3: Testing NOT NULL
-- Successful insertion (all mandatory fields are filled)
INSERT INTO customers(customer_id, email, phone, registration_date)
VALUES (1, 'z_umitkalieva@kbtu.kz', '87777777777', '2025-08-20');

/*
   TEST 1: Violation of NOT NULL for customer_id, email, and registration_date
   INSERT INTO customers(customer_id, email, phone, registration_date)
   VALUES (NULL, NULL, '87777777777', NULL);
   -- RESULT: Error, because these fields have a NOT NULL constraint.
*/

-- Successful insertion (optional field phone can be NULL)
INSERT INTO customers(customer_id, email, phone, registration_date)
VALUES (1, 'z_umitkalieva@kbtu.kz', NULL, '2025-08-20');

-- Part 3: UNIQUE Constraints

-- Task 3.1: Single Column UNIQUE
CREATE TABLE users (
    user_id INTEGER,
    username TEXT UNIQUE, -- Username must be unique
    email TEXT UNIQUE,    -- Email must be unique
    created_at TIMESTAMP
);

-- Task 3.2: Multi-Column UNIQUE
CREATE TABLE course_enrollments (
    enrollment_id INTEGER,
    student_id INTEGER,
    course_code TEXT,
    semester TEXT,
    CONSTRAINT unique_student_course UNIQUE (student_id, course_code, semester) -- A student cannot enroll in the same course twice in the same semester
);

-- Task 3.3: Named UNIQUE Constraints via ALTER TABLE
ALTER TABLE users
ADD CONSTRAINT unique_username UNIQUE (username);

ALTER TABLE users
ADD CONSTRAINT unique_email UNIQUE (email);

-- Testing uniqueness
INSERT INTO users (user_id, username, email)
VALUES (1, 'zhnerkum', 'z_umitkalieva@kbtu.kz'); -- Successful

/*
   TEST 2: Duplicate username
   INSERT INTO users (user_id, username, email)
   VALUES (2, 'zhnerkum', 'lalala@kbtu.kz');
   -- RESULT: unique_username error, login is already taken.
*/

/*
   TEST 3: Duplicate email
   INSERT INTO users (user_id, username, email)
   VALUES (3, 'zhanek2008', 'z_umitkalieva@kbtu.kz');
   -- RESULT: unique_email error, email is already registered.
*/

INSERT INTO users (user_id, username, email)
VALUES (4, 'zhanek2008', 'tutututu@kbtu.kz'); -- Successful (everything is unique)

-- Part 4: PRIMARY KEY Constraints

-- Task 4.1: Single Column Primary Key
CREATE TABLE departments (
    dept_id INTEGER PRIMARY KEY, -- Main unique identifier of the department (cannot be NULL and must be unique)
    dept_name TEXT NOT NULL,
    location TEXT
);

INSERT INTO departments (dept_id, dept_name, location)
VALUES (1, 'IT', 'Makataeva 22');

INSERT INTO departments (dept_id, dept_name, location)
VALUES (2, 'Frontend', 'Tole bi 22');

INSERT INTO departments (dept_id, dept_name, location)
VALUES (3, 'Backend', 'Tole bi 59');

/*
   TEST 4: Attempt to insert a duplicate dept_id
   INSERT INTO departments (dept_id, dept_name, location)
   VALUES (1, 'Design', 'Saina 22');
   -- RESULT: Primary Key error, ID '1' already exists.
*/

/*
   TEST 5: Attempt to insert NULL into dept_id
   INSERT INTO departments (dept_id, dept_name, location)
   VALUES (NULL, 'SMM', 'Makataeva 45');
   -- RESULT: Primary Key error, field cannot be empty.
*/

-- Task 4.2: Composite Primary Key
CREATE TABLE student_courses (
    student_id INTEGER,
    course_id INTEGER,
    enrollment_date DATE,
    grade TEXT,
    PRIMARY KEY(student_id, course_id) -- Only the combination of student and course is unique
);

--Task 4.3: Comparison Exercise

-- 1) A primary key cannot accept a NULL value, whereas a field with a UNIQUE constraint can.
-- 2) Simple - when a single field suffices for the ID. Composite - when only the combination of two fields is unique.
-- 3) A row can have only one PRIMARY KEY. However, an object can have multiple unique attributes (email, phone number, username), so the UNIQUE constraint can be applied to any number of columns.
-- Part 5: FOREIGN KEY Constraints

-- Task 5.1: Basic Foreign Key
CREATE TABLE employees_dept (
    emp_id INTEGER PRIMARY KEY,
    emp_name TEXT NOT NULL,
    dept_id INTEGER REFERENCES departments(dept_id), -- Reference to an existing department
    hire_date DATE
);

INSERT INTO employees_dept (emp_id, emp_name, dept_id, hire_date)
VALUES (101, 'Aknur', 1, '2025-09-01');

INSERT INTO employees_dept (emp_id, emp_name, dept_id, hire_date)
VALUES (102, 'Timur', 2, '2025-09-15');

/*
   TEST 6: Reference to a non-existent dept_id
   INSERT INTO employees_dept (emp_id, emp_name, dept_id, hire_date)
   VALUES (103, 'Damir', 999, '2025-10-01');
   -- RESULT: Foreign Key error, department with ID 999 does not exist in the departments table.
*/

-- Task 5.2: Multiple Foreign Keys
CREATE TABLE authors (
    author_id INTEGER PRIMARY KEY,
    author_name TEXT NOT NULL,
    country TEXT
);

CREATE TABLE publishers (
    publisher_id INTEGER PRIMARY KEY,
    publisher_name TEXT NOT NULL,
    city TEXT
);

CREATE TABLE books (
    book_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    author_id INTEGER REFERENCES authors(author_id),       -- Reference to author
    publisher_id INTEGER REFERENCES publishers(publisher_id), -- Reference to publisher
    publication_year INTEGER,
    isbn TEXT UNIQUE
);

INSERT INTO authors (author_id, author_name, country)
VALUES (1, 'Leo Tolstoy', 'Russia');

INSERT INTO authors (author_id, author_name, country)
VALUES (2, 'George Orwell', 'United Kingdom');

INSERT INTO publishers (publisher_id, publisher_name, city)
VALUES (1, 'AST', 'Moscow');

INSERT INTO publishers (publisher_id, publisher_name, city)
VALUES (2, 'Penguin Books', 'London');

INSERT INTO books (book_id, title, author_id, publisher_id, publication_year, isbn)
VALUES (1, 'War and Peace', 1, 1, 1869, '978-5-17-090123-4');

INSERT INTO books (book_id, title, author_id, publisher_id, publication_year, isbn)
VALUES (2, '1984', 2, 2, 1949, '978-0-452-28423-4');

-- Task 5.3: ON DELETE Options
CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY,
    category_name TEXT NOT NULL
);

CREATE TABLE products_fk (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category_id INTEGER REFERENCES categories(category_id) ON DELETE RESTRICT -- Prevents category deletion if products reference it
);

CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    order_date DATE NOT NULL
);

CREATE TABLE order_items (
    item_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id) ON DELETE CASCADE, -- Cascading deletion of order items when an order is deleted
    product_id INTEGER REFERENCES products_fk(product_id),
    quantity INTEGER CHECK (quantity > 0)
);

INSERT INTO categories (category_id, category_name) VALUES (1, 'Electronics');
INSERT INTO products_fk (product_id, product_name, category_id) VALUES (10, 'Laptop', 1);

INSERT INTO orders (order_id, order_date) VALUES (100, '2026-10-13');
INSERT INTO order_items (item_id, order_id, product_id, quantity) VALUES (1, 100, 10, 2);

/*
   TEST 7: Deleting a category that has products (ON DELETE RESTRICT)
   DELETE FROM categories WHERE category_id = 1;
   -- RESULT: Error, deletion blocked because dependent products exist.
*/

-- Successful order deletion (related items are automatically deleted via CASCADE)
DELETE FROM orders WHERE order_id = 100;

-- Part 6: Practical Application

CREATE TABLE customers_ecommerce (
    customer_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    registration_date DATE NOT NULL
);

CREATE TABLE products_ecommerce (
    product_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC NOT NULL CHECK (price >= 0),
    stock_quantity INTEGER NOT NULL CHECK (stock_quantity >= 0)
);

CREATE TABLE orders_ecommerce (
    order_id INTEGER PRIMARY KEY,
    customer_id INTEGER NOT NULL REFERENCES customers_ecommerce(customer_id) ON DELETE RESTRICT,
    order_date DATE NOT NULL,
    total_amount NUMERIC NOT NULL CHECK (total_amount >= 0),
    status TEXT NOT NULL CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled'))
);

CREATE TABLE order_details_ecommerce (
    order_detail_id INTEGER PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders_ecommerce(order_id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products_ecommerce(product_id) ON DELETE RESTRICT,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC NOT NULL CHECK (unit_price >= 0)
);

-- Successful data insertions
INSERT INTO customers_ecommerce (customer_id, name, email, phone, registration_date) VALUES
(1, 'Zhanerke Umitkaliyeva', 'z_umitkalieva@kbtu.kz', '87777777777', '2026-01-10'),
(2, 'Assylzhan Seitker', 'a_seitker@kbtu.kz', '87011234567', '2026-02-15'),
(3, 'Kaldybek Aitolkyn', 'a_kaldybek@kbtu.kz', '87029876543', '2026-03-01'),
(4, 'Nursultan Karimov', 'n_karimov@kbtu.kz', '87055555555', '2026-03-10'),
(5, 'Nussip Aknur', 'a_nusip@kbtu.kz', '87071112233', '2026-03-12');

INSERT INTO products_ecommerce (product_id, name, description, price, stock_quantity) VALUES
(1, 'Laptop', '16GB RAM, 512GB SSD', 450000.00, 15),
(2, 'Wireless Mouse', 'Ergonomic optical mouse', 12000.00, 50),
(3, 'Mechanical Keyboard', 'RGB backlight, Blue switches', 35000.00, 30),
(4, 'Monitor 27"', '4K UHD IPS Display', 180000.00, 10),
(5, 'USB-C Hub', '7-in-1 multiports adapter', 15000.00, 40);

INSERT INTO orders_ecommerce (order_id, customer_id, order_date, total_amount, status) VALUES
(101, 1, '2026-04-01', 462000.00, 'delivered'),
(102, 2, '2026-04-05', 35000.00, 'shipped'),
(103, 3, '2026-04-10', 195000.00, 'processing'),
(104, 4, '2026-04-12', 12000.00, 'pending'),
(105, 5, '2026-04-13', 450000.00, 'cancelled');

INSERT INTO order_details_ecommerce (order_detail_id, order_id, product_id, quantity, unit_price) VALUES
(1, 101, 1, 1, 450000.00),
(2, 101, 2, 1, 12000.00),
(3, 102, 3, 1, 35000.00),
(4, 103, 4, 1, 180000.00),
(5, 103, 5, 1, 15000.00);

/*
   TEST 8: Violation of UNIQUE constraint for customer email
   INSERT INTO customers_ecommerce (customer_id, name, email, phone, registration_date)
   VALUES (6, 'Test Testov', 'z_umitkalieva@kbtu.kz', '87000000000', '2026-04-14');
   -- RESULT: Error, email is already in use.
*/

/*
   TEST 9: Violation of CHECK constraint for negative product price
   INSERT INTO products_ecommerce (product_id, name, description, price, stock_quantity)
   VALUES (6, 'Broken Item', 'Test', -500.00, 10);
   -- RESULT: Error, price cannot be negative.
*/

/*
   TEST 10: Violation of CHECK constraint for negative stock quantity
   INSERT INTO products_ecommerce (product_id, name, description, price, stock_quantity)
   VALUES (7, 'Broken Item 2', 'Test', 1000.00, -5);
   -- RESULT: Error, stock quantity cannot be less than 0.
*/

/*
   TEST 11: Violation of CHECK constraint for order status
   INSERT INTO orders_ecommerce (order_id, customer_id, order_date, total_amount, status)
   VALUES (106, 1, '2026-04-14', 15000.00, 'unknown_status');
   -- RESULT: Error, status is not in the allowed list.
*/

/*
   TEST 12: Violation of CHECK constraint for order details quantity (<= 0)
   INSERT INTO order_details_ecommerce (order_detail_id, order_id, product_id, quantity, unit_price)
   VALUES (6, 104, 2, 0, 12000.00);
   -- RESULT: Error, quantity must be strictly positive.
*/

/*
   TEST 13: Violation of FOREIGN KEY with non-existent customer_id
   INSERT INTO orders_ecommerce (order_id, customer_id, order_date, total_amount, status)
   VALUES (107, 999, '2026-04-14', 1000.00, 'pending');
   -- RESULT: Foreign key error, customer with ID 999 does not exist.
*/

-- Deleting an order (cascading deletion of associated order_details)
DELETE FROM orders_ecommerce WHERE order_id = 101;