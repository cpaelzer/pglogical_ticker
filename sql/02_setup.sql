SELECT pglogical.create_node('test','host=localhost') INTO TEMP foonode;
DROP TABLE foonode;

WITH sets AS (
SELECT 'test'||generate_series AS set_name
FROM generate_series(1,8)
)

SELECT pglogical.create_replication_set
(set_name:=s.set_name
,replicate_insert:=TRUE
,replicate_update:=TRUE
,replicate_delete:=TRUE
,replicate_truncate:=TRUE) AS result
INTO TEMP repsets
FROM sets s
WHERE NOT EXISTS (
SELECT 1
FROM pglogical.replication_set
WHERE set_name = s.set_name);

DROP TABLE repsets;
