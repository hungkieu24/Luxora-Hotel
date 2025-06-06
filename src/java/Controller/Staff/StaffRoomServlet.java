package Controller.Staff;

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
import jakarta.servlet.http.HttpSession;

@WebServlet(name = "StaffRoomServlet", urlPatterns = {"/staff-rooms"})
public class StaffRoomServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
            // --- VALIDATION: Check staff session/role ---
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userRole") == null
                || !"staff".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String keyword = request.getParameter("keyword");
        int page = 1;
        int pageSize = 8; 

        try {
            if (request.getParameter("page") != null) {
                page = Integer.parseInt(request.getParameter("page"));
            }
        } catch (NumberFormatException e) {
            page = 1;
        }

        RoomDAO roomDAO = new RoomDAO();
        RoomTypeDAO roomTypeDAO = new RoomTypeDAO();

        List<Room> rooms;
        int totalRoom = 0;
        if (keyword != null && !keyword.trim().isEmpty()) {
            rooms = roomDAO.searchRoomsByRoomTypeNamePaging(keyword.trim(), page, pageSize);
            totalRoom = roomDAO.countRoomsByRoomTypeName(keyword.trim());
        } else {    
            rooms = roomDAO.pagingRoom(page, pageSize);
            totalRoom = roomDAO.countAllRooms();
        }

        int totalPage = (int) Math.ceil((double) totalRoom / pageSize);

        Map<Integer, String> roomTypeMap = roomTypeDAO.getRoomTypeMap();
        request.setAttribute("roomTypeMap", roomTypeMap);
        request.setAttribute("rooms", rooms);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPage", totalPage);

        request.getRequestDispatcher("staff-rooms.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            String status = request.getParameter("status");

            RoomDAO roomDAO = new RoomDAO();
            roomDAO.updateRoomStatus(roomId, status);

            response.sendRedirect("staff-rooms?message=statusUpdated");
        } catch (Exception e) {
            request.setAttribute("error", "Error updating room status: " + e.getMessage());
            doGet(request, response);
        }
    }
}
