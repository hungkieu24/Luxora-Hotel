<%-- 
    Document   : createRoom
    Created on : Jun 2, 2025, 1:56:26 AM
    Author     : thien
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Create Room</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    </head>
    <body>
        <div class="container" style="margin-top: 20px;">
            <h2>Create Room</h2>
            <form action="createRoom" method="post" enctype="multipart/form-data">
                <div class="mb-3">
                    <label class="form-label">Room Number</label>
                    <input type="text" class="form-control" name="roomNumber" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Branch ID</label>
                    <input type="number" class="form-control" name="branchId" required>
                </div>
                <div class="mb-3">
                    <label class="form-label">Room Type</label>
                    <select class="form-select" name="roomTypeId" required>
                        <c:forEach var="roomType" items="${roomTypes}">
                            <option value="${roomType.roomTypeID}">${roomType.name}</option>
                        </c:forEach>
                            
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Status</label>
                    <select class="form-select" name="status" required>
                        <option value="Available">Available</option>
                        <option value="Occupied">Occupied</option>
                        <option value="Booked">Booked</option>
                        <option value="Maintenance">Maintenance</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Image</label>
                    <input type="file" class="form-control" name="image" accept="image/*">
                </div>
                <button type="submit" class="btn btn-primary">Create</button>
                <a href="manageRooms" class="btn btn-secondary">Back</a>
            </form>
        </div>
    </body>
</html>
