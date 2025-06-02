package Dal;

import Model.Room;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import DBcontext.DBContext;
/**
 * RoomDAO for handling Room database operations.
 */
public class RoomDAO extends DBContext {

    public Room getRoomById(int id) {
        Room room = null;
        String sql = "SELECT * FROM Room WHERE id = ?";

        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                room = new Room(
                        rs.getInt("id"),
                        rs.getString("room_number"),
                        rs.getInt("branch_id"),
                        rs.getInt("room_type_id"),
                        rs.getString("status"),
                        rs.getString("image_url")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return room;
    }

    public List<Room> getAllRooms() {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT * FROM Room ORDER BY room_number";

        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Room room = new Room(
                        rs.getInt("id"),
                        rs.getString("room_number"),
                        rs.getInt("branch_id"),
                        rs.getInt("room_type_id"),
                        rs.getString("status"),
                        rs.getString("image_url")
                );
                rooms.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return rooms;
    }

    public List<Room> getRoomsByBranchId(int branchId) {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT * FROM Room WHERE branch_id = ? ORDER BY room_number";

        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, branchId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Room room = new Room(
                        rs.getInt("id"),
                        rs.getString("room_number"),
                        rs.getInt("branch_id"),
                        rs.getInt("room_type_id"),
                        rs.getString("status"),
                        rs.getString("image_url")
                );
                rooms.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return rooms;
    }

    public List<Room> getRoomsByRoomTypeId(int roomTypeId) {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT * FROM Room WHERE room_type_id = ? ORDER BY room_number";

        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, roomTypeId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Room room = new Room(
                        rs.getInt("id"),
                        rs.getString("room_number"),
                        rs.getInt("branch_id"),
                        rs.getInt("room_type_id"),
                        rs.getString("status"),
                        rs.getString("image_url")
                );
                rooms.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return rooms;
    }

    public boolean addRoom(Room room) {
        String sql = "INSERT INTO Room (room_number, branch_id, room_type_id, status, image_url) VALUES (?, ?, ?, ?, ?)";

        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, room.getRoomNumber());
            stmt.setInt(2, room.getBranchId());
            stmt.setInt(3, room.getRoomTypeId());
            stmt.setString(4, room.getStatus());
            stmt.setString(5, room.getImageUrl());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateRoom(Room room) {
        String sql = "UPDATE Room SET room_number=?, branch_id=?, room_type_id=?, status=?, image_url=? WHERE id=?";

        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, room.getRoomNumber());
            stmt.setInt(2, room.getBranchId());
            stmt.setInt(3, room.getRoomTypeId());
            stmt.setString(4, room.getStatus());
            stmt.setString(5, room.getImageUrl());
            stmt.setInt(6, room.getId());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteRoom(int id) {
        String sql = "DELETE FROM Room WHERE id = ?";

        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, id);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateRoomStatus(int id, String status) {
        String sql = "UPDATE Room SET status = ? WHERE id = ?";

        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, status);
            stmt.setInt(2, id);

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
      // Lấy danh sách room_id theo booking_id 
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
    public static void main(String[] args) {
        RoomDAO rdao = new RoomDAO();
        boolean uds = rdao.updateRoomStatus(1, "occupied");
        if(uds) {
            System.out.println("success");
        } else {
            System.out.println("fail");
        }
    }
 
public List<Room> searchRoomsByRoomTypeName(String roomTypeNameKeyword) {
    List<Room> list = new ArrayList<>();
    String sql = "SELECT r.* FROM Room r " +
                 "JOIN RoomType rt ON r.roomTypeId = rt.id " +
                 "WHERE rt.name LIKE ?";
    try {
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setString(1, "%" + roomTypeNameKeyword + "%");
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Room r = new Room();
            r.setId(rs.getInt("id"));
            r.setRoomNumber(rs.getString("roomNumber"));
            r.setBranchId(rs.getInt("branchId"));
            r.setRoomTypeId(rs.getInt("roomTypeId"));
            r.setStatus(rs.getString("status"));
            r.setImageUrl(rs.getString("imageUrl"));
            list.add(r);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}

}
