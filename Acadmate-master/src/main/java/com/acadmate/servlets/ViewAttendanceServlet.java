package com.acadmate.servlets;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.*;

import com.acadmate.dao.AttendanceDAO;

@WebServlet("/ViewAttendanceServlet")
public class ViewAttendanceServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        AttendanceDAO dao = new AttendanceDAO();
        List<Map<String, String>> list = dao.getAllAttendance();
        req.getSession().setAttribute("attendanceList", list);
        res.sendRedirect("faculty-view-attendance.jsp");
    }
}
