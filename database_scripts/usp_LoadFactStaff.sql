USE demographics
GO

IF OBJECT_ID(N'[dbo].[usp_LoadFactStaff]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[usp_LoadFactStaff]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[usp_LoadFactStaff]   

AS

BEGIN
/* Call usp_LoadFactStaff to insert into the school year dimension table */
/* any new school years found in the latest batch in the staff */
/* demographics staging table. */
	SET NOCOUNT ON; 

	INSERT INTO FactStaff
	(yearID,schoolID,genderID,raceID,hispanicID,[cert])
	SELECT yearID, schoolID, genderID, raceID, hispanicID, [cert]
	FROM StageStaffDemographics staff
	JOIN DimSchoolYear schoolYear ON schoolYear.schoolYear9 = staff.schoolYear
	JOIN DimSchool school ON school.buildingNumber = staff.bldgn
	JOIN DimGender gender ON gender.genderCode = staff.sex
	JOIN DimRace race ON race.raceCode = staff.race
	JOIN DimHispanic hispanic ON hispanic.isHispanic = CASE WHEN staff.hispanic = 'Y' THEN 1 ELSE 0 END
	WHERE staff.loadDatetime =
	(SELECT MAX(loadDatetime) 
	FROM StageStaffDemographics)
	AND [cert] IS NOT NULL
	AND NOT EXISTS
	(SELECT *
	FROM FactStaff fs
	WHERE fs.[cert] = staff.[cert])

	DECLARE @rowsInserted INT;
	SELECT @rowsInserted = @@ROWCOUNT;

	SELECT @rowsInserted AS RowsInserted;

	
END

GO

GRANT EXECUTE ON usp_LoadFactStaff
	TO demographics_user;

GO
