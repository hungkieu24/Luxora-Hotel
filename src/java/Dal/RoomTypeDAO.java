/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Dal;
import Model.RoomType;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author hungk
 */
public class RoomTypeDAO extends DBcontext.DBContext{
    
    public List<RoomType> getAllRoomType() {
        List<RoomType> roomTypeList = new ArrayList<>();
        String sql = "SELECT * FROM RoomType";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                RoomType roomtype = new RoomType(
                        rs.getInt("id"),
                        rs.getString("name"), 
                        rs.getString("description"),
                        rs.getDouble("base_price"), 
                        rs.getInt("capacity"),
                        rs.getString("image_url"));
                
                roomTypeList.add(roomtype);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return roomTypeList;
    }
}
