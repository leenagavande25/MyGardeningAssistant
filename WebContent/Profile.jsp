<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.gardening.DBConnection" %>
<%@ page session="true" %>

<%
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("userId") == null) {
        response.sendRedirect("UserLogin.html");
        return;
    }

    int userId = Integer.parseInt(sessionObj.getAttribute("userId").toString());
    String username = "";
    String email = "";
    String aboutMe = "";
    String profilePic = "uploads/profile_pics/default.jpg";

    try {
        Connection conn = DBConnection.connect();
        PreparedStatement ps = conn.prepareStatement("SELECT username, email, about_me, profile_pic FROM users WHERE id=?");
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            username = rs.getString("username");
            email = rs.getString("email");
            aboutMe = rs.getString("about_me") != null ? rs.getString("about_me") : "";
            profilePic = rs.getString("profile_pic") != null ? rs.getString("profile_pic") : "uploads/profile_pics/default.jpg";
        }

        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Profile</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(to right, #e8f5e9, #f9f9f9);
            margin: 0;
            padding: 0;
        }
        .header {
            background: linear-gradient(135deg, #4caf50, #2e7d32);
            color: white;
            text-align: center;
            padding: 25px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        .navbar {
            display: flex;
            justify-content: center;
            background-color: #388e3c;
            padding: 14px 0;
        }
        .navbar a {
            color: white;
            text-decoration: none;
            margin: 0 18px;
            font-weight: bold;
        }
        .navbar a:hover {
            color: #ffeb3b;
        }
        .profile-container {
            max-width: 600px;
            margin: 40px auto;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            text-align: center;
        }
        .profile-pic {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #4caf50;
        }
        input[type="text"], input[type="email"], input[type="password"], textarea {
            width: 90%;
            padding: 10px;
            margin: 8px 0;
            border-radius: 6px;
            border: 1px solid #ccc;
        }
        input[type="file"] {
            margin: 10px 0;
        }
        button {
            background-color: #4caf50;
            color: white;
            border: none;
            padding: 10px 25px;
            border-radius: 8px;
            cursor: pointer;
            transition: 0.3s;
        }
        button:hover {
            background-color: #45a049;
        }
        .status {
            margin: 10px 0;
            font-weight: 600;
            color: #2e7d32;
        }
    </style>
</head>
<body>

    <div class="header">
        <h1>Welcome, <%= username %> 🌿</h1>
    </div>

    <div class="navbar">
        <a href="User_Dashboard.jsp">Dashboard</a>
        <a href="Tasks.jsp">Tasks</a>
        <a href="Profile.jsp">Profile</a>
        <a href="LogoutServlet">Logout</a>
    </div>

    <div class="profile-container">
        <h2>Your Profile</h2>

        <img src="<%= profilePic %>" alt="Profile Picture" class="profile-pic"><br><br>

        <% if (request.getParameter("success") != null) { %>
            <div class="status">✅ Profile updated successfully!</div>
        <% } else if (request.getParameter("error") != null) { %>
            <div class="status" style="color:red;">❌ Failed to update profile. Try again.</div>
        <% } %>

        <form action="UpdateProfileServlet" method="post" enctype="multipart/form-data">
            <label>Username:</label><br>
            <input type="text" name="username" value="<%= username %>" required><br>

            <label>Email:</label><br>
            <input type="email" name="email" value="<%= email %>" required><br>

            <label>About Me:</label><br>
            <textarea name="about_me" rows="4" placeholder="Write something about yourself..."><%= aboutMe %></textarea><br>

            <label>New Password (optional):</label><br>
            <input type="password" name="password" placeholder="Leave blank to keep current password"><br>

            <label>Profile Picture:</label><br>
            <input type="file" name="profile_pic" accept="image/*"><br><br>

            <button type="submit">Update Profile</button>
        </form>
    </div>

</body>
</html>
