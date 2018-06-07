USE demographics

IF OBJECT_ID(N'[dbo].[StageStaffDemographics]','U') IS NOT NULL
	DROP TABLE [dbo].[StageStaffDemographics]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[StageStaffDemographics](
	[staffDemoID] [INT] IDENTITY(1,1),
	[loadDatetime] [DATETIME] NULL,
	[schoolYear] [CHAR](9) NULL,
	[codist] [INT] NULL,	
	[cert] [CHAR](7) NULL,
	[sex] [CHAR](1) NULL,
	[hispanic] [CHAR](1) NULL,
	[race] [VARCHAR](5) NULL,
	[hdeg] [VARCHAR](10) NULL,
	[certFTE] [DECIMAL](4,3) NULL,
	[certflag] [CHAR](1) NULL,
	[recno] [INT] NULL,
	[prog] [INT] NULL,
	[act] [INT] NULL,
	[bldgn] [INT] NULL,
	[asspct] [DECIMAL](6,3) NULL,
	[assFTE] [DECIMAL](4,3) NULL,
	[yr] [INT] NULL
	CONSTRAINT PK_StageStaffDemographics_staffDemoID PRIMARY KEY CLUSTERED (staffDemoID)  
) ON [PRIMARY]

GO

GRANT SELECT, INSERT ON StageStaffDemographics
	TO demographics_user;

GO
