USE [Trigers_Example]


go
CREATE TRIGGER New_member1 ON dbo.Books
AFTER INSERT 
AS
BEGIN
	INSERT INTO dbo.Members (firstname, lastname)
	values ('Hi!', 'checking')
END;

GO
INSERT INTO dbo.Books (title, author, published, stock)
VALUES ('qwerty', 'ÍÎÐÌ,', '18.12.1999', 22)

go
CREATE TRIGGER New_member11 ON dbo.Books
INSTEAD OF INSERT 
AS
DECLARE @title nvarchar(MAX)

DECLARE @author nvarchar(50)
DECLARE @published date
DECLARE @stock int

SELECT  @title = title, @author = author, @published = published, @stock = stock from inserted

BEGIN
	IF @title = 'qwerty'
	BEGIN
		PRINT('Íåëüçÿ!!!!')
	END
	ELSE
	BEGIN
		INSERT INTO dbo.Books(title, author, published, stock)
		VALUES ( @title, @author, @published, @stock)
	END;
END;

GO

CREATE TRIGGER New_member ON dbo.Books
INSTEAD OF INSERT 
AS
BEGIN
	INSERT INTO dbo.Members (firstname, lastname)
	values ('Hi!', 'checking')
END;

GO
INSERT INTO dbo.Books (title, author, published, stock)
VALUES ('FDGFGD', 'DGHDG,', '18.12.1999', 22)

go
CREATE TRIGGER New_member1 ON dbo.Books
AFTER INSERT 
AS
BEGIN
	INSERT INTO dbo.Members (firstname, lastname)
	values ('Hi!', 'checking')
END;