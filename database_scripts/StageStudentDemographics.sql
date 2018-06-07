USE demographics

IF OBJECT_ID(N'[dbo].[StageStudentDemographics]','U') IS NOT NULL
	DROP TABLE [dbo].[StageStudentDemographics]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[StageStudentDemographics](
	[studentDemoID] [INT] IDENTITY(1,1),
	[loadDatetime] [DATETIME] NULL,
	[schoolYear] [CHAR](7) NULL,
	[esd] [VARCHAR](50) NULL,
	[countyNumber] [INT] NULL,
	[county] [VARCHAR](30) NULL,
	[countyDistrictNumber] [INT] NULL,	
	[district] [VARCHAR](50) NULL,
	[buildingNumber] [INT] NULL,
	[school] [VARCHAR](50) NULL,
	[schoolTypeCode] [CHAR](1) NULL,
	[gradeSpan] [VARCHAR](10) NULL,
	[totalEnrollment] [INT] NULL,
	[numberAmericanIndianorAlaskanNative] [INT] NULL,
	[percentAmericanIndianorAlaskanNative] [DECIMAL](5,2) NULL,
	[numberAsian] [INT] NULL,
	[percentAsian] [DECIMAL](5,2) NULL,
	[numberPacificIslander] [INT] NULL,
	[percentPacificIslander] [DECIMAL](5,2) NULL,
	[numberAsianPacificIslander] [INT] NULL,
	[percentAsianPacificIslander] [DECIMAL](5,2) NULL,
	[numberBlack] [INT] NULL,
	[percentBlack] [DECIMAL](5,2) NULL,
	[numberHispanic] [INT] NULL,
	[percentHispanic] [DECIMAL](5,2) NULL,
	[numberWhite] [INT] NULL,
	[percentWhite] [DECIMAL](5,2) NULL,
	[numberTwoOrMoreRaces] [INT] NULL,
	[percentTwoOrMoreRaces] [DECIMAL](5,2) NULL,
	[numberMales] [INT] NULL,
	[percentMales] [DECIMAL](5,2) NULL,
	[numberFemales] [INT] NULL,
	[percentFemales] [DECIMAL](5,2) NULL,
	[numberMigrant] [INT] NULL,
	[percentMigrant] [DECIMAL](5,2) NULL,
	[numberTransitionalBilingual] [INT] NULL,
	[percentTransitionalBilingual] [DECIMAL](5,2) NULL,
	[numberSpecialEducation] [INT] NULL,
	[percentSpecialEducation] [DECIMAL](5,2) NULL,
	[numberFreeorReducedPricedMeals] [INT] NULL,
	[percentFreeorReducedPricedMeals] [DECIMAL](5,2) NULL,
	[numberSection504] [INT] NULL,
	[percentSection504] [DECIMAL](5,2) NULL,
	[numberFosterCare] [INT] NULL,
	[percentFosterCare] [DECIMAL](5,2) NULL,
	[studentsPerClassroomTeacher] [INT] NULL,
	[avgYearsEducationalExperience] [DECIMAL](3,1) NULL,
	[numberTeachersWithAtLeastMasterDegree] [INT] NULL,
	[percentTeachersWithAtLeastMasterDegree] [DECIMAL](5,2) NULL
	CONSTRAINT PK_StageStudentDemographics_studentDemoID PRIMARY KEY CLUSTERED (studentDemoID)  
) ON [PRIMARY]

GO

GRANT SELECT, INSERT ON StageStudentDemographics
	TO demographics_user;

GO