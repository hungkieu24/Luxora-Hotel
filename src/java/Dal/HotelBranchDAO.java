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

    public boolean deleteHotelBranchById(int branchId) {
        String sql = "DELETE FROM [dbo].[HotelBranch] WHERE id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, branchId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

}
