-- Script to drop all triggers if needed
-- Use this if you want to remove triggers or recreate them

DROP TRIGGER IF EXISTS before_task_insert;
DROP TRIGGER IF EXISTS before_task_update;
DROP TRIGGER IF EXISTS after_task_status_update;
DROP TRIGGER IF EXISTS before_task_delete;
DROP TRIGGER IF EXISTS validate_task_status_insert;
DROP TRIGGER IF EXISTS validate_task_status_update;

-- Optionally drop audit tables (WARNING: This will delete audit history)
-- DROP TABLE IF EXISTS task_status_history;
-- DROP TABLE IF EXISTS deleted_tasks_log;

SELECT 'All triggers dropped successfully!' AS message;
