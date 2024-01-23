create table book(
	id integer primary key,
	author_id integer,
	constraint fk_book_author_id foreign key (author_id) references author(id)
);
ALTER TABLE book ADD COLUMN book_name VARCHAR(30);
select * from book;

insert into book (id,author_id,book_name) values ('1', '1', 'ABC BOOK');
insert into book (id,author_id,book_name) values ('2', '2', 'DEF BOOK');
insert into book (id,author_id,book_name) values ('3', '3', 'IJK BOOK');


create table author(
	id serial primary key, -- auto-incrementing integer
	author_name VARCHAR(50) not null,
	nat_code VARCHAR(2), -- nationality,
	constraint fk_author_contact foreign key(nat_code) references nationality(nat_code)
);

insert into author (author_name, nat_code) values ('JOHN LAM', 'HK');
insert into author (author_name, nat_code) values ('APPLE TSE', 'SG');
insert into author (author_name, nat_code) values ('ILSA LAM', 'HK');
select * from author;


create table nationality(
	id serial primary key, -- auto-incrementing integer
	nat_code VARCHAR(2) unique not null,
	nat_desc VARCHAR(50) not null
);
insert into nationality (nat_code, nat_desc) values('HK', 'HONGKONG');
insert into nationality (nat_code, nat_desc) values('SG', 'SINGAPORE');
select * from nationality;


create table users(
	id serial primary key, -- auto-incrementing integer
	user_name VARCHAR(50) not null
);

insert into users(user_name) values ('Jason Yeung');
insert into users(user_name) values ('Katy Ho');
select * from users;


create table user_contact(
	id serial primary key, -- auto-incrementing integer
	user_id integer unique, -- unique + FK -> one to one
	user_phone varchar(100) not null,
	user_email varchar(100),
	constraint fk_user_contact foreign key (user_id) references users(id)
);

insert into user_contact (user_id, user_phone, user_email) values ('1', '98765439', 'jasonyeung@gmail.com');
insert into user_contact (user_id, user_phone, user_email) values ('2', '98765438', 'katyho@gmail.com');
select * from user_contact;



--Many to Many
create table borrow_history(
	id serial primary key, -- auto-increamenting integer
	user_id integer not null,
	book_id integer not null,
	borrow_date timestamp not null,
	constraint fk_history_user_id foreign key (user_id) references users(id),
	constraint fk_history_book_id foreign key (book_id) references book(id)
);

insert into borrow_history(user_id, book_id, borrow_date) values('1','1', '2024-01-01 12:55:01');
insert into borrow_history(user_id, book_id, borrow_date) values('2','2', '2024-01-01 12:55:02');
insert into borrow_history(user_id, book_id, borrow_date) values('1','3', '2024-01-01 12:55:03');
select * from borrow_history;



-- show choosen column
select bh.borrow_date
, u.user_name
, b.book_name
, a.author_name
, n.nat_code as author_nat_code
, n.nat_desc as author_nat_desc
, rh.return_date
from borrow_history bh, book b, users u, author a, nationality n, return_history rh
where bh.book_id = b.id
and bh.user_id = u.id
and b.author_id = a.id
and a.nat_code = n.nat_code
and bh.id = rh.borrow_id
order by bh.borrow_date desc
;



-- one to one
create table return_history(
	id serial primary key,
	borrow_id integer unique not null,
	return_date timestamp not null,
	CONSTRAINT fk_return_book_id FOREIGN KEY (borrow_id) REFERENCES borrow_history(id)
);

insert into return_history (borrow_id, return_date) values ('5','2024-01-14 13:55:01');
insert into return_history (borrow_id, return_date) values ('6','2024-01-15 13:55:02');
insert into return_history (borrow_id, return_date) values ('7','2024-01-16 13:55:03');
select * from return_history;



-- Find the user (user_name), who has the longest total book borrowing time. (no of days, ignore timestamp)
with borrow_days_per_user as (
	select bh.user_id, sum(EXTRACT(DAY FROM (rh.return_date - bh.borrow_date))) as borrow_days
	from borrow_history bh, return_history rh, users u
	where bh.id = rh.borrow_id
	and u.id = bh.user_id
	group by bh.user_id
)
select bd.user_id, u.user_name, bd.borrow_days
from borrow_days_per_user bd, users u
where borrow_days in (select max(borrow_days) from borrow_days_per_user)
and bd.user_id = u.id
;



-- Find the user(s) who has not ever borrow a book
insert into users(user_name) values('Peter Chan');

select user_name, id
from users
where not exists (select user_id from borrow_history where borrow_history.user_id = users.id); -- use NOT EXISTS METHOD



-- Find the book(s), which has no borrow history
insert into book (id, author_id, book_name) values ('4', '3', 'XYZ BOOK');

-- Approach 1: not exists
select *
from book b
where not exists (select 1 from borrow_history bh where bh.book_id = b.id);

-- Approach 2: left join
select *create table book(
	id integer primary key,
	author_id integer,
	constraint fk_book_author_id foreign key (author_id) references author(id)
);
ALTER TABLE book ADD COLUMN book_name VARCHAR(30);
select * from book;

insert into book (id,author_id,book_name) values ('1', '1', 'ABC BOOK');
insert into book (id,author_id,book_name) values ('2', '2', 'DEF BOOK');
insert into book (id,author_id,book_name) values ('3', '3', 'IJK BOOK');


create table author(
	id serial primary key, -- auto-incrementing integer
	author_name VARCHAR(50) not null,
	nat_code VARCHAR(2), -- nationality,
	constraint fk_author_contact foreign key(nat_code) references nationality(nat_code)
);

insert into author (author_name, nat_code) values ('JOHN LAM', 'HK');
insert into author (author_name, nat_code) values ('APPLE TSE', 'SG');
insert into author (author_name, nat_code) values ('ILSA LAM', 'HK');
select * from author;


create table nationality(
	id serial primary key, -- auto-incrementing integer
	nat_code VARCHAR(2) unique not null,
	nat_desc VARCHAR(50) not null
);
insert into nationality (nat_code, nat_desc) values('HK', 'HONGKONG');
insert into nationality (nat_code, nat_desc) values('SG', 'SINGAPORE');
select * from nationality;


create table users(
	id serial primary key, -- auto-incrementing integer
	user_name VARCHAR(50) not null
);

insert into users(user_name) values ('Jason Yeung');
insert into users(user_name) values ('Katy Ho');
select * from users;


create table user_contact(
	id serial primary key, -- auto-incrementing integer
	user_id integer unique, -- unique + FK -> one to one
	user_phone varchar(100) not null,
	user_email varchar(100),
	constraint fk_user_contact foreign key (user_id) references users(id)
);

insert into user_contact (user_id, user_phone, user_email) values ('1', '98765439', 'jasonyeung@gmail.com');
insert into user_contact (user_id, user_phone, user_email) values ('2', '98765438', 'katyho@gmail.com');
select * from user_contact;



--Many to Many
create table borrow_history(
	id serial primary key, -- auto-increamenting integer
	user_id integer not null,
	book_id integer not null,
	borrow_date timestamp not null,
	constraint fk_history_user_id foreign key (user_id) references users(id),
	constraint fk_history_book_id foreign key (book_id) references book(id)
);

insert into borrow_history(user_id, book_id, borrow_date) values('1','1', '2024-01-01 12:55:01');
insert into borrow_history(user_id, book_id, borrow_date) values('2','2', '2024-01-01 12:55:02');
insert into borrow_history(user_id, book_id, borrow_date) values('1','3', '2024-01-01 12:55:03');
select * from borrow_history;



-- show choosen column
select bh.borrow_date
, u.user_name
, b.book_name
, a.author_name
, n.nat_code as author_nat_code
, n.nat_desc as author_nat_desc
, rh.return_date
from borrow_history bh, book b, users u, author a, nationality n, return_history rh
where bh.book_id = b.id
and bh.user_id = u.id
and b.author_id = a.id
and a.nat_code = n.nat_code
and bh.id = rh.borrow_id
order by bh.borrow_date desc
;



-- one to one
create table return_history(
	id serial primary key,
	borrow_id integer unique not null,
	return_date timestamp not null,
	CONSTRAINT fk_return_book_id FOREIGN KEY (borrow_id) REFERENCES borrow_history(id)
);

insert into return_history (borrow_id, return_date) values ('5','2024-01-14 13:55:01');
insert into return_history (borrow_id, return_date) values ('6','2024-01-15 13:55:02');
insert into return_history (borrow_id, return_date) values ('7','2024-01-16 13:55:03');
select * from return_history;



-- Find the user (user_name), who has the longest total book borrowing time. (no of days, ignore timestamp)
with borrow_days_per_user as (
	select bh.user_id, sum(EXTRACT(DAY FROM (rh.return_date - bh.borrow_date))) as borrow_days
	from borrow_history bh, return_history rh, users u
	where bh.id = rh.borrow_id
	and u.id = bh.user_id
	group by bh.user_id
)
select bd.user_id, u.user_name, bd.borrow_days
from borrow_days_per_user bd, users u
where borrow_days in (select max(borrow_days) from borrow_days_per_user)
and bd.user_id = u.id
;



-- Find the user(s) who has not ever borrow a book
insert into users(user_name) values('Peter Chan');

select user_name, id
from users
where not exists (select user_id from borrow_history where borrow_history.user_id = users.id); -- use NOT EXISTS METHOD



-- Find the book(s), which has no borrow history
insert into book (id, author_id, book_name) values ('4', '3', 'XYZ BOOK');

-- Approach 1: not exists
select *
from book b
where not exists (select 1 from borrow_history bh where bh.book_id = b.id);

-- Approach 2: left join
select *
from book b left join borrow_history bh on bh.book_id = b.id
where bh.book_id is null;



-- Find all users and books, no matter the user or book has borrow history
select *
from borrow_history bh
	full outer join users u on u.id = bh.user_id
	full outer join book b on b.id = bh.book_id
	
-- where u.id is null or b.id is null;
-- Result Set:
-- 'John' 'ABC Book'
-- 'Mary' 'IJK Book'
-- 'Mary' null
-- null 'XYZ Book'





from book b left join borrow_history bh on bh.book_id = b.id
where bh.book_id is null;



-- Find all users and books, no matter the user or book has borrow history
select *
from borrow_history bh
	full outer join users u on u.id = bh.user_id
	full outer join book b on b.id = bh.book_id
	
-- where u.id is null or b.id is null;
-- Result Set:
-- 'John' 'ABC Book'
-- 'Mary' 'IJK Book'
-- 'Mary' null
-- null 'XYZ Book'

DROP VIEW VUSERS_BORROW_HISTORY;

CREATE VIEW VUSERS_BORROW_HISTORY 
AS 
SELECT U.USER_NAME, BH.BOOK_ID, BH.USER_ID, BH.BORROW_DATE
FROM USERS U LEFT JOIN BORROW_HISTORY BH ON U.ID = BH.USER_ID;

-- VIEW
-- 1. You cannot insert/update/delete in a view, because view access the physical table at real time.
-- 2. Hide unrelated data to the view user.
SELECT * 
FROM VUSERS_BORROW_HISTORY
WHERE USER_NAME LIKE 'JOE%';


CREATE MATERIALIZED VIEW MV_USERS_BORROW_HISTORY
AS
SELECT U.USER_NAME, BH.BOOK_ID, BH.USER_ID, BH.BORROW_DATE
FROM USERS U LEFT JOIN BORROW_HISTORY BH ON U.ID = BH.USER_ID;

-- 6 records returned.
select * from MV_USERS_BORROW_HISTORY;

insert into users (user_name) values ('Steven Chan');

-- 6 records returned.
select * from MV_USERS_BORROW_HISTORY;
-- 7 records returned.
select * from VUSERS_BORROW_HISTORY;

REFRESH MATERIALIZED VIEW MV_USERS_BORROW_HISTORY;
-- 7 records returned.
select * from MV_USERS_BORROW_HISTORY;




-- Procedures

-- Sample 
CREATE OR REPLACE FUNCTION CREATE_USER (IN USER_NAME VARCHAR) RETURNS VOID AS $$
BEGIN
	INSERT INTO USERS VALUES (USER_NAME);
	-- YOU CAN DO HUNDREDS OF CODE HERE ....
END;
$$ LANGUAGE plpgsql;

-- Task: Create a procedure/ function to automate management report data extraction
DROP TABLE report_management_id_1;

create table report_management_id_1 (
	report_id serial primary key,
	report_date varchar not null, -- same as character varying
	borrow_month VARCHAR not null, -- 202312
	user_id integer,
	num_of_book integer,
	CONSTRAINT fk_report_user_id FOREIGN KEY (user_id) REFERENCES users(id)
);

create or replace function insert_management_report(pi_borrow_month character varying) returns void as $$
declare
	rec record; -- record, means follow the returned field from the select statement.
begin
	for rec in
        select to_char(bh.borrow_date, 'YYYYMM') as borrow_month,
               bh.user_id as user_id,
               count(1) as num_of_book
        from borrow_history bh
        where to_char(bh.borrow_date, 'YYYY') = pi_borrow_month
		group by to_char(bh.borrow_date, 'YYYYMM'), bh.user_id
    loop
		if rec.num_of_book > 1 then
			insert into report_management_id_1 (report_date, borrow_month, user_id, num_of_book) 
			values (to_char(current_date, 'YYYYMM'), rec.borrow_month, rec.user_id, rec.num_of_book);
		end if;
	end loop;
end;
$$ language plpgsql;

-- Prepare extra raw data
insert into borrow_history (user_id, book_id, borrow_date)
values (2, 2, '2021-04-02 19:30:00');

-- Execute the function
SELECT public.insert_management_report('2021');

-- Check the result
select * from report_management_id_1;


-- Table Trigger
-- 
alter table users add borrow_times integer not null default 0;

-- When someone insert data into borrow_history, users.borrow_times + 1 (update)

CREATE OR REPLACE FUNCTION borrow_times_increment()
RETURNS TRIGGER AS $$
BEGIN
  update users set borrow_times = borrow_times + 1 where id = new.user_id;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER borrow_times_trigger
AFTER INSERT -- or BEFORE INSERT/ UPDATE/ DELETE or AFTER INSERT/ UPDATE/ DELETE
ON borrow_history
FOR EACH ROW -- must add for each row 
EXECUTE FUNCTION borrow_times_increment();

-- Trigger event (insert into borrow_history)
insert into borrow_history (user_id, book_id, borrow_date)
values (3, 1, '2023-01-15 12:30:00');

select * from borrow_history;

select * from users




