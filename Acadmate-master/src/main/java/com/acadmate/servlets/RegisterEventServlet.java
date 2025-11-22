package com.acadmate.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

import com.acadmate.util.DBUtil;

@WebServlet("/RegisterEventServlet")  // ✅ MUST MATCH URL
public class RegisterEventServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        String studentName = (session != null) ? (String) session.getAttribute("name") : null;
        int eventId = Integer.parseInt(req.getParameter("event_id"));

        if (studentName == null) {
            res.sendRedirect("login.jsp?error=Please+login+first!");
            return;
        }

        try (Connection con = DBUtil.getConnection()) {
            String sql = "INSERT INTO registrations (student_name, event_id) VALUES (?, ?)";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, studentName);
                ps.setInt(2, eventId);
                int rows = ps.executeUpdate();

                if (rows > 0) {
                    res.sendRedirect("student-dashboard.jsp?success=Registered+Successfully!");
                } else {
                    res.sendRedirect("student-dashboard.jsp?error=Registration+Failed!");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            res.sendRedirect("student-dashboard.jsp?error=Database+Error!");
        }
    }
}
