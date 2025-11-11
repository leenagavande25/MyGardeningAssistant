<%@ page import="java.sql.*" %>
<%@ page import="com.gardening.DBConnection" %>

<%
    // --- Handle Logout ---
    if ("logout".equals(request.getParameter("action"))) {
        session.invalidate();
        response.sendRedirect("adminLogin.jsp");
        return;
    }

    // --- Check Login Session ---
    HttpSession session1 = request.getSession(false);
    if (session1 == null || session1.getAttribute("adminUser") == null) {
        response.sendRedirect("adminLogin.jsp?error=unauthorized");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f7f6;
            margin: 0;
        }
        .topbar {
            background-color: #4CAF50;
            color: white;
            padding: 12px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .logout-btn {
            background-color: #e53935;
            border: none;
            color: white;
            padding: 8px 16px;
            text-decoration: none;
            border-radius: 5px;
        }
        .logout-btn:hover {
            background-color: #c62828;
        }
        .content {
            padding: 30px;
            background: white;
            margin: 40px auto;
            width: 80%;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        h2, h3 {
            color: #2e7d32;
            text-align: center;
        }
        h4 {
            color: #333;
            text-align: center;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 25px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 10px;
            text-align: center;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tr:hover {
            background-color: #f1f8e9;
        }
    </style>
</head>
<body>
    <div class="topbar">
        <h2>Admin Dashboard</h2>
        <a href="adminLogin.jsp?action=logout" class="logout-btn">Logout</a>
    </div>

    <div class="content">
        <h3>Welcome, <%= session1.getAttribute("adminUser") %>!</h3>
        <hr>

        <%
            Connection conn = null;
            PreparedStatement ps = null;
            ResultSet rs = null;
            int userCount = 0;

            try {
                conn = DBConnection.connect();

                // Count total users
                ps = conn.prepareStatement("SELECT COUNT(*) FROM users");
                rs = ps.executeQuery();
                if (rs.next()) {
                    userCount = rs.getInt(1);
                }
                rs.close();
                ps.close();

                // Fetch user details
                ps = conn.prepareStatement("SELECT id, username, email FROM users ORDER BY id ASC");
                rs = ps.executeQuery();
        %>

        <h4>Total Registered Users: <%= userCount %></h4>

        <table>
            <tr>
                <th>User ID</th>
                <th>Username</th>
                <th>Email</th>
            </tr>

            <%
                while (rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("username") %></td>
                <td><%= rs.getString("email") %></td>
                
            </tr>
            <%
                }
            %>
        </table>

        <%
            } catch (Exception e) {
                out.println("<p style='color:red;text-align:center;'>Error: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            }
        %>
    </div>
</body>
</html>
