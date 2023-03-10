USE [master]
GO
/****** Object:  Database [jeden]    Script Date: 08.03.2023 12:22:50 ******/
CREATE DATABASE [jeden]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'jeden', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\jeden.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'jeden_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\jeden_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [jeden] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [jeden].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [jeden] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [jeden] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [jeden] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [jeden] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [jeden] SET ARITHABORT OFF 
GO
ALTER DATABASE [jeden] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [jeden] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [jeden] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [jeden] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [jeden] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [jeden] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [jeden] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [jeden] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [jeden] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [jeden] SET  DISABLE_BROKER 
GO
ALTER DATABASE [jeden] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [jeden] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [jeden] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [jeden] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [jeden] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [jeden] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [jeden] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [jeden] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [jeden] SET  MULTI_USER 
GO
ALTER DATABASE [jeden] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [jeden] SET DB_CHAINING OFF 
GO
ALTER DATABASE [jeden] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [jeden] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [jeden] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [jeden] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'jeden', N'ON'
GO
ALTER DATABASE [jeden] SET QUERY_STORE = ON
GO
ALTER DATABASE [jeden] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [jeden]
GO
/****** Object:  Table [dbo].[Pracownicy]    Script Date: 08.03.2023 12:22:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Pracownicy](
	[id_pracownika] [int] IDENTITY(1,1) NOT NULL,
	[id_dzialu] [int] NOT NULL,
	[Imie] [varchar](50) NOT NULL,
	[nazwisko] [varchar](50) NOT NULL,
	[id_przelozonego] [int] NULL,
	[stanowisko] [varchar](50) NOT NULL,
 CONSTRAINT [PK_pracownicy] PRIMARY KEY CLUSTERED 
(
	[id_pracownika] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[Widok]    Script Date: 08.03.2023 12:22:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[Widok]
AS
WITH  k as (
select id_pracownika,imie,nazwisko,stanowisko,id_przelozonego,cast( concat (imie,' ',nazwisko) as varchar) as przelozeni from Pracownicy
union all 
select p.id_pracownika, k.imie,k.nazwisko,k.stanowisko,p.id_przelozonego, cast(concat(k.przelozeni, '<=',p.imie)as varchar)
from k 
inner join Pracownicy p
on k.id_przelozonego = p.id_pracownika
where k.id_przelozonego is not NULL
)
select imie,nazwisko,stanowisko,przelozeni from k where id_przelozonego is NULL
GO
/****** Object:  Table [dbo].[Atrybuty]    Script Date: 08.03.2023 12:22:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Atrybuty](
	[id_atrybutu] [int] NOT NULL,
	[nazwa] [varchar](50) NOT NULL,
	[jednostki] [varchar](50) NULL,
 CONSTRAINT [PK_Atrybuty] PRIMARY KEY CLUSTERED 
(
	[id_atrybutu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Dzial]    Script Date: 08.03.2023 12:22:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Dzial](
	[id_dzialu] [int] IDENTITY(1,1) NOT NULL,
	[nazwa_dzialu] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Dzial] PRIMARY KEY CLUSTERED 
(
	[id_dzialu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Przypadanie]    Script Date: 08.03.2023 12:22:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Przypadanie](
	[id_przypadania] [int] NOT NULL,
	[id_sprzet] [int] NOT NULL,
	[id_dzial] [int] NOT NULL,
 CONSTRAINT [PK_przypadanie] PRIMARY KEY CLUSTERED 
(
	[id_przypadania] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sprzet]    Script Date: 08.03.2023 12:22:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sprzet](
	[id_sprzetu] [int] IDENTITY(1,1) NOT NULL,
	[nazwa_sprzetu] [varchar](50) NOT NULL,
	[model] [varchar](50) NOT NULL,
	[atrybuty] [varchar](50) NULL,
	[dzialy] [varchar](50) NULL,
 CONSTRAINT [PK_sprzet] PRIMARY KEY CLUSTERED 
(
	[id_sprzetu] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SprzetAtrybut]    Script Date: 08.03.2023 12:22:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SprzetAtrybut](
	[id] [int] NOT NULL,
	[id_sprzetu] [int] NOT NULL,
	[id_atrybutu] [int] NOT NULL,
 CONSTRAINT [PK_sprzet-atrybut] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Zlecenia]    Script Date: 08.03.2023 12:22:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Zlecenia](
	[id_zlecenia] [int] IDENTITY(1,1) NOT NULL,
	[id_pracownika] [int] NOT NULL,
	[id_sprzetu] [int] NOT NULL,
	[ilosc] [int] NOT NULL,
	[cena] [float] NOT NULL,
 CONSTRAINT [PK_zlecenia] PRIMARY KEY CLUSTERED 
(
	[id_zlecenia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Pracownicy]  WITH CHECK ADD  CONSTRAINT [FK_pracownicy_Dzial] FOREIGN KEY([id_dzialu])
REFERENCES [dbo].[Dzial] ([id_dzialu])
GO
ALTER TABLE [dbo].[Pracownicy] CHECK CONSTRAINT [FK_pracownicy_Dzial]
GO
ALTER TABLE [dbo].[Pracownicy]  WITH CHECK ADD  CONSTRAINT [FK_pracownicy_pracownicy] FOREIGN KEY([id_przelozonego])
REFERENCES [dbo].[Pracownicy] ([id_pracownika])
GO
ALTER TABLE [dbo].[Pracownicy] CHECK CONSTRAINT [FK_pracownicy_pracownicy]
GO
ALTER TABLE [dbo].[Przypadanie]  WITH CHECK ADD  CONSTRAINT [FK_przypadanie_Dzial] FOREIGN KEY([id_dzial])
REFERENCES [dbo].[Dzial] ([id_dzialu])
GO
ALTER TABLE [dbo].[Przypadanie] CHECK CONSTRAINT [FK_przypadanie_Dzial]
GO
ALTER TABLE [dbo].[Przypadanie]  WITH CHECK ADD  CONSTRAINT [FK_przypadanie_sprzet] FOREIGN KEY([id_sprzet])
REFERENCES [dbo].[Sprzet] ([id_sprzetu])
GO
ALTER TABLE [dbo].[Przypadanie] CHECK CONSTRAINT [FK_przypadanie_sprzet]
GO
ALTER TABLE [dbo].[SprzetAtrybut]  WITH CHECK ADD  CONSTRAINT [FK_sprzet-atrybut_Atrybuty] FOREIGN KEY([id_atrybutu])
REFERENCES [dbo].[Atrybuty] ([id_atrybutu])
GO
ALTER TABLE [dbo].[SprzetAtrybut] CHECK CONSTRAINT [FK_sprzet-atrybut_Atrybuty]
GO
ALTER TABLE [dbo].[SprzetAtrybut]  WITH CHECK ADD  CONSTRAINT [FK_sprzet-atrybut_sprzet] FOREIGN KEY([id_sprzetu])
REFERENCES [dbo].[Sprzet] ([id_sprzetu])
GO
ALTER TABLE [dbo].[SprzetAtrybut] CHECK CONSTRAINT [FK_sprzet-atrybut_sprzet]
GO
ALTER TABLE [dbo].[Zlecenia]  WITH CHECK ADD  CONSTRAINT [FK_zlecenia_sprzet] FOREIGN KEY([id_sprzetu])
REFERENCES [dbo].[Sprzet] ([id_sprzetu])
GO
ALTER TABLE [dbo].[Zlecenia] CHECK CONSTRAINT [FK_zlecenia_sprzet]
GO
ALTER TABLE [dbo].[Zlecenia]  WITH CHECK ADD  CONSTRAINT [FK_zlecenia_zlecenia] FOREIGN KEY([id_pracownika])
REFERENCES [dbo].[Pracownicy] ([id_pracownika])
GO
ALTER TABLE [dbo].[Zlecenia] CHECK CONSTRAINT [FK_zlecenia_zlecenia]
GO
USE [master]
GO
ALTER DATABASE [jeden] SET  READ_WRITE 
GO
