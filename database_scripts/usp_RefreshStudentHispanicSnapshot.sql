USE demographics
GO

IF OBJECT_ID(N'[dbo].[usp_RefreshStudentHispanicSnapshot]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[usp_RefreshStudentHispanicSnapshot]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_RefreshStudentHispanicSnapshot]   

AS

BEGIN
/* Call usp_RefreshStudentHispanicSnapshot to refresh the student snapshot */
/* for Hispanic ethnicity data from the latest from the student */
/* demographics staging table. */
	SET NOCOUNT ON; 

	DELETE FROM StudentHispanicSnapshot;

	INSERT INTO StudentHispanicSnapshot
	(yearID,schoolYear,countyDistrictNumber,district,schoolID,schoolName,ethnicity,studentCount,totalEnrollment,percentOfStudents)
	SELECT DISTINCT yearID,schoolYear9 AS schoolYear,student.countyDistrictNumber, student.district,school.schoolID,student.school AS schoolName,
	'Hispanic' AS ethnicity,
	student.numberHispanic AS studentCount,
	student.totalEnrollment,
	student.percentHispanic AS percentOfStudents
	FROM StageStudentDemographics student
	JOIN DimSchoolYear schoolYear ON schoolYear.schoolYear7 = student.schoolYear
	JOIN DimSchool school ON school.buildingNumber = student.buildingNumber
	WHERE loadDatetime =
	(SELECT MAX(loadDatetime)
	FROM StageStudentDemographics)
	ORDER BY student.school

	DECLARE @rowsInserted INT;
	SELECT @rowsInserted = @@ROWCOUNT;

	UPDATE shs
	SET shs.geopoint = school.geopoint
	FROM StudentHispanicSnapshot shs
	JOIN DimSchool school ON school.schoolID = shs.schoolID;

	SELECT @rowsInserted AS RowsInserted;

	
END

GO

GRANT EXECUTE ON usp_RefreshStudentHispanicSnapshot
	TO demographics_user;

GO



