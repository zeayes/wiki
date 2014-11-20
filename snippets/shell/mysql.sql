/* modify table charset */
ALTER TABLE rebate CONVERT TO CHARACTER SET utf8;

/* add column on table */
ALTER TABLE rebate ADD COLUMN username VARCHAR(20) DEFAULT NULL;
