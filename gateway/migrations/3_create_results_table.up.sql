CREATE TABLE results (
game serial not null primary key,
user_id int,
user_name varchar(200),
score int,
date_added TIMESTAMP
)
