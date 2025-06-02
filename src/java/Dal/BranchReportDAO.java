///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//package Dal;
//
//import java.sql.*;
//import java.util.ArrayList;
//import java.util.List;
//import Model.BranchReport;
//import DBcontext.DBContext;
//
//public class BranchReportDAO extends DBContext {
//    
//    public List<BranchReport> getBranchReports(String ownerId, String startDate, String endDate, String reportType) 
//            throws SQLException {
//        List<BranchReport> reports = new ArrayList<>();
//        DBContext db = new DBContext();
//        
//        String sql = """
//            SELECT 
//                hb.id as branch_id,
//                hb.name as branch_name,
//                hb.address as branch_address,
//                hb.phone as branch_phone,
//                hb.email as branch_email,
//                COUNT(DISTINCT r.id) as total_rooms,
//                COUNT(DISTINCT CASE WHEN b.status IN ('Confirmed', 'CheckedIn', 'CheckedOut') 
//                      AND b.check_out > ? AND b.check_in < DATEADD(day, 1, ?) THEN b.id END) as total_bookings,
//                ISNULL(SUM(CASE WHEN b.status IN ('Confirmed', 'CheckedIn', 'CheckedOut') 
//                           AND b.check_out > ? AND b.check_in < DATEADD(day, 1, ?) THEN b.total_price END), 0) as total_revenue,
//                ISNULL(AVG(CAST(f.rating AS FLOAT)), 0) as average_rating,
//                COUNT(DISTINCT f.id) as total_feedbacks
//            FROM HotelBranch hb
//            LEFT JOIN Room r ON hb.id = r.branch_id
//            LEFT JOIN BookingRoom br ON r.id = br.room_id
//            LEFT JOIN Booking b ON br.booking_id = b.id
//            LEFT JOIN Feedback f ON b.id = f.booking_id
//            WHERE hb.owner_id = ?
//            GROUP BY hb.id, hb.name, hb.address, hb.phone, hb.email
//            ORDER BY hb.name
//        """;
//        
//        try (Connection conn = db.connection;
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//            
//            stmt.setString(1, startDate);
//            stmt.setString(2, endDate);
//            stmt.setString(3, startDate);
//            stmt.setString(4, endDate);
//            stmt.setString(5, ownerId);
//            
//            ResultSet rs = stmt.executeQuery();
//            
//            while (rs.next()) {
//                BranchReport report = new BranchReport();
//                report.setBranchId(rs.getInt("branch_id"));
//                report.setBranchName(rs.getString("branch_name"));
//                report.setBranchAddress(rs.getString("branch_address"));
//                report.setBranchPhone(rs.getString("branch_phone"));
//                report.setBranchEmail(rs.getString("branch_email"));
//                report.setTotalRooms(rs.getInt("total_rooms"));
//                report.setTotalBookings(rs.getInt("total_bookings"));
//                report.setTotalRevenue(rs.getDouble("total_revenue"));
//                report.setAverageRating(rs.getDouble("average_rating"));
//                report.setTotalFeedbacks(rs.getInt("total_feedbacks"));
//                
//                
//                double occupancyRate = calculateOccupancyRate(conn, rs.getInt("branch_id"), startDate, endDate, rs.getInt("total_rooms"));
//                report.setOccupancyRate(occupancyRate);
//                
//                reports.add(report);
//            }
//        }
//        return reports;
//    }
//    
//    public BranchReport getIndividualBranchReport(String ownerId, String branchId, String startDate, String endDate) throws SQLException {
//        String sql = """
//            SELECT 
//                hb.id as branch_id,
//                hb.name as branch_name,
//                hb.address as branch_address,
//                hb.phone as branch_phone,
//                hb.email as branch_email,
//                COUNT(DISTINCT r.id) as total_rooms,
//                COUNT(DISTINCT CASE WHEN b.status IN ('Confirmed', 'CheckedIn', 'CheckedOut') 
//                      AND b.check_out > ? AND b.check_in < DATEADD(day, 1, ?) THEN b.id END) as total_bookings,
//                ISNULL(SUM(CASE WHEN b.status IN ('Confirmed', 'CheckedIn', 'CheckedOut') 
//                           AND b.check_out > ? AND b.check_in < DATEADD(day, 1, ?) THEN b.total_price END), 0) as total_revenue,
//                ISNULL(AVG(CAST(f.rating AS FLOAT)), 0) as average_rating,
//                COUNT(DISTINCT f.id) as total_feedbacks
//            FROM HotelBranch hb
//            LEFT JOIN Room r ON hb.id = r.branch_id
//            LEFT JOIN BookingRoom br ON r.id = br.room_id
//            LEFT JOIN Booking b ON br.booking_id = b.id
//            LEFT JOIN Feedback f ON b.id = f.booking_id
//            WHERE hb.owner_id = ? AND hb.id = ?
//            GROUP BY hb.id, hb.name, hb.address, hb.phone, hb.email
//        """;
//        
//        try (Connection conn = connection;
//             PreparedStatement stmt = conn.prepareStatement(sql)) {
//            
//            stmt.setString(1, startDate);
//            stmt.setString(2, endDate);
//            stmt.setString(3, startDate);
//            stmt.setString(4, endDate);
//            stmt.setString(5, ownerId);
//            stmt.setString(6, branchId);
//            
//            ResultSet rs = stmt.executeQuery();
//            
//            if (rs.next()) {
//                BranchReport report = new BranchReport();
//                report.setBranchId(rs.getInt("branch_id"));
//                report.setBranchName(rs.getString("branch_name"));
//                report.setBranchAddress(rs.getString("branch_address"));
//                report.setBranchPhone(rs.getString("branch_phone"));
//                report.setBranchEmail(rs.getString("branch_email"));
//                report.setTotalRooms(rs.getInt("total_rooms"));
//                report.setTotalBookings(rs.getInt("total_bookings"));
//                report.setTotalRevenue(rs.getDouble("total_revenue"));
//                report.setAverageRating(rs.getDouble("average_rating"));
//                report.setTotalFeedbacks(rs.getInt("total_feedbacks"));
//                
//                double occupancyRate = calculateOccupancyRate(conn, rs.getInt("branch_id"), startDate, endDate, rs.getInt("total_rooms"));
//                report.setOccupancyRate(occupancyRate);
//                
//                return report;
//            }
//        }
//        return null;
//    }
//    
//    private double calculateOccupancyRate(Connection conn, int branchId, String startDate, String endDate, int totalRooms) throws SQLException {
//        if (totalRooms == 0) return 0.0;
//        
//        String sql = """
//            SELECT 
//                SUM(DATEDIFF(day, 
//                    CASE WHEN b.check_in < ? THEN ? ELSE b.check_in END,
//                    CASE WHEN b.check_out > ? THEN ? ELSE b.check_out END
//                )) as total_room_nights
//            FROM Booking b
//            JOIN BookingRoom br ON b.id = br.booking_id
//            JOIN Room r ON br.room_id = r.id
//            WHERE r.branch_id = ?
//            AND b.status IN ('Confirmed', 'CheckedIn', 'CheckedOut')
//            AND b.check_out > ?
//            AND b.check_in < DATEADD(day, 1, ?)
//        """;
//        
//        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
//            stmt.setString(1, startDate);
//            stmt.setString(2, startDate);
//            stmt.setString(3, endDate);
//            stmt.setString(4, endDate);
//            stmt.setInt(5, branchId);
//            stmt.setString(6, startDate);
//            stmt.setString(7, endDate);
//            
//            ResultSet rs = stmt.executeQuery();
//            if (rs.next()) {
//                int bookedRoomNights = rs.getInt("total_room_nights");
//                int totalPossibleRoomNights = totalRooms * calculateDaysBetween(startDate, endDate);
//                return totalPossibleRoomNights > 0 ? (double) bookedRoomNights / totalPossibleRoomNights * 100 : 0.0;
//            }
//        }
//        return 0.0;
//    }
//    
//    private int calculateDaysBetween(String startDate, String endDate) {
//        try {
//            java.sql.Date start = java.sql.Date.valueOf(startDate);
//            java.sql.Date end = java.sql.Date.valueOf(endDate);
//            long diff = end.getTime() - start.getTime();
//            return (int) (diff / (1000 * 60 * 60 * 24)) + 1;
//        } catch (IllegalArgumentException e) {
//            return 1;
//        }
//    }
//    
//    public List<BranchReport> getTopPerformingBranches(String ownerId, String startDate, String endDate, int limit) 
//            throws SQLException {
//        List<BranchReport> topBranches = getBranchReports(ownerId, startDate, endDate, "revenue");
//        topBranches.sort((a, b) -> Double.compare(b.getTotalRevenue(), a.getTotalRevenue()));
//        return topBranches.size() > limit ? topBranches.subList(0, limit) : topBranches;
//    }
//}

/*
 * Updated BranchReportDAO.java with method to fetch all branches
 */
package Dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import Model.BranchReport;
import DBcontext.DBContext;

public class BranchReportDAO extends DBContext {
    
    // Existing methods remain unchanged
    public List<BranchReport> getBranchReports(String ownerId, String startDate, String endDate, String reportType) 
            throws SQLException {
        List<BranchReport> reports = new ArrayList<>();
        DBContext db = new DBContext();
        
        String sql = """
            SELECT 
                hb.id as branch_id,
                hb.name as branch_name,
                hb.address as branch_address,
                hb.phone as branch_phone,
                hb.email as branch_email,
                COUNT(DISTINCT r.id) as total_rooms,
                COUNT(DISTINCT CASE WHEN b.status IN ('Confirmed', 'CheckedIn', 'CheckedOut') 
                      AND b.check_out > ? AND b.check_in < DATEADD(day, 1, ?) THEN b.id END) as total_bookings,
                ISNULL(SUM(CASE WHEN b.status IN ('Confirmed', 'CheckedIn', 'CheckedOut') 
                           AND b.check_out > ? AND b.check_in < DATEADD(day, 1, ?) THEN b.total_price END), 0) as total_revenue,
                ISNULL(AVG(CAST(f.rating AS FLOAT)), 0) as average_rating,
                COUNT(DISTINCT f.id) as total_feedbacks
            FROM HotelBranch hb
            LEFT JOIN Room r ON hb.id = r.branch_id
            LEFT JOIN BookingRoom br ON r.id = br.room_id
            LEFT JOIN Booking b ON br.booking_id = b.id
            LEFT JOIN Feedback f ON b.id = f.booking_id
            WHERE hb.owner_id = ?
            GROUP BY hb.id, hb.name, hb.address, hb.phone, hb.email
            ORDER BY hb.name
        """;
        
        try (Connection conn = db.connection;
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, startDate);
            stmt.setString(2, endDate);
            stmt.setString(3, startDate);
            stmt.setString(4, endDate);
            stmt.setString(5, ownerId);
            
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                BranchReport report = new BranchReport();
                report.setBranchId(rs.getInt("branch_id"));
                report.setBranchName(rs.getString("branch_name"));
                report.setBranchAddress(rs.getString("branch_address"));
                report.setBranchPhone(rs.getString("branch_phone"));
                report.setBranchEmail(rs.getString("branch_email"));
                report.setTotalRooms(rs.getInt("total_rooms"));
                report.setTotalBookings(rs.getInt("total_bookings"));
                report.setTotalRevenue(rs.getDouble("total_revenue"));
                report.setAverageRating(rs.getDouble("average_rating"));
                report.setTotalFeedbacks(rs.getInt("total_feedbacks"));
                
                double occupancyRate = calculateOccupancyRate(conn, rs.getInt("branch_id"), startDate, endDate, rs.getInt("total_rooms"));
                report.setOccupancyRate(occupancyRate);
                
                reports.add(report);
            }
        }
        return reports;
    }
    
    public BranchReport getIndividualBranchReport(String ownerId, String branchId, String startDate, String endDate) throws SQLException {
        
        String sql = """
            SELECT 
                hb.id as branch_id,
                hb.name as branch_name,
                hb.address as branch_address,
                hb.phone as branch_phone,
                hb.email as branch_email,
                COUNT(DISTINCT r.id) as total_rooms,
                COUNT(DISTINCT CASE WHEN b.status IN ('Confirmed', 'CheckedIn', 'CheckedOut') 
                      AND b.check_out > ? AND b.check_in < DATEADD(day, 1, ?) THEN b.id END) as total_bookings,
                ISNULL(SUM(CASE WHEN b.status IN ('Confirmed', 'CheckedIn', 'CheckedOut') 
                           AND b.check_out > ? AND b.check_in < DATEADD(day, 1, ?) THEN b.total_price END), 0) as total_revenue,
                ISNULL(AVG(CAST(f.rating AS FLOAT)), 0) as average_rating,
                COUNT(DISTINCT f.id) as total_feedbacks
            FROM HotelBranch hb
            LEFT JOIN Room r ON hb.id = r.branch_id
            LEFT JOIN BookingRoom br ON r.id = br.room_id
            LEFT JOIN Booking b ON br.booking_id = b.id
            LEFT JOIN Feedback f ON b.id = f.booking_id
            WHERE hb.owner_id = ? AND hb.id = ?
            GROUP BY hb.id, hb.name, hb.address, hb.phone, hb.email
        """;
        
        try (Connection conn = connection;
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, startDate);
            stmt.setString(2, endDate);
            stmt.setString(3, startDate);
            stmt.setString(4, endDate);
            stmt.setString(5, ownerId);
            stmt.setString(6, branchId);
            
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                BranchReport report = new BranchReport();
                report.setBranchId(rs.getInt("branch_id"));
                report.setBranchName(rs.getString("branch_name"));
                report.setBranchAddress(rs.getString("branch_address"));
                report.setBranchPhone(rs.getString("branch_phone"));
                report.setBranchEmail(rs.getString("branch_email"));
                report.setTotalRooms(rs.getInt("total_rooms"));
                report.setTotalBookings(rs.getInt("total_bookings"));
                report.setTotalRevenue(rs.getDouble("total_revenue"));
                report.setAverageRating(rs.getDouble("average_rating"));
                report.setTotalFeedbacks(rs.getInt("total_feedbacks"));
                
                double occupancyRate = calculateOccupancyRate(conn, rs.getInt("branch_id"), startDate, endDate, rs.getInt("total_rooms"));
                report.setOccupancyRate(occupancyRate);
                
                return report;
            }
        }
        return null;
    }
    
    private double calculateOccupancyRate(Connection conn, int branchId, String startDate, String endDate, int totalRooms) throws SQLException {
        if (totalRooms == 0) return 0.0;
        
        String sql = """
            SELECT 
                SUM(DATEDIFF(day, 
                    CASE WHEN b.check_in < ? THEN ? ELSE b.check_in END,
                    CASE WHEN b.check_out > ? THEN ? ELSE b.check_out END
                )) as total_room_nights
            FROM Booking b
            JOIN BookingRoom br ON b.id = br.booking_id
            JOIN Room r ON br.room_id = r.id
            WHERE r.branch_id = ?
            AND b.status IN ('Confirmed', 'CheckedIn', 'CheckedOut')
            AND b.check_out > ?
            AND b.check_in < DATEADD(day, 1, ?)
        """;
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, startDate);
            stmt.setString(2, startDate);
            stmt.setString(3, endDate);
            stmt.setString(4, endDate);
            stmt.setInt(5, branchId);
            stmt.setString(6, startDate);
            stmt.setString(7, endDate);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int bookedRoomNights = rs.getInt("total_room_nights");
                int totalPossibleRoomNights = totalRooms * calculateDaysBetween(startDate, endDate);
                return totalPossibleRoomNights > 0 ? (double) bookedRoomNights / totalPossibleRoomNights * 100 : 0.0;
            }
        }
        return 0.0;
    }
    
    private int calculateDaysBetween(String startDate, String endDate) {
        try {
            java.sql.Date start = java.sql.Date.valueOf(startDate);
            java.sql.Date end = java.sql.Date.valueOf(endDate);
            long diff = end.getTime() - start.getTime();
            return (int) (diff / (1000 * 60 * 60 * 24)) + 1;
        } catch (IllegalArgumentException e) {
            return 1;
        }
    }
    
    public List<BranchReport> getTopPerformingBranches(String ownerId, String startDate, String endDate, int limit) 
            throws SQLException {
        List<BranchReport> topBranches = getBranchReports(ownerId, startDate, endDate, "revenue");
        topBranches.sort((a, b) -> Double.compare(b.getTotalRevenue(), a.getTotalRevenue()));
        return topBranches.size() > limit ? topBranches.subList(0, limit) : topBranches;
    }
    
    // New method to fetch all branches for dropdown
    public List<BranchReport> getAllBranches(String ownerId) throws SQLException {
        List<BranchReport> branches = new ArrayList<>();
        String sql = """
            SELECT 
                hb.id as branch_id,
                hb.name as branch_name
            FROM HotelBranch hb
            WHERE hb.owner_id = ?
            ORDER BY hb.name
        """;
        
        try (Connection conn = connection;
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, ownerId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                BranchReport branch = new BranchReport();
                branch.setBranchId(rs.getInt("branch_id"));
                branch.setBranchName(rs.getString("branch_name"));
                branches.add(branch);
            }
        }
        return branches;
    }
}