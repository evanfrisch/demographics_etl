USE demographics

GO

IF OBJECT_ID(N'[dbo].[vw_SchoolStaffStudentHispanic]','V') IS NOT NULL
	DROP VIEW [dbo].[vw_SchoolStaffStudentHispanic]
GO

CREATE VIEW vw_SchoolStaffStudentHispanic AS
SELECT ds.countyDistrictNumber,ds.district,ds.schoolID,ds.schoolName,hispanic.ethnicity,stu.studentCount,stu.totalEnrollment,stu.percentOfStudents,
ISNULL(sta.staffCount,0) AS staffCount,ISNULL(sta.totalStaffCount,0) AS totalStaffCount,ISNULL(sta.percentOfStaff,0) AS percentOfStaff,ds.geopoint,x,y
FROM DimSchool ds
LEFT JOIN DimHispanic hispanic ON hispanic.isHispanic IN (0,1)
LEFT JOIN vw_StudentHispanicSnapshot stu ON stu.schoolID = ds.schoolID AND stu.ethnicity = hispanic.ethnicity
LEFT JOIN vw_SchoolStaffHispanic sta ON sta.schoolID = stu.schoolID AND sta.isHispanic = hispanic.isHispanic AND sta.schoolYear = stu.schoolYear

GO

GRANT SELECT ON vw_SchoolStaffStudentHispanic
	TO demographics_user;

GO


