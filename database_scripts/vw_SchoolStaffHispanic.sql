USE demographics

GO

IF OBJECT_ID(N'[dbo].[vw_SchoolStaffHispanic]','V') IS NOT NULL
	DROP VIEW [dbo].[vw_SchoolStaffHispanic]
GO

CREATE VIEW vw_SchoolStaffHispanic AS
SELECT yr.schoolYear9 AS schoolYear,school.countyDistrictNumber,school.district,school.schoolID,school.schoolName,Hispanic.isHispanic,COUNT(*) AS staffCount,total.staffCount AS totalStaffCount, 100.0*COUNT(*)/total.staffCount AS percentOfStaff
FROM FactStaff fs
JOIN DimSchoolYear yr ON yr.yearID = fs.yearID 
JOIN DimSchool school ON school.schoolID = fs.schoolID 
JOIN DimHispanic Hispanic ON hispanic.HispanicID = fs.hispanicID 
JOIN vw_SchoolStaffCount total ON total.schoolID = school.schoolID
GROUP BY yr.schoolYear9,school.countyDistrictNumber,school.district,school.schoolID,school.schoolName,hispanic.isHispanic,total.staffCount
GO

GRANT SELECT ON vw_SchoolStaffHispanic
	TO demographics_user;

GO




