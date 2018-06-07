USE demographics
GO

IF OBJECT_ID(N'[dbo].[usp_LoadDimGender]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[usp_LoadDimGender]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[usp_LoadDimGender]   

AS

BEGIN
/* Call usp_LoadDimGender to insert into the gender dimension table */
/* any new gender codes found in the latest batch in the staff */
/* demographics staging table. */
	SET NOCOUNT ON; 

	INSERT INTO DimGender 
	(genderCode,genderName)
	SELECT DISTINCT Sex, CASE WHEN Sex = 'F' THEN 'Female' WHEN Sex = 'M' THEN 'Male' END
	FROM StageStaffDemographics staff
	WHERE staff.loadDatetime =
	(SELECT MAX(loadDatetime) 
	FROM StageStaffDemographics)
	AND NOT EXISTS
	(SELECT *
	FROM DimGender gender
	WHERE gender.genderCode = staff.Sex)

	DECLARE @rowsInserted INT;
	SELECT @rowsInserted = @@ROWCOUNT;

	SELECT @rowsInserted AS RowsInserted;	
END

GO

GRANT EXECUTE ON usp_LoadDimGender
	TO demographics_user;

GO


