<%-- 
    Document   : forgotPassword
    Created on : Jun 1, 2025, 5:18:45 PM
    Author     : thien
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"/>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;500;600&display=swap"/>
        <link rel="stylesheet" href="./css/forgotPasswordStyles.css"/>
    </head>
    <body>
        <form action="" method="post">

            <h3>Forgot Password</h3>
            <label for="email">Enter your email</label>
            <input type="email" placeholder="Email" id="emial" name="email"required>
            <c:if test="${not empty error}">
                <p stype="color:red; font-size: 10px">${error}</p>
            </c:if>
                <button type="submit">Send Verification Code</button>
                <h4><a href="login.jsp">Back to login</a></h4>
        </form>
    </body>
</html>
