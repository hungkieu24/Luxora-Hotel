/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Dal;
import DBcontext.DBContext;
import java.sql.*;
import Model.UserAccount;
/**
 *
 * @author thien
 */
public class UserAccountDAO extends DBContext  {
    public UserAccount login(String username, String password){
        String sql = "SELECT * FROM UserAccount WHERE username = ? AND password = ?";
        try{
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2,password);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
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
        }catch(SQLException e){
            e.printStackTrace();
        }
        return null;
    }
    public static void main(String[] args) {
        UserAccountDAO dao = new UserAccountDAO();

        String username = "nguyenvanA";
        String password = "hashed_pass1";

        UserAccount user = dao.login(username, password);

        if (user != null) {
            System.out.println("Đăng nhập thành công!");
            System.out.println(user.getStatus());  // in ra thông tin user
        } else {
            System.out.println("Đăng nhập thất bại. Sai tài khoản hoặc mật khẩu.");
        }
    }
}
