USE demographics

GO

IF OBJECT_ID(N'[dbo].[vw_StudentHispanicSnapshot]','V') IS NOT NULL
	DROP VIEW [dbo].[vw_StudentHispanicSnapshot]
GO

CREATE VIEW vw_StudentHispanicSnapshot AS
SELECT schoolYear,countyDistrictNumber,district,schoolID,schoolName,ethnicity,studentCount,totalEnrollment,percentOfStudents
FROM StudentHispanicSnapshot
UNION 
SELECT schoolYear,countyDistrictNumber,district,schoolID,schoolName,'Non-Hispanic' AS ethnicity,totalEnrollment-studentCount AS studentCount,totalEnrollment,CASE WHEN studentCount = 0 THEN 0.00 ELSE 100.0-percentOfStudents END AS percentOfStudents
FROM StudentHispanicSnapshot

GO

GRANT SELECT ON vw_StudentHispanicSnapshot
	TO demographics_user;

GO
