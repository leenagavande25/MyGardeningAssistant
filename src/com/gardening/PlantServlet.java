package com.gardening;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/PlantServlet")
public class PlantServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String plantName = request.getParameter("plantName");
        String plantType = request.getParameter("plantType");

        try (Connection conn = DBConnection.connect()) {
            PreparedStatement ps = conn.prepareStatement("INSERT INTO user_plants (user_id, plant_name, plant_type) VALUES (?, ?, ?)");
            ps.setInt(1, userId);
            ps.setString(2, plantName);
            ps.setString(3, plantType);
            ps.executeUpdate();
            response.getWriter().write("success");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String action = request.getParameter("action");
        String plantId = request.getParameter("plantId");

        try (Connection conn = DBConnection.connect()) {
            if ("delete".equals(action)) {
                PreparedStatement ps = conn.prepareStatement("DELETE FROM user_plants WHERE plant_id=? AND user_id=?");
                ps.setInt(1, Integer.parseInt(plantId));
                ps.setInt(2, userId);
                ps.executeUpdate();
                response.getWriter().write("deleted");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error");
        }
    }
}
