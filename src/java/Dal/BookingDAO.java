package Dal;

import Model.Booking;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO extends DBcontext.DBContext {

    public List<Booking> getBookingsByUserId(String userId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT b.id, b.user_id, hb.name AS hotelName, r.room_number, b.check_in, b.check_out, b.status, b.total_price " +
                     "FROM Booking b " +
                     "JOIN BookingRoom br ON b.id = br.booking_id " +
                     "JOIN Room r ON br.room_id = r.id " +
                     "JOIN HotelBranch hb ON r.branch_id = hb.id " +
                     "WHERE b.user_id = ? " +
                     "ORDER BY b.booking_time DESC";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Booking booking = new Booking();
                booking.setId(rs.getInt("id"));
                booking.setUserId(rs.getString("user_id"));
                booking.setHotelName(rs.getString("hotelName"));
                booking.setRoomName(rs.getString("room_number"));
                booking.setCheckInDate(rs.getTimestamp("check_in"));
                booking.setCheckOutDate(rs.getTimestamp("check_out"));
                booking.setStatus(rs.getString("status"));
                booking.setTotalPrice(rs.getBigDecimal("total_price"));
                bookings.add(booking);
            }
            rs.close();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }
}