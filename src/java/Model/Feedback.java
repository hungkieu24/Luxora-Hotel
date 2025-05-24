/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;
import java.sql.Timestamp;

/**
 *
 * @author hungk
 */
public class Feedback {
    private int feedbackID;
    private String user_id;
    private int booking_id;
    private int rating;
    private String comment;
    private String image_url;
    private Timestamp created_at;
    private String status;
    private String admin_action;

    public Feedback() {
    }

    public Feedback(int feedbackID, String user_id, int booking_id, int rating, String comment, String image_url, Timestamp created_at, String status, String admin_action) {
        this.feedbackID = feedbackID;
        this.user_id = user_id;
        this.booking_id = booking_id;
        this.rating = rating;
        this.comment = comment;
        this.image_url = image_url;
        this.created_at = created_at;
        this.status = status;
        this.admin_action = admin_action;
    }

    public Feedback(int rating, String comment, Timestamp created_at, String status) {
        this.rating = rating;
        this.comment = comment;
        this.created_at = created_at;
        this.status = status;
    }

    public int getFeedbackID() {
        return feedbackID;
    }

    public void setFeedbackID(int feedbackID) {
        this.feedbackID = feedbackID;
    }

    public String getUser_id() {
        return user_id;
    }

    public void setUser_id(String user_id) {
        this.user_id = user_id;
    }

    public int getBooking_id() {
        return booking_id;
    }

    public void setBooking_id(int booking_id) {
        this.booking_id = booking_id;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getImage_url() {
        return image_url;
    }

    public void setImage_url(String image_url) {
        this.image_url = image_url;
    }

    public Timestamp getCreated_at() {
        return created_at;
    }

    public void setCreated_at(Timestamp created_at) {
        this.created_at = created_at;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAdmin_action() {
        return admin_action;
    }

    public void setAdmin_action(String admin_action) {
        this.admin_action = admin_action;
    }

    @Override
    public String toString() {
        return "Feedback{" + "rating=" + rating + ", comment=" + comment + ", created_at=" + created_at + ", status=" + status + '}';
    }
}
