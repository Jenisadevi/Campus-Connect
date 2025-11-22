<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.acadmate.dao.TimetableDAO, java.util.*" %>

<!-- ✅ Animated Timetable Section -->
<div class="card mt-5 timetable-section">
  <h3 class="text-center mb-4">
    <i class="fa-solid fa-calendar-days"></i> Weekly Timetable
  </h3>

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
          TimetableDAO tdao = new TimetableDAO();
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

<style>
  /* ✨ Animation + Glow Effects */
  .timetable-section {
    background: rgba(255, 255, 255, 0.1);
    border-radius: 16px;
    padding: 25px;
    box-shadow: 0 6px 25px rgba(0,0,0,0.3);
    animation: fadeInUp 1s ease-out;
  }

  @keyframes fadeInUp {
    from { opacity: 0; transform: translateY(40px); }
    to { opacity: 1; transform: translateY(0); }
  }

  .timetable-row {
    opacity: 0;
    transform: translateX(-50px);
    animation: slideIn 0.8s ease forwards;
  }

  @keyframes slideIn {
    to { opacity: 1; transform: translateX(0); }
  }

  /* Highlight current day dynamically */
  .highlight-today {
    background: linear-gradient(90deg, #4ade80, #22c55e) !important;
    color: #000 !important;
    font-weight: bold;
    transform: scale(1.02);
    transition: all 0.3s ease;
  }
</style>

<script>
  // ✨ Animate rows with delay
  const rows = document.querySelectorAll('.timetable-row');
  rows.forEach((row, index) => {
    row.style.animationDelay = `${index * 0.1}s`;
  });

  // 🌞 Highlight current day automatically
  const todayNames = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
  const today = todayNames[new Date().getDay()];
  rows.forEach(row => {
    if (row.dataset.day === today) {
      row.classList.add('highlight-today');
    }
  });
</script>
