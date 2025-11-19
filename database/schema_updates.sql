-- Schema Updates to Support Triggers
-- Run these SQL statements before creating triggers

-- Add timestamp columns to tasks table if they don't exist
ALTER TABLE tasks 
ADD COLUMN IF NOT EXISTS created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN IF NOT EXISTS updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

-- Create audit table for task status changes
CREATE TABLE IF NOT EXISTS task_status_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    task_id INT NOT NULL,
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_task_id (task_id)
);

-- Create audit table for deleted tasks
CREATE TABLE IF NOT EXISTS deleted_tasks_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    task_id INT NOT NULL,
    description TEXT,
    status VARCHAR(50),
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
