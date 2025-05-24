<%-- 
    Document   : login
    Created on : May 24, 2025, 10:00:32 PM
    Author     : thien
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
        <form>
            
            <h3>Login here</h3>
            <label for="username">User name</label>
            <input type="text" placeholder="Username" id="username" name="username" required>
            
            <label for="password"> Password</label>
            <input type="password" placeholder="Password" id="password" name="password" required> 
            
            <div class="forgot-password">
                    <a href="#">Forgot Password?</a>
                </div>
            
            <button>Log In</button>
            <div class="social">
                <a href="#">
                    <div class="go"><i class="fab fa-google"></i> Google</div>
                </a>
            </div>
        </form>
    </body>
</html>
