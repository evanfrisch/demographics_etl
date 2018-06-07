USE demographics
GO

IF OBJECT_ID(N'[dbo].[usp_RefreshStudentGenderSnapshot]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[usp_RefreshStudentGenderSnapshot]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[usp_RefreshStudentGenderSnapshot]   

AS

BEGIN
/* Call usp_RefreshStudentGenderSnapshot to refresh the student gender snapshot */
/* from the latest from the student demographics staging table. */
	SET NOCOUNT ON; 

	DELETE FROM StudentGenderSnapshot;

	INSERT INTO StudentGenderSnapshot
	(yearID,schoolYear,countyDistrictNumber,district,schoolID,schoolName,gender,studentCount,totalEnrollment,percentOfStudents)
	SELECT DISTINCT yearID,schoolYear9 AS schoolYear,student.countyDistrictNumber, student.district,school.schoolID,student.school AS schoolName,
	gender.genderName,
	CASE WHEN gender.genderCode = 'F' THEN numberFemales
		 WHEN gender.genderCode = 'M' THEN numberMales END AS studentCount,
	student.totalEnrollment,
	CASE WHEN gender.genderCode = 'F' THEN percentFemales
		 WHEN gender.genderCode = 'M' THEN percentMales END AS percentOfStudents
	FROM StageStudentDemographics student
	JOIN DimSchoolYear schoolYear ON schoolYear.schoolYear7 = student.schoolYear
	JOIN DimSchool school ON school.buildingNumber = student.buildingNumber
	JOIN DimGender gender ON gender.genderCode IN ('F','M')
	WHERE loadDatetime =
	(SELECT MAX(loadDatetime)
	FROM StageStudentDemographics)
	ORDER BY student.school;

	DECLARE @rowsInserted INT;
	SELECT @rowsInserted = @@ROWCOUNT;

	UPDATE sgs
	SET sgs.geopoint = school.geopoint
	FROM StudentGenderSnapshot sgs
	JOIN DimSchool school ON school.schoolID = sgs.schoolID;

	SELECT @rowsInserted AS RowsInserted;

	
END

GO

GRANT EXECUTE ON usp_RefreshStudentGenderSnapshot
	TO demographics_user;

GO



