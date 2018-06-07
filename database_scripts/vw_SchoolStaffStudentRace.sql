USE demographics

GO

IF OBJECT_ID(N'[dbo].[vw_SchoolStaffStudentRace]','V') IS NOT NULL
	DROP VIEW [dbo].[vw_SchoolStaffStudentRace]
GO

CREATE VIEW vw_SchoolStaffStudentRace AS
SELECT ds.countyDistrictNumber,ds.district,ds.schoolID,ds.schoolName,race.race,stu.studentCount,stu.totalEnrollment,stu.percentOfStudents,
ISNULL(sta.staffCount,0) AS staffCount,ISNULL(sta.totalStaffCount,0) AS totalStaffCount,ISNULL(sta.percentOfStaff,0) AS percentOfStaff,ds.geopoint,x,y
FROM DimSchool ds
LEFT JOIN (SELECT DISTINCT race FROM vw_StudentRaceSnapshot) race ON race.race IS NOT NULL
LEFT JOIN vw_StudentRaceSnapshot stu ON stu.schoolID = ds.schoolID AND stu.race = race.race
LEFT JOIN vw_SchoolStaffRace sta ON sta.schoolID = stu.schoolID AND sta.race = race.race AND sta.schoolYear = stu.schoolYear

GO

GRANT SELECT ON vw_SchoolStaffStudentRace
	TO demographics_user;

GO


