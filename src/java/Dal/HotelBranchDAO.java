/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Dal;

import Model.HotelBranch;
import Model.UserAccount;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author hungk
 */
public class HotelBranchDAO extends DBcontext.DBContext {

    public List<HotelBranch> getAllHotelBranchesSimple() {
        List<HotelBranch> branches = new ArrayList<>();
        String sql = "SELECT * FROM HotelBranch";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                HotelBranch branch = new HotelBranch(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("address"),
                        rs.getString("phone"),
                        rs.getString("email"),
                        rs.getString("image_url"),
                        rs.getString("owner_id"),
                        rs.getString("manager_id")
                );

                branches.add(branch);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return branches;
    }

    public List<HotelBranch> getAllHotelBranches() {
        List<HotelBranch> branches = new ArrayList<>();

        String sql = "SELECT hb.*, "
                + "owner.id AS owner_id, owner.username AS owner_username, owner.password AS owner_password, owner.email AS owner_email, "
                + "owner.avatar_url AS owner_avatar, owner.role AS owner_role, owner.status AS owner_status, owner.created_at AS owner_created, owner.phonenumber AS owner_phone, "
                + "manager.id AS manager_id, manager.username AS manager_username, manager.password AS manager_password, manager.email AS manager_email, "
                + "manager.avatar_url AS manager_avatar, manager.role AS manager_role, manager.status AS manager_status, manager.created_at AS manager_created, manager.phonenumber AS manager_phone "
                + "FROM HotelBranch hb "
                + "LEFT JOIN UserAccount owner ON hb.owner_id = owner.id "
                + "LEFT JOIN UserAccount manager ON hb.manager_id = manager.id";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                // Tạo owner
                UserAccount owner = new UserAccount(
                        rs.getString("owner_id"),
                        rs.getString("owner_username"),
                        rs.getString("owner_password"),
                        rs.getString("owner_email"),
                        rs.getString("owner_avatar"),
                        rs.getString("owner_role"),
                        rs.getString("owner_status"),
                        (rs.getTimestamp("owner_created") != null) ? rs.getTimestamp("owner_created").toString() : null
                );

                // Tạo manager
                UserAccount manager = new UserAccount(
                        rs.getString("manager_id"),
                        rs.getString("manager_username"),
                        rs.getString("manager_password"),
                        rs.getString("manager_email"),
                        rs.getString("manager_avatar"),
                        rs.getString("manager_role"),
                        rs.getString("manager_status"),
                        (rs.getTimestamp("manager_created") != null) ? rs.getTimestamp("manager_created").toString() : null
                );

                // Tạo branch
                HotelBranch branch = new HotelBranch(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("address"),
                        rs.getString("phone"),
                        rs.getString("email"),
                        rs.getString("image_url"),
                        owner,
                        manager
                );

                branches.add(branch);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return branches;
    }

    public HotelBranch getHotelBranchByIdSimple(int id) {
        String sql = "SELECT * FROM HotelBranch WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return new HotelBranch(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("address"),
                        rs.getString("phone"),
                        rs.getString("email"),
                        rs.getString("image_url"),
                        rs.getString("owner_id"),
                        rs.getString("manager_id")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // Không tìm thấy branch hoặc có lỗi
    }

    public HotelBranch getHotelBranchById(int id) {
        String sql = "SELECT hb.*, "
                + "owner.id AS owner_id, owner.username AS owner_username, owner.password AS owner_password, owner.email AS owner_email, "
                + "owner.avatar_url AS owner_avatar, owner.role AS owner_role, owner.status AS owner_status, owner.created_at AS owner_created_at, owner.phonenumber AS owner_phone, "
                + "manager.id AS manager_id, manager.username AS manager_username, manager.password AS manager_password, manager.email AS manager_email, "
                + "manager.avatar_url AS manager_avatar, manager.role AS manager_role, manager.status AS manager_status, manager.created_at AS manager_created_at, manager.phonenumber AS manager_phone "
                + "FROM HotelBranch hb "
                + "LEFT JOIN UserAccount owner ON hb.owner_id = owner.id "
                + "LEFT JOIN UserAccount manager ON hb.manager_id = manager.id "
                + "WHERE hb.id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                // Lấy owner
                UserAccount owner = new UserAccount(
                        rs.getString("owner_id"),
                        rs.getString("owner_username"),
                        rs.getString("owner_password"),
                        rs.getString("owner_email"),
                        rs.getString("owner_avatar"),
                        rs.getString("owner_role"),
                        rs.getString("owner_status"),
                        rs.getString("owner_created_at"),
                        rs.getString("owner_phone")
                );

                // Lấy manager nếu có
                UserAccount manager = null;
                if (rs.getString("manager_id") != null) {
                    manager = new UserAccount(
                            rs.getString("manager_id"),
                            rs.getString("manager_username"),
                            rs.getString("manager_password"),
                            rs.getString("manager_email"),
                            rs.getString("manager_avatar"),
                            rs.getString("manager_role"),
                            rs.getString("manager_status"),
                            rs.getString("manager_created_at"),
                            rs.getString("manager_phone")
                    );
                }

                return new HotelBranch(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("address"),
                        rs.getString("phone"),
                        rs.getString("email"),
                        rs.getString("image_url"),
                        owner,
                        manager
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean updateHotelBranch(HotelBranch branch) {
        String sql = "UPDATE HotelBranch SET name = ?, address = ?, phone = ?, email = ?, image_url = ?, owner_id = ?, manager_id = ? WHERE id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, branch.getName());
            ps.setString(2, branch.getAddress());
            ps.setString(3, branch.getPhone());
            ps.setString(4, branch.getEmail());
            ps.setString(5, branch.getImage_url());
            ps.setString(6, branch.getOwner_id());
            ps.setString(7, branch.getManager_id());
            ps.setInt(8, branch.getId());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean addHotelBranch(HotelBranch branch) {
        String sql = "INSERT INTO HotelBranch (name, address, phone, email, image_url, owner_id, manager_id) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, branch.getName());
            ps.setString(2, branch.getAddress());
            ps.setString(3, branch.getPhone());
            ps.setString(4, branch.getEmail());
            ps.setString(5, branch.getImage_url());
            ps.setString(6, branch.getOwner_id());
            ps.setString(7, branch.getManager_id());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean deleteHotelBranch(int branchID) {
        String checkBookingSql = "SELECT COUNT(*) AS total "
                + "FROM Room r "
                + "JOIN BookingRoom br ON r.id = br.room_id "
                + "JOIN Booking b ON br.booking_id = b.id "
                + "WHERE r.branch_id = ? AND b.status IN ('Pending', 'Confirmed', 'CheckedIn', 'Locked')";

        String deleteBookingRoomSql = "DELETE br "
                + "FROM BookingRoom br "
                + "JOIN Room r ON br.room_id = r.id "
                + "WHERE r.branch_id = ?";

        String deleteRoomsSql = "DELETE FROM Room WHERE branch_id = ?";
        String deleteBranchSql = "DELETE FROM HotelBranch WHERE id = ?";

        try {
            connection.setAutoCommit(false); // Bắt đầu transaction

            // 1. Kiểm tra trạng thái Booking
            try (PreparedStatement ps = connection.prepareStatement(checkBookingSql)) {
                ps.setInt(1, branchID);
                ResultSet rs = ps.executeQuery();
                if (rs.next() && rs.getInt("total") > 0) {
                    connection.rollback();
                    System.out.println("Khong the xoa chi nhanh: Co phong dang duoc dat.");
                    return false;
                }
            }

            // 2. Xóa BookingRoom liên quan
            try (PreparedStatement ps = connection.prepareStatement(deleteBookingRoomSql)) {
                ps.setInt(1, branchID);
                ps.executeUpdate();
            }

            // 3. Xóa các phòng trong Room
            try (PreparedStatement ps = connection.prepareStatement(deleteRoomsSql)) {
                ps.setInt(1, branchID);
                ps.executeUpdate();
            }

            // 4. Xóa HotelBranch
            try (PreparedStatement ps = connection.prepareStatement(deleteBranchSql)) {
                ps.setInt(1, branchID);
                ps.executeUpdate();
            }

            connection.commit(); // Hoàn tất giao dịch
            return true;

        } catch (SQLException e) {
            try {
                connection.rollback(); // Trả lại nếu lỗi
            } catch (SQLException rollbackEx) {
                rollbackEx.printStackTrace();
            }
            e.printStackTrace();
        } finally {
            try {
                connection.setAutoCommit(true); // Bật lại auto-commit
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        return false;
    }

    public List<HotelBranch> getListHotelBranchByPage(int page, int pageSize) {
        List<HotelBranch> branchList = new ArrayList<>();
        String sql = "SELECT * FROM HotelBranch ORDER BY id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try {
            PreparedStatement stmt = connection.prepareStatement(sql);
            stmt.setInt(1, (page - 1) * pageSize);
            stmt.setInt(2, pageSize);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                HotelBranch branch = new HotelBranch(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("address"),
                        rs.getString("phone"),
                        rs.getString("email"),
                        rs.getString("image_url"),
                        rs.getString("owner_id"),
                        rs.getString("manager_id")
                );
                branchList.add(branch);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return branchList;
    }

    public int getTotalHotelBranchAfterSearching(String keyword) {
        String sql = "SELECT COUNT(*) FROM HotelBranch WHERE name LIKE ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, "%" + keyword + "%");

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return 0;
    }

    public List<HotelBranch> searchHotelBranchByName(String keyword, int page, int pageSize) {
        List<HotelBranch> branchList = new ArrayList<>();
        String sql = "SELECT * FROM HotelBranch WHERE name LIKE ? ORDER BY id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, "%" + keyword + "%");
            stmt.setInt(2, (page - 1) * pageSize);
            stmt.setInt(3, pageSize);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    HotelBranch branch = new HotelBranch(
                            rs.getInt("id"),
                            rs.getString("name"),
                            rs.getString("address"),
                            rs.getString("phone"),
                            rs.getString("email"),
                            rs.getString("image_url"),
                            rs.getString("owner_id"),
                            rs.getString("manager_id")
                    );
                    branchList.add(branch);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return branchList;
    }
    
    
   public String getBranchNameById(int branchId) {
    String sql = "SELECT name FROM HotelBranch WHERE id = ?";
    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, branchId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getString("name");
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return "";
}

}
