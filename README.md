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
  
# Insert multiple rows in one time:
INSERT INTO products (product_no, name, price) VALUES
    (1, 'Cheese', 9.99),
    (2, 'Bread', 1.99),
    (3, 'Milk', 2.99);
  
# Add column with default value
ALTER TABLE customers ADD COLUMN access_type int NOT NULL DEFAULT 0;
  
# Try Select:
SELECT * FROM users;
```

### 1.1 General pattern for creating Tables:
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

### 1.2 Foreign keys:

**Why do we need Foreign Key?**

When you use foreign keys you get: Data integrity and faster queries. Consider you remove a user, then you would end up with a lot of comments linked to an invalid user if you forget to remove the comments manually with a separate query. With foreign keys you could set it to remove all the comments automatically as you remove a user (or update changes, like if you would change the user id). 
Also you won't be able to add new row to Table if it does not have corresponding row in main table (for example, you won't be able to add new row to Balance while you don't have corresponding Customer)
Once you try to delete from main table you will observe error like ERROR:  
`update or delete on table "customers" violates foreign key constraint "fk_balances" on table "balances" DETAIL:  Key (id)=(1) is still referenced from table "balances".):`

**Get existing constraints and Foreign Keys**: 

`\d+ table_name`

**Add Foreign Key to existing Table:**

`ALTER TABLE orders ADD CONSTRAINT name_of_rule FOREIGN KEY (customer_id) REFERENCES customers (id);`

**if you want to enable on delete cascade:**

_Explanantion if you need cascade delete: [link](https://stackoverflow.com/questions/278392/should-i-use-the-cascade-delete-rule)_

`ALTER TABLE orders ADD CONSTRAINT name_of_rule FOREIGN KEY (customer_id) REFERENCES customers (id) on delete cascade;`

**In order to have foreign_key but in case we delete from main table then in dependent value will set to null:**

`ALTER TABLE transactions ADD CONSTRAINT fk_transactions_to FOREIGN KEY (customer_id_to) REFERENCES customers (id) on delete set null;`

_Source of all possible actions while delete [link](https://metanit.com/sql/mysql/2.5.php)_

**Remove Foreign key:**

`alter table table_name drop constraint name_of_foreign_key`

**Get all Foreign keys for a given table:**

1. Create view:

```
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
```

2. Select from it:

`SELECT * FROM foreign_keys_view;`

_Soruce: [link](https://stackoverflow.com/questions/1152260/postgres-sql-to-list-table-foreign-keys)_

### 1.3 Indexes 

```
# Create index:
CREATE INDEX idx_name ON customers (id);
# Remove index:
DROP INDEX idx_name;
```

Get all indexes:
```
select *
from pg_indexes
where tablename not like 'pg%'
order by tablename
```

Details: [link](https://postgrespro.com/docs/postgresql/9.6/sql-createindex)

### 1.4 Useful tips:
```
# To connect to Database fith username:
psql DBNAME USERNAME

# All databases
\l

# For info with sequences:
\d

# All tables in database (without sequence):
\dt

# Connection ifo (DB and USer name):
\conninfo

# Add constraint to existing column not null: 
alter table customers alter column nickname_telegram set not NULL

# Remove constraint:
alter table table_name alter column column_name drop not null;

# Add constraint to existing column unique values:
alter table balances add constraint unique_cust_id UNIQUE (customer_id);

# Change type of column:
ALTER TABLE a ALTER COLUMN t TYPE TIMESTAMP WITH TIME ZONE USING t AT TIME ZONE 'UTC'

# Drop column:
ALTER TABLE table_name DROP COLUMN column_name;

# Rename column:
ALTER TABLE table_name RENAME COLUMN column_name TO new_column_name;
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

5. Check with psycopg2 that you have access to DB: `connect_db_psycopg2.py`

## 4. Connect with SQLAlchemy in Python:

1. `pip install SQLAlchemy`

2. In folder `models` are descriptions of all Tables

3. To run: `sqlalchemy_examples/queries.py` for queries, `sqlalchemy_examples/inserts.py` for insert examples and so on

4. Majority of comments are in `queries.py` about Foreign Keys, relationships etc. Relationship means that python object will have separate field which is connected to value from another table. For example, object Customer will have separate field Balance which will be taken from Balance table, meanwhile it won't increase time consumption because it is lazy operation ([proof](https://stackoverflow.com/questions/53987267/sqlalchemy-disable-lazy-loading-and-load-object-only-on-join))

## 5. Save Dump DataBase:

Save dump: `pg_dump <parameters> <DB name> > <file where to store dump>`, example `pg_dump bank_bot_db > ~/bank_bot_db.dump`. You can find file `bank_bot_db.dump` in this repo. [Source](https://www.dmosk.ru/miniinstruktions.php?mini=postgresql-dump)

## 6. Restore DataBase from Dump:

1. `sudo -u postgres psql`

2. `CREATE DATABASE bank_bot_db_copy;`

3. `GRANT ALL ON DATABASE bank_bot_db_copy TO dmitryhse;` in order to give access to DB to your user

4. Exit from interactive psql mode (ctrl+D)

5. `psql <DB name> < <file with dump>`, example `psql bank_bot_db_copy < ~/bank_bot_db.dump`  

## 7. Sources: 

[1] Create DB: https://eax.me/postgresql-install/

[2] Useful commands: https://metanit.com/sql/postgresql/2.6.php

[3] SQLAlchemy: https://auth0.com/blog/sqlalchemy-orm-tutorial-for-python-developers/
