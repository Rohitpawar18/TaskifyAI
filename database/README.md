# Database Triggers Setup for SmartTaskAI

## Overview
This directory contains SQL scripts to add database triggers to your SmartTaskAI project without modifying the existing Java code structure.

## Installation Steps

### Step 1: Update Database Schema
First, run the schema updates to add required columns and audit tables:

```bash
mysql -u root -p smarttaskdb < schema_updates.sql
```

Or manually execute in MySQL Workbench/CLI:
```sql
SOURCE d:/Java Projects/SmartTaskAI/database/schema_updates.sql;
```

### Step 2: Create Triggers
After schema updates, create the triggers:

```bash
mysql -u root -p smarttaskdb < triggers.sql
```

Or manually execute:
```sql
SOURCE d:/Java Projects/SmartTaskAI/database/triggers.sql;
```

## Triggers Included

### 1. **before_task_insert**
- **Purpose**: Automatically sets `created_at` timestamp when a new task is created
- **Impact**: Zero - works seamlessly with existing code

### 2. **before_task_update**
- **Purpose**: Automatically updates `updated_at` timestamp whenever a task is modified
- **Impact**: Zero - works seamlessly with existing code

### 3. **after_task_status_update**
- **Purpose**: Logs all status changes to `task_status_history` table for auditing
- **Impact**: Zero - creates audit trail without affecting application
- **Benefit**: Track complete history of status changes per task

### 4. **before_task_delete**
- **Purpose**: Archives deleted tasks to `deleted_tasks_log` before deletion
- **Impact**: Zero - preserves data for compliance/recovery
- **Benefit**: Can recover accidentally deleted tasks

### 5. **validate_task_status_insert & validate_task_status_update**
- **Purpose**: Enforces valid status values at database level
- **Allowed Values**: 'Pending', 'done', 'in-progress', 'cancelled'
- **Impact**: Prevents invalid status values from being inserted

## Verify Triggers

Check if triggers are created successfully:

```sql
SHOW TRIGGERS FROM smarttaskdb;
```

View trigger details:
```sql
SHOW CREATE TRIGGER before_task_insert;
```

## Testing Triggers

### Test 1: Insert Trigger (created_at auto-fill)
```sql
INSERT INTO tasks (description, status) VALUES ('Test task', 'Pending');
SELECT * FROM tasks ORDER BY task_id DESC LIMIT 1;
-- created_at should be automatically set
```

### Test 2: Update Trigger (updated_at auto-update)
```sql
UPDATE tasks SET status = 'done' WHERE task_id = 1;
SELECT * FROM tasks WHERE task_id = 1;
-- updated_at should be automatically updated
```

### Test 3: Status History Trigger
```sql
UPDATE tasks SET status = 'done' WHERE task_id = 1;
SELECT * FROM task_status_history WHERE task_id = 1;
-- Should show status change log
```

### Test 4: Delete Log Trigger
```sql
DELETE FROM tasks WHERE task_id = 5;
SELECT * FROM deleted_tasks_log;
-- Should show deleted task details
```

### Test 5: Status Validation
```sql
INSERT INTO tasks (description, status) VALUES ('Test', 'invalid_status');
-- Should fail with error message
```

## View Audit Data

### View all status changes:
```sql
SELECT 
    h.history_id,
    h.task_id,
    t.description,
    h.old_status,
    h.new_status,
    h.changed_at
FROM task_status_history h
LEFT JOIN tasks t ON h.task_id = t.task_id
ORDER BY h.changed_at DESC;
```

### View deleted tasks:
```sql
SELECT * FROM deleted_tasks_log ORDER BY deleted_at DESC;
```

## Drop Triggers (if needed)

If you need to remove triggers:

```sql
DROP TRIGGER IF EXISTS before_task_insert;
DROP TRIGGER IF EXISTS before_task_update;
DROP TRIGGER IF EXISTS after_task_status_update;
DROP TRIGGER IF EXISTS before_task_delete;
DROP TRIGGER IF EXISTS validate_task_status_insert;
DROP TRIGGER IF EXISTS validate_task_status_update;
```

## Benefits

✅ **No Java code changes required** - All existing code continues to work  
✅ **Automatic timestamps** - Track when tasks are created/updated  
✅ **Complete audit trail** - Know who changed what and when  
✅ **Data recovery** - Recover deleted tasks from logs  
✅ **Data integrity** - Enforce valid status values at database level  
✅ **Transparent operation** - Application doesn't need to know about triggers  

## Notes

- Triggers work at the database level and are **transparent** to your Java application
- No changes to `TaskDAO.java`, servlets, or any other Java files
- Triggers will work with any application accessing the database (not just your Java app)
- Performance impact is minimal for these simple triggers
- Consider adding indexes on audit tables if they grow very large

## Optional Enhancements

You can view audit data in your application by adding new DAO methods:

```java
// Optional: Add to TaskDAO.java if you want to display audit data
public List<Map<String, String>> getTaskHistory(int taskId) throws Exception {
    String sql = "SELECT * FROM task_status_history WHERE task_id = ? ORDER BY changed_at DESC";
    // ... implementation
}

public List<Map<String, String>> getDeletedTasks() throws Exception {
    String sql = "SELECT * FROM deleted_tasks_log ORDER BY deleted_at DESC";
    // ... implementation
}
```
