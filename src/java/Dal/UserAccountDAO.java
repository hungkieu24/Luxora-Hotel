    /*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Dal;

import DBcontext.DBContext;
import java.sql.*;
import Model.UserAccount;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author thien
 */
public class    UserAccountDAO extends DBContext {

    public UserAccount login(String username, String password) {
        String sql = "SELECT * FROM UserAccount WHERE username = ? AND password = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Timestamp ts = rs.getTimestamp("created_at");
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                String createdAt = (ts != null) ? sdf.format(ts) : null;
                return new UserAccount(
                        rs.getString("id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("avatar_url"),
                        rs.getString("role"),
                        rs.getString("status"),
                        createdAt,
                        rs.getString("phonenumber")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean register(String username, String password, String email, String avatar_url, String phonenumber) {
        try {
            // 1. Tìm ID lớn nhất hiện có
            String getMaxIdSql = "SELECT MAX(CAST(SUBSTRING(id, 2, LEN(id)) AS INT)) AS maxId FROM UserAccount";
            PreparedStatement ps1 = connection.prepareStatement(getMaxIdSql);
            ResultSet rs = ps1.executeQuery();

            String newId = "U001";
            if (rs.next()) {
                int maxId = rs.getInt("maxId");
                newId = String.format("U%03d", maxId + 1);
            }

            // 2. Thêm người dùng mới
            String insertUserSql = "INSERT INTO UserAccount (id, username, password, email, avatar_url, role, status, phonenumber) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement ps2 = connection.prepareStatement(insertUserSql);
            ps2.setString(1, newId);
            ps2.setString(2, username);
            ps2.setString(3, password);
            ps2.setString(4, email);
            ps2.setString(5, avatar_url);
            ps2.setString(6, "Customer");
            ps2.setString(7, "Active");
            ps2.setString(8, phonenumber);

            int rowsUser = ps2.executeUpdate();

            // 3. Nếu thêm user thành công thì thêm LoyaltyPoint
            if (rowsUser > 0) {
                String insertLoyaltySql = "INSERT INTO LoyaltyPoint (user_id, points, level) VALUES (?, ?, ?)";
                PreparedStatement ps3 = connection.prepareStatement(insertLoyaltySql);
                ps3.setString(1, newId);
                ps3.setInt(2, 0);  // default points
                ps3.setString(3, "Member");  // default level
                int rowsLoyalty = ps3.executeUpdate();

                // 4. Ghi vào MemberTierHistory nếu thêm điểm thành công
                if (rowsLoyalty > 0) {
                    String insertHistorySql = "INSERT INTO MemberTierHistory (user_id, old_level, new_level, reason) VALUES (?, ?, ?, ?)";
                    PreparedStatement ps4 = connection.prepareStatement(insertHistorySql);
                    ps4.setString(1, newId);
                    ps4.setString(2, "Member");  // không có cấp trước đó
                    ps4.setString(3, "Member");  // cấp mới
                    ps4.setString(4, "Registered new account");

                    int rowsHistory = ps4.executeUpdate();
                    return rowsHistory > 0;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean isEmailExist(String email) {
        String sql = "SELECT 1 FROM UserAccount WHERE email = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public boolean isUsernameExist(String username) {
        String sql = "SELECT 1 FROM UserAccount WHERE username = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public UserAccount getUserByEmail(String email) {
        String sql = "SELECT * FROM UserAccount WHERE email = ? AND status = 'Active'";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new UserAccount(
                        rs.getString("id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("avatar_url"),
                        rs.getString("role"),
                        rs.getString("status"),
                        rs.getString("created_at")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public UserAccount saveUserToDatabase(String email, String name, String avatar_url) {
        try {
            String checkSql = "SELECT * FROM UserAccount WHERE email= ?";
            PreparedStatement ps = connection.prepareStatement(checkSql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Timestamp ts = rs.getTimestamp("created_at");
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                String createdAt = (ts != null) ? sdf.format(ts) : null;// doc tu database
                String updateSql = "update UserAccount set username = ?, avatar_url = ?, role = ?, status=?, created_at=? where email =?";
                PreparedStatement pss = connection.prepareStatement(updateSql);
                pss.setString(1, name);
                pss.setString(2, avatar_url);
                pss.setString(3, rs.getString("role"));
                pss.setString(4, rs.getString("status"));
                pss.setString(5, createdAt);
                pss.setString(6, email);
                pss.executeUpdate();
                return new UserAccount(
                        rs.getString("id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("avatar_url"),
                        rs.getString("role"),
                        rs.getString("status"),
                        createdAt
                );
            } else {
                // Thêm người dùng mới
                String getMaxIdSql = "SELECT MAX(CAST(SUBSTRING(id, 2, LEN(id)) AS INT)) AS maxId FROM UserAccount";
                PreparedStatement ps1 = connection.prepareStatement(getMaxIdSql);
                rs = ps1.executeQuery();

                String newId = "U001";
                if (rs.next()) {
                    int maxId = rs.getInt("maxId");
                    newId = String.format("U%03d", maxId + 1);
                }
                String insertSql = "Insert into UserAccount (id, username, password, email, avatar_url, role, status, created_at)"
                        + "values(?, ?, ?, ?, ?,?,?,?)";
                ps = connection.prepareStatement(insertSql);
                ps.setString(1, newId);
                ps.setString(2, name);
                ps.setString(3, "123");// đặt mặc định là 123
                ps.setString(4, email);
                ps.setString(5, avatar_url);
                ps.setString(6, "Customer");// đặt mặc định là customer
                ps.setString(7, "Active"); //dat mac dinh la active
                ps.setTimestamp(8, new Timestamp(System.currentTimeMillis()));
                ps.executeUpdate();
                Timestamp ts = rs.getTimestamp("created_at");
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                String createdAt = (ts != null) ? sdf.format(ts) : null;// doc tu database
                return new UserAccount(newId, name, "123", email, avatar_url, "Customer", "Active", createdAt);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public UserAccount getUserById(String id) {
        String sql = "SELECT * FROM UserAccount WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new UserAccount(
                        rs.getString("id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("avatar_url"),
                        rs.getString("phone_number"),
                        rs.getString("role"),
                        rs.getString("status"),
                        rs.getString("created_at")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateUserInfo(String userId, String username, String email, String phoneNumber, String avatarUrl) {
        String sql = "UPDATE UserAccount SET username = ?, email = ?, phone_number = ?, avatar_url = ? WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, phoneNumber);
            ps.setString(4, avatarUrl);
            ps.setString(5, userId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public UserAccount getHotelOwner() {
        String sql = "SELECT TOP 1 * FROM UserAccount WHERE role = 'HotelOwner' AND status = 'Active'";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Timestamp ts = rs.getTimestamp("created_at");
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                String createdAt = (ts != null) ? sdf.format(ts) : null;

                return new UserAccount(
                        rs.getString("id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("avatar_url"),
                        rs.getString("role"),
                        rs.getString("status"),
                        createdAt
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null; // Không tìm thấy hotel owner hoặc lỗi xảy ra
    }

    public List<UserAccount> getAllStaff() {
        List<UserAccount> staffList = new ArrayList<>();
        String sql = "SELECT * FROM UserAccount WHERE role = 'Staff'";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                UserAccount staff = new UserAccount(
                        rs.getString("id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("avatar_url"),
                        rs.getString("role"),
                        rs.getString("status"),
                        rs.getString("created_at"),
                        rs.getString("phonenumber")
                );
                staffList.add(staff);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return staffList;
    }

    public boolean updateUserRoleToManager(String userId) {
        String sql = "UPDATE UserAccount SET role = 'Manager' WHERE id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, userId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updatePassword(String email, String password){
        String sql="update UserAccount set password = ? where email = ?";
        try{
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, password);
            ps.setString(2, email);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
            
        }catch(SQLException e){
            e.printStackTrace();
            return false;
        }
    }
}
