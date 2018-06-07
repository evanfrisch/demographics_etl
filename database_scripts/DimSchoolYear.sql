USE demographics

IF OBJECT_ID(N'[dbo].[DimSchoolYear]','U') IS NOT NULL
	DROP TABLE [dbo].[DimSchoolYear]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[DimSchoolYear](
	[yearID] [INT] IDENTITY(1,1),
	[schoolYear7] [CHAR](7) NOT NULL,
	[schoolYear9] [CHAR](9) NOT NULL,
	[startYear] [INT] NOT NULL,	
	[endYear] [INT] NOT NULL,
	CONSTRAINT PK_DimSchoolYear_yearID PRIMARY KEY CLUSTERED (yearID),
	CONSTRAINT AK_schoolYear7 UNIQUE(schoolYear7),
	CONSTRAINT AK_schoolYear9 UNIQUE(schoolYear9),
	CONSTRAINT AK_startYear UNIQUE(startYear),
	CONSTRAINT AK_endYear UNIQUE(endYear)
) ON [PRIMARY]

GO

GRANT SELECT, INSERT ON DimSchoolYear
	TO demographics_user;

GO
