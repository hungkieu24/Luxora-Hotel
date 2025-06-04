/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Utility;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author hungk
 */
public class UploadMultyImage {
    public List<String> uploadImages(HttpServletRequest request, String inputName, String uploadFolderPath)
            throws ServletException, IOException {

        List<String> uploadedFileNames = new ArrayList<>();

        File uploadDir = new File(uploadFolderPath);
        if (!uploadDir.exists()) {
            if (!uploadDir.mkdirs()) {
                throw new IOException("Không thể tạo thư mục upload: " + uploadFolderPath);
            }
        }

        for (Part part : request.getParts()) {
            if (part.getName().equals(inputName)
                    && part.getSize() > 0
                    && part.getContentType() != null
                    && part.getContentType().startsWith("image/")) {

                String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();

                if (fileName != null && !fileName.isEmpty()) {
                    // Tạo tên file mới tránh trùng tên (nếu bạn muốn)
                    // String newFileName = System.currentTimeMillis() + "_" + fileName;
                    // fileName = newFileName;

                    File filePath = new File(uploadFolderPath + File.separator + fileName);
                    Files.copy(part.getInputStream(), filePath.toPath(), StandardCopyOption.REPLACE_EXISTING);
                    uploadedFileNames.add(fileName);
                }
            }
        }

        return uploadedFileNames;
    }
}
