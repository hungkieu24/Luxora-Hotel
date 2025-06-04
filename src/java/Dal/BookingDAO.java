package Dal;

import Model.Booking;
import Model.Room;
import java.sql.Timestamp;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO extends DBcontext.DBContext {

    public List<Booking> getBookingsToday() {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT "
                + "b.id, b.user_id, b.booking_time, b.check_in, b.check_out, "
                + "b.status, b.total_price, b.deposit, b.payment_status, "
                + "b.cancel_reason, b.cancel_time, b.promotion_id, "
                + "u.username, "
                + "STRING_AGG(rt.name, ', ') AS roomTypes "
                + // rt.name là varchar(100) nên không cần CAST
                "FROM Booking b "
                + "LEFT JOIN UserAccount u ON b.user_id = u.id "
                + "LEFT JOIN BookingRoom br ON b.id = br.booking_id "
                + "LEFT JOIN Room r ON br.room_id = r.id "
                + "LEFT JOIN RoomType rt ON r.room_type_id = rt.id "
                + "WHERE CAST(b.check_in AS date) = CAST(GETDATE() AS date) "
                + "   OR CAST(b.check_out AS date) = CAST(GETDATE() AS date) "
                + "GROUP BY "
                + "b.id, b.user_id, b.booking_time, b.check_in, b.check_out, "
                + "b.status, b.total_price, b.deposit, b.payment_status, "
                + "b.cancel_reason, b.cancel_time, b.promotion_id, u.username";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Booking> getBookingsByUserId(String userId) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, u.username, "
                + "STRING_AGG(rt.name, ', ') AS roomTypes "
                + "FROM Booking b "
                + "LEFT JOIN UserAccount u ON b.user_id = u.id "
                + "LEFT JOIN BookingRoom br ON b.id = br.booking_id "
                + "LEFT JOIN Room r ON br.room_id = r.id "
                + "LEFT JOIN RoomType rt ON r.room_type_id = rt.roomTypeID "
                + "WHERE b.user_id = ? "
                + "GROUP BY b.id, b.user_id, b.booking_time, b.check_in, b.check_out, b.status, "
                + "b.total_price, b.deposit, b.payment_status, b.cancel_reason, b.cancel_time, "
                + "b.promotion_id, u.username";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, userId);
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
                b.setRooms(getRoomsByBookingId(b.getId()));
                list.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Booking getBookingById(int bookingId) {
        Booking booking = null;
        String sql = "SELECT b.*, u.username, u.email, "
                + "STRING_AGG(r.room_number, ', ') AS roomNumbers "
                + "FROM Booking b "
                + "LEFT JOIN UserAccount u ON b.user_id = u.id "
                + "LEFT JOIN BookingRoom br ON b.id = br.booking_id "
                + "LEFT JOIN Room r ON br.room_id = r.id "
                + "WHERE b.id = ? "
                + "GROUP BY b.id, b.user_id, b.booking_time, b.check_in, b.check_out, b.status, "
                + "b.total_price, b.deposit, b.payment_status, b.cancel_reason, b.cancel_time, "
                + "b.promotion_id, u.username, u.email";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, bookingId);
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
                booking.setRooms(getRoomsByBookingId(bookingId));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return booking;
    }

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

    public List<Room> getRoomsByBookingId(int bookingId) {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT r.*, rt.name AS roomTypeName, hb.name AS hotelName "
                + "FROM BookingRoom br "
                + "JOIN Room r ON br.room_id = r.id "
                + "LEFT JOIN RoomType rt ON r.room_type_id = rt.id "
                + "LEFT JOIN HotelBranch hb ON r.branch_id = hb.id "
                + "WHERE br.booking_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, bookingId);
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
    public List<Integer> getRoomIdsByBooking(int bookingId) {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT room_id FROM BookingRoom WHERE booking_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ids.add(rs.getInt("room_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ids;
    }

    public Booking getBookingByUserId(String userId) {
        Booking booking = null;
        String sql = "SELECT b.*, u.username, "
                + "STRING_AGG(r.room_number, ', ') AS roomNumbers "
                + "FROM Booking b "
                + "LEFT JOIN UserAccount u ON b.user_id = u.id "
                + "LEFT JOIN BookingRoom br ON b.id = br.booking_id "
                + "LEFT JOIN Room r ON br.room_id = r.id "
                + "WHERE b.user_id = ? "
                + "GROUP BY b.id, b.user_id, b.booking_time, b.check_in, b.check_out, b.status, "
                + "b.total_price, b.deposit, b.payment_status, b.cancel_reason, b.cancel_time, "
                + "b.promotion_id, u.username "
                + "ORDER BY b.booking_time DESC "
                + "OFFSET 0 ROWS FETCH NEXT 1 ROW ONLY";

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
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
                    booking.setRooms(getRoomsByBookingId(booking.getId()));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return booking;
    }

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

    public Booking getBookingById(int bookingId) {
        Booking booking = null;
        String sql = "SELECT b.*, u.username, u.email, "
                + "STRING_AGG(rt.name, ', ') AS roomTypes "
                + "FROM Booking b "
                + "LEFT JOIN UserAccount u ON b.user_id = u.id "
                + "LEFT JOIN BookingRoom br ON b.id = br.booking_id "
                + "LEFT JOIN Room r ON br.room_id = r.id "
                + "LEFT JOIN RoomType rt ON r.room_type_id = rt.roomTypeID "
                + "WHERE b.id = ? "
                + "GROUP BY b.id, b.user_id, b.booking_time, b.check_in, b.check_out, b.status, "
                + "b.total_price, b.deposit, b.payment_status, b.cancel_reason, b.cancel_time, "
                + "b.promotion_id, u.username, u.email";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, bookingId);
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
                booking.setRoomTypes(rs.getString("roomTypes"));
                booking.setRooms(getRoomsByBookingId(bookingId));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return booking;
    }

    public List<Room> getRoomsByBookingId(int bookingId) {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT r.*, rt.name AS roomTypeName, hb.name AS hotelName "
                + "FROM BookingRoom br "
                + "JOIN Room r ON br.room_id = r.id "
                + "LEFT JOIN RoomType rt ON r.room_type_id = rt.roomTypeID "
                + "LEFT JOIN HotelBranch hb ON r.branch_id = hb.id "
                + "WHERE br.booking_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Room room = new Room();
                room.setId(rs.getInt("id"));
                room.setRoomNumber(rs.getString("room_number"));
                room.setBranchId(rs.getInt("branch_id"));
                room.setRoomTypeId(rs.getInt("room_type_id"));
                room.setStatus(rs.getString("status"));
                room.setImageUrl(rs.getString("image_url"));
                room.setRoomTypeName(rs.getString("roomTypeName"));
                room.setHotelName(rs.getString("hotelName"));
                rooms.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    public List<Booking> searchBookingsTodayByCustomer(String keyword) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT b.*, u.username, "
                + "STRING_AGG(rt.name, ', ') AS roomTypes "
                + "FROM Booking b "
                + "LEFT JOIN UserAccount u ON b.user_id = u.id "
                + "LEFT JOIN BookingRoom br ON b.id = br.booking_id "
                + "LEFT JOIN Room r ON br.room_id = r.id "
                + "LEFT JOIN RoomType rt ON r.room_type_id = rt.roomTypeID "
                + "WHERE (CAST(b.check_in AS date) = CAST(GETDATE() AS date) "
                + "   OR CAST(b.check_out AS date) = CAST(GETDATE() AS date)) "
                + "AND u.username LIKE ? "
                + "GROUP BY b.id, u.username";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
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
                    // b.setRooms(getRoomsByBookingId(b.getId())); // Nếu cần
                    list.add(b);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

}
