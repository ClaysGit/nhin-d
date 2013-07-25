USE [$(DBName)]

/*----------------------------------------------

	Domains
	
------------------------------------------------*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Domains')
BEGIN
	CREATE TABLE [dbo].[Domains](
		[DomainName] [varchar](255) NOT NULL,
		[AgentName] [varchar] (25) NULL,
		[DomainID] [bigint] IDENTITY(1,1) NOT NULL,
		[CreateDate] [datetime] NOT NULL,
		[UpdateDate] [datetime] NOT NULL,
		[Status] [tinyint] NOT NULL,
	 CONSTRAINT [PK_Domains] PRIMARY KEY CLUSTERED 
	(
		[DomainName] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
	 CONSTRAINT [DomainID] UNIQUE NONCLUSTERED 
	(
		[DomainID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	ALTER TABLE [dbo].[Domains] ADD  CONSTRAINT [DF_Domains_Status]  DEFAULT ((0)) FOR [Status]
END
GO

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Domains' and COLUMN_NAME ='AgentName')
BEGIN
	ALTER TABLE Domains ADD AgentName varchar(25) NULL
END
GO

/*----------------------------------------------

	DnsRecords
	
------------------------------------------------*/
SET ANSI_PADDING OFF
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DnsRecords')
BEGIN
	CREATE TABLE [dbo].[DnsRecords](
		[RecordID] [bigint] IDENTITY(1,1) NOT NULL,
		[DomainName] [varchar](255) NOT NULL,
		[TypeID] [int] NOT NULL,
		[RecordData] [varbinary](max) NULL,
		[CreateDate] [datetime] NOT NULL,
		[UpdateDate] [datetime] NOT NULL,
		[Notes] [varchar](500) NOT NULL,
	 CONSTRAINT [PK_DnsRecords] PRIMARY KEY CLUSTERED 
	(
		[RecordID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IX_DnsRecords_DomainName] ON [dbo].[DnsRecords] 
	(
		[DomainName] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

	ALTER TABLE [dbo].[DnsRecords] ADD  CONSTRAINT [DF_DnsRecords_DomainName]  DEFAULT ('') FOR [DomainName]
	ALTER TABLE [dbo].[DnsRecords] ADD  CONSTRAINT [DF_DnsRecords_TypeID]  DEFAULT ((0)) FOR [TypeID]
	ALTER TABLE [dbo].[DnsRecords] ADD  CONSTRAINT [DF_DnsRecords_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
	ALTER TABLE [dbo].[DnsRecords] ADD  CONSTRAINT [DF_DnsRecords_UpdateDate]  DEFAULT (getdate()) FOR [UpdateDate]
	ALTER TABLE [dbo].[DnsRecords] ADD  CONSTRAINT [DF_DnsRecords_Notes]  DEFAULT ('') FOR [Notes]
END
GO
SET ANSI_PADDING OFF
GO

/*----------------------------------------------

	Certificates
	
------------------------------------------------*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Certificates')
BEGIN
	CREATE TABLE [dbo].[Certificates](
		[Owner] [varchar](400) NOT NULL,
		[Thumbprint] [nvarchar](64) NOT NULL,
		[CertificateID] [bigint] IDENTITY(1,1) NOT NULL,
		[CreateDate] [datetime] NOT NULL,
		[CertificateData] [varbinary](max) NOT NULL,
		[ValidStartDate] [datetime] NOT NULL,
		[ValidEndDate] [datetime] NOT NULL,
		[Status] [tinyint] NOT NULL,
	 CONSTRAINT [PK_Certificates] PRIMARY KEY CLUSTERED 
	(
		[Owner] ASC,
		[Thumbprint] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE UNIQUE NONCLUSTERED INDEX [IX_Certificates_CertificateID] ON [dbo].[Certificates] 
	(
		[CertificateID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

	ALTER TABLE [dbo].[Certificates] ADD  CONSTRAINT [DF_Certificates_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
	ALTER TABLE [dbo].[Certificates] ADD  CONSTRAINT [DF_Certificates_Status]  DEFAULT ((0)) FOR [Status]
END
GO
SET ANSI_PADDING OFF
GO

/*----------------------------------------------

	Anchors
	
------------------------------------------------*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Anchors')
BEGIN
	CREATE TABLE [dbo].[Anchors](
		[Owner] [varchar](400) NOT NULL,
		[Thumbprint] [nvarchar](64) NOT NULL,
		[CertificateID] [bigint] IDENTITY(1,1) NOT NULL,
		[CreateDate] [datetime] NOT NULL,
		[CertificateData] [varbinary](max) NOT NULL,
		[ValidStartDate] [datetime] NOT NULL,
		[ValidEndDate] [datetime] NOT NULL,
		[ForIncoming] [bit] NOT NULL,
		[ForOutgoing] [bit] NOT NULL,
		[Status] [tinyint] NOT NULL,
	 CONSTRAINT [PK_Anchors_1] PRIMARY KEY CLUSTERED 
	(
		[Owner] ASC,
		[Thumbprint] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	ALTER TABLE [dbo].[Anchors] ADD  CONSTRAINT [DF_Anchors_ForIncoming]  DEFAULT ((1)) FOR [ForIncoming]
	ALTER TABLE [dbo].[Anchors] ADD  CONSTRAINT [DF_Anchors_ForOutgoing]  DEFAULT ((1)) FOR [ForOutgoing]
	ALTER TABLE [dbo].[Anchors] ADD  CONSTRAINT [DF_Anchors_Status]  DEFAULT ((0)) FOR [Status]
END
GO
SET ANSI_PADDING OFF
GO

/*----------------------------------------------

	Administrators
	
------------------------------------------------*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Administrators')
BEGIN
	CREATE TABLE [dbo].[Administrators](
		[AdministratorID] [bigint] IDENTITY(1,1) NOT NULL,
		[Username] [varchar](50) NOT NULL,
		[PasswordHash] [varchar](50) NOT NULL,
		[CreateDate] [datetime] NOT NULL,
		[UpdateDate] [datetime] NOT NULL,
		[Status] [tinyint] NOT NULL,
	 CONSTRAINT [PK_Administrators] PRIMARY KEY CLUSTERED 
	(
		[Username] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO

/*----------------------------------------------

	Addresses
	
------------------------------------------------*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Addresses')
BEGIN
	CREATE TABLE [dbo].[Addresses](
		[EmailAddress] [varchar](400) NOT NULL,
		[AddressID] [bigint] IDENTITY(1,1) NOT NULL,
		[DomainID] [bigint] NOT NULL,
		[DisplayName] [varchar](64) NOT NULL,
		[CreateDate] [datetime] NOT NULL,
		[UpdateDate] [datetime] NOT NULL,
		[Type] [nvarchar](64) NULL,
		[Status] [tinyint] NOT NULL,
	 CONSTRAINT [PK_Addresses] PRIMARY KEY CLUSTERED 
	(
		[EmailAddress] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE UNIQUE NONCLUSTERED INDEX [IX_Addresses_AddressID] ON [dbo].[Addresses] 
	(
		[AddressID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

	ALTER TABLE [dbo].[Addresses] ADD  CONSTRAINT [DF_Addresses_Status]  DEFAULT ((0)) FOR [Status]
	ALTER TABLE [dbo].[Addresses]  WITH CHECK ADD  CONSTRAINT [FK_Addresses_DomainID] FOREIGN KEY([DomainID])
	REFERENCES [dbo].[Domains] ([DomainID])
	ALTER TABLE [dbo].[Addresses] CHECK CONSTRAINT [FK_Addresses_DomainID]

END
GO
SET ANSI_PADDING OFF
GO

/*----------------------------------------------

	Properties
	
------------------------------------------------*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Properties')
BEGIN
	CREATE TABLE [dbo].[Properties](
		[PropertyID] [bigint] IDENTITY(1,1) NOT NULL,
		[Name] [nvarchar](255) NOT NULL,
		[Value] [nvarchar](255) NOT NULL,
	 CONSTRAINT [PK_Properties] PRIMARY KEY CLUSTERED 
	(
		[Name] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IX_Properties_ID] ON [dbo].[Properties] 
	(
		[PropertyID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END
GO

/*----------------------------------------------

	Blobs
	
------------------------------------------------*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Blobs')
BEGIN
	CREATE TABLE [dbo].[Blobs](
		[BlobID] [bigint] IDENTITY(1,1) NOT NULL,
		[Name] [varchar](255) NOT NULL,
		[Data] [varbinary](max) NOT NULL,
		[CreateDate] [datetime] NOT NULL,
		[UpdateDate] [datetime] NOT NULL,
	 CONSTRAINT [PK_Blobs] PRIMARY KEY CLUSTERED 
	(
		[Name] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	SET ANSI_PADDING OFF
	CREATE UNIQUE NONCLUSTERED INDEX [IX_Blobs_ID] ON [dbo].[Blobs] 
	(
		[BlobID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END

/*----------------------------------------------

	Bundles
	
------------------------------------------------*/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Bundles')
BEGIN
	CREATE TABLE [dbo].[Bundles](
		[BundleID] [bigint] IDENTITY(1,1) NOT NULL,
		[Owner] [varchar](400) NOT NULL,
		[Url] [varchar](2048) NOT NULL,
		[CreateDate] [datetime] NOT NULL,
		[ForIncoming] [bit] NOT NULL,
		[ForOutgoing] [bit] NOT NULL,
		[Status] [tinyint] NOT NULL,
	 CONSTRAINT [PK_Bundles_1] PRIMARY KEY CLUSTERED 
	(
		[BundleID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]

	CREATE NONCLUSTERED INDEX [IX_Bundles_Owner] ON [dbo].[Bundles] 
	(
		[Owner] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

	ALTER TABLE [dbo].[Bundles] ADD  CONSTRAINT [DF_Bundles_ForIncoming]  DEFAULT ((1)) FOR [ForIncoming]
	ALTER TABLE [dbo].[Bundles] ADD  CONSTRAINT [DF_Bundles_ForOutgoing]  DEFAULT ((1)) FOR [ForOutgoing]
	ALTER TABLE [dbo].[Bundles] ADD  CONSTRAINT [DF_Bundles_Status]  DEFAULT ((0)) FOR [Status]
	ALTER TABLE [dbo].[Bundles] ADD  CONSTRAINT [DF_Bundles_CreateDate]  DEFAULT (getdate()) FOR [CreateDate]
END
GO
SET ANSI_PADDING OFF
GO
