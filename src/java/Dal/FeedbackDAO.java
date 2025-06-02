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

}
