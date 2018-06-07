USE demographics

GO

IF OBJECT_ID(N'[dbo].[vw_SchoolStaffStudentGender]','V') IS NOT NULL
	DROP VIEW [dbo].[vw_SchoolStaffStudentGender]
GO

CREATE VIEW vw_SchoolStaffStudentGender AS
SELECT ds.countyDistrictNumber,ds.district,ds.schoolID,ds.schoolName,gender.genderName,stu.studentCount,stu.totalEnrollment,stu.percentOfStudents,
ISNULL(sta.staffCount,0) AS staffCount,ISNULL(sta.totalStaffCount,0) AS totalStaffCount,ISNULL(sta.percentOfStaff,0) AS percentOfStaff,ds.geopoint,x,y
FROM DimSchool ds
LEFT JOIN DimGender gender ON gender.genderCode IN ('F','M')
LEFT JOIN vw_StudentGenderSnapshot stu ON stu.schoolID = ds.schoolID AND stu.gender = gender.genderName
LEFT JOIN vw_SchoolStaffGender sta ON sta.schoolID = stu.schoolID AND sta.genderName = gender.genderName AND sta.schoolYear = stu.schoolYear

GO

GRANT SELECT ON vw_SchoolStaffStudentGender
	TO demographics_user;

GO


