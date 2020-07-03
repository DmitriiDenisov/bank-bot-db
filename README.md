# bank-bot-db

## 1. Creating Database Postgres

```
# Install Postgres:
sudo apt update
sudo apt install postgresql postgresql-contrib

# Turn on interactive mode:
sudo -u postgres psql

# Create DB:
CREATE DATABASE test_database;

# Create User:
CREATE USER test_user WITH password 'qwerty';
GRANT ALL ON DATABASE test_database TO test_user;

# (optional) Additional rights to user:
ALTER ROLE test_user CREATEDB;
# Or even
ALTER ROLE test_user WITH SUPERUSER

# Try to work with DB:
psql -h localhost test_database test_user

# Create new Table:
CREATE SEQUENCE user_ids;
CREATE TABLE users (
  id INTEGER PRIMARY KEY DEFAULT NEXTVAL('user_ids'),
  login CHAR(64),
  password CHAR(64));
SELECT NEXTVAL('user_ids');

# The above is equal to:
CREATE TABLE users2 (
  id SERIAL PRIMARY KEY,
  login CHAR(64),
  password CHAR(64));
   
# Create one more table: 
CREATE TABLE "anotherTable" ("someValue" VARCHAR(64));

# Insert values to table: 
INSERT INTO users (login, password)
  VALUES ('afiskon', '123456');
  
# Try Select:
SELECT * FROM users;
```

**General pattern for creating Tables:**
```
# Pattern
CREATE TABLE table_name (
    column_name1 col_type (field_length) column_constraints,
    column_name2 col_type (field_length),
    column_name3 col_type (field_length)
);

# Example:
CREATE TABLE playground (
    equip_id serial PRIMARY KEY,
    type varchar (50) NOT NULL,
    color varchar (25) NOT NULL,
    location varchar(25) check (location in ('north', 'south', 'west', 'east', 'northeast', 'southeast', 'southwest', 'northwest')),
    install_date date
);
```

**Useful tips**:
```
# All databases
\l

# All tables in database:
\dt

# Connection ifo (DB and USer name):
\conninfo

# To connect to Database fith username:
psql DBNAME USERNAME

# For info:
\d

# For info (without sequence):
\dt

# Add constraint to existing column not null: 
alter table customers alter column nickname_telegram set not NULL

# Add constraint to existing column unique values
alter table balances add constraint unique_cust_id UNIQUE (customer_id);

# Get existing constraints and Foreign Keys: 
\d+ table_name

# Add foreign Key (once you try to delete from main table you will observe error like ERROR:  update or delete on table "customers" violates foreign key constraint "fk_balances" on table "balances"
DETAIL:  Key (id)=(1) is still referenced from table "balances".):
ALTER TABLE orders ADD CONSTRAINT name_of_rule FOREIGN KEY (customer_id) REFERENCES customers (id);

# if you want to enable on delete cascade:
ALTER TABLE orders ADD CONSTRAINT name_of_rule FOREIGN KEY (customer_id) REFERENCES customers (id) on delete cascade;

# Remove Foreign key:
alter table table_name drop constraint name_of_foreign_key

# Get all Foreign keys for a given table:
# 1. Create view:

CREATE VIEW foreign_keys_view AS
SELECT
    tc.table_name, kcu.column_name,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name,
    tc.constraint_name
FROM
    information_schema.table_constraints AS tc
    JOIN information_schema.key_column_usage
        AS kcu ON tc.constraint_name = kcu.constraint_name
    JOIN information_schema.constraint_column_usage
        AS ccu ON ccu.constraint_name = tc.constraint_name
WHERE constraint_type = 'FOREIGN KEY';

# 2. Select from it:
SELECT * FROM foreign_keys_view;

# 3. Soruce:
# Source: https://stackoverflow.com/questions/1152260/postgres-sql-to-list-table-foreign-keys

```



## 2. Remote connection to Database

1. Check that your machine is available by `ping -a ip_adreees`, for exmple `ping -a 34.72.212.249`

2. Check that port is open with `telnet 34.72.212.249 5432`

3. `cd /etc/postgresql/9.5/main`. **Change here 9.5 to your version of postgresql!**

4. `sudo vim postgresql.conf`, uncomment + change `listen_addresses='localhost'` to `listen_addresses = '0.0.0.0'`

5. `sudo vim pg_hba.conf`, add following: 
```
host    all             all              0.0.0.0/0                       md5
host    all             all              ::/0                            md5
```

6. `sudo service postgresql restart`

7. In order to connect:

<p align="center">
  <img src="https://i.ibb.co/Ph7vCsJ/Screen-Shot-2020-07-03-at-12-48-07-PM.png" width="350" alt="accessibility text">
</p>

## 3. Connect from Python (in assumption that system is MacOs)

1. `brew install postgresql`

2. `pip install psycopg2`

3. In case of error `gcc failed with exit mac` then `sudo installer -pkg /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg -target /`

4. In case of warining `UserWarning: The psycopg2 wheel package will be renamed from release 2.8; in` => ` pip install psycopg2-binary `

5. Check with psycopg2 that you have access to DB: 

```
import psycopg2


conn = psycopg2.connect(host="34.72.212.249", database="test_db", user="user_name", password="pass")
cur = conn.cursor()
print('PostgreSQL database version:')
cur.execute('SELECT version()')

db_version = cur.fetchone()
print(db_version)
a = cur.execute("SELECT * FROM customers;")
print(cur.fetchone())
```

Source: 

[1] Create DB: https://eax.me/postgresql-install/

[2] Useful commands: https://metanit.com/sql/postgresql/2.6.php
