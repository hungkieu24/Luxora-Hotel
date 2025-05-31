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
        <h3 class="profile-menu__title admin__title">Manage Account</h3>
        <ul class="profile-menu__list">
            <li>
                <a href="../admin/admin-account" class="profile-menu__link">
                    <span class="profile-menu__icon">
                        <img src="../assets/icons/brain.svg" alt="" class="icon" />
                    </span>
                    Admin
                </a>
            </li>
            <li>
                <a href="../admin/customer-account" class="profile-menu__link">
                    <span class="profile-menu__icon">
                        <img src="../assets/icons/lock.svg" alt="" class="icon" />
                    </span>
                    Customer
                </a>
            </li>
            
        </ul>
    </div>

    <!-- Menu 2 -->
    <div class="profile-menu">
        <h3 class="profile-menu__title admin__title">Manage Product</h3>
        <ul class="profile-menu__list">
            <li>
                <a href="../admin/manage-product" class="profile-menu__link">
                    <span class="profile-menu__icon">
                        <img src="../assets/icons/download.svg" alt="" class="icon" />
                    </span>
                    Product
                </a>
            </li>
            <li>
                <a href="../admin/manage-supplier" class="profile-menu__link">
                    <span class="profile-menu__icon">
                        <img src="../assets/icons/supply.svg" alt="" class="icon" />
                    </span>
                    Supplier
                </a>
            </li>
            <li>
                <a href="../admin/manage-category" class="profile-menu__link">
                    <span class="profile-menu__icon">
                        <img src="../assets/icons/gift-2.svg" alt="" class="icon" />
                    </span>
                    Category
                </a>
            </li>
        </ul>
    </div>

    <!-- Menu 3 -->
    <div class="profile-menu">
        <h3 class="profile-menu__title">Customer</h3>
        <ul class="profile-menu__list">
            <li>
                <a href="../admin/manage-order" class="profile-menu__link">
                    <span class="profile-menu__icon">
                        <img src="../assets/icons/shield.svg" alt="" class="icon" />
                    </span>
                    Order
                </a>
            </li>
<!--            <li>
                <a href="../admin/manage-wallet" class="profile-menu__link">
                    <span class="profile-menu__icon">
                        <img src="../assets/icons/wallet.svg" alt="" class="icon" />
                    </span>
                    Wallet
                </a>
            </li>-->
            <li>
                <a href="../admin/manage-transaction" class="profile-menu__link">
                    <span class="profile-menu__icon">
                        <img src="../assets/icons/wallet.svg" alt="" class="icon" />
                    </span>
                    Transaction
                </a>
            </li>
        </ul>
    </div>

</aside>