USE demographics

IF OBJECT_ID(N'[dbo].[DimGender]','U') IS NOT NULL
	DROP TABLE [dbo].[DimGender]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[DimGender](
	[genderID] [INT] IDENTITY(1,1),
	[genderCode] [CHAR](1) NOT NULL,	
	[genderName] [VARCHAR](20) NOT NULL,
	CONSTRAINT PK_DimGender_genderID PRIMARY KEY CLUSTERED (genderID),
	CONSTRAINT AK_genderCode UNIQUE(genderCode) 
) ON [PRIMARY]

GO

GRANT SELECT, INSERT ON DimGender
	TO demographics_user;

GO