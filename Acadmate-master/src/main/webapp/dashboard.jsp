<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String name = (session != null) ? (String) session.getAttribute("name") : null;
    if (name == null) {
        response.sendRedirect("login.jsp?error=Please+login+first!");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>AcadMate Dashboard</title>
</head>
<body style="font-family:sans-serif; text-align:center; margin-top:10%;">
    <h2>Welcome, <%= name %> 👋</h2>
    <p>You are successfully logged in to AcadMate.</p>
    <form action="LogoutServlet" method="post">
        <button type="submit">Logout</button>
    </form>
</body>
</html>
