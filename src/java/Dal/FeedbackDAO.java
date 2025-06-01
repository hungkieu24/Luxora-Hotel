/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Dal;

import Model.Feedback;
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

}
