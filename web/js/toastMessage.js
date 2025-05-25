/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


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
        }, 3000);
    }
});