USE demographics
GO

IF OBJECT_ID(N'[dbo].[usp_LoadDimRace]','P') IS NOT NULL
	DROP PROCEDURE [dbo].[usp_LoadDimRace]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[usp_LoadDimRace]   

AS

BEGIN
/* Call usp_LoadDimRace to insert into the race dimension table */
/* any new race codes found in the latest batch in the staff */
/* demographics staging table. */
	SET NOCOUNT ON; 

	INSERT INTO DimRace
	(raceCode,twoOrMoreRaces)
	SELECT DISTINCT race, CASE WHEN LEN(race) > 1 THEN 1 ELSE 0 END
	FROM StageStaffDemographics staff
	WHERE ISNULL(race,'') <> ''
	AND staff.loadDatetime =
	(SELECT MAX(loadDatetime) 
	FROM StageStaffDemographics)
	AND NOT EXISTS
	(SELECT *
	FROM DimRace race
	WHERE race.raceCode = staff.race)
	ORDER BY CASE WHEN LEN(race) > 1 THEN 1 ELSE 0 END,race
	
	DECLARE @rowsInserted INT;
	SELECT @rowsInserted = @@ROWCOUNT;

	SELECT @rowsInserted AS RowsInserted;
END

GO

GRANT EXECUTE ON usp_LoadDimRace
	TO demographics_user;

GO


