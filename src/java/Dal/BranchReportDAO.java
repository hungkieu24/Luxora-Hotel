package Dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import Model.BranchReport;
import DBcontext.DBContext;

public class BranchReportDAO extends DBContext {
    
    private static final Logger LOGGER = Logger.getLogger(BranchReportDAO.class.getName());
    
    public List<BranchReport> getBranchReports(String ownerId, String startDate, String endDate, String reportType) 
            throws SQLException {
        List<BranchReport> reports = new ArrayList<>();
        
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
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            Date sqlStartDate = Date.valueOf(startDate);
            Date sqlEndDate = Date.valueOf(endDate);
            
            stmt.setDate(1, sqlStartDate);
            stmt.setDate(2, sqlEndDate);
            stmt.setDate(3, sqlStartDate);
            stmt.setDate(4, sqlEndDate);
            stmt.setString(5, ownerId);
            
            LOGGER.info("Executing getBranchReports query for owner: " + ownerId);
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
            
            LOGGER.info("Retrieved " + reports.size() + " branch reports");
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error in getBranchReports", ex);
            throw ex;
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

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            Date sqlStartDate = Date.valueOf(startDate);
            Date sqlEndDate = Date.valueOf(endDate);

            stmt.setDate(1, sqlStartDate);
            stmt.setDate(2, sqlEndDate);
            stmt.setDate(3, sqlStartDate);
            stmt.setDate(4, sqlEndDate);
            stmt.setString(5, ownerId);
            stmt.setString(6, branchId);

            LOGGER.info("Executing getIndividualBranchReport for branch: " + branchId + ", owner: " + ownerId);
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

                LOGGER.info("Successfully retrieved individual branch report for: " + report.getBranchName());
                return report;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error in getIndividualBranchReport", ex);
            throw ex;
        }

        LOGGER.warning("No branch report found for branchId: " + branchId + ", ownerId: " + ownerId);
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
            Date sqlStartDate = Date.valueOf(startDate);
            Date sqlEndDate = Date.valueOf(endDate);
            
            stmt.setDate(1, sqlStartDate);
            stmt.setDate(2, sqlStartDate);
            stmt.setDate(3, sqlEndDate);
            stmt.setDate(4, sqlEndDate);
            stmt.setInt(5, branchId);
            stmt.setDate(6, sqlStartDate);
            stmt.setDate(7, sqlEndDate);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int bookedRoomNights = rs.getInt("total_room_nights");
                int totalPossibleRoomNights = totalRooms * calculateDaysBetween(startDate, endDate);
                return totalPossibleRoomNights > 0 ? (double) bookedRoomNights / totalPossibleRoomNights * 100 : 0.0;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.WARNING, "Error calculating occupancy rate", ex);
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
            LOGGER.warning("Error calculating days between dates: " + startDate + " to " + endDate);
            return 1;
        }
    }
    
    public List<BranchReport> getTopPerformingBranches(String ownerId, String startDate, String endDate, int limit) 
            throws SQLException {
        List<BranchReport> topBranches = getBranchReports(ownerId, startDate, endDate, "revenue");
        topBranches.sort((a, b) -> Double.compare(b.getTotalRevenue(), a.getTotalRevenue()));
        return topBranches.size() > limit ? topBranches.subList(0, limit) : topBranches;
    }
    
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
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, ownerId);
            LOGGER.info("Executing getAllBranches query for owner: " + ownerId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                BranchReport branch = new BranchReport();
                branch.setBranchId(rs.getInt("branch_id"));
                branch.setBranchName(rs.getString("branch_name"));
                branches.add(branch);
            }
            
            LOGGER.info("Retrieved " + branches.size() + " branches for owner: " + ownerId);
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error in getAllBranches", ex);
            throw ex;
        }
        
        return branches;
    }
    
    @Override
    protected void finalize() throws Throwable {
        closeConnection();
        super.finalize();
    }
}