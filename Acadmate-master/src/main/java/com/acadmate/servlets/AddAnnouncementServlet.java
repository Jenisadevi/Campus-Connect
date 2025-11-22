package com.acadmate.servlets;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import com.acadmate.dao.AnnouncementDAO;

@WebServlet("/AddAnnouncementServlet")
public class AddAnnouncementServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String title = req.getParameter("title");
        String message = req.getParameter("message");

        AnnouncementDAO dao = new AnnouncementDAO();
        if (dao.addAnnouncement(title, message)) {
            res.sendRedirect("faculty-dashboard.jsp?success=Announcement+Posted");
        } else {
            res.sendRedirect("faculty-dashboard.jsp?error=Database+Error");
        }
    }
}
