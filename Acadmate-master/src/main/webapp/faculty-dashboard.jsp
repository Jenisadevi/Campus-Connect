<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.acadmate.util.DBUtil, java.sql.*, java.util.*" %>

<%
    String name = (String) session.getAttribute("name");
    String role = (String) session.getAttribute("role");

    if (name == null || !"faculty".equals(role)) {
        response.sendRedirect("login.jsp?error=Please+login+as+faculty");
        return;
    }

    // Event & registration data
    List<Map<String, String>> records = new ArrayList<>();
    List<Map<String, String>> announcements = new ArrayList<>();
    List<Map<String, String>> attendanceSummary = new ArrayList<>();
    List<Map<String, String>> studentSummary = new ArrayList<>();
    List<Map<String, String>> timetable = new ArrayList<>();

    try (Connection con = DBUtil.getConnection()) {

        // EVENTS
     String sqlEvents =
    "SELECT e.event_name, e.type, e.event_date, e.status, r.student_name " +
    "FROM events e " +
    "LEFT JOIN registrations r ON e.event_id = r.event_id " +
    "ORDER BY e.event_date DESC";

        PreparedStatement ps1 = con.prepareStatement(sqlEvents);
        ResultSet rs1 = ps1.executeQuery();
        while (rs1.next()) {
            Map<String, String> row = new HashMap<>();
            row.put("event_name", rs1.getString("event_name"));
            row.put("type", rs1.getString("type"));
            row.put("date", rs1.getString("event_date"));
            row.put("status", rs1.getString("status"));
            row.put("student_name", rs1.getString("student_name") == null ? "—" : rs1.getString("student_name"));
            records.add(row);
        }

        // ANNOUNCEMENTS
        String sqlAnnouncements = "SELECT * FROM announcements ORDER BY created_at DESC";
        PreparedStatement ps2 = con.prepareStatement(sqlAnnouncements);
        ResultSet rs2 = ps2.executeQuery();
        while (rs2.next()) {
            Map<String, String> row = new HashMap<>();
            row.put("title", rs2.getString("title"));
            row.put("message", rs2.getString("message"));
            row.put("created_at", rs2.getString("created_at"));
            announcements.add(row);
        }

        // ATTENDANCE SUMMARY
        String sqlAttendance =
    "SELECT subject_id, COUNT(*) AS total_classes, " +
    "SUM(CASE WHEN status='Present' THEN 1 ELSE 0 END) AS present_classes " +
    "FROM attendance GROUP BY subject_id";

        PreparedStatement ps3 = con.prepareStatement(sqlAttendance);
        ResultSet rs3 = ps3.executeQuery();
        while (rs3.next()) {
            Map<String, String> row = new HashMap<>();
            row.put("subject_id", rs3.getString("subject_id"));
            row.put("total_classes", rs3.getString("total_classes"));
            row.put("present_classes", rs3.getString("present_classes"));
            attendanceSummary.add(row);
        }

        // STUDENT SUMMARY
       String sqlStudents =
    "SELECT s.student_id, s.name, " +
    "SUM(CASE WHEN a.status='Present' THEN 1 ELSE 0 END) AS total_present, " +
    "COUNT(a.status) AS total_classes " +
    "FROM students s " +
    "LEFT JOIN attendance a ON s.student_id = a.student_id " +
    "GROUP BY s.student_id, s.name";

        PreparedStatement ps4 = con.prepareStatement(sqlStudents);
        ResultSet rs4 = ps4.executeQuery();
        while (rs4.next()) {
            Map<String, String> row = new HashMap<>();
            row.put("student_id", rs4.getString("student_id"));
            row.put("name", rs4.getString("name"));
            row.put("present", rs4.getString("total_present"));
            row.put("classes", rs4.getString("total_classes"));
            studentSummary.add(row);
        }

        // TIMETABLE
        String sqlTimetable = "SELECT * FROM timetable ORDER BY day_of_week";
        PreparedStatement ps5 = con.prepareStatement(sqlTimetable);
        ResultSet rs5 = ps5.executeQuery();
        while (rs5.next()) {
            Map<String, String> row = new HashMap<>();
            row.put("day", rs5.getString("day_of_week"));
            row.put("subject", rs5.getString("subject"));
            row.put("time_slot", rs5.getString("time_slot"));
            timetable.add(row);
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Faculty Dashboard | AcadMate</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

<style>
body {
  background: linear-gradient(135deg, #0f172a, #1e3a8a);
  color: #fff;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
}
.card {
  background: rgba(255,255,255,0.08);
  border-radius: 20px;
  padding: 30px;
  width: 95%;
  max-width: 1200px;
  box-shadow: 0 0 30px rgba(255,255,255,0.1);
}
h2 { color: #60a5fa; }
h4 { color: #facc15; }
th { background-color: #1d4ed8; }
.btn-custom {
  border: none; border-radius: 10px; font-weight: 600; padding: 8px 15px; transition: 0.3s;
}
.btn-export { background: #22c55e; color: #fff; }
.btn-export:hover { background: #16a34a; transform: scale(1.05); }
.btn-attendance { background: #facc15; color: #000; margin-left: 10px; }
.btn-attendance:hover { background: #eab308; transform: scale(1.05); }
.btn-view { background: #3b82f6; color: #fff; margin-left: 10px; }
.btn-view:hover { background: #2563eb; transform: scale(1.05); }
.section-divider { margin: 40px 0 20px; border-bottom: 2px solid rgba(255,255,255,0.2); }
</style>
</head>

<body>
<div class="container">
<div class="card">
  <h2><i class="fa-solid fa-user-tie"></i> Welcome Faculty, <%= name %> 🎓</h2>
  <p class="text-light mb-3">You can view reports, manage attendance, announcements, and timetable.</p>

  <!-- Buttons -->
  <div class="d-flex justify-content-end mb-3">
    <form action="FacultyReportServlet" method="get" class="me-2">
      <button class="btn-custom btn-export"><i class="fa-solid fa-file-pdf"></i> Export PDF</button>
    </form>
    <a href="faculty-attendance.jsp" class="btn-custom btn-attendance"><i class="fa-solid fa-clipboard-check"></i> Mark Attendance</a>
    <a href="faculty-view-attendance.jsp" class="btn-custom btn-view"><i class="fa-solid fa-eye"></i> View Attendance</a>
  </div>

  <!-- Events Table -->
  <h4>📅 Events Overview</h4>
  <table class="table table-striped table-hover">
    <thead><tr><th>Event</th><th>Type</th><th>Date</th><th>Status</th><th>Student</th></tr></thead>
    <tbody>
      <% if (records.isEmpty()) { %><tr><td colspan="5" class="text-center">No events.</td></tr>
      <% } else { for (Map<String, String> r : records) { %>
        <tr><td><%= r.get("event_name") %></td><td><%= r.get("type") %></td><td><%= r.get("date") %></td><td><%= r.get("status") %></td><td><%= r.get("student_name") %></td></tr>
      <% }} %>
    </tbody>
  </table>

  <div class="section-divider"></div>

  <!-- Announcements -->
  <h4>📢 Announcements</h4>
  <form action="AddAnnouncementServlet" method="post" class="mb-3">
    <div class="input-group">
      <input type="text" name="title" placeholder="Title" class="form-control" required>
      <input type="text" name="message" placeholder="Message" class="form-control" required>
      <button class="btn btn-warning"><i class="fa-solid fa-paper-plane"></i> Post</button>
    </div>
  </form>
  <ul>
    <% for (Map<String, String> a : announcements) { %>
      <li><b><%= a.get("title") %></b>: <%= a.get("message") %> <small class="text-secondary">[<%= a.get("created_at") %>]</small></li>
    <% } %>
  </ul>

  <div class="section-divider"></div>

  <!-- Timetable -->
  <h4>🕓 Timetable</h4>
  <table class="table table-dark table-striped">
    <thead><tr><th>Day</th><th>Subject</th><th>Time</th></tr></thead>
    <tbody>
      <% for (Map<String, String> t : timetable) { %>
        <tr><td><%= t.get("day") %></td><td><%= t.get("subject") %></td><td><%= t.get("time_slot") %></td></tr>
      <% } %>
    </tbody>
  </table>

  <div class="section-divider"></div>

  <!-- Attendance Summary -->
  <h4>📊 Attendance Summary</h4>
  <table class="table table-striped">
    <thead><tr><th>Subject</th><th>Total</th><th>Present</th><th>Percentage</th></tr></thead>
    <tbody>
      <% for (Map<String, String> a : attendanceSummary) {
           int total = Integer.parseInt(a.get("total_classes"));
           int present = Integer.parseInt(a.get("present_classes"));
           double per = total == 0 ? 0 : (present * 100.0 / total);
      %>
        <tr><td><%= a.get("subject_id") %></td><td><%= total %></td><td><%= present %></td><td><%= String.format("%.1f", per) %>%</td></tr>
      <% } %>
    </tbody>
  </table>

  <div class="section-divider"></div>

  <!-- Student Summary -->
  <h4>🎓 Student Summary</h4>
  <table class="table table-striped">
    <thead><tr><th>ID</th><th>Name</th><th>Present</th><th>Total</th><th>%</th></tr></thead>
    <tbody>
      <% for (Map<String, String> s : studentSummary) {
           int total = Integer.parseInt(s.get("classes"));
           int present = Integer.parseInt(s.get("present"));
           double per = total == 0 ? 0 : (present * 100.0 / total);
      %>
        <tr><td><%= s.get("student_id") %></td><td><%= s.get("name") %></td><td><%= present %></td><td><%= total %></td><td><%= String.format("%.1f", per) %>%</td></tr>
      <% } %>
    </tbody>
  </table>

  <form action="LogoutServlet" method="post" class="mt-3">
    <button type="submit" class="btn btn-light"><i class="fa-solid fa-right-from-bracket"></i> Logout</button>
  </form>
</div>
</div>
</body>
</html>
