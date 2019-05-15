

----Тригер проверки входных данных в Model
--GO
--CREATE TRIGGER Value_check_model ON dbo.model
--INSTEAD OF INSERT 
--AS
--DECLARE @Model_id int, @Name nvarchar(25), @Capacity int, @Runway_min float
--SELECT @Model_id = Model_id , @Name = [Name], @Capacity = Capacity, @Runway_min = Runway_min  FROM inserted
--BEGIN 
--	IF @Model_id <=0 OR @Capacity <= 0 OR @Runway_min <= 0 
--	BEGIN
--		Print('Your value <= 0')
--	END
--	ELSE
--	BEGIN
--		INSERT INTO Model(Model_id, [Name], Capacity, Runway_min)
--		VALUES (@Model_id, @Name, @Capacity, @Runway_min)
--	END
--END
--
--GO
----Тригер проверки входных данных в Airline
--CREATE TRIGGER Value_check_airline ON dbo.airline
--INSTEAD OF INSERT 
--AS
--DECLARE @Airline_id int, @Name nvarchar(20), @Baggage_limit float
--SELECT @Airline_id = Airline_id , @Name = [Name], @Baggage_limit = Baggage_limit FROM inserted
--BEGIN 
--	IF @Airline_id <=0 OR @Baggage_limit <= 0  
--	BEGIN
--		Print('Your value <= 0')
--	END
--	ELSE
--	BEGIN
--		INSERT INTO Airline (Airline_id, [Name], Baggage_limit)
--		VALUES (@Airline_id, @Name, @Baggage_limit)
--	END
--END
--
--GO
----Тригер проверки входных данных в Aircraft
--CREATE TRIGGER Value_check_aircraft ON dbo.aircraft
--INSTEAD OF INSERT 
--AS
--DECLARE @Aircraft_id int, @Production_date datetime, @Model_id int, @Airline_id int
--SELECT @Aircraft_id = Aircraft_id, @Production_date = Production_date, @Model_id = Model_id, @Airline_id = Airline_id FROM inserted
--BEGIN 
--	IF @Aircraft_id <=0 OR @Production_date <=0 OR @Model_id <=0 OR @Airline_id <=0
--	BEGIN
--		Print('Your value <= 0')
--	END
--	ELSE
--	BEGIN
--		INSERT INTO Aircraft(Aircraft_id, Production_date, Model_id, Airline_id)
--		VALUES (@Aircraft_id, @Production_date, @Model_id, @Airline_id)
--	END
--END
--
--GO
----Тригер проверки входных данных в City
--CREATE TRIGGER Value_check_city ON dbo.city
--INSTEAD OF INSERT 
--AS
--DECLARE @City_id int, @Name nvarchar(20)
--SELECT @City_id = City_id, @Name = Name FROM inserted
--BEGIN 
--	IF @City_id <=0 
--	BEGIN
--		Print('Your value <= 0')
--	END
--	ELSE
--	BEGIN
--		INSERT INTO City(City_id, [Name])
--		VALUES (@City_id, @Name)
--	END
--END
--
--GO
----Тригер проверки входных данных в Airport
--CREATE TRIGGER Value_check_airport ON dbo.airport
--INSTEAD OF INSERT 
--AS
--DECLARE @Airport_id int, @Name nvarchar(25), @City_id int
--SELECT @Airport_id = Airport_id, @Name = [Name], @City_id = City_id FROM inserted
--BEGIN 
--	IF @City_id <=0 
--	BEGIN
--		Print('Your value <= 0')
--	END
--	ELSE
--	BEGIN
--		INSERT INTO Airport(Airport_id, [Name], City_id)
--		VALUES (@Airport_id, @Name, @City_id)
--	END
--END
--
use [airport_task]
GO
--Тригер проверки входных данных в Path
CREATE TRIGGER Path_check_airport ON dbo.[path]
INSTEAD OF INSERT 
AS
DECLARE @Airport_id int, @Type nchar(1), @Path_id nvarchar(4)
SELECT @Airport_id = Airport_id, @Type = [Type] FROM inserted
BEGIN 
	IF NOT EXISTS(SELECT * FROM Airport WHERE Airport_id = @Airport_id) OR (@Type != 'A' AND @Type != 'D' AND @Type != 'a' AND @Type != 'd' ) 
	BEGIN
		Print('VALUE ERROR')
	END
	ELSE
	BEGIN
		WHILE 1=1
		BEGIN
			SET @Path_id = CAST(LEFT(RAND() * 100000, 4)  AS nvarchar(4))
			IF NOT EXISTS(SELECT * FROM [Path] WHERE Path_id = @Path_id)
			BEGIN 
				BREAK
			END
		END
		IF @Type = 'A' Or @Type = 'a'
		BEGIN
			SET @Type = 'A'
		END
		ELSE
		BEGIN
			SET @Type = 'D'
		END
		INSERT INTO [Path](Path_id, Airport_id, [Type])
		VALUES (@Path_id, @Airport_id, @Type)
	END
END

GO
--Тригер проверки входных данных в Flight
CREATE TRIGGER Value_check_flight ON dbo.flight
INSTEAD OF INSERT 
AS
DECLARE @Flight_id int, @Path_id nvarchar(7), @Departure_time datetime, @Arrival_time datetime, @Passangers_amount int, @Aircraft_id int
SELECT @Flight_id = Flight_id, @Path_id = [Path_id], @Departure_time = Departure_time, @Arrival_time = Arrival_time,
@Passangers_amount = Passangers_amount, @Aircraft_id = Aircraft_id  FROM inserted
BEGIN 
	IF @Flight_id <=0 OR @Passangers_amount <= 0 OR NOT EXISTS(SELECT * FROM [Path] WHERE Path_id = @Path_id) OR @Departure_time >= @Arrival_time
	BEGIN
		Print('VALUE ERROR')
	END
	ELSE
	BEGIN
		 DECLARE @Amount int
		 SELECT @Amount = m.Capacity
		 FROM Aircraft a		 
		 JOIN Model m
		 ON a.Model_id = m.Model_id
		 WHERE a.Aircraft_id = @Aircraft_id
		 IF @Passangers_amount > @Amount
		 BEGIN
				Print('Passangers amount error! Check the model of the Aircraft.')
		 END
		 ELSE
		 BEGIN
				INSERT INTO Flight(Flight_id, Path_id, Departure_time, Arrival_time, Passangers_amount, Aircraft_id)
				VALUES (@Flight_id, @Path_id, @Departure_time, @Arrival_time, @Passangers_amount, @Aircraft_id)

				IF (SELECT [Type] FROM [Path] WHERE Path_id = @Path_id) = 'A' 
				BEGIN
					INSERT INTO Arrival(Flight_id, [Status])
					VALUES (@Flight_id, 'processing')
				END
				ELSE
				BEGIN
					INSERT INTO Departure(Flight_id, [Status])
					VALUES (@Flight_id, 'processing')
				END
		 END
	END
END

--GO
----Тригер проверки входных данных в Runway
--CREATE TRIGGER Value_check_runway ON dbo.runway
--INSTEAD OF INSERT 
--AS
--DECLARE @Runway_id int, @Length float
--SELECT @Runway_id = Runway_id, @Length = [Length] FROM inserted
--BEGIN 
--	IF @Runway_id <=0 OR  @Length <= 0
--	BEGIN
--		Print('Your value <= 0')
--	END
--	ELSE
--	BEGIN
--		INSERT INTO Runway(Runway_id, [Length])
--		VALUES (@Runway_id, @Length)
--	END
--END
--
GO
--Тригер проверки входных данных в Person
CREATE TRIGGER Value_check_person ON dbo.Person
INSTEAD OF INSERT 
AS
DECLARE @Person_id int, @Name nvarchar(20), @Surname nvarchar(20), @Passport_number int, @Birthdate datetime, @Gender nvarchar(1)
SELECT @Person_id = Person_id, @Name = [Name], @Surname = Surname,
 @Passport_number = Passport_number, @Birthdate = Birthdate, @Gender = Gender FROM inserted
BEGIN 
	IF @Person_id <=0 OR LEN(@Name) <= 1 OR LEN(@Surname) <= 1 OR @Passport_number < 1000000 OR @Passport_number > 9999999 OR @Birthdate > GETDATE() 
	OR (@Gender != 'F' AND @Gender != 'f' AND @Gender != 'M' AND @Gender != 'm')
	BEGIN
		Print('VALUE ERROR')
	END
	ELSE
	BEGIN
		IF EXISTS (SELECT * FROM Person p WHERE p.Passport_number = @Passport_number)
		BEGIN
			PRINT('Passport number ''' + CAST(@Passport_number AS nvarchar(MAX)) + ''' already exists.')
		END
		ELSE 
		BEGIN
			INSERT INTO Person(Person_id, [Name], Surname, Passport_number, Birthdate, Gender)
			VALUES (@Person_id, @Name ,@Surname ,@Passport_number, @Birthdate, @Gender)
		END	
	END
END








GO
--Тригер проверки входных данных в Check-in
CREATE TRIGGER Value_check_checkin ON dbo.Check_in
INSTEAD OF INSERT 
AS
DECLARE @Flight_id int, @Manager_id int, @Baggage_weight float, @Time datetime, @Passenger_id int
SELECT @Flight_id = Flight_id, @Manager_id = Manager_id, @Baggage_weight = Baggage_weight, @Passenger_id = Passenger_id FROM inserted
SET @Time = GETDATE()
BEGIN 
	IF @Flight_id <=0 OR @Flight_id <=0 OR @Manager_id <= 0 OR @Baggage_weight < 0 OR NOT EXISTS(SELECT * FROM Passenger WHERE Person_id = @Passenger_id)
	BEGIN
		Print('VALUE ERROR')
	END
	ELSE
	BEGIN
		IF (SELECT m.Capacity FROM Flight f JOIN Aircraft a ON a.Aircraft_id = f.Aircraft_id
		JOIN Model m ON m.Model_id = a.Model_id WHERE Flight_id = @Flight_id) < 
		1 + (SELECT Passangers_amount FROM Flight WHERE Flight_id = @Flight_id)
		BEGIN 
			PRINT('Plane is FULL')
		END
		ELSE
		BEGIN
			IF EXISTS(SELECT * FROM Check_in WHERE Passenger_id = @Passenger_id AND Flight_id = @Flight_id)
			BEGIN
				PRINT('Passenger (id''' + CAST(@Passenger_id AS nvarchar(MAX)) + ''') is already checked-in. ')
			END
			ELSE 
			BEGIN
				DECLARE @Limit float = (SELECT air.Baggage_limit FROM Flight f JOIN Aircraft a ON f.Aircraft_id = a.Aircraft_id 
				JOIN Airline air ON a.Airline_id = air.Airline_id WHERE f.Flight_id = @Flight_id)

				IF @Baggage_weight > @Limit
				BEGIN
				PRINT('Overweight! Your luggage: ' + CAST(@Baggage_weight AS nvarchar(MAX)) + ' kg || Limit: ' + CAST(@Limit AS nvarchar(MAX)) + ' kg')
				END
				ELSE
				BEGIN
					INSERT INTO Check_in(Flight_id, Baggage_weight, [Time], Manager_id, Passenger_id)
					VALUES (@Flight_id, @Baggage_weight, @Time, @Manager_id, @Passenger_id )
					UPDATE Passenger
					SET Last_flight = GETDATE()
					WHERE Person_id = @Passenger_id
				END
			END
		END	
	END
END


GO
--Тригер проверки входных данных в Departure
CREATE TRIGGER Value_check_departure ON dbo.departure
INSTEAD OF INSERT 
AS
DECLARE @Flight_id int, @Status nvarchar(15), @Operator_id int, @Runway_id int
SELECT @Flight_id = Flight_id, @Status = [Status] FROM inserted
BEGIN 
	IF @Flight_id <=0 
	BEGIN
		Print('Your value <= 0')
	END
	ELSE
	BEGIN
		IF @Status != 'processing' OR (SELECT [Type] FROM Flight f JOIN [Path] p ON f.Path_id = p.Path_id WHERE f.Flight_id = @Flight_id) != 'D' 
		BEGIN
			PRINT('Wrong status/type.')
		END
		ELSE
		BEGIN
			INSERT INTO Departure(Flight_id, [Status])
			VALUES (@Flight_id, @Status)
		END
	END
END

GO
--Тригер проверки входных данных в Arrival
CREATE TRIGGER Value_check_arrival ON dbo.arrival
INSTEAD OF INSERT 
AS
DECLARE @Flight_id int, @Status nvarchar(15), @Operator_id int, @Runway_id int
SELECT @Flight_id = Flight_id, @Status = [Status] FROM inserted
BEGIN 
	IF @Flight_id <=0 
	BEGIN
		Print('Your value <= 0')
	END
	ELSE
	BEGIN
		IF @Status != 'processing' OR (SELECT [Type] FROM Flight f JOIN [Path] p ON f.Path_id = p.Path_id WHERE f.Flight_id = @Flight_id) != 'A' 
		BEGIN
			PRINT('Wrong status/type.')
		END
		ELSE
		BEGIN
			INSERT INTO Arrival(Flight_id, [Status])
			VALUES (@Flight_id, @Status)
		END
	END
END






GO
--Тригер проверки входных данных в Employee
CREATE TRIGGER Value_check_employee ON dbo.Employee
INSTEAD OF INSERT 
AS
DECLARE @Person_id int, @Position nvarchar(20), @Phone int, @Email nvarchar(20), @Salary decimal(18, 0)
SELECT @Person_id = Person_id, @Position = Position, @Phone = Phone, @Email = Email, @Salary = Salary FROM inserted
BEGIN 
	IF @Person_id <=0 OR LEN(@Position) <= 2 OR @Person_id <=0 OR LEN(@Email) <=4 OR @Salary <=0
	BEGIN
		Print('VALUE ERROR')
	END
	ELSE
	BEGIN
		IF EXISTS(SELECT * FROM Employee WHERE Person_id = @Person_id )
		BEGIN
			PRINT('Person id''' + CAST(@Person_id AS nvarchar(MAX)) + ''' already exists.')
		END
		ELSE 
		BEGIN
			INSERT INTO Employee(Person_id, Position, Phone, Email, Salary)
			VALUES (@Person_id ,@Position, @Phone , @Email, @Salary)
		END	
	END
END