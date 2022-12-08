use Oishi;
GO

DROP INDEX idx_menu_dishtype ON MENU;
DROP INDEX idx_dishtypes_typename ON DISHTYPES;

CREATE INDEX idx_menu_dishtype ON MENU(DishType);
CREATE INDEX idx_dishtypes_typename ON DISHTYPES(TypeName);
CREATE INDEX idx_restables_ordinalnumber ON RESTABLES(OrdinalNumber);
CREATE INDEX idx_menu_dishname ON MENU(DishName);
CREATE INDEX idx_menu_tpnmprwt ON MENU(DishType) INCLUDE (DishName, DishPrice, DishWeight, DishDescription);

GO

with igs as (
    select *
    from sys.dm_db_missing_index_group_stats
),
igd as (
    select *,
        isnull(equality_columns, '') + ',' + isnull(inequality_columns, '') as ix_col
    from sys.dm_db_missing_index_details
)
select --top(10)
    'use [' + db_name(igd.database_id) + '];
create index [' + 'ix_' + replace(convert(varchar(10), getdate(), 120), '-', '') + '_' + convert(varchar, igs.group_handle) + '] on ' + igd.[statement] + '(' + case
        when left(ix_col, 1) = ',' then stuff(ix_col, 1, 1, '')
        when right(ix_col, 1) = ',' then reverse(stuff(reverse(ix_col), 1, 1, ''))
        else ix_col
    end + ') ' + isnull('include(' + igd.included_columns + ')', '') + ' with(online=on, maxdop=0)
go
' command,
    igs.user_seeks,
    igs.user_scans,
    igs.avg_total_user_cost
from igs
    join sys.dm_db_missing_index_groups link on link.index_group_handle = igs.group_handle
    join igd on link.index_handle = igd.index_handle
where igd.database_id = db_id()
order by igs.avg_total_user_cost * igs.user_seeks desc;
GO


SELECT   OBJECT_NAME(S.[OBJECT_ID]) AS [OBJECT NAME], 
             I.[NAME] AS [INDEX NAME], type_desc,
             coalesce(last_user_seek,last_user_scan,last_user_lookup,last_system_scan,last_system_seek,last_system_lookup) as LastUsed,
             USER_SEEKS, 
             USER_SCANS, 
             USER_LOOKUPS, 
             USER_UPDATES ,
             last_user_seek,last_user_scan,last_user_lookup,last_system_scan,last_system_seek,last_system_lookup,
             'drop index ['+I.[NAME]+'] on ['+OBJECT_NAME(S.[OBJECT_ID])+'];' as DropStatement
    FROM     SYS.DM_DB_INDEX_USAGE_STATS AS S 
             INNER JOIN SYS.INDEXES AS I 
               ON I.[OBJECT_ID] = S.[OBJECT_ID] 
                  AND I.INDEX_ID = S.INDEX_ID 
    WHERE    OBJECTPROPERTY(S.[OBJECT_ID],'IsUserTable') = 1 
    order by type_desc,coalesce(last_user_seek,last_user_scan,last_user_lookup,last_system_scan,last_system_seek,last_system_lookup) desc
	GO


SELECT
	a3.name AS [schemaname],
	a2.name AS [tablename],
	a1.rows as row_count,
	(a1.reserved + ISNULL(a4.reserved,0))* 8 AS [reserved], 
	a1.data * 8 AS [data],
	(CASE WHEN (a1.used + ISNULL(a4.used,0)) > a1.data THEN (a1.used + ISNULL(a4.used,0)) - a1.data ELSE 0 END) * 8 AS [index_size],
	(CASE WHEN (a1.reserved + ISNULL(a4.reserved,0)) > a1.used THEN (a1.reserved + ISNULL(a4.reserved,0)) - a1.used ELSE 0 END) * 8 AS [unused]
FROM
	(SELECT 
		ps.object_id,
		SUM (
			CASE
				WHEN (ps.index_id < 2) THEN row_count
				ELSE 0
			END
			) AS [rows],
		SUM (ps.reserved_page_count) AS reserved,
		SUM (
			CASE
				WHEN (ps.index_id < 2) THEN (ps.in_row_data_page_count + ps.lob_used_page_count + ps.row_overflow_used_page_count)
				ELSE (ps.lob_used_page_count + ps.row_overflow_used_page_count)
			END
			) AS data,
		SUM (ps.used_page_count) AS used
	FROM sys.dm_db_partition_stats ps
	GROUP BY ps.object_id) AS a1
LEFT OUTER JOIN 
	(SELECT 
		it.parent_id,
		SUM(ps.reserved_page_count) AS reserved,
		SUM(ps.used_page_count) AS used
	 FROM sys.dm_db_partition_stats ps
	 INNER JOIN sys.internal_tables it ON (it.object_id = ps.object_id)
	 WHERE it.internal_type IN (202,204)
	 GROUP BY it.parent_id) AS a4 ON (a4.parent_id = a1.object_id)
INNER JOIN sys.all_objects a2  ON ( a1.object_id = a2.object_id ) 
INNER JOIN sys.schemas a3 ON (a2.schema_id = a3.schema_id)
WHERE a2.type <> N'S' and a2.type <> N'IT'
ORDER BY reserved DESC