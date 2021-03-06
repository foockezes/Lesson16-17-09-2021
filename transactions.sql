USE [master]
GO
/****** Object:  Database [Person]    Script Date: 17.09.2021 21:46:28 ******/
CREATE DATABASE [Person]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Person', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Person.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Person_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SQLEXPRESS\MSSQL\DATA\Person_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Person] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Person].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Person] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Person] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Person] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Person] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Person] SET ARITHABORT OFF 
GO
ALTER DATABASE [Person] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Person] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Person] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Person] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Person] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Person] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Person] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Person] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Person] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Person] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Person] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Person] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Person] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Person] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Person] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Person] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Person] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Person] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Person] SET  MULTI_USER 
GO
ALTER DATABASE [Person] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Person] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Person] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Person] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Person] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Person] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [Person] SET QUERY_STORE = OFF
GO
USE [Person]
GO
/****** Object:  Table [dbo].[Account]    Script Date: 17.09.2021 21:46:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Account](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Account] [nvarchar](5) NOT NULL,
	[Is_Active] [int] NOT NULL,
	[Created_At] [datetime] NOT NULL,
	[Updated_At] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Transactions]    Script Date: 17.09.2021 21:46:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transactions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Account_Id] [int] NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[Created_At] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Account] ADD  DEFAULT ((1)) FOR [Is_Active]
GO
ALTER TABLE [dbo].[Transactions]  WITH CHECK ADD  CONSTRAINT [FK_Transactions_Account] FOREIGN KEY([Account_Id])
REFERENCES [dbo].[Account] ([Id])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Transactions] CHECK CONSTRAINT [FK_Transactions_Account]
GO
USE [master]
GO
ALTER DATABASE [Person] SET  READ_WRITE 
GO
