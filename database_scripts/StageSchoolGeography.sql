USE demographics

IF OBJECT_ID(N'[dbo].[StageSchoolGeography]','U') IS NOT NULL
	DROP TABLE [dbo].[StageSchoolGeography]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[StageSchoolGeography](
	[schoolGeoID] [INT] IDENTITY(1,1),
	[loadDatetime] [DATETIME] NOT NULL,
	[x] [DECIMAL](18,15) NULL,
	[y] [DECIMAL](18,15) NULL,
	[objectID] [INT] NULL,
	[feature_ID] [INT] NULL,
	[esite] [INT] NULL,
	[code] [INT] NULL,
	[name] [VARCHAR](60) NULL,
	[abb_name] [VARCHAR](35) NULL,
	[address] [VARCHAR](40) NULL,
	[zipcode] [CHAR](5) NULL,
	[long_cen] [DECIMAL](18,15) NULL,
	[lat_cen] [DECIMAL](18,15) NULL,
	[sch_class] [INT] NULL,
	[district] [VARCHAR](20) NULL,
	[pin] [BIGINT] NULL,
	[major] [INT] NULL,
	[minor] [INT] NULL,
	[featuredes] [VARCHAR](30) NULL,
	[ospi_code] [INT] NULL,
	CONSTRAINT PK_StageSchoolGeography_schoolGeoID PRIMARY KEY CLUSTERED (schoolGeoID)  
) ON [PRIMARY]

GO

GRANT SELECT, INSERT ON StageSchoolGeography
	TO demographics_user;

GO