USE demographics
GO

IF OBJECT_ID(N'[dbo].[usp_LoadDimSchool]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[usp_LoadDimSchool]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[usp_LoadDimSchool]   

AS

BEGIN
/* Call usp_LoadDimRace to insert into the school dimension table */
/* any new schools found in the latest batch in the student */
/* demographics staging table. */
	SET NOCOUNT ON; 
	
	INSERT INTO DimSchool 
	(buildingNumber,countyDistrictNumber,district,schoolName,schoolTypeCode,gradeSpan,schoolAddress,zipcode,x,y)
	SELECT DISTINCT buildingNumber,countyDistrictNumber,student.district,school,schoolTypeCode,gradeSpan,geo.[address],geo.zipcode,geo.x,geo.y
	FROM StageStudentDemographics student
	LEFT JOIN StageSchoolGeography geo ON geo.ospi_code = student.buildingNumber
	WHERE student.loadDatetime =
	(SELECT MAX(loadDatetime) 
	FROM StageStudentDemographics)
	AND NOT EXISTS 
	(SELECT * 
	FROM DimSchool school
	WHERE school.buildingNumber = student.buildingNumber)
	
	DECLARE @rowsInserted INT;
	SELECT @rowsInserted = @@ROWCOUNT;

	UPDATE ds
	SET geopoint = geography::STPointFromText('POINT(' + CAST(x AS VARCHAR(20)) + ' ' + CAST(y AS VARCHAR(20)) + ')', 4326)
	FROM DimSchool ds
	WHERE x IS NOT NULL
	AND y IS NOT NULL;

	SELECT @rowsInserted AS RowsInserted;

END

GO

GRANT EXECUTE ON usp_LoadDimSchool
	TO demographics_user;

GO


