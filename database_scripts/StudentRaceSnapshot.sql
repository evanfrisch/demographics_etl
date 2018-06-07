USE demographics

IF OBJECT_ID(N'[dbo].[StudentRaceSnapshot]','U') IS NOT NULL
	DROP TABLE [dbo].[StudentRaceSnapshot]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[StudentRaceSnapshot](
	[studentRaceSnapshotID] [INT] IDENTITY(1,1),
	[yearID] [INT] NOT NULL,
	[schoolYear] [CHAR](9) NOT NULL,
	[countyDistrictNumber] [INT] NOT NULL,	
	[district] [VARCHAR](50) NOT NULL,
	[schoolID] [INT] NOT NULL,
	[schoolName] [VARCHAR](50) NOT NULL,
	[race] [VARCHAR](25) NOT NULL,
	[studentCount] [INT] NOT NULL,
	[totalEnrollment] [INT] NULL,
	[percentOfStudents] [DECIMAL](5,2) NOT NULL,
	[geopoint] [GEOGRAPHY] NULL,
	CONSTRAINT PK_StudentRaceSnapshot_studentRaceSnapshotID PRIMARY KEY CLUSTERED (studentRaceSnapshotID),
	CONSTRAINT FK_StudentRaceSnapshot_yearID FOREIGN KEY (yearID)
		REFERENCES DimSchoolYear (yearID)     
		ON DELETE CASCADE    
		ON UPDATE CASCADE,
	CONSTRAINT FK_StudentRaceSnapshot_schoolID FOREIGN KEY (schoolID)  
		REFERENCES DimSchool (schoolID)     
		ON DELETE CASCADE    
		ON UPDATE CASCADE
) ON [PRIMARY]

GO

GRANT SELECT, INSERT, DELETE ON StudentRaceSnapshot
	TO demographics_user;

GO