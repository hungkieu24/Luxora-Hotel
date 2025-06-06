/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

const $ = document.querySelector.bind(document);
const $$ = document.querySelectorAll.bind(document);
window.addEventListener("DOMContentLoaded", initJsToggle);

function initJsToggle() {
    $$(".js-toggle").forEach((button) => {
        const target = button.getAttribute("toggle-target");
        if (!target) {
            document.body.innerText = `Cần thêm toggle-target cho: ${button.outerHTML}`;
        }
        button.onclick = (e) => {
            e.preventDefault();
            if (!$(target)) {
                return (document.body.innerText = `Không tìm thấy phần tử "${target}"`);
            }
            const isHidden = $(target).classList.contains("hide");

            requestAnimationFrame(() => {
                $(target).classList.toggle("hide", !isHidden);
                $(target).classList.toggle("show", isHidden);
            });
        };

        document.onclick = function (e) {
            if (!e.target.closest(target)) {
                const isHidden = $(target).classList.contains("hide");
                if (!isHidden) {
                    button.click();
                }
            }
        };

    });
}

function initButtons(className, dataAttr, fillDataCallback) {
    const buttons = document.querySelectorAll(`.${className}`);

    buttons.forEach(button => {
        button.addEventListener("click", (e) => {
            const dataValue = button.getAttribute(`${dataAttr}`);
            if (dataValue && fillDataCallback && typeof fillDataCallback === "function") {
                fillDataCallback(dataValue); // Gọi callback với giá trị từ data attribute
            } else {
                console.error(`Không tìm thấy thuộc tính ${dataAttr} hoặc fillDataCallback không hợp lệ`);
            }
        });
    });
}

// Toast message animation
document.addEventListener('DOMContentLoaded', function () {
    const toast = document.getElementById('toastMessage');
    if (toast) {
        // Show toast
        setTimeout(() => {
            toast.classList.add('show');
        }, 100);

        // Hide toast after 3 seconds
        setTimeout(() => {
            toast.classList.remove('show');
            // Remove toast from DOM after animation
            setTimeout(() => {
                toast.remove();
            }, 500);
        }, 5000);
    }
});
