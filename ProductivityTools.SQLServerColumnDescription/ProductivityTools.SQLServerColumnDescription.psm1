function Get-ColumnsDescription {
    [cmdletbinding()]
    param(
        [string]$ServerInstance,
        [string]$Database,
        [switch]$OutMd
    )

    Write-Verbose "Hello from Get-ColumnsDescription"


    $query="select 
	    TableName = tbl.table_schema + '.' + tbl.table_name, 
        --st.name [Table],
        sc.name [Column],
        sep.value [Description]
        from sys.tables st
	    inner join information_schema.tables tbl on st.object_id=object_id(tbl.table_schema + '.' + tbl.table_name) 
        inner join sys.columns sc on st.object_id = sc.object_id
        left join sys.extended_properties sep on st.object_id = sep.major_id
                                             and sc.column_id = sep.minor_id
                                              and sep.name = 'MS_Description'"


    $r=Invoke-SQLQuery -SqlInstance $ServerInstance -DatabaseName $Database -Query $query
    if ($OutMd.IsPresent)
    {
        $md="Columns description:"+ [System.Environment]::NewLine;
        $md+="Table name|Column name|Description" + [System.Environment]::NewLine;
        $md+="|----------|:-------------:|------:|" + [System.Environment]::NewLine;
        foreach($item in $r){
            $md+=$item.TableName+"|"+$item.Column+"|"+$item.Description+ [System.Environment]::NewLine;
        }
        $md|Out-File ColumnDescription.MD
        Write-Output $md
    }
    else
    {
        Write-Output $r
    }    
}

  