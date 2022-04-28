<!--Category:SQL,Powershell--> 
 <p align="right">
  <a href="https://www.powershellgallery.com/packages/ProductivityTools.SQLServerColumnDescription/"><img src="Images/Header/Powershell_border_40px.png" /></a>
    <a href="http://productivitytools.tech/sql-server-column-description/"><img src="Images/Header/ProductivityTools_green_40px_2.png" /><a> 
    <a href="https://github.com/pwujczyk/ProductivityTools.SQLServerColumnDescription"><img src="Images/Header/Github_border_40px.png" /></a>
</p>
<p align="center">
    <a href="http://http://productivitytools.tech/">
        <img src="Images/Header/LogoTitle_green_500px.png" />
    </a>
</p>


# SQL Server Column Description

Module allows to export column description from extented properties in SQL Server.

<!--more-->


## Creating the description in the database
To add column description we can use function

```
  EXEC sys.sp_addextendedproperty
  @name=N'MS_Description' --name of property
 ,@value=N'Age should be between 12 and 100 Descp' --descption text
 ,@level0type=N'SCHEMA'
 ,@level0name=N'jl' --Schema name
 ,@level1type=N'TABLE'
 ,@level1name=N'JournalItemNotes' --Table Name
 ,@level2type=N'COLUMN'
 ,@level2name=N'NotesType'   -- Column Name
```

If we would like to use it in the script we can use the 


```
IF OBJECT_ID ('dbo.usp_addorupdatedescription', 'P') IS NOT NULL
    DROP PROCEDURE dbo.usp_addorupdatedescription;
GO

CREATE PROCEDURE usp_addorupdatedescription
    @table nvarchar(128),  -- table name
    @column nvarchar(128), -- column name, NULL if description for table
    @descr sql_variant     -- description text
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @c nvarchar(128) = NULL;

    IF @column IS NOT NULL
        SET @c = N'COLUMN';

    BEGIN TRY
        EXECUTE sp_updateextendedproperty  N'MS_Description', @descr, N'SCHEMA', N'dbo', N'TABLE', @table, @c, @column;
    END TRY
    BEGIN CATCH
        EXECUTE sp_addextendedproperty N'MS_Description', @descr, N'SCHEMA', N'dbo', N'TABLE', @table, @c, @column;
    END CATCH;
END
GO
```

## Powershell module

Module gets the description from the columns.
```powershell
Get-ColumnsDescription -Verbose -ServerInstance ".\SQL2019" -Database PTMeetings
```
<!--og-image-->
![description](Images/Description.png)

If we use ```-outMD``` switch it will generate MD file

```
Get-ColumnsDescription -Verbose -ServerInstance ".\SQL2019" -Database PTMeetings -OutMd
```

Columns description:
Table name|Column name|Description
|----------|:-------------:|------:|
dbo.VersionInfo|AppliedOn|
dbo.VersionInfo|Description|
dbo.VersionInfo|Version|
jl.JournalItem|AfterNotes_old|
jl.JournalItem|BeforeNotes_old|
jl.JournalItem|Date|
jl.JournalItem|Deleted|
jl.JournalItem|DuringNotes_old|
jl.JournalItem|JournalItemId|
jl.JournalItem|Subject|
jl.JournalItem|TreeId|
mt.Tree|Deleted|
mt.Tree|Name|
mt.Tree|ParentId|
mt.Tree|TreeId|
jl.JournalItemNotes|JournalItemId|
jl.JournalItemNotes|JournalItemNotesId|
jl.JournalItemNotes|Notes|
jl.JournalItemNotes|NotesType|Technical type of item notes, it could be empty or Slate
jl.JournalItemNotes|Type|


