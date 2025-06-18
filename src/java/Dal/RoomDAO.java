package Dal;

import Model.Room;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import DBcontext.DBContext;
import Model.RoomType;
import java.util.HashMap;
import java.util.Map;

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

    public void createRoom(Room room) throws SQLException {
        String sql = "INSERT INTO Room (room_number, branch_id, room_type_id, status, image_url) VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setString(1, room.getRoomNumber());
            stmt.setInt(2, room.getBranchId());
            stmt.setInt(3, room.getRoomTypeId());
            stmt.setString(4, room.getStatus());
            stmt.setString(5, room.getImageUrl() != null ? room.getImageUrl() : "");
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();

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

 

    public List<Room> getRooms(String status, String roomTypeId, String search) {
        List<Room> rooms = new ArrayList<>();
        String sql = "SELECT r.id, r.room_number, r.branch_id, r.room_type_id, r.status, r.image_url, "
                + "rt.id AS rt_id, rt.name AS rt_name, rt.description AS rt_description, "
                + "rt.base_price, rt.capacity, rt.image_url AS rt_image_url "
                + "FROM Room r JOIN RoomType rt ON r.room_type_id = rt.id WHERE 1=1";

        if (status != null && !status.isEmpty()) {
            sql += " AND r.status = ?";
        }
        if (roomTypeId != null && !roomTypeId.isEmpty()) {
            sql += " AND r.room_type_id = ?";
        }
        if (search != null && !search.isEmpty()) {
            sql += " AND r.room_number LIKE ? Or lower(rt.name) like lower(?) OR lower(r.status) like lower(?)";
        }

        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            int index = 1;
            if (status != null && !status.isEmpty()) {
                stmt.setString(index++, status);
            }
            if (roomTypeId != null && !roomTypeId.isEmpty()) {
                stmt.setInt(index++, Integer.parseInt(roomTypeId));
            }
            if (search != null && !search.isEmpty()) {
                stmt.setString(index++, "%" + search + "%");
                stmt.setString(index++, "%" + search + "%");
                stmt.setString(index++, "%" + search + "%");
            }

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                // Tạo RoomType
                RoomType rt = new RoomType(
                        rs.getInt("rt_id"),
                        rs.getString("rt_name"),
                        rs.getString("rt_description"),
                        rs.getDouble("base_price"),
                        rs.getInt("capacity"),
                        rs.getString("rt_image_url")
                );

                // Tạo Room và gắn RoomType
                Room room = new Room(
                        rs.getInt("id"),
                        rs.getString("room_number"),
                        rs.getInt("branch_id"),
                        rs.getInt("room_type_id"),
                        rs.getString("status"),
                        rs.getString("image_url")
                );
                room.setRoomType(rt);

                rooms.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
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

    public List<Room> searchRoomsByRoomTypeName(String roomTypeNameKeyword) {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.* FROM Room r "
                + "JOIN RoomType rt ON r.roomTypeId = rt.id "
                + "WHERE rt.name LIKE ?";
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
// Phân trang danh sách phòng ()

    public List<Room> pagingRoom(int page, int pageSize) {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT * FROM Room ORDER BY id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY;";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Room r = new Room(
                        rs.getInt("id"),
                        rs.getString("room_number"),
                        rs.getInt("branch_id"),
                        rs.getInt("room_type_id"),
                        rs.getString("status"),
                        rs.getString("image_url")
                );
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

// Đếm tổng số phòng
    public int countAllRooms() {
        String sql = "SELECT COUNT(*) FROM Room";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

// Phân trang danh sách phòng theo loại phòng (tìm kiếm)
    public List<Room> searchRoomsByRoomTypeNamePaging(String roomTypeNameKeyword, int page, int pageSize) {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.* FROM Room r JOIN RoomType rt ON r.room_type_id = rt.id "
                + "WHERE rt.name LIKE ? "
                + "ORDER BY r.id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY;";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, "%" + roomTypeNameKeyword + "%");
            ps.setInt(2, (page - 1) * pageSize);
            ps.setInt(3, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Room r = new Room(
                        rs.getInt("id"),
                        rs.getString("room_number"),
                        rs.getInt("branch_id"),
                        rs.getInt("room_type_id"),
                        rs.getString("status"),
                        rs.getString("image_url")
                );
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

// Đếm tổng số phòng theo loại phòng (tìm kiếm)
    public int countRoomsByRoomTypeName(String roomTypeNameKeyword) {
        String sql = "SELECT COUNT(*) FROM Room r JOIN RoomType rt ON r.room_type_id = rt.id WHERE rt.name LIKE ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, "%" + roomTypeNameKeyword + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    // Phân trang danh sách phòng theo branch

    public List<Room> pagingRoomByBranch(int branchId, int page, int pageSize) {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT * FROM Room WHERE branch_id = ? ORDER BY id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY;";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, branchId);
            ps.setInt(2, (page - 1) * pageSize);
            ps.setInt(3, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Room r = new Room(
                        rs.getInt("id"),
                        rs.getString("room_number"),
                        rs.getInt("branch_id"),
                        rs.getInt("room_type_id"),
                        rs.getString("status"),
                        rs.getString("image_url")
                );
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Đếm tổng số phòng theo branch
    public int countRoomsByBranch(int branchId) {
        String sql = "SELECT COUNT(*) FROM Room WHERE branch_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, branchId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Tìm kiếm phòng theo tên loại phòng và branch + phân trang
    public List<Room> searchRoomsByRoomTypeNameAndBranchPaging(String roomTypeNameKeyword, int branchId, int page, int pageSize) {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.* FROM Room r JOIN RoomType rt ON r.room_type_id = rt.id "
                + "WHERE rt.name LIKE ? AND r.branch_id = ? "
                + "ORDER BY r.id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY;";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, "%" + roomTypeNameKeyword + "%");
            ps.setInt(2, branchId);
            ps.setInt(3, (page - 1) * pageSize);
            ps.setInt(4, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Room r = new Room(
                        rs.getInt("id"),
                        rs.getString("room_number"),
                        rs.getInt("branch_id"),
                        rs.getInt("room_type_id"),
                        rs.getString("status"),
                        rs.getString("image_url")
                );
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Đếm tổng số phòng theo tên loại phòng và branch
    public int countRoomsByRoomTypeNameAndBranch(String roomTypeNameKeyword, int branchId) {
        String sql = "SELECT COUNT(*) FROM Room r JOIN RoomType rt ON r.room_type_id = rt.id WHERE rt.name LIKE ? AND r.branch_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, "%" + roomTypeNameKeyword + "%");
            ps.setInt(2, branchId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<RoomType> getRoomTypesByBranch(int branchId) {
        List<RoomType> list = new ArrayList<>();
        String sql = "SELECT DISTINCT rt.* FROM RoomType rt "
                + "JOIN Room r ON rt.id = r.room_type_id WHERE r.branch_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, branchId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RoomType rt = new RoomType();
                    rt.setRoomTypeID(rs.getInt("id"));
                    rt.setName(rs.getString("name"));
                    // Mapping thêm các trường khác nếu RoomType có (vd: mô tả, giá, ...)
                    list.add(rt);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy danh sách phòng còn trống của 1 branch
    public List<Room> getAvailableRoomsByBranch(int branchId) {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.*, rt.name as roomTypeName FROM Room r "
                + "JOIN RoomType rt ON r.room_type_id = rt.id "
                + "WHERE r.branch_id = ? AND r.status = 'available'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, branchId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Room room = new Room();
                    room.setId(rs.getInt("id"));
                    room.setRoomNumber(rs.getString("room_number"));
                    room.setRoomTypeId(rs.getInt("room_type_id"));
                    room.setRoomTypeName(rs.getString("roomTypeName"));
                    // Mapping thêm các trường khác nếu Room có (vd: tầng, trạng thái, ...)
                    list.add(room);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

// Lấy danh sách phòng còn trống theo branch và loại phòng
    public List<Room> getAvailableRoomsByBranchAndRoomType(int branchId, int roomTypeId) {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT r.*, rt.name as roomTypeName FROM Room r "
                + "JOIN RoomType rt ON r.room_type_id = rt.id "
                + "WHERE r.branch_id = ? AND r.room_type_id = ? AND r.status = 'available'";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, branchId);
            ps.setInt(2, roomTypeId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Room room = new Room();
                    room.setId(rs.getInt("id"));
                    room.setRoomNumber(rs.getString("room_number"));
                    room.setRoomTypeId(rs.getInt("room_type_id"));
                    room.setRoomTypeName(rs.getString("roomTypeName"));
                    // Mapping thêm các trường khác nếu Room có
                    list.add(room);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    //
    public boolean updateRoomStatus(int roomId, String status) {
        String sql = "UPDATE Room SET status = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, roomId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
    