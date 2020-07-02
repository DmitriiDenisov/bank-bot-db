# bank-bot

1. Creating Database Postgres

```
# Install Postgres:
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo -i -u postgres
psql

# Create new user:
sudo -u postgres createuser --interactive
# (follow instructions)...
# Create new DB:
sudo -u postgres createdb New_Name

sudo -u dmitryhse psql

# 
CREATE TABLE table_name (
    column_name1 col_type (field_length) column_constraints,
    column_name2 col_type (field_length),
    column_name3 col_type (field_length)
);

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

2. Remote connection to Database



Source: 

[1] https://www.digitalocean.com/community/tutorials/how-to-install-and-use-postgresql-on-ubuntu-18-04-ru
