package com.acadmate.servlets;

import com.acadmate.dao.EventDAO;
import com.acadmate.util.DBUtil;
import com.acadmate.util.EmailUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/AdminEventServlet")
public class AdminEventServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        int eventId = Integer.parseInt(req.getParameter("event_id"));
        String action = req.getParameter("action");

        String status = "approve".equals(action) ? "Approved" : "Rejected";

        try (Connection con = DBUtil.getConnection()) {
            // ✅ Update status in DB
            PreparedStatement ps = con.prepareStatement("UPDATE events SET status=? WHERE event_id=?");
            ps.setString(1, status);
            ps.setInt(2, eventId);
            ps.executeUpdate();

            // ✅ Get organizer email
            PreparedStatement ps2 = con.prepareStatement(
                "SELECT u.email, e.event_name FROM events e JOIN users u ON e.created_by=u.id WHERE e.event_id=?");
            ps2.setInt(1, eventId);
            ResultSet rs = ps2.executeQuery();

            if (rs.next()) {
                String organizerEmail = rs.getString("email");
                String eventName = rs.getString("event_name");

                String subject = "AcadMate - Event " + status;
                String message = "Dear Organizer,\n\nYour event '" + eventName +
                        "' has been " + status.toLowerCase() + " by Admin.\n\n- AcadMate Team";

                EmailUtil.sendEmail(organizerEmail, subject, message);
            }

            res.sendRedirect("admin-dashboard.jsp?success=Event+" + status + "+and+email+sent");

        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("admin-dashboard.jsp?error=Error+updating+event");
        }
    }
}
