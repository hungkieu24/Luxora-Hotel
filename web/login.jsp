<%-- 
    Document   : login
    Created on : May 24, 2025, 10:00:32 PM
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
        <link rel="stylesheet" href="./css/loginStyles.css"/>
    </head>
    <body>
        <form action="login" method="post">

            <h3>Login here</h3>
            <label for="username">User name</label>
            <input type="text" placeholder="Username" id="username" name="username" required>

            <label for="password"> Password</label>
            <input type="password" placeholder="Password" id="password" name="password" required> 

            <div class="forgot-password">
                <a href="#">Forgot Password?</a>
            </div>
            <c:if test="${not empty error}">
                <p style="color: red; font-size: 10px">${error}</p>
            </c:if>
            <button>Log In</button>
            <div class="bottom-row">
                <div class="social">
                    <a href="#">
                        <div class="go"><i class="fab fa-google"></i> Google</div>
                    </a>
                </div>
                <div class="register-text">
                   You don't have an account? <a href="#">Register</a>
                </div>
            </div>
        </form>
    </body>
</html>
