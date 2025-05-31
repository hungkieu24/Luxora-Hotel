<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Staff Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
</head>
<body class="bg-light">
<div class="container py-5">
    <div class="card shadow-sm">
        <div class="card-body text-center">
            <h1 class="mb-4"><i class="bi bi-speedometer2"></i> Staff Dashboard</h1>
            <div class="row justify-content-center">
                <div class="col-md-4 mb-3">
                    <a href="staff-bookings" class="btn btn-primary btn-lg w-100">
                        <i class="bi bi-list-ul"></i> Today's Bookings Management
                    </a>
                </div>
                <div class="col-md-4 mb-3">
                    <a href="staff-checkin" class="btn btn-success btn-lg w-100">
                        <i class="bi bi-check2-square"></i> Check-in/Check-out
                    </a>
                </div>
                <div class="col-md-4 mb-3">
                    <a href="staff-rooms" class="btn btn-warning btn-lg w-100">
                        <i class="bi bi-door-open"></i> Room Management
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>