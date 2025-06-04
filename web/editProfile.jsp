<%-- 
    Document   : editProfile
    Created on : May 24, 2025, 5:41:24 PM
    Author     : KTC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">

<!DOCTYPE html>
<html lang="en">
    <html>
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Edit Profile</title>
            <link rel="stylesheet" href="css/editProfile.css">
        </head>
        <body >

            <div class="container">
                <div class="sidebar">
                    <img class="avatar" src=".${sessionScope.user.getAvatar_url()}" alt="Profile Avatar"/>
                    <p>Rank: <span>${loyaltypointlp.getLevel()}</span> </p>
                    <p>Accumulated Points: <a href="#">${loyaltypointlp.getPoints()}</a></p>
                    <ul>
                        <li><a href="editProfile">Personal Info</a></li>
                        <li><a href="bookingHistory.jsp">Booking History</a></li>
                        <li><a href="myBooking">Your Booking</a></li>
                        <li><a href="#">Loyalty Status</a> </li>
                        <li><a href="#">Security</a></li>
                        <li><a href="#">Change Password</a></li>
                        <li><a href="./homepage?action=logout">Log out</a></li>
                        <li><a href="homepage" class="home-link">Home</a></li>
                    </ul>

                </div>
                <div class="main-content">
                    <h2>Personal Information</h2>
                    <p>View and update your personal details.</p>
                    <form action="editProfile" method="post" enctype="multipart/form-data">
                        <div class="avatar-section">
                            <img class="avatar" src=".${sessionScope.user.getAvatar_url()}" alt="Avatar"/>
                            <p >Choose file to change avatar</p>

                            <input type="file" id="avatar-upload" name="avatar">
                            <button type="button" class="custom-upload-button" onclick="document.getElementById('avatar-upload').click();">
                                Upload Avatar
                            </button>
                            <span class="file-name" id="file-name">No file chosen</span>
                        </div>

                        <div class="form-group">
                            <label>Username</label>
                            <input type="text" value="${sessionScope.user.getUsername()}" name="username">
                        </div>

                        <div class="form-group">
                            <label>Email</label>
                            <input type="email" value="${sessionScope.user.getEmail()}" name="email">
                        </div>
                        
                        <div class="form-group">
                            <label>Phone number</label>
                            <input type="tel" value="${sessionScope.user.getPhonenumber()}" name="phonenumber">
                        </div>

                        <button type="button" class="cancel-btn" onclick="window.location.reload();">Cancel</button>

                        <button type="submit" class="save-btn">Save Change</button>
                        <c:if test="${not empty message}">
                            <p style="color: red; font-size: 20px">${message}</p>
                        </c:if>

                    </form>
                </div>
            </div>

            <script>
                const input = document.getElementById('avatar-upload');
                const fileNameDisplay = document.getElementById('file-name');

                input.addEventListener('change', function () {
                    if (input.files.length > 0) {
                        fileNameDisplay.textContent = input.files[0].name;
                    } else {
                        fileNameDisplay.textContent = "No file chosen";
                    }
                });
            </script>
        </body >
    </html>
