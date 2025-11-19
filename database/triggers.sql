-- Database Triggers for SmartTaskAI
-- Execute these triggers in your MySQL database (smarttaskdb)

-- 1. Trigger to automatically set created_at timestamp when a new task is inserted
DELIMITER $$

CREATE TRIGGER before_task_insert
BEFORE INSERT ON tasks
FOR EACH ROW
BEGIN
    IF NEW.created_at IS NULL THEN
        SET NEW.created_at = NOW();
    END IF;
END$$

DELIMITER ;

-- 2. Trigger to automatically update updated_at timestamp when a task is modified
DELIMITER $$

CREATE TRIGGER before_task_update
BEFORE UPDATE ON tasks
FOR EACH ROW
BEGIN
    SET NEW.updated_at = NOW();
END$$

DELIMITER ;

-- 3. Trigger to log task status changes in a separate audit table
DELIMITER $$

CREATE TRIGGER after_task_status_update
AFTER UPDATE ON tasks
FOR EACH ROW
BEGIN
    IF OLD.status != NEW.status THEN
        INSERT INTO task_status_history (task_id, old_status, new_status, changed_at)
        VALUES (NEW.task_id, OLD.status, NEW.status, NOW());
    END IF;
END$$

DELIMITER ;

-- 4. Trigger to log deleted tasks for audit purposes
DELIMITER $$

CREATE TRIGGER before_task_delete
BEFORE DELETE ON tasks
FOR EACH ROW
BEGIN
    INSERT INTO deleted_tasks_log (task_id, description, status, deleted_at)
    VALUES (OLD.task_id, OLD.description, OLD.status, NOW());
END$$

DELIMITER ;

-- 5. Trigger to validate status values before insert/update
DELIMITER $$

CREATE TRIGGER validate_task_status_insert
BEFORE INSERT ON tasks
FOR EACH ROW
BEGIN
    IF NEW.status NOT IN ('Pending', 'done', 'in-progress', 'cancelled') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid status value. Allowed: Pending, done, in-progress, cancelled';
    END IF;
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER validate_task_status_update
BEFORE UPDATE ON tasks
FOR EACH ROW
BEGIN
    IF NEW.status NOT IN ('Pending', 'done', 'in-progress', 'cancelled') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid status value. Allowed: Pending, done, in-progress, cancelled';
    END IF;
END$$

DELIMITER ;
