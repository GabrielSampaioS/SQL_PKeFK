-- Buscar as chaves primárias da tabela
select DISTINCT t.name as 'Tabela',
	    P.name 'NomeColuna',
	   'PK' as 'Tipo',
	   kc.name as 'NomeChave',
	   '-' as 'Origem'
from sys.all_columns ac
inner join sys.columns c on ac.object_id = c.object_id
inner join sys.tables t on c.object_id = t.object_id
inner join sys.key_constraints kc on t.object_id = kc.parent_object_id
inner join sys.indexes i on t.object_id = i.object_id
inner join (select object_id as 'ID' , name from sys.indexes where is_primary_key = 1) P on P.ID = t.object_id
UNION
-- Buscar as chaves estrangeiras da tabela
SELECT t.name as 'Tabela',
	   c.name  'NomeColuna',
	   'FK' as 'Tipo',
	   FK.name as 'NomeChave',
	   Origem.Origem
FROM 
    sys.foreign_key_columns AS fkc
JOIN 
    sys.all_columns AS ac ON fkc.parent_object_id = ac.object_id 
                           AND fkc.parent_column_id = ac.column_id
JOIN
    sys.all_columns AS rc ON fkc.referenced_object_id = rc.object_id
                           AND fkc.referenced_column_id = rc.column_id
inner join sys.tables t on fkc.parent_object_id = t.object_id
inner join sys.foreign_keys fk on fkc.constraint_object_id = fk.object_id
inner join sys.columns c on t.object_id = c.object_id and FKC.parent_column_id = c.column_id 
inner join (
			SELECT rt.name as 'Origem', fk.name
			FROM sys.foreign_keys AS fk
			INNER JOIN sys.tables AS pt ON fk.parent_object_id = pt.object_id
			INNER JOIN sys.tables AS rt ON fk.referenced_object_id = rt.object_id) Origem on fk.name = Origem.name
order by Tabela Asc, Tipo Desc