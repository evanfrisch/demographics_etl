USE demographics
GO

IF OBJECT_ID(N'[dbo].[usp_LoadDimSchoolYear]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[usp_LoadDimSchoolYear]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[usp_LoadDimSchoolYear]   

AS

BEGIN
/* Call usp_LoadDimSchoolYear to insert into the school year dimension table */
/* any new school years found in the latest batch in the staff */
/* demographics staging table. */
	SET NOCOUNT ON; 

	INSERT INTO DimSchoolYear
	(schoolYear7,schoolYear9,startYear,endYear)
	SELECT DISTINCT CONCAT(LEFT(schoolYear,4),'-',RIGHT(schoolYear,2)),schoolYear,CAST(LEFT(schoolYear,4) AS INT),CAST(RIGHT(schoolYear,4) AS INT)
	FROM StageStaffDemographics staff
	WHERE staff.loadDatetime =
	(SELECT MAX(loadDatetime) 
	FROM StageStaffDemographics)
	AND NOT EXISTS
	(SELECT *
	FROM DimSchoolYear schoolYear
	WHERE schoolYear.schoolYear9 = staff.schoolYear)

	DECLARE @rowsInserted INT;
	SELECT @rowsInserted = @@ROWCOUNT;

	SELECT @rowsInserted AS RowsInserted;
	
END

GO

GRANT EXECUTE ON usp_LoadDimSchoolYear
	TO demographics_user;

GO
