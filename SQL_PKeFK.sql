-- Buscar as chaves primárias da tabela
SELECT t.name AS 'Tabela', 
       c.name AS 'NomeColuna',
       'PK' AS 'Tipo',
       i.name AS 'NomeChave',
       '-' AS 'Origem'
FROM sys.indexes i
INNER JOIN sys.tables t ON t.object_id = i.object_id
INNER JOIN sys.index_columns ic ON ic.object_id = t.object_id AND ic.index_id = i.index_id
INNER JOIN sys.columns c ON c.object_id = t.object_id AND c.column_id = ic.column_id
WHERE i.is_primary_key = 1
UNION
-- Buscar as chaves estrangeiras da tabela
SELECT t.name AS 'Tabela',
	   c.name AS 'NomeColuna',
	   'FK' AS 'Tipo', 
	   NTO.NomeChave AS 'NomeChave',
	   NTO.Tabela AS 'Origem'
FROM sys.tables t
INNER JOIN sys.foreign_key_columns FK ON t.object_id = FK.parent_object_id
INNER JOIN sys.columns c ON t.object_id = c.object_id AND FK.parent_column_id = c.column_id 
INNER JOIN (
    SELECT c.name AS 'Campo', t.name AS 'Tabela', FK.name AS 'NomeChave'
    FROM sys.foreign_keys FK
    INNER JOIN sys.foreign_key_columns FKC ON FK.object_id = FKC.constraint_object_id
    INNER JOIN sys.tables t ON FK.referenced_object_id = t.object_id
    INNER JOIN sys.index_columns ic ON t.object_id = ic.object_id 
    INNER JOIN sys.columns c ON t.object_id = c.object_id AND ic.column_id = c.column_id
    INNER JOIN sys.indexes i ON t.object_id = i.object_id AND ic.index_id = i.index_id
) AS NTO ON NTO.Campo = c.name 
ORDER BY 'Tabela' ASC, 'Tipo' DESC;
