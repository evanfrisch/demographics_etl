USE demographics

IF OBJECT_ID(N'[dbo].[FactStaff]','U') IS NOT NULL
	DROP TABLE [dbo].[FactStaff]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[FactStaff](
	[staffID] [INT] IDENTITY(1,1),
	[yearID] [INT] NOT NULL,	
	[schoolID] [INT] NOT NULL,
	[genderID] [INT] NOT NULL,
	[raceID] [INT] NOT NULL,
	[hispanicID] [INT] NOT NULL,
	[cert] [CHAR](7) NOT NULL,
	CONSTRAINT PK_FactStaff_staffID PRIMARY KEY CLUSTERED (staffID),
	CONSTRAINT FK_FactStaff_yearID FOREIGN KEY (yearID)  
		REFERENCES DimSchoolYear (yearID)     
		ON DELETE CASCADE    
		ON UPDATE CASCADE,
	CONSTRAINT FK_FactStaff_schoolID FOREIGN KEY (schoolID)  
		REFERENCES DimSchool (schoolID)     
		ON DELETE CASCADE    
		ON UPDATE CASCADE,
	CONSTRAINT FK_FactStaff_genderID FOREIGN KEY (genderID)  
		REFERENCES DimGender (genderID)     
		ON DELETE CASCADE    
		ON UPDATE CASCADE,
	CONSTRAINT FK_FactStaff_raceID FOREIGN KEY (raceID)  
		REFERENCES DimRace (raceID)     
		ON DELETE CASCADE    
		ON UPDATE CASCADE,
	CONSTRAINT FK_FactStaff_hispanicID FOREIGN KEY (hispanicID)  
		REFERENCES DimHispanic (hispanicID)     
		ON DELETE CASCADE    
		ON UPDATE CASCADE
)


GO

GRANT SELECT, INSERT ON FactStaff
	TO demographics_user;

GO


/*
SELECT *
FROM DimSchoolYear

SELECT *
FROM DimGender

SELECT *
FROM DimRace

SELECT *
FROM DimSchool

*/