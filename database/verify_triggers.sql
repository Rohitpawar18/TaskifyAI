-- Verification script to check if triggers are installed correctly

-- Show all triggers in the database
SHOW TRIGGERS FROM smarttaskdb;

-- Count triggers (should be 6)
SELECT COUNT(*) AS trigger_count 
FROM information_schema.TRIGGERS 
WHERE TRIGGER_SCHEMA = 'smarttaskdb';

-- Check if audit tables exist
SELECT 
    TABLE_NAME,
    TABLE_ROWS,
    CREATE_TIME
FROM information_schema.TABLES 
WHERE TABLE_SCHEMA = 'smarttaskdb' 
  AND TABLE_NAME IN ('task_status_history', 'deleted_tasks_log', 'tasks');

-- Check if timestamp columns exist in tasks table
SELECT 
    COLUMN_NAME,
    COLUMN_TYPE,
    COLUMN_DEFAULT,
    EXTRA
FROM information_schema.COLUMNS 
WHERE TABLE_SCHEMA = 'smarttaskdb' 
  AND TABLE_NAME = 'tasks'
  AND COLUMN_NAME IN ('created_at', 'updated_at');

-- Test trigger functionality (optional - uncomment to test)
/*
-- Insert test task
INSERT INTO tasks (description, status) VALUES ('Trigger Test Task', 'Pending');

-- Get the last inserted task
SELECT * FROM tasks ORDER BY task_id DESC LIMIT 1;

-- Update task status
UPDATE tasks SET status = 'done' WHERE description = 'Trigger Test Task';

-- Check status history
SELECT * FROM task_status_history ORDER BY changed_at DESC LIMIT 5;

-- Delete test task
DELETE FROM tasks WHERE description = 'Trigger Test Task';

-- Check deleted tasks log
SELECT * FROM deleted_tasks_log ORDER BY deleted_at DESC LIMIT 5;
*/
