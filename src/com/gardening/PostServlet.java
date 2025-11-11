package com.gardening;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/PostServlet")
public class PostServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String postContent = request.getParameter("postContent");

        try (Connection conn = DBConnection.connect()) {
            PreparedStatement ps = conn.prepareStatement("INSERT INTO user_posts (user_id, post_content) VALUES (?, ?)");
            ps.setInt(1, userId);
            ps.setString(2, postContent);
            ps.executeUpdate();
            response.getWriter().write("success");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("error");
        }
    }
}
