USE demographics

GO

IF OBJECT_ID(N'[dbo].[vw_StudentRaceSnapshot]','V') IS NOT NULL
	DROP VIEW [dbo].[vw_StudentRaceSnapshot]
GO

CREATE VIEW vw_StudentRaceSnapshot AS
SELECT schoolYear,countyDistrictNumber,district,schoolID,schoolName,race,studentCount,totalEnrollment,percentOfStudents
FROM StudentRaceSnapshot

GO

GRANT SELECT ON vw_StudentRaceSnapshot
	TO demographics_user;

GO








