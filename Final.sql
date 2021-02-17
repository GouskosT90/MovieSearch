/* SQL for 2019's Programming Project 2 */
drop table Featured;
drop table Film;
drop table Nominees;

create table Nominees (
	year varchar(9) not null,
	award varchar(40) not null,
	winner boolean not null,
	name varchar(88) not null,
	primary key (year, award, name)
	) engine = innodb;

create table Film (
	year varchar(9) not null,
	fname varchar(115) not null,
	primary key (year, fname)
	) engine = innodb;

create table Featured (
	year varchar(9)not null,
	name varchar(88) not null,
	fname varchar(115) not null,
	primary key (year, name, fname),
	foreign key (year,fname)
		references Film(year,fname)
		on delete no action

	) engine = innodb;


/* list of Queries */
/* Ask for a Specific Actor/Actress
		- Need input from User, and the name from Nominee.
		- Will validate if input is blank or non-blank and if in Table.
   Ask for a Specific Movie Title
		- Need input from User, will need the fname from Film.
		- Will validate if input is blank or non-blank and if in Table.
   Ask for a winners/nominees in a range for the date
		- Will need a max and min from user, and the years from won/nominees
		- Will validate of Max is higher than min and if a Date.
   Ask for a specific category of Actors
	    - Need input from User, and the category from Nominees.
		- Will validate if input is a non-blank, and if in Table.
   Ask for a specific category from Film
		- Need input from User, and the faward from Film.
		- Will validate if input is non-blank and if in table.
