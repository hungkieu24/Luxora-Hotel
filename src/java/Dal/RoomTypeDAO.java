/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Dal;

import Model.RoomType;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author hungk
 */
public class RoomTypeDAO extends DBcontext.DBContext {

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

    public List<RoomType> searchAvailableRoomTypes(LocalDate checkIn, LocalDate checkOut, int guests, int branchId) {
        List<RoomType> availableRoomTypes = new ArrayList<>();

        String sql = """
            SELECT DISTINCT rt.id, rt.name, rt.description, rt.base_price, rt.capacity, rt.image_url
            FROM RoomType rt
            WHERE rt.capacity >= ?
              AND EXISTS (
                  SELECT 1
                  FROM Room r
                  WHERE r.room_type_id = rt.id
                    AND r.branch_id = ?
                    AND r.status NOT IN ('Maintenance', 'Locked')
                    AND r.id NOT IN (
                        SELECT br.room_id
                        FROM BookingRoom br
                        JOIN Booking b ON br.booking_id = b.id
                        WHERE b.status NOT IN ('Cancelled', 'Locked')
                          AND b.check_in < ?
                          AND b.check_out > ?
                    )
              )
            """;

        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, guests);
            st.setInt(2, branchId);
            st.setDate(3, Date.valueOf(checkOut));
            st.setDate(4, Date.valueOf(checkIn));

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                RoomType roomType = new RoomType(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getDouble("base_price"),
                        rs.getInt("capacity"),
                        rs.getString("image_url")
                );
                availableRoomTypes.add(roomType);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return availableRoomTypes;
    }

    public Map<Integer, String> getRoomTypeMap() {
        Map<Integer, String> map = new HashMap<>();
        String sql = "SELECT id, name FROM RoomType";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                map.put(rs.getInt("id"), rs.getString("name"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return map;
    }

    public RoomType getRoomTypeById(int roomtypeId){
        RoomType roomtype = null;
        String sql ="select * from RoomType where id = ?";
        try(PreparedStatement ps = connection.prepareStatement(sql)){
            ps.setInt(1, roomtypeId);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                roomtype = new RoomType(
                        rs.getInt("id"),
                        rs.getString("name"),
                        rs.getString("description"),
                        rs.getDouble("base_price"),
                        rs.getInt("capacity"),
                        rs.getString("image_url"));
            }
        }catch(SQLException e){
            e.printStackTrace();
        }
        return roomtype;
    }
    public void updateRoomType(int roomtypeId, double basePrice, int capacity, String description){
        String sql ="update RoomType set base_price = ? , capacity =?, description =? where id = ?";
        try(PreparedStatement ps = connection.prepareStatement(sql)){
            ps.setDouble(1, basePrice);
            ps.setInt(2, capacity);
            ps.setString(3, description);
            ps.setInt(4, roomtypeId);
            ps.executeUpdate();
        }catch(SQLException e){
            e.printStackTrace();
        }
    }

    
    public Map<Integer, Double> getRoomTypePriceMap() {
      Map<Integer, Double> map = new HashMap<>();
      String sql = "SELECT id, base_price FROM RoomType";
      try (
           PreparedStatement ps = connection.prepareStatement(sql);
           ResultSet rs = ps.executeQuery()) {
          while (rs.next()) {
              int id = rs.getInt("id");
              double price = rs.getDouble("base_price");
              map.put(id, price);
          }
      } catch (Exception e) {
          e.printStackTrace();
      }
      return map;
  }
}
