package com.gardening;

import java.io.*;
import javax.servlet.*;
import javax.servlet.annotation.*;
import javax.servlet.http.*;
import java.sql.*;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

@WebServlet("/UpdateProfileServlet")
@MultipartConfig
public class UpdateProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html;charset=UTF-8");

        try {
            int userId = Integer.parseInt(request.getParameter("userId"));
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String about = request.getParameter("about");

            // Handle profile picture upload
            Part filePart = null;
            try {
                filePart = request.getPart("profilePic");
            } catch (IllegalStateException ise) {
                // file too large or multipart parsing issue
                ise.printStackTrace();
            }

            String fileName = null;
            String imagePath = null;

            if (filePart != null) {
                // parse filename from content-disposition header for Servlet 3.0 compatibility
                fileName = extractFileName(filePart);
                if (fileName != null && !fileName.isEmpty()) {
                    // Ensure uploads directory exists under app context
                    String uploadDirPath = getServletContext().getRealPath("/") + File.separator + "uploads";
                    File uploadDir = new File(uploadDirPath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();

                    // sanitize fileName if needed (basic)
                    fileName = new File(fileName).getName();

                    File savedFile = new File(uploadDir, fileName);

                    // Save file via stream (works across servlet versions)
                    try (InputStream in = filePart.getInputStream()) {
                        Files.copy(in, savedFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                    }

                    // store relative path in DB
                    imagePath = "uploads/" + fileName;
                }
            }

            Connection conn = DBConnection.connect();

            // Build SQL dynamically to avoid overwriting password/profile_pic when not provided
            StringBuilder sql = new StringBuilder("UPDATE users SET username=?, email=?, about=?");
            if (password != null && !password.trim().isEmpty()) {
                sql.append(", password=?");
            }
            if (imagePath != null) {
                sql.append(", profile_pic=?");
            }
            sql.append(" WHERE user_id=?");

            PreparedStatement ps = conn.prepareStatement(sql.toString());
            int idx = 1;
            ps.setString(idx++, username);
            ps.setString(idx++, email);
            ps.setString(idx++, about);

            if (password != null && !password.trim().isEmpty()) {
                ps.setString(idx++, password);
            }
            if (imagePath != null) {
                ps.setString(idx++, imagePath);
            }

            ps.setInt(idx, userId);

            int updated = ps.executeUpdate();

            ps.close();
            conn.close();

            if (updated > 0) {
                response.sendRedirect("Profile.jsp?success=true");
            } else {
                response.sendRedirect("Profile.jsp?error=not_updated");
            }

        } catch (Exception e) {
            e.printStackTrace();
            // avoid exposing raw stack to user; redirect with message
            response.sendRedirect("Profile.jsp?error=" + urlEncode(e.getMessage()));
        }
    }

    /**
     * Extracts filename from Part's content-disposition header (compatible with Servlet 3.0).
     */
    private String extractFileName(Part part) {
        if (part == null) return null;
        String contentDisp = part.getHeader("content-disposition");
        if (contentDisp == null) return null;

        // example header: form-data; name="profilePic"; filename="photo.png"
        for (String token : contentDisp.split(";")) {
            token = token.trim();
            if (token.startsWith("filename")) {
                String[] kv = token.split("=", 2);
                if (kv.length == 2) {
                    String filename = kv[1].trim();
                    // remove surrounding quotes, if present
                    if (filename.startsWith("\"") && filename.endsWith("\"") && filename.length() > 1) {
                        filename = filename.substring(1, filename.length() - 1);
                    }
                    return filename;
                }
            }
        }
        return null;
    }

    private String urlEncode(String s) {
        try {
            return java.net.URLEncoder.encode(s, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            return "";
        }
    }
}
