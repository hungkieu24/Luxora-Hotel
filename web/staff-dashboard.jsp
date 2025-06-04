<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Staff Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head>
<body class="bg-light">
<div class="container py-5">
    <div class="row mb-4">
        <div class="col-12">
            <h1 class="text-primary mb-3">
                <i class="bi bi-person-badge"></i> Staff Dashboard
            </h1>
            <hr>
        </div>
    </div>
    <div class="row g-4">
        <!-- Booking & Check-in/Check-out (Combined) -->
        <div class="col-md-6">
            <div class="card shadow-sm h-100">
                <div class="card-body d-flex flex-column align-items-center justify-content-center">
                    <i class="bi bi-list-ul display-4 text-primary mb-3"></i>
                    <h3 class="card-title">Today's Bookings & Check-in/Check-out</h3>
                    <p class="card-text text-center">
                        View, search, and perform check-in/check-out actions for today's bookings.
                    </p>
                    <a href="staff-bookings-checkin" class="btn btn-primary mt-2">
                        Manage Today's Bookings <i class="bi bi-arrow-right-circle"></i>
                    </a>
                </div>
            </div>
        </div>
        <!-- Other features if any -->
        <div class="col-md-6">
            <div class="card shadow-sm h-100">
                <div class="card-body d-flex flex-column align-items-center justify-content-center">
                    <i class="bi bi-door-closed display-4 text-secondary mb-3"></i>
                    <h3 class="card-title">Room Management</h3>
                    <p class="card-text text-center">
                        View status, update, and search for rooms in the hotel.
                    </p>
                    <a href="staff-rooms" class="btn btn-secondary mt-2">
                        Manage Rooms <i class="bi bi-arrow-right-circle"></i>
                    </a>
                </div>
            </div>
        </div>
        <!-- ... you can add more cards if needed -->
    </div>
</div>
</body>
</html>