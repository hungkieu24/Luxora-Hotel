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
        <form action="forgotPassword" method="post">

            <h3>Forgot Password</h3>
            <label for="email">Enter your email</label>
            <input type="email" placeholder="Email" id="email" name="email"required>
            <button type="submit">Send Verification Code</button>
            <h4><a href="login.jsp">Back to login</a></h4>
        </form>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script>
            var errorMsg = "${error != null ? error : ''}";
            var successMsg = "${success != null ? success : ''}";
            if (errorMsg && errorMsg.trim() !== "") {
                Swal.fire({
                    icon: 'error',
                    title: 'Lỗi',
                    text: errorMsg
                });
            } else if (successMsg && successMsg.trim() !== "") {
                Swal.fire({
                    icon: 'success',
                    title: 'Thành công',
                    text: successMsg
                });
            }
            // Validation phía client
            document.querySelector('form').addEventListener('submit', function (e) {
                var emailInput = document.getElementById('email');
                var email = emailInput.value.trim();
                // Regex kiểm tra định dạng email cơ bản
                var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

                if (email === "") {
                    e.preventDefault();
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: 'Please input mail'
                    });
                    emailInput.focus();
                    return false;
                }
                if (!emailRegex.test(email)) {
                    e.preventDefault();
                    Swal.fire({
                        icon: 'error',
                        title: 'Error',
                        text: 'Email invalid!'
                    });
                    emailInput.focus();
                    return false;
                }
                // Nếu hợp lệ, cho submit form bình thường
            });
        </script>
    </body>
</html>
