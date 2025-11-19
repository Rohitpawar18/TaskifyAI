<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Login - TaskifyAI</title>
    <link href="https://fonts.googleapis.com/css?family=Roboto:400,700" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <style>
        :root {
            --primary: #2962ff;
            --primary-dark: #0039cb;
            --secondary: #00c853;
            --background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --card-bg: #ffffff;
            --text: #333333;
            --text-light: #757575;
            --error: #f44336;
        }
        
        body {
            background: var(--background); 
            font-family: 'Roboto', Arial, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .container {
            max-width:400px;
            width: 100%;
            background: var(--card-bg);
            padding: 40px 30px;
            border-radius: 20px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            text-align: center;
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
        
        h2 {
            color: var(--primary);
            margin-bottom: 25px;
            font-size: 1.8rem;
        }
        
        label {
            display: block;
            text-align: left;
            margin: 15px 0 8px;
            font-weight: 500;
            color: var(--text);
        }
        
        input {
            width: 100%;
            padding: 14px;
            border-radius: 10px;
            border: 1px solid #e0e0e0;
            margin-bottom: 20px;
            font-size: 16px;
            transition: all 0.3s;
            background: #f8f9fa;
        }
        
        input:focus {
            border-color: var(--primary);
            background: #fff;
            box-shadow: 0 0 0 3px rgba(41, 98, 255, 0.1);
            outline: none;
        }
        
        .btn-main {
            background: var(--primary);
            color: #fff;
            border: none;
            border-radius: 10px;
            padding: 14px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 500;
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
        
        .links {
            margin-top: 25px;
            text-align: center;
        }
        
        .links a {
            color: var(--primary);
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        
        .links a:hover {
            color: var(--primary-dark);
            text-decoration: underline;
        }
        
        .message {
            margin: 20px 0;
            padding: 12px;
            border-radius: 10px;
            font-size: 15px;
            text-align: center;
            background: #ffebee;
            color: var(--error);
            border: 1px solid #ffcdd2;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">
            <i class="fas fa-robot"></i>
            TaskifyAI
        </div>
        <h2>Login to Your Account</h2>
        <form action="login" method="post">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" required placeholder="Enter your username">
            
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required placeholder="Enter your password">
            
            <button type="submit" class="btn-main">
                <i class="fas fa-sign-in-alt"></i> Login
            </button>
        </form>
        
        <div class="links">
            <a href="register.jsp">
                <i class="fas fa-user-plus"></i> Register a new account
            </a>
        </div>
        
        <% 
            String msg = (String) request.getAttribute("message");
            if (msg != null) { 
        %>
            <div class="message">
                <i class="fas fa-exclamation-circle"></i> <%= msg %>
            </div>
        <% } %>
    </div>
</body>
</html>