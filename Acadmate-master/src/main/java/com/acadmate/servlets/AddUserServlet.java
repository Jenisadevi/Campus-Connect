package com.acadmate.servlets;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import com.acadmate.dao.AdminUserDAO;

@WebServlet("/AddUserServlet")
public class AddUserServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String role = req.getParameter("role");

        AdminUserDAO dao = new AdminUserDAO();
        if (dao.addUser(name, email, password, role)) {
            res.sendRedirect("admin-dashboard.jsp?success=User+Added");
        } else {
            res.sendRedirect("admin-dashboard.jsp?error=Database+Error");
        }
    }
}
