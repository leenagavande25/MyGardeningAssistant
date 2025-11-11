<%@ page import="com.gardening.DBConnection" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="javax.servlet.*" %>
<%
    HttpSession session1 = request.getSession(false);	
    int userId = (int) session1.getAttribute("userId");

    Connection conn = DBConnection.connect();
    PreparedStatement ps = conn.prepareStatement("SELECT * FROM reminders WHERE user_id=? ORDER BY reminder_date ASC");
    ps.setInt(1, userId);
    ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
  <title>My Gardening Reminders</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container mt-5">
  <h2>My Gardening Reminders</h2>
  <table class="table table-bordered mt-3">
    <thead>
      <tr>
        <th>Plant</th>
        <th>Task</th>
        <th>Date</th>
        <th>Status</th>
      </tr>
    </thead>
    <tbody>
      <%
        while (rs.next()) {
      %>
        <tr>
          <td><%= rs.getString("plant_name") %></td>
          <td><%= rs.getString("task") %></td>
          <td><%= rs.getDate("reminder_date") %></td>
          <td><%= rs.getString("status") %></td>
        </tr>
      <%
        }
        conn.close();
      %>
    </tbody>
  </table>
</body>
</html>
