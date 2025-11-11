package com.gardening;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class AddReminderServlet
 */
@WebServlet("/AddReminderServlet")
public class AddReminderServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AddReminderServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		try {
            String plantName = request.getParameter("plant_name");
            String task = request.getParameter("task");
            String reminderDate = request.getParameter("reminder_date");

            HttpSession session = request.getSession(false);
            int userId = (int) session.getAttribute("userId"); // saved during login

            Connection conn = DBConnection.connect();
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO reminders (user_id, plant_name, task, reminder_date) VALUES (?,?,?,?)"
            );
            ps.setInt(1, userId);
            ps.setString(2, plantName);
            ps.setString(3, task);
            ps.setString(4, reminderDate);

            int rows = ps.executeUpdate();
            if (rows > 0) {
                response.sendRedirect("viewReminders.jsp");
            } else {
                response.getWriter().println("Error adding reminder!");
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
	}

}
