<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
  <title>Add Event | AcadMate</title>

  <!-- ✅ Bootstrap + Styling -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="css/style.css" rel="stylesheet">

  <style>
    body.organizer {
      background: linear-gradient(135deg, #f59e0b, #d97706);
      min-height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
    }

    .card {
      background: rgba(255, 255, 255, 0.15);
      border-radius: 16px;
      padding: 30px;
      color: #fff;
      backdrop-filter: blur(8px);
      box-shadow: 0 6px 25px rgba(0, 0, 0, 0.3);
      animation: fadeInUp 0.6s ease-out;
    }

    @keyframes fadeInUp {
      from { opacity: 0; transform: translateY(30px); }
      to { opacity: 1; transform: translateY(0); }
    }

    .btn {
      border-radius: 8px;
      transition: 0.3s ease;
    }

    .btn:hover {
      transform: scale(1.05);
      box-shadow: 0 0 12px rgba(255,255,255,0.5);
    }

    h3 {
      font-weight: 600;
      text-align: center;
      color: #fff;
    }

    .alert {
      border-radius: 8px;
      margin-top: 15px;
      font-weight: 500;
      text-align: center;
    }
  </style>
</head>

<body class="organizer">

  <div class="container">
    <div class="card mx-auto" style="max-width:500px;">
      <h3 class="mb-3"><i class="fa-solid fa-plus-circle"></i> Create New Event</h3>
      <p class="text-light text-center mb-4">Fill in the details below to create a new event.</p>

      <!-- ✅ Event Form -->
      <form action="AddEventServlet" method="post" class="d-grid gap-3">
        <div>
          <label class="form-label fw-semibold text-light">Event Name</label>
          <input type="text" name="event_name" class="form-control" placeholder="Enter event name" required>
        </div>

        <div>
          <label class="form-label fw-semibold text-light">Event Type</label>
          <select name="type" class="form-select" required>
            <option value="">Select Type</option>
            <option value="Cultural">🎭 Cultural</option>
            <option value="Technical">💻 Technical</option>
          </select>
        </div>

        <div>
          <label class="form-label fw-semibold text-light">Event Date</label>
          <input type="date" name="event_date" class="form-control" required>
        </div>

        <button type="submit" class="btn btn-light fw-semibold mt-2">
          <i class="fa-solid fa-check"></i> Add Event
        </button>
        <a href="organizer-dashboard.jsp" class="btn btn-outline-light fw-semibold mt-1">
          <i class="fa-solid fa-arrow-left"></i> Cancel
        </a>
      </form>

      <!-- ✅ Alerts -->
      <% 
         String error = request.getParameter("error");
         String success = request.getParameter("success");
         if(error != null) {
      %>
          <div class="alert alert-danger fade show" role="alert">
            <i class="fa-solid fa-circle-xmark"></i> <%= error %>
          </div>
      <% 
         } else if(success != null) {
      %>
          <div class="alert alert-success fade show" role="alert">
            <i class="fa-solid fa-circle-check"></i> <%= success %>
          </div>
      <% } %>

    </div>
  </div>
</body>
</html>
