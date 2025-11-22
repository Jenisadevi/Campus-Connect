package com.acadmate.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
    private static final String URL = "jdbc:mysql://localhost:3306/acadmate_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String USER = "root";          // ✅ Change if needed
    private static final String PASSWORD = "jenisa@123";      // ✅ Use your actual MySQL password here

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("✅ MySQL JDBC Driver Loaded Successfully!");
        } catch (ClassNotFoundException e) {
            System.out.println("❌ JDBC Driver not found!");
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        System.out.println("🔗 Connecting to Database...");
        Connection con = DriverManager.getConnection(URL, USER, PASSWORD);
        System.out.println("✅ Database Connected!");
        return con;
    }
}
