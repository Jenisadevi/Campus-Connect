package com.acadmate.servlets;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import com.acadmate.dao.TimetableDAO;

@WebServlet("/AddTimetableServlet")
public class AddTimetableServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String day = req.getParameter("day");
        String subject = req.getParameter("subject");
        String facultyIdStr = req.getParameter("faculty_id");
        String start = req.getParameter("start_time");
        String end = req.getParameter("end_time");
        String className = req.getParameter("class_name");

        if (day == null || subject == null || facultyIdStr == null || start == null || end == null || className == null) {
            res.sendRedirect("admin-dashboard.jsp?error=Missing+fields");
            return;
        }

        try {
            int facultyId = Integer.parseInt(facultyIdStr);
            TimetableDAO dao = new TimetableDAO();

            if (dao.addSlot(day, subject, facultyId, start, end, className)) {
                res.sendRedirect("admin-dashboard.jsp?success=Timetable+Added+Successfully");
            } else {
                res.sendRedirect("admin-dashboard.jsp?error=Database+Error");
            }

        } catch (NumberFormatException e) {
            res.sendRedirect("admin-dashboard.jsp?error=Invalid+Faculty+ID");
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("admin-dashboard.jsp?error=Server+Error");
        }
    }
}
