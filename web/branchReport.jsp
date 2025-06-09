<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Branch Report - HotelBooki Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .sidebar {
            min-height: 100vh;
            background: #fff;
            box-shadow: 2px 0 5px rgba(0,0,0,0.1);
        }
        .nav-link {
            color: #6c757d;
            padding: 12px 20px;
            border-radius: 8px;
            margin: 2px 10px;
        }
        .nav-link:hover, .nav-link.active {
            background: #e3f2fd;
            color: #1976d2;
        }
        .main-content {
            background: #f8f9fa;
            min-height: 100vh;
        }
        .header {
            background: white;
            padding: 15px 30px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .stats-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
            transition: transform 0.2s;
        }
        .stats-card:hover {
            transform: translateY(-2px);
        }
        .stats-card.revenue {
            background: linear-gradient(135deg, #27ae60, #2ecc71);
            color: white;
        }
        .stats-card.bookings {
            background: linear-gradient(135deg, #3498db, #5dade2);
            color: white;
        }
        .stats-card.occupancy {
            background: linear-gradient(135deg, #f39c12, #f7dc6f);
            color: white;
        }
        .stats-card.branches {
            background: linear-gradient(135deg, #9b59b6, #bb8fce);
            color: white;
        }
        .stats-card.rooms {
            background: linear-gradient(135deg, #e74c3c, #ec7063);
            color: white;
        }
        .chart-container {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .filter-section {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .table-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .progress-bar-custom {
            width: 80px;
            height: 8px;
            background: #e0e0e0;
            border-radius: 4px;
            overflow: hidden;
            margin-right: 8px;
        }
        .progress-fill {
            height: 100%;
            background: linear-gradient(90deg, #27ae60, #f39c12);
            border-radius: 4px;
            transition: width 0.4s;
        }
        .btn-action {
            padding: 5px 12px;
            font-size: 12px;
            border-radius: 4px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 sidebar">
                <div class="p-3">
                    <div class="d-flex align-items-center mb-4">
                        <div class="bg-primary rounded p-2 me-2">
                            <i class="fas fa-hotel text-white"></i>
                        </div>
                        <span class="fw-bold text-primary">Sample Branch</span>
                    </div>
                    
                    <nav class="nav flex-column">
                        <a class="nav-link" href="${pageContext.request.contextPath}/dashboard">
                            <i class="fas fa-tachometer-alt me-2"></i> Dashboard
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/branch-reports">
                            <i class="fas fa-bed me-2"></i> branch report
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/feedback">
                            <i class="fas fa-comments me-2"></i> Feedback
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/services">
                            <i class="fas fa-concierge-bell me-2"></i> Services
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/promotions">
                            <i class="fas fa-tags me-2"></i> Promotions
                        </a>
                        <a class="nav-link" href="${pageContext.request.contextPath}/members">
                            <i class="fas fa-users me-2"></i> Members
                        </a>
                        <hr>
                        <a class="nav-link text-danger" href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt me-2"></i> Logout
                        </a>
                    </nav>
                </div>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-10 main-content">
                <!-- Header -->
                <div class="header d-flex justify-content-between align-items-center">
                    <h4 class="mb-0">Branch Report</h4>
                    <div class="d-flex align-items-center">
                        <span class="me-2">admin</span>
                        <div class="bg-secondary rounded-circle" style="width: 32px; height: 32px;"></div>
                    </div>
                </div>
                
                <div class="p-4">
                    <!-- Filter Section -->
                    <div class="filter-section">
                        <h5 class="mb-3"><i class="fas fa-filter me-2"></i>Report Filters</h5>
                        <form action="branch-reports" method="GET">
                            <div class="row">
                                <div class="col-md-3">
                                    <label for="startDate" class="form-label">From Date:</label>
                                    <input type="date" id="startDate" name="startDate" 
                                           value="${startDate != null ? startDate : '2024-01-01'}" 
                                           class="form-control" required>
                                </div>
                                <div class="col-md-3">
                                    <label for="endDate" class="form-label">To Date:</label>
                                    <input type="date" id="endDate" name="endDate" 
                                           value="${endDate != null ? endDate : '2024-12-31'}" 
                                           class="form-control" required>
                                </div>
                                <div class="col-md-3">
                                    <label for="reportType" class="form-label">Report Type:</label>
                                    <select id="reportType" name="reportType" class="form-select">
                                        <option value="revenue" ${reportType == 'revenue' ? 'selected' : ''}>Revenue</option>
                                        <option value="occupancy" ${reportType == 'occupancy' ? 'selected' : ''}>Occupancy Rate</option>
                                        <option value="bookings" ${reportType == 'bookings' ? 'selected' : ''}>Bookings</option>
                                        <option value="all" ${reportType == 'all' ? 'selected' : ''}>All</option>
                                    </select>
                                </div>
                                <div class="col-md-3 d-flex align-items-end">
                                    <button type="submit" class="btn btn-primary me-2">
                                        <i class="fas fa-search me-1"></i>Generate Report
                                    </button>
                                    <button type="button" class="btn btn-success" onclick="exportReport()">
                                        <i class="fas fa-download me-1"></i>Export Excel
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>

                    <!-- Statistics Cards -->
                    <div class="row mb-4">
                        <div class="col-md-2">
                            <div class="stats-card revenue text-center">
                                <i class="fas fa-dollar-sign fa-2x mb-2"></i>
                                <h4><fmt:formatNumber value="${totalRevenue}" type="currency" 
                                                      currencySymbol="₫" maxFractionDigits="0"/></h4>
                                <p class="mb-0">Total Revenue</p>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="stats-card bookings text-center">
                                <i class="fas fa-calendar-check fa-2x mb-2"></i>
                                <h4>${totalBookings}</h4>
                                <p class="mb-0">Total Bookings</p>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="stats-card occupancy text-center">
                                <i class="fas fa-percentage fa-2x mb-2"></i>
                                <h4><fmt:formatNumber value="${averageOccupancyRate}" maxFractionDigits="1"/></h4>
                                <p class="mb-0">Average Occupancy</p>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="stats-card branches text-center">
                                <i class="fas fa-building fa-2x mb-2"></i>
                                <h4>${totalBranches}</h4>
                                <p class="mb-0">Total Branches</p>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="stats-card rooms text-center">
                                <i class="fas fa-bed fa-2x mb-2"></i>
                                <h4>${totalRooms}</h4>
                                <p class="mb-0">Total Rooms</p>
                            </div>
                        </div>
                    </div>

                    <!-- Charts Section -->
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <div class="chart-container" style="height: 300px;">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <h6 class="mb-0"><i class="fas fa-chart-line me-2"></i>Revenue by Branch</h6>
                                    <select id="revenueChartType" onchange="updateRevenueChart()" class="form-select form-select-sm" style="width: auto;">
                                        <option value="line">Line Chart</option>
                                        <option value="bar">Bar Chart</option>
                                    </select>
                                </div>
                                <canvas id="revenueChart"></canvas>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="chart-container" style="height: 300px;">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <h6 class="mb-0"><i class="fas fa-chart-pie me-2"></i>Occupancy Rate by Branch</h6>
                                </div>
                                <canvas id="occupancyChart"></canvas>
                            </div>
                        </div>
                    </div>

                    <!-- Branch Reports Table -->
                    <div class="table-container">
                        <div class="p-3 border-bottom">
                            <div class="d-flex justify-content-between align-items-center">
                                <h5 class="mb-0"><i class="fas fa-table me-2"></i>Branch Report Details</h5>
                                <input type="text" id="searchTable" placeholder="Search..." class="form-control" style="width: 250px;">
                            </div>
                        </div>
                        <div class="table-responsive">
                            <c:choose>
                                <c:when test="${empty branchReports}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-chart-bar fa-3x text-muted mb-3"></i>
                                        <h5 class="text-muted">No Data</h5>
                                        <p class="text-muted">No branch reports found for the selected time period.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <table class="table table-hover mb-0" id="branchTable">
                                        <thead class="table-dark">
                                            <tr>
                                                <th onclick="sortTable(0)">Branch Name <i class="fas fa-sort"></i></th>
                                                <th onclick="sortTable(1)">Revenue <i class="fas fa-sort"></i></th>
                                                <th onclick="sortTable(2)">Total Bookings <i class="fas fa-sort"></i></th>
                                                <th onclick="sortTable(3)">Occupancy Rate <i class="fas fa-sort"></i></th>
                                                <th onclick="sortTable(4)">Total Rooms <i class="fas fa-sort"></i></th>
                                                <th onclick="sortTable(5)">Average Rating <i class="fas fa-sort"></i></th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody id="branchTableBody">
                                            <c:forEach var="branch" items="${branchReports}">
                                                <tr>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <i class="fas fa-building text-primary me-2"></i>
                                                            <strong>${branch.branchName}</strong>
                                                        </div>
                                                    </td>
                                                    <td class="text-success fw-bold">
                                                        <fmt:formatNumber value="${branch.totalRevenue}" type="currency" 
                                                                          currencySymbol="₫" maxFractionDigits="0"/>
                                                    </td>
                                                    <td><fmt:formatNumber value="${branch.totalBookings}" type="number"/></td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <div class="progress-bar-custom">
                                                                <div class="progress-fill" data-width="<c:out value='${branch.occupancyRate}'/>"></div>
                                                            </div>
                                                            <span><fmt:formatNumber value="${branch.occupancyRate}" maxFractionDigits="1"/>%</span>
                                                        </div>
                                                    </td>
                                                    <td><fmt:formatNumber value="${branch.totalRooms}" type="number"/></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${branch.averageRating > 0}">
                                                                <div class="d-flex align-items-center">
                                                                    <span class="me-1"><fmt:formatNumber value="${branch.averageRating}" maxFractionDigits="1"/></span>
                                                                    <div class="text-warning">
                                                                        <c:forEach begin="1" end="5" var="i">
                                                                            <i class="fas fa-star${i <= branch.averageRating ? '' : '-o'}"></i>
                                                                        </c:forEach>
                                                                    </div>
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">No ratings</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <button class="btn btn-primary btn-action" data-branch-id="<c:out value='${branch.branchId}'/>" onclick="viewDetails(this.dataset.branchId)">
                                                            <i class="fas fa-eye me-1"></i>Details
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                    <div id="branchTablePagination" class="p-3 d-flex justify-content-center"></div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Charts
        let revenueChart, occupancyChart;

        // Get data from JSP
        const branchData = [
            <c:forEach var="report" items="${branchReports}" varStatus="status">
                {
                    name: "<c:out value='${report.branchName}'/>",
                    revenue: <c:out value='${report.totalRevenue}'/>,
                    occupancy: <c:out value='${report.occupancyRate}'/>,
                    bookings: <c:out value='${report.totalBookings}'/>
                }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
        ];

        // Revenue Chart
        const revenueCtx = document.getElementById('revenueChart').getContext('2d');
        revenueChart = new Chart(revenueCtx, {
            type: 'line',
            data: {
                labels: branchData.map(branch => branch.name),
                datasets: [{
                    label: 'Doanh thu (₫)',
                    data: branchData.map(branch => branch.revenue),
                    borderColor: '#3498db',
                    backgroundColor: 'rgba(52, 152, 219, 0.1)',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true,
                        position: 'top',
                        labels: {
                            boxWidth: 10,
                            font: {
                                size: 10
                            }
                        }
                    }
                },
                scales: {
                    x: {
                        ticks: {
                            maxRotation: 45,
                            minRotation: 45,
                            font: {
                                size: 10
                            }
                        }
                    },
                    y: {
                        beginAtZero: true,
                        ticks: {
                            font: {
                                size: 10
                            },
                            callback: function(value) {
                                return new Intl.NumberFormat('vi-VN', {
                                    style: 'currency',
                                    currency: 'VND',
                                    notation: 'compact',
                                    maximumFractionDigits: 1
                                }).format(value);
                            }
                        }
                    }
                }
            }
        });

        // Occupancy Chart
        const occupancyCtx = document.getElementById('occupancyChart').getContext('2d');
        occupancyChart = new Chart(occupancyCtx, {
            type: 'doughnut',
            data: {
                labels: branchData.map(branch => branch.name),
                datasets: [{
                    data: branchData.map(branch => branch.occupancy),
                    backgroundColor: [
                        '#3498db', '#27ae60', '#f39c12', '#e74c3c', 
                        '#9b59b6', '#e67e22', '#1abc9c', '#34495e'
                    ]
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                cutout: '60%',
                plugins: {
                    legend: {
                        position: 'bottom',
                        align: 'center',
                        labels: {
                            boxWidth: 10,
                            font: {
                                size: 9
                            },
                            padding: 5
                        }
                    }
                }
            }
        });

        // Update Revenue Chart Type
        function updateRevenueChart() {
            const chartType = document.getElementById('revenueChartType').value;
            revenueChart.destroy();
            revenueChart = new Chart(revenueCtx, {
                type: chartType,
                data: {
                    labels: branchData.map(branch => branch.name),
                    datasets: [{
                        label: 'Doanh thu (₫)',
                        data: branchData.map(branch => branch.revenue),
                        borderColor: '#3498db',
                        backgroundColor: chartType === 'bar' ? '#3498db' : 'rgba(52, 152, 219, 0.1)',
                        tension: 0.4,
                        fill: chartType === 'line'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: true,
                            position: 'top',
                            labels: {
                                boxWidth: 10,
                                font: {
                                    size: 10
                                }
                            }
                        }
                    },
                    scales: {
                        x: {
                            ticks: {
                                maxRotation: 45,
                                minRotation: 45,
                                font: {
                                    size: 10
                                }
                            }
                        },
                        y: {
                            beginAtZero: true,
                            ticks: {
                                font: {
                                    size: 10
                                },
                                callback: function(value) {
                                    return new Intl.NumberFormat('vi-VN', {
                                        style: 'currency',
                                        currency: 'VND',
                                        notation: 'compact',
                                        maximumFractionDigits: 1
                                    }).format(value);
                                }
                            }
                        }
                    }
                }
            });
        }

        // Update Occupancy Chart Type
        function updateOccupancyChart() {
            const chartType = document.getElementById('occupancyChartType').value;
            occupancyChart.destroy();
            occupancyChart = new Chart(occupancyCtx, {
                type: chartType,
                data: {
                    labels: branchData.map(branch => branch.name),
                    datasets: [{
                        data: branchData.map(branch => branch.occupancy),
                        backgroundColor: [
                            '#3498db', '#27ae60', '#f39c12', '#e74c3c', 
                            '#9b59b6', '#e67e22', '#1abc9c', '#34495e'
                        ]
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    cutout: chartType === 'doughnut' ? '60%' : undefined,
                    plugins: {
                        legend: {
                            position: chartType === 'doughnut' ? 'bottom' : 'top',
                            align: 'center',
                            labels: {
                                boxWidth: 10,
                                font: {
                                    size: 9
                                },
                                padding: 5
                            }
                        }
                    },
                    scales: chartType === 'bar' ? {
                        x: {
                            ticks: {
                                maxRotation: 45,
                                minRotation: 45,
                                font: {
                                    size: 9
                                }
                            }
                        },
                        y: {
                            beginAtZero: true,
                            max: 100,
                            ticks: {
                                font: {
                                    size: 9
                                },
                                callback: function(value) {
                                    return value + '%';
                                }
                            }
                        }
                    } : undefined
                }
            });
        }

        // Table Search Functionality
        document.getElementById('searchTable').addEventListener('keyup', function() {
            const searchValue = this.value.toLowerCase();
            const tableRows = document.querySelectorAll('#branchTableBody tr');
            
            tableRows.forEach(row => {
                const branchName = row.cells[0].textContent.toLowerCase();
                if (branchName.includes(searchValue)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });

        // Table Sorting Functionality
        let sortDirection = true;
        function sortTable(columnIndex) {
            const table = document.getElementById('branchTable');
            const tbody = table.querySelector('tbody');
            const rows = Array.from(tbody.querySelectorAll('tr'));
            
            rows.sort((a, b) => {
                let aValue = a.cells[columnIndex].textContent.trim();
                let bValue = b.cells[columnIndex].textContent.trim();
                
                // Handle different data types
                if (columnIndex === 1) { // Revenue column
                    aValue = parseFloat(aValue.replace(/[^\d.-]/g, ''));
                    bValue = parseFloat(bValue.replace(/[^\d.-]/g, ''));
                } else if (columnIndex === 2 || columnIndex === 4) { // Bookings and Rooms columns
                    aValue = parseInt(aValue.replace(/[^\d]/g, ''));
                    bValue = parseInt(bValue.replace(/[^\d]/g, ''));
                } else if (columnIndex === 3 || columnIndex === 5) { // Occupancy and Rating columns
                    aValue = parseFloat(aValue.replace(/[^\d.-]/g, ''));
                    bValue = parseFloat(bValue.replace(/[^\d.-]/g, ''));
                }
                
                if (sortDirection) {
                    return aValue > bValue ? 1 : -1;
                } else {
                    return aValue < bValue ? 1 : -1;
                }
            });
            
            // Clear tbody and append sorted rows
            tbody.innerHTML = '';
            rows.forEach(row => tbody.appendChild(row));
            
            // Toggle sort direction
            sortDirection = !sortDirection;
            
            // Update sort icons
            const headers = table.querySelectorAll('th i.fa-sort, th i.fa-sort-up, th i.fa-sort-down');
            headers.forEach(icon => {
                icon.className = 'fas fa-sort';
            });
            
            const currentHeader = table.querySelectorAll('th')[columnIndex].querySelector('i');
            currentHeader.className = sortDirection ? 'fas fa-sort-up' : 'fas fa-sort-down';
        }

        // View Details Function
        function viewDetails(branchId) {
            window.location.href = "${pageContext.request.contextPath}/branch-details?id=" + branchId;
        }

        // Export Report Function
        function exportReport() {
            let csvContent = "data:text/csv;charset=utf-8,";
            csvContent += "Chi nhánh,Doanh thu,Tổng đặt phòng,Tỷ lệ lấp đầy,Tổng phòng,Đánh giá TB\n";
            
            const tableRows = document.querySelectorAll('#branchTableBody tr');
            tableRows.forEach(row => {
                if (row.style.display !== 'none') {
                    const cells = row.querySelectorAll('td');
                    const rowData = [
                        cells[0].textContent.trim().replace(/[,]/g, ''),
                        cells[1].textContent.trim().replace(/[,₫]/g, ''),
                        cells[2].textContent.trim(),
                        cells[3].textContent.trim().replace('%', ''),
                        cells[4].textContent.trim(),
                        cells[5].textContent.trim()
                    ];
                    csvContent += rowData.join(",") + "\n";
                }
            });
            
            const encodedUri = encodeURI(csvContent);
            const link = document.createElement("a");
            link.setAttribute("href", encodedUri);
            link.setAttribute("download", "branch_report_" + new Date().toISOString().split('T')[0] + ".csv");
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }

        // Date validation
        document.getElementById('startDate').addEventListener('change', function() {
            const startDate = new Date(this.value);
            const endDate = new Date(document.getElementById('endDate').value);
            
            if (startDate > endDate) {
                document.getElementById('endDate').value = this.value;
            }
        });

        document.getElementById('endDate').addEventListener('change', function() {
            const startDate = new Date(document.getElementById('startDate').value);
            const endDate = new Date(this.value);
            
            if (endDate < startDate) {
                document.getElementById('startDate').value = this.value;
            }
        });

        // Pagination for table
        (function() {
            const rowsPerPage = 5;
            let currentPage = 1;
            const table = document.getElementById('branchTable');
            const tbody = document.getElementById('branchTableBody');
            const searchInput = document.getElementById('searchTable');
            const pagination = document.getElementById('branchTablePagination');

            function getFilteredRows() {
                const filter = searchInput.value.toLowerCase();
                return Array.from(tbody.getElementsByTagName('tr')).filter(row => {
                    return row.innerText.toLowerCase().includes(filter);
                });
            }

            function renderTable() {
                const filteredRows = getFilteredRows();
                // Hide all rows
                Array.from(tbody.getElementsByTagName('tr')).forEach(row => row.style.display = 'none');
                // Show current page rows
                const start = (currentPage - 1) * rowsPerPage;
                const end = start + rowsPerPage;
                filteredRows.slice(start, end).forEach(row => row.style.display = '');
                renderPagination(filteredRows.length);
            }

            function renderPagination(totalRows) {
                pagination.innerHTML = '';
                if (totalRows <= rowsPerPage) return;
                
                const pageCount = Math.ceil(totalRows / rowsPerPage);
                
                // Previous button
                if (currentPage > 1) {
                    const prevBtn = document.createElement('button');
                    prevBtn.innerHTML = '<i class="fas fa-chevron-left"></i>';
                    prevBtn.className = 'btn btn-outline-primary btn-sm me-1';
                    prevBtn.onclick = function() {
                        currentPage--;
                        renderTable();
                    };
                    pagination.appendChild(prevBtn);
                }
                
                // Page numbers
                for (let i = 1; i <= pageCount; i++) {
                    const btn = document.createElement('button');
                    btn.innerText = i;
                    btn.className = (i === currentPage) ? 'btn btn-primary btn-sm me-1' : 'btn btn-outline-primary btn-sm me-1';
                    btn.onclick = function() {
                        currentPage = i;
                        renderTable();
                    };
                    pagination.appendChild(btn);
                }
                
                // Next button
                if (currentPage < pageCount) {
                    const nextBtn = document.createElement('button');
                    nextBtn.innerHTML = '<i class="fas fa-chevron-right"></i>';
                    nextBtn.className = 'btn btn-outline-primary btn-sm';
                    nextBtn.onclick = function() {
                        currentPage++;
                        renderTable();
                    };
                    pagination.appendChild(nextBtn);
                }
            }

            if (searchInput) {
                searchInput.addEventListener('input', function() {
                    currentPage = 1;
                    renderTable();
                });
            }

            // Initialize
            if (tbody && tbody.children.length > 0) {
                renderTable();
            }
        })();

        // Animate statistics cards on load
        window.addEventListener('load', function() {
            const statCards = document.querySelectorAll('.stats-card');
            statCards.forEach((card, index) => {
                setTimeout(() => {
                    card.style.opacity = '0';
                    card.style.transform = 'translateY(20px)';
                    card.style.transition = 'all 0.5s ease';
                    
                    requestAnimationFrame(() => {
                        card.style.opacity = '1';
                        card.style.transform = 'translateY(0)';
                    });
                }, index * 100);
            });
        });

        document.addEventListener('DOMContentLoaded', function() {
            // Set progress bar widths
            document.querySelectorAll('.progress-fill').forEach(function(element) {
                const width = element.dataset.width;
                element.style.width = width + '%';
                element.style.background = 'linear-gradient(90deg, #27ae60, #f39c12)';
            });
        });
    </script>
</body>
</html>