USE [AUT.DAL.Model.AUTContext]
GO
/****** Object:  StoredProcedure [dbo].[triggerGenerator]    Script Date: 2020-04-03 9:04:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER     PROC [dbo].[triggerGenerator] @dbName NVARCHAR(MAX)
AS
BEGIN
	DECLARE @tableName NVARCHAR(MAX)

	DECLARE db_cursor CURSOR FOR
		SELECT TABLE_NAME
		FROM INFORMATION_SCHEMA.TABLES
		WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_CATALOG=@dbName

	OPEN db_cursor
		FETCH NEXT FROM db_cursor
		INTO @tableName
		WHILE @@FETCH_STATUS=0
		BEGIN
			EXECUTE (
					'CREATE OR ALTER trigger [dbo].[Insert'+@tableName+'] on [dbo].['+@tableName+']
						FOR INSERT
						AS
						BEGIN
							INSERT into dbo.ActivityLog values (GETDATE(),''Insert'','''+@tableName+''',''something'')
						END'
					)

			EXECUTE (
					'CREATE OR ALTER trigger [dbo].[Update'+@tableName+'] on [dbo].['+@tableName+']
						FOR UPDATE
						AS
						BEGIN
							INSERT into dbo.ActivityLog values (GETDATE(),''Update'','''+@tableName+''',''something'')
						END'
					)

			EXECUTE (
					'CREATE OR ALTER trigger [dbo].[Delete'+@tableName+'] on [dbo].['+@tableName+']
						FOR DELETE
						AS
						BEGIN
							INSERT into dbo.ActivityLog values (GETDATE(),''Delete'','''+@tableName+''',''something'')
						END'
					)

			FETCH NEXT FROM db_cursor
			INTO @tableName
		END
	CLOSE db_cursor

DEALLOCATE db_cursor

END

