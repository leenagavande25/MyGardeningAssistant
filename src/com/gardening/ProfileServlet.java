package com.gardening;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ProfileServlet")
public class ProfileServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String aboutMe = request.getParameter("aboutMe");

        try (Connection conn = DBConnection.connect()) {
            PreparedStatement ps = conn.prepareStatement("UPDATE users SET about_me=? WHERE id=?");
            ps.setString(1, aboutMe);
            ps.setInt(2, userId);
            ps.executeUpdate();
            response.getWriter().write("success");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error");
        }
    }
}
