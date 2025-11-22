<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.acadmate.dao.EventDAO, java.util.*" %>

<%
String name = (String) session.getAttribute("name");
    if (name == null) {
        response.sendRedirect("login.jsp?error=Please+login+first!");
        return;
    }

    EventDAO dao = new EventDAO();
    List<EventDAO.Event> events = dao.getUpcomingEvents();

    Map<Integer, Integer> registrationCounts = new HashMap<>();
    try (java.sql.Connection con = com.acadmate.util.DBUtil.getConnection();
         java.sql.PreparedStatement ps = con.prepareStatement(
            "SELECT event_id, COUNT(*) AS count FROM registrations GROUP BY event_id");
         java.sql.ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            registrationCounts.put(rs.getInt("event_id"), rs.getInt("count"));
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Organizer Dashboard | Event Control Center 🎤✨</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

<style>

/* 🌟 FULL VISIBLE PARTY BACKDROP */
body.organizer {
  background:
    linear-gradient(rgba(0,0,0,0.15), rgba(0,0,0,0.45)),
    url('https://images.unsplash.com/photo-1507874457470-272b3c8d8ee2?auto=format&fit=crop&w=1400&q=80');

  background-size: cover;
  background-position: center top;
  background-attachment: fixed;

  min-height: 100vh;
  padding: 40px;

  display: flex;
  justify-content: center;
  align-items: flex-start;

  color: #fff;
}

/* 🌟 TEXT ALWAYS VISIBLE */
body.organizer * {
  color: #fff !important;
  text-shadow: 0 0 6px rgba(0,0,0,1);
}

/* 🌟 MAIN CARD */
.card {
  background: rgba(0,0,0,0.55);
  backdrop-filter: blur(16px);
  border-radius: 22px;
  padding: 35px;
  max-width: 900px;
  width: 100%;
  margin-top: 40px;

  box-shadow: 0 10px 35px rgba(0,0,0,1);
  position: relative;
}

.card::before {
  content: "";
  position: absolute;
  top: -6px; bottom: -6px; left: -6px; right: -6px;
  background: linear-gradient(135deg, rgba(255,0,150,0.6), rgba(0,120,255,0.6));
  filter: blur(20px);
  border-radius: 26px;
  z-index: -1;
}

/* 🌟 EVENT ITEM */
.event-item {
  background: rgba(0,0,0,0.45);
  padding: 14px;
  margin-bottom: 14px;
  border-radius: 12px;
  border: 1px solid rgba(255,255,255,0.3);

  display: flex;
  justify-content: space-between;
  align-items: center;

  transition: 0.3s ease;
}

.event-item:hover {
  background: rgba(0,0,0,0.70);
  transform: scale(1.03);
}

/* VIEW BUTTON */
.btn-view {
  background: rgba(255,255,255,0.20);
  border: 1px solid rgba(255,255,255,0.4);
  padding: 6px 14px;
  border-radius: 8px;
  color: #fff !important;
}

.btn-view:hover {
  background: rgba(255,255,255,0.35);
  transform: scale(1.07);
}

/* ADD EVENT BUTTON */
.btn-light {
  background: linear-gradient(90deg, #ff66c4, #ffd645);
  color: #000 !important;
  font-weight: bold;
  border-radius: 10px;
}

</style>
</head>

<body class="organizer">

<div class="card">

    <h2 class="mb-2"><i class="fa-solid fa-calendar-days"></i> Event Organizer Panel 🎤✨</h2>
    <p>Welcome, <strong><%= name %></strong>.</p>

    <div class="text-end mb-3">
      <a href="add-event.jsp" class="btn btn-light">
        <i class="fa-solid fa-plus"></i> Add New Event
      </a>
    </div>

    <h4>🎪 Upcoming Events</h4>

    <% if (events.isEmpty()) { %>
      <p>No events added yet.</p>
    <% } else { 
         for (EventDAO.Event e : events) { 
         int count = registrationCounts.getOrDefault(e.getId(), 0);
    %>

      <div class="event-item">
        <span>
          <i class="fa-solid <%= e.getType().equals("Cultural") ? "fa-masks-theater" : "fa-laptop-code" %>"></i>
          <strong> <%= e.getName() %> </strong> — <%= e.getType() %> | <%= e.getDate() %>
        </span>

        <span>
          <%= count %> Registered
          <button class="btn-view"
                  data-bs-toggle="modal"
                  data-bs-target="#viewModal"
                  onclick="loadRegistrations(<%= e.getId() %>, '<%= e.getName() %>')">
            View
          </button>
        </span>
      </div>

    <% } } %>

</div>

</body>
</html>
