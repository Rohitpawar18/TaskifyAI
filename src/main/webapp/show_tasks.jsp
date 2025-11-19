<%
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<%@ page import="java.util.*" %>
<html lang="en">
<head>
    <title>All Tasks - TaskifyAI</title>
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,700" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <style>
        :root {
            --primary: #2962ff;
            --primary-dark: #0039cb;
            --secondary: #00c853;
            --accent: #ff4081;
            --background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --card-bg: #ffffff;
            --text: #333333;
            --text-light: #757575;
            --success: #4caf50;
            --warning: #ff9800;
            --error: #f44336;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body { 
            font-family: 'Roboto', Arial, sans-serif; 
            background: var(--background); 
            margin:0;
            padding:0;
            min-height: 100vh;
            color: var(--text);
        }
        
        .page-container {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        .content {
            flex: 1;
            padding: 20px;
        }
        
        h2 { 
            color: white; 
            text-align: center;
            margin: 20px 0 30px 0;
            font-size: 2rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .tasks-container {
            max-width: 1200px;
            margin: 0 auto;
            background: var(--card-bg);
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        
        table { 
            border-collapse: collapse; 
            width: 100%;
        }
        
        th, td { 
            padding: 15px 20px; 
            text-align: left; 
            border-bottom: 1px solid #e0e0e0; 
        }
        
        th { 
            background: #f5f7fa; 
            font-weight: 600;
            color: var(--primary);
            position: sticky;
            top: 0;
        }
        
        tr:hover td { 
            background: #f8f9fa; 
        }
        
        .priority-high {
            color: var(--error);
            font-weight: 600;
        }
        
        .priority-medium {
            color: var(--warning);
            font-weight: 600;
        }
        
        .priority-low {
            color: var(--success);
            font-weight: 600;
        }
        
        .status-pending {
            color: var(--warning);
            font-weight: 600;
        }
        
        .status-done {
            color: var(--success);
            font-weight: 600;
        }
        
        .action-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }
        
        .action-btn { 
            background: var(--primary); 
            color: #fff; 
            border: none; 
            border-radius: 6px; 
            padding: 8px 12px; 
            cursor: pointer; 
            font-size: 14px;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.2);
        }
        
        .delete-btn { 
            background: var(--error);
        }
        
        .edit-btn { 
            background: var(--warning);
        }
        
        .done-btn { 
            background: var(--success);
        }
        
        .edit-form { 
            margin-top: 10px; 
            background: #f0f7ff; 
            padding: 15px; 
            border-radius: 10px;
            border-left: 4px solid var(--primary);
        }
        
        .edit-form label {
            display: block;
            margin: 10px 0 5px;
            font-weight: 500;
            color: var(--text);
        }
        
        .edit-form input, .edit-form select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            margin-bottom: 10px;
        }
        
        .no-tasks {
            text-align: center;
            padding: 40px;
            color: var(--text-light);
        }
        
        .no-tasks i {
            font-size: 3rem;
            margin-bottom: 15px;
            color: #e0e0e0;
        }
        
        /* Header Styles */
        .header {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            color: var(--text);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 25px;
            height: 70px;
            box-shadow: 0 2px 20px rgba(0, 0, 0, 0.1);
            font-family: 'Roboto', Arial, sans-serif;
        }
        .header-left { 
            font-size: 28px; 
            font-weight:700; 
            letter-spacing:1px;
            color: var(--primary);
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .header-center { 
            flex: 1; 
            text-align: center;
            display: flex;
            justify-content: center;
            gap: 10px;
        }
        .header-tab {
            color: var(--text);
            text-decoration: none;
            margin: 0 10px;
            font-size: 16px;
            font-weight: 500;
            padding: 10px 20px;
            border-radius: 25px;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .header-tab.active {
            background: var(--primary);
            color: white;
        }
        .header-tab:hover { 
            background: rgba(41, 98, 255, 0.1); 
            color: var(--primary);
        }
        .header-right { }
        .logout-btn {
            background: var(--error);
            color: #fff;
            border: none;
            border-radius: 10px;
            padding: 10px 20px;
            text-decoration: none;
            font-size:16px;
            font-weight:500;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .logout-btn:hover { 
            background: #d32f2f;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(244, 67, 54, 0.3);
        }
        
        .back-btn {
            display: flex;
            justify-content: center;
            margin: 30px 0;
        }
        
        .back-btn a {
            background: var(--primary);
            color: white;
            padding: 12px 25px;
            border-radius: 10px;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
        }
        
        .back-btn a:hover {
            background: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(41, 98, 255, 0.3);
        }
        
        @media (max-width:700px) { 
            table, th, td { 
                font-size:14px; 
                padding:10px 8px;
            } 
            .header { 
                flex-direction: column; 
                height:auto; 
                padding:15px 10px;
                gap: 10px;
            }
            .header-left, .header-center, .header-right { 
                margin:5px 0;
            }
            .action-buttons {
                flex-direction: column;
            }
            .action-btn {
                justify-content: center;
            }
        } 
    </style>
    <script>
        function showEdit(id) { 
            document.getElementById('edit-form-'+id).style.display='block'; 
        }
        function hideEdit(id) { 
            document.getElementById('edit-form-'+id).style.display='none'; 
        }
    </script>
</head>
<body>
    <div class="page-container">
        <!-- Header -->
        <div class="header">
            <div class="header-left">
                <i class="fas fa-robot"></i>
                TaskifyAI
            </div>
            <div class="header-center">
                <a href="index.jsp" class="header-tab">
                    <i class="fas fa-home"></i> Home
                </a>
                <a href="task" class="header-tab active">
                    <i class="fas fa-tasks"></i> Show Tasks
                </a>
            </div>
            <div class="header-right">
                <a href="logout" class="logout-btn">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </div>
        </div>
        
        <div class="content">
            <h2>
                <i class="fas fa-tasks"></i>
                Task List
            </h2>
            
            <div class="tasks-container">
                <table>
                    <tr>
                        <th>No.</th>
                        <th>Description</th>
                        <th>Status</th>
                        <th>Priority</th>
                        <th>Deadline</th>
                        <th>Actions</th>
                    </tr>
                    <%
                        List<Map<String, String>> tasks = (List<Map<String, String>>) request.getAttribute("tasks");
                        if (tasks != null && !tasks.isEmpty()) {
                            int taskNum = 1;
                            for (Map<String, String> t : tasks) {
                                String tid = t.get("id");
                                String priority = t.get("priority");
                                String status = t.get("status");
                    %>
                    <tr>
                        <td><%= taskNum %></td>
                        <td><%= t.get("desc") %></td>
                        <td class="status-<%= status.toLowerCase() %>">
                            <i class="fas fa-<%= "done".equals(status) ? "check-circle" : "clock" %>"></i>
                            <%= status %>
                        </td>
                        <td class="priority-<%= priority.toLowerCase() %>">
                            <i class="fas fa-<%= "high".equals(priority.toLowerCase()) ? "exclamation-circle" : "flag" %>"></i>
                            <%= priority %>
                        </td>
                        <td><%= t.get("deadline") != null ? t.get("deadline") : "No deadline" %></td>
                        <td>
                            <div class="action-buttons">
                                <!-- Mark as Done -->
                                <% if (!"done".equals(status)) { %>
                                <form action="task" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="updateStatus">
                                    <input type="hidden" name="task_id" value="<%= tid %>">
                                    <input type="hidden" name="status" value="done">
                                    <button type="submit" class="action-btn done-btn" aria-label="Mark as Done">
                                        <i class="fas fa-check"></i> Done
                                    </button>
                                </form>
                                <% } %>
                                
                                <!-- Edit Button -->
                                <button class="action-btn edit-btn" onclick="showEdit(<%= tid %>)" aria-label="Edit Task">
                                    <i class="fas fa-edit"></i> Edit
                                </button>
                                
                                <!-- Delete Button -->
                                <form action="task" method="post" style="display:inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="task_id" value="<%= tid %>">
                                    <button type="submit" class="action-btn delete-btn" onclick="return confirm('Are you sure you want to delete this task?');" aria-label="Delete Task">
                                        <i class="fas fa-trash"></i> Delete
                                    </button>
                                </form>
                            </div>
                            
                            <!-- Inline edit form, hidden by default -->
                            <div class="edit-form" id="edit-form-<%= tid %>" style="display:none;">
                                <form action="task" method="post" style="margin:0;">
                                    <input type="hidden" name="action" value="edit">
                                    <input type="hidden" name="task_id" value="<%= tid %>">
                                    <label>Description:
                                        <input type="text" name="desc" value="<%= t.get("desc") %>" required aria-label="Edit Description">
                                    </label>
                                    <label>Status:
                                        <select name="status" aria-label="Edit Status">
                                            <option value="Pending" <%= "Pending".equals(t.get("status")) ? "selected" : "" %>>Pending</option>
                                            <option value="done" <%= "done".equals(t.get("status")) ? "selected" : "" %>>Done</option>
                                        </select>
                                    </label>
                                    <label>Priority:
                                        <select name="priority" aria-label="Edit Priority">
                                            <option value="High" <%= "High".equals(t.get("priority")) ? "selected" : "" %>>High</option>
                                            <option value="Medium" <%= "Medium".equals(t.get("priority")) ? "selected" : "" %>>Medium</option>
                                            <option value="Low" <%= "Low".equals(t.get("priority")) ? "selected" : "" %>>Low</option>
                                        </select>
                                    </label>
                                    <label>Deadline:
                                        <input type="date" name="deadline" value="<%= t.get("deadline") != null ? t.get("deadline") : "" %>" aria-label="Edit Deadline">
                                    </label>
                                    <div style="display: flex; gap: 10px; margin-top: 10px;">
                                        <button type="submit" class="action-btn edit-btn">
                                            <i class="fas fa-save"></i> Save
                                        </button>
                                        <button type="button" class="action-btn" onclick="hideEdit(<%= tid %>)">
                                            <i class="fas fa-times"></i> Cancel
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </td>
                    </tr>
                    <%
                                taskNum++;
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="6">
                            <div class="no-tasks">
                                <i class="fas fa-clipboard-list"></i>
                                <h3>No tasks found</h3>
                                <p>Create your first task to get started!</p>
                            </div>
                        </td>
                    </tr>
                    <% } %>
                </table>
            </div>
            
            <div class="back-btn">
                <a href="index.jsp" aria-label="Back to Create Task">
                    <i class="fas fa-arrow-left"></i> Back to Create Task
                </a>
            </div>
        </div>
    </div>
</body>
</html>