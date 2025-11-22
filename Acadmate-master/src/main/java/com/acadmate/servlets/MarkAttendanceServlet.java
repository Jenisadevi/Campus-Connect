package com.acadmate.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.acadmate.util.DBUtil;

@WebServlet("/MarkAttendanceServlet")
public class MarkAttendanceServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        int studentId = Integer.parseInt(req.getParameter("student_id"));
        int subjectId = Integer.parseInt(req.getParameter("subject_id"));
        String date = req.getParameter("date");
        String status = req.getParameter("status");

        HttpSession session = req.getSession(false);
        Integer facultyId = (session != null) ? (Integer) session.getAttribute("user_id") : null;

        try (Connection con = DBUtil.getConnection()) {
            String sql = "INSERT INTO attendance (student_id, subject_id, attendance_date, status) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, studentId);
            ps.setInt(2, subjectId);
            ps.setString(3, date);
            ps.setString(4, status);
            ps.setObject(5, facultyId);
            ps.executeUpdate();

            res.sendRedirect("faculty-attendance.jsp?success=Attendance+Marked+Successfully");
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("faculty-attendance.jsp?error=Database+Error");
        }
    }
}
