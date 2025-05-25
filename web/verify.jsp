<%-- 
    Document   : verify
    Created on : May 25, 2025, 11:55:42 AM
    Author     : hungk
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Verify</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"/>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;500;600&display=swap"/>
        <link rel="stylesheet" href="./css/registerStyles.css"/>
    </head>
    <body>
        <form action="verifyemail" method="post">
            <h3>Verify your email</h3>
            <p style="text-align: center">We have sent a verification code to your email. Please enter it below to verify your account.</p>
            <div class="form__group">
                <label for="code">Verify Code</label>
                <input type="text" name="code" id="code" placeholder="Enter verify code" required>
            </div>
            <button type="submit">Verify</button>
            <c:if test="${not empty error}">
                <p style="color:red">${error}</p>
            </c:if>
        </form>

    </body>
</html>
