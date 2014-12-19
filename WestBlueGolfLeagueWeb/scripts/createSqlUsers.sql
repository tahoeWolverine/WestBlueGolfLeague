DROP USER 'westblue'@'localhost';
DROP USER 'westbluereadonly'@'localhost';
CREATE USER 'westblue'@'localhost' IDENTIFIED BY 'westblue';
CREATE USER 'westbluereadonly'@'localhost' IDENTIFIED BY 'westbluereadonly';
GRANT SELECT, DELETE, INSERT, UPDATE ON westbluegolf.* TO 'westblue'@'localhost';
GRANT SELECT ON westbluegolf.* TO 'westbluereadonly'@'localhost';