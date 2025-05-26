/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller;

import Dal.RoomDAO;
import Model.Room;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/room-detail")
public class RoomDetailServlet extends HttpServlet {
    private RoomDAO roomDAO;

    @Override
    public void init() throws ServletException {
        roomDAO = new RoomDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String roomIdParam = "1";

        if (roomIdParam != null && !roomIdParam.isEmpty()) {
            try {
                int roomId = Integer.parseInt(roomIdParam);
                Room room = roomDAO.getRoomById(roomId);

                if (room != null) {
                    request.setAttribute("room", room);
                    request.getRequestDispatcher("room-detail.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Room not found");
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid room ID");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Room ID is required");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("update".equals(action)) {
            updateRoom(request, response);
        } else if ("delete".equals(action)) {
            deleteRoom(request, response);
        } else if ("add".equals(action)) {
            addRoom(request, response);
        } else if ("updateStatus".equals(action)) {
            updateRoomStatus(request, response);
        }
    }

    private void addRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Room room = new Room();

            room.setRoomNumber(request.getParameter("roomNumber"));
            room.setBranchId(Integer.parseInt(request.getParameter("branchId")));
            room.setRoomTypeId(Integer.parseInt(request.getParameter("roomTypeId")));
            room.setStatus(request.getParameter("status"));
            room.setImageUrl(request.getParameter("imageUrl"));

            boolean success = roomDAO.addRoom(room);

            if (success) {
                response.sendRedirect("rooms?message=added");
            } else {
                request.setAttribute("error", "Failed to add room");
                request.setAttribute("room", room);
                request.getRequestDispatcher("add-room.jsp")
                       .forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error adding room: " + e.getMessage());
            request.getRequestDispatcher("add-room.jsp")
                   .forward(request, response);
        }
    }

    private void updateRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int roomId = Integer.parseInt(request.getParameter("id"));
            Room room = new Room();

            room.setId(roomId);
            room.setRoomNumber(request.getParameter("roomNumber"));
            room.setBranchId(Integer.parseInt(request.getParameter("branchId")));
            room.setRoomTypeId(Integer.parseInt(request.getParameter("roomTypeId")));
            room.setStatus(request.getParameter("status"));
            room.setImageUrl(request.getParameter("imageUrl"));

            boolean success = roomDAO.updateRoom(room);

            if (success) {
                response.sendRedirect("room-detail?id=" + roomId + "&message=updated");
            } else {
                request.setAttribute("error", "Failed to update room");
                request.setAttribute("room", room);
                request.getRequestDispatcher("room-detail.jsp")
                       .forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error updating room: " + e.getMessage());
            doGet(request, response);
        }
    }

    private void updateRoomStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int roomId = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");

            boolean success = roomDAO.updateRoomStatus(roomId, status);

            if (success) {
                response.sendRedirect("room-detail?id=" + roomId + "&message=statusUpdated");
            } else {
                request.setAttribute("error", "Failed to update room status");
                doGet(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error updating room status: " + e.getMessage());
            doGet(request, response);
        }
    }

    private void deleteRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int roomId = Integer.parseInt(request.getParameter("id"));
            boolean success = roomDAO.deleteRoom(roomId);

            if (success) {
                response.sendRedirect("rooms?message=deleted");
            } else {
                request.setAttribute("error", "Failed to delete room");
                doGet(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error deleting room: " + e.getMessage());
            doGet(request, response);
        }
    }
    
}