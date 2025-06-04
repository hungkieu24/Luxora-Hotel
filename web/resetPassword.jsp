<%-- 
    Document   : resetPassword
    Created on : Jun 1, 2025, 11:02:16 PM
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

    </head>
    <body>
        <style>
            *
            *:before,
            *:after {
                padding: 0;
                margin: 0;
                box-sizing: border-box;
            }

            body {
                background: linear-gradient(rgba(0,0,0,0.5), rgba(0,0,0,0.5)),
                    url('./img/loginBackground.jpg');
                background-size: cover;
                background-position: center;
                background-repeat: no-repeat;
                min-height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;

            }


            .background {
                width: 430px;
                height: 520px;
                position: absolute;
                transform: translate(-50%, -50%);
                left: 50%;
                top: 50%;
            }

            form {
                height: 450px;
                width: 400px;
                background-color: rgba(255, 255, 255, 0.13);
                position: absolute;
                transform: translate(-50%, -50%);
                top: 50%;
                left: 50%;
                border-radius: 10px;
                backdrop-filter: blur(10px);
                border: 2px solid rgba(255, 255, 255, 0.1);
                box-shadow: 0 0 40px rgba(8, 7, 16, 0.6);
                padding: 50px 35px;
            }

            form * {
                font-family: 'Poppins', sans-serif;
                color: #ffffff;
                letter-spacing: 0.5px;
                outline: none;
                border: none;
            }

            form h3 {
                font-size: 32px;
                font-weight: 500;
                line-height: 42px;
                text-align: center;
            }

            label {
                display: block;
                margin-top: 30px;
                font-size: 16px;
                font-weight: 500;
            }

            input {
                display: block;
                height: 50px;
                width: 100%;
                background-color: rgba(255, 255, 255, 0.07);
                border-radius: 3px;
                padding: 0 10px;
                margin-top: 8px;
                font-size: 14px;
                font-weight: 300;
            }

            ::placeholder {
                color: #e5e5e5;
            }

            button {
                margin-top: 10px;
                width: 100%;
                background-color: #ffffff;
                color: #080710;
                padding: 15px 0;
                font-size: 18px;
                font-weight: 600;
                border-radius: 5px;
                cursor: pointer;
            }

        </style>
        <form action="resetPassword" method="post">
            <h3>Reset Password</h3>
            <label for="password">New Password</label>
            <input type="password" placeholder="New password" id="password" name="password" required>
            <label for="confirmPassword">Confirm Password</label>
            <input type="password" placeholder="Confirm Password" id="confirmPassword" name="confirmPassword" required>
            <input type="hidden" name="email" value="${email}">
            <c:if test="${not empty error}">
                <p style="color: red; font-size: 10px">${error}</p>
            </c:if>
            <button type="submit">Reset Password</button>
            <h4><a href="login.jsp">Back to Login</a></h4>
        </form>
    </body>
</html>
