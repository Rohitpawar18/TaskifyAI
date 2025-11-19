<%
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<html lang="en">
<head>
    <title>SmartTask AI: Create Task</title>
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,700" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
            background: var(--background); 
            font-family: 'Roboto', Arial, sans-serif; 
            min-height: 100vh;
            color: var(--text);
            display: flex;
            flex-direction: column;
        }
        
        .container { 
            max-width: 500px; 
            margin: 30px auto; 
            background: var(--card-bg); 
            padding: 30px; 
            border-radius: 20px; 
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1); 
            text-align: center;
            flex-grow: 1;
        }
        
        .logo {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--primary);
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        
        .logo i {
            color: var(--secondary);
        }
        
        .info { 
            color: var(--text-light); 
            font-size: 15px; 
            margin-bottom: 25px; 
            line-height: 1.5;
            background: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            border-left: 4px solid var(--primary);
        }
        
        .info b {
            color: var(--primary);
        }
        
        .form-section {
            margin-bottom: 25px;
            text-align: left;
        }
        
        .section-title {
            font-size: 18px;
            color: var(--primary);
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        label { 
            display: block; 
            text-align:left; 
            margin: 15px 0 8px 0;
            font-weight: 500;
            color: var(--text);
        }
        
        input, select { 
            width: 100%; 
            padding: 12px 15px; 
            font-size: 16px; 
            border: 1px solid #e0e0e0; 
            border-radius: 10px; 
            margin-bottom: 15px; 
            background: #f8f9fa; 
            outline: none;
            transition: all 0.3s;
        }
        
        input:focus, select:focus { 
            border-color: var(--primary);
            background: #fff;
            box-shadow: 0 0 0 3px rgba(41, 98, 255, 0.1);
        }
        
        .btn-main { 
            background: var(--primary); 
            color: #fff; 
            font-weight: 500; 
            border: none; 
            border-radius: 10px; 
            padding: 12px 25px; 
            font-size: 16px; 
            cursor: pointer; 
            margin: 15px 0; 
            width: 100%;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .btn-main:hover { 
            background: var(--primary-dark);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(41, 98, 255, 0.3);
        }
        
        .btn-secondary { 
            background: var(--secondary); 
            color: #fff; 
            border: none; 
            border-radius: 10px; 
            padding: 12px 20px; 
            cursor: pointer; 
            margin-top: 10px;
            width: 100%;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        
        .btn-secondary:hover {
            background: #00b248;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 200, 83, 0.3);
        }
        
        .message { 
            margin-top: 20px; 
            padding: 12px;
            border-radius: 10px;
            font-size: 15px; 
            text-align: center;
        }
        
        .message.success {
            background: #e8f5e9;
            color: var(--success);
            border: 1px solid #c8e6c9;
        }
        
        .message.error {
            background: #ffebee;
            color: var(--error);
            border: 1px solid #ffcdd2;
        }
        
        .divider {
            display: flex;
            align-items: center;
            margin: 25px 0;
            color: var(--text-light);
        }
        
        .divider::before,
        .divider::after {
            content: "";
            flex: 1;
            border-bottom: 1px solid #e0e0e0;
        }
        
        .divider span {
            padding: 0 15px;
            font-size: 14px;
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
        
        @media (max-width:600px) {
            .header { 
                flex-direction: column; 
                height:auto; 
                padding:15px 10px;
                gap: 10px;
            }
            .header-left, .header-center, .header-right { 
                margin:5px 0;
            }
            .container { 
                padding: 20px; 
                margin: 20px 10px;
                max-width:100%; 
            }
            input, select { 
                font-size:16px;
            }
            .header-center {
                flex-wrap: wrap;
            }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <div class="header">
        <div class="header-left">
            <i class="fas fa-robot"></i>
            SmartTask AI
        </div>
        <div class="header-center">
            <a href="index.jsp" class="header-tab active">
                <i class="fas fa-home"></i> Home
            </a>
            <a href="task" class="header-tab">
                <i class="fas fa-tasks"></i> Show Tasks
            </a>
        </div>
        <div class="header-right">
            <a href="logout" class="logout-btn">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>
    </div>
    
    <div class="container">
        <div class="logo">
            <i class="fas fa-robot"></i>
            SmartTask AI
        </div>
        <div class="info">
            <span>Create a new task using natural language or the form below.</span><br>
            <b>Example NLP:</b> 
            <span style="color:var(--primary);">create task complete assignment with high priority by 2025-12-05</span>
        </div>
        
        <!-- Natural Language Input Form -->
        <div class="form-section">
            <div class="section-title">
                <i class="fas fa-comment-alt"></i>
                Natural Language Input
            </div>
            <form action="task" method="post">
                <label for="input">NLP Task Input:</label>
                <input type="text" id="input" name="input" autocomplete="off" placeholder="Type NLP command" aria-label="NLP Input">
                <button type="submit" class="btn-main">
                    <i class="fas fa-paper-plane"></i> Submit NLP
                </button>
            </form>
        </div>
        
        <div class="divider">
            <span>OR</span>
        </div>
        
        <!-- Standard Task Creation Form -->
        <div class="form-section">
            <div class="section-title">
                <i class="fas fa-edit"></i>
                Standard Task Form
            </div>
            <form action="task" method="post">
                <label for="desc">Description:</label>
                <input type="text" id="desc" name="desc" autocomplete="off" required placeholder="Task description" aria-label="Task Description">
                
                <label for="priority">Priority:</label>
                <select id="priority" name="priority" aria-label="Priority">
                    <option value="High">High</option>
                    <option value="Medium" selected>Medium</option>
                    <option value="Low">Low</option>
                </select>
                
                <label for="deadline">Deadline:</label>
                <input type="date" id="deadline" name="deadline" aria-label="Deadline">
                
                <input type="hidden" name="action" value="createStandard">
                <button type="submit" class="btn-main">
                    <i class="fas fa-plus-circle"></i> Add Task
                </button>
            </form>
        </div>
        
        <% 
            String msg = (String) request.getAttribute("message"); 
            if (msg != null) { 
                String msgClass = msg.toLowerCase().contains("error") || msg.toLowerCase().contains("invalid") ? "error" : "success";
        %>
            <div class="message <%= msgClass %>">
                <i class="fas fa-<%= msgClass.equals("success") ? "check-circle" : "exclamation-circle" %>"></i>
                <%= msg %>
            </div>
        <% } %>
        
        <!-- View tasks button -->
        <form action="task" method="post">
            <input type="hidden" name="input" value="show task">
            <button type="submit" class="btn-secondary" aria-label="Show All Tasks">
                <i class="fas fa-list"></i> Show All Tasks
            </button>
        </form>
    </div>
</body>
</html>