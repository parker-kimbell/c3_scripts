use craftHPC;
DROP TABLE IF EXISTS temp_table;

CREATE TABLE temp_table (
translation_key	varchar(128) ,	
translation_value mediumtext,
description	varchar(6) COLLATE utf8_unicode_ci,
translation	varchar(100)
); 

LOAD DATA LOCAL INFILE 'C:/Users/kimbell/Documents/tou_translations_cleansed_a_tags_7-11.csv'
INTO TABLE temp_table 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
;

# SELECT * FROM temp_table;

# These two updates repair inconsistencies with language/country representations in Craft
UPDATE temp_table
SET description = "no_NO"
where temp_table.description = "nb_NO";

UPDATE temp_table
SET description = "en_UK"
where temp_table.description = "en_GB";

#The select statement below can be used to test the UDPATE call beneath this select statement, as it is a near duplicate of that logic
/*
SELECT translation_key, translation_value, id, locale, description FROM 
#SELECT * FROM 
temp_table INNER JOIN
newTable
ON LCASE(temp_table.description) = newTable.locale;
#WHERE temp_table.translation_key='msg.hp.tou.content';
*/


DROP TABLE IF EXISTS newTable;
CREATE TABLE newtable LIKE crafthpc.craft_content; 
INSERT newtable SELECT * FROM crafthpc.craft_content t1 WHERE t1.field_body IS NOT NULL;

UPDATE newTable
INNER JOIN temp_table as t3 ON LCASE(t3.description) = newTable.locale
SET newTable.field_body=t3.translation_value
WHERE t3.translation_key='msg.hp.tou.content' AND newTable.id=newTable.id;

UPDATE newTable
INNER JOIN temp_table as t3 ON LCASE(t3.description) = newTable.locale
SET newTable.field_dateText=t3.translation_value
WHERE t3.translation_key='msg.hp.tou.date' AND newTable.id=newTable.id;

UPDATE newTable
INNER JOIN temp_table as t3 ON LCASE(t3.description) = newTable.locale
SET newTable.field_titleText=t3.translation_value
WHERE t3.translation_key='msg.hp.tou.title' AND newTable.id=newTable.id;

SELECT * FROM newTable;

/* Update Craft TOU entries */
SELECT * FROM newTable INNER JOIN crafthpc.craft_content ON newTable.id = crafthpc.craft_content.id;

UPDATE crafthpc.craft_content
INNER JOIN newTable as t3 ON t3.id = crafthpc.craft_content.id
SET crafthpc.craft_content.field_body = t3.field_body
WHERE crafthpc.craft_content.id = t3.id;

UPDATE crafthpc.craft_content
INNER JOIN newTable as t3 ON t3.id = crafthpc.craft_content.id
SET crafthpc.craft_content.field_dateText = t3.field_dateText
WHERE crafthpc.craft_content.id = t3.id;

UPDATE crafthpc.craft_content
INNER JOIN newTable as t3 ON t3.id = crafthpc.craft_content.id
SET crafthpc.craft_content.field_titleText = t3.field_titleText
WHERE crafthpc.craft_content.id = t3.id;

# View updates
SELECT * FROM crafthpc.craft_content t1 WHERE t1.field_body IS NOT NULL;
DROP TABLE IF EXISTS temp_table;