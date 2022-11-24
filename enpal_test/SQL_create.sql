-- Script to create database and tables

-- CREATE DATABASE enpal_test;

use enpal_test;

CREATE TABLE bases (
    team_id int NOT NULL PRIMARY KEY,
    latitude decimal(18, 6),
    longitude decimal(18, 6)
);

CREATE TABLE teams (
    team_id int NOT NULL PRIMARY KEY,
    availability_from datetime,
    availability_till datetime,
	skill_level int
);

CREATE TABLE customers (
    customer_id int IDENTITY(1,1) PRIMARY KEY,
    latitude decimal(18, 6),
    longitude decimal(18, 6),
	panels_to_install int,
	installation_start_date datetime
);