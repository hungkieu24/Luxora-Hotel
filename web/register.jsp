<%-- 
    Document   : register
    Created on : May 25, 2025, 9:15:28 AM
    Author     : hungk
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register</title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"/>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;500;600&display=swap"/>
        <link rel="stylesheet" href="./css/registerStyles.css"/>
    </head>
    <body>
        <c:if test="${not empty sessionScope.message}">
            <div id="toastMessage" class="toast-message ${sessionScope.messageType}">
                <c:choose>
                    <c:when test="${sessionScope.messageType == 'success'}">
                        <i class="fa fa-check-circle"></i>
                    </c:when>
                    <c:when test="${sessionScope.messageType == 'error'}">
                        <i class="fa fa-times-circle"></i>
                    </c:when>
                </c:choose>
                ${sessionScope.message}
            </div>

            <!-- Xóa message sau khi hiển thị -->
            <c:remove var="message" scope="session" />
            <c:remove var="messageType" scope="session" />
        </c:if>
        <form action="register" method="post" id="form-register" style="height: 550px">

            <div style="text-align: center; font-size: 28px; font-weight: 600; margin: 0;">Register</div>
            <div class="form__group">
                <div class="form__flex">
                    <label for="username">User name</label>
                    <input type="text" placeholder="Username" id="username" name="username" required>
                </div>
                <p class="form__error username__error"></p>
            </div>
            <div class="form__group">
                <div class="form__flex">
                    <label for="phone">Phone</label>
                    <input type="text" placeholder="Phone number" id="phone" name="phone" required>
                </div>
                <p class="form__error username__error"></p>
            </div>

            <div class="form__group">
                <div class="form__flex">
                    <label for="email">Email</label>
                    <input type="email" placeholder="Email" id="email" name="email" required> 
                </div>
                <p class="form__error username__error"></p>
            </div>

            <div class="form__group">
                <div class="form__flex">
                    <label for="password">Password</label>
                    <input type="password" placeholder="Password" id="password" name="password" required> 
                </div>
                <p class="form__error username__error"></p>
            </div>

            <div class="form__group">
                <div class="form__flex">
                    <label for="repassword">Repassword</label>
                    <input type="password" placeholder="Repassword" id="repassword" name="repassword" required> 
                </div>
                <p class="form__error username__error"></p>
            </div>

            <c:if test="${not empty error}">
                <p class="form__error" style="margin: 0; text-align: center">${error}</p>
            </c:if>
            <button >Register</button>
            <div class="social">
                <a href="https://accounts.google.com/o/oauth2/auth?scope=email%20profile%20openid&redirect_uri=http://localhost:8080/ParadiseHotel/register&response_type=code&client_id=370841450880-23fiie6auhj74f5f5lel16b2gujnt2ui.apps.googleusercontent.com&approval_prompt=force">
                    <div class="go" style="width: 100%"><i class="fab fa-google"></i> Google</div>
                </a>
            </div>
            <h4>You already have an account ?  <a href="login.jsp" style="color: #7a7aff">Login</a></h4>
        </form>
        <script src="./js/validationForm.js"></script>
        <script>
            Validator({
                form: '#form-register',
                formGroupSelector: '.form__group',
                errorSelector: '.form__error',
                rules: [
                    Validator.isRequired('#username', 'Please enter your username'),
                    Validator.isPhoneNumber('#phone', 'Please enter your phone number'),
                    Validator.isRequired('#email', 'Please enter your email'),
                    Validator.isEmail('#email'),
                    Validator.minLength(' #password', 8),
                    Validator.isRequired('#repassword'),
                    Validator.isConfirmed(' #repassword', function () {
                        return document.querySelector('#form-register #password').value;
                    }, 'Password re-entered is incorrect'),
                ],
                onsubmit: function (formValue) {
                    document.querySelector('#form-register').submit();
                }
            })
        </script>
    </body>
</html>
