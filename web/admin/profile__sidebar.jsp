<%-- 
    Document   : profile__sidebar
    Created on : May 30, 2025, 10:20:46 PM
    Author     : hungk
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<aside class="profile__sidebar">
    <!-- Menu 1 -->
    <div class="profile-menu">
        <a href="admin-dashboard"><h3 class="profile-menu__title admin__title">Dashboard</h3></a>
        <br>
        <ul class="profile-menu__list">
            <li>
                <a href="../admin/" class="profile-menu__link">
                    <span class="profile-menu__icon">
                        <img src="../assets/icons/download.svg" alt="" class="icon" />
                    </span>
                    Account
                </a>
            </li>
            <li>
                <a href="../admin/branch" class="profile-menu__link">
                    <span class="profile-menu__icon">
                        <img src="../assets/icons/download.svg" alt="" class="icon" />
                    </span>
                    Branch
                </a>
            </li>
            <li>
                <a href="../admin/" class="profile-menu__link">
                    <span class="profile-menu__icon">
                        <img src="../assets/icons/download.svg" alt="" class="icon" />
                    </span>
                    Feedback
                </a>
            </li>
        </ul>
    </div>

</aside>