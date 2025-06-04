/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.Manager;

import Dal.RoomDAO;
import Dal.RoomTypeDAO;
import Model.Room;
import Model.RoomType;
import Model.UserAccount;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;

/**
 *
 * @author thien
 */
@WebServlet(name="SearchRoomServlet", urlPatterns={"/searchRooms"})
public class SearchRoomServlet extends HttpServlet {
   

    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserAccount user = (UserAccount) session.getAttribute("user");
        if(user == null){
            request.setAttribute("error", "can you login");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
       
        RoomTypeDAO rtDao = new RoomTypeDAO();
        RoomDAO rDao = new RoomDAO();
        int branchId = rDao.getBranchId(user.getId());
        List<RoomType> roomTypes = rtDao.getAllRoomType();
        // lay phong cho bo loc
        String status = request.getParameter("status");
        String roomType = request.getParameter("roomType");
        String search = request.getParameter("search");
        
        List<Room> rooms = rDao.getRoomsByBranch(branchId, status, roomType, search);
        request.setAttribute("rooms", rooms);
        request.setAttribute("roomtypes", roomTypes);
        request.getRequestDispatcher("roomManage.jsp").forward(request, response);
    } 

   

}
