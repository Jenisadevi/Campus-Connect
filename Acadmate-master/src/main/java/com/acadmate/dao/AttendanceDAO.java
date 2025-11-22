package com.acadmate.dao;

import java.sql.*;
import java.util.*;

import com.acadmate.util.DBUtil;

public class AttendanceDAO {

    public boolean markAttendance(int studentId, int subjectId, String date, String status) {
        String sql = "INSERT INTO attendance (student_id, subject_id, attendance_date, status) VALUES (?, ?, ?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, subjectId);
            ps.setString(3, date);
            ps.setString(4, status);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();           
        }
        return false;
    }

    public List<Map<String, String>> getAllAttendance() {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = "SELECT * FROM attendance ORDER BY attendance_date DESC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, String> row = new HashMap<>();
                row.put("attendance_id", rs.getString("attendance_id"));
                row.put("student_id", rs.getString("student_id"));
                row.put("subject_id", rs.getString("subject_id"));
                row.put("attendance_date", rs.getString("attendance_date"));
                row.put("status", rs.getString("status"));
                list.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}



