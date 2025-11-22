package com.acadmate.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.acadmate.util.DBUtil;

import java.util.HashMap;

public class EventDAO {

    // ---------- Inner DTO class ----------
    public static class Event {
        private final int id;
        private final String name;
        private final String type;
        private final Date date;
        private final String status;

        public Event(int id, String name, String type, Date date, String status) {
            this.id = id;
            this.name = name;
            this.type = type;
            this.date = date;
            this.status = status;
        }

        public int getId()     { return id; }
        public String getName(){ return name; }
        public String getType(){ return type; }
        public Date getDate()  { return date; }
        public String getStatus(){ return status; }
    }

    // ---------- Insert new event (Organizer) ----------
    public boolean insertEvent(String name, String type, String date, int createdBy) {
        final String sql =
                "INSERT INTO events (event_name, type, event_date, created_by, status) " +
                "VALUES (?, ?, ?, ?, 'Pending')";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, type);
            ps.setString(3, date);
            ps.setInt(4, createdBy);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("❌ Error inserting event: " + e.getMessage());
            return false;
        }
    }

    // ---------- Fetch all events (Admin) ----------
    public List<Event> getAllEvents() {
        List<Event> list = new ArrayList<>();
        final String sql = "SELECT * FROM events ORDER BY event_date ASC";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new Event(
                        rs.getInt("event_id"),
                        rs.getString("event_name"),
                        rs.getString("type"),
                        rs.getDate("event_date"),
                        rs.getString("status")
                ));
            }

        } catch (SQLException e) {
            System.err.println("❌ Error fetching events: " + e.getMessage());
        }
        return list;
    }

    // ---------- Update event status (Admin Approve/Reject) ----------
    public boolean updateEventStatus(int eventId, String status) {
        final String sql = "UPDATE events SET status = ? WHERE event_id = ?";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, eventId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            System.err.println("❌ Error updating event status: " + e.getMessage());
            return false;
        }
    }

    // ---------- Fetch only approved events (Student) ----------
    public List<Event> getApprovedEvents() {
        List<Event> list = new ArrayList<>();
        final String sql = "SELECT * FROM events WHERE status='Approved' ORDER BY event_date ASC";

        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(new Event(
                        rs.getInt("event_id"),
                        rs.getString("event_name"),
                        rs.getString("type"),
                        rs.getDate("event_date"),
                        rs.getString("status")
                ));
            }

        } catch (SQLException e) {
            System.err.println("❌ Error fetching approved events: " + e.getMessage());
        }
        return list;
    }

    // ---------- Fetch upcoming events ----------
    public List<Event> getUpcomingEvents() {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT * FROM events WHERE event_date >= CURDATE() ORDER BY event_date ASC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Event(
                    rs.getInt("event_id"),
                    rs.getString("event_name"),
                    rs.getString("type"),
                    rs.getDate("event_date"),
                    rs.getString("status")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Fetch events created by a specific organizer
    public List<Event> getEventsByOrganizer(int organizerId) {
        List<Event> list = new ArrayList<>();
        String sql = "SELECT * FROM events WHERE created_by = ? ORDER BY event_date ASC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, organizerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Event(
                    rs.getInt("event_id"),
                    rs.getString("event_name"),
                    rs.getString("type"),
                    rs.getDate("event_date"),
                    rs.getString("status")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ✅ Fetch registered students for events created by this organizer
    public List<Map<String, String>> getRegistrationsByOrganizer(int organizerId) {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = """
            SELECT r.student_name, e.event_name, e.event_date 
            FROM registrations r 
            JOIN events e ON r.event_id = e.event_id 
            WHERE e.created_by = ? 
            ORDER BY e.event_date ASC
        """;
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, organizerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, String> row = new HashMap<>();
                row.put("student_name", rs.getString("student_name"));
                row.put("event_name", rs.getString("event_name"));
                row.put("event_date", rs.getString("event_date"));
                list.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
