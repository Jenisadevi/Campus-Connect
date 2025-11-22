<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*,com.acadmate.dao.AttendanceDAO" %>

<%
    String name = (String) session.getAttribute("name");
    if (name == null) {
        response.sendRedirect("login.jsp?error=Please+login+first!");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Mark Attendance | AcadMate</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-dark text-light">
  <div class="container mt-5">
    <h2>📋 Mark Attendance</h2>

    <form action="MarkAttendanceServlet" method="post">
      <div class="mb-3">
        <label class="form-label">Student ID</label>
        <input type="number" name="student_id" class="form-control" required>
      </div>

      <div class="mb-3">
        <label class="form-label">Subject ID</label>
        <input type="number" name="subject_id" class="form-control" required>
      </div>

      <div class="mb-3">
        <label class="form-label">Date</label>
        <input type="date" name="date" class="form-control" required>
      </div>

      <div class="mb-3">
        <label class="form-label">Status</label>
        <select name="status" class="form-select">
          <option>Present</option>
          <option>Absent</option>
        </select>
      </div>

      <button type="submit" class="btn btn-primary">Mark Attendance</button>
    </form>
  </div>
</body>
</html>
