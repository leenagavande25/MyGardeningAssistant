<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #e8f5e9;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .login-box {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
            width: 320px;
            text-align: center;
        }
        input {
            width: 90%;
            padding: 10px;
            margin: 8px 0;
            border: 1px solid #ccc;
            border-radius: 6px;
        }
        button {
            width: 100%;
            padding: 10px;
            background-color: #4CAF50;
            border: none;
            color: white;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
        }
        button:hover {
            background-color: #2e7d32;
        }
        .error {
            color: red;
            margin-bottom: 10px;
        }
        .logout-msg {
            color: green;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>

<div class="login-box">
    <h2>🌿 Admin Login</h2>

    <% 
        String message = request.getParameter("error");
        if ("invalid".equals(message)) { 
    %>
        <div class="error">❌ Invalid Username or Password</div>
    <% } else if ("logout".equals(message)) { %>
        <div class="logout-msg">✅ Logged out successfully</div>
    <% } else if ("unauthorized".equals(message)) { %>
        <div class="error">⚠️ Please login first</div>
    <% } %>

    <form method="post">
        <input type="text" name="username" placeholder="Enter Username" required><br>
        <input type="password" name="password" placeholder="Enter Password" required><br>
        <button type="submit">Login</button>
    </form>

    <%
        // ✅ Hardcoded Admin Credentials
        String hardcodedUser = "Leena123";
        String hardcodedPass = "123";

        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");

            if (hardcodedUser.equals(username) && hardcodedPass.equals(password)) {
                HttpSession session1 = request.getSession();
                session1.setAttribute("adminUser", username);
                response.sendRedirect("AdminDashboard.jsp");
            } else {
                response.sendRedirect("adminLogin.jsp?error=invalid");
            }
        }
    %>
</div>

</body>
</html>
