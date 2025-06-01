/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.admin;

import Dal.HotelBranchDAO;
import Dal.UserAccountDAO;
import Model.HotelBranch;
import Model.UserAccount;
import Utility.UploadImage;
import Utility.UploadMultyImage;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.File;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author hungk
 */
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
        maxFileSize = 1024 * 1024 * 10, // 10 MB
        maxRequestSize = 1024 * 1024 * 50 // 50 MB
)
@WebServlet(name = "branchEventHandlerServlet", urlPatterns = {"/admin/branchEventHandler"})
public class branchEventHandlerServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet branchEventHandlerServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet branchEventHandlerServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int branchID = Integer.parseInt(request.getParameter("branchID"));
        HotelBranchDAO branchDAO = new HotelBranchDAO();
        HotelBranch branch = branchDAO.getHotelBranchById(branchID);

        List<String> imagePaths = null;

        String folderPath = getServletContext().getRealPath(branch.getImage_url());
        if (folderPath != null) {
            File folder = new File(folderPath);
            File[] files = folder.listFiles((dir, name) -> name.toLowerCase().matches(".*\\.(jpg|jpeg|png|gif)$"));

            if (files != null) {
                imagePaths = new ArrayList<>();
                for (File file : files) {
                    imagePaths.add("../" + branch.getImage_url() + "/" + file.getName());
                }
            }
        }

        Map<String, Object> responseData = new HashMap<>();
        responseData.put("branch", branch);
        responseData.put("images", imagePaths);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        Gson gson = new Gson();
        response.getWriter().write(gson.toJson(responseData));
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String action = request.getParameter("action");
        String branchIDString = request.getParameter("branchID");
        String staffID = request.getParameter("staffID");
        String branchName = request.getParameter("branchName");
        String branchPhone = request.getParameter("branchPhone");
        String branchEmail = request.getParameter("branchEmail");
        String branchAddress = request.getParameter("branchAddress");
        String branchImgs = request.getParameter("branchImgs");
        HotelBranchDAO branchDAO = new HotelBranchDAO();

        if (branchIDString == null && action.equals("edit")) {
            setSessionMessage(session, "BranchID is null.", "error");
            response.sendRedirect("./branch");
            return;
        }
        if (branchIDString != null && action.equals("edit")) {
            int branchID = Integer.parseInt(branchIDString);
            HotelBranch existingBranch = branchDAO.getHotelBranchByIdSimple(branchID);

            if (staffID == null || staffID.isEmpty()) {
                updateBranchInfo(request, session, branchDAO, existingBranch, branchName, branchAddress, branchPhone, branchEmail, branchImgs);
            } else {
                assignManagerAndUpdateBranch(request, session, branchDAO, existingBranch, staffID, branchName, branchAddress, branchPhone, branchEmail);
            }
        }

        if (action.equals("add")) {
            String ownerId = request.getParameter("ownerId");
            String specificAddress = request.getParameter("specificAddress");
            String address = branchAddress;
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss");
            String timestamp = LocalDateTime.now().format(formatter);
            if (specificAddress != null || !specificAddress.isEmpty()) {
                address = specificAddress + ", " + branchAddress;
            }
            if (staffID == null || staffID.isEmpty()) {
                addBranchInfo(request, session, branchDAO, branchName, address, branchPhone, branchEmail, ownerId, null, timestamp);
            } else {
                assignManagerAndAddBranch(request, session, branchDAO, staffID, address, branchAddress, branchPhone, ownerId, staffID, timestamp);
            }
        }

        if (action.equals("delete")) {
            String branchIDDeleteString = request.getParameter("IdDelete");
            if (branchIDDeleteString == null) {
                setSessionMessage(session, "BranchID is null.", "error");
                response.sendRedirect("./branch");
                return;
            }
            int branchIDDelete = Integer.parseInt(branchIDDeleteString);
            boolean deleted = branchDAO.deleteHotelBranch(branchIDDelete);
            setSessionMessage(session, deleted ? "Delete successful!" : "Cannot delete, room may be booked!",
                    deleted ? "success" : "error");
        }

        response.sendRedirect("./branch");
    }

    private void updateBranchInfo(HttpServletRequest request, HttpSession session, HotelBranchDAO dao, HotelBranch oldBranch,
            String name, String address, String phone, String email, String branchImgs) throws ServletException, IOException {
//        boolean noChange = name.equals(oldBranch.getName())
//                && address.equals(oldBranch.getAddress())
//                && phone.equals(oldBranch.getPhone())
//                && email.equals(oldBranch.getEmail()
//                && email.equals(oldBranch.getEmail());
//
//        if (noChange) {
//            setSessionMessage(session, "Nothing to update.", "error");
//            return;
//        }

        UploadMultyImage uploader = new UploadMultyImage();

        String UPLOAD_DIR = oldBranch.getImage_url();
        String pathHost = getServletContext().getRealPath("");
        String uploadPath = pathHost.replace("build\\", "") + UPLOAD_DIR;
        String uploadPath2 = pathHost + UPLOAD_DIR;

        List<String> uploadedFiles = uploader.uploadImages(request, "branchImgs", uploadPath);
        List<String> uploadedFiles2 = uploader.uploadImages(request, "branchImgs", uploadPath2);

        HotelBranch updated = new HotelBranch(oldBranch.getId(), name, address, phone, email,
                UPLOAD_DIR, oldBranch.getOwner_id(), oldBranch.getManager_id());

        boolean success = dao.updateHotelBranch(updated);
        setSessionMessage(session, success ? "Update successful!" : "Failure to update!",
                success ? "success" : "error");
    }

    private void assignManagerAndUpdateBranch(HttpServletRequest request, HttpSession session, HotelBranchDAO dao, HotelBranch oldBranch,
            String newManagerID, String name, String address, String phone, String email) throws ServletException, IOException {
        UserAccountDAO accountDAO = new UserAccountDAO();
        if (!accountDAO.updateUserRoleToManager(newManagerID)) {
            setSessionMessage(session, "Failure to update role!", "error");
            return;
        }

        UploadMultyImage uploader = new UploadMultyImage();

        String UPLOAD_DIR = oldBranch.getImage_url();
        String pathHost = getServletContext().getRealPath("");
        String uploadPath = pathHost.replace("build\\", "") + UPLOAD_DIR;
        String uploadPath2 = pathHost + UPLOAD_DIR;

        List<String> uploadedFiles = uploader.uploadImages(request, "branchImgs", uploadPath);
        List<String> uploadedFiles2 = uploader.uploadImages(request, "branchImgs", uploadPath2);

        HotelBranch updated = new HotelBranch(oldBranch.getId(), name, address, phone, email,
                UPLOAD_DIR, oldBranch.getOwner_id(), newManagerID);

        boolean success = dao.updateHotelBranch(updated);
        setSessionMessage(session, success ? "Update successful!" : "Failure to update!",
                success ? "success" : "error");
    }

    private void addBranchInfo(HttpServletRequest request, HttpSession session, HotelBranchDAO dao,
            String name, String address, String phone, String email,
            String ownerID, String managerID, String timestamp) throws ServletException, IOException {
        UploadMultyImage uploader = new UploadMultyImage();

        // Tạm thời tạo một folder tên theo thời gian để upload ảnh
        String folderName = "HotelBranch_" + timestamp;
        String UPLOAD_DIR = "/img/" + folderName;

        String pathHost = getServletContext().getRealPath("");
        String uploadPath = pathHost.replace("build\\", "") + UPLOAD_DIR;
        String uploadPath2 = pathHost + UPLOAD_DIR;

        List<String> uploadedFiles = uploader.uploadImages(request, "branchImgs", uploadPath);
        List<String> uploadedFiles2 = uploader.uploadImages(request, "branchImgs", uploadPath2);

        HotelBranch newBranch = new HotelBranch(0, name, address, phone, email,
                UPLOAD_DIR, ownerID, managerID);

        boolean success = dao.addHotelBranch(newBranch);
        setSessionMessage(session, success ? "Add branch successful!" : "Failure to add branch!",
                success ? "success" : "error");
    }

    private void assignManagerAndAddBranch(HttpServletRequest request, HttpSession session, HotelBranchDAO dao,
            String name, String address, String phone, String email,
            String ownerID, String newManagerID, String timestamp) throws ServletException, IOException {
        UserAccountDAO accountDAO = new UserAccountDAO();

        if (!accountDAO.updateUserRoleToManager(newManagerID)) {
            setSessionMessage(session, "Failure to update role!", "error");
            return;
        }

        UploadMultyImage uploader = new UploadMultyImage();

        String folderName = "HotelBranch_" + timestamp;
        String UPLOAD_DIR = "/img/" + folderName;

        String pathHost = getServletContext().getRealPath("");
        String uploadPath = pathHost.replace("build\\", "") + UPLOAD_DIR;
        String uploadPath2 = pathHost + UPLOAD_DIR;

        List<String> uploadedFiles = uploader.uploadImages(request, "branchImgs", uploadPath);
        List<String> uploadedFiles2 = uploader.uploadImages(request, "branchImgs", uploadPath2);

        HotelBranch newBranch = new HotelBranch(0, name, address, phone, email,
                UPLOAD_DIR, ownerID, newManagerID);

        boolean success = dao.addHotelBranch(newBranch);
        setSessionMessage(session, success ? "Add branch successful!" : "Failure to add branch!",
                success ? "success" : "error");
    }

    private void setSessionMessage(HttpSession session, String message, String type) {
        session.setAttribute("message", message);
        session.setAttribute("messageType", type);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
