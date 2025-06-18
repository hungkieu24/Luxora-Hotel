package Controller.Staff;

import Dal.HotelBranchDAO;
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
                || !"staff".equalsIgnoreCase(String.valueOf(session.getAttribute("userRole")))) {
            response.sendRedirect("login.jsp");
            return;
        }

        // ---- Lấy branchId từ session của staff ----
        Object branchIdObj = session.getAttribute("branchId");
        Integer branchId = null;
        if (branchIdObj instanceof Integer) {
            branchId = (Integer) branchIdObj;
        } else if (branchIdObj instanceof String) {
            try {
                branchId = Integer.parseInt((String) branchIdObj);
            } catch (NumberFormatException e) {
                branchId = null;
            }
        }
        // Nếu không có branchId -> lỗi, không cho xem phòng
        if (branchId == null) {
            request.setAttribute("errorMessage", "Staff information is invalid (no branch found).");
            response.sendRedirect("login.jsp");
            return;
        }

        // Đảm bảo branchName có trong session
        if (session.getAttribute("branchName") == null) {
            Integer branchIdInt = branchId;
            if (branchIdInt != null) {
                HotelBranchDAO branchDAO = new HotelBranchDAO();
                String branchName = branchDAO.getBranchNameById(branchIdInt);
                session.setAttribute("branchName", branchName);
            }
        }
        // Đặt branchName lên request để sidebar lấy ra hiển thị
        request.setAttribute("branchName", session.getAttribute("branchName"));
        
        
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
            rooms = roomDAO.searchRoomsByRoomTypeNameAndBranchPaging(keyword.trim(), branchId, page, pageSize);
            totalRoom = roomDAO.countRoomsByRoomTypeNameAndBranch(keyword.trim(), branchId);
        } else {
            rooms = roomDAO.pagingRoomByBranch(branchId, page, pageSize);
            totalRoom = roomDAO.countRoomsByBranch(branchId);
        }

        int totalPage = (int) Math.ceil((double) totalRoom / pageSize);

        Map<Integer, String> roomTypeMap = roomTypeDAO.getRoomTypeMap();
        Map<Integer, Double> roomTypePriceMap = roomTypeDAO.getRoomTypePriceMap(); 

        request.setAttribute("roomTypeMap", roomTypeMap);
        request.setAttribute("roomTypePriceMap", roomTypePriceMap); 
        request.setAttribute("rooms", rooms);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPage", totalPage);

        // --- AJAX support for live search ---
        if ("1".equals(request.getParameter("ajax"))) {
            // Trả về chỉ phần tbody (không render cả trang)
            request.getRequestDispatcher("staff-room-tablebody.jsp").forward(request, response);
            return;
        }

        request.getRequestDispatcher("staff-rooms.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String[] roomIds = request.getParameterValues("roomId");
            if (roomIds != null) {
                RoomDAO roomDAO = new RoomDAO();
                for (String roomIdStr : roomIds) {
                    int roomId = Integer.parseInt(roomIdStr);
                    String status = request.getParameter("status_" + roomId);
                    if (status != null && !status.isEmpty()) {
                        roomDAO.updateRoomStatus(roomId, status);
                    }
                }
            }
            response.sendRedirect("staff-rooms?message=statusUpdated");
        } catch (Exception e) {
            request.setAttribute("error", "Error updating room status: " + e.getMessage());
            doGet(request, response);
        }
    }
}