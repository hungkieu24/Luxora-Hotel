/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Dal;

import Model.Feedback;
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
public class FeedbackDAO extends DBcontext.DBContext {

    public List<Feedback> getAllFeedBackComment() {
        List<Feedback> feedbackList = new ArrayList<>();
        String sql = "SELECT * FROM Feedback Where status In ('Visible')";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Feedback feedback = new Feedback(
                        rs.getInt("rating"),
                        rs.getString("comment"),
                        rs.getTimestamp("created_at"),
                        rs.getString("status"));

                feedbackList.add(feedback);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbackList;
    }

    public void addFeedback(Feedback feedback) {
        String sql = "INSERT INTO Feedback (user_id, booking_id, rating, comment, image_url, created_at, status, admin_action) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, feedback.getUser_id());
            ps.setInt(2, feedback.getBooking_id());
            ps.setInt(3, feedback.getRating());
            ps.setString(4, feedback.getComment());
            ps.setString(5, feedback.getImage_url());
            ps.setTimestamp(6, feedback.getCreated_at());
            ps.setString(7, feedback.getStatus());
            ps.setString(8, feedback.getAdmin_action());
            ps.executeUpdate();
            ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Feedback> getAllFeedBack() {
        List<Feedback> feedbackList = new ArrayList<>();
        String sql = "SELECT f.booking_id, f.rating, f.comment, f.created_at, u.username "
                + "FROM Feedback f "
                + "JOIN UserAccount u ON f.user_id = u.id "
                + "WHERE f.status = 'Visible'";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Feedback feedback = new Feedback(
                        rs.getInt("booking_id"),
                        rs.getInt("rating"),
                        rs.getString("comment"),
                        rs.getTimestamp("created_at"),
                        rs.getString("username"));

                feedbackList.add(feedback);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbackList;
    }

    public List<Feedback> getListFeedbackByPage(int page, int pageSize) {
        List<Feedback> feedbackList = new ArrayList<>();
        String sql = "SELECT f.booking_id, f.rating, f.comment, f.created_at, u.username "
                + "FROM Feedback f "
                + "JOIN UserAccount u ON f.user_id = u.id "
                + "WHERE f.status = 'Visible' "
                + "ORDER BY f.id "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, (page - 1) * pageSize);
            stmt.setInt(2, pageSize);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Feedback feedback = new Feedback(
                        rs.getInt("booking_id"),
                        rs.getInt("rating"),
                        rs.getString("comment"),
                        rs.getTimestamp("created_at"),
                        rs.getString("username")
                );
                feedbackList.add(feedback);
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }

        return feedbackList;
    }

    public List<Feedback> getUniqueFiveStarFeedbacksFromCustomers() {
        List<Feedback> feedbackList = new ArrayList<>();
        String sql = "SELECT fb.id AS feedback_id, fb.booking_id, fb.rating, fb.comment, fb.image_url, fb.created_at, fb.status, fb.admin_action, "
                + "ua.id AS user_id, ua.username, ua.password, ua.email, ua.avatar_url, ua.role, ua.status AS user_status, "
                + "ua.created_at AS user_created, ua.phonenumber "
                + "FROM Feedback fb "
                + "INNER JOIN UserAccount ua ON fb.user_id = ua.id "
                + "WHERE fb.rating = 5 AND ua.role = 'Customer' "
                + "AND fb.id IN ( SELECT MIN(f2.id) FROM Feedback f2 "
                + "INNER JOIN UserAccount u2 ON f2.user_id = u2.id "
                + "WHERE f2.rating = 5 AND u2.role = 'Customer' "
                + "GROUP BY f2.user_id ) "
                + "ORDER BY fb.created_at DESC ";

        try (PreparedStatement stmt = connection.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                // Create UserAccount object
                UserAccount user = new UserAccount(
                        rs.getString("user_id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("email"),
                        rs.getString("avatar_url"),
                        rs.getString("role"),
                        rs.getString("user_status"),
                        rs.getString("phonenumber")
                );

                // Create Feedback object
                Feedback feedback = new Feedback(
                        rs.getInt("feedback_id"),
                        rs.getInt("booking_id"),
                        rs.getInt("rating"),
                        rs.getString("comment"),
                        rs.getString("image_url"),
                        rs.getTimestamp("created_at"),
                        rs.getString("status"),
                        rs.getString("admin_action"),
                        user
                );

                feedbackList.add(feedback);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return feedbackList;
    }

    public List<Feedback> getAllFeedbackWithPagination(int page, int pageSize, String status, String sortBy) {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT f.*, u.username, u.avatar_url " +
                    "FROM Feedback f " +
                    "LEFT JOIN UserAccount u ON f.user_id = u.id " +
                    "WHERE 1=1 ";
        
        // Add status filter if provided
        if (status != null && !status.equals("all")) {
            sql += "AND f.status = ? ";
        }
        
        // Add sorting
        switch (sortBy) {
            case "rating":
                sql += "ORDER BY f.rating DESC ";
                break;
            case "date":
                sql += "ORDER BY f.created_at DESC ";
                break;
            case "status":
                sql += "ORDER BY f.status ASC ";
                break;
            default:
                sql += "ORDER BY f.created_at DESC ";
        }
        
        // Add pagination
        sql += "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            int paramIndex = 1;
            
            if (status != null && !status.equals("all")) {
                ps.setString(paramIndex++, status);
            }
            
            ps.setInt(paramIndex++, (page - 1) * pageSize);
            ps.setInt(paramIndex, pageSize);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Feedback feedback = new Feedback(
                    rs.getInt("id"),
                    rs.getString("user_id"),
                        rs.getInt("booking_id"),
                    rs.getInt("rating"),
                    rs.getString("comment"),
                    rs.getString("image_url"),
                    rs.getTimestamp("created_at"),
                    rs.getString("status"),
                    rs.getString("admin_action")
                        
                );
                feedback.setUsername(rs.getString("username"));
                feedback.setUserAvatarUrl(rs.getString("avatar_url"));
                feedbacks.add(feedback);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return feedbacks;
    }
    
    // Get total feedback count for pagination
    public int getTotalFeedbackCount(String status) {
        String sql = "SELECT COUNT(*) FROM Feedback WHERE 1=1 ";
        if (status != null && !status.equals("all")) {
            sql += "AND status = ?";
        }
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            if (status != null && !status.equals("all")) {
                ps.setString(1, status);
            }
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }
    
    // Get feedback by ID
    public Feedback getFeedbackById(int id) {
        String sql = "SELECT f.*, u.username, u.avatar_url " +
                    "FROM Feedback f " +
                    "LEFT JOIN UserAccount u ON f.user_id = u.id " +
                    "WHERE f.id = ?";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                Feedback feedback = new Feedback(
                    rs.getInt("id"),
                    rs.getString("user_id"),
                    rs.getInt("booking_id"),
                    rs.getInt("rating"),
                    rs.getString("comment"),
                    rs.getString("image_url"),
                    rs.getTimestamp("created_at"),
                    rs.getString("status"),
                    rs.getString("admin_action")
                );
                feedback.setUsername(rs.getString("username"));
                feedback.setUserAvatarUrl(rs.getString("avatar_url"));
                return feedback;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }
    
    public FeedbackStats getFeedbackStats() {
        String sql = "SELECT " +
                    "COUNT(*) as total, " +
                    "SUM(CASE WHEN status = 'Visible' THEN 1 ELSE 0 END) as visible, " +
                    "SUM(CASE WHEN status = 'Hidden' THEN 1 ELSE 0 END) as hidden, " +
                    "SUM(CASE WHEN status = 'Blocked' THEN 1 ELSE 0 END) as blocked, " +
                    "AVG(CAST(rating as FLOAT)) as avgRating " +
                    "FROM Feedback";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return new FeedbackStats(
                    rs.getInt("total"),
                    rs.getInt("visible"),
                    rs.getInt("hidden"),
                    rs.getInt("blocked"),
                    rs.getDouble("avgRating")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return new FeedbackStats(0, 0, 0, 0, 0.0);
    }
    
    // Inner class for statistics
    public static class FeedbackStats {
        private int total;
        private int visible;
        private int hidden;
        private int blocked;
        private double avgRating;
        
        public FeedbackStats(int total, int visible, int hidden, int blocked, double avgRating) {
            this.total = total;
            this.visible = visible;
            this.hidden = hidden;
            this.blocked = blocked;
            this.avgRating = avgRating;
        }
        
        // Getters
        public int getTotal() { return total; }
        public int getVisible() { return visible; }
        public int getHidden() { return hidden; }
        public int getBlocked() { return blocked; }
        public double getAvgRating() { return avgRating; }
    }

    public boolean updateFeedbackStatus(int id, String status, String adminAction) {
        String sql = "UPDATE Feedback SET status = ?, admin_action = ? WHERE id = ?";
        
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, status);
            ps.setString(2, adminAction);
            ps.setInt(3, id);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }
}
