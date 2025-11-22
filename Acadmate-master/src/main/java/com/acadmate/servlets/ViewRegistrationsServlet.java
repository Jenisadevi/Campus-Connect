package com.acadmate.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.*;

import com.acadmate.util.DBUtil;
import com.google.gson.Gson;

@WebServlet("/ViewRegistrationsServlet")
public class ViewRegistrationsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        int eventId = Integer.parseInt(req.getParameter("eventId"));
        List<String> students = new ArrayList<>();

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "SELECT student_name FROM registrations WHERE event_id=?")) {

            ps.setInt(1, eventId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                students.add(rs.getString("student_name"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        res.setContentType("application/json");
        PrintWriter out = res.getWriter();
        out.print(new Gson().toJson(students));
        out.flush();
    }
}
