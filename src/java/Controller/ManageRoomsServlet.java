/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller;

import Dal.RoomDAO;
import Dal.RoomTypeDAO;
import Model.Room;
import Model.RoomType;
import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.util.List;

/**
 *
 * @author thien
 */
@WebServlet(name="ManageRoomsServlet", urlPatterns={"/manageRooms"})
public class ManageRoomsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RoomTypeDAO rtDao = new RoomTypeDAO();
        RoomDAO rDao = new RoomDAO();
        List<RoomType> roomTypes = rtDao.getAllRoomType();
        // lay phong cho bo loc
        String status = request.getParameter("status");
        String roomType = request.getParameter("roomType");
        String search = request.getParameter("search");
        
        List<Room> rooms = rDao.getRooms(status, roomType, search);
        request.setAttribute("rooms", rooms);
        request.setAttribute("roomTypes", roomTypes);
        request.getRequestDispatcher("manageRoom.jsp").forward(request, response);
    }
  
}
