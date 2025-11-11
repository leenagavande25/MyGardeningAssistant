<%@ page import="java.sql.*" %>
<%@ page import="com.gardening.DBConnection" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("userId") == null) {
        response.sendRedirect("UserLogin.html");
        return;
    }

    int userId = (Integer) sessionObj.getAttribute("userId");
    String username = "";
    String email = "";
    String aboutMe = "";
    String profilePic = "uploads/profile_pics/default.jpg";

    try {
        Connection conn = DBConnection.connect();
        PreparedStatement ps = conn.prepareStatement(
            "SELECT username, email, about_me, profile_pic FROM users WHERE id = ?"
        );
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            username = rs.getString("username");
            email = rs.getString("email");
            aboutMe = rs.getString("about_me");
            profilePic = rs.getString("profile_pic");
        }
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Edit Profile</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #e8f5e9;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 700px;
            margin: 40px auto;
            background: #fff;
            border-radius: 10px;
            padding: 25px 40px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            color: #2e7d32;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            font-weight: bold;
            color: #2e7d32;
        }
        input[type="text"], input[type="email"], input[type="password"], textarea {
            width: 100%;
            padding: 10px;
            border: 1px solid #c8e6c9;
            border-radius: 6px;
        }
        input[type="file"] {
            border: none;
        }
        button {
            width: 100%;
            padding: 10px;
            background-color: #388e3c;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
        }
        button:hover {
            background-color: #2e7d32;
        }
        .profile-pic {
            display: block;
            margin: 10px auto;
            width: 130px;
            height: 130px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #81c784;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Edit Profile</h2>

    <form action="UpdateProfileServlet" method="post" enctype="multipart/form-data">
        <img src="<%= profilePic %>" alt="Profile Picture" class="profile-pic" />

        <div class="form-group">
            <label>Username</label>
            <input type="text" name="username" value="<%= username %>" required />
        </div>

        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" value="<%= email %>" required />
        </div>

        <div class="form-group">
            <label>About Me</label>
            <textarea name="about_me" rows="4"><%= aboutMe %></textarea>
        </div>

        <div class="form-group">
            <label>Profile Picture</label>
            <input type="file" name="profile_pic" accept="image/*" />
        </div>

        <div class="form-group">
            <label>Change Password (Optional)</label>
            <input type="password" name="password" placeholder="Enter new password if you want" />
        </div>

        <button type="submit">Update Profile</button>
    </form>
</div>

</body>
</html>
