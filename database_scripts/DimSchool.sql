USE demographics

IF OBJECT_ID(N'[dbo].[DimSchool]','U') IS NOT NULL
	DROP TABLE [dbo].[DimSchool]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[DimSchool](
	[schoolID] [INT] IDENTITY(1,1),
	[buildingNumber] [INT] NOT NULL,
	[countyDistrictNumber] [INT] NOT NULL,	
	[district] [VARCHAR](50) NOT NULL,
	[schoolName] [VARCHAR](50) NULL,
	[schoolTypeCode] [CHAR](1) NULL,
	[gradeSpan] [VARCHAR](10) NULL,
	[schoolAddress] [VARCHAR](40) NULL,
	[zipcode] [CHAR](5) NULL,
	[x] [DECIMAL](18,15) NULL,
	[y] [DECIMAL](18,15) NULL,
	[geopoint] [GEOGRAPHY] NULL
	CONSTRAINT PK_DimSchool_schoolID PRIMARY KEY CLUSTERED (schoolID),
	CONSTRAINT AK_buildingNumber UNIQUE(buildingNumber) 
) ON [PRIMARY]

GO

GRANT SELECT, INSERT ON DimSchool
	TO demographics_user;

GO