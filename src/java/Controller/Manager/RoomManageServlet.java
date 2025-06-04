/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.Manager;

import Dal.RoomDAO;
import Dal.RoomTypeDAO;
import Model.Room;
import Model.RoomType;
import Model.UserAccount;
import Utility.UploadImage;
import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.util.List;

/**
 *
 * @author thien
 */
@WebServlet(name = "RoomManageServlet", urlPatterns = {"/rooms"})
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class RoomManageServlet extends HttpServlet {

    private RoomDAO r = new RoomDAO();
    private RoomTypeDAO rt = new RoomTypeDAO();
    private UploadImage uploadImage = new UploadImage();
    private final static String UPLOAD_DIR = "/img/rooms";// thư mục lưu ảnh

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserAccount user = (UserAccount) session.getAttribute("user");

        if (user != null) {
            // Lấy tên chi nhánh và tên manager
            String username = user.getUsername();
            String userId = user.getId();

            String branchname = r.getBranchNameById(userId);
            int branchId = r.getBranchId(userId);
            //lấy list room và roomtype
            List<Room> rooms = r.getAllRoomByBranchId(branchId);
            List<RoomType> roomtypes = rt.getAllRoomType();

            // set thuộc tính
            request.setAttribute("branchId", branchId);
            request.setAttribute("username", username);
            request.setAttribute("userId", userId);
            request.setAttribute("branchname", branchname);
            request.setAttribute("rooms", rooms);
            request.setAttribute("roomtypes", roomtypes);
            request.getRequestDispatcher("roomManage.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "don't see user");
            response.sendRedirect("login");
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserAccount user = (UserAccount) session.getAttribute("user");
        if (user == null) {
            request.setAttribute("error", "User not logged in.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        String userId = user.getId();
        int branchId = r.getBranchId(userId);

        // Lấy dữ liệu từ form
        String roomNumber = request.getParameter("room_number");
        String roomTypeParam = request.getParameter("room_type");
        String status = request.getParameter("status");
        String capacityParam = request.getParameter("capacity");
        String priceParam = request.getParameter("price");
        String description = request.getParameter("description");

        // Validation
        StringBuilder errors = new StringBuilder();

        if (roomNumber == null || roomNumber.trim().isEmpty()) {
            errors.append("Room number cannot be empty. ");
        }
        if (r.isRoomNumberExist(roomNumber, branchId)) {
            errors.append("Room number already exists. ");
        }
        if (branchId <= 0) {
            errors.append("Invalid branch ID. ");
        }
        if (roomTypeParam == null || roomTypeParam.trim().isEmpty()) {
            errors.append("Please select a room type. ");
        }
        if (status == null || !List.of("Available", "Occupied", "Maintenance", "Cleaning").contains(status)) {
            errors.append("Invalid status. ");
        }
        if (capacityParam == null || capacityParam.trim().isEmpty()) {
            errors.append("Capacity cannot be empty. ");
        }
        if (priceParam == null || priceParam.trim().isEmpty()) {
            errors.append("Price cannot be empty. ");
        }

        // Parse các giá trị số
        int roomTypeId = 0;
        int capacity = 0;
        double price = 0;

        try {
            if (roomTypeParam != null && !roomTypeParam.trim().isEmpty()) {
                roomTypeId = Integer.parseInt(roomTypeParam);
            }
            if (capacityParam != null && !capacityParam.trim().isEmpty()) {
                capacity = Integer.parseInt(capacityParam);
            }
            if (priceParam != null && !priceParam.trim().isEmpty()) {
                price = Double.parseDouble(priceParam);
            }
        } catch (NumberFormatException e) {
            errors.append("Invalid number format for room type, capacity, or price. ");
        }

        // Validation sau khi parse
        if (roomTypeId <= 0) {
            errors.append("Invalid room type. ");
        }
        if (capacity <= 0) {
            errors.append("Capacity must be greater than 0. ");
        }
        if (price <= 0) {
            errors.append("Price must be greater than 0. ");
        }

        // Xử lý upload ảnh
        String imageUrl = "";
        String uploadPath = request.getServletContext().getRealPath(UPLOAD_DIR); // Lấy đường dẫn thực tế
        try {
            imageUrl = uploadImage.uploadImage(request, "image", uploadPath); // Truyền tên input "image"
            if (imageUrl == null || imageUrl.isEmpty()) {
                errors.append("Failed to upload image or invalid image type. ");
            } else {
                imageUrl = UPLOAD_DIR + "/" + imageUrl; // Đường dẫn tương đối để lưu vào DB
            }
        } catch (Exception e) {
            e.printStackTrace();
            errors.append("Failed to upload image: " + e.getMessage() + ". ");
        }

        // Nếu có lỗi, trả về JSP với dữ liệu
        if (errors.length() > 0) {
            request.setAttribute("error", errors.toString());
            List<Room> rooms = r.getAllRoomByBranchId(branchId);
            List<RoomType> roomTypes = rt.getAllRoomType();
            request.setAttribute("rooms", rooms);
            request.setAttribute("roomtypes", roomTypes);
            request.getRequestDispatcher("roomManage.jsp").forward(request, response);
            return;
        }

        // Tạo đối tượng Room
        Room room = new Room();
        room.setRoomNumber(roomNumber);
        room.setRoomTypeId(roomTypeId);
        room.setBranchId(branchId);
        room.setStatus(status);
        room.setImageUrl(imageUrl);

        // Thêm Room vào cơ sở dữ liệu
        boolean add = r.addRoom(room);
        if (add) {
            // Cập nhật RoomType (nếu cần)
            rt.updateRoomType(roomTypeId, price, capacity, description);
            response.sendRedirect("rooms");
        } else {
            request.setAttribute("error", "Failed to add new room.");
            List<Room> rooms = r.getAllRoomByBranchId(branchId);
            List<RoomType> roomTypes = rt.getAllRoomType();
            request.setAttribute("rooms", rooms);
            request.setAttribute("roomtypes", roomTypes);
            request.getRequestDispatcher("roomManage.jsp").forward(request, response);
        }
    }

}
