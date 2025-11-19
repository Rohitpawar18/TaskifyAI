<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Register - TaskifyAI</title>
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
            --success: #4caf50;
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
            display: flex;
            align-items: flex-start;
            justify-content: center;
            padding: 20px;
        }
        
        .container {
            max-width: 450px;
            width: 100%;
            background: var(--card-bg);
            padding: 40px 35px;
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
        
        .tagline {
            color: var(--text-light);
            font-size: 16px;
            margin-bottom: 30px;
            line-height: 1.5;
        }
        
        h2 {
            color: var(--primary);
            margin-bottom: 25px;
            font-size: 1.8rem;
        }
        
        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }
        
        label {
            display: block;
            margin: 15px 0 8px;
            font-weight: 500;
            color: var(--text);
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .input-with-icon {
            position: relative;
        }
        
        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-light);
        }
        
        input {
            width: 100%;
            padding: 14px 14px 14px 45px;
            border-radius: 10px;
            border: 1px solid #e0e0e0;
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
        
        .password-requirements {
            background: #f0f7ff;
            border-radius: 8px;
            padding: 12px 15px;
            margin-top: 10px;
            border-left: 4px solid var(--primary);
        }
        
        .password-requirements h4 {
            color: var(--primary);
            margin-bottom: 8px;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .password-requirements ul {
            list-style: none;
            padding-left: 0;
        }
        
        .password-requirements li {
            font-size: 13px;
            color: var(--text-light);
            margin-bottom: 5px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .password-requirements li i {
            font-size: 12px;
            color: #bdbdbd;
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
            margin-top: 10px;
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
        
        .features {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
            margin: 25px 0;
        }
        
        .feature {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 10px;
            text-align: center;
            transition: all 0.3s;
        }
        
        .feature:hover {
            background: #e3f2fd;
            transform: translateY(-3px);
        }
        
        .feature i {
            font-size: 24px;
            color: var(--primary);
            margin-bottom: 8px;
        }
        
        .feature p {
            font-size: 13px;
            color: var(--text);
            font-weight: 500;
        }
        
        @media (max-width: 480px) {
            .container {
                padding: 30px 20px;
            }
            
            .features {
                grid-template-columns: 1fr;
            }
            
            .logo {
                font-size: 2rem;
            }
        }
    </style>
    <script>
        function validatePassword() {
            const password = document.getElementById('password').value;
            const requirements = {
                length: password.length >= 6,
                uppercase: /[A-Z]/.test(password),
                number: /[0-9]/.test(password)
            };
            
            // Update requirement indicators
            document.getElementById('req-length').style.color = requirements.length ? '#4caf50' : '#bdbdbd';
            document.getElementById('req-uppercase').style.color = requirements.uppercase ? '#4caf50' : '#bdbdbd';
            document.getElementById('req-number').style.color = requirements.number ? '#4caf50' : '#bdbdbd';
            
            return requirements.length && requirements.uppercase && requirements.number;
        }
        
        function validateForm() {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                alert('Passwords do not match!');
                return false;
            }
            
            if (!validatePassword()) {
                alert('Please meet all password requirements!');
                return false;
            }
            
            return true;
        }
    </script>
</head>
<body>
    <div class="container">
        <div class="logo">
            <i class="fas fa-robot"></i>
            TaskifyAI
        </div>
        
        
        
        <h2>Create Your Account</h2>
        
        <form action="register" method="post" onsubmit="return validateForm()">
            <div class="form-group">
                <label for="username">
                    <i class="fas fa-user"></i> Username
                </label>
                <div class="input-with-icon">
                    <i class="fas fa-user input-icon"></i>
                    <input type="text" id="username" name="username" required autocomplete="off" 
                           placeholder="Choose a username" aria-label="Username" maxlength="50">
                </div>
            </div>
            
            <div class="form-group">
                <label for="password">
                    <i class="fas fa-lock"></i> Password
                </label>
                <div class="input-with-icon">
                    <i class="fas fa-lock input-icon"></i>
                    <input type="password" id="password" name="password" required 
                           placeholder="Create a strong password" aria-label="Password"
                           onkeyup="validatePassword()">
                </div>
                
                <div class="password-requirements">
                    <h4>
                        <i class="fas fa-shield-alt"></i> Password Requirements
                    </h4>
                    <ul>
                        <li>
                            <i class="fas fa-circle" id="req-length"></i>
                            At least 6 characters long
                        </li>
                        <li>
                            <i class="fas fa-circle" id="req-uppercase"></i>
                            Contains uppercase letter
                        </li>
                        <li>
                            <i class="fas fa-circle" id="req-number"></i>
                            Contains number
                        </li>
                    </ul>
                </div>
            </div>
            
            <div class="form-group">
                <label for="confirmPassword">
                    <i class="fas fa-lock"></i> Confirm Password
                </label>
                <div class="input-with-icon">
                    <i class="fas fa-lock input-icon"></i>
                    <input type="password" id="confirmPassword" name="confirmPassword" required 
                           placeholder="Re-enter your password" aria-label="Confirm Password">
                </div>
            </div>
            
            <div class="features">
                <div class="feature">
                    <i class="fas fa-magic"></i>
                    <p>NLP Task Creation</p>
                </div>
                <div class="feature">
                    <i class="fas fa-tasks"></i>
                    <p>Smart Organization</p>
                </div>
                <div class="feature">
                    <i class="fas fa-bell"></i>
                    <p>Deadline Reminders</p>
                </div>
                <div class="feature">
                    <i class="fas fa-chart-line"></i>
                    <p>Progress Tracking</p>
                </div>
            </div>
            
            <button type="submit" class="btn-main">
                <i class="fas fa-user-plus"></i> Create Account
            </button>
        </form>
        
        <div class="links">
            <a href="login.jsp">
                <i class="fas fa-arrow-left"></i> Back to Login
            </a>
        </div>
        
        <% 
            String msg = (String) request.getAttribute("message");
            if (msg != null) { 
                String msgClass = msg.toLowerCase().contains("success") ? "success" : "error";
        %>
            <div class="message <%= msgClass %>">
                <i class="fas fa-<%= msgClass.equals("success") ? "check-circle" : "exclamation-circle" %>"></i>
                <%= msg %>
            </div>
        <% } %>
    </div>
    
    <script>
        // Initialize password requirement indicators
        document.addEventListener('DOMContentLoaded', function() {
            validatePassword();
        });
    </script>
</body>
</html>