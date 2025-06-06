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
        <form action="verifyemail" method="post" id="verifyForm">
            <h3>Verify your email</h3>
            <p style="text-align: center">We have sent a verification code to your email. Please enter it below to verify your account.</p>
            <div class="form__group">
                <label for="code">Verify Code</label>
                <div class="form__flex verify">
                    <input type="text" name="code" id="code" placeholder="Enter verify code" required>
                    <button type="button" class="reset" id="reset">Get new code</button>
                </div>
            </div>
            <button type="submit">Verify</button>
            <p id="countdown" style="color: #00ca92; font-size: 15px;"></p>
        </form>

        <script>
            document.getElementById("reset").addEventListener("click", function () {
                const form = document.getElementById("verifyForm");

                // Nếu input 'action' đã tồn tại thì không tạo lại
                let actionInput = document.querySelector('input[name="action"]');
                if (!actionInput) {
                    actionInput = document.createElement("input");
                    actionInput.type = "hidden";
                    actionInput.name = "action";
                    form.appendChild(actionInput);
                }

                actionInput.value = "resend";
                form.submit(); // Gửi form
            });
        </script>
        <script>
            function startCountdown(durationInSeconds, displayElementId, resetElement) {
                const display = document.getElementById(displayElementId);
                const resetBtn = document.getElementById(resetElement);
                console.log(resetBtn);
                let timer = durationInSeconds;

                const interval = setInterval(() => {

                    const minutes = Math.floor(timer / 60);
                    const seconds = timer % 60;
                    var sercondFormat = seconds;
                    if (seconds < 10) {
                        sercondFormat = "0" + seconds;
                    }

                    display.textContent = "Code expires in: " + minutes + ":" + sercondFormat;
                    if (--timer < 0) {
                        clearInterval(interval);
                    }
                }, 1000);
            }

            // Bắt đầu đếm ngược 
            const expiryTime = ${sessionScope.expiryTime}; // millisec
            const currentTime = new Date().getTime(); // millisec
            const remaining = Math.floor((expiryTime - currentTime) / 1000);

            if (remaining > 0) {
                startCountdown(remaining, "countdown", "reset");
            } else {
                document.getElementById("countdown").textContent = "Code has expired!";
                document.getElementById("countdown").style.color = "red";
                document.getElementById("reset").style.opacity = 1;
                document.getElementById("reset").style.cursor = "pointer";
            }

        </script>


    </body>
</html>
