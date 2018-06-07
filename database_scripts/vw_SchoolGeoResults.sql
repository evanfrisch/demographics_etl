USE demographics

GO

IF OBJECT_ID(N'[dbo].[vw_SchoolGeoResults]','V') IS NOT NULL
	DROP VIEW [dbo].[vw_SchoolGeoResults]
GO

CREATE VIEW vw_SchoolGeoResults AS
SELECT district,schoolName,race AS raceEthnicity,studentCount,totalEnrollment,percentOfStudents,staffCount,totalStaffCount,
CAST(percentOfStaff AS DECIMAL(5,2)) AS percentOfStaff,CAST(percentOfStudents-percentOfStaff AS DECIMAL(5,2)) AS percentGap,x,y 
FROM vw_SchoolStaffStudentRace 
WHERE x IS NOT NULL AND y IS NOT NULL
UNION 
SELECT district,schoolName,ethnicity AS raceEthnicity,studentCount,totalEnrollment,percentOfStudents,staffCount,totalStaffCount,
CAST(percentOfStaff AS DECIMAL(5,2)) AS percentOfStaff,CAST(percentOfStudents-percentOfStaff AS DECIMAL(5,2)) AS percentGap,x,y 
FROM vw_SchoolStaffStudentHispanic
WHERE x IS NOT NULL AND y IS NOT NULL

GO

GRANT SELECT ON vw_SchoolGeoResults
	TO demographics_user;

GO


