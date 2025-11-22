package com.acadmate.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

import com.acadmate.util.DBUtil;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

@WebServlet("/FacultyReportServlet") // ✅ ensures it maps correctly to /acadmate/FacultyReportServlet
public class FacultyReportServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        res.setContentType("application/pdf");
        res.setHeader("Content-Disposition", "attachment; filename=Event_Report.pdf");

        try (Connection con = DBUtil.getConnection();
             OutputStream out = res.getOutputStream()) {

            // Create PDF document
            Document document = new Document(PageSize.A4);
            PdfWriter.getInstance(document, out);
            document.open();

            // Add title
            Font titleFont = new Font(Font.FontFamily.HELVETICA, 18, Font.BOLD, new GrayColor(0.2f));
            Paragraph title = new Paragraph("AcadMate - Event Report", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(20);
            document.add(title);

            // Table setup
            PdfPTable table = new PdfPTable(5);
            table.setWidthPercentage(100);
            table.setWidths(new float[]{2.5f, 1.5f, 1.5f, 1.2f, 2.5f});

            String[] headers = {"Event Name", "Type", "Date", "Status", "Student"};
            for (String header : headers) {
                PdfPCell cell = new PdfPCell(new Phrase(header, new Font(Font.FontFamily.HELVETICA, 12, Font.BOLD)));
                cell.setBackgroundColor(new GrayColor(0.9f));
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                table.addCell(cell);
            }

            // Query data
            PreparedStatement ps = con.prepareStatement(
                "SELECT e.event_name, e.type, e.event_date, e.status, r.student_name " +
                "FROM events e " +
                "LEFT JOIN registrations r ON e.event_id = r.event_id " +
                "ORDER BY e.event_date DESC"
            );
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                table.addCell(rs.getString("event_name"));
                table.addCell(rs.getString("type"));
                table.addCell(rs.getString("event_date"));
                table.addCell(rs.getString("status"));
                table.addCell(rs.getString("student_name") != null ? rs.getString("student_name") : "—");
            }

            document.add(table);
            document.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
