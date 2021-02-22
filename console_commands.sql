insert into balances (customer_id, usd_bal, eur_bal, aed_bal) values (1, -4, 120, 0)
select * from balances;


ALTER TABLE balances ADD CONSTRAINT fk_balances FOREIGN KEY (customer_id) REFERENCES customers (id);


insert into customers (first_name, second_name, nickname_telegram, join_date) VALUES ('Dmitry', 'Denisov', 'ssf', '2020-01-06')
insert into balances (customer_id, usd_bal, eur_bal, aed_bal) values (56, 0, 1030, 0);
insert into customers (first_name, second_name, nickname_telegram, join_date) VALUES ('Dache', 'Dacha', '@d', '2020-08-07')
insert into transactions (customer_id_from, customer_id_to, usd_amt, eur_amt, aed_amt) VALUES (10, 6, 0, 3, 0);
insert into transactions (customer_id_from, customer_id_to, usd_amt, eur_amt, aed_amt) VALUES (45, 33, 10, 0, 0);

delete from customers;
delete from balances;
delete from transactions;

delete from tokens where customer_id =47;
delete from balances where customer_id=28;
delete from customers where id=56;
delete from transactions where aed_amt=-1;

select * from transactions;

ALTER TABLE balances ADD CONSTRAINT fk_balances FOREIGN KEY (customer_id) REFERENCES customers (id) on delete cascade;
ALTER TABLE transactions ADD CONSTRAINT fk_transactions_to FOREIGN KEY (customer_id_to) REFERENCES customers (id) on delete set null ;
ALTER TABLE transactions ADD CONSTRAINT fk_transactions_from FOREIGN KEY (customer_id_from) REFERENCES customers (id) on delete set null ;


-- Create View for all constraints
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
-- See view of constraints
select * from foreign_keys_view;


SELECT * FROM foreign_keys_view;

INSERT into customers (first_name, second_name, nickname_telegram, join_date) VALUES ('Ilya', 'Tek', '@teck', '2020-01-01')

-- Get all indices
select *
from pg_indexes
where tablename not like 'pg%'
order by tablename;

INSERT INTO access_types (access_type_int, access_type_str) VALUES (0, 'user'), (1, 'admin')

update balances set eur_amt=100 where customer_id=33;

alter table transactions add constraint trans_aed_gt_0 check (aed_amt >= 0);
alter table transactions add constraint trans_usd_gt_0 check (usd_amt >= 0);
alter table transactions add constraint trans_eur_gt_0 check (eur_amt >= 0);

-- Get all constraints (such as some column is greater than 0 and so on)
SELECT con.*
       FROM pg_catalog.pg_constraint con
            INNER JOIN pg_catalog.pg_class rel
                       ON rel.oid = con.conrelid
            INNER JOIN pg_catalog.pg_namespace nsp
                       ON nsp.oid = connamespace
       WHERE nsp.nspname = 'public'
             AND rel.relname = 'transactions';