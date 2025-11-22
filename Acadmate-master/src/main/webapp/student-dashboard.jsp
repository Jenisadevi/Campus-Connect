<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.acadmate.dao.EventDAO,com.acadmate.util.DBUtil, java.util.*, java.sql.*" %>

<%
    String name = (session != null) ? (String) session.getAttribute("name") : null;
    String role = (session != null) ? (String) session.getAttribute("role") : null;
    Integer studentId = (Integer) session.getAttribute("user_id");

    if (name == null || !"student".equals(role)) {
        response.sendRedirect("login.jsp?error=Please+login+as+student");
        return;
    }

    EventDAO dao = new EventDAO();
    List<EventDAO.Event> events = dao.getApprovedEvents();

    String success = request.getParameter("success");
    String error = request.getParameter("error");

    // Attendance retrieval (unchanged)
    List<Map<String, String>> attendanceSummary = new ArrayList<>();
    try (Connection con = DBUtil.getConnection()) {

        String sql = "SELECT subject_id, " +
                     "COUNT(*) AS total_classes, " +
                     "SUM(CASE WHEN status='Present' THEN 1 ELSE 0 END) AS attended_classes " +
                     "FROM attendance " +
                     "WHERE student_id = ? " +
                     "GROUP BY subject_id";

        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, studentId);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, String> record = new HashMap<>();
            int total = rs.getInt("total_classes");
            int attended = rs.getInt("attended_classes");
            double percent = (total == 0) ? 0.0 : (attended * 100.0 / total);

            record.put("subject_id", String.valueOf(rs.getInt("subject_id")));
            record.put("percentage", String.format("%.1f", percent));

            attendanceSummary.add(record);
        }

        rs.close();
        ps.close();

    } catch (SQLException e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Student Dashboard | AcadMate — Grand Library Mode</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

<style>
/* ---------------------------
   GRAND LIBRARY + STUDENTS EPIC
   Cinematic, dramatic, film-grain + glassmorphism
   Backend unchanged — UI only
   --------------------------- */

/* full-page cinematic background (library interior, epic lighting) */
:root{
  --glass-bg: rgba(255,255,255,0.08);
  --glass-border: rgba(255,255,255,0.14);
  --accent: #FFD166; /* warm golden accent for library lighting */
  --accent-2: #60A5FA; /* subtle blue balance */
}

html,body{
  height:100%;
  margin:0;
  padding:0;
  font-family: 'Poppins', sans-serif;
  -webkit-font-smoothing:antialiased;
  -moz-osx-font-smoothing:grayscale;
  background-color:#0b1220;
}

/* Cinematic layered background:
   - dramatic radial spotlight
   - dark linear overlay
   - large library hero image (Unsplash)
   - subtle parallax via background-attachment fixed
*/
body{
  background:
    radial-gradient(circle at 20% 20%, rgba(255,240,200,0.06), rgba(0,0,0,0) 30%),
    linear-gradient(180deg, rgba(0,0,0,0.55), rgba(0,0,0,0.75)),
    url('https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?auto=format&fit=crop&w=1800&q=80');
  background-size: cover;
  background-position: center 35%;
  background-attachment: fixed;
  color: #f8fafc;
  display:flex;
  align-items:center;
  justify-content:center;
  padding:48px;
  overflow-y:auto;
}

/* film-grain overlay (pseudo element) */
body::before{
  content:"";
  pointer-events:none;
  position:fixed;
  inset:0;
  background-image: linear-gradient(transparent, rgba(0,0,0,0.12));
  mix-blend-mode:multiply;
  opacity:0.45;
  z-index:0;
}

/* subtle vignette */
body::after{
  content:"";
  pointer-events:none;
  position:fixed;
  inset:0;
  background: radial-gradient(ellipse at center, rgba(0,0,0,0) 30%, rgba(0,0,0,0.55) 80%);
  z-index:0;
}

/* container: elevated glass card centered */
.container-main {
  position:relative;
  z-index:5; /* above bg overlays */
  width:100%;
  max-width:1000px;
  margin: 24px;
}

/* BIG cinematic glass card */
.hero-card {
  border-radius: 20px;
  padding: 36px;
  background: linear-gradient(180deg, rgba(255,255,255,0.06), rgba(255,255,255,0.02));
  border: 1px solid var(--glass-border);
  backdrop-filter: blur(14px) saturate(140%);
  box-shadow: 0 30px 80px rgba(3,7,18,0.7), inset 0 1px 0 rgba(255,255,255,0.03);
  transform: translateY(0);
  transition: transform .35s ease;
}

/* headline + subheading big, cinematic */
.header-row {
  display:flex;
  align-items:center;
  gap:18px;
  margin-bottom:12px;
}
.header-row .title {
  font-size:28px;
  font-weight:700;
  letter-spacing:0.3px;
}
.header-row .subtitle {
  color: rgba(255,255,255,0.85);
  font-weight:500;
  font-size:14px;
}

/* golden decorative line under heading */
.header-line{
  height:4px;
  width:140px;
  border-radius:4px;
  background: linear-gradient(90deg, rgba(255,209,102,1), rgba(137,102,255,0.18));
  box-shadow: 0 6px 18px rgba(255,209,102,0.14);
  margin:16px 0 22px 0;
}

/* grid layout: big left area (attendance) + right pane (events + actions) on wide screens */
.content-grid {
  display:grid;
  grid-template-columns: 1fr 420px;
  gap:28px;
  align-items:start;
}

/* mobile fallback */
@media (max-width: 980px){
  .content-grid { grid-template-columns: 1fr; }
}

/* Attendance panel — large, with epic circles */
.attendance-panel {
  padding:20px;
  border-radius:14px;
  background: linear-gradient(180deg, rgba(255,255,255,0.03), rgba(255,255,255,0.02));
  border: 1px solid rgba(255,255,255,0.06);
  box-shadow: 0 10px 30px rgba(0,0,0,0.5);
}

/* big title */
.attendance-panel h3 { margin: 0 0 12px 0; font-size:18px; color:#fff; }

/* fancy grid for circles (bigger & grand) */
.dashboard-grid {
  display:grid;
  grid-template-columns: repeat(auto-fit, minmax(170px, 1fr));
  gap:26px;
  margin-top:18px;
}

/* GRAND attendance circle */
.circle {
  width: 170px;
  height: 170px;
  border-radius:50%;
  display:flex;
  align-items:center;
  justify-content:center;
  color:#fff;
  font-weight:800;
  font-size:1.5rem;
  position:relative;
  transition: transform .36s cubic-bezier(.2,.9,.3,1), box-shadow .36s;
  box-shadow: 0 14px 40px rgba(2,6,23,0.6), inset 0 -10px 30px rgba(255,255,255,0.03);
  background: conic-gradient(var(--color) calc(var(--percent)*1%), rgba(255,255,255,0.18) 0%);
  border: 2px solid rgba(255,255,255,0.06);
}

/* inner glow ring */
.circle::after{
  content:"";
  position:absolute;
  inset:6px;
  border-radius:50%;
  box-shadow: 0 8px 30px rgba(0,0,0,0.6), 0 0 40px rgba(255,255,255,0.02) inset;
  pointer-events:none;
}

/* label below circle */
.circle span { position:absolute; bottom:-36px; font-size:1rem; color:rgba(255,255,255,0.95); }

/* hover pop */
.circle:hover{
  transform: translateY(-10px) scale(1.06);
  box-shadow: 0 26px 70px rgba(0,0,0,0.7), 0 0 30px rgba(255,255,255,0.03) inset;
}

/* right column - events + quick actions */
.side-panel {
  display:flex;
  flex-direction:column;
  gap:18px;
}

/* events list - cinematic cards */
.events {
  padding:18px;
  border-radius:12px;
  background: linear-gradient(180deg, rgba(255,255,255,0.03), rgba(255,255,255,0.02));
  border: 1px solid rgba(255,255,255,0.06);
  box-shadow: 0 12px 26px rgba(0,0,0,0.5);
}

/* big event title */
.events h4 { margin:0 0 12px 0; font-weight:700; }

/* each event item */
.event-item {
  display:flex;
  align-items:center;
  justify-content:space-between;
  gap:12px;
  padding:12px;
  border-radius:10px;
  background: linear-gradient(90deg, rgba(255,255,255,0.02), rgba(255,255,255,0.01));
  border: 1px solid rgba(255,255,255,0.03);
  transition: transform .18s, background .18s;
}
.event-item:hover{
  background: linear-gradient(90deg, rgba(255,255,255,0.04), rgba(255,255,255,0.02));
  transform: translateY(-6px);
}

/* event meta */
.event-item .meta { color: rgba(255,255,255,0.9); font-weight:600; }

/* golden register button */
.btn-register {
  background: linear-gradient(180deg, var(--accent), #f2a900);
  color:#000;
  padding:8px 14px;
  border-radius:10px;
  border: none;
  font-weight:700;
  letter-spacing: .3px;
  box-shadow: 0 8px 26px rgba(245,166,35,0.18);
  transition: transform .18s, box-shadow .18s;
}
.btn-register:hover{
  transform: translateY(-4px) scale(1.03);
  box-shadow: 0 18px 48px rgba(245,166,35,0.26);
}

/* small utilities row */
.utils {
  display:flex;
  gap:12px;
  margin-top:8px;
  align-items:center;
}

/* fancy logout */
.btn-logout {
  background: transparent;
  color: #fff;
  border: 1px solid rgba(255,255,255,0.08);
  padding:10px 14px;
  border-radius:10px;
  transition: .2s;
}
.btn-logout:hover{
  background: rgba(255,255,255,0.06);
  transform: translateY(-4px);
}

/* footer small note */
.footer-note {
  margin-top:20px;
  color: rgba(255,255,255,0.65);
  font-size:13px;
}

/* responsive tweaks */
@media (max-width: 980px){
  .dashboard-grid { grid-template-columns: repeat(auto-fit, minmax(140px,1fr)); gap:18px; }
  .circle { width:140px; height:140px; font-size:1.25rem; }
  .content-grid { grid-template-columns: 1fr; }
  .side-panel { order: 2; }
  .attendance-panel { order: 1; }
}

/* small cinematic accent lines */
.accent-glow {
  height:8px;
  width:100%;
  border-radius:6px;
  background: linear-gradient(90deg, rgba(255,209,102,0.95), rgba(96,165,250,0.5));
  box-shadow: 0 8px 24px rgba(96,165,250,0.06);
  margin:12px 0 18px 0;
}
</style>
</head>

<body>
  <div class="container-main">
    <div class="hero-card" role="main">
      <div class="header-row">
        <div>
          <div class="title">Welcome, <span style="color:var(--accent);"><%= name %></span></div>
          <div class="subtitle">Student Dashboard — Attendance & Events (Epic Library)</div>
        </div>
        <div style="margin-left:auto; text-align:right;">
          <div style="font-weight:700; color:rgba(255,255,255,0.85);">AcadMate</div>
          <div style="font-size:12px; color:rgba(255,255,255,0.7);">Powered by your campus</div>
        </div>
      </div>

      <div class="header-line"></div>

      <% if(success != null){ %>
        <div class="alert alert-success"><%= success %></div>
      <% } else if(error != null){ %>
        <div class="alert alert-danger"><%= error %></div>
      <% } %>

      <div class="content-grid">
        <!-- LEFT: Attendance big panel -->
        <div class="attendance-panel">
          <h3><i class="fa-solid fa-chart-pie"></i> Attendance Overview</h3>
          <p style="margin:6px 0 12px 0; color:rgba(255,255,255,0.85);">Live percentages per subject — stay on top of your classes.</p>

          <div class="dashboard-grid">
            <% if (attendanceSummary.isEmpty()) { %>
              <div style="grid-column:1/-1; text-align:center; color:rgba(255,255,255,0.85); padding:20px 0;">No attendance records yet.</div>
            <% } else {
                 String[] colors = {"#FFD166","#60A5FA","#34D399","#F87171","#A78BFA","#06B6D4"};
                 int i = 0;
                 for (Map<String, String> a : attendanceSummary) {
                     double percent = Double.parseDouble(a.get("percentage"));
                     String color = colors[i % colors.length];
            %>

              <div class="circle" style="--percent:<%= percent %>; --color:<%= color %>;">
                <%= a.get("percentage") %>%
                <span>Sub <%= a.get("subject_id") %></span>
              </div>

            <% i++; } } %>
          </div>

          <div class="footer-note">Tip: Click on an attendance circle to focus (visual only).</div>
        </div>

        <!-- RIGHT: Events + actions -->
        <aside class="side-panel">
          <div class="events">
            <h4><i class="fa-solid fa-calendar-days"></i> Approved Events</h4>

            <% if (events.isEmpty()) { %>
              <div style="color:rgba(255,255,255,0.85); padding:10px 0;">No approved events available.</div>
            <% } else {
                 for (EventDAO.Event e : events) { %>

              <div class="event-item">
                <div class="meta">
                  <i class="fa-solid <%= e.getType().equalsIgnoreCase("Cultural") ? "fa-masks-theater" : "fa-laptop-code" %>"></i>
                  &nbsp;<strong><%= e.getName() %></strong>
                  <div style="font-size:12px; color:rgba(255,255,255,0.75); margin-top:4px;"><%= e.getDate() %></div>
                </div>

                <form action="RegisterEventServlet" method="post">
                  <input type="hidden" name="event_id" value="<%= e.getId() %>">
                  <button class="btn-register" type="submit">Register</button>
                </form>
              </div>

            <% } } %>

            <div class="accent-glow" aria-hidden="true"></div>

            <div style="display:flex; gap:10px; align-items:center; justify-content:space-between;">
              <div style="color:rgba(255,255,255,0.85); font-weight:600;">Quick Actions</div>
              <div style="font-size:12px; color:rgba(255,255,255,0.65);">Campus · Live</div>
            </div>

            <div class="utils" style="margin-top:12px;">
              <form action="LogoutServlet" method="post" style="margin:0;">
                <button class="btn-logout" type="submit"><i class="fa-solid fa-right-from-bracket"></i> Logout</button>
              </form>

              <!-- placeholder for other quick actions -->
              <button class="btn-logout" onclick="alert('Coming Soon — Profile'); return false;">Profile</button>
              <button class="btn-logout" onclick="alert('Coming Soon — Notifications'); return false;">Notices</button>
            </div>

          </div>

          <!-- optional smaller info card -->
          <div style="padding:14px; border-radius:12px; background:linear-gradient(180deg, rgba(255,255,255,0.02), rgba(255,255,255,0.01)); border:1px solid rgba(255,255,255,0.04);">
            <div style="font-weight:700; color:#fff;">Campus Hours</div>
            <div style="font-size:13px; color:rgba(255,255,255,0.78); margin-top:6px;">Library: 8:00 AM — 9:00 PM</div>
            <div style="font-size:13px; color:rgba(255,255,255,0.78); margin-top:6px;">Office: 9:00 AM — 6:00 PM</div>
          </div>

        </aside>
      </div>
    </div>
  </div>

  <!-- small script: visual-only pulse on circles (no backend effects) -->
  <script>
    document.addEventListener('DOMContentLoaded', function(){
      const circles = document.querySelectorAll('.circle');
      circles.forEach((c, idx) => {
        c.addEventListener('click', () => {
          c.style.transition = 'transform .35s';
          c.style.transform = 'scale(1.12) translateY(-10px)';
          setTimeout(()=>{ c.style.transform = ''; }, 400);
        });
      });
    });
  </script>
</body>
</html>
