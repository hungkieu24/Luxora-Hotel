/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Dal;

import DBcontext.DBContext;
import java.sql.*;
import Model.UserAccount;
import java.text.SimpleDateFormat;

/**
 *
 * @author thien
 */
public class UserAccountDAO extends DBContext {

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
                        createdAt
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

                String newId = "U" + System.currentTimeMillis() % 10000;
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

    public boolean updateUserInfo(String userId, String username, String email, String avatarUrl) {
        String sql = "UPDATE UserAccount SET username = ?, email = ?, avatar_url = ? WHERE id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, avatarUrl);
            ps.setString(4, userId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0; // Return true if update was successful
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
