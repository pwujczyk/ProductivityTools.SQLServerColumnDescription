<#
	My Function
#>
function Get-Function {

}

select 
	    TableName = tbl.table_schema + '.' + tbl.table_name, 
        --st.name [Table],
        sc.name [Column],
        sep.value [Description]
    from sys.tables st
	inner join information_schema.tables tbl on st.object_id=object_id(tbl.table_schema + '.' + tbl.table_name) 
    inner join sys.columns sc on st.object_id = sc.object_id
    left join sys.extended_properties sep on st.object_id = sep.major_id
                                         and sc.column_id = sep.minor_id
                                         and sep.name = 'MS_Description'

  