package com.acadmate.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import com.acadmate.dao.EventDAO;

@WebServlet("/AddEventServlet")   // ✅ Must match JSP form action
public class AddEventServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"organizer".equals(session.getAttribute("role"))) {
            res.sendRedirect("login.jsp?error=Please+login+as+organizer!");
            return;
        }

        String name = req.getParameter("event_name");
        String type = req.getParameter("type");
        String date = req.getParameter("event_date");
        int createdBy = 4; // later you’ll map real organizer ID

        EventDAO dao = new EventDAO();
        boolean success = dao.insertEvent(name, type, date, createdBy);

        if (success) {
            res.sendRedirect("organizer-dashboard.jsp?success=Event+created+and+awaiting+approval!");
        } else {
            res.sendRedirect("add-event.jsp?error=Failed+to+create+event!");
        }
    }
}
