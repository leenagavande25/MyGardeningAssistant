<%@ page import="com.gardening.DBConnection" %>
<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>

<%
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj == null || sessionObj.getAttribute("username") == null) {
        response.sendRedirect("UserLogin.html");
        return;
    }

    String username = (String) sessionObj.getAttribute("username");
    Integer userIdObj = (Integer) sessionObj.getAttribute("userId");
    int userId = (userIdObj != null) ? userIdObj.intValue() : 0;
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Your Tasks</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f4f7f6;
            margin: 0;
            padding: 0;
        }
        .header {
            background: linear-gradient(135deg, #4caf50, #2e7d32);
            color: white;
            padding: 20px;
            text-align: center;
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        .header h1 {
            margin: 0;
            font-size: 26px;
        }
        .container {
            max-width: 900px;
            margin: 30px auto;
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 15px;
        }
        th, td {
            padding: 12px;
            border-bottom: 1px solid #ddd;
            text-align: center;
        }
        th {
            background: #4caf50;
            color: white;
        }
        tr:hover {
            background: #f1f8e9;
        }
        .btn {
            padding: 6px 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-weight: bold;
        }
        .btn-delete {
            background-color: #e53935;
            color: white;
        }
        .btn-delete:hover {
            background-color: #c62828;
        }
        .back-btn {
            display: inline-block;
            margin-top: 15px;
            padding: 10px 15px;
            background: #2e7d32;
            color: white;
            text-decoration: none;
            border-radius: 6px;
        }
        .back-btn:hover {
            background: #1b5e20;
        }
        /* ✅ Toast message style */
        #toast {
            position: fixed;
            top: 20px;
            right: 20px;
            background-color: #4caf50;
            color: white;
            padding: 12px 20px;
            border-radius: 6px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.3);
            display: none;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1><%= username %> - Your Task List</h1>
    </div>

    <div class="container">
        <h2>📋 Task Manager</h2>

        <table>
            <tr>
                <th>Task Number</th>
                <th>Task Name</th>
                <th>Task Date</th>
                <th>Created At</th>
                <th>Action</th>
            </tr>

            <%
                int srNo = 1;
                try {
                    Connection conn = DBConnection.connect();
                    PreparedStatement ps = conn.prepareStatement(
                        "SELECT task_id, task_name, task_date, created_at FROM tasks WHERE user_id = ? ORDER BY task_date ASC"
                    );
                    ps.setInt(1, userId);
                    ResultSet rs = ps.executeQuery();

                    while (rs.next()) {
                        String taskName = rs.getString("task_name");
                        String taskDate = rs.getString("task_date");
                        String createdAt = rs.getString("created_at");
                        int taskId = rs.getInt("task_id");
            %>
            <tr id="row-<%= taskId %>">
                <td><%= srNo++ %></td>
                <td><%= taskName %></td>
                <td><%= taskDate %></td>
                <td><%= createdAt %></td>
                <td>
                    <button type="button" class="btn btn-delete" onclick="deleteTask(<%= taskId %>)">Delete</button>
                </td>
            </tr>
            <%
                    }
                    conn.close();
                } catch (Exception e) {
                    out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
                }
            %>
        </table>

        <a href="User_Dashboard.jsp" class="back-btn">⬅ Back to Dashboard</a>
    </div>

    <!-- Toast Notification -->
    <div id="toast">✅ Task deleted successfully!</div>

    <script>
    function showToast(message) {
        const toast = document.getElementById("toast");
        toast.textContent = message;
        toast.style.display = "block";
        setTimeout(() => { toast.style.display = "none"; }, 3000);
    }

    function deleteTask(taskId) {
        if (!confirm("Are you sure you want to delete this task?")) return;

        fetch("TaskServlet", {
            method: "POST",
            headers: { "Content-Type": "application/x-www-form-urlencoded" },
            body: "action=delete&taskId=" + encodeURIComponent(taskId)
        })
        .then(function(res) {
            if (!res.ok) throw new Error("Failed to delete");
            return res.text();
        })
        .then(function(data) {
            if (data.indexOf("Deleted") !== -1) {
                // Remove the deleted row instantly
                var row = document.getElementById("row-" + taskId);
                if (row) row.remove();
                showToast("✅ Task deleted successfully!");
            }
        })
        .catch(function(err) {
            console.error(err);
            showToast("❌ Error deleting task!");
        });
    }
    </script>
</body>
</html>
