<%-- 
    Document   : editProfile
    Created on : May 24, 2025, 5:41:24 PM
    Author     : KTC
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">

<!DOCTYPE html>
<html lang="en">

    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Feedback Room</title>
        <link rel="stylesheet" href="css/send_feedback.css">
    </head>
    <body >

        <div class="container">
            <div class="sidebar">
                <img class="avatar" src="./img/avatar/${sessionScope.user.getAvatar_url()}" alt="Profile Avatar"/>

                <ul>
                    <li><a href="#">Booking Room</a></li>
                    <li><a href="myBooking">Your Booking</a></li>
                    <li><a href="sendFeedback">Feedback Room</a></li>
                </ul>

            </div>
            <div class="main-content">
                <h2>Welcome dear customers!</h2>
                <p>Please leave your comments here so we can know your experience.</p>
                <form id="sendFeedback" action="sendFeedback" method="post">                      
                    <div class="form-group">
                        <label>Overall Rating (1-5 Stars)</label>
                        <div class="star-rating">
                            <div class="star-option">
                                <span class="star-number" style="color: white">5</span>
                                <input type="radio" id="star5" name="rating" value="5" checked required>
                                <label for="star5"><span class="star-icon" style="color: yellow">★</span><span class="star-icon" style="color: yellow">★</span><span class="star-icon" style="color: yellow">★</span><span class="star-icon" style="color: yellow">★</span><span class="star-icon" style="color: yellow">★</span></label>
                            </div>
                            <div class="star-option">
                                <span class="star-number" style="color: white">4</span>
                                <input type="radio" id="star4" name="rating" value="4">
                                <label for="star4"><span class="star-icon" style="color: yellow">★</span><span class="star-icon" style="color: yellow">★</span><span class="star-icon" style="color: yellow">★</span><span class="star-icon" style="color: yellow">★</span></label>
                            </div>
                            <div class="star-option">
                                <span class="star-number" style="color: white">3</span>
                                <input type="radio" id="star3" name="rating" value="3">
                                <label for="star3"><span class="star-icon" style="color: yellow">★</span><span class="star-icon" style="color: yellow">★</span><span class="star-icon" style="color: yellow">★</span></label>
                            </div>
                            <div class="star-option">
                                <span class="star-number" style="color: white">2</span>
                                <input type="radio" id="star2" name="rating" value="2">
                                <label for="star2"><span class="star-icon" style="color: yellow">★</span><span class="star-icon" style="color: yellow">★</span></label>
                            </div>
                            <div class="star-option">
                                <span class="star-number" style="color: white">1</span>
                                <input type="radio" id="star1" name="rating" value="1">
                                <label for="star1"><span class="star-icon" style="color: yellow">★</span></label>
                            </div>
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Detailed Comments</label>
                        <textarea id="comment" name="comment" rows="5" cols="50" required></textarea>
                         <p class="form_error"></p>
                    </div>



                    <button type="button" class="cancel-btn" onclick="window.location.reload();">Cancel</button>

                    <button type="submit" class="save-btn">Submit a review</button>
                    <c:if test="${not empty message}">
                        <p style="color: red; font-size: 20px">${message}</p>
                    </c:if>

                </form>

                <div class="feedback-table">
                    <h3>Feedback For Our Hotel</h3>
                    <table border="1">
                        <thead>
                            <tr>
                                <th>Username</th>
                                <th>Rating</th>
                                <th>Comment</th>
                                <th>Created At</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="feedback" items="${listFeedback}">
                                <tr>
                                    <td>${feedback.username}</td>
                                    <td>${feedback.rating}</td>
                                    <td>${feedback.comment}</td>
                                    <td><fmt:formatDate value="${feedback.created_at}" pattern="dd-MM-yyyy HH:mm:ss"/></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="pagination">
                    <c:if test="${currentPage > 1}">
                        <a href="?page=${currentPage - 1}"  class="prev"> Previous</a>
                    </c:if>

                    <c:forEach var="i" begin="1" end="${totalPages}">
                        <a href="?page=${i}" class="${i == currentPage ? 'active' : ''}">${i}</a>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <a href="?page=${currentPage + 1}" class="next">Next</a>
                    </c:if>
                </div>



            </div>
        </div>
        <script src="./js/validationForm.js"></script>
        <script>
                Validator({
                    form: '#sendFeedback',
                    formGroupSelector: '.form-group',
                    errorSelector: '.form_error',
                    rules: [
                        Validator.lengthRange('#comment', 1, 35),
                    ],
                    onsubmit: function (formValue) {
                        document.querySelector('#sendFeedback').submit();
                    }
                })
        </script>

    </body>
</html>
