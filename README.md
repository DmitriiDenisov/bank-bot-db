# bank-bot

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

General pattern for creating Tables: 
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

# For info:
\d
# For info (without sequence):
\dt
```

## 2. Remote connection to Database

1. Check that your machine is available by `ping -a ip_adreees`, for exmple `ping -a 34.72.212.249`

2. Check that port is open with `telnet 34.72.212.249 5432`

3. `cd /etc/postgresql/9.5/main`. **Change here 9.5 to your version of postgresql!**

4. `sudo vim postgresql.conf`, uncomment + change `listen_addresses='localhost'` to `listen_addresses = '0.0.0.0'`

5. `sudo vim pg_hba.conf`, add following: 
host    all             all              0.0.0.0/0                       md5
host    all             all              ::/0                            md5

6. `sudo service postgresql restart`

7. In order to connect:

<p align="center">
  <img src="https://i.ibb.co/Ph7vCsJ/Screen-Shot-2020-07-03-at-12-48-07-PM.png" width="500" alt="accessibility text">
</p>


Source: 

[1] https://eax.me/postgresql-install/

[2] https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-18-04-ru
