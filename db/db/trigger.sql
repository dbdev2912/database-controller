USE DIPE;

DELIMITER $$

DROP TRIGGER IF EXISTS AUTO_INSERT_BLANK_RECORD_AFTER_ADD_ACCOUNT $$
CREATE TRIGGER AUTO_INSERT_BLANK_RECORD_AFTER_ADD_ACCOUNT
AFTER INSERT ON `accounts`
FOR EACH ROW
BEGIN 
	INSERT INTO `account_detail`( `credential_string`, `fullname`, `phone`, `email`, `address` ) VALUES
    ( NEW.credential_string, "Unknown", "Unknown phone number", "Unknown email address", "Nowhere" );
END

$$


DROP TRIGGER IF EXISTS AUTO_CREATE_NEW_TABLE_AND_DEFAULT_FIELD_AFTER_INSERT_NEW_TABLE $$
CREATE TRIGGER AUTO_CREATE_NEW_TABLE_AND_DEFAULT_FIELD_AFTER_INSERT_NEW_TABLE
AFTER INSERT ON `tables` 
FOR EACH ROW
BEGIN
	DECLARE new_table_id INT;
    SELECT `table_id` INTO new_table_id FROM `tables` WHERE `table_alias` = NEW.`table_alias`;
    CALL `add_field_silent`( new_table_id,  'ID', CONCAT('table_',new_table_id, '_id_alias'), FALSE, "INT", '{"AUTO_INCREMENT": "TRUE" }', "");
END

$$


DROP TRIGGER IF EXISTS AUTO_DROP_FIELDS_AND_CONSTRAINT_BEFORE_DROPPING_TABLE $$
CREATE TRIGGER AUTO_DROP_FIELDS_AND_CONSTRAINT_BEFORE_DROPPING_TABLE
BEFORE DELETE ON `tables`
FOR EACH ROW
BEGIN
	DELETE FROM `constraints` WHERE field_id IN ( SELECT field_id FROM `fields` WHERE table_id = OLD.table_id );
    DELETE FROM `default_value` WHERE field_id IN ( SELECT field_id FROM `fields` WHERE table_id = OLD.table_id );
    DELETE FROM `fields` WHERE table_id = OLD.table_id;
END
$$

DROP TRIGGER IF EXISTS AUTO_DROP_DEFAULT_VALUE_BEFORE_DROPPING_FIELD $$
CREATE TRIGGER AUTO_DROP_DEFAULT_VALUE_BEFORE_DROPPING_FIELD
BEFORE DELETE ON `fields`
FOR EACH ROW
BEGIN
    DELETE FROM `default_value` WHERE field_id = OLD.field_id;
END
$$

