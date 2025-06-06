<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

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
        <link rel="stylesheet" href="css/send_feedback1.css">
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
                        <a href="index.html" class="logo_normal"><img src="img/logo.png" width="135" height="45" alt=""></a>
                        <a href="index.html" class="logo_sticky"><img src="img/logo_sticky.png" width="135" height="45" alt=""></a>
                    </div>
                    <div class="col-6">
                        <nav>
                            <ul>
                                <li><a href="#booking_section" class="btn_1 btn_scrollto">Book Now</a></li>
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
            </div><!-- /container -->
        </header><!-- /Header -->

        <div class="nav_panel">
            <a href="#" class="closebt open_close_nav_panel"><i class="bi bi-x"></i></a>
            <div class="logo_panel"><img src="img/logo_sticky.png" width="135" height="45" alt=""></div>
            <div class="sidebar-navigation">
                <nav>
                    <ul class="level-1">
                        <li><a href="#">Personal Info</a></li>
                        <li><a href="editProfile">Change Personal Info</a></li>
                        <li><a href="#">Booking History</a></li>
                        <li><a href="myBooking">Your Booking</a></li>
                        <li><a href="#">Loyalty Status</a> </li>
                        <li><a href="#">Change Password</a></li>
                        <li class="parent"><a href="#0">Feedback</a>
                            <ul class="level-2">
                                <li class="back"><a href="#0">Back</a></li>
                                <li><a href="viewFeedback">View Feedback</a></li>
                                <li><a href="sendFeedback1.jsp">Send Feedback</a></li>
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

            <div class="hero medium-height jarallax" data-jarallax data-speed="0.2">
                <img class="jarallax-img" src="img/room1.jpg" alt="">
                <div class="wrapper opacity-mask d-flex align-items-center justify-content-center text-center animate_hero" data-opacity-mask="rgba(0, 0, 0, 0.5)">
                    <div class="container">
                        <small class="slide-animated one">Luxury Hotel Experience</small>
                        <h1 class="slide-animated two">Contact Us</h1>
                    </div>
                </div>
            </div>
            <!-- /Background Img Parallax -->

            <div class="container margin_120_95">
                <div class="row justify-content-between">
                    <div class="col-xl-4 col-lg-5 order-lg-2">
                        <div class="contact_info">
                            <ul class="clearfix">
                                <li>
                                    <i class="bi bi-geo-alt"></i>
                                    <h4>Address</h4>
                                    <div>PO Box 97845 Baker st. 567, Los Angeles<br>California - US.</div>
                                </li>
                                <li>
                                    <i class="bi bi-envelope-paper"></i>
                                    <h4>Email address</h4>
                                    <p><a href="#0">booking@Paradise.com</a> - <a href="#0">info@Paradise.com</a></p>
                                </li>
                                <li>
                                    <i class="bi bi-telephone"></i>
                                    <h4>Telephone</h4>
                                    <div>+ 61 (2) 8093 3402 + 61 (2) 8093 3402<br><small>Monday to Friday 9am - 7pm</small></div>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="col-xl-7 col-lg-7 order-lg-1">
                        <h3 class="mb-3">Get in Touch</h3>
                        <div id="message-contact"></div>

                        <form id="sendFeedback" action="sendFeedback1" method="post">                      
                            <div class="form-group">
                                <label>Overall Rating (1-5 Stars)</label>

                                <div class="row">
                                <div class="col-sm-6">
                                    <div class="form-floating mb-4">
                                        <input
                                            class="form-control"
                                            type="range"
                                            id="star_rating"
                                            name="rating"
                                            min="1"
                                            max="5"
                                            step="1"
                                            value="3"                             
                                        />
                                        <label for="star_rating">Rating (stars)</label>
                                    </div>
                                </div>

                                <div class="col-sm-6">
                                    <div class="form-floating mb-4">
                                        <div
                                            id="star_display"
                                            style="font-size: 1.5rem; color: gold; cursor: context-menu"
                                        ></div>
                                    </div>
                                </div>
                            </div>


                            </div>

                            <div class="form-group">
                                <label>Detailed Comments</label><!--
                                <textarea id="comment" name="comment" rows="5" cols="50" required></textarea>-->
                                <textarea class="form-control" placeholder="Message" id="comment" name="comment" required></textarea>
                                <p class="form_error"></p>
                            </div>



                            <button type="button" class="cancel-btn" onclick="window.location.reload();">Cancel</button>

                            <button type="submit" class="save-btn">Submit a review</button>
                             <p class="text-end"><a href="viewFeedback" class="btn_1">View reviews</a></p>
                            <c:if test="${not empty message}">
                                <p style="color: red; font-size: 20px">${message}</p>
                            </c:if>
                        </form>

                    </div>
                </div>
                <!-- /row -->
            </div>
            <!--/container -->

            <div class="map_contact">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3021.4364241114604!2d-73.96780638459853!3d40.774418641731515!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x89c258a29d3847f5%3A0x564dfbba0141774a!2s5th%20Ave%2C%20New%20York%2C%20NY%2C%20Stati%20Uniti!5e0!3m2!1sit!2ses!4v1661414716655!5m2!1sit!2ses" width="600" height="450" style="border:0;" allowfullscreen="" loading="lazy" referrerpolicy="no-referrer-when-downgrade"></iframe>
            </div>
            <!--/map_contact -->

            <div class="container margin_120_95" id="booking_section">
                <div class="row justify-content-between">
                    <div class="col-xl-4">
                        <div data-cue="slideInUp">
                            <div class="title">
                                <small>Paradise Hotel</small>
                                <h2>Check Availability</h2>
                            </div>
                            <p>Mea nibh meis philosophia eu. Duis legimus efficiantur ea sea. Id placerat tacimates definitionem sea, prima quidam vim no. Duo nobis persecuti cu. </p>
                            <p class="phone_element no_borders"><a href="tel://423424234"><i class="bi bi-telephone"></i><span><em>Info and bookings</em>+41 934 121 1334</span></a></p>
                        </div>
                    </div>
                    <div class="col-xl-7">
                        <div data-cue="slideInUp" data-delay="200">
                            <div class="booking_wrapper">
                                <p id="daterangepicker-result" class="d-none"></p>
                                <input id="date_booking" type="hidden">
                                <div id="daterangepicker-embedded-container" class="embedded-daterangepicker clearfix mb-4"></div>
                                <div class="row">
                                    <div class="col-lg-6">
                                        <div class="custom_select">
                                            <select class="wide">
                                                <option>Select Room</option>
                                                <option>Double Room</option>
                                                <option>Deluxe Room</option>
                                                <option>Superior Room</option>
                                                <option>Junior Suite</option>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="col-lg-6">
                                        <div class="row">
                                            <div class="col-6">
                                                <div class="qty-buttons mb-3 version_2">
                                                    <input type="button" value="+" class="qtyplus" name="adults_booking">
                                                    <input type="text" name="adults_booking" id="adults_booking" value="" class="qty form-control" placeholder="Adults">
                                                    <input type="button" value="-" class="qtyminus" name="adults_booking">
                                                </div>
                                            </div>
                                            <div class="col-6">
                                                <div class="mb-3 qty-buttons mb-3 version_2">
                                                    <input type="button" value="+" class="qtyplus" name="childs_booking">
                                                    <input type="text" name="childs_booking" id="childs_booking" value="" class="qty form-control" placeholder="Childs">
                                                    <input type="button" value="-" class="qtyminus" name="childs_booking">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- / row -->
                            <p class="text-end mt-5"><a href="#0" class="btn_1 outline">Book Now</a></p>
                        </div>
                    </div>
                    <!-- /col -->
                </div>
                <!-- /row -->
            </div>
            <!-- /container -->

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
            <path d="M50,1 a49,49 0 0,1 0,98 a49,49 0 0,1 0,-98" />
            </svg>
        </div>
        <!-- /back to top -->

        <!-- COMMON SCRIPTS -->
        <script src="js/common_scripts.js"></script>
        <script src="js/common_functions.js"></script>
        <script src="js/datepicker_inline.js"></script>
        <script src="phpmailer/validate.js"></script>
        <script>
            $(document).ready(function () {
                function updateStars(value) {
                    let stars = "";
                    for (let i = 0; i < value; i++) {
                        stars += "⭐";
                    }
                    $("#star_display").html(stars);
                }

                // Khởi tạo hiển thị sao ban đầu
                updateStars($("#star_rating").val());

                // Cập nhật khi thay đổi
                $("#star_rating").on("input change", function () {
                    updateStars($(this).val());
                });
            });
        </script>

    </body>
</html>