/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package tool;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;

/**
 *
 * @author hungk
 */
public class UploadImage {

    public String uploadImage(HttpServletRequest request, String inputName, String uploadFolderPath)
            throws ServletException, IOException {
        // Tạo thư mục upload nếu chưa tồn tại
        File uploadDir = new File(uploadFolderPath);
        if (!uploadDir.exists()) {
            if (!uploadDir.mkdirs()) {
                throw new IOException("Không thể tạo thư mục: " + uploadFolderPath);
            }
        }

        // Lấy thông tin file từ form
        Part filePart = request.getPart(inputName);
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }

        // Lấy tên file
        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        if (fileName == null || fileName.isEmpty()) {
            return null;
        }

        // Kiểm tra loại file (chỉ chấp nhận ảnh)
        String contentType = filePart.getContentType();
        if (!contentType.startsWith("image/")) {
            return null;
        }

        // Đường dẫn lưu file
        File filePath = new File(uploadFolderPath + File.separator + fileName);
        if (filePath.exists()) {
//            String newFileName = System.currentTimeMillis() + "_" + fileName;
//            filePath = new File(uploadFolderPath + File.separator + newFileName);
//            fileName = newFileName;
            return fileName;
        }

        // Lưu file vào server
        Files.copy(filePart.getInputStream(), filePath.toPath(), StandardCopyOption.REPLACE_EXISTING);
        return fileName;
    }

}
