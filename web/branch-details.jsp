<%-- 
    Document   : branchDetails
    Created on : 2 thg 6, 2025, 00:52:22
    Author     : pc
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Branch Report - ${branchReport.branchName} - HotelBooki</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
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
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 25px 30px;
            margin-bottom: 30px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 20px;
        }

        .header h1 {
            font-size: 2.2rem;
            font-weight: 700;
            color: #2d3748;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .header h1 i {
            color: #667eea;
            font-size: 2rem;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .user-info span {
            font-weight: 600;
            color: #4a5568;
        }

        .logout-btn {
            background: linear-gradient(135deg, #ff6b6b, #ee5a24);
            color: white;
            padding: 12px 20px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .logout-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(238, 90, 36, 0.3);
        }

        /* Filter Section */
        .filter-section {
            margin-bottom: 30px;
        }

        .filter-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .filter-card h3 {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .filter-card h3 i {
            color: #667eea;
        }

        .filter-form {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 25px;
            align-items: end;
        }

        .form-group label {
            display: block;
            font-weight: 600;
            color: #4a5568;
            margin-bottom: 8px;
        }

        .form-group select,
        .form-group input {
            width: 100%;
            padding: 14px 16px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: white;
        }

        .form-group select:focus,
        .form-group input:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .filter-btn {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            padding: 14px 24px;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 10px;
            justify-content: center;
        }

        .filter-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }

        /* Summary Cards */
        .summary-section {
            margin-bottom: 40px;
        }

        .summary-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
        }

        .summary-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .summary-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, var(--card-color), var(--card-color-light));
        }

        .summary-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.15);
        }

        .summary-card.revenue {
            --card-color: #10b981;
            --card-color-light: #34d399;
        }

        .summary-card.bookings {
            --card-color: #3b82f6;
            --card-color-light: #60a5fa;
        }

        .summary-card.occupancy {
            --card-color: #f59e0b;
            --card-color-light: #fbbf24;
        }

        .summary-card.rooms {
            --card-color: #8b5cf6;
            --card-color-light: #a78bfa;
        }

        .summary-card .card-icon {
            width: 60px;
            height: 60px;
            border-radius: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
            background: linear-gradient(135deg, var(--card-color), var(--card-color-light));
        }

        .summary-card .card-icon i {
            font-size: 1.8rem;
            color: white;
        }

        .summary-card h3 {
            font-size: 1rem;
            font-weight: 600;
            color: #6b7280;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .summary-card .card-value {
            font-size: 2.5rem;
            font-weight: 800;
            color: #1f2937;
            line-height: 1;
        }

        /* Table Section */
        .table-section {
            margin-bottom: 40px;
        }

        .table-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 30px;
            border-bottom: 1px solid #e5e7eb;
            flex-wrap: wrap;
            gap: 20px;
        }

        .table-header h3 {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2d3748;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .table-header h3 i {
            color: #667eea;
        }

        .print-btn {
            background: linear-gradient(135deg, #4ade80, #22c55e);
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .print-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(34, 197, 94, 0.3);
        }

        .table-container {
            overflow-x: auto;
        }

        .report-table {
            width: 100%;
            border-collapse: collapse;
        }

        .report-table th {
            background: linear-gradient(135deg, #f8fafc, #f1f5f9);
            padding: 20px 16px;
            text-align: left;
            font-weight: 700;
            color: #374151;
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            border-bottom: 2px solid #e5e7eb;
        }

        .report-table td {
            padding: 20px 16px;
            border-bottom: 1px solid #f3f4f6;
            vertical-align: middle;
        }

        .report-table tr:hover {
            background: #f8fafc;
        }

        .branch-name {
            font-weight: 700;
            color: #1f2937;
        }

        .contact-info {
            line-height: 1.6;
            color: #6b7280;
        }

        .contact-info i {
            color: #667eea;
            width: 16px;
        }

        .text-center {
            text-align: center;
            font-weight: 600;
        }

        .revenue-cell {
            font-weight: 800;
            color: #10b981;
            font-size: 1.1rem;
        }

        .occupancy-cell {
            text-align: center;
        }

        .occupancy-bar {
            position: relative;
            background: #e5e7eb;
            height: 25px;
            border-radius: 12px;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .occupancy-fill {
            position: absolute;
            left: 0;
            top: 0;
            height: 100%;
            background: linear-gradient(90deg, #f59e0b, #fbbf24);
            border-radius: 12px;
            transition: width 0.5s ease;
        }

        .occupancy-bar span {
            position: relative;
            z-index: 1;
            font-weight: 700;
            color: #374151;
            font-size: 0.9rem;
        }

        .rating-cell {
            text-align: center;
        }

        .rating {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 2px;
        }

        .rating i {
            color: #d1d5db;
            font-size: 1.2rem;
        }

        .rating i.filled {
            color: #fbbf24;
        }

        .rating span {
            margin-left: 8px;
            font-weight: 600;
            color: #6b7280;
        }

        /* Charts Section */
        .charts-section {
            margin-bottom: 40px;
        }

        .charts-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(400px, 1fr));
            gap: 30px;
        }

        .chart-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .chart-card h3 {
            font-size: 1.3rem;
            font-weight: 700;
            color: #2d3748;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .chart-card h3 i {
            color: #667eea;
        }

        .chart-card canvas {
            max-height: 300px;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                padding: 15px;
            }

            .header h1 {
                font-size: 1.8rem;
            }

            .filter-form {
                grid-template-columns: 1fr;
            }

            .summary-cards {
                grid-template-columns: 1fr;
            }

            .summary-card .card-value {
                font-size: 2rem;
            }

            .table-header {
                flex-direction: column;
                align-items: stretch;
            }

            .charts-container {
                grid-template-columns: 1fr;
            }
        }

        /* Print Styles */
        @media print {
            body {
                background: white;
            }

            .header,
            .filter-card,
            .summary-card,
            .table-card,
            .chart-card {
                background: white;
                box-shadow: none;
                border: 1px solid #ddd;
            }

            .print-btn,
            .logout-btn {
                display: none;
            }
        }

        /* Animation */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .summary-card,
        .table-card,
        .chart-card {
            animation: fadeInUp 0.6s ease forwards;
        }

        .summary-card:nth-child(1) { animation-delay: 0.1s; }
        .summary-card:nth-child(2) { animation-delay: 0.2s; }
        .summary-card:nth-child(3) { animation-delay: 0.3s; }
        .summary-card:nth-child(4) { animation-delay: 0.4s; }
    </style>
</head>
<body>
    <div class="container">
        <header class="header">
            <h1><i class="fas fa-chart-bar"></i> Branch Report - 
                <c:choose>
                    <c:when test="${not empty branchReport}">
                        ${branchReport.branchName}
                    </c:when>
                    <c:otherwise>
                        No Branch Selected
                    </c:otherwise>
                </c:choose>
            </h1>
        </header>

        <c:if test="${not empty errorMessage}">
            <div class="error-message">${errorMessage}</div>
        </c:if>
            
        <!-- Filter Section -->
        <section class="filter-section">
            <div class="filter-card">
                <h3><i class="fas fa-filter"></i> Report Filters</h3>
                <form action="branch-details" method="GET" class="filter-form">
                    <div class="form-group">
                        <label for="id">Select Branch:</label>
                        <select id="id" name="id" required>
                            <option value="">-- Select Branch --</option>
                            <c:forEach var="branch" items="${branches}">
                                <option value="${branch.branchId}" ${branch.branchId == selectedBranchId ? 'selected' : ''}>
                                    ${branch.branchName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="startDate">Start Date:</label>
                        <input type="date" id="startDate" name="startDate" value="${startDate}" required>
                    </div>
                    <div class="form-group">
                        <label for="endDate">End Date:</label>
                        <input type="date" id="endDate" name="endDate" value="${endDate}" required>
                    </div>
                    <button type="submit" class="filter-btn">
                        <i class="fas fa-search"></i> Update Report
                    </button>
                </form>
            </div>
        </section>

        <!-- Summary Cards -->
        <c:if test="${not empty branchReport}">
            <section class="summary-section">
                <div class="summary-cards">
                    <div class="summary-card revenue">
                        <div class="card-icon">
                            <i class="fas fa-dollar-sign"></i>
                        </div>
                        <div class="card-content">
                            <h3>Total Revenue</h3>
                            <p class="card-value">
                                <fmt:formatNumber value="${branchReport.totalRevenue}" type="currency" currencySymbol="$"/>
                            </p>
                        </div>
                    </div>
                    <div class="summary-card bookings">
                        <div class="card-icon">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <div class="card-content">
                            <h3>Total Bookings</h3>
                            <p class="card-value">${branchReport.totalBookings}</p>
                        </div>
                    </div>
                    <div class="summary-card occupancy">
                        <div class="card-icon">
                            <i class="fas fa-bed"></i>
                        </div>
                        <div class="card-content">
                            <h3>Occupancy Rate</h3>
                            <p class="card-value">
                                <fmt:formatNumber value="${branchReport.occupancyRate}" maxFractionDigits="1"/>%
                            </p>
                        </div>
                    </div>
                    <div class="summary-card rooms">
                        <div class="card-icon">
                            <i class="fas fa-door-open"></i>
                        </div>
                        <div class="card-content">
                            <h3>Total Rooms</h3>
                            <p class="card-value">${branchReport.totalRooms}</p>
                        </div>
                    </div>
                </div>
            </section>
        </c:if>

        <!-- Branch Details -->
        <section class="table-section">
            <div class="table-card">
                <div class="table-header">
                    <h3><i class="fas fa-table"></i> Branch Details</h3>
                    <div class="table-actions">
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
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="branch-name">
                                    <div class="branch-info">
                                        <strong>${branchReport.branchName}</strong>
                                    </div>
                                </td>
                                <td class="branch-address">${branchReport.branchAddress}</td>
                                <td class="contact-info">
                                    <div>
                                        <i class="fas fa-phone"></i> ${branchReport.branchPhone}<br>
                                        <i class="fas fa-envelope"></i> ${branchReport.branchEmail}
                                    </div>
                                </td>
                                <td class="text-center">${branchReport.totalRooms}</td>
                                <td class="text-center">${branchReport.totalBookings}</td>
                                <td class="revenue-cell">
                                    <fmt:formatNumber value="${branchReport.totalRevenue}" type="currency" currencySymbol="$"/>
                                </td>
                                <td class="occupancy-cell">
                                    <div class="occupancy-bar">
                                        <div class="occupancy-fill" style="width: ${branchReport.occupancyRate}%"></div>
                                        <span><fmt:formatNumber value="${branchReport.occupancyRate}" maxFractionDigits="1"/>%</span>
                                    </div>
                                </td>
                                <td class="rating-cell">
                                    <div class="rating">
                                        <c:forEach begin="1" end="5" var="star">
                                            <i class="fas fa-star ${star <= branchReport.averageRating ? 'filled' : ''}"></i>
                                        </c:forEach>
                                        <span>(<fmt:formatNumber value="${branchReport.averageRating}" maxFractionDigits="1"/>)</span>
                                    </div>
                                </td>
                                <td class="text-center">${branchReport.totalFeedbacks}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>

        <!-- Charts Section -->
        <section class="charts-section">
            <div class="charts-container">
                <div class="chart-card">
                    <h3><i class="fas fa-chart-pie"></i> Revenue Breakdown</h3>
                    <canvas id="revenueChart"></canvas>
                </div>
                <div class="chart-card">
                    <h3><i class="fas fa-chart-bar"></i> Occupancy Rate</h3>
                    <canvas id="occupancyChart"></canvas>
                </div>
            </div>
        </section>
        
        <c:if test="${empty branchReport}">
            <p>No data available for the selected branch and date range.</p>
        </c:if>
    </div>

    <!-- Scripts -->
    <script>
        // Chart data preparation
        const totalRevenue = [${branchReport.totalRevenue}];
        const revenueData = [totalRevenue, Math.max(0, 50000 - totalRevenue)];
        const occupancyData = [${branchReport.occupancyRate}];

        // Revenue Chart (Enhanced Pie Chart)
        const revenueCtx = document.getElementById('revenueChart').getContext('2d');
        new Chart(revenueCtx, {
            type: 'doughnut',
            data: {
                labels: ['Current Revenue', 'Target Gap'],
                datasets: [{
                    data: revenueData,
                    backgroundColor: [
                        'rgba(16, 185, 129, 0.8)',
                        'rgba(229, 231, 235, 0.5)'
                    ],
                    borderColor: [
                        'rgba(16, 185, 129, 1)',
                        'rgba(229, 231, 235, 1)'
                    ],
                    borderWidth: 2,
                    hoverOffset: 10
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'bottom',
                        labels: {
                            padding: 20,
                            font: {
                                size: 14,
                                weight: '600'
                            }
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.8)',
                        titleColor: 'white',
                        bodyColor: 'white',
                        borderColor: 'rgba(255, 255, 255, 0.2)',
                        borderWidth: 1
                    }
                },
                cutout: '60%'
            }
        });

        // Occupancy Chart (Enhanced)
        const occupancyCtx = document.getElementById('occupancyChart').getContext('2d');
        new Chart(occupancyCtx, {
            type: 'bar',
            data: {
                labels: ['${branchReport.branchName}'],
                datasets: [{
                    label: 'Occupancy Rate (%)',
                    data: occupancyData,
                    backgroundColor: 'rgba(59, 130, 246, 0.8)',
                    borderColor: 'rgba(59, 130, 246, 1)',
                    borderWidth: 2,
                    borderRadius: 8,
                    borderSkipped: false,
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        labels: {
                            font: {
                                size: 14,
                                weight: '600'
                            }
                        }
                    },
                    tooltip: {
                        backgroundColor: 'rgba(0, 0, 0, 0.8)',
                        titleColor: 'white',
                        bodyColor: 'white',
                        borderColor: 'rgba(255, 255, 255, 0.2)',
                        borderWidth: 1
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 100,
                        grid: {
                            color: 'rgba(0, 0, 0, 0.1)'
                        },
                        ticks: {
                            font: {
                                size: 12,
                                weight: '600'
                            }
                        }
                    },
                    x: {
                        grid: {
                            display: false
                        },
                        ticks: {
                            font: {
                                size: 12,
                                weight: '600'
                            }
                        }
                    }
                }
            }
        });

        // Print function
        function printReport() {
            window.print();
        }

        // Add loading animation
        document.addEventListener('DOMContentLoaded', function() {
            const cards = document.querySelectorAll('.summary-card, .table-card, .chart-card');
            cards.forEach((card, index) => {
                setTimeout(() => {
                    card.style.opacity = '1';
                    card.style.transform = 'translateY(0)';
                }, index * 100);
            });
        });
    </script>
</body>
</html>