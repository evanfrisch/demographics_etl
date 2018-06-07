USE demographics

IF OBJECT_ID(N'[dbo].[DimRace]','U') IS NOT NULL
	DROP TABLE [dbo].[DimRace]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[DimRace](
	[raceID] [INT] IDENTITY(1,1),
	[raceCode] [CHAR](5) NOT NULL,	
	[twoOrMoreRaces] [bit] NOT NULL,
	CONSTRAINT PK_DimRace_genderID PRIMARY KEY CLUSTERED (raceID),
	CONSTRAINT AK_raceCode UNIQUE(raceCode) 
) ON [PRIMARY]

GO

GRANT SELECT, INSERT ON DimRace
	TO demographics_user;

GO
