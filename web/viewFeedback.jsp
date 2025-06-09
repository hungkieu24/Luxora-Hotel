<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="Ansonika">
        <title>PARADISE - Hotel and Bed&Breakfast Site Template</title>

        <!-- Favicons-->
        <link rel="shortcut icon" href="img/favicon.ico" type="image/x-icon">
        <link rel="apple-touch-icon" type="image/x-icon" href="img/apple-touch-icon-57x57-precomposed.png">
        <link rel="apple-touch-icon" type="image/x-icon" sizes="72x72" href="img/apple-touch-icon-72x72-precomposed.png">
        <link rel="apple-touch-icon" type="image/x-icon" sizes="114x114" href="img/apple-touch-icon-114x114-precomposed.png">
        <link rel="apple-touch-icon" type="image/x-icon" sizes="144x144" href="img/apple-touch-icon-144x144-precomposed.png">

        <!-- GOOGLE WEB FONT-->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Caveat:wght@400;500&family=Montserrat:wght@300;400;500;600;700&display=swap" rel="stylesheet">

        <!-- BASE CSS -->
        <link href="css/bootstrap.min.css" rel="stylesheet">
        <link href="css/style.css" rel="stylesheet">
        <link href="css/vendors.min.css" rel="stylesheet">
        <link rel="stylesheet" href="css/view_feedback.css">
        <!-- YOUR CUSTOM CSS -->
        <link href="css/custom.css" rel="stylesheet">
    </head>

    <body> 

        <div id="preloader">
            <div data-loader="circle-side"></div>
        </div><!-- /Page Preload -->

        <div class="layer"></div><!-- Opacity Mask -->

        <header class="reveal_header">
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-6">
                        <a href="homepage" class="logo_normal"><img src="img/logo.png" width="135" height="45" alt=""></a>
                        <a href="index.html" class="logo_sticky"><img src="img/logo_sticky.png" width="135" height="45" alt=""></a>
                    </div>

                    <div class="col-6">
                        <nav class="second_nav">
                            <ul>
                                
                                <li>
                                    <div class="hamburger_2 open_close_nav_panel">
                                        <div class="hamburger__box">
                                            <div class="hamburger__inner"></div>
                                        </div>
                                    </div>
                                </li>
                            </ul>
                        </nav>
                    </div>
                </div>
            </div><!-- container -->
        </header><!-- End Header -->

        <div class="nav_panel">
            <a href="#" class="closebt open_close_nav_panel"><i class="bi bi-x"></i></a>
            <div class="logo_panel"><img src="img/logo_sticky.png" width="135" height="45" alt=""></div>
            <div class="sidebar-navigation">
                <nav>
                    <ul class="level-1">
                        <li><a href="#">Personal Info</a></li>
                        <li><a href="editProfile1">Change Personal Info</a></li>
                        <li><a href="#">Booking History</a></li>
                        <li><a href="myBooking">Your Booking</a></li>
                        <li><a href="#">Loyalty Status</a> </li>
                        <li><a href="#">Change Password</a></li>
                        <li class="parent"><a href="#0">Feedback</a>
                            <ul class="level-2">
                                <li class="back"><a href="#0">Back</a></li>
                                <li><a href="viewFeedback">View Feedback</a></li>
                                <li><a href="sendFeedback.jsp">Send Feedback</a></li>
                            </ul> 
                        </li>
                        <li><a href="./homepage?action=logout">Log out</a></li>
                        <li><a href="homepage" class="home-link">Home</a></li>
                    </ul>
                    <div class="panel_footer">
                        <div class="phone_element"><a href="tel://423424234"><i class="bi bi-telephone"></i><span><em>Info and bookings</em>+41 934 121 1334</span></a></div>
                    </div>
                    <!-- /panel_footer -->
                </nav>
            </div>
            <!-- /sidebar-navigation -->
        </div>
        <!-- /nav_panel -->

        <main>

            <div class="hero full-height jarallax" data-jarallax data-speed="0.2">
                <img class="jarallax-img kenburns" src="img/room1.jpg" alt="">
                <div class="wrapper opacity-mask d-flex align-items-center  text-center animate_hero" data-opacity-mask="rgba(0, 0, 0, 0.5)">
                    <div class="container">
                        <div class="row justify-content-center">
                            <div class="col-lg-8">
                                <small class="slide-animated one">Luxury Hotel Experience</small>
                                <h1 class="slide-animated two">Welcome dear customers!</h1>
                                <p class="slide-animated three">Please leave your comments here so we can know your experience.</p>
                            </div>
                        </div>
                    </div>
                    <div class="mouse_wp slide-animated four">
                        <a href="#first_section" class="btn_explore">
                            <div class="mouse"></div>
                        </a>
                    </div>
                    <!-- / mouse -->
                </div>
            </div>
            <!-- /Background Img Parallax -->
            
            <div class="container margin_120_95" id="reviews">
                <div class="row justify-content-between">

                    <div class="col-lg-12 order-lg-1">


                        <div id="feedback-container">
                            <h3 class="mb-3">Feedback History</h3>
                            <c:forEach var="feedback" items="${listFeedback}"> 

                                <div class="review_card">
                                    <div class="row">
                                        <div class="col-md-2 user_info">
                                            <figure><img class="avatar" src="${feedback.userAvatarUrl}" alt="Profile Avatar"/></figure>
                                            <h5>${feedback.username}</h5>
                                        </div>
                                        <div class="col-md-10 review_content">
                                            <div class="clearfix mb-3">
                                                <span class="rating">${feedback.rating}<small>★</small> <strong>Rating average</strong></span>
                                                <em><fmt:formatDate value="${feedback.created_at}" pattern="dd-MM-yyyy HH:mm:ss"/></em>
                                            </div>
                                            <h4 style="word-wrap: break-word; overflow-wrap: break-word; word-break: break-word; white-space: pre-wrap;">${feedback.comment}</h4>
                                        </div>
                                    </div>

                                </div>

                            </c:forEach>
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
                        <!-- /review_card -->
                        <p class="text-end"><a href="sendFeedback.jsp" class="btn_1">Leave a review</a></p>



                    </div>
                    
                </div>
            </div>



        </main>

        <footer class="revealed">
            <div class="footer_bg">
                <div class="gradient_over"></div>
                <div class="background-image" data-background="url(img/rooms/3.jpg)"></div>
            </div>
            <div class="container">
                <div class="row move_content">
                    <div class="col-lg-4 col-md-12">
                        <h5>Contacts</h5>
                        <ul>
                            <li>Baker Street 567, Los Angeles 11023<br>California - US<br><br></li>
                            <li><strong><a href="#0">info@Paradisehotel.com</a></strong></li>
                            <li><strong><a href="#0">+434 43242232</a></strong></li>
                        </ul>
                        <div class="social">
                            <ul>
                                <li><a href="#0"><i class="bi bi-instagram"></i></a></li>
                                <li><a href="#0"><i class="bi bi-whatsapp"></i></a></li>
                                <li><a href="#0"><i class="bi bi-facebook"></i></a></li>
                                <li><a href="#0"><i class="bi bi-twitter"></i></a></li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6 ms-lg-auto">
                        <h5>Explore</h5>
                        <div class="footer_links">
                            <ul>
                                <li><a href="index.html">Home</a></li>
                                <li><a href="about.html">About Us</a></li>
                                <li><a href="room-list-1.html">Rooms &amp; Suites</a></li>
                                <li><a href="news-1.html">News &amp; Events</a></li>
                                <li><a href="contacts.html">Contacts</a></li>
                                <li><a href="about.html">Terms and Conditions</a></li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-lg-3 col-md-6">
                        <div id="newsletter">
                            <h5>Newsletter</h5>
                            <div id="message-newsletter"></div>
                            <form method="post" action="phpmailer/newsletter_template_email.php" name="newsletter_form" id="newsletter_form">
                                <div class="form-group">
                                    <input type="email" name="email_newsletter" id="email_newsletter" class="form-control" placeholder="Your email">
                                    <button type="submit" id="submit-newsletter"><i class="bi bi-send"></i></button>
                                </div>
                            </form>
                            <p>Receive latest offers and promos without spam. You can cancel anytime.</p>
                        </div>
                    </div>
                </div>
                <!--/row-->
            </div>
            <!--/container-->
            <div class="copy">
                <div class="container">
                    © Paradise - by <a href="#">Ansonika</a>
                </div>
            </div>
        </footer>
        <!-- /footer -->

        <div class="progress-wrap">
            <svg class="progress-circle svg-content" width="100%" height="100%" viewBox="-1 -1 102 102">
            <path d="M50,1 a49,49 0 0,1 0,98 a49,49 0 0,1 0,-98"/>
            </svg>
        </div>
        <!-- /back to top -->


        <!-- COMMON SCRIPTS -->
        <script src="js/common_scripts.js"></script>
        <script src="js/common_functions.js"></script>
        <script src="js/datepicker_inline.js"></script>
        <script src="phpmailer/validate.js"></script>
        <script>
            // Progress bars animation
            $(function () {
                "use strict";
                var $section = $('#reviews');
                $(window).on('scroll', function (ev) {
                    var scrollOffset = $(window).scrollTop();
                    var containerOffset = $section.offset().top - window.innerHeight;
                    if (scrollOffset > containerOffset) {
                        $(".progress-bar").each(function () {
                            var each_bar_width = $(this).attr('aria-valuenow');
                            $(this).width(each_bar_width + '%');
                        });
                    }
                });
            });
        </script>


        <script>
            $(document).ready(function () {
                $(document).on('click', '.pagination a', function (e) {
                    e.preventDefault();
                    var url = $(this).attr('href');

                    $.ajax({
                        url: url,
                        type: 'GET',
                        headers: {'X-Requested-With': 'XMLHttpRequest'},
                        success: function (data) {
                            // lấy ra phần feedback-container từ kết quả trả về
                            var newContent = $(data).find('#feedback-container').html();
                            $('#feedback-container').html(newContent);
                        },
                        error: function () {
                            alert("Error loading feedbacks.");
                        }
                    });
                });
            });
        </script>


    </body>
</html>