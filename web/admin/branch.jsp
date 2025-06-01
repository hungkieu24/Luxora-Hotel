<%-- 
    Document   : branch
    Created on : May 30, 2025, 10:16:46 PM
    Author     : hungk
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Branch</title>

        <!-- Styles -->
        <link rel="stylesheet" href="../css/hungkd.css" />
        <link rel="stylesheet" href="../css/custom.css" />


    </head>
    <body>
        <c:if test="${not empty sessionScope.message}">
            <div id="toastMessage" class="toast-message ${sessionScope.messageType}">
                <c:choose>
                    <c:when test="${sessionScope.messageType == 'success'}">
                        <i class="fa fa-check-circle"></i>
                    </c:when>
                    <c:when test="${sessionScope.messageType == 'error'}">
                        <i class="fa fa-times-circle"></i>
                    </c:when>
                </c:choose>
                ${sessionScope.message}
            </div>

            <!-- Xóa message sau khi hiển thị -->
            <c:remove var="message" scope="session" />
            <c:remove var="messageType" scope="session" />
        </c:if>

        <!-- Main -->
        <!-- profile detail -->
        <main class="profile">
            <div class="container">

                <!-- Profile content -->
                <div class="profile-container">

                    <div class="row gy-md-3">
                        <div class="col-2 col-xl-4 col-lg-5 col-md-12">
                            <%@ include file="./profile__sidebar.jsp"%>
                        </div>
                        <div class="col-10 col-xl-8 col-lg-7 col-md-12">

                            <div class="cart-info">
                                <div class="admin__flex">
                                    <form action="" class="admin__search-bar">
                                        <div class="search-bar d-flex">
                                            <input type="hidden" name="action" value="search">
                                            <input type="text" name="searchKeyword" value="${param.searchKeyword}" placeholder="Search Branch" class="search-bar__input" />
                                            <button type="submit" class="search-bar__submit">
                                                <img src="../img/svg_icons/search.svg" alt="" class="search-bar__icon icon" />
                                            </button>
                                        </div>
                                    </form>
                                    <button class="btn btn--primary btn--rounded js-toggle" toggle-target="#add-modal">Add Branch</button>
                                </div>

                                <div class="row gy-3">
                                    <!-- Admin Dashboard -->
                                    <div class="col-12">
                                        <h2 class="cart-info__heading admin__heading">Branchs</h2>
                                        <p class="cart-info__desc profile__desc">Quantity: ${brancheListSize}</p>
                                        <p class="cart-info__desc profile__desc">Hotel Owner: ${owner.getUsername()} </p>

                                        <table class="admin__table" border="1">

                                            <thead>
                                                <tr>
                                                    <th >ID</th>                    
                                                    <th >Name</th>
                                                    <th >Address</th>
                                                    <th >Phone</th>
                                                    <th >Email</th>
                                                    <th >Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${brancheList}" var="b">
                                                    <tr>
                                                        <td>${b.getId()}</td>                        
                                                        <td>${b.getName()}</td>
                                                        <td>${b.getAddress()}</td>
                                                        <td>${b.getPhone()}</td>
                                                        <td>${b.getEmail()}</td>
                                                        <td > 
                                                            <div style="display: flex; justify-content: space-around">
                                                                <div class="admin__icon-wrap edit js-toggle" 
                                                                     toggle-target="#edit-modal" 
                                                                     data-actor-id="${b.getId()}">
                                                                    <div class="admin__icon">
                                                                        <img class="icon" src="../img/svg_icons/edit.svg" alt="" />
                                                                    </div>
                                                                </div>
                                                                <div class="admin__icon-wrap delete js-toggle" 
                                                                     toggle-target="#delete-modal" 
                                                                     data-actor-id="${b.getId()}">
                                                                    <div class="admin__icon">
                                                                        <img class="icon" src="../img/svg_icons/trash.svg" alt="" />
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>

                                <div class="pagination">
                                    <c:if test="${currentPage > 1}">
                                        <a href="?page=${currentPage - 1}&action=${action}&searchKeyword=${keyword}"  class="prev"> Previous</a>
                                    </c:if>

                                    <c:forEach var="i" begin="1" end="${totalPages}">
                                        <a href="?page=${i}&action=${action}&searchKeyword=${keyword}" class="${i == currentPage ? 'active' : ''}">${i}</a>
                                    </c:forEach>

                                    <c:if test="${currentPage < totalPages}">
                                        <a href="?page=${currentPage + 1}&action=${action}&searchKeyword=${keyword}" class="next">Next</a>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <!-- Footer -->
        <!-- Modal: Edit Product -->
        <div id="edit-modal" class="modal modal--bigest hide">
            <div class="modal__content">
                <div class="modal__heading">Edit Branch</div>
                <h3 style="font-size: 1.8rem; font-weight: 700; margin: 10px 0">Manager</h3>
                <form action="branchEventHandler" method="post" enctype="multipart/form-data" id="edit-form" class="form form-card">
                    <input type="hidden" name="branchID" id="branchID">
                    <input type="hidden" name="action" value="edit">
                    <!-- Form row 1 -->
                    <div class="form__row">
                        <div class="form__group">
                            <label for="" class="form__label form-card__label">Avatar</label>
                            <div class="form__avatar-preview">
                                <img src="" alt="Image" name="image-manager" class="avatar-preview" id="avatar-previewView"/>
                            </div>
                        </div>
                        <div class="form__group">
                            <label for="managerId" class="form__label form-card__label">Choose another staff to become manager</label>
                            <div class="form__text-input">
                                <select class="form__select " style="width: 100%" id="chooseAnotherManager" name="staffID">
                                    <option value="" selected>Choose Staff</option>
                                    <c:forEach items="${staffList}" var="s">
                                        <option 
                                            value="${s.getId()}" 
                                            data-username="${s.getUsername()}" 
                                            data-email="${s.getEmail()}" 
                                            data-phone="${s.getPhonenumber()}"
                                            data-imageUrl="${s.getAvatar_url()}">
                                            Id: ${s.getId()}, Role: ${s.getRole()}, userName: ${s.getUsername()}
                                        </option>
                                    </c:forEach>
                                </select>

                            </div>
                        </div>
                    </div>

                    <!-- Form row 2 -->
                    <div class="form__row">
                        <div class="form__group">
                            <label for="userName" class="form__label form-card__label">User Name</label>
                            <div class="form__text-input">
                                <input type="text" name="userName" id="userName" class="form__input" placeholder="User Name" readonly/>
                            </div>
                            <p class="form__error"></p>
                        </div>
                        <div class="form__group">
                            <label for="Email" class="form__label form-card__label">Email</label>
                            <div class="form__text-input">
                                <input type="email" name="Email" id="Email" class="form__input" placeholder="Email" readonly/>
                            </div>
                            <p class="form__error"></p>
                        </div>
                        <div class="form__group">
                            <label for="phone" class="form__label form-card__label">Phone</label>
                            <div class="form__text-input">
                                <input type="text" name="phone" id="phone" class="form__input" placeholder="Phone" readonly/>
                            </div>
                            <p class="form__error"></p>
                        </div>
                    </div>

                    <div class="cart-info__separate"></div>

                    <h3 style="font-size: 1.8rem; font-weight: 700; margin: 10px 0">Branch</h3>
                    <!-- Form row 3 -->
                    <div class="form__row">
                        <div class="form__group">
                            <label for="branchName" class="form__label form-card__label">Name</label>
                            <div class="form__text-input">
                                <input type="text" name="branchName" id="branchName" class="form__input" placeholder="Branch Name"/>
                            </div>
                            <p class="form__error"></p>
                        </div>
                        <div class="form__group">
                            <label for="branchPhone" class="form__label form-card__label">Phone</label>
                            <div class="form__text-input">
                                <input type="text" name="branchPhone" id="branchPhone" placeholder="Branch Phone" class="form__input"/>
                            </div>
                            <p class="form__error"></p>
                        </div>
                        <div class="form__group">
                            <label for="branchEmail" class="form__label form-card__label">Email</label>
                            <div class="form__text-input">
                                <input type="email" name="branchEmail" id="branchEmail" placeholder="Branch Email" class="form__input"/>
                            </div>
                            <p class="form__error"></p>
                        </div>
                    </div>

                    <!-- Form row 4 -->
                    <div class="form__row">
                        <div class="form__group">
                            <label for="address" class="form__label form-card__label">
                                Address
                            </label>
                            <div class="form__text-input">
                                <input type="text" name="branchAddress" id="branchAddress" class="form__input address" placeholder="Address" value=""/>
                                <img
                                    src="../img/svg_icons/edit.svg"
                                    alt=""
                                    class="icon form__input-icon js-toggle" 
                                    toggle-target="#addressEdit"
                                    />
                            </div>

                            <p class="form__error"></p>
                        </div>
                    </div>

                    <!-- Form row 5 -->
                    <div class="form__row hide" id="addressEdit">
                        <div class="form__group ">
                            <label for="provinceInput" class="form__label form-card__label">Province</label>
                            <div class="form__text-input">
                                <select class="form__select province address__select" id="province" name="province">
                                    <option value="">Choose province</option>
                                </select>
                            </div>
                        </div>

                        <div class="form__group ">
                            <label for="districtInput" class="form__label form-card__label">District</label>
                            <div class="form__text-input">
                                <select class="form__select district address__select" id="district" name="district">
                                    <option value="">Choose district</option>
                                </select>
                            </div>
                        </div>

                        <div class="form__group">
                            <label for="wardInput" class="form__label form-card__label">Ward</label>
                            <div class="form__text-input">
                                <select class="form__select ward address__select" id="ward" name="ward">
                                    <option value="">Choose ward</option>
                                </select>
                            </div>
                        </div>

                        <div class="form__group">
                            <label for="specificAddress" class="form__label form-card__label">
                                Specific address
                            </label>
                            <div class="form__text-input">
                                <input
                                    type="text"
                                    name="specificAddress"
                                    id="specificAddress"
                                    class="form__input"
                                    placeholder="Specific address"
                                    value=""
                                    />
                            </div>

                            <p class="form__error"></p>
                        </div>
                    </div>

                    <!-- Form row 6 -->
                    <div class="form__row">
                        <div class="form__group">
                            <label for="branchName" class="form__label form-card__label">Image</label>
                            <div class="wrapper-images" id="imagePreviewWrapper">
                                <div class="images">
                                    <img class="images_img" src="" alt="">
                                </div>
                            </div>

                            <p class="form__error"></p>
                        </div>
                        <div class="form__group">
                            <label for="imageInput" class="form__label form-card__label">Choose Another Image</label>
                            <div class="form__text-input">
                                <input type="file" name="branchImgs" id="imageInput" multiple accept="image/*">
                            </div>
                            <p class="form__error"></p>
                        </div>
                    </div>

                    <div class="form-card__bottom">
                        <a href="../admin/branch" class="btn btn--text">Cancel</a>
                        <button type="submit" class="btn btn--primary btn--rounded">Change</button>
                    </div>
                </form>
            </div>
            <div class="modal__overlay js-toggle" toggle-target="#edit-modal"></div>
        </div>
        <div class="gallery">
            <i class="close">X</i>
            <div class="gallery_inner">
                <img src="" alt="">
            </div>
            <div class="control_prev"> <= </div>
            <div class="control_after"> => </div>
        </div>

        <!-- Modal: Add modal -->
        <div id="add-modal" class="modal modal--bigest hide">
            <div class="modal__content">
                <div class="modal__heading">Add Branch</div>
                <h3 style="font-size: 1.8rem; font-weight: 700; margin: 10px 0">Manager</h3>
                <form action="branchEventHandler" method="post" enctype="multipart/form-data" id="add-form" class="form form-card">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="ownerId" value="${owner.getId()}">
                    <!-- Form row 1: Manager -->
                    <div class="form__row">
                        <div class="form__group">
                            <label for="" class="form__label form-card__label">Avatar</label>
                            <div class="form__avatar-preview">
                                <img 
                                    src="" 
                                    alt="Image" 
                                    name="image-manager"
                                    class="avatar-preview"
                                    id="avatar-previewView-add"
                                    />
                            </div>
                        </div>
                        <div class="form__group">
                            <label for="chooseManager" class="form__label form-card__label">Choose staff to become manager</label>
                            <div class="form__text-input">
                                <select class="form__select" style="width: 100%" id="chooseManager" name="staffID">
                                    <option value="" selected>Choose Staff</option>
                                    <c:forEach items="${staffList}" var="s">
                                        <option 
                                            value="${s.getId()}" 
                                            data-username="${s.getUsername()}" 
                                            data-email="${s.getEmail()}" 
                                            data-phone="${s.getPhonenumber()}"
                                            data-imageUrl="${s.getAvatar_url()}">
                                            Id: ${s.getId()}, Role: ${s.getRole()}, Username: ${s.getUsername()}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Manager info auto-fill -->
                    <div class="form__row">
                        <div class="form__group">
                            <label class="form__label form-card__label">User Name</label>
                            <div class="form__text-input">
                                <input type="text" name="userName" id="userName-add" class="form__input" placeholder="User Name" readonly/>
                            </div>
                        </div>
                        <div class="form__group">
                            <label class="form__label form-card__label">Email</label>
                            <div class="form__text-input">
                                <input type="email" name="Email" id="Email-add" class="form__input" placeholder="Email" readonly/>
                            </div>
                        </div>
                        <div class="form__group">
                            <label class="form__label form-card__label">Phone</label>
                            <div class="form__text-input">
                                <input type="text" name="phone" id="phone-add" class="form__input" placeholder="Phone" readonly/>
                            </div>
                        </div>
                    </div>

                    <div class="cart-info__separate"></div>

                    <h3 style="font-size: 1.8rem; font-weight: 700; margin: 10px 0">Branch</h3>

                    <!-- Branch Info -->
                    <div class="form__row">
                        <div class="form__group">
                            <label class="form__label form-card__label">Branch Name</label>
                            <div class="form__text-input">
                                <input type="text" name="branchName" id="branchName-add" class="form__input" placeholder="Branch Name"/>
                            </div>
                            <p class="form__error"></p>
                        </div>
                        <div class="form__group">
                            <label class="form__label form-card__label">Phone</label>
                            <div class="form__text-input">
                                <input type="text" name="branchPhone" id="branchPhone-add" class="form__input" placeholder="Branch Phone"/>
                            </div>
                            <p class="form__error"></p>
                        </div>
                        <div class="form__group">
                            <label class="form__label form-card__label">Email</label>
                            <div class="form__text-input">
                                <input type="email" name="branchEmail" id="branchEmail-add" class="form__input" placeholder="Branch Email"/>
                            </div>
                            <p class="form__error"></p>
                        </div>
                    </div>

                    <!-- Address -->
                    <div class="form__row" id="addressAdd">
                        <div class="form__group">
                            <label class="form__label form-card__label">Province</label>
                            <div class="form__text-input">
                                <select class="form__select province address__select" id="province-add" name="province">
                                    <option value="">Choose province</option>
                                </select>
                            </div>
                        </div>

                        <div class="form__group">
                            <label class="form__label form-card__label">District</label>
                            <div class="form__text-input">
                                <select class="form__select district address__select" id="district-add" name="district">
                                    <option value="">Choose district</option>
                                </select>
                            </div>
                        </div>

                        <div class="form__group">
                            <label class="form__label form-card__label">Ward</label>
                            <div class="form__text-input">
                                <select class="form__select ward address__select" id="ward-add" name="ward">
                                    <option value="">Choose ward</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="form__row">
                        <div class="form__group">
                            <label class="form__label form-card__label">Address</label>
                            <div class="form__text-input">
                                <input type="text" name="branchAddress" id="branchAddress-add" class="form__input address" placeholder="Address"/>
                            </div>
                            <p class="form__error"></p>
                        </div>
                    </div>
                    <div class="form__row">
                        <div class="form__group">
                            <label class="form__label form-card__label">Specific Address</label>
                            <div class="form__text-input">
                                <input type="text" name="specificAddress" id="specificAddress-add" class="form__input" placeholder="Specific address"/>
                            </div>
                            <p class="form__error"></p>
                        </div>
                    </div>


                    <!-- Images -->
                    <div class="form__row">
                        <div class="form__group">
                            <label class="form__label form-card__label">Image Preview</label>
                            <div class="wrapper-images" id="imagePreviewWrapper-add">
                                <div class="images">
                                    <img class="images_img" src="" alt="">
                                </div>
                            </div>
                        </div>
                        <div class="form__group">
                            <label class="form__label form-card__label">Choose Image</label>
                            <div class="form__text-input">
                                <input type="file" name="branchImgs" id="imageInput-add" multiple accept="image/*">
                            </div>
                        </div>
                    </div>

                    <div class="form-card__bottom">
                        <a href="../admin/branch" class="btn btn--text">Cancel</a>
                        <button type="submit" class="btn btn--primary btn--rounded">Add</button>
                    </div>
                </form>
            </div>
            <div class="modal__overlay js-toggle" toggle-target="#add-modal"></div>
        </div>


        <!-- Modal delete -->
        <div id="delete-modal" class="modal modal--small hide">
            <div class="modal__content">

                <div class="modal__text">Do you want to delete this?</div>
                <div class="modal__bottom">
                    <button
                        class="btn btn--small btn--text modal__btn btn--no-margin js-toggle"
                        toggle-target="#delete-modal"
                        >
                        Cancel
                    </button>
                    <form action="branchEventHandler" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="IdDelete" id="IdDelete" value="">
                        <input type="hidden" name="action" value="delete">
                        <button
                            type="submit"
                            class="btn btn--small btn--danger btn--primary modal__btn btn--no-margin"
                            >
                            Delete
                        </button>
                    </form>
                </div>
            </div>
            <div class="modal__overlay js-toggle" toggle-target="#delete-modal"></div>
        </div>

        <!-- Scripts -->
        <script src="../js/hungkd.js"></script>
        <script src="../js/api.js"></script>
        <script src="../js/toastMessage.js"></script>
        <script src="../js/validationForm.js"></script>
        <script src="../js/imageGallery.js"></script>

        <script>
            // Gọi hàm với class
            createLocationSelectorByClass({
                provinceClass: 'province',
                districtClass: 'district',
                wardClass: 'ward',
                addressClass: 'address'
            });

            document.getElementById("chooseAnotherManager").addEventListener("change", function () {
                const selectedOption = this.options[this.selectedIndex];

                // Lấy dữ liệu từ option được chọn
                const username = selectedOption.getAttribute("data-username") ?? "need to set";
                const email = selectedOption.getAttribute("data-email") ?? "need to set";
                const phone = selectedOption.getAttribute("data-phone") ?? "need to set";
                const imageUrl = selectedOption.getAttribute("data-imageUrl") ?? "need to set";
                // Gán vào các input
                document.getElementById("userName").value = username;
                document.getElementById("Email").value = email;
                document.getElementById("phone").value = phone;
                document.getElementById("avatar-previewView").src = imageUrl;
            });
            document.getElementById("chooseManager").addEventListener("change", function () {
                const selectedOption = this.options[this.selectedIndex];

                // Lấy dữ liệu từ option được chọn
                const username = selectedOption.getAttribute("data-username") ?? "need to set";
                const email = selectedOption.getAttribute("data-email") ?? "need to set";
                const phone = selectedOption.getAttribute("data-phone") ?? "need to set";
                const imageUrl = selectedOption.getAttribute("data-imageUrl") ?? "need to set";
                // Gán vào các input
                document.getElementById("userName-add").value = username;
                document.getElementById("Email-add").value = email;
                document.getElementById("phone-add").value = phone;
                document.getElementById("avatar-previewView-add").src = imageUrl;
            });
        </script>


        <!--Js điền dữ liệu vào Edit admin modal -->
        <script>
            function fillModalEdit(branchID) {
                fetch("/ParadiseHotel/admin/branchEventHandler?branchID=" + branchID)
                        .then(res => res.json())
                        .then(data => {
                            const actor = data.branch;
                            const images = data.images;

                            if (!actor)
                                return;

                            document.getElementById("avatar-previewView").src = "../img/avatar/avatar4.jpg";
                            document.getElementById("userName").value = actor?.manager?.username ?? "";
                            document.getElementById("Email").value = actor?.manager?.email ?? "";
                            document.getElementById("phone").value = actor?.manager?.phonenumber ?? "";
                            document.getElementById("branchID").value = actor.id;
                            document.getElementById("branchName").value = actor.name;
                            document.getElementById("branchPhone").value = actor.phone;
                            document.getElementById("branchEmail").value = actor.email;
                            document.getElementById("branchAddress").value = actor.address;

                            // Hiển thị danh sách ảnh
                            const wrapper = document.getElementById("imagePreviewWrapper");
                            wrapper.innerHTML = ""; // Xóa ảnh cũ
                            images.forEach(path => {
                                const div = document.createElement("div");
                                div.className = "images";

                                const img = document.createElement("img");
                                img.className = "images_img";
                                img.src = path;
                                img.alt = "";

                                div.appendChild(img);
                                wrapper.appendChild(div);
                            });
                            applyImageTransforms();
                            updateImagesAndEvents();
                        })
                        .catch(err => console.error("Lỗi fetch:", err));
            }

            function fillModalDelete(branchID) {
                console.log("branchID: ", branchID);
                fetch("/ParadiseHotel/admin/branchEventHandler?branchID=" + branchID)
                        .then(res => res.json())
                        .then(data => {
                            const actor = data.branch;
                            const images = data.images;

                            if (!actor)
                                return;

                            document.getElementById("IdDelete").value = branchID;
                        })
                        .catch(err => console.error("Lỗi fetch:", err));
            }
            initButtons("edit.js-toggle", "data-actor-id", fillModalEdit);
            initButtons("delete.js-toggle", "data-actor-id", fillModalDelete);

        </script>
        <script>
            Validator({
                form: '#add-form',
                formGroupSelector: '.form__group',
                errorSelector: '.form__error',
                rules: [
                    Validator.isRequired('#branchName-add', 'Please enter the full name of the branch'),
                    Validator.maxLength('#branchPhone-add', 10),
                    Validator.isPhoneNumber('#branchPhone-add', 'Please enter branch phone number'),
                    Validator.isRequired('#branchEmail-add', 'Please enter branch email'),
                    Validator.isEmail('#branchEmail-add', 'This field must be an email'),
                    Validator.isRequired('#branchAddress-add', 'Please enter the branch address'),
                ],
                onsubmit: function (formValue) {
                    document.querySelector('#add-form').submit();
                }
            })

            Validator({
                form: '#edit-form',
                formGroupSelector: '.form__group',
                errorSelector: '.form__error',
                rules: [
                    Validator.isRequired('#branchName', 'Please enter the full name of the branch'),
                    Validator.maxLength('#branchPhone', 10),
                    Validator.isPhoneNumber('#branchPhone', 'Please enter branch phone number'),
                    Validator.isRequired('#branchEmail', 'Please enter branch email'),
                    Validator.isEmail('#branchEmail', 'This field must be an email'),
                    Validator.isRequired('#branchAddress', 'Please enter the branch address'),
                ],
                onsubmit: function (formValue) {
                    document.querySelector('#edit-form').submit();
                }
            })
        </script>

    </body>
</html>