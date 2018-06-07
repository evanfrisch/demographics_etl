USE demographics

/*
--The following statements can be used to empty tables before loading, if desired.
TRUNCATE TABLE StageStaffDemographics

TRUNCATE TABLE StageStudentDemographics

TRUNCATE TABLE StageSchoolGeography

TRUNCATE TABLE FactStaff

DELETE FROM DimSchoolYear

DELETE FROM DimSchool
ELETE FROM DimRace

DELETE FROM DimGender
*/

SELECT *
FROM DimSchoolYear

SELECT *
FROM DimSchool

SELECT *
FROM DimRace

SELECT *
FROM DimGender


SELECT *
FROM StageStudentDemographics

SELECT *
FROM StageStaffDemographics

SELECT *
FROM StageSchoolGeography

SELECT *
FROM FactStaff
