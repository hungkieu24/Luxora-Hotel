package Model;

public class BranchReport {
    private int branchId;
    private String branchName;
    private String branchAddress;
    private String branchPhone;
    private String branchEmail;
    private int totalRooms;
    private int totalBookings;
    private double totalRevenue;
    private double occupancyRate;
    private double averageRating;
    private int totalFeedbacks;
    
    // Default constructor
    public BranchReport() {}
    
    // Constructor with parameters
    public BranchReport(int branchId, String branchName, String branchAddress, 
                       String branchPhone, String branchEmail, int totalRooms, 
                       int totalBookings, double totalRevenue, double occupancyRate,
                       double averageRating, int totalFeedbacks) {
        this.branchId = branchId;
        this.branchName = branchName;
        this.branchAddress = branchAddress;
        this.branchPhone = branchPhone;
        this.branchEmail = branchEmail;
        this.totalRooms = totalRooms;
        this.totalBookings = totalBookings;
        this.totalRevenue = totalRevenue;
        this.occupancyRate = occupancyRate;
        this.averageRating = averageRating;
        this.totalFeedbacks = totalFeedbacks;
    }
    
    // Getters and Setters
    public int getBranchId() {
        return branchId;
    }
    
    public void setBranchId(int branchId) {
        this.branchId = branchId;
    }
    
    public String getBranchName() {
        return branchName;
    }
    
    public void setBranchName(String branchName) {
        this.branchName = branchName;
    }
    
    public String getBranchAddress() {
        return branchAddress;
    }
    
    public void setBranchAddress(String branchAddress) {
        this.branchAddress = branchAddress;
    }
    
    public String getBranchPhone() {
        return branchPhone;
    }
    
    public void setBranchPhone(String branchPhone) {
        this.branchPhone = branchPhone;
    }
    
    public String getBranchEmail() {
        return branchEmail;
    }
    
    public void setBranchEmail(String branchEmail) {
        this.branchEmail = branchEmail;
    }
    
    public int getTotalRooms() {
        return totalRooms;
    }
    
    public void setTotalRooms(int totalRooms) {
        this.totalRooms = totalRooms;
    }
    
    public int getTotalBookings() {
        return totalBookings;
    }
    
    public void setTotalBookings(int totalBookings) {
        this.totalBookings = totalBookings;
    }
    
    public double getTotalRevenue() {
        return totalRevenue;
    }
    
    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }
    
    public double getOccupancyRate() {
        return occupancyRate;
    }
    
    public void setOccupancyRate(double occupancyRate) {
        this.occupancyRate = occupancyRate;
    }
    
    public double getAverageRating() {
        return averageRating;
    }
    
    public void setAverageRating(double averageRating) {
        this.averageRating = averageRating;
    }
    
    public int getTotalFeedbacks() {
        return totalFeedbacks;
    }
    
    public void setTotalFeedbacks(int totalFeedbacks) {
        this.totalFeedbacks = totalFeedbacks;
    }
    
    @Override
    public String toString() {
        return "BranchReport{" +
                "branchId=" + branchId +
                ", branchName='" + branchName + '\'' +
                ", branchAddress='" + branchAddress + '\'' +
                ", totalRooms=" + totalRooms +
                ", totalBookings=" + totalBookings +
                ", totalRevenue=" + totalRevenue +
                ", occupancyRate=" + occupancyRate +
                ", averageRating=" + averageRating +
                ", totalFeedbacks=" + totalFeedbacks +
                '}';
    }
}