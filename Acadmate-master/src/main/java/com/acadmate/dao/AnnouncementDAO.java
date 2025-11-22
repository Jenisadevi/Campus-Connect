package com.acadmate.dao;

import java.sql.*;
import java.util.*;

import com.acadmate.util.DBUtil;

public class AnnouncementDAO {

    public boolean addAnnouncement(String title, String message) {
        String sql = "INSERT INTO announcements (title, message) VALUES (?, ?)";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, title);
            ps.setString(2, message);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Map<String, String>> getAllAnnouncements() {
        List<Map<String, String>> list = new ArrayList<>();
        String sql = "SELECT * FROM announcements ORDER BY created_at DESC";
        try (Connection con = DBUtil.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, String> row = new HashMap<>();
                row.put("title", rs.getString("title"));
                row.put("message", rs.getString("message"));
                row.put("created_at", rs.getString("created_at"));
                list.add(row);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
