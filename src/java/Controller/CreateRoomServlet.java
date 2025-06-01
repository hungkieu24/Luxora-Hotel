/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import Dal.RoomDAO;
import Dal.RoomTypeDAO;
import Model.Room;
import Model.RoomType;
import Utility.UploadImage;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

/**
 *
 * @author thien
 */
@WebServlet(name = "CreateRoomServlet", urlPatterns = {"/createRoom"})
@MultipartConfig(maxFileSize = 1024 * 1024 * 5)
public class CreateRoomServlet extends HttpServlet {

    RoomTypeDAO rtDao = new RoomTypeDAO();
    RoomDAO rDao = new RoomDAO();
    UploadImage uploadImage;
    final static String UPLOAD_DIR = "C:/upload/images/";// Define your upload directory

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<RoomType> roomTypes = rtDao.getAllRoomType();
           
            request.setAttribute("roomTypes", roomTypes);
            request.getRequestDispatcher("createRoom.jsp").forward(request, response);
            

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load room types: " + e.getMessage());
            request.getRequestDispatcher("createRoom.jsp").forward(request, response);

        }
    }
    

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String roomNumber = request.getParameter("roomNumber");
        int branchId = Integer.parseInt(request.getParameter("branchId"));
        int roomTypeId = Integer.parseInt(request.getParameter("roomTypeId"));
        String status = request.getParameter("status");
        String imageUrl = null;
        try {
            imageUrl = uploadImage.uploadImage(request, "image", UPLOAD_DIR);
            if (imageUrl == null) {
                imageUrl = ""; // Default to empty if no image uploaded
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to upload image: " + e.getMessage());
            request.getRequestDispatcher("createRoom.jsp").forward(request, response);
            return;
        }
        // Create a Room object
        Room room = new Room(roomNumber, branchId, roomTypeId, status, imageUrl);

        try {
            // Use DAO to create the room
            rDao.createRoom(room);
            response.sendRedirect("manageRooms");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to create room: " + e.getMessage());
            request.getRequestDispatcher("createRoom.jsp").forward(request, response);
        }
    }

}
