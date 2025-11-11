<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    Integer userId = (Integer) session.getAttribute("userId");  // store user_id during login
    if (username == null || userId == null) {
        response.sendRedirect("UserLogin.html");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Dashboard</title>

    <!-- FullCalendar CSS -->
    <link href="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.9/index.global.min.css" rel="stylesheet"/>
    <!-- SweetAlert2 -->
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to right, #e6f2e6, #f9f9f9);
            margin: 0;
            padding: 0;
        }
        .header {
            background: linear-gradient(135deg, #4caf50, #2e7d32);
            color: white;
            padding: 25px;
            text-align: center;
            box-shadow: 0px 4px 8px rgba(0,0,0,0.2);
        }
        .navbar {
            display: flex;
            justify-content: center;
            background-color: #388e3c;
            padding: 14px 0;
            box-shadow: 0px 2px 6px rgba(0,0,0,0.2);
        }
        .navbar a {
            color: white;
            text-decoration: none;
            margin: 0 18px;
            font-weight: 600;
            transition: 0.3s;
        }
        .navbar a:hover {
            color: #ffeb3b;
        }
        #calendar {
            max-width: 850px;
            margin: 30px auto;
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0px 4px 15px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>Welcome <%= username %></h1>
        <h2>Your Smart Gardening Assistant 🌱</h2>
    </div>

    <div class="navbar">
        <a href="User_Dashboard.jsp">Dashboard</a>
        <a href="Profile.jsp">Profile</a>
        <a href="Tasks.jsp">Tasks</a>
        <a href="LogoutServlet">Logout</a>
    </div>

    <div id="calendar"></div>

    <!-- FullCalendar JS -->
    <script src="https://cdn.jsdelivr.net/npm/fullcalendar@6.1.9/index.global.min.js"></script>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var calendarEl = document.getElementById("calendar");

            var calendar = new FullCalendar.Calendar(calendarEl, {
                initialView: "dayGridMonth",
                selectable: true,
                editable: true,

                // Fetch tasks from DB via TaskServlet
                events: {
                    url: "TaskServlet",
                    method: "GET",
                    extraParams: { userId: "<%= userId %>" },
                    failure: function () {
                        Swal.fire("Error", "Failed to load tasks from server.", "error");
                    }
                },

                // Add new task
                dateClick: function (info) {
                    Swal.fire({
                        title: "Add Task",
                        input: "text",
                        inputPlaceholder: "Enter task name",
                        showCancelButton: true,
                        confirmButtonText: "Save"
                    }).then((result) => {
                        if (result.value) {
                            fetch("TaskServlet", {
                                method: "POST",
                                headers: { "Content-Type": "application/x-www-form-urlencoded" },
                                body: "action=add&userId=<%= userId %>&taskName=" + encodeURIComponent(result.value) + "&taskDate=" + info.dateStr
                            })
                            .then(() => {
                                calendar.refetchEvents();
                                Swal.fire("Added!", "Task saved successfully.", "success");
                            })
                            .catch(() => Swal.fire("Error", "Failed to save task.", "error"));
                        }
                    });
                },

                // Delete task
                eventClick: function (info) {
                    Swal.fire({
                        title: "Delete Task?",
                        text: info.event.title,
                        icon: "warning",
                        showCancelButton: true,
                        confirmButtonColor: "#d33",
                        cancelButtonColor: "#3085d6",
                        confirmButtonText: "Yes, delete it!"
                    }).then((result) => {
                        if (result.isConfirmed) {
                            fetch("TaskServlet?action=delete&taskId=" + info.event.id, { method: "GET" })
                            .then(() => {
                                info.event.remove();
                                Swal.fire("Deleted!", "Task removed successfully.", "success");
                            })
                            .catch(() => Swal.fire("Error", "Failed to delete task.", "error"));
                        }
                    });
                }
            });

            calendar.render();
        });
    </script>
</body>
</html>
