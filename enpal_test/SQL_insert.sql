-- SQL script to populate the tables

USE [enpal_test]
GO


INSERT INTO bases (team_id, latitude, longitude)
VALUES 
(1, 52.5167, 13.3833),  --Berlin
(2, 48.1372, 11.5755),	--Munich
(3, 50.1136, 8.6797),	--Frankfurt
(4, 52.5167, 13.3833),
(5, 48.1372, 11.5755),
(6, 50.1136, 8.6797),
(7, 50.1136, 8.6797),
(8, 52.5167, 13.3833),
(9, 48.1372, 11.5755),
(10, 50.1136, 8.6797)
GO

-- Insert values into teams table, with random dates and skill levels
INSERT INTO teams(team_id, availability_from, availability_till, skill_level)
VALUES 
( 1, CAST(DATEADD(YEAR , -2, GETDATE()) AS DATE), CAST(DATEADD(YEAR, 2, GETDATE()) AS DATE) , ABS(CHECKSUM(NEWID())) % 3 + 1),		
( 2, CAST(DATEADD(MONTH, -7, GETDATE()) AS DATE), CAST(DATEADD(MONTH, 7, GETDATE()) AS DATE), ABS(CHECKSUM(NEWID())) % 3 + 1),		
( 3, CAST(DATEADD(YEAR , -1, GETDATE()) AS DATE), CAST(DATEADD(YEAR, 1, GETDATE()) AS DATE) , ABS(CHECKSUM(NEWID())) % 3 + 1),		
( 4, CAST(DATEADD(MONTH, -3, GETDATE()) AS DATE), CAST(DATEADD(YEAR, 2, GETDATE()) AS DATE) , ABS(CHECKSUM(NEWID())) % 3 + 1),
( 5, CAST(DATEADD(MONTH, -1, GETDATE()) AS DATE), CAST(DATEADD(YEAR, 2, GETDATE()) AS DATE) , ABS(CHECKSUM(NEWID())) % 3 + 1),
( 6, CAST(DATEADD(YEAR , -2, GETDATE()) AS DATE), CAST(DATEADD(MONTH, 6, GETDATE()) AS DATE), ABS(CHECKSUM(NEWID())) % 3 + 1),
( 7, CAST(DATEADD(MONTH, -2, GETDATE()) AS DATE), CAST(DATEADD(MONTH, 8, GETDATE()) AS DATE), ABS(CHECKSUM(NEWID())) % 3 + 1),
( 8, CAST(DATEADD(YEAR , -1, GETDATE()) AS DATE), CAST(DATEADD(MONTH, 3, GETDATE()) AS DATE), ABS(CHECKSUM(NEWID())) % 3 + 1),
( 9, CAST(DATEADD(MONTH, -1, GETDATE()) AS DATE), CAST(DATEADD(YEAR, 1, GETDATE()) AS DATE) , ABS(CHECKSUM(NEWID())) % 3 + 1),
(10, CAST(DATEADD(YEAR , -3, GETDATE()) AS DATE), CAST(DATEADD(MONTH, 6, GETDATE()) AS DATE), ABS(CHECKSUM(NEWID())) % 3 + 1)
GO


-- Insert values in customers table, with random number of panels up to 25 panels and random installation dates
INSERT INTO [dbo].[customers]
           ([latitude]
           ,[longitude]
           ,[panels_to_install]
           ,[installation_start_date])
     VALUES
        (49.5103, 11.2772, ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE)),
		(48.5667, 13.4667, ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE)),
		(52.85, 11.15	 , ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE)),
		(50.7189, 12.4961, ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE)),
		(49.9757, 9.1478 , ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE)),
		(51.4458, 7.5653 , ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE)),
		(49.35, 9.1333	 , ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE)),
		(48.2689, 10.8908, ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE)),
		(51.9458, 7.1675 , ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE)),
		(51.0631, 6.0964 , ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE)),
		(51.2, 6.4333	 , ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE)),
		(49.8667, 8.65	 , ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE)),
		(51.1167, 6.95	 , ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE)),
		(47.9947, 7.8497 , ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE)),
		(53.4714, 7.4836 , ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE)),
		(51.3658, 6.4194 , ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE)),
		(48.6333, 12.5	 , ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE)),
		(48.5667, 13.4667, ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE)),
		(50.8961, 14.8072, ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE)),
		(50.9622, 13.9403, ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE)),
		(51.5167, 7.1	 , ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE)),
		(50.8744, 6.1615 , ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE)),
		(51.505, 10.7911 , ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE)),
		(50.9787, 11.0328, ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE)),
		(49.6811, 8.6228 , ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE)),
		(48.8372, 10.0936, ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE)),
		(51.5667, 6.7333 , ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE)),
		(49.0167, 8.4	 , ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE)),
		(51.5603, 13.0056, ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE)),
		(49.0167, 8.4	 , ABS(CHECKSUM(NEWID())) % 25 + 1, CAST('2022-11-01' AS DATE))

-- Update installation date with random dates
DECLARE @FromDate DATETIME = DATEADD(MONTH, -1, GETDATE())
DECLARE @ToDate   DATETIME = DATEADD(MONTH, 4, GETDATE())

DECLARE @Seconds INT = DATEDIFF(SECOND, @FromDate, @ToDate)
DECLARE @cnt INT = 1
WHILE @cnt<31
BEGIN
	DECLARE @Random INT = ROUND(((@Seconds-1) * RAND()), 0)
	DECLARE @Milliseconds INT = ROUND((999 * RAND()), 0)

	UPDATE customers
	SET installation_start_date= cast(DATEADD(MILLISECOND, @Milliseconds, DATEADD(SECOND, @Random, @FromDate)) AS DATE)
	where customer_id=@cnt
	SET @cnt = @cnt+1
END

GO

-- Update availabilities of teams with random dates
USE enpal_test

DECLARE @FromDate DATETIME = (SELECT min(availability_from) from teams)
DECLARE @ToDate   DATETIME = DATEADD(MONTH, 4, GETDATE())

DECLARE @Seconds INT = DATEDIFF(SECOND, @FromDate, @ToDate)
DECLARE @cnt INT = 1
WHILE @cnt<11
BEGIN
	DECLARE @Random INT = ROUND(((@Seconds-1) * RAND()), 0)
	DECLARE @Milliseconds INT = ROUND((999 * RAND()), 0)

	UPDATE teams
	SET availability_till= cast(DATEADD(MILLISECOND, @Milliseconds, DATEADD(SECOND, @Random, @FromDate)) AS DATE)
	where team_id=@cnt
	SET @cnt = @cnt+1
END