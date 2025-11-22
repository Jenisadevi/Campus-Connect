<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.acadmate.dao.*,java.util.*" %>

<%
String name = (String) session.getAttribute("name");
    String role = (String) session.getAttribute("role");
    if (name == null || !"admin".equals(role)) {
        response.sendRedirect("login.jsp?error=Please+login+as+admin");
        return;
    }

    AdminUserDAO userDAO = new AdminUserDAO();
    TimetableDAO timetableDAO = new TimetableDAO();
    AnnouncementDAO annDAO = new AnnouncementDAO();
    EventDAO eventDAO = new EventDAO();

    List<Map<String, String>> facultyList = userDAO.getAllUsers("faculty");
    List<Map<String, String>> studentList = userDAO.getAllUsers("student");
    List<Map<String, String>> timetable = timetableDAO.getAllTimetable();
    List<Map<String, String>> announcements = annDAO.getAllAnnouncements();
    List<EventDAO.Event> events = eventDAO.getAllEvents();

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin Dashboard | AcadMate</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

  <!-- ULTRA-PREMIUM CAMPUS THEME CSS -->
  <style>
/* 🌟 ULTRA-PREMIUM SUPER-ADMIN CAMPUS THEME — NEXT LEVEL UI 🌟 */

/* ===== BODY WITH 3D PARALLAX BACKGROUND ===== */
body {
  background:
    radial-gradient(circle at top, rgba(255,255,255,0.10), rgba(0,0,0,0.75)),
    linear-gradient(rgba(0,0,0,0.55), rgba(0,0,0,0.72)),
    url('https://images.unsplash.com/photo-1532012197267-da84d127e765?auto=format&fit=crop&w=1920&q=80');
  /* Replace the URL above with your college image if you wish */

  background-size: cover;
  background-position: center;
  background-attachment: scroll;
  min-height: 100vh;
  color: #fff;
  font-family: 'Poppins', sans-serif;
  padding-left: 280px;
  perspective: 1800px;
  animation: fadeBody 1.0s ease both;
  margin: 0;
}

@keyframes fadeBody {
  from { opacity: 0; filter: blur(12px); transform: translateY(6px); }
  to { opacity: 1; filter: blur(0); transform: translateY(0); }
}

/* ===== SUPER-PREMIUM SIDEBAR (3D GLASS PANEL) ===== */
.sidebar {
  height: 100vh;
  width: 280px;
  position: fixed;
  top: 0;
  left: 0;
  background: rgba(4,6,12,0.45);
  backdrop-filter: blur(18px) saturate(160%);
  border-right: 1px solid rgba(255,255,255,0.16);
  box-shadow: 10px 0 40px rgba(0,0,0,0.7);
  transform: translateZ(60px);
  animation: slideSidebar 0.9s ease;
  z-index: 2000;
  display: flex;
  flex-direction: column;
  padding-top: 26px;
}
@keyframes slideSidebar {
  from { transform: translateX(-100%) translateZ(60px); opacity:0; }
  to { transform: translateX(0) translateZ(60px); opacity:1; }
}
.sidebar h2 {
  text-align: center;
  color: #e6eef8;
  margin-bottom: 28px;
  font-weight: 700;
  letter-spacing: 1px;
  font-size: 20px;
  padding: 0 12px;
  text-transform: uppercase;
  text-shadow: 0 0 10px rgba(255,255,255,0.12);
}
.sidebar a {
  display: flex;
  align-items: center;
  padding: 14px 26px;
  gap: 12px;
  font-size: 16px;
  color: #f4f7fb;
  text-decoration: none;
  letter-spacing: 0.5px;
  transition: all 0.22s ease;
  border-left: 3px solid transparent;
}
.sidebar a i { font-size: 18px; opacity: 0.95; }
.sidebar a:hover {
  background: rgba(255,255,255,0.06);
  border-left: 3px solid #60a5fa;
  padding-left: 40px;
  box-shadow: inset 0 0 10px rgba(96,165,250,0.08);
}

/* ===== FLOATING NAVBAR ===== */
.navbar-custom {
  background: rgba(0,0,0,0.35);
  backdrop-filter: blur(14px) saturate(160%);
  padding: 12px 30px;
  border-bottom: 1px solid rgba(255,255,255,0.12);
  position: sticky;
  top: 0;
  margin-left: 280px;
  z-index: 1500;
  box-shadow: 0 8px 30px rgba(0,0,0,0.45);
  display: flex;
  align-items: center;
  gap: 14px;
}
#toggleSidebar {
  font-size: 22px;
  cursor: pointer;
  color: #e6eef8;
  transition: .28s;
}
#toggleSidebar:hover { color: #60a5fa; transform: scale(1.08); }
.navbar-custom h3 {
  font-size: 22px;
  font-weight: 600;
  color: #f1f7fb;
  text-shadow: 0 0 10px rgba(255,255,255,0.06);
  margin: 0;
}

/* ===== SUPER-GLASS SECTIONS ===== */
.section-card {
  background: rgba(255,255,255,0.12);
  border-radius: 18px;
  padding: 28px;
  margin-top: 28px;
  backdrop-filter: blur(18px) saturate(160%);
  border: 1px solid rgba(255,255,255,0.16);
  box-shadow: 0 20px 60px rgba(0,0,0,0.55);
  transform: translateZ(40px);
}

/* ===== Typography & Icons ===== */
h3 { letter-spacing: .5px; margin-bottom: 14px; }
h3 i {
  margin-right: 8px;
  font-size: 20px;
  color: #93c5fd;
  filter: drop-shadow(0 0 10px #38bdf8);
}

/* ===== Forms & Buttons ===== */
.form-label { color: #e6eef8; font-weight: 600; }
.btn { border-radius: 12px; font-weight: 600; letter-spacing: 0.4px; }
.btn-success { background:#22c55e; border:none; }
.btn-primary { background:#60a5fa; border:none; }
.btn-warning { background:#f59e0b; border:none; color:#000; }
.btn-danger  { background:#ef4444; border:none; }
.btn-light   { background:#f8fafc; color:#000; }

/* ===== Tables ===== */
.table { color:#fff; margin-bottom: 0; }
th {
  background: rgba(9,10,20,0.85);
  backdrop-filter: blur(8px);
  font-weight: 700;
  text-transform: uppercase;
  font-size: 13px;
  letter-spacing: .8px;
}
td {
  background: rgba(255,255,255,0.06);
  backdrop-filter: blur(6px);
  padding: 12px;
  vertical-align: middle;
}

/* ===== Weekly Timetable ===== */
.timetable-section {
  background: rgba(255,255,255,0.14);
  border-radius: 22px;
  padding: 28px;
  backdrop-filter: blur(22px);
  box-shadow: 0 18px 60px rgba(0,0,0,0.55);
  transform: translateZ(60px);
}
.timetable-row {
  opacity: 0;
  transform: translateX(-50px);
  animation: rowShow 0.7s ease forwards;
}
@keyframes rowShow { from { opacity:0; transform:translateX(-50px);} to { opacity:1; transform:translateX(0);} }
.highlight-today {
  background: linear-gradient(90deg,#4ade80,#22c55e) !important;
  color:#000 !important;
  border-radius: 8px;
  font-weight: 700;
  box-shadow: 0 0 12px rgba(34,197,94,0.7);
  transform: scale(1.04);
}

/* ===== Alerts ===== */
.alert {
  backdrop-filter: blur(10px);
  border-radius: 12px;
  border: 1px solid rgba(255,255,255,0.28);
  font-weight: 600;
  box-shadow: 0 8px 30px rgba(0,0,0,0.45);
  margin-top: 18px;
}

/* ===== Responsive tweaks ===== */
@media (max-width: 991px) {
  body { padding-left: 0; }
  .navbar-custom { margin-left: 0; }
  .sidebar { position: relative; width: 100%; height: auto; display: flex; flex-wrap: wrap; padding: 12px; }
  .sidebar a { display:inline-flex; padding: 8px 12px; }
}
  </style>
</head>

<body>
  <!-- SIDEBAR -->
  <div class="sidebar" id="sidebar">
    <h2><i class="fa-solid fa-school"></i> AcadMate</h2>
    <a href="#users"><i class="fa-solid fa-users"></i> Manage Users</a>
    <a href="#timetable"><i class="fa-solid fa-calendar-days"></i> Timetable</a>
    <a href="#announce"><i class="fa-solid fa-bullhorn"></i> Announcements</a>
    <a href="#weekly"><i class="fa-solid fa-calendar-week"></i> Weekly Timetable</a>
    <a href="#events"><i class="fa-solid fa-calendar-check"></i> Event Approvals</a>
    <a href="LogoutServlet"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
  </div>

  <!-- NAVBAR -->
  <nav class="navbar-custom d-flex align-items-center">
    <span id="toggleSidebar"><i class="fa-solid fa-bars"></i></span>
    <h3>AcadMate Admin Panel</h3>
  </nav>

  <!-- MAIN CONTENT -->
  <div class="container py-4">

    <h2 class="text-center mb-3"><i class="fa-solid fa-crown"></i> Admin Dashboard – Welcome, <%=name%> 👑</h2>

    <%
    if (success != null) {
    %>
      <div class="alert alert-success text-center"><%=success%></div>
    <%
    } else if (error != null) {
    %>
      <div class="alert alert-danger text-center"><%=error%></div>
    <%
    }
    %>

    <!-- ======================= USERS MANAGEMENT ======================= -->
    <div class="section-card" id="users">
      <h3><i class="fa-solid fa-users"></i> Manage Users</h3>

      <form action="AddUserServlet" method="post" class="row g-3 mt-2">
        <div class="col-md-3">
          <input type="text" name="name" class="form-control" placeholder="Full Name" required>
        </div>
        <div class="col-md-3">
          <input type="email" name="email" class="form-control" placeholder="Email" required>
        </div>
        <div class="col-md-2">
          <input type="password" name="password" class="form-control" placeholder="Password" required>
        </div>
        <div class="col-md-2">
          <select name="role" class="form-select">
            <option value="faculty">Faculty</option>
            <option value="student">Student</option>
          </select>
        </div>
        <div class="col-md-2">
          <button type="submit" class="btn btn-success w-100"><i class="fa-solid fa-user-plus"></i> Add</button>
        </div>
      </form>

      <!-- Faculty Table -->
      <h5 class="mt-4">Faculty List</h5>
      <div class="table-responsive">
        <table class="table table-bordered table-striped">
          <thead><tr><th>ID</th><th>Name</th><th>Email</th></tr></thead>
          <tbody>
            <%
            if (facultyList.isEmpty()) {
            %>
              <tr><td colspan="3" class="text-center">No faculty found.</td></tr>
            <%
            } else {
                             for (Map<String, String> f : facultyList) {
            %>
              <tr><td><%=f.get("id")%></td><td><%=f.get("name")%></td><td><%=f.get("email")%></td></tr>
            <%
            } }
            %>
          </tbody>
        </table>
      </div>

      <!-- Student Table -->
      <h5 class="mt-4">Student List</h5>
      <div class="table-responsive">
        <table class="table table-bordered table-striped">
          <thead><tr><th>ID</th><th>Name</th><th>Email</th></tr></thead>
          <tbody>
            <%
            if (studentList.isEmpty()) {
            %>
              <tr><td colspan="3" class="text-center">No students found.</td></tr>
            <%
            } else {
                             for (Map<String, String> s : studentList) {
            %>
              <tr><td><%=s.get("id")%></td><td><%=s.get("name")%></td><td><%=s.get("email")%></td></tr>
            <%
            } }
            %>
          </tbody>
        </table>
      </div>
    </div>

    <!-- ======================= TIMETABLE MANAGEMENT ======================= -->
    <div class="section-card" id="timetable">
      <h3><i class="fa-solid fa-calendar-days"></i> Manage Timetable</h3>

      <form action="${pageContext.request.contextPath}/AddTimetableServlet" method="post" class="row g-3 align-items-center mt-2">
        <div class="col-md-2">
          <select name="day" class="form-select" required>
            <option>Monday</option><option>Tuesday</option><option>Wednesday</option>
            <option>Thursday</option><option>Friday</option><option>Saturday</option>
          </select>
        </div>
        <div class="col-md-2">
          <input type="text" name="subject" class="form-control" placeholder="Subject" required>
        </div>
        <div class="col-md-2">
          <select name="faculty_id" class="form-select" required>
            <option value="">Select Faculty</option>
            <%
            for (Map<String,String> f : facultyList) {
            %>
              <option value="<%=f.get("id")%>"><%=f.get("name")%></option>
            <%
            }
            %>
          </select>
        </div>
        <div class="col-md-2">
          <input type="time" name="start_time" class="form-control" required>
        </div>
        <div class="col-md-2">
          <input type="time" name="end_time" class="form-control" required>
        </div>
        <div class="col-md-2">
          <input type="text" name="class_name" class="form-control" placeholder="Class" required>
        </div>
        <div class="col-12 text-end mt-2">
          <button class="btn btn-primary"><i class="fa-solid fa-plus"></i> Add Slot</button>
        </div>
      </form>

      <div class="table-responsive mt-3">
        <table class="table table-bordered table-striped">
          <thead><tr><th>Day</th><th>Subject</th><th>Faculty</th><th>Time</th><th>Class</th></tr></thead>
          <tbody>
            <%
            if (timetable.isEmpty()) {
            %>
              <tr><td colspan="5" class="text-center">No timetable entries yet.</td></tr>
            <%
            } else {
                             for (Map<String,String> t : timetable) {
            %>
              <tr><td><%=t.get("day")%></td><td><%=t.get("subject")%></td><td><%=t.get("faculty")%></td><td><%=t.get("time")%></td><td><%=t.get("class")%></td></tr>
            <%
            } }
            %>
          </tbody>
        </table>
      </div>
    </div>

    <!-- ======================= ANNOUNCEMENTS ======================= -->
    <div class="section-card" id="announce">
      <h3><i class="fa-solid fa-bullhorn"></i> Announcements</h3>

      <form action="AddAnnouncementServlet" method="post" class="row g-3 mt-2">
        <div class="col-md-3">
          <input type="text" name="title" class="form-control" placeholder="Title" required>
        </div>
        <div class="col-md-7">
          <input type="text" name="message" class="form-control" placeholder="Message" required>
        </div>
        <div class="col-md-2">
          <button class="btn btn-warning w-100"><i class="fa-solid fa-bullhorn"></i> Post</button>
        </div>
      </form>

      <ul class="list-group list-group-flush mt-3">
        <%
        if (announcements.isEmpty()) {
        %>
          <li class="list-group-item bg-transparent text-light">No announcements yet.</li>
        <%
        } else {
                     for (Map<String,String> a : announcements) {
        %>
          <li class="list-group-item bg-transparent text-light">
            <strong><%=a.get("title")%>:</strong> <%=a.get("message")%>
            <small class="text-muted"> (Posted on: <%=a.get("created_at")%>)</small>
          </li>
        <%
        } }
        %>
      </ul>
    </div>

    <!-- ======================= WEEKLY TIMETABLE (Animated) ======================= -->
    <div class="timetable-section" id="weekly">
      <h3 class="text-center mb-4"><i class="fa-solid fa-calendar-days"></i> Weekly Timetable</h3>

      <div class="table-responsive">
        <table class="table table-striped table-hover align-middle text-center" id="timetableTable">
          <thead class="table-primary">
            <tr>
              <th>Day</th>
              <th>Subject</th>
              <th>Faculty ID</th>
              <th>Start</th>
              <th>End</th>
              <th>Class</th>
            </tr>
          </thead>
          <tbody>
            <%
            com.acadmate.dao.TimetableDAO tdao = new com.acadmate.dao.TimetableDAO();
                          List<Map<String, String>> slots = tdao.getAllTimetable();

                          if (slots.isEmpty()) {
            %>
              <tr>
                <td colspan="6" class="text-center text-light">No timetable slots added yet.</td>
              </tr>
            <%
              } else {
                  for (Map<String, String> slot : slots) {
            %>
              <tr class="timetable-row" data-day="<%= slot.get("day_of_week") %>">
                <td><%= slot.get("day_of_week") %></td>
                <td><%= slot.get("subject") %></td>
                <td><%= slot.get("faculty_id") %></td>
                <td><%= slot.get("start_time") %></td>
                <td><%= slot.get("end_time") %></td>
                <td><%= slot.get("class_name") %></td>
              </tr>
            <%
                  }
              }
            %>
          </tbody>
        </table>
      </div>
    </div>

    <!-- ======================= EVENT APPROVALS ======================= -->
    <div class="section-card" id="events">
      <h3><i class="fa-solid fa-calendar-check"></i> Event Approvals</h3>
      <div class="table-responsive">
        <table class="table table-striped mt-3">
          <thead><tr><th>ID</th><th>Name</th><th>Type</th><th>Date</th><th>Status</th><th>Action</th></tr></thead>
          <tbody>
            <% if (events.isEmpty()) { %>
              <tr><td colspan="6" class="text-center">No events found.</td></tr>
            <% } else {
                 for (EventDAO.Event e : events) { 
                    boolean pending = "pending".equalsIgnoreCase(e.getStatus());
            %>
              <tr>
                <td><%= e.getId() %></td><td><%= e.getName() %></td><td><%= e.getType() %></td><td><%= e.getDate() %></td>
                <td><%= e.getStatus() %></td>
                <td>
                  <!-- Note: Buttons remain visible, but become disabled (OFF mode) when not pending -->

                  <form action="AdminEventServlet" method="post" class="d-inline">
                    <input type="hidden" name="event_id" value="<%= e.getId() %>">
                    <button 
                      name="action" 
                      value="approve" 
                      class="btn btn-success btn-sm"
                      <%= pending ? "" : "disabled style='opacity:0.5; cursor:not-allowed;'" %>>
                      Approve
                    </button>
                  </form>

                  <form action="AdminEventServlet" method="post" class="d-inline">
                    <input type="hidden" name="event_id" value="<%= e.getId() %>">
                    <button 
                      name="action" 
                      value="reject" 
                      class="btn btn-danger btn-sm"
                      <%= pending ? "" : "disabled style='opacity:0.5; cursor:not-allowed;'" %>>
                      Reject
                    </button>
                  </form>
                </td>
              </tr>
            <% } } %>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Logout -->
    <form action="LogoutServlet" method="post" class="text-center mt-4">
      <button class="btn btn-light"><i class="fa-solid fa-right-from-bracket"></i> Logout</button>
    </form>

  </div> <!-- container -->

  <!-- SCRIPTS -->
  <script>
    // Sidebar toggle
    (function() {
      const sidebar = document.getElementById('sidebar');
      const toggle = document.getElementById('toggleSidebar');
      const navbar = document.querySelector('.navbar-custom');
      toggle.addEventListener('click', () => {
        if (sidebar.style.marginLeft === "-280px") {
          sidebar.style.marginLeft = "0";
          document.body.style.paddingLeft = "280px";
          if (navbar) navbar.style.marginLeft = "280px";
        } else {
          sidebar.style.marginLeft = "-280px";
          document.body.style.paddingLeft = "0";
          if (navbar) navbar.style.marginLeft = "0";
        }
      });
    })();

    // Animate weekly timetable rows & highlight current day
    document.addEventListener('DOMContentLoaded', function() {
      const rows = document.querySelectorAll('.timetable-row');
      rows.forEach((row, index) => {
        row.style.animationDelay = `${index * 0.08}s`;
      });

      const todayNames = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
      const today = todayNames[new Date().getDay()];
      rows.forEach(row => {
        if (row.dataset.day === today) {
          row.classList.add('highlight-today');
        }
      });
    });
  </script>

</body>
</html>
