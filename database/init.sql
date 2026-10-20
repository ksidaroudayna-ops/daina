-- Execution: sudo mysql < database/init.sql
CREATE DATABASE IF NOT EXISTS tasksdb CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'taskuser'@'localhost' IDENTIFIED BY 'taskpass';
GRANT ALL PRIVILEGES ON tasksdb.* TO 'taskuser'@'localhost';
FLUSH PRIVILEGES;

USE tasksdb;

CREATE TABLE IF NOT EXISTS task (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    done BIT(1) NOT NULL DEFAULT b'0'
);

INSERT INTO task (title, done)
SELECT * FROM (
    SELECT 'Installer MariaDB' AS title, b'1' AS done
    UNION ALL SELECT 'Apprendre Spring Boot', b'0'
    UNION ALL SELECT 'Apprendre Angular', b'0'
) AS seed
WHERE NOT EXISTS (SELECT 1 FROM task);
