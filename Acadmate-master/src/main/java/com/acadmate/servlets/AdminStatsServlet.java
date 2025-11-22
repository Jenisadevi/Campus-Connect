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

@WebServlet("/AdminStatsServlet")
public class AdminStatsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        Map<String, Object> data = new HashMap<>();
        int approved = 0, pending = 0, rejected = 0;
        int cultural = 0, technical = 0;
        List<String> eventNames = new ArrayList<>();
        List<Integer> eventRegistrations = new ArrayList<>();

        try (Connection con = DBUtil.getConnection()) {

            // ✅ Count event statuses
            PreparedStatement ps1 = con.prepareStatement(
                "SELECT status, COUNT(*) AS total FROM events GROUP BY status");
            ResultSet rs1 = ps1.executeQuery();
            while (rs1.next()) {
                String status = rs1.getString("status");
                if ("Approved".equalsIgnoreCase(status)) approved = rs1.getInt("total");
                else if ("Pending".equalsIgnoreCase(status)) pending = rs1.getInt("total");
                else if ("Rejected".equalsIgnoreCase(status)) rejected = rs1.getInt("total");
            }

            // ✅ Count by event type
            PreparedStatement ps2 = con.prepareStatement(
                "SELECT type, COUNT(*) AS total FROM events GROUP BY type");
            ResultSet rs2 = ps2.executeQuery();
            while (rs2.next()) {
                String type = rs2.getString("type");
                if ("Cultural".equalsIgnoreCase(type)) cultural = rs2.getInt("total");
                else if ("Technical".equalsIgnoreCase(type)) technical = rs2.getInt("total");
            }

            // ✅ Registrations per event (including 0)
            PreparedStatement ps3 = con.prepareStatement("""
                SELECT e.event_name, COUNT(r.reg_id) AS count
                FROM events e
                LEFT JOIN registrations r ON e.event_id = r.event_id
                GROUP BY e.event_name
                ORDER BY e.event_date ASC
            """);
            ResultSet rs3 = ps3.executeQuery();
            while (rs3.next()) {
                eventNames.add(rs3.getString("event_name"));
                eventRegistrations.add(rs3.getInt("count"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        // ✅ Log data for debugging
        System.out.println("📊 Stats Data Sent to Chart:");
        System.out.println("Approved: " + approved + ", Pending: " + pending + ", Rejected: " + rejected);
        System.out.println("Event Names: " + eventNames);
        System.out.println("Registrations: " + eventRegistrations);

        // ✅ Put into map
        data.put("approved", approved);
        data.put("pending", pending);
        data.put("rejected", rejected);
        data.put("cultural", cultural);
        data.put("technical", technical);
        data.put("eventNames", eventNames);
        data.put("eventRegistrations", eventRegistrations);

        // ✅ Send JSON
        res.setContentType("application/json");
        PrintWriter out = res.getWriter();
        out.print(new Gson().toJson(data));
        out.flush();
    }
}
