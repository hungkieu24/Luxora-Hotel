<%-- 
    Document   : editProfile
    Created on : May 24, 2025, 5:41:24 PM
    Author     : KTC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Edit Profile</title>
        <link rel="stylesheet" href="css/editProfile.css">
    </head>
    <body>
        <div class="container">
        <div class="sidebar">
            <img src="img/avatar.jpg" alt="Profile Avatar"/>
            <p>Rank: Gold</p>
            <p>Accumulated Points: <a href="#">5000</a></p>
            <ul>
                <li><a href="#" class="Personal-link">Personal Info</a></li>
                <li><a href="#" class="Booking-link">Booking History</a></li>
                <li><a href="#" class="Your-link">Your Booking</a></li>
                <li><a href="#" class="Loyalty-link">Loyalty Status</a> </li>
                <li><a href="#" class="Security-link">Security</a></li>
                <li><a href="#" class="Change-link">Change Password</a></li>
                <li><a href="#" class="home-link">Home</a></li>
            </ul>
            
        </div>
        <div class="main-content">
            <h2>Personal Information</h2>
            <p>View and update your personal details.</p>
            <div class="avatar-section">
                <img src="img/avatar.jpg" alt="Avatar"/>
                <p>Choose file to change avatar</p>
                <input type="file" id="avatar-upload">
            </div>
            <form action="editProfile" method="post">
                <div class="form-group">
                    <label>Name</label>
                    <input type="text" value="" name="name">
                </div>
                <div class="form-group">
                    <label>Phone Number</label>
                    <input type="text" value="" name="phone">
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <input type="email" value="" name="email">
                </div>
                <div class="form-group">
                    <label>CC/CD Number</label>
                    <input type="text" value="" name="cccd">
                </div>
                <button type="button" class="cancel-btn">Cancel</button>
                <button type="button" class="save-btn">Save Change</button>
            </form>
        </div>
    </div>
    </body>
</html>
