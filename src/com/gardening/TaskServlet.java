package com.gardening;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/TaskServlet")
public class TaskServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        JSONArray taskArray = new JSONArray();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.getWriter().write("[]");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try (Connection conn = DBConnection.connect()) {
            String sql = "SELECT task_id, task_name, task_date FROM tasks WHERE user_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                JSONObject task = new JSONObject();
                task.put("id", rs.getInt("task_id"));
                task.put("title", rs.getString("task_name"));
                task.put("start", rs.getString("task_date"));
                taskArray.put(task);
            }

            response.getWriter().write(taskArray.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("[]");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Login required");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        try (Connection conn = DBConnection.connect()) {
            if ("delete".equals(action)) {
                String taskIdParam = request.getParameter("taskId");
                System.out.println("Deleting taskId: " + taskIdParam);

                if (taskIdParam == null || taskIdParam.isEmpty()) {
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing taskId");
                    return;
                }

                int taskId = Integer.parseInt(taskIdParam);
                PreparedStatement ps = conn.prepareStatement("DELETE FROM tasks WHERE task_id=? AND user_id=?");
                ps.setInt(1, taskId);
                ps.setInt(2, userId);

                int rows = ps.executeUpdate();
                if (rows > 0) {
                    response.getWriter().write("Deleted");
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Task not found");
                }

            } else if ("add".equals(action)) {
                String taskName = request.getParameter("taskName");
                String taskDate = request.getParameter("taskDate");

                PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO tasks (user_id, task_name, task_date, created_at) VALUES (?, ?, ?, NOW())");
                ps.setInt(1, userId);
                ps.setString(2, taskName);
                ps.setString(3, taskDate);
                ps.executeUpdate();

                response.getWriter().write("Added");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
        }
    }
}
