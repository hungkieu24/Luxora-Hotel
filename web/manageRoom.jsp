<%-- 
    Document   : manageRoom
    Created on : Jun 2, 2025, 12:53:55 AM
    Author     : thien
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage Rooms</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
        <style>
            .table-container {
                margin: 20px;
            }
            .filter-select {
                width: 150px;
                margin-right: 10px;
            }
            .create-btn {
                margin-bottom: 20px;
            }
            .status-available {
                background-color: #d4edda;
                color: #155724;
            }
            .status-occupied {
                background-color: #f8d7da;
                color: #721c24;
            }
            .status-booked {
                background-color: #fff3cd;
                color: #856404;
            }
            .status-maintenance {
                background-color: #cce5ff;
                color: #004085;
            }
        </style>
    </head>
    <body>

        <div class="container">
            <h2>Manage Rooms</h2>
            <button class="btn btn-primary create-btn" onclick="window.location.href = 'createRoom'">+ Create room</button>
            <form method="get">
                <div class="row mb-3">
                    <div class="col">
                        <select class="form-select filter-select" name="status" onchange="this.form.submit()">
                            <option value="">All Status</option>
                            <option value="Available" ${param.status == 'Available' ? 'selected' : ''}>Available</option>
                            <option value="Occupied" ${param.status == 'Occupied' ? 'selected' : ''}>Occupied</option>
                            <option value="Booked" ${param.status == 'Booked' ? 'selected' : ''}>Booked</option>
                            <option value="Maintenance" ${param.status == 'Maintenance' ? 'selected' : ''}>Maintenance</option>
                        </select>
                    </div>
                    <div class="col">
                        <select class="form-select filter-select" name="roomType" onchange="this.form.submit()">
                            <option value="">All Room Types</option>
                            <c:forEach var="roomType" items="${roomTypes}">
                                <option value="${roomType.roomTypeID}" 
                                        <c:if test="${param.roomType == roomType.roomTypeID}">selected</c:if>>
                                    ${roomType.name}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col">
                        <input type="text" class="form-control" name="search" value="${param.search}" placeholder="Search" onchange="this.form.submit()">
                    </div>
                </div>

                <div class="table-container">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Room Number</th>
                                <th>Room Type</th>
                                <th>Price Per Night</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="room" items="${rooms}">
                                <tr>
                                    <td>${room.roomNumber}</td>
                                    <td>${room.roomType.name}</td>
                                    <td>${room.roomType.base_price} VND</td>
                                    <td class="status-${room.status.toLowerCase()}">${room.status}</td>
                                    <td><a href="editRoom.jsp?id=${room.id}" class="btn btn-sm btn-primary">Edit</a></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

        </div>
    </form>
</body>
</html>
