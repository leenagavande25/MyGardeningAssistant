package com.gardening;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        JSONObject result = new JSONObject();

        try (Connection conn = DBConnection.connect()) {
            // Get total users
            PreparedStatement ps1 = conn.prepareStatement("SELECT COUNT(*) AS total FROM users");
            ResultSet rs1 = ps1.executeQuery();
            int totalUsers = 0;
            if (rs1.next()) totalUsers = rs1.getInt("total");

            // Get all user info
            PreparedStatement ps2 = conn.prepareStatement("SELECT user_id, username, email FROM users");
            ResultSet rs2 = ps2.executeQuery();
            JSONArray users = new JSONArray();
            while (rs2.next()) {
                JSONObject user = new JSONObject();
                user.put("id", rs2.getInt("user_id"));
                user.put("username", rs2.getString("username"));
                user.put("email", rs2.getString("email"));
                users.put(user);
            }

            result.put("totalUsers", totalUsers);
            result.put("users", users);
            response.getWriter().write(result.toString());

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error fetching admin data");
        }
    }
}
