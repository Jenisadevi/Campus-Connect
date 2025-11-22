package com.acadmate.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/hello")
public class HelloServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        out.println("<html><body style='font-family:sans-serif;text-align:center;margin-top:10%;'>");
        out.println("<h1>🚀 AcadMate ERP is Running Successfully!</h1>");
        out.println("<p>Welcome, Bujji! Your Tomcat 10.1 setup is working perfectly ✅</p>");
        out.println("</body></html>");
    }
}
