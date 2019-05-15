use [airport_task]
GO
--Процедура для добавления нового пассажира 
CREATE PROCEDURE [dbo].Proc_AddPassenger 
	@NAME nvarchar(20),
	@SURNAME nvarchar(20),
	@PASSPORT_NUMBER int,
	@BIRTHDATE datetime,
	@GENDER nvarchar(1), 
	@SKYPRIORITY bit = NULL
AS
BEGIN

	DECLARE @person_id int = (SELECT Person_id FROM Person WHERE [Name] = @NAME AND Surname = @SURNAME AND Passport_number = @PASSPORT_NUMBER AND Birthdate = @BIRTHDATE)
	
	IF @person_id IS NOT NULL
	BEGIN
			--Есть ли уже такой пассажир?
			IF EXISTS (SELECT * FROM Passenger WHERE Person_id = @person_id)
			BEGIN
				PRINT('Passanger id: '+ Cast(@PERSON_ID AS NVARCHAR(MAX)) + '|' + ' ' + @NAME + ' ' + @SURNAME + ' already exists.')
			END
			ELSE
			BEGIN
				-- это случай, когда работник аэропорта куда-то летит в первый раз
					INSERT INTO Passenger(Person_id, Sky_priority)
					VALUES(@person_id, @SKYPRIORITY)
			END
	END
	ELSE
	BEGIN
		SET @person_id = (SELECT MAX(Person_id) FROM Person) + 1
		INSERT INTO Person(Person_id, [Name], Surname, Passport_number, Birthdate, Gender)
		VALUES(@person_id, @NAME, @SURNAME, @PASSPORT_NUMBER, @BIRTHDATE, @GENDER)
		--Если триггер не выдал исключение
		IF EXISTS (SELECT * FROM Person WHERE Person_id = @person_id)
		BEGIN 
			INSERT INTO Passenger(Person_id, Sky_priority)
			VALUES (@person_id, @SKYPRIORITY)
		END
	END
END


GO
--Процедура для добавления нового Сотрудника
CREATE PROCEDURE [dbo].Proc_AddEmployee
	@NAME nvarchar(20),
	@SURNAME nvarchar(20),
	@PASSPORT_NUMBER int,
	@BIRTHDATE datetime,
	@GENDER nvarchar(1),
	@POSITION nvarchar(20),
	@SALARY decimal(18, 0),
	@EMAIL nvarchar(20),
	@PHONE int,
	@TYPE nchar(1)

AS
BEGIN
	DECLARE @person_id int = (SELECT Person_id FROM Person WHERE [Name] = @NAME AND Surname = @SURNAME AND Passport_number = @PASSPORT_NUMBER AND Birthdate = @BIRTHDATE)
	IF @TYPE != 'o' and @TYPE != 'O' and @TYPE != 'm' and @TYPE != 'M'
	BEGIN
		PRINT('Wrong Employee type!')
	END
	ELSE
	BEGIN
		IF @person_id IS NOT NULL
		BEGIN			
						-- это случай, когда пассажир становится рабочим	
						IF @person_id is NULL
						BEGIN
							SET @person_id = (SELECT MAX(Person_id) FROM Person) + 1
							INSERT INTO Person(Person_id, [Name], Surname, Passport_number, Birthdate, Gender)
							VALUES(@person_id, @NAME, @SURNAME, @PASSPORT_NUMBER, @BIRTHDATE, @GENDER)
							IF EXISTS (SELECT * FROM Person WHERE Person_id = @person_id)
							BEGIN
								INSERT INTO Employee(Person_id, Position, Email, Phone, Salary)
								VALUES(@person_id, @POSITION, @EMAIL, @PHONE, @SALARY)
								IF EXISTS(SELECT * FROM Employee WHERE Person_id = @person_id)
								BEGIN
									IF @TYPE = 'O' OR @TYPE = 'o'
									BEGIN
										INSERT INTO Operator(Person_id)
										VALUES (@person_id)
									END

									ELSE
									BEGIN
										INSERT INTO Manager(Person_id)
										VALUES (@person_id)
									END
								END
							END													
						END						
			END
	END
END




GO
--Процедура для регистрации пассажира
CREATE PROCEDURE [dbo].Proc_Check_In   
	@FLIGHT_ID int, 
	@NAME nvarchar(20),
	@SURNAME nvarchar(20),
	@GENDER nvarchar(1),
	@PASSPORT_NUMBER int,
	@BIRTHDATE datetime,
	@BAGGAGE_WEIGHT float, 
	@MANAGER_ID int,
	@SKYPRIORITY bit = NULL

AS
BEGIN
	IF NOT EXISTS (SELECT * FROM Departure WHERE Flight_id = @FLIGHT_ID)
	BEGIN
		PRINT('Flight number: ' + CAST(@Flight_id AS NVARCHAR(MAX)) + ' does not depart from this airport!')
	END
	ELSE
	BEGIN
		IF @MANAGER_ID NOT IN (SELECT Person_id FROM Manager)
		BEGIN
		PRINT('This procedure is only available for Managers. ')
		END
		ELSE
		BEGIN
			
			-- Сначала добавляем пассажира в таблицу Пассажиры
			EXECUTE [dbo].Proc_AddPassenger @NAME,	@SURNAME, @PASSPORT_NUMBER, @BIRTHDATE, @GENDER, @SKYPRIORITY  
			DECLARE @Person_id int = (SELECT per.Person_id FROM Passenger pas JOIN Person per ON pas.Person_id = per.Person_id WHERE [Name] = @NAME AND Surname = @SURNAME AND
			Passport_number = @PASSPORT_NUMBER AND Birthdate = @BIRTHDATE)
			IF @Person_id IS NOT NULL
			BEGIN			
				INSERT INTO Check_in(Flight_id, Passenger_id, Baggage_weight, [Time], Manager_id)
				VALUES(@FLIGHT_ID, @Person_id, @BAGGAGE_WEIGHT, GETDATE(), @MANAGER_ID)
			END
		END
	END
END


GO
--Основная процедура Оператора. Назначение полосы/изменение статуса
CREATE PROCEDURE [dbo].Proc_Runway
	@FLIGHT_ID int, 
	@OPERATOR_ID int, 
	@STATUS nvarchar(15),
	@RUNWAY_ID int 

AS
BEGIN
	IF @STATUS != 'processing' AND @STATUS != 'processed' AND @STATUS != 'took off' AND @STATUS != 'landed' AND  @STATUS != 'delayed'
	OR NOT EXISTS(SELECT * FROM Flight WHERE Flight_id = @FLIGHT_ID) 
	BEGIN
		PRINT('VALUE ERROR')
	END
	ELSE
	BEGIN
		
		IF @OPERATOR_ID NOT IN (SELECT Person_id FROM Operator)
		BEGIN
			PRINT('This procedure is only available for Operators.')
		END
		ELSE
		BEGIN
			DECLARE @length float = (SELECT M.Runway_min FROM Flight F JOIN Aircraft A ON F.Aircraft_id = A.Aircraft_id 
			JOIN Model M ON M.Model_id = A.Model_id WHERE F.Flight_id = @FLIGHT_ID)

			DECLARE @runway float = (SELECT [Length] FROM Runway WHERE Runway_id = @RUNWAY_ID)

			IF @runway < @length
			BEGIN
					PRINT('Wrong runway! Minimum length for this aircraft: '+ cast(@length as nvarchar(max)))
			END
			ELSE
			BEGIN
				IF @FLIGHT_ID IN (SELECT Flight_id FROM Arrival)
				BEGIN
					UPDATE Arrival
					SET [Status] = @STATUS, Operator_id = @OPERATOR_ID, Runway_id = @RUNWAY_ID
					WHERE Flight_id = @FLIGHT_ID
				END
				ELSE
				BEGIN
					UPDATE Departure
					SET [Status] = @STATUS, Operator_id = @OPERATOR_ID, Runway_id = @RUNWAY_ID
					WHERE Flight_id = @FLIGHT_ID
				END
			END
		END
	END		
END



GO
--Основная процедура Оператора. Назначение полосы/изменение статуса
CREATE PROCEDURE [dbo].Proc_Belt
	@FLIGHT_ID int, 
	@OPERATOR_ID int, 
	@STATUS nvarchar(15),
	@BELT_ID int 

AS
BEGIN
	IF @STATUS != 'processing' AND @STATUS != 'processed' AND @STATUS != 'took off' AND @STATUS != 'landed' AND  @STATUS != 'delayed'
	OR NOT EXISTS(SELECT * FROM Arrival WHERE Flight_id = @FLIGHT_ID) 
	BEGIN
		PRINT('VALUE ERROR')
	END
	ELSE
	BEGIN
		
		IF @OPERATOR_ID NOT IN (SELECT Person_id FROM Operator)
		BEGIN
			PRINT('This procedure is only available for Operators.')
		END
		ELSE
		BEGIN
			DECLARE @capacity int = (SELECT Passangers_amount FROM Flight WHERE Flight_id = @FLIGHT_ID  )

			DECLARE @belt_capacity int = (SELECT Capacity FROM Belt WHERE Belt_id = @BELT_ID)

			IF @belt_capacity < @capacity
			BEGIN
					PRINT('Wrong belt! Minimum belt capacity for this aircraft: '+ cast(@capacity as nvarchar(max)))
			END
			ELSE
			BEGIN
				UPDATE Arrival
				SET [Status] = @STATUS, Operator_id = @OPERATOR_ID, Belt_id = @BELT_ID
				WHERE Flight_id = @FLIGHT_ID
			END
		END
	END		
END



 GO
--Запрос №2
CREATE PROCEDURE [dbo].Proc_Table
	@DATE date, 
	@TYPE nchar(1)

AS
BEGIN
	IF NOT EXISTS(SELECT * FROM Flight WHERE cast(Arrival_time as date) = @DATE OR cast(Departure_time as date) = @DATE)
	BEGIN
		PRINT('Wrong date.')
	END
	ELSE
	BEGIN
		IF @TYPE != 'a' AND @TYPE != 'A' AND @TYPE != 'd' AND @TYPE != 'D'
		BEGIN
			PRINT('Wrong type.')
		END
		ELSE
		BEGIN
			IF @TYPE = 'a' OR @TYPE = 'A' 
			BEGIN
				SELECT CAST(CAST(flight.Arrival_time as time) as nvarchar(5))  as [Time], airline.[Name] as [Airline], 
				airline.Code + ' ' + p.Path_id as [Flight number], city.[Name], airport.[Name],
				model.[Name] as [Aircraft], arrival.Belt_id AS [Belt], arrival.Runway_id AS [Runway],  arrival.[Status], arrival.Operator_id AS [Last change by]
				FROM Arrival arrival
				JOIN Flight flight ON arrival.Flight_id = flight.Flight_id
				JOIN Path p ON p.Path_id = flight.Path_id
				JOIN Aircraft aircraft ON flight.Aircraft_id = aircraft.Aircraft_id
				JOIN Model model ON aircraft.Model_id = model.Model_id
				JOIN Airline airline ON aircraft.Airline_id = airline.Airline_id
				JOIN Airport airport ON p.Airport_id = airport.Airport_id
				JOIN City city ON city.City_id = airport.City_id			
				WHERE CAST(flight.Arrival_time as date) = @DATE
				ORDER BY flight.Arrival_time
			END
			ELSE
			BEGIN
				SELECT CAST(CAST(flight.Departure_time as time) as nvarchar(5))  as [Time], airline.[Name] as [Airline], 
				airline.Code + ' ' + p.Path_id as [Flight number], city.[Name], airport.[Name],
				model.[Name] as [Aircraft], departure.Runway_id AS [Runway], departure.[Status], departure.Operator_id AS [Last change by]
				FROM Departure departure
				JOIN Flight flight ON departure.Flight_id = flight.Flight_id
				JOIN Aircraft aircraft ON flight.Aircraft_id = aircraft.Aircraft_id
				JOIN Path p ON p.Path_id = flight.Path_id
				JOIN Model model ON aircraft.Model_id = model.Model_id
				JOIN Airline airline ON aircraft.Airline_id = airline.Airline_id
				JOIN Airport airport ON p.Airport_id = airport.Airport_id
				JOIN City city ON city.City_id = airport.City_id
				WHERE CAST(flight.Departure_time as date) = @DATE
				ORDER BY flight.Departure_time
			END
		END
	END
END






