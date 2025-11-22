package com.acadmate.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

import com.acadmate.util.DBUtil;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String role = req.getParameter("role");

        if (email == null || password == null || role == null) {
            res.sendRedirect("login.jsp?error=Please+fill+all+fields");
            return;
        }

        try (Connection con = DBUtil.getConnection()) {
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM users WHERE email=? AND password=? AND role=?");
            ps.setString(1, email);
            ps.setString(2, password);
            ps.setString(3, role);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                HttpSession session = req.getSession(true);
                session.setAttribute("user_id", rs.getInt("id")); // ✅ FIXED LINE
                session.setAttribute("name", rs.getString("name"));
                session.setAttribute("role", rs.getString("role"));

                System.out.println("✅ LOGIN SUCCESS: id=" + rs.getInt("id") +
                                   " | name=" + rs.getString("name") +
                                   " | role=" + rs.getString("role"));

                switch (role) {
                case "admin" -> 
                    res.sendRedirect("logo-animation.jsp?redirect=admin-dashboard.jsp");
                case "faculty" -> 
                    res.sendRedirect("logo-animation.jsp?redirect=faculty-dashboard.jsp");
                case "organizer" -> 
                    res.sendRedirect("logo-animation.jsp?redirect=organizer-dashboard.jsp");
                default -> 
                    res.sendRedirect("logo-animation.jsp?redirect=student-dashboard.jsp");
            }

            } else {
                res.sendRedirect("login.jsp?error=Invalid+email,+password,+or+role!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            res.sendRedirect("login.jsp?error=" + e.getMessage());
        }
    }
}
