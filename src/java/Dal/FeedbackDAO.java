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
}
