use [airport_task]

GO

INSERT INTO Model (Model_id, [Name], Capacity, Runway_min)
VALUES 
(1, 'Airbus A320', 160, 2100),
(2, 'Airbus A319', 100, 1800),
(3, 'Airbus A380', 283, 2400),
(4, 'Boeing 777', 240, 2250),
(5, 'Boeing 737', 150, 1900),
(6, 'Tu-154', 190, 2000);

INSERT INTO Airline (Airline_id, [Name], Baggage_limit, Code)
VALUES
(1, 'Aeroflot', 23, 'SU'),
(2, 'British Airways', 26, 'BA'),
(3, 'S7', 21, 'S7'),
(4, 'Air France', 24, 'AF')

INSERT INTO City (City_id, [Name])
VALUES
(1, 'Moscow'),
(2, 'Liverpool'),
(3, 'London'),
(4, 'Paris'),
(5, 'Marseille'),
(6, 'Barcelona'),
(7, 'Bristol'),
(8, 'Sochi'),
(9, 'Kazan'),
(10, 'Bordeaux'),
(11, 'Nice'),
(12, 'Vladivostok'),
(13, 'Manchester');

INSERT INTO Airport(Airport_id, [Name], City_id)
VALUES(1, 'Sheremetyevo', 1),
(2, 'John Lennon', 2),
(3, 'Heathrow', 3),
(4, 'Gatwick', 3),
(5, 'London-City', 3),
(6, 'Sharl de gol', 4),
(7, 'Napoleon', 4),
(8, 'Marseille-Provans', 5),
(9, 'Lionel Messi', 6),
(10, 'Bristol-City', 7),
(11, 'Sochi-City', 8),
(12, 'Useinov', 9),
(13, 'Fine-Wine',	10),
(14, 'Nice-fly', 11),
(15, 'Caviar,', 12),
(16, 'Rooney', 13),
(17, 'Alex Ferguson', 13);

GO
INSERT INTO [Path](Airport_id, [Type])
VALUES(2, 'A')
INSERT INTO [Path](Airport_id, [Type])
VALUES(3, 'A')
INSERT INTO [Path](Airport_id, [Type])
VALUES(4, 'A')
INSERT INTO [Path](Airport_id, [Type])
VALUES(5, 'A')
INSERT INTO [Path](Airport_id, [Type])
VALUES(6, 'A')
INSERT INTO [Path](Airport_id, [Type])
VALUES(7, 'A')
INSERT INTO [Path](Airport_id, [Type])
VALUES(8, 'A')
INSERT INTO [Path](Airport_id, [Type])
VALUES(9, 'A')
INSERT INTO [Path](Airport_id, [Type])
VALUES(10, 'A')
INSERT INTO [Path](Airport_id, [Type])
VALUES(11, 'A')
INSERT INTO [Path](Airport_id, [Type])
VALUES(12, 'A')
INSERT INTO [Path](Airport_id, [Type])
VALUES(13, 'A')
INSERT INTO [Path](Airport_id, [Type])
VALUES(14, 'A')
INSERT INTO [Path](Airport_id, [Type])
VALUES(15, 'A')
INSERT INTO [Path](Airport_id, [Type])
VALUES(16, 'A')
INSERT INTO [Path](Airport_id, [Type])
VALUES(17, 'A')
INSERT INTO [Path](Airport_id, [Type])
VALUES(1, 'D')
INSERT INTO [Path](Airport_id, [Type])
VALUES(2, 'D')
INSERT INTO [Path](Airport_id, [Type])
VALUES(3, 'D')
INSERT INTO [Path](Airport_id, [Type])
VALUES(4, 'D')
INSERT INTO [Path](Airport_id, [Type])
VALUES(5, 'D')
INSERT INTO [Path](Airport_id, [Type])
VALUES(6, 'D')
INSERT INTO [Path](Airport_id, [Type])
VALUES(7, 'D')
INSERT INTO [Path](Airport_id, [Type])
VALUES(8, 'D')
INSERT INTO [Path](Airport_id, [Type])
VALUES(9, 'D')
INSERT INTO [Path](Airport_id, [Type])
VALUES(10, 'D')
INSERT INTO [Path](Airport_id, [Type])
VALUES(11, 'D')
INSERT INTO [Path](Airport_id, [Type])
VALUES(12, 'D')
INSERT INTO [Path](Airport_id, [Type])
VALUES(13, 'D')
INSERT INTO [Path](Airport_id, [Type])
VALUES(14, 'D')
INSERT INTO [Path](Airport_id, [Type])
VALUES(15, 'D')
INSERT INTO [Path](Airport_id, [Type])
VALUES(16, 'D')
INSERT INTO [Path](Airport_id, [Type])
VALUES(17, 'D')

GO
INSERT INTO Aircraft(Aircraft_id, Production_date, Model_id, Airline_id)
VALUES
(1,	'12.04.2001',	5,	1),
(2,	'10.04.2010',	1,	1),
(3,	'11.04.2016',	3,	1),
(4,	'12.04.1996',	6,	1),
(5,	'12.04.1999',	4,	2),
(6,	'02.04.2002',	2,	2),
(7,	'01.04.1993',	1,	2),
(8,	'01.04.2000',	1,	2),
(9,	'04.04.1984',	6,	3),
(10, '02.11.2004',	4,	3),
(11, '02.01.2007',	5,	3),
(12, '01.05.2017',	3,	4),
(13, '02.10.1991',	2,	4),
(14, '01.03.2005',	1,	4),
(15, '03.02.1999',	4,	4);


GO
INSERT INTO Flight (Flight_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id, Path_id)
VALUES
(2,  '15.12.2018 07:10', '15.12.2018 11:15', 160, 2, (SELECT TOP 1 Path_id FROM [Path]
ORDER BY NEWID()))
INSERT INTO Flight (Flight_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id, Path_id)
VALUES(3,  '15.12.2018 9:11', '15.12.2018 13:15', 200, 3, (SELECT TOP 1 Path_id FROM [Path]
ORDER BY NEWID()))
INSERT INTO Flight (Flight_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id, Path_id)
VALUES(4, '15.12.2018 17:54', '15.12.2018 21:15', 178, 4, (SELECT TOP 1 Path_id FROM [Path]
ORDER BY NEWID()))
INSERT INTO Flight (Flight_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id, Path_id)
VALUES(5, '16.12.2018 12:18', '16.12.2018 19:15', 150, 1, (SELECT TOP 1 Path_id FROM [Path]
ORDER BY NEWID()))
INSERT INTO Flight (Flight_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id, Path_id)
VALUES(6,  '16.12.2018 7:00', '16.12.2018 11:15', 160, 2, (SELECT TOP 1 Path_id FROM [Path]
ORDER BY NEWID()))
INSERT INTO Flight (Flight_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id, Path_id)
VALUES(7,  '16.12.2018 03:10', '16.12.2018 7:35', 280, 2, (SELECT TOP 1 Path_id FROM [Path]
ORDER BY NEWID()))
INSERT INTO Flight (Flight_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id, Path_id)
VALUES(8,  '16.12.2018 02:10', '16.12.2018 11:15', 180, 2, (SELECT TOP 1 Path_id FROM [Path]
ORDER BY NEWID()))
INSERT INTO Flight (Flight_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id, Path_id)
VALUES(9,  '15.12.2018 14:12', '15.12.2018 19:15', 230, 5, (SELECT TOP 1 Path_id FROM [Path]
ORDER BY NEWID()))
INSERT INTO Flight (Flight_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id, Path_id)
VALUES(10, '15.12.2018 12:35', '15.12.2018 21:32', 80, 6, (SELECT TOP 1 Path_id FROM [Path]
ORDER BY NEWID()))
INSERT INTO Flight (Flight_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id, Path_id)
VALUES(11, '15.12.2018 13:23', '15.12.2018 15:52', 143, 7,(SELECT TOP 1 Path_id FROM [Path]
ORDER BY NEWID()))
INSERT INTO Flight (Flight_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id, Path_id)
VALUES(12, '15.12.2018 05:51', '15.12.2018 11:51', 160, 8,(SELECT TOP 1 Path_id FROM [Path]
ORDER BY NEWID()))
INSERT INTO Flight (Flight_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id, Path_id)
VALUES(13, '16.12.2018 05:44', '16.12.2018 11:14', 200, 5,(SELECT TOP 1 Path_id FROM [Path]
ORDER BY NEWID()))
INSERT INTO Flight (Flight_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id, Path_id)
VALUES(14, '16.12.2018 07:21', '16.12.2018 15:16', 89, 6, (SELECT TOP 1 Path_id FROM [Path]
ORDER BY NEWID()))
INSERT INTO Flight (Flight_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id, Path_id)
VALUES(15, '16.12.2018 03:53', '16.12.2018 09:42', 150, 7, (SELECT TOP 1 Path_id FROM [Path]
ORDER BY NEWID()))
INSERT INTO Flight (Flight_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id, Path_id)
VALUES(16, '16.12.2018 01:41', '16.12.2018 08:16', 160, 8, (SELECT TOP 1 Path_id FROM [Path]
ORDER BY NEWID()))
INSERT INTO Flight (Flight_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id, Path_id)
VALUES(17, '15.12.2018 03:51', '15.12.2018 15:24', 190, 9, (SELECT TOP 1 Path_id FROM [Path]
ORDER BY NEWID()))
INSERT INTO Flight (Flight_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id, Path_id)
VALUES(18, '15.12.2018 15:11', '15.12.2018 21:31', 230, 10, (SELECT TOP 1 Path_id FROM [Path]
ORDER BY NEWID()))
INSERT INTO Flight (Flight_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id, Path_id)
VALUES(19, '15.12.2018 04:15', '15.12.2018 13:14', 142, 11,(SELECT TOP 1 Path_id FROM [Path]
ORDER BY NEWID()))
INSERT INTO Flight (Flight_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id, Path_id)
VALUES(20, '16.12.2018 13:15', '16.12.2018 19:14', 142, 9, (SELECT TOP 1 Path_id FROM [Path]
ORDER BY NEWID()))
INSERT INTO Flight (Flight_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id, Path_id)
VALUES(21, '16.12.2018 03:46', '16.12.2018 08:34', 142, 10, (SELECT TOP 1 Path_id FROM [Path]
ORDER BY NEWID()))
INSERT INTO Flight (Flight_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id, Path_id)
VALUES(22, '16.12.2018 05:25', '16.12.2018 10:44', 142, 11, (SELECT TOP 1 Path_id FROM [Path]
ORDER BY NEWID()))
INSERT INTO Flight (Flight_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id, Path_id)
VALUES(23, '15.12.2018 04:25', '15.12.2018 13:24', 280, 12, (SELECT TOP 1 Path_id FROM [Path]
ORDER BY NEWID()))
INSERT INTO Flight (Flight_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id, Path_id)
VALUES(24, '15.12.2018 10:43', '15.12.2018 14:17', 98, 13, (SELECT TOP 1 Path_id FROM [Path]
ORDER BY NEWID()))
INSERT INTO Flight (Flight_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id, Path_id)
VALUES(25, '15.12.2018 13:52', '15.12.2018 16:16', 160, 14, (SELECT TOP 1 Path_id FROM [Path]
ORDER BY NEWID()))
INSERT INTO Flight (Flight_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id, Path_id)
VALUES(26, '15.12.2018 12:15', '15.12.2018 17:24', 240, 15, (SELECT TOP 1 Path_id FROM [Path]
ORDER BY NEWID()))
INSERT INTO Flight (Flight_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id, Path_id)
VALUES(27, '16.12.2018 12:55', '16.12.2018 17:27', 270, 12, (SELECT TOP 1 Path_id FROM [Path]
ORDER BY NEWID()))
INSERT INTO Flight (Flight_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id, Path_id)
VALUES(28, '16.12.2018 08:52', '16.12.2018 12:10', 100, 13, (SELECT TOP 1 Path_id FROM [Path]
ORDER BY NEWID()))
INSERT INTO Flight (Flight_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id, Path_id)
VALUES(29, '16.12.2018 01:14', '16.12.2018 05:14', 160, 14, (SELECT TOP 1 Path_id FROM [Path]
ORDER BY NEWID()))
INSERT INTO Flight (Flight_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id, Path_id)
VALUES(30, '16.12.2018 10:12', '16.12.2018 15:51', 240, 15, (SELECT TOP 1 Path_id FROM [Path]
ORDER BY NEWID()))


GO
INSERT INTO Runway (Runway_id, [Length])
VALUES 
(1, 1950),
(2, 2300),
(3, 2500)

GO
INSERT INTO Person (Person_id, [Name], Surname, Passport_number, Birthdate, Gender)
VALUES
(1, 'Patsy','Lopez', 7265783,       '23.05.1975', 'F'    ) 					
INSERT INTO Person (Person_id, [Name], Surname, Passport_number, Birthdate, Gender)
VALUES(2, 'Emily',  'King	', 2133394,     '28.04.1977', 'F'    )					
INSERT INTO Person (Person_id, [Name], Surname, Passport_number, Birthdate, Gender)
VALUES(3, 'Laura', 'Baldwin',7431724,     '24.07.1977', 'F' )				
INSERT INTO Person (Person_id, [Name], Surname, Passport_number, Birthdate, Gender)
VALUES(4, 'Herman', 'Oliver', 2180552,    '14.10.1979', 'M' )				
INSERT INTO Person (Person_id, [Name], Surname, Passport_number, Birthdate, Gender)
VALUES(5, 'Deanna', 'Hanson', 8333279,    '10.01.1980', 'F' )					
INSERT INTO Person (Person_id, [Name], Surname, Passport_number, Birthdate, Gender)
VALUES(6, 'Cynthia', 'Larson', 6414593,   '23.04.1981', 'F' )					
INSERT INTO Person (Person_id, [Name], Surname, Passport_number, Birthdate, Gender)
VALUES(7, 'Mattie', 'Stokes', 8828925,    '05.05.1982', 'M' )				
INSERT INTO Person (Person_id, [Name], Surname, Passport_number, Birthdate, Gender)
VALUES(8, 'Janet', 'Scott', 5539566,      '29.11.1982', 'F' )					
INSERT INTO Person (Person_id, [Name], Surname, Passport_number, Birthdate, Gender)
VALUES(9, 'Barry', 'Perez', 4665775,      '31.08.1986', 'M' )					
INSERT INTO Person (Person_id, [Name], Surname, Passport_number, Birthdate, Gender)
VALUES(10, 'Martha','Jones', 5868304,     '01.12.1987', 'F' )					
INSERT INTO Person (Person_id, [Name], Surname, Passport_number, Birthdate, Gender)
VALUES(11, 'Shirley','Murray', 2283942,   '21.01.1988', 'M' )					
INSERT INTO Person (Person_id, [Name], Surname, Passport_number, Birthdate, Gender)
VALUES(12, 'Fernando', 'Reeves', 4837145, '17.10.1990', 'M' )				
INSERT INTO Person (Person_id, [Name], Surname, Passport_number, Birthdate, Gender)
VALUES(13, 'Archie', 'Ortega', 7813942,   '10.01.1991', 'M' )				
INSERT INTO Person (Person_id, [Name], Surname, Passport_number, Birthdate, Gender)
VALUES(14, 'Winston', 'Jordan', 7404692,  '19.03.1993', 'M' )				
INSERT INTO Person (Person_id, [Name], Surname, Passport_number, Birthdate, Gender)
VALUES(15, 'Gerardo','Beck', 2367133,     '22.06.1996', 'M' )					
INSERT INTO Person (Person_id, [Name], Surname, Passport_number, Birthdate, Gender)
VALUES(16, 'Armando', 'Norton', 7318202,  '06.11.1996', 'M' )				
INSERT INTO Person (Person_id, [Name], Surname, Passport_number, Birthdate, Gender)
VALUES(17, 'Tricia',' Steele', 8154374,   '28.11.1997', 'F' )					
INSERT INTO Person (Person_id, [Name], Surname, Passport_number, Birthdate, Gender)
VALUES(18, 'Sue','Moss', 1324129,         '16.12.1999', 'F' )						
INSERT INTO Person (Person_id, [Name], Surname, Passport_number, Birthdate, Gender)
VALUES(19, 'Vera','Wade', 1570365,        '22.12.2001', 'F' )						
INSERT INTO Person (Person_id, [Name], Surname, Passport_number, Birthdate, Gender)
VALUES(20, 'Joel', 'Maxwell' , 9554095,   '02.05.2003', 'M' )				
INSERT INTO Person (Person_id, [Name], Surname, Passport_number, Birthdate, Gender)
VALUES(21, 'Harry','Houston' , 9755801,   '03.09.2004', 'M' )				
INSERT INTO Person (Person_id, [Name], Surname, Passport_number, Birthdate, Gender)
VALUES(22, 'Hugh','Cooper' , 1625387,     '26.09.2004', 'M' )				
INSERT INTO Person (Person_id, [Name], Surname, Passport_number, Birthdate, Gender)
VALUES(23, 'Cedric ', 'Little' , 7847163, '25.06.2008', 'M' )			
INSERT INTO Person (Person_id, [Name], Surname, Passport_number, Birthdate, Gender)
VALUES(24, 'Chad', 'Conner' , 1896378,    '23.08.2008', 'M' )				
INSERT INTO Person (Person_id, [Name], Surname, Passport_number, Birthdate, Gender)
VALUES(25, 'Robin', ' Wilson' , 2199774,  '23.03.2009', 'M' )				

