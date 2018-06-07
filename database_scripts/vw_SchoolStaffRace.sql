USE demographics

GO

IF OBJECT_ID(N'[dbo].[vw_SchoolStaffRace]','V') IS NOT NULL
	DROP VIEW [dbo].[vw_SchoolStaffRace]
GO

CREATE VIEW vw_SchoolStaffRace AS
SELECT yr.schoolYear9 AS schoolYear,school.countyDistrictNumber,school.district,school.schoolID,school.schoolName,
	CASE WHEN race.twoOrMoreRaces = 1 THEN 'Two or More Races' 
		 WHEN race.raceCode = 'A' THEN 'Asian'
		 WHEN race.raceCode = 'B' THEN 'Black/African American'
		 WHEN race.raceCode = 'I' THEN 'Indian/Native American'
		 WHEN race.raceCode = 'P' THEN 'Pacific Islander'
		 WHEN race.raceCode = 'W' THEN 'White/Caucasian' END AS race,
	COUNT(*) AS staffCount,
	total.staffCount AS totalStaffCount, 100.0*COUNT(*)/total.staffCount AS percentOfStaff
FROM FactStaff fs
JOIN DimSchoolYear yr ON yr.yearID = fs.yearID 
JOIN DimSchool school ON school.schoolID = fs.schoolID 
JOIN DimRace race ON race.raceID = fs.raceID 
JOIN vw_SchoolStaffCount total ON total.schoolID = school.schoolID AND total.schoolYear = yr.schoolYear9
GROUP BY yr.schoolYear9,school.countyDistrictNumber,school.district,school.schoolID,school.schoolName,
CASE WHEN race.twoOrMoreRaces = 1 THEN 'Two or More Races' 
		 WHEN race.raceCode = 'A' THEN 'Asian'
		 WHEN race.raceCode = 'B' THEN 'Black/African American'
		 WHEN race.raceCode = 'I' THEN 'Indian/Native American'
		 WHEN race.raceCode = 'P' THEN 'Pacific Islander'
		 WHEN race.raceCode = 'W' THEN 'White/Caucasian' END,
total.staffCount

GO

GRANT SELECT ON vw_SchoolStaffRace
	TO demographics_user;

GO




