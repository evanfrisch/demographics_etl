USE demographics

GO

IF OBJECT_ID(N'[dbo].[vw_SchoolStaffCount]','V') IS NOT NULL
	DROP VIEW [dbo].[vw_SchoolStaffCount]
GO

CREATE VIEW vw_SchoolStaffCount AS
SELECT schoolYear.schoolYear9 AS schoolYear,fs.schoolID,COUNT(*) AS staffCount
FROM FactStaff fs
JOIN DimSchoolYear schoolYear ON schoolYear.yearID = fs.yearID
GROUP BY schoolYear.schoolYear9,schoolID

GO

GRANT SELECT ON vw_SchoolStaffCount
	TO demographics_user;

GO