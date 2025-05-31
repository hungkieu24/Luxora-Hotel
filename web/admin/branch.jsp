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
                                    <button class="btn btn--primary btn--rounded js-toggle" toggle-target="#add-product-modal">Add Branch</button>
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
                                <img 
                                    src="" 
                                    alt="Image" 
                                    name="image-manager"
                                    class="avatar-preview"
                                    id="avatar-previewView"
                                    />
                            </div>
                        </div>
                        <div class="form__group">
                            <label for="managerId" class="form__label form-card__label">Choose another staff to become manager</label>
                            <div class="form__text-input">
                                <select class="form__select " 
                                        style="width: 100%"
                                        id="chooseAnotherManager" 
                                        name="staffID">
                                    <option value="" selected>Choose Staff</option>
                                    <c:forEach items="${staffList}" var="s">
                                        <option 
                                            value="${s.getId()}" 
                                            data-username="${s.getUsername()}" 
                                            data-email="${s.getEmail()}" 
                                            data-phone="${s.getPhonenumber()}">
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
                            <div class="wrapper" id="imagePreviewWrapper">
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
        <div id="add-modal" class="modal hide">
            <div class="modal__content">
                <div class="modal__heading">Add Branch</div>
                <form action="edit-product" method="post" enctype="multipart/form-data" id="add-product-form" class="form form-card">
                    <input type="hidden" name="action" value="add">
                    <!-- Form row 1 -->
                    <div class="form__row">
                        <div class="form__group">
                            <div class="form__avatar-preview">
                                <img 
                                    src="" 
                                    alt="Current Product" 
                                    name="product-previewAdd"
                                    class="avatar-preview"
                                    id="avatar-previewAdd"
                                    />
                            </div>
                        </div>
                        <div class="form__group">
                            <label class="form__label form-card__label">
                                Product Image
                            </label>
                            <div class="form__text-input">
                                <input
                                    type="file"
                                    name="productImageAdd"
                                    id="productImageAdd"
                                    class="form__input avatar-input"
                                    accept=".jpg,.jpeg,.png"
                                    required
                                    />
                            </div>
                        </div>
                    </div>

                    <!-- Form row 2 -->
                    <div class="form__row">
                        <div class="form__group">
                            <label for="productNameAdd" class="form__label form-card__label">Product Name</label>
                            <div class="form__text-input">
                                <input type="text" name="productNameAdd" id="productNameAdd" class="form__input" placeholder="Product Name"/>
                            </div>
                            <p class="form__error"></p>
                        </div>
                        <div class="form__group">
                            <label for="quantityAdd" class="form__label form-card__label">Quantity Per Unit</label>
                            <div class="form__text-input">
                                <input type="text" name="quantityAdd" id="quantityAdd" class="form__input" placeholder="Quantity Per Unit" />
                            </div>
                            <p class="form__error"></p>
                        </div>
                    </div>

                    <div class="form__row">
                        <div class="form__group">
                            <label for="productDescriptionAdd" class="form__label form-card__label">Product Description</label>
                            <div class="form__text-area">
                                <textarea
                                    name="productDescriptionAdd"
                                    id="productDescriptionAdd"
                                    placeholder="Product Description"
                                    class="form__text-area-input"
                                    required
                                    ></textarea>
                            </div>
                            <p class="form__error"></p>
                        </div>
                    </div>

                    <!-- Form row 3 -->
                    <div class="form__row">
                        <div class="form__group">
                            <label for="unitPriceAdd" class="form__label form-card__label">Unit Price</label>
                            <div class="form__text-input">
                                <input type="text" name="unitPriceAdd" id="unitPriceAdd" class="form__input" placeholder="Unit Price"/>
                            </div>
                            <p class="form__error"></p>
                        </div>
                        <div class="form__group">
                            <label for="unitsInStockAdd" class="form__label form-card__label">
                                Units In Stock
                            </label>
                            <div class="form__text-input">
                                <input type="text" name="unitsInStockAdd" id="unitsInStockAdd" placeholder="Units In Stock" class="form__input"/>
                            </div>
                            <p class="form__error"></p>
                        </div>
                    </div>

                    <div class="form__row">
                        <div class="form__group">
                            <label for="discountAdd" class="form__label form-card__label">
                                Discount
                            </label>
                            <div class="form__text-input">
                                <input type="text" name="discountAdd" placeholder="Discount" id="discountAdd" class="form__input"/>
                            </div>
                            <p class="form__error"></p>
                        </div>
                        <div class="form__group">
                            <label for="ratingAdd" class="form__label form-card__label">
                                Rating
                            </label>
                            <div class="form__text-input">
                                <input type="text" name="ratingAdd" placeholder="Rating" id="ratingAdd" class="form__input"/>
                            </div>
                            <p class="form__error"></p>
                        </div>
                    </div>

                    <!-- Form row 4 -->
                    <div class="form__row">
                        <div class="form__group">
                            <label for="chooseSupplierAdd" class="form__label form-card__label">Choose Supplier</label>
                            <div class="form__text-input">
                                <select required style="width: 100%" class="form__select chooseSupplierAdd" id="chooseSupplierAdd" name="chooseSupplierAdd">
                                    <option value="">Choose Supplier</option>
                                    <c:forEach items="${listSupply}" var="s">
                                        <option value="${s.getSupplierID()}">${s.getSupplierName()}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                        <div class="form__group">
                            <label for="chooseCategoryAdd" class="form__label form-card__label">Choose Category</label>
                            <div class="form__text-input">
                                <select required style="width: 100%" class="form__select chooseCategoryAdd" id="chooseCategoryAdd" name="chooseCategoryAdd">
                                    <option value="">Choose Category</option>
                                    <c:forEach items="${listCategory}" var="s">
                                        <option value="${s.getCategoryID()}">${s.getCategoryName()}</option>
                                    </c:forEach>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="form-card__bottom">
                        <a href="../admin/manage-product" class="btn btn--text">Cancel</a>
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
                    <form action="branchEventHandler" method="post">
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

                // Gán vào các input
                document.getElementById("userName").value = username;
                document.getElementById("Email").value = email;
                document.getElementById("phone").value = phone;
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
                        .then(actor => {
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
                form: '#add-product-form',
                formGroupSelector: '.form__group',
                errorSelector: '.form__error',
                rules: [
                    Validator.isRequired('#branchNamew', 'Please enter the full name of the branch'),
                    Validator.maxLength('#productNameAdd', 30),
                    Validator.isRequired('#quantityAdd', 'Please enter the quantity per unit'),
                    Validator.isRequired('#productDescriptionAdd', 'Please enter the product description'),
                    Validator.isRequired('#unitPriceAdd', 'Please enter the product price'),
                    Validator.isRequired('#unitsInStockAdd', 'Please enter the quantity of the product'),
                    Validator.isRequired('#discountAdd', 'Please enter the discount percentage'),
                    Validator.isNumber('#ratingAdd'),
                ],
                onsubmit: function (formValue) {
                    document.querySelector('#add-product-form').submit();
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