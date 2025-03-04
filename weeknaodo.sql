create table billiard.education (educationid int primary key, name varchar(100))
select * from billiard.education

create table billiard.state (stateid int primary key)

create table billiard.doctor 
(doctorid int not null identity primary key, name varchar(100), 
stateid int not null foreign key 
references billiard.state(stateid))

create table billiard.doctoreducation
(doctorid int not null foreign key references billiard.doctor(doctorid),
educationid int not null foreign key references billiard.education(educationid),
constraint PK_doctoreducation primary key(doctorid, educationid))

select * from billiard.doctoreducation

insert billiard.state(statename)
select distinct statename from billiard.example1
