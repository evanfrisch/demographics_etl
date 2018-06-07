USE demographics
GO

IF OBJECT_ID(N'[dbo].[usp_RefreshStudentRaceSnapshot]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[usp_RefreshStudentRaceSnapshot]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[usp_RefreshStudentRaceSnapshot]   

AS

BEGIN
/* Call usp_RefreshStudentRaceSnapshot to refresh the student race snapshot */
/* from the latest from the student demographics staging table. */
	SET NOCOUNT ON; 

	DELETE FROM StudentRaceSnapshot;

	INSERT INTO StudentRaceSnapshot
	(yearID,schoolYear,countyDistrictNumber,district,schoolID,schoolName,race,studentCount,totalEnrollment,percentOfStudents)
	SELECT DISTINCT yearID,schoolYear9 AS schoolYear,student.countyDistrictNumber, student.district,school.schoolID,student.school AS schoolName,
	CASE WHEN race.twoOrMoreRaces = 1 THEN 'Two or More Races' 
			 WHEN race.raceCode = 'A' THEN 'Asian'
			 WHEN race.raceCode = 'B' THEN 'Black/African American'
			 WHEN race.raceCode = 'I' THEN 'Indian/Native American'
			 WHEN race.raceCode = 'P' THEN 'Pacific Islander'
			 WHEN race.raceCode = 'W' THEN 'White/Caucasian' END AS race,
	CASE WHEN race.twoOrMoreRaces = 1 THEN student.numberTwoOrMoreRaces 
			 WHEN race.raceCode = 'A' THEN student.numberAsian
			 WHEN race.raceCode = 'B' THEN student.numberBlack
			 WHEN race.raceCode = 'I' THEN student.numberAmericanIndianorAlaskanNative
			 WHEN race.raceCode = 'P' THEN student.numberPacificIslander
			 WHEN race.raceCode = 'W' THEN student.numberWhite END AS studentCount,
	student.totalEnrollment,
	CASE WHEN race.twoOrMoreRaces = 1 THEN student.percentTwoOrMoreRaces 
			 WHEN race.raceCode = 'A' THEN student.percentAsian
			 WHEN race.raceCode = 'B' THEN student.percentBlack
			 WHEN race.raceCode = 'I' THEN student.percentAmericanIndianorAlaskanNative
			 WHEN race.raceCode = 'P' THEN student.percentPacificIslander
			 WHEN race.raceCode = 'W' THEN student.percentWhite END AS percentOfStudents
	FROM StageStudentDemographics student
	JOIN DimSchoolYear schoolYear ON schoolYear.schoolYear7 = student.schoolYear
	JOIN DimSchool school ON school.buildingNumber = student.buildingNumber
	JOIN DimRace race ON race.raceCode IN ('A','B','I','P','W') OR race.twoOrMoreRaces = 1
	WHERE loadDatetime =
	(SELECT MAX(loadDatetime)
	FROM StageStudentDemographics)
	ORDER BY student.school

	DECLARE @rowsInserted INT;
	SELECT @rowsInserted = @@ROWCOUNT;

	UPDATE srs
	SET srs.geopoint = school.geopoint
	FROM StudentRaceSnapshot srs
	JOIN DimSchool school ON school.schoolID = srs.schoolID;

	SELECT @rowsInserted AS RowsInserted;

END

GO

GRANT EXECUTE ON usp_RefreshStudentRaceSnapshot
	TO demographics_user;

GO



