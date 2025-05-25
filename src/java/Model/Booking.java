package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Booking {
    private int id;
    private String userId; 
    private String hotelName;
    private String roomName;
    private Timestamp checkInDate;
    private Timestamp checkOutDate;
    private String status;
    private BigDecimal totalPrice;

    public Booking() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }

    public String getHotelName() { return hotelName; }
    public void setHotelName(String hotelName) { this.hotelName = hotelName; }

    public String getRoomName() { return roomName; }
    public void setRoomName(String roomName) { this.roomName = roomName; }

    public Timestamp getCheckInDate() { return checkInDate; }
    public void setCheckInDate(Timestamp checkInDate) { this.checkInDate = checkInDate; }

    public Timestamp getCheckOutDate() { return checkOutDate; }
    public void setCheckOutDate(Timestamp checkOutDate) { this.checkOutDate = checkOutDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public BigDecimal getTotalPrice() { return totalPrice; }
    public void setTotalPrice(BigDecimal totalPrice) { this.totalPrice = totalPrice; }
}