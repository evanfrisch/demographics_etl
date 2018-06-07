USE demographics

GO

IF OBJECT_ID(N'[dbo].[vw_StudentGenderSnapshot]','V') IS NOT NULL
	DROP VIEW [dbo].[vw_StudentGenderSnapshot]
GO

CREATE VIEW vw_StudentGenderSnapshot ASs
SELECT schoolYear,countyDistrictNumber,district,schoolID,schoolName,gender,studentCount,totalEnrollment,percentOfStudents
FROM StudentGenderSnapshot

GO

GRANT SELECT ON vw_StudentGenderSnapshot
	TO demographics_user;

GO
