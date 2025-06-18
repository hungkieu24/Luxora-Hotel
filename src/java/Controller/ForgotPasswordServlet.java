/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import Dal.UserAccountDAO;
import Utility.EmailUtilityVerifyCode;
import java.util.Random;
import jakarta.mail.*;


/**
 *
 * @author thien
 */
@WebServlet(name="ForgotPasswordServlet", urlPatterns={"/forgotPassword"})
public class ForgotPasswordServlet extends HttpServlet {
   
   @Override
   protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
       String email = request.getParameter("email");
       HttpSession session = request.getSession();
       UserAccountDAO uDao = new  UserAccountDAO();
       if(!uDao.isEmailExist(email)){
           request.setAttribute("error", "Email not found");
           request.getRequestDispatcher("forgotPassword.jsp").forward(request, response);
           return;
       }
       //Tao code 6 ky tu
       String code = String.format("%06d", new Random().nextInt(999999));
       long expiryTime = System.currentTimeMillis() + 1 * 60 * 1000;// 1 phut ke tu luc send
       
       // luu thong tin vao session
       session.setAttribute("resetCode", code);
       session.setAttribute("resetEmail", email);
       session.setAttribute("resetExpiry", expiryTime);
       // Gửi Email
       try{
           EmailUtilityVerifyCode.sendEmail(email, "Reset your password", code);
           request.setAttribute("email", email);
           request.getRequestDispatcher("verifyCode.jsp").forward(request, response);
       }catch(Exception e){
           e.printStackTrace();
           request.setAttribute("error", "Unable to send email");
           request.getRequestDispatcher("forgotPassword.jsp").forward(request, response);
       }
   }

}
