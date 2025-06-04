/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.admin;

import Dal.HotelBranchDAO;
import Dal.UserAccountDAO;
import Model.HotelBranch;
import Utility.UploadMultyImage;
import com.google.gson.Gson;
import java.io.IOException;
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

    private final UploadMultyImage uploader = new UploadMultyImage();
    private final UserAccountDAO accountDAO = new UserAccountDAO();
    private final HotelBranchDAO branchDAO = new HotelBranchDAO();

    private final String BRANCH_PAGE = "./branch";
    private final String HOTEL_BRANCH_IMAGE_FOLDER_PREFIX = "HotelBranch_";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int branchID = Integer.parseInt(request.getParameter("branchID"));
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
        String uploadParamName = "branchImgs";

        String UPLOAD_DIR = "";
        String pathHost = getServletContext().getRealPath("");
        String serverUploadPath = pathHost.replace("build\\", "");
        String buildUploadPath = pathHost;

        if (branchIDString == null && action.equals("edit")) {
            setSessionMessage(session, "BranchID is null.", "error");
            response.sendRedirect(BRANCH_PAGE);
            return;
        }
        if (branchIDString != null && action.equals("edit")) {
            int branchID = Integer.parseInt(branchIDString);
            HotelBranch existingBranch = branchDAO.getHotelBranchByIdSimple(branchID);

            if (staffID == null || staffID.trim().isEmpty()) {
                updateBranchInfo(request, session, branchDAO, existingBranch, branchName, branchAddress, branchPhone, branchEmail, uploadParamName, UPLOAD_DIR, serverUploadPath, buildUploadPath);
            } else {
                assignManagerAndUpdateBranch(request, session, branchDAO, existingBranch, staffID, branchName, branchAddress, branchPhone, branchEmail, uploadParamName, UPLOAD_DIR, serverUploadPath, buildUploadPath);
            }
        }

        if (action.equals("add")) {
            String ownerId = request.getParameter("ownerId");
            String specificAddress = request.getParameter("specificAddress");
            String address = specificAddress + ", " + branchAddress;

            if (staffID == null || staffID.isEmpty()) {
                addBranchInfo(request, session, branchDAO, branchName, address, branchPhone, branchEmail, ownerId, null, uploadParamName, UPLOAD_DIR, serverUploadPath, buildUploadPath);
            } else {
                assignManagerAndAddBranch(request, session, branchDAO, branchName, address, branchPhone, branchEmail, ownerId, staffID, uploadParamName, UPLOAD_DIR, serverUploadPath, buildUploadPath);
            }
        }

        if (action.equals("delete")) {
            String branchIDDeleteString = request.getParameter("IdDelete");
            if (branchIDDeleteString == null) {
                setSessionMessage(session, "BranchID is null.", "error");
                response.sendRedirect(BRANCH_PAGE);
                return;
            }
            int branchIDDelete = Integer.parseInt(branchIDDeleteString);
            boolean deleted = branchDAO.deleteHotelBranch(branchIDDelete);
            setSessionMessage(session, deleted ? "Delete successful!" : "Cannot delete, room may be booked!",
                    deleted ? "success" : "error");
        }

        response.sendRedirect(BRANCH_PAGE);
    }

    private void updateBranchInfo(HttpServletRequest request, HttpSession session, HotelBranchDAO dao, HotelBranch oldBranch,
            String name, String address, String phone, String email, String uploadParamName,
            String UPLOAD_DIR, String serverUploadPath, String buildUploadPath) throws ServletException, IOException {

        UPLOAD_DIR = HOTEL_BRANCH_IMAGE_FOLDER_PREFIX + oldBranch.getId();
        serverUploadPath = serverUploadPath + UPLOAD_DIR;
        buildUploadPath = buildUploadPath + UPLOAD_DIR;
        uploader.uploadImages(request, uploadParamName, serverUploadPath);
        uploader.uploadImages(request, uploadParamName, buildUploadPath);

        HotelBranch branch = new HotelBranch(oldBranch.getId(), name, address, phone, email,
                UPLOAD_DIR, oldBranch.getOwner_id(), oldBranch.getManager_id());

        boolean updated = dao.updateHotelBranch(branch);
        setSessionMessage(session, updated ? "Update successful!" : "Failure to update!",
                updated ? "success" : "error");
    }

    private void assignManagerAndUpdateBranch(HttpServletRequest request, HttpSession session, HotelBranchDAO dao, HotelBranch oldBranch,
            String newManagerID, String name, String address,
            String phone, String email, String uploadParamName,
            String UPLOAD_DIR, String serverUploadPath, String buildUploadPath) throws ServletException, IOException {
        if (!accountDAO.updateUserRoleToManager(newManagerID)) {
            setSessionMessage(session, "Failure to update role!", "error");
            return;
        }

        UPLOAD_DIR = HOTEL_BRANCH_IMAGE_FOLDER_PREFIX + oldBranch.getId();
        serverUploadPath = serverUploadPath + UPLOAD_DIR;
        buildUploadPath = buildUploadPath + UPLOAD_DIR;
        uploader.uploadImages(request, uploadParamName, serverUploadPath);
        uploader.uploadImages(request, uploadParamName, buildUploadPath);

        HotelBranch branch = new HotelBranch(oldBranch.getId(), name, address, phone, email,
                UPLOAD_DIR, oldBranch.getOwner_id(), newManagerID);

        boolean updated = dao.updateHotelBranch(branch);
        setSessionMessage(session, updated ? "Update successful!" : "Failure to update!",
                updated ? "success" : "error");
    }

    private void addBranchInfo(HttpServletRequest request, HttpSession session, HotelBranchDAO dao,
            String name, String address, String phone, String email,
            String ownerID, String managerID, String uploadParamName,
            String UPLOAD_DIR, String serverUploadPath, String buildUploadPath) throws ServletException, IOException {

        // Tạm thời tạo một folder tên theo thời gian để upload ảnh
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss");
        String timestamp = LocalDateTime.now().format(formatter);
        String folderName = HOTEL_BRANCH_IMAGE_FOLDER_PREFIX + timestamp;
        UPLOAD_DIR = "/img/" + folderName;
        serverUploadPath = serverUploadPath + UPLOAD_DIR;
        buildUploadPath = buildUploadPath + UPLOAD_DIR;
        uploader.uploadImages(request, uploadParamName, serverUploadPath);
        uploader.uploadImages(request, uploadParamName, buildUploadPath);

        HotelBranch newBranch = new HotelBranch(0, name, address, phone, email,
                UPLOAD_DIR, ownerID, managerID);

        boolean success = dao.addHotelBranch(newBranch);
        setSessionMessage(session, success ? "Add branch successful!" : "Failure to add branch!",
                success ? "success" : "error");
    }

    private void assignManagerAndAddBranch(HttpServletRequest request, HttpSession session, HotelBranchDAO dao,
            String name, String address, String phone, String email,
            String ownerID, String newManagerID, String uploadParamName,
            String UPLOAD_DIR, String serverUploadPath, String buildUploadPath) throws ServletException, IOException {
        if (!accountDAO.updateUserRoleToManager(newManagerID)) {
            setSessionMessage(session, "Failure to update role!", "error");
            return;
        }

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss");
        String timestamp = LocalDateTime.now().format(formatter);
        String folderName = HOTEL_BRANCH_IMAGE_FOLDER_PREFIX + timestamp;
        UPLOAD_DIR = "/img/" + folderName;
        serverUploadPath = serverUploadPath + UPLOAD_DIR;
        buildUploadPath = buildUploadPath + UPLOAD_DIR;
        uploader.uploadImages(request, uploadParamName, serverUploadPath);
        uploader.uploadImages(request, uploadParamName, buildUploadPath);

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
}
