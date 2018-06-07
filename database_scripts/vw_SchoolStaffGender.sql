USE demographics

GO

IF OBJECT_ID(N'[dbo].[vw_SchoolStaffGender]','V') IS NOT NULL
	DROP VIEW [dbo].[vw_SchoolStaffGender]
GO

CREATE VIEW vw_SchoolStaffGender AS
SELECT yr.schoolYear9 AS schoolYear,school.countyDistrictNumber,school.district,school.schoolID,school.schoolName,gender.genderName,COUNT(*) AS staffCount,total.staffCount AS totalStaffCount, 100.0*COUNT(*)/total.staffCount AS percentOfStaff
FROM FactStaff fs
JOIN DimSchoolYear yr ON yr.yearID = fs.yearID 
JOIN DimSchool school ON school.schoolID = fs.schoolID 
JOIN DimGender gender ON gender.genderID = fs.genderID 
JOIN vw_SchoolStaffCount total ON total.schoolID = school.schoolID
GROUP BY yr.schoolYear9,school.countyDistrictNumber,school.district,school.schoolID,school.schoolName,gender.genderName,total.staffCount

GO

GRANT SELECT ON vw_SchoolStaffGender
	TO demographics_user;

GO




