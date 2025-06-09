<%-- 
    Document   : menu5
    Created on : May 24, 2025, 5:30:58 PM
    Author     : hungk
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="en" />


<!DOCTYPE html>
<html lang="zxx">

    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="Ansonika">
        <title>PARADISE - Hotel</title>

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

        <!-- YOUR CUSTOM CSS -->
        <link href="css/custom.css" rel="stylesheet">
    </head>

    <body class="datepicker_mobile_full"> 
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
        <div id="preloader">
            <div data-loader="circle-side"></div>
        </div><!-- /Page Preload -->

        <header class="fixed_header menu_v4 submenu_version">
            <div class="layer"></div><!-- Opacity Mask -->
            <div class="container">
                <div class="row align-items-center">
                    <div class="col-3">
                        <a href="index222.html" class="logo_normal"><img src="img/logo.png" width="135" height="45" alt=""></a>
                        <a href="index222.html" class="logo_sticky"><img src="img/logo_sticky.png" width="135" height="45" alt=""></a>
                    </div>
                    <div class="col-9">
                        <div class="main-menu">
                            <a href="#" class="closebt open_close_menu"><i class="bi bi-x"></i></a>
                            <div class="logo_panel"><img src="img/logo_sticky.png" width="135" height="45" alt=""></div>
                            <nav id="mainNav">
                                <ul class="navBarList_Hompage">
                                    <!--                                    <li class="submenu">
                                                                            <a href="#0" class="show-submenu">Home</a>
                                                                            <ul>
                                                                                <li><a href="index222.html">Home Video Bg</a></li>
                                                                                <li><a href="index-2.html">Home Carousel</a></li>
                                                                                <li><a href="index-3.html">Home FlexSlider</a></li>
                                                                                <li><a href="index-4.html">Home Youtube/Vimeo</a></li>
                                                                                <li><a href="index-5.html">Home Parallax</a></li>
                                                                                <li><a href="index-6.html">Home Parallax 2</a></li>
                                                                            </ul>
                                                                        </li>-->
                                   <li class="submenu">
                                        <a href="#0" class="show-submenu">Home</a>
                                        <ul>
                                            <li><a href="branchReport.jsp">branch report</a></li>
                                        </ul>
                                    </li>
                                    <li class="submenu">
                                        <a href="#0" class="show-submenu">Rooms & Suites</a>
                                        <ul>
                                            <li><a href="searchRoomResult22.html">Room list 1</a></li>
                                            <li><a href="room-list-2.html">Room list 2</a></li>
                                            <li><a href="room-list-3.html">Room list 3</a></li>
                                            <li><a href="room-details.html">Room details</a></li>
                                            <li><a href="room-details-booking.html">Working Booking Request</a></li>
                                        </ul>
                                    </li>
                                    <!--                                    <li class="submenu">
                                                                            <a href="#0" class="show-submenu">Other Pages</a>
                                                                            <ul>
                                                                                <li><a href="gallery.html">Masonry Gallery</a></li>
                                                                                <li><a href="restaurant.html">Restaurant</a></li>
                                                                                <li><a href="menu-of-the-day.html">Menu of the day</a></li>
                                                                                <li><a href="news-1.html">Blog</a></li>
                                                                                <li><a href="404.html">Error Page</a></li>
                                                                                <li><a href="modal-advertise-1.html">Modal Advertise</a></li>
                                                                                <li><a href="cookie-bar.html">GDPR Cookie Bar</a></li>
                                                                                <li><a href="coming-soon.html">Coming Soon</a></li>
                                                                                <li><a href="menu-2.html">Menu Version 2 <span class="custom_badge">Hot</span></a></li>
                                                                                <li><a href="menu-3.html">Menu Version 3</a></li>
                                                                                <li><a href="menu-4.html">Menu Version 4</a></li>
                                                                            </ul>
                                                                        </li>-->
                                    <li><a href="about.html">About</a></li>
                                    <li><a href="contacts.html">Contacts</a></li>
                                        <c:if test="${sessionScope.user == null}">
                                        <li><a href="login.jsp">Login</a></li>
                                        <li><a href="register.jsp" class="btn_1">Register</a></li>
                                        </c:if>
                                        <c:if test="${sessionScope.user != null}">
                                        <li><a href="editProfile">${sessionScope.user.getUsername()}</a></li>
                                        <li>
                                            <a href="./editProfile">
                                                <img src="${sessionScope.user.getAvatar_url()}" alt="" class="top-act__avatar" />  
                                            </a>
                                        </li>
                                        </c:if>
                                </ul>
                            </nav>
                        </div>
                        <div class="hamburger_2 open_close_menu float-end">
                            <div class="hamburger__box">
                                <div class="hamburger__inner"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div><!-- container -->
        </header><!-- End Header -->

        <main>

            <main>
                <div class="hero full-height jarallax" data-jarallax-video="mp4:./video/sunset.mp4,webm:./video/sunset.webm,ogv:./video/sunset.ogv" data-speed="0.2">
                    <div class="wrapper opacity-mask d-flex align-items-center justify-content-center text-center animate_hero" data-opacity-mask="rgba(0, 0, 0, 0.5)">
                        <div class="container">
                            <small class="slide-animated one">Luxury Hotel Experience</small>
                            <h3 class="slide-animated two">A unique Experience<br>where to stay</h3>
                            <div class="row justify-content-center slide-animated three">
                                <div class="col-xl-10">
                                    <form action="searchroom">
                                        <div class="row g-0 booking_form">
                                            <div class="col-lg-3 ">
                                                <div class="form-group">
                                                    <input class="form-control" type="text" name="dates" placeholder="Check in / Check out" readonly="readonly" required>
                                                    <i class="bi bi-calendar2"></i>
                                                </div>
                                            </div>
                                            <div class="col-lg-3 col-sm-6 pe-lg-0 pe-sm-1">
                                                <div class="qty-buttons">
                                                    <label>Adults</label>
                                                    <input type="button" value="+" class="qtyplus" name="adults" >
                                                    <input type="text" name="adults" id="adults" value="" required class="qty form-control">
                                                    <input type="button" value="-" class="qtyminus" name="adults">
                                                </div>
                                            </div>
                                            <div class="col-lg-3 col-sm-6 ps-lg-0 ps-sm-1">
                                                <div class="qty-buttons">
                                                    <label>Childs</label>
                                                    <input type="button" value="+" class="qtyplus" name="childs" >
                                                    <input type="text" name="childs" id="childs" value="" required class="qty form-control">
                                                    <input type="button" value="-" class="qtyminus" name="childs">
                                                </div>
                                            </div>
                                            <div class="col-lg-3 col-sm-12 pe-lg-0 pe-sm-1">
                                                <div class="custom_select">
                                                    <select class="wide" name="branchID" style="position: absolute; left: -9999px; display: block">
                                                        <c:forEach items="${branchList}" var="b">
                                                            <option value="${b.getId()}">${b.getAddress()}</option>
                                                        </c:forEach>
                                                    </select>
                                                    <div class="nice-select wide" tabindex="0">
                                                        <span class="current">Select Room</span>
                                                        <ul class="list">
                                                            <c:forEach items="${branchList}" var="b">
                                                                <li data-value="${b.getId()}" class="option">${b.getAddress()}</li>
                                                                </c:forEach>
                                                        </ul>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-lg-12">
                                                <input type="submit" class="btn_search" value="Search">
                                            </div>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                        <div class="mouse_wp slide-animated four">
                            <a href="#first_section" class="btn_scrollto">
                                <div class="mouse"></div>
                            </a>
                        </div>
                        <!-- /mouse_wp -->
                    </div>
                </div>
                <!-- /jarallax video background -->

                <div class="pattern_2">
                    <div class="container margin_120_95" id="first_section">
                        <div class="row justify-content-between flex-lg-row-reverse align-items-center">
                            <div class="col-lg-5">
                                <div class="parallax_wrapper">
                                    <img src="img/registerbg.jpg" alt="" class="img-fluid rounded-img">
                                    <div data-cue="slideInUp" class="img_over"><span data-jarallax-element="-30"><img src="img/loginBackground.jpg" alt="" class="rounded-img"></span></div>
                                </div>
                            </div>
                            <div class="col-lg-5">
                                <div class="intro">
                                    <div class="title">
                                        <small>About us</small>
                                        <h2>Tailored services and the experience of unique holidays</h2>
                                    </div>
                                    <p class="lead">Vivamus volutpat eros pulvinar velit laoreet, sit amet egestas erat dignissim.</p>
                                    <p>Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.</p>
                                    <p><em>Hung...the Owner</em></p>
                                </div>
                            </div>
                        </div>
                        <!-- /Row -->
                    </div>
                    <div class="pinned-image pinned-image--medium">
                        <div class="pinned-image__container" id="section_video">
                            <video loop="loop" muted="muted" id="video_home">
                                <source src="video/swimming_pool.mp4" type="video/mp4">
                                <source src="video/swimming_pool.webm" type="video/webm">
                                <source src="video/swimming_pool.ogv" type="video/ogg">
                            </video>
                            <div class="pinned-image__container-overlay"></div>
                        </div>
                        <div class="pinned_over_content">
                            <div class="title white">
                                <small data-cue="slideInUp" data-delay="200">Luxury Hotel Experience</small>
                                <h2 data-cue="slideInUp" data-delay="300">Enjoy in a very<br> Immersive Relax</h2>
                            </div>
                        </div>
                    </div>
                    <!-- /pinned content -->
                </div>
                <!-- /Pattern  -->   

                <div class="container margin_120_95">
                    <div class="title mb-3">
                        <small data-cue="slideInUp">Luxury experience</small>
                        <h2 data-cue="slideInUp" data-delay="200">Rooms & Suites</h2>
                    </div>
                    <div class="row justify-content-center add_bottom_90" data-cues="slideInUp" data-delay="300">
                        <div data-cues="zoomIn" data-delay="200" data-disabled="true">
                            <div class="owl-carousel owl-theme carousel_item_centered_rooms rounded-img owl-loaded owl-drag" data-cue="zoomIn" data-delay="200" data-show="true" style="animation-name: zoomIn; animation-duration: 600ms; animation-timing-function: ease; animation-delay: 200ms; animation-direction: normal; animation-fill-mode: both;">
                                <c:forEach items="${roomTypeList}" var="r">
                                    <!-- /item-->
                                    <div class="item">
                                        <a href="./viewRoomTypeDetail?roomTypeId=${r.getRoomTypeID()}" class="box_cat_rooms">
                                            <figure>
                                                <div class="background-image" 
                                                     data-background="url(${r.getImage_url()})" 
                                                     style="background-image: url('${r.getImage_url()}'); height: 300px; background-size: cover; background-position: center;">
                                                </div>
                                                <div class="info">
                                                    <small>
                                                        From 
                                                        <fmt:formatNumber value="${r.getBase_price()}" type="number" groupingUsed="true" maxFractionDigits="0" />
                                                        VND /night
                                                    </small>
                                                    <h3>${r.getName()}</h3>
                                                    <span>Read more</span>
                                                </div>
                                            </figure>
                                        </a>
                                    </div>
                                </c:forEach>
                        </div>
                            <p style="opacity: 1" class="text-end"><a href="./viewRoomTypeList" class="btn_1 outline mt-2">View all Room Types</a></p>
                    </div>
                    <!-- /row-->

                    <div class="title text-center mb-5">
                        <small data-cue="slideInUp">Paradise Hotel</small>
                        <h2 data-cue="slideInUp" data-delay="100">Main Facilities</h2>
                    </div>
                    <div class="row mt-4">
                        <div class="col-xl-3 col-md-6">
                            <div class="box_facilities no-border" data-cue="slideInUp">
                                <i class="customicon-private-parking"></i>
                                <h3>Private Parking</h3>
                                <p>Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam.</p>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="box_facilities" data-cue="slideInUp">
                                <i class="customicon-wifi"></i>
                                <h3>High Speed Wifi</h3>
                                <p>At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium.</p>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="box_facilities" data-cue="slideInUp">
                                <i class="customicon-cocktail"></i>
                                <h3>Bar & Restaurant</h3>
                                <p>Similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga.</p>
                            </div>
                        </div>
                        <div class="col-xl-3 col-md-6">
                            <div class="box_facilities" data-cue="slideInUp">
                                <i class="customicon-swimming-pool"></i>
                                <h3>Swimming Pool</h3>
                                <p>Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus.</p>
                            </div>
                        </div>
                    </div>
                    <!-- /Row -->
                </div>
                <!-- /container-->

                <div class="marquee">
                    <div class="track">
                        <div class="content">&nbsp;Relax Enjoy Luxury Holiday Travel Discover Experience Relax Enjoy Luxury Holiday Travel Discover Experience Relax Enjoy Luxury Holiday Travel Discover Experience Relax Enjoy Luxury Holiday Travel Discover Experience</div>
                    </div>
                </div>
                <!-- /marquee-->

                <div class="bg_white">
                    <div class="container margin_120_95">
                        <div class="row justify-content-between d-flex align-items-center add_bottom_90">
                            <div class="col-lg-6">
                                <div class="pinned-image rounded_container pinned-image--small mb-4">
                                    <div class="pinned-image__container">
                                        <img src="img/restaurant/food.jpg" alt="">
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-5">
                                <div class="title">
                                    <small>Local Amenities</small>
                                    <h3>Restaurants</h3>
                                    <p>Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.</p>
                                    <p><a href="about.html" class="btn_1 mt-1 outline">Read more</a></p>
                                </div>
                            </div>
                        </div>
                        <!-- /row-->
                        <div class="row justify-content-between d-flex align-items-center">
                            <div class="col-lg-6 order-lg-2">
                                <div class="pinned-image rounded_container pinned-image--small mb-4">
                                    <div class="pinned-image__container">
                                        <img src="img/art_culture.jpg" alt="">
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-5 order-lg-1">
                                <div class="title">
                                    <small>Local Amenities</small>
                                    <h3>Art & Culture</h3>
                                    <p>Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.</p>
                                    <p><a href="about.html" class="btn_1 mt-1 outline">Read more</a></p>
                                </div>
                            </div>
                        </div>
                        <!-- /row-->
                    </div>
                    <!-- /container-->
                </div>
                <!-- /bg_white -->

                <div class="parallax_section_1 jarallax" data-jarallax data-speed="0.2">
                    <img class="jarallax-img kenburns-2" src="img/hero_home_1.jpg" alt="">
                    <div class="wrapper opacity-mask d-flex align-items-center justify-content-center text-center" data-opacity-mask="rgba(0, 0, 0, 0.5)">
                        <div class="container">
                            <div class="row justify-content-center">
                                <div class="col-lg-8">
                                    <div class="title white">
                                        <small class="mb-1">Testimonials</small>
                                        <h2>What Clients Says</h2>
                                    </div>
                                    <div class="carousel_testimonials owl-carousel owl-theme nav-dots-orizontal">
                                        <c:forEach items="${feedbackList}" var="f">
                                            <div>
                                                <div class="box_overlay">
                                                    <div class="pic">
                                                        <figure><img src="img/testimonial_1.jpg" alt="" class="img-circle">
                                                        </figure>
                                                        <h4>${f.getUserAccount().getUsername()}
                                                            <small>
                                                                <fmt:formatDate value="${f.getCreated_at()}" pattern="MMM dd yyyy" />
                                                            </small>
                                                        </h4>
                                                    </div>
                                                    <div class="comment">
                                                        "${f.getComment()}"
                                                    </div>
                                                </div>
                                                <!-- End box_overlay -->
                                            </div>
                                        </c:forEach> 
                                    </div>
                                    <!-- End carousel_testimonials -->
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- /parallax_section_1-->


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
                                <p class="text-end mt-4"><a href="#0" class="btn_1 outline">Book Now</a></p>
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
                                <li><strong><a href="#0">info@paradisehotel.com</a></strong></li>
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
                                    <li><a href="index222.html">Home</a></li>
                                    <li><a href="about.html">About Us</a></li>
                                    <li><a href="searchRoomResult22.html">Rooms &amp; Suites</a></li>
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
            <script src="js/toastMessage.js"></script>
    </body>
</html>