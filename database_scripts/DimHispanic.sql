USE demographics

IF OBJECT_ID(N'[dbo].[DimHispanic]','U') IS NOT NULL
	DROP TABLE [dbo].[DimHispanic]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[DimHispanic](
	[hispanicID] [INT] IDENTITY(1,1),
	[isHispanic] [BIT] NOT NULL,	
	[ethnicity] [VARCHAR](20) NOT NULL,
	CONSTRAINT PK_DimHispanic_HispanicID PRIMARY KEY CLUSTERED (hispanicID),
	CONSTRAINT AK_HispanicCode UNIQUE(isHispanic) 
) ON [PRIMARY]

GO

GRANT SELECT, INSERT ON DimHispanic
	TO demographics_user;

GO