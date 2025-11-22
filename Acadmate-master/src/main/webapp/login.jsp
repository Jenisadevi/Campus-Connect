<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>AcadMate | Login</title>

  <!--  Bootstrap 5 and Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

  <!--  Custom Style -->
  <link href="css/style.css" rel="stylesheet">

  <style>
    /* inline fallback if css/style.css missing */
    body {
      background: linear-gradient(135deg,#e6eef8,#f8fafc);
      font-family: 'Poppins', sans-serif;
      min-height: 100vh;
    }
    .fade-in {
      opacity: 0;
      transform: translateY(20px);
      animation: fadeUp 0.8s ease-out forwards;
    }
    @keyframes fadeUp {
      to { opacity:1; transform:translateY(0); }
    }
  </style>
</head>

<body>
  <!--  Centered Login Card  -->
  <div class="container d-flex justify-content-center align-items-center" style="min-height:100vh;">
    <div class="card p-4 shadow fade-in" style="max-width:420px;width:100%;border-radius:16px;">
      <h3 class="mb-3 text-center fw-bold text-primary">AcadMate</h3>
      <p class="text-center text-muted mb-4">Smart Campus Simplified</p>

      <form action="LoginServlet" method="post" class="d-grid">
        <input class="form-control mb-3" type="email" name="email" placeholder="Enter email" required>
        <input class="form-control mb-3" type="password" name="password" placeholder="Enter password" required>

        <select class="form-select mb-3" name="role" required>
          <option value="">Select Role</option>
          <option value="admin">Admin</option>
          <option value="faculty">Faculty</option>
          <option value="student">Student</option>
          <option value="organizer">Event Organizer</option>
        </select>

        <button class="btn btn-primary fw-semibold py-2" type="submit">
          <i class="fa-solid fa-right-to-bracket"></i>&nbsp;Login
        </button>
      </form>

      <!-- Error Message -->
      <p class="mt-3 text-danger text-center mb-0">
        <% String error=request.getParameter("error");
           if(error!=null && !error.isEmpty()) out.print(error); %>
      </p>
    </div>
  </div>

  <!--  Toast Container -->
  <div class="position-fixed bottom-0 end-0 p-3" style="z-index:11;">
    <div id="logoutToast" class="toast text-bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
      <div class="d-flex">
        <div class="toast-body">Logged out successfully!</div>
        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
      </div>
    </div>
  </div>

  <!-- Bootstrap JS -->
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

  <!-- Toast Trigger -->
  <script>
    const params = new URLSearchParams(window.location.search);
    if (params.get('error') === 'Logged out successfully!') {
      const toast = new bootstrap.Toast(document.getElementById('logoutToast'));
      toast.show();
    }
  </script>
</body>
</html>
