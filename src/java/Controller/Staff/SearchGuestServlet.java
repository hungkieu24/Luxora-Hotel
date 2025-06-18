package Controller.Staff;

import Dal.UserAccountDAO;
import Dal.RoomDAO;
import Model.UserAccount;
import Model.RoomType;
import Model.Room;
import java.io.IOException;
import java.util.List;
import java.util.regex.Pattern;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name="SearchGuestServlet", urlPatterns={"/searchGuest"})
public class SearchGuestServlet extends HttpServlet {

    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[a-zA-Z0-9_\\-.]+@[a-zA-Z0-9\\-.]+\\.[a-zA-Z]{2,}$");
    private static final Pattern PHONE_PATTERN = Pattern.compile("^(0\\d{9,10}|\\+84\\d{9,10})$");
 
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("searchGuest.jsp").forward(request, response);
    }

    // Xử lý tìm kiếm khi submit form POST
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");

        // Validate input: not null and not empty
        if (keyword == null || keyword.trim().isEmpty()) {
            request.setAttribute("errorMsg", "Please enter an email or phone number.");
            request.getRequestDispatcher("searchGuest.jsp").forward(request, response);
            return;
        }

        keyword = keyword.trim();
        boolean isEmail = EMAIL_PATTERN.matcher(keyword).matches();
        boolean isPhone = PHONE_PATTERN.matcher(keyword).matches();

        // Validate if input is a valid email or phone number
        if (!isEmail && !isPhone) {
            request.setAttribute("errorMsg", "Invalid email or phone number format.");
            request.getRequestDispatcher("searchGuest.jsp").forward(request, response);
            return;
        }

        UserAccountDAO userDao = new UserAccountDAO();
        UserAccount guest = userDao.getUserByEmailOrPhone(keyword);

        if (guest == null) {
            request.setAttribute("errorMsg", "Account does not exist. Please register a new one.");
            request.getRequestDispatcher("searchGuest.jsp").forward(request, response);
            return;
        }

        // Lấy staff từ session để lấy branch
        UserAccount staff = (UserAccount) request.getSession().getAttribute("user");
        Integer branchId = (staff != null) ? staff.getBranchId() : null;

        List<RoomType> roomTypes = null;
        List<Room> rooms = null;
        if (branchId != null) {
            RoomDAO roomDao = new RoomDAO();
            roomTypes = roomDao.getRoomTypesByBranch(branchId);
            rooms = roomDao.getAvailableRoomsByBranch(branchId);
        }

      
        request.setAttribute("guest", guest);
        request.setAttribute("roomTypes", roomTypes);
        request.setAttribute("rooms", rooms);
        request.getRequestDispatcher("createWalkInBooking.jsp").forward(request, response);
    }
}