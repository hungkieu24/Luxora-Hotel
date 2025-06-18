package Dal;

import Model.Booking;
import Model.Room;
import Model.UserAccount;
import java.math.BigDecimal;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO extends DBcontext.DBContext {

    // Lấy booking hôm nay theo chi nhánh (staff chỉ xem booking thuộc chi nhánh của mình)
    public List<Booking> getBookingsTodayByBranch(int branchId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT "
                + "b.id, b.user_id, b.booking_time, b.check_in, b.check_out, "
                + "b.status, b.total_price, b.deposit, b.payment_status, "
                + "b.cancel_reason, b.cancel_time, b.promotion_id, "
                + "u.username, "
                + "STRING_AGG(rt.name, ', ') AS roomTypes "
                + "FROM Booking b "
                + "LEFT JOIN UserAccount u ON b.user_id = u.id "
                + "LEFT JOIN BookingRoom br ON b.id = br.booking_id "
                + "LEFT JOIN Room r ON br.room_id = r.id "
                + "LEFT JOIN RoomType rt ON r.room_type_id = rt.id "
                + "WHERE (CAST(b.check_in AS date) = CAST(GETDATE() AS date) "
                + "   OR CAST(b.check_out AS date) = CAST(GETDATE() AS date)) "
                + "AND r.branch_id = ? "
                + "GROUP BY "
                + "b.id, b.user_id, b.booking_time, b.check_in, b.check_out, "
                + "b.status, b.total_price, b.deposit, b.payment_status, "
                + "b.cancel_reason, b.cancel_time, b.promotion_id, u.username";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, branchId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = new Booking();
                    b.setId(rs.getInt("id"));
                    b.setUserId(rs.getString("user_id"));
                    b.setBookingTime(rs.getTimestamp("booking_time"));
                    b.setCheckIn(rs.getTimestamp("check_in"));
                    b.setCheckOut(rs.getTimestamp("check_out"));
                    b.setStatus(rs.getString("status"));
                    b.setTotalPrice(rs.getDouble("total_price"));
                    b.setDeposit(rs.getDouble("deposit"));
                    b.setPaymentStatus(rs.getString("payment_status"));
                    b.setCancelReason(rs.getString("cancel_reason"));
                    b.setCancelTime(rs.getTimestamp("cancel_time"));
                    b.setPromotionId(rs.getInt("promotion_id"));
                    b.setUserName(rs.getString("username"));
                    b.setRoomTypes(rs.getString("roomTypes"));
                    b.setRoomNumbers(getRoomNumbersByBookingId(b.getId())); // Set roomNumbers!
                    list.add(b);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lay booking theo userID
    public List<Booking> getBookingByUserId(String userId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM Booking WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setUserId(rs.getString("user_id"));
                booking.setBookingTime(rs.getTimestamp("booking_time"));
                booking.setCheckIn(rs.getTimestamp("check_in"));
                booking.setCheckOut(rs.getTimestamp("check_out"));
                booking.setStatus(rs.getString("status"));
                booking.setTotalPrice(rs.getDouble("total_price"));
                booking.setDeposit(rs.getDouble("deposit"));
                booking.setPaymentStatus(rs.getString("payment_status"));
                booking.setCancelReason(rs.getString("cancel_reason"));
                booking.setCancelTime(rs.getTimestamp("cancel_time"));
                booking.setPromotionId(rs.getInt("promotion_id"));
                // Nếu Booking có các field bổ sung như roomTypes, userName... bạn có thể map thêm nếu cần (hoặc bỏ qua)
                bookings.add(booking);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return bookings;
    }

    // Lấy danh sách booking theo userId và branch (nếu cần)
    public List<Booking> getBookingsByUserIdAndBranch(String userId, int branchId) throws SQLException {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, u.username, "
                + "STRING_AGG(rt.name, ', ') AS roomTypes "
                + "FROM Booking b "
                + "LEFT JOIN UserAccount u ON b.user_id = u.id "
                + "LEFT JOIN BookingRoom br ON b.id = br.booking_id "
                + "LEFT JOIN Room r ON br.room_id = r.id "
                + "LEFT JOIN RoomType rt ON r.room_type_id = rt.id "
                + "WHERE b.user_id = ? AND r.branch_id = ? "
                + "GROUP BY b.id, b.user_id, b.booking_time, b.check_in, b.check_out, b.status, "
                + "b.total_price, b.deposit, b.payment_status, b.cancel_reason, b.cancel_time, "
                + "b.promotion_id, u.username";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, userId);
            ps.setInt(2, branchId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Booking b = new Booking();
                b.setId(rs.getInt("id"));
                b.setUserId(rs.getString("user_id"));
                b.setBookingTime(rs.getTimestamp("booking_time"));
                b.setCheckIn(rs.getTimestamp("check_in"));
                b.setCheckOut(rs.getTimestamp("check_out"));
                b.setStatus(rs.getString("status"));
                b.setTotalPrice(rs.getDouble("total_price"));
                b.setDeposit(rs.getDouble("deposit"));
                b.setPaymentStatus(rs.getString("payment_status"));
                b.setCancelReason(rs.getString("cancel_reason"));
                b.setCancelTime(rs.getTimestamp("cancel_time"));
                b.setPromotionId(rs.getInt("promotion_id"));
                b.setUserName(rs.getString("username"));
                b.setRoomTypes(rs.getString("roomTypes"));
                b.setRooms(getRoomsByBookingIdAndBranch(b.getId(), branchId));
                list.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }


    // Lấy booking theo bookingId, nhưng chỉ khi booking thuộc branchId
    public Booking getBookingByIdAndBranch(int bookingId, int branchId) {
        Booking booking = null;
        String sql = "SELECT b.*, u.username, u.email, "
                + "STRING_AGG(r.room_number, ', ') AS roomNumbers "
                + "FROM Booking b "
                + "LEFT JOIN UserAccount u ON b.user_id = u.id "
                + "LEFT JOIN BookingRoom br ON b.id = br.booking_id "
                + "LEFT JOIN Room r ON br.room_id = r.id "
                + "WHERE b.id = ? AND r.branch_id = ? "
                + "GROUP BY b.id, b.user_id, b.booking_time, b.check_in, b.check_out, b.status, "
                + "b.total_price, b.deposit, b.payment_status, b.cancel_reason, b.cancel_time, "
                + "b.promotion_id, u.username, u.email";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, bookingId);
            ps.setInt(2, branchId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setUserId(rs.getString("user_id"));
                booking.setBookingTime(rs.getTimestamp("booking_time"));
                booking.setCheckIn(rs.getTimestamp("check_in"));
                booking.setCheckOut(rs.getTimestamp("check_out"));
                booking.setStatus(rs.getString("status"));
                booking.setTotalPrice(rs.getDouble("total_price"));
                booking.setDeposit(rs.getDouble("deposit"));
                booking.setPaymentStatus(rs.getString("payment_status"));
                booking.setCancelReason(rs.getString("cancel_reason"));
                booking.setCancelTime(rs.getTimestamp("cancel_time"));
                booking.setPromotionId(rs.getInt("promotion_id"));
                booking.setUserName(rs.getString("username"));
                booking.setRoomNumbers(rs.getString("roomNumbers"));
                booking.setRooms(getRoomsByBookingIdAndBranch(bookingId, branchId));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return booking;
    }

    // Lấy danh sách phòng theo booking và branch
    public List<Room> getRoomsByBookingIdAndBranch(int bookingId, int branchId) {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT r.*, rt.name AS roomTypeName, hb.name AS hotelName "
                + "FROM BookingRoom br "
                + "JOIN Room r ON br.room_id = r.id "
                + "LEFT JOIN RoomType rt ON r.room_type_id = rt.id "
                + "LEFT JOIN HotelBranch hb ON r.branch_id = hb.id "
                + "WHERE br.booking_id = ? AND r.branch_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, bookingId);
            ps.setInt(2, branchId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Room room = new Room();
                room.setId(rs.getInt("id"));
                room.setRoomNumber(rs.getString("room_number"));
                room.setBranchId(rs.getInt("branch_id"));
                room.setRoomTypeId(rs.getInt("room_type_id"));
                room.setStatus(rs.getString("status"));
                room.setImageUrl(rs.getString("image_url"));
                rooms.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    // Lấy danh sách room_id theo booking_id (phục vụ cho StaffCheckinServlet/StaffCheckOutServlet)
    public List<Integer> getRoomIdsByBookingAndBranch(int bookingId, int branchId) {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT r.id FROM BookingRoom br "
                + "JOIN Room r ON br.room_id = r.id "
                + "WHERE br.booking_id = ? AND r.branch_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, bookingId);
            ps.setInt(2, branchId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ids.add(rs.getInt("id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ids;
    }

    // Cập nhật trạng thái booking
    public boolean updateBookingStatus(int bookingId, String status) {
        String sql = "UPDATE Booking SET status = ? WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, bookingId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Hủy booking với lý do
    public boolean cancelBooking(int bookingId, String cancelReason) {
        String sql = "UPDATE Booking SET status = 'CANCELLED', cancel_reason = ?, cancel_time = ? WHERE id = ? AND status IN ('Pending', 'Confirmed')";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, cancelReason);
            ps.setTimestamp(2, new Timestamp(System.currentTimeMillis())); // Thời gian hủy
            ps.setInt(3, bookingId);
            int rowsAffected = ps.executeUpdate();
            ps.close();
            return rowsAffected > 0; // Trả về true nếu cập nhật thành công
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

//    public Booking getBookingById(int bookingId) {
//        Booking booking = null;
//        String sql = "SELECT b.*, u.username, u.email, "
//                + "STRING_AGG(rt.name, ', ') AS roomTypes "
//                + "FROM Booking b "
//                + "LEFT JOIN UserAccount u ON b.user_id = u.id "
//                + "LEFT JOIN BookingRoom br ON b.id = br.booking_id "
//                + "LEFT JOIN Room r ON br.room_id = r.id "
//                + "LEFT JOIN RoomType rt ON r.room_type_id = rt.roomTypeID "
//                + "WHERE b.id = ? "
//                + "GROUP BY b.id, b.user_id, b.booking_time, b.check_in, b.check_out, b.status, "
//                + "b.total_price, b.deposit, b.payment_status, b.cancel_reason, b.cancel_time, "
//                + "b.promotion_id, u.username, u.email";
//        try {
//            PreparedStatement ps = connection.prepareStatement(sql);
//            ps.setInt(1, bookingId);
//            ResultSet rs = ps.executeQuery();
//            if (rs.next()) {
//                booking = new Booking();
//                booking.setId(rs.getInt("id"));
//                booking.setUserId(rs.getString("user_id"));
//                booking.setBookingTime(rs.getTimestamp("booking_time"));
//                booking.setCheckIn(rs.getTimestamp("check_in"));
//                booking.setCheckOut(rs.getTimestamp("check_out"));
//                booking.setStatus(rs.getString("status"));
//                booking.setTotalPrice(rs.getDouble("total_price"));
//                booking.setDeposit(rs.getDouble("deposit"));
//                booking.setPaymentStatus(rs.getString("payment_status"));
//                booking.setCancelReason(rs.getString("cancel_reason"));
//                booking.setCancelTime(rs.getTimestamp("cancel_time"));
//                booking.setPromotionId(rs.getInt("promotion_id"));
//                booking.setUserName(rs.getString("username"));
//                booking.setRoomTypes(rs.getString("roomTypes"));
//                booking.setRooms(getRoomsByBookingId(bookingId));
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return booking;
//    }
//
//    public List<Room> getRoomsByBookingId(int bookingId) {
//        List<Room> rooms = new ArrayList<>();
//        String sql = "SELECT r.*, rt.name AS roomTypeName, hb.name AS hotelName "
//                + "FROM BookingRoom br "
//                + "JOIN Room r ON br.room_id = r.id "
//                + "LEFT JOIN RoomType rt ON r.room_type_id = rt.roomTypeID "
//                + "LEFT JOIN HotelBranch hb ON r.branch_id = hb.id "
//                + "WHERE br.booking_id = ?";
//        try {
//            PreparedStatement ps = connection.prepareStatement(sql);
//            ps.setInt(1, bookingId);
//            ResultSet rs = ps.executeQuery();
//            while (rs.next()) {
//                Room room = new Room();
//                room.setId(rs.getInt("id"));
//                room.setRoomNumber(rs.getString("room_number"));
//                room.setBranchId(rs.getInt("branch_id"));
//                room.setRoomTypeId(rs.getInt("room_type_id"));
//                room.setStatus(rs.getString("status"));
//                room.setImageUrl(rs.getString("image_url"));
//                room.setRoomTypeName(rs.getString("roomTypeName"));
//                room.setHotelName(rs.getString("hotelName"));
//                rooms.add(room);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return rooms;
//    }

    // Tìm kiếm booking hôm nay theo customer và branch
    public List<Booking> searchBookingsTodayByCustomerAndBranch(String keyword, int branchId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, u.username, "
                + "STRING_AGG(rt.name, ', ') AS roomTypes "
                + "FROM Booking b "
                + "LEFT JOIN UserAccount u ON b.user_id = u.id "
                + "LEFT JOIN BookingRoom br ON b.id = br.booking_id "
                + "LEFT JOIN Room r ON br.room_id = r.id "
                + "LEFT JOIN RoomType rt ON r.room_type_id = rt.id "
                + "WHERE (CAST(b.check_in AS date) = CAST(GETDATE() AS date) "
                + "   OR CAST(b.check_out AS date) = CAST(GETDATE() AS date)) "
                + "AND u.username LIKE ? "
                + "AND r.branch_id = ? "
                + "GROUP BY b.id, b.user_id, b.booking_time, b.check_in, b.check_out, b.status, "
                + "b.total_price, b.deposit, b.payment_status, b.cancel_reason, b.cancel_time, "
                + "b.promotion_id, u.username";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setInt(2, branchId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = new Booking();
                    b.setId(rs.getInt("id"));
                    b.setUserId(rs.getString("user_id"));
                    b.setBookingTime(rs.getTimestamp("booking_time"));
                    b.setCheckIn(rs.getTimestamp("check_in"));
                    b.setCheckOut(rs.getTimestamp("check_out"));
                    b.setStatus(rs.getString("status"));
                    b.setTotalPrice(rs.getDouble("total_price"));
                    b.setDeposit(rs.getDouble("deposit"));
                    b.setPaymentStatus(rs.getString("payment_status"));
                    b.setCancelReason(rs.getString("cancel_reason"));
                    b.setCancelTime(rs.getTimestamp("cancel_time"));
                    b.setPromotionId(rs.getInt("promotion_id"));
                    b.setUserName(rs.getString("username"));
                    b.setRoomTypes(rs.getString("roomTypes"));
                    list.add(b);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Phân trang booking hôm nay theo chi nhánh
    public List<Booking> getBookingsTodayByBranchPaging(int branchId, int page, int pageSize) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT "
                + "b.id, b.user_id, b.booking_time, b.check_in, b.check_out, "
                + "b.status, b.total_price, b.deposit, b.payment_status, "
                + "b.cancel_reason, b.cancel_time, b.promotion_id, "
                + "u.username, "
                + "STRING_AGG(rt.name, ', ') AS roomTypes "
                + "FROM Booking b "
                + "LEFT JOIN UserAccount u ON b.user_id = u.id "
                + "LEFT JOIN BookingRoom br ON b.id = br.booking_id "
                + "LEFT JOIN Room r ON br.room_id = r.id "
                + "LEFT JOIN RoomType rt ON r.room_type_id = rt.id "
                + "WHERE (CAST(b.check_in AS date) = CAST(GETDATE() AS date) "
                + "   OR CAST(b.check_out AS date) = CAST(GETDATE() AS date)) "
                + "AND r.branch_id = ? "
                + "GROUP BY "
                + "b.id, b.user_id, b.booking_time, b.check_in, b.check_out, "
                + "b.status, b.total_price, b.deposit, b.payment_status, "
                + "b.cancel_reason, b.cancel_time, b.promotion_id, u.username "
                + "ORDER BY b.id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, branchId);
            ps.setInt(2, (page - 1) * pageSize);
            ps.setInt(3, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = new Booking();
                    b.setId(rs.getInt("id"));
                    b.setUserId(rs.getString("user_id"));
                    b.setBookingTime(rs.getTimestamp("booking_time"));
                    b.setCheckIn(rs.getTimestamp("check_in"));
                    b.setCheckOut(rs.getTimestamp("check_out"));
                    b.setStatus(rs.getString("status"));
                    b.setTotalPrice(rs.getDouble("total_price"));
                    b.setDeposit(rs.getDouble("deposit"));
                    b.setPaymentStatus(rs.getString("payment_status"));
                    b.setCancelReason(rs.getString("cancel_reason"));
                    b.setCancelTime(rs.getTimestamp("cancel_time"));
                    b.setPromotionId(rs.getInt("promotion_id"));
                    b.setUserName(rs.getString("username"));
                    b.setRoomTypes(rs.getString("roomTypes"));
                    b.setRoomNumbers(getRoomNumbersByBookingId(b.getId())); // Set roomNumbers!
                    list.add(b);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Đếm tổng số booking hôm nay theo chi nhánh
    public int countBookingsTodayByBranch(int branchId) {
        String sql = "SELECT COUNT(DISTINCT b.id) AS total FROM Booking b "
                + "JOIN BookingRoom br ON b.id = br.booking_id "
                + "JOIN Room r ON br.room_id = r.id "
                + "WHERE (CAST(b.check_in AS date) = CAST(GETDATE() AS date) "
                + "   OR CAST(b.check_out AS date) = CAST(GETDATE() AS date)) "
                + "AND r.branch_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, branchId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }


    // Phân trang và tìm kiếm booking hôm nay theo customer và branch
    public List<Booking> searchBookingsTodayByCustomerAndBranchPaging(String keyword, int branchId, int page, int pageSize) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.id, b.user_id, b.booking_time, b.check_in, b.check_out, "
                + "b.status, b.total_price, b.deposit, b.payment_status, "
                + "b.cancel_reason, b.cancel_time, b.promotion_id, "
                + "u.username, "
                + "STRING_AGG(rt.name, ', ') AS roomTypes "
                + "FROM Booking b "
                + "LEFT JOIN UserAccount u ON b.user_id = u.id "
                + "LEFT JOIN BookingRoom br ON b.id = br.booking_id "
                + "LEFT JOIN Room r ON br.room_id = r.id "
                + "LEFT JOIN RoomType rt ON r.room_type_id = rt.id "
                + "WHERE (CAST(b.check_in AS date) = CAST(GETDATE() AS date) "
                + "   OR CAST(b.check_out AS date) = CAST(GETDATE() AS date)) "
                + "AND u.username LIKE ? "
                + "AND r.branch_id = ? "
                + "GROUP BY b.id, b.user_id, b.booking_time, b.check_in, b.check_out, "
                + "b.status, b.total_price, b.deposit, b.payment_status, "
                + "b.cancel_reason, b.cancel_time, b.promotion_id, u.username "
                + "ORDER BY b.id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setInt(2, branchId);
            ps.setInt(3, (page - 1) * pageSize);
            ps.setInt(4, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = new Booking();
                    b.setId(rs.getInt("id"));
                    b.setUserId(rs.getString("user_id"));
                    b.setBookingTime(rs.getTimestamp("booking_time"));
                    b.setCheckIn(rs.getTimestamp("check_in"));
                    b.setCheckOut(rs.getTimestamp("check_out"));
                    b.setStatus(rs.getString("status"));
                    b.setTotalPrice(rs.getDouble("total_price"));
                    b.setDeposit(rs.getDouble("deposit"));
                    b.setPaymentStatus(rs.getString("payment_status"));
                    b.setCancelReason(rs.getString("cancel_reason"));
                    b.setCancelTime(rs.getTimestamp("cancel_time"));
                    b.setPromotionId(rs.getInt("promotion_id"));
                    b.setUserName(rs.getString("username"));
                    b.setRoomTypes(rs.getString("roomTypes"));
                    b.setRoomNumbers(getRoomNumbersByBookingId(b.getId())); // Set roomNumbers!
                    list.add(b);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Đếm tổng số booking hôm nay có tìm kiếm theo tên customer và branch
    public int countBookingsTodayByCustomerAndBranch(String keyword, int branchId) {
        String sql = "SELECT COUNT(DISTINCT b.id) AS total FROM Booking b "
                + "JOIN UserAccount u ON b.user_id = u.id "
                + "JOIN BookingRoom br ON b.id = br.booking_id "
                + "JOIN Room r ON br.room_id = r.id "
                + "WHERE (CAST(b.check_in AS date) = CAST(GETDATE() AS date) "
                + "   OR CAST(b.check_out AS date) = CAST(GETDATE() AS date)) "
                + "AND u.username LIKE ? "
                + "AND r.branch_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setInt(2, branchId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("total");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy booking theo booking_id
    public Booking getBookingById(int bookingId) {
        String sql = "SELECT * FROM Booking WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Booking booking = new Booking();
                    booking.setId(rs.getInt("id"));
                    booking.setUserId(rs.getString("user_id"));
                    booking.setBookingTime(rs.getTimestamp("booking_time"));
                    booking.setCheckIn(rs.getTimestamp("check_in"));
                    booking.setCheckOut(rs.getTimestamp("check_out"));
                    booking.setStatus(rs.getString("status"));
                    booking.setTotalPrice(rs.getDouble("total_price"));
                    booking.setDeposit(rs.getDouble("deposit"));
                    booking.setPaymentStatus(rs.getString("payment_status"));
                    booking.setCancelReason(rs.getString("cancel_reason"));
                    booking.setCancelTime(rs.getTimestamp("cancel_time"));
                    booking.setPromotionId(rs.getObject("promotion_id") != null ? rs.getInt("promotion_id") : null);
                    return booking;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // (Tùy chọn) Lấy tất cả booking của một user
    public List<Booking> getBookingsByUserId(String userId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM Booking WHERE user_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking booking = new Booking();
                    booking.setId(rs.getInt("id"));
                    booking.setUserId(rs.getString("user_id"));
                    booking.setBookingTime(rs.getTimestamp("booking_time"));
                    booking.setCheckIn(rs.getTimestamp("check_in"));
                    booking.setCheckOut(rs.getTimestamp("check_out"));
                    booking.setStatus(rs.getString("status"));
                    booking.setTotalPrice(rs.getDouble("total_price"));
                    booking.setDeposit(rs.getDouble("deposit"));
                    booking.setPaymentStatus(rs.getString("payment_status"));
                    booking.setCancelReason(rs.getString("cancel_reason"));
                    booking.setCancelTime(rs.getTimestamp("cancel_time"));
                    booking.setPromotionId(rs.getObject("promotion_id") != null ? rs.getInt("promotion_id") : null);
                    list.add(booking);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // DAO tạo booking. Chỉ cần hàm đơn giản như sau:
    public boolean createWalkInBookingSimple(String guestId, int roomId, Timestamp checkIn, Timestamp checkOut) {
        String insertBooking = "INSERT INTO Booking (user_id, check_in, check_out, status, total_price, deposit, payment_status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String insertBookingRoom = "INSERT INTO BookingRoom (booking_id, room_id) VALUES (?, ?)";

        try {
            connection.setAutoCommit(false);

            // 1. Insert Booking
            PreparedStatement ps = connection.prepareStatement(insertBooking, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, guestId);
            ps.setTimestamp(2, checkIn);
            ps.setTimestamp(3, checkOut);
            ps.setString(4, "Pending");
            ps.setBigDecimal(5, BigDecimal.ZERO);
            ps.setBigDecimal(6, BigDecimal.ZERO);
            ps.setString(7, "Unpaid");
            int rows = ps.executeUpdate();

            if (rows == 0) {
                connection.rollback();
                return false;
            }

            // 2. Lấy booking_id vừa tạo
            ResultSet rs = ps.getGeneratedKeys();
            int bookingId = -1;
            if (rs.next()) {
                bookingId = rs.getInt(1);
            } else {
                connection.rollback();
                return false;
            }

            // 3. Insert BookingRoom
            PreparedStatement ps2 = connection.prepareStatement(insertBookingRoom);
            ps2.setInt(1, bookingId);
            ps2.setInt(2, roomId);
            int rows2 = ps2.executeUpdate();

            if (rows2 == 0) {
                connection.rollback();
                return false;
            }

            connection.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            try {
                connection.rollback();
            } catch (Exception ex) {
            }
            return false;
        } finally {
            try {
                connection.setAutoCommit(true);
            } catch (Exception ex) {
            }
        }
    }

    // Helper để lấy chuỗi room numbers từ booking_id
    private String getRoomNumbersByBookingId(int bookingId) {
        StringBuilder sb = new StringBuilder();
        String sql = "SELECT r.room_number FROM BookingRoom br "
                + "JOIN Room r ON br.room_id = r.id "
                + "WHERE br.booking_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                if (sb.length() > 0) {
                    sb.append(", ");
                }
                sb.append(rs.getString("room_number"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return sb.toString();
    }
    
    
   
}
