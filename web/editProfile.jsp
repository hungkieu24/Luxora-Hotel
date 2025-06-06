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
            
            <div class="container">
                <div class="sidebar">
                    <img class="avatar" src="${sessionScope.user.getAvatar_url()}" alt="Profile Avatar"/>
                    <p>Rank: <span>${loyaltypointlp.getLevel()}</span> </p>
                    <p>Accumulated Points: <a href="#">${loyaltypointlp.getPoints()}</a></p>
                    <ul class="level-1">
                        <li><a href="#">Personal Info</a></li>
                        <li><a href="editProfile">Change Personal Info</a></li>
                        <li><a href="#">Booking History</a></li>
                        <li><a href="myBooking">Your Booking</a></li>
                        <li><a href="#">Loyalty Status</a> </li>
                        <li><a href="#">Change Password</a></li>
                        
                                <li><a href="viewFeedback">View Feedback</a></li>
                                <li><a href="sendFeedback1.jsp">Send Feedback</a></li>
                             
                        <li><a href="./homepage?action=logout">Log out</a></li>
                        <li><a href="homepage" class="home-link">Home</a></li>
                    </ul>

                </div>
                <div class="main-content">
                    <h2>Personal Information</h2>
                    <p>View and update your personal details.</p>
                    <form id="editProfile" action="editProfile" method="post" enctype="multipart/form-data">
                        <div class="avatar-section">
                            <img class="avatar" src="${sessionScope.user.getAvatar_url()}" alt="Avatar"/>
                            <p >Choose file to change avatar</p>

                            <input type="file" id="avatar-upload" name="avatar">
                            <button type="button" class="custom-upload-button" onclick="document.getElementById('avatar-upload').click();">
                                Upload Avatar
                            </button>
                            <span class="file-name" id="file-name">No file chosen</span>
                        </div>

                        <div class="form-group">
                            <label>Username</label>
                            <input id="username" type="text" value="${sessionScope.user.getUsername()}" name="username">
                            <p class="form_error"></p>
                        </div>

                        <div class="form-group">
                            <label>Email</label>
                            <input id="email" type="email" value="${sessionScope.user.getEmail()}" name="email">
                            <p class="form_error"></p>
                        </div>

                        <div class="form-group">
                            <label>Phone number</label>
                            <input id="phonenumber" type="tel" value="${sessionScope.user.getPhonenumber()}" name="phonenumber">
                            <p class="form_error"></p>
                        </div>

                        <button type="button" class="cancel-btn" onclick="window.location.href = 'editProfile';">Cancel</button>

                        <button  class="save-btn">Save Change</button>

                    </form>
                </div>
            </div>
                            
            <script src="./js/toastMessage.js"></script>                
            <script src="./js/validationForm.js"></script>
            <script>
                Validator({
                form: '#editProfile',
                formGroupSelector: '.form-group',
                errorSelector: '.form_error',
                rules: [
                    Validator.isRequired('#username', 'Please enter the your username'),
                    Validator.lengthRange('#username',6,30),
                    Validator.isPhoneNumber('#phonenumber', 'Please enter your phone number'),
                    Validator.isRequired('#email', 'Please enter your email'),
                    Validator.isEmail('#email', 'This field must be an email'),
                    Validator.lengthRange('#email',16,40),
                ],
                onsubmit: function (formValue) {
                    document.querySelector('#editProfile').submit();
                }
            })
            </script>
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
