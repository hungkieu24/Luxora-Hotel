/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller;

import Dal.RoomDAO;
import Dal.RoomTypeDAO;
import Model.Room;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Admin
 */
@WebServlet(name = "StaffRoomServlet", urlPatterns = {"/staff-rooms"})
public class StaffRoomServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        RoomDAO roomDAO = new RoomDAO();
        RoomTypeDAO roomTypeDAO = new RoomTypeDAO();

        List<Room> rooms;
        Map<Integer, String> roomTypeMap = roomTypeDAO.getRoomTypeMap();
        request.setAttribute("roomTypeMap", roomTypeMap);

        if (keyword != null && !keyword.trim().isEmpty()) {
            rooms = roomDAO.searchRoomsByRoomTypeName(keyword.trim()); // <-- Tìm theo tên RoomType
        } else {
            rooms = roomDAO.getAllRooms();
        }

        request.setAttribute("rooms", rooms);
        request.getRequestDispatcher("staff-rooms.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int roomId = Integer.parseInt(request.getParameter("roomId"));
        String status = request.getParameter("status");

        RoomDAO roomDAO = new RoomDAO();
        roomDAO.updateRoomStatus(roomId, status);

        response.sendRedirect("staff-rooms");
    }
}

