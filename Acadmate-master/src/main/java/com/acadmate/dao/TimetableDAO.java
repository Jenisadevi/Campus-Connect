package com.acadmate.dao;

import java.sql.*;
import java.util.*;

import com.acadmate.util.DBUtil;

public class TimetableDAO {

    // ✅ Add a new timetable slot
    public boolean addSlot(String day, String subject, int facultyId, String startTime, String endTime, String className) {
        String sql = "INSERT INTO timetable (day_of_week, subject, faculty_id, start_time, end_time, class_name) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, day);
            ps.setString(2, subject);
            ps.setInt(3, facultyId);
            ps.setString(4, startTime);
            ps.setString(5, endTime);
            ps.setString(6, className);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // ✅ Fetch all timetable entries for admin view
    public List<Map<String, String>> getAllTimetable() {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = "SELECT t.*, u.name AS faculty_name FROM timetable t JOIN users u ON t.faculty_id = u.id ORDER BY FIELD(day_of_week, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday')";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, String> row = new HashMap<>();
                row.put("day", rs.getString("day_of_week"));
                row.put("subject", rs.getString("subject"));
                row.put("faculty", rs.getString("faculty_name"));
                row.put("time", rs.getString("start_time") + " - " + rs.getString("end_time"));
                row.put("class", rs.getString("class_name"));
                list.add(row);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
