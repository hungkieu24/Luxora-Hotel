<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Branch Reports - HotelBooki</title>
    <link rel="stylesheet" href="css/branch-reports.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>

/* Global Styles */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
    color: #333;
}

.container {
    max-width: 1400px;
    margin: 0 auto;
    padding: 20px;
}

/* Header Styles */
.header {
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(10px);
    border-radius: 15px;
    margin-bottom: 30px;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

.header-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px 30px;
}

.header h1 {
    color: #2c3e50;
    font-size: 2.2em;
    font-weight: 600;
}

.header h1 i {
    color: #3498db;
    margin-right: 10px;
}

.user-info {
    display: flex;
    align-items: center;
    gap: 15px;
}

.user-info span {
    color: #7f8c8d;
    font-weight: 500;
}

.logout-btn {
    background: #e74c3c;
    color: white;
    padding: 8px 16px;
    border-radius: 8px;
    text-decoration: none;
    transition: all 0.3s ease;
    font-weight: 500;
}

.logout-btn:hover {
    background: #c0392b;
    transform: translateY(-2px);
}

/* Filter Section */
.filter-section {
    margin-bottom: 30px;
}

.filter-card {
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(10px);
    border-radius: 15px;
    padding: 25px;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

.filter-card h3 {
    color: #2c3e50;
    margin-bottom: 20px;
    font-size: 1.3em;
}

.filter-card h3 i {
    color: #9b59b6;
    margin-right: 8px;
}

.filter-form {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 20px;
    align-items: end;
}

.form-group {
    display: flex;
    flex-direction: column;
}

.form-group label {
    color: #34495e;
    font-weight: 500;
    margin-bottom: 5px;
}

.form-group input,
.form-group select {
    padding: 10px 15px;
    border: 2px solid #ecf0f1;
    border-radius: 8px;
    font-size: 14px;
    transition: border-color 0.3s ease;
    background: white;
}

.form-group input:focus,
.form-group select:focus {
    outline: none;
    border-color: #3498db;
}

.filter-btn {
    background: linear-gradient(135deg, #3498db, #2980b9);
    color: white;
    padding: 12px 24px;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    font-weight: 500;
    transition: all 0.3s ease;
}

.filter-btn:hover {
    background: linear-gradient(135deg, #2980b9, #1abc9c);
    transform: translateY(-2px);
    box-shadow: 0 4px 15px rgba(52, 152, 219, 0.3);
}

/* Summary Cards */
.summary-section {
    margin-bottom: 30px;
}

.summary-cards {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 20px;
}

.summary-card {
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(10px);
    border-radius: 15px;
    padding: 25px;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
    display: flex;
    align-items: center;
    gap: 20px;
    transition: transform 0.3s ease;
}

.summary-card:hover {
    transform: translateY(-5px);
}

.card-icon {
    width: 60px;
    height: 60px;
    border-radius: 15px;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 24px;
    color: white;
}

.summary-card.revenue .card-icon {
    background: linear-gradient(135deg, #27ae60, #2ecc71);
}

.summary-card.bookings .card-icon {
    background: linear-gradient(135deg, #3498db, #2980b9);
}

.summary-card.occupancy .card-icon {
    background: linear-gradient(135deg, #e67e22, #f39c12);
}

.summary-card.rooms .card-icon {
    background: linear-gradient(135deg, #9b59b6, #8e44ad);
}

.card-content h3 {
    color: #7f8c8d;
    font-size: 14px;
    font-weight: 500;
    margin-bottom: 5px;
}

.card-value {
    color: #2c3e50;
    font-size: 28px;
    font-weight: 700;
}

/* Charts Section */
.charts-section {
    margin-bottom: 30px;
}

.charts-container {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
    gap: 20px;
}

.chart-card {
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(10px);
    border-radius: 15px;
    padding: 25px;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

.chart-card h3 {
    color: #2c3e50;
    margin-bottom: 20px;
    font-size: 1.2em;
}

.chart-card h3 i {
    color: #3498db;
    margin-right: 8px;
}

/* Table Section */
.table-section {
    margin-bottom: 30px;
}

.table-card {
    background: rgba(255, 255, 255, 0.95);
    backdrop-filter: blur(10px);
    border-radius: 15px;
    padding: 25px;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
}

.table-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 25px;
    flex-wrap: wrap;
    gap: 15px;
}

.table-header h3 {
    color: #2c3e50;
    font-size: 1.3em;
}

.table-header h3 i {
    color: #e74c3c;
    margin-right: 8px;
}

.table-actions {
    display: flex;
    gap: 10px;
}

.export-btn,
.print-btn {
    background: linear-gradient(135deg, #27ae60, #2ecc71);
    color: white;
    padding: 8px 16px;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    font-weight: 500;
    transition: all 0.3s ease;
    font-size: 14px;
}

.print-btn {
    background: linear-gradient(135deg, #e67e22, #f39c12);
}

.export-btn:hover,
.print-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
}

.table-container {
    overflow-x: auto;
    border-radius: 10px;
    box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
}

.report-table {
    width: 100%;
    border-collapse: collapse;
    background: white;
    border-radius: 10px;
    overflow: hidden;
}

.report-table th {
    background: linear-gradient(135deg, #34495e, #2c3e50);
    color: white;
    padding: 15px 10px;
    text-align: left;
    font-weight: 600;
    font-size: 14px;
}

.report-table td {
    padding: 15px 10px;
    border-bottom: 1px solid #ecf0f1;
    font-size: 14px;
}

.report-table tr:hover {
    background: #f8f9fa;
}

.branch-name {
    font-weight: 600;
    color: #2c3e50;
}

.branch-info strong {
    color: #3498db;
}

.branch-address {
    color: #7f8c8d;
    max-width: 200px;
}

.contact-info {
    font-size: 12px;
    color: #7f8c8d;
}

.contact-info i {
    color: #3498db;
    margin-right: 5px;
}

.text-center {
    text-align: center;
}

.revenue-cell {
    font-weight: 600;
    color: #27ae60;
    text-align: right;
}

.occupancy-cell {
    min-width: 120px;
}

.occupancy-bar {
    position: relative;
    background: #ecf0f1;
    height: 20px;
    border-radius: 10px;
    overflow: hidden;
}

.occupancy-fill {
    height: 100%;
    background: linear-gradient(135deg, #3498db, #2980b9);
    border-radius: 10px;
    transition: width 0.3s ease;
}

.occupancy-bar span {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    font-size: 12px;
    font-weight: 600;
    color: white;
    text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.5);
}

.rating-cell {
    min-width: 120px;
}

.rating {
    display: flex;
    align-items: center;
    gap: 2px;
}

.rating i {
    color: #ecf0f1;
    font-size: 14px;
}

.rating i.filled {
    color: #f39c12;
}

.rating span {
    margin-left: 8px;
    font-size: 12px;
    color: #7f8c8d;
}

.actions-cell {
    text-align: center;
}

.action-btn {
    background: none;
    border: none;
    padding: 8px;
    margin: 0 2px;
    border-radius: 6px;
    cursor: pointer;
    transition: all 0.3s ease;
    font-size: 14px;
}

.action-btn.view {
    color: #3498db;
}

.action-btn.report {
    color: #e74c3c;
}

.action-btn:hover {
    background: rgba(0, 0, 0, 0.1);
    transform: scale(1.1);
}

/* No Data State */
.no-data {
    text-align: center;
    padding: 50px 20px;
    color: #7f8c8d;
}

.no-data i {
    font-size: 48px;
    margin-bottom: 20px;
    color: #bdc3c7;
}

.no-data h3 {
    margin-bottom: 10px;
    color: #34495e;
}

/* Responsive Design */
@media (max-width: 768px) {
    .container {
        padding: 10px;
    }
    
    .header-content {
        flex-direction: column;
        gap: 15px;
        text-align: center;
    }
    
    .filter-form {
        grid-template-columns: 1fr;
    }
    
    .summary-cards {
        grid-template-columns: 1fr;
    }
    
    .charts-container {
        grid-template-columns: 1fr;
    }
    
    .table-header {
        flex-direction: column;
        align-items: stretch;
    }
    
    .table-actions {
        justify-content: center;
    }
    
    .report-table th,
    .report-table td {
        padding: 10px 5px;
        font-size: 12px;
    }
    
    .branch-address {
        max-width: 150px;
    }
}

@media (max-width: 480px) {
    .header h1 {
        font-size: 1.5em;
    }
    
    .card-value {
        font-size: 20px;
    }
    
    .summary-card {
        padding: 15px;
    }
    
    .chart-card,
    .filter-card,
    .table-card {
        padding: 15px;
    }
}

/* Print Styles */
@media print {
    body {
        background: white;
    }
    
    .header,
    .filter-card,
    .chart-card,
    .table-card {
        background: white;
        box-shadow: none;
        border: 1px solid #ddd;
    }
    
    .logout-btn,
    .table-actions {
        display: none;
    }
    
    .action-btn {
        display: none;
    }
}

/* Animation for loading states */
@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.summary-card,
.chart-card,
.table-card,
.filter-card {
    animation: fadeIn 0.6s ease-out;
}
</style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <header class="header">
            <div class="header-content">
                <h1><i class="fas fa-chart-bar"></i> Branch Performance Reports</h1>
                <div class="user-info">
                    <span>Welcome, Hotel Owner</span>
                    <a href="logout" class="logout-btn"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </div>
            </div>
        </header>

        <!-- Filter Section -->
        <section class="filter-section">
            <div class="filter-card">
                <h3><i class="fas fa-filter"></i> Report Filters</h3>
                <form action="branch-reports" method="GET" class="filter-form">
                    <div class="form-group">
                        <label for="startDate">Start Date:</label>
                        <input type="date" id="startDate" name="startDate" value="${startDate}" required>
                    </div>
                    <div class="form-group">
                        <label for="endDate">End Date:</label>
                        <input type="date" id="endDate" name="endDate" value="${endDate}" required>
                    </div>
                   
                    <button type="submit" class="filter-btn">
                        <i class="fas fa-search"></i> Generate Report
                    </button>
                </form>
            </div>
        </section>

        <!-- Summary Cards -->
        <section class="summary-section">
            <div class="summary-cards">
                <div class="summary-card revenue">
                    <div class="card-icon">
                        <i class="fas fa-dollar-sign"></i>
                    </div>
                    <div class="card-content">
                        <h3>Total Revenue</h3>
                        <p class="card-value">
                            <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="$"/>
                        </p>
                    </div>
                </div>
                <div class="summary-card bookings">
                    <div class="card-icon">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <div class="card-content">
                        <h3>Total Bookings</h3>
                        <p class="card-value">${totalBookings}</p>
                    </div>
                </div>
                <div class="summary-card occupancy">
                    <div class="card-icon">
                        <i class="fas fa-bed"></i>
                    </div>
                    <div class="card-content">
                        <h3>Avg Occupancy Rate</h3>
                        <p class="card-value">
                            <fmt:formatNumber value="${averageOccupancyRate}" maxFractionDigits="1"/>%
                        </p>
                    </div>
                </div>
                <div class="summary-card rooms">
                    <div class="card-icon">
                        <i class="fas fa-door-open"></i>
                    </div>
                    <div class="card-content">
                        <h3>Total Rooms</h3>
                        <p class="card-value">${totalRooms}</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Charts Section -->
        <section class="charts-section">
            <div class="charts-container">
                <div class="chart-card">
                    <h3><i class="fas fa-chart-pie"></i> Revenue by Branch</h3>
                    <canvas id="revenueChart"></canvas>
                </div>
                <div class="chart-card">
                    <h3><i class="fas fa-chart-line"></i> Occupancy Rate Comparison</h3>
                    <canvas id="occupancyChart"></canvas>
                </div>
            </div>
        </section>

        <!-- Branch Reports Table -->
        <section class="table-section">
            <div class="table-card">
                <div class="table-header">
                    <h3><i class="fas fa-table"></i> Branch Performance Details</h3>
                    <div class="table-actions">
                        <button onclick="exportToCSV()" class="export-btn">
                            <i class="fas fa-download"></i> Export CSV
                        </button>
                        <button onclick="printReport()" class="print-btn">
                            <i class="fas fa-print"></i> Print Report
                        </button>
                    </div>
                </div>
                
                <div class="table-container">
                    <table class="report-table">
                        <thead>
                            <tr>
                                <th>Branch Name</th>
                                <th>Location</th>
                                <th>Contact</th>
                                <th>Total Rooms</th>
                                <th>Bookings</th>
                                <th>Revenue</th>
                                <th>Occupancy Rate</th>
                                <th>Avg Rating</th>
                                <th>Feedbacks</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="report" items="${branchReports}">
                                <tr>
                                    <td class="branch-name">
                                        <div class="branch-info">
                                            <strong>${report.branchName}</strong>
                                        </div>
                                    </td>
                                    <td class="branch-address">${report.branchAddress}</td>
                                    <td class="contact-info">
                                        <div>
                                            <i class="fas fa-phone"></i> ${report.branchPhone}<br>
                                            <i class="fas fa-envelope"></i> ${report.branchEmail}
                                        </div>
                                    </td>
                                    <td class="text-center">${report.totalRooms}</td>
                                    <td class="text-center">${report.totalBookings}</td>
                                    <td class="revenue-cell">
                                        <fmt:formatNumber value="${report.totalRevenue}" type="currency" currencySymbol="$"/>
                                    </td>
                                    <td class="occupancy-cell">
                                        <div class="occupancy-bar">
                                            <div class="occupancy-fill" style="width: ${report.occupancyRate}%"></div>
                                            <span><fmt:formatNumber value="${report.occupancyRate}" maxFractionDigits="1"/>%</span>
                                        </div>
                                    </td>
                                    <td class="rating-cell">
                                        <div class="rating">
                                            <c:forEach begin="1" end="5" var="star">
                                                <i class="fas fa-star ${star <= report.averageRating ? 'filled' : ''}"></i>
                                            </c:forEach>
                                            <span>(<fmt:formatNumber value="${report.averageRating}" maxFractionDigits="1"/>)</span>
                                        </div>
                                    </td>
                                    <td class="text-center">${report.totalFeedbacks}</td>
                                    <td class="actions-cell">
                                        <button onclick="viewDetails(${report.branchId})" class="action-btn view">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <button onclick="generateBranchReport(${report.branchId})" class="action-btn report">
                                            <i class="fas fa-file-alt"></i>
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
                
                <c:if test="${empty branchReports}">
                    <div class="no-data">
                        <i class="fas fa-chart-bar"></i>
                        <h3>No Data Available</h3>
                        <p>No branch reports found for the selected period.</p>
                    </div>
                </c:if>
            </div>
        </section>
    </div>

    <!-- Scripts -->
    <script>
        // Chart data preparation
        const branchNames = [
            <c:forEach var="report" items="${branchReports}" varStatus="status">
                "${report.branchName}"<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];
        
        const revenueData = [
            <c:forEach var="report" items="${branchReports}" varStatus="status">
                ${report.totalRevenue}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];
        
        const occupancyData = [
            <c:forEach var="report" items="${branchReports}" varStatus="status">
                ${report.occupancyRate}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        // Revenue Chart
        const revenueCtx = document.getElementById('revenueChart').getContext('2d');
        new Chart(revenueCtx, {
            type: 'pie',
            data: {
                labels: branchNames,
                datasets: [{
                    data: revenueData,
                    backgroundColor: [
                        '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0',
                        '#9966FF', '#FF9F40', '#FF6384', '#C9CBCF'
                    ]
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        position: 'bottom'
                    }
                }
            }
        });

        // Occupancy Chart
        const occupancyCtx = document.getElementById('occupancyChart').getContext('2d');
        new Chart(occupancyCtx, {
            type: 'bar',
            data: {
                labels: branchNames,
                datasets: [{
                    label: 'Occupancy Rate (%)',
                    data: occupancyData,
                    backgroundColor: '#36A2EB',
                    borderColor: '#2E8BC0',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 100
                    }
                }
            }
        });

        // Utility functions
        function viewDetails(branchId) {
            window.location.href = 'branch-details?id=' + branchId;
        }

        function generateBranchReport(branchId) {
            window.open('branch-report-pdf?id=' + branchId, '_blank');
        }

        function exportToCSV() {
            // Implementation for CSV export
            alert('CSV export functionality would be implemented here');
        }

        function printReport() {
            window.print();
        }
    </script>
</body>
</html>