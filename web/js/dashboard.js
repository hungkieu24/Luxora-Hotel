let roomStatusChart = null;
let revenueChart = null;

function initializeDashboard(roomStats) {
    initializeRoomStatusChart(roomStats);
    initializeRevenueChart();
    initializeAnimations();
}

function initializeRoomStatusChart(roomStats) {
    const ctx = document.getElementById('roomStatusChart');
    if (!ctx) return;
    
    const data = {
        labels: ['Phòng trống', 'Có khách', 'Bảo trì', 'Dọn dẹp'],
        datasets: [{
            data: [
                roomStats.available || 0,
                roomStats.occupied || 0,
                roomStats.maintenance || 0,
                roomStats.cleaning || 0
            ],
            backgroundColor: [
                'hsl(142, 76%, 36%)',
                'hsl(38, 92%, 50%)',
                'hsl(0, 72%, 51%)',
                'hsl(220, 73%, 49%)'
            ],
            borderColor: [
                'hsl(142, 76%, 30%)',
                'hsl(38, 92%, 40%)',
                'hsl(0, 72%, 40%)',
                'hsl(220, 73%, 40%)'
            ],
            borderWidth: 2
        }]
    };
    
    roomStatusChart = new Chart(ctx, {
        type: 'doughnut',
        data: data,
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        padding: 20,
                        usePointStyle: true,
                        font: { size: 12 }
                    }
                },
                tooltip: {
                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                    titleColor: 'white',
                    bodyColor: 'white',
                    borderColor: 'rgba(255, 255, 255, 0.1)',
                    borderWidth: 1,
                    callbacks: {
                        label: function(context) {
                            const label = context.label || '';
                            const value = context.parsed || 0;
                            const total = context.dataset.data.reduce((a, b) => a + b, 0);
                            const percentage = total > 0 ? ((value / total) * 100).toFixed(1) : 0;
                            return `${label}: ${value} (${percentage}%)`;
                        }
                    }
                }
            },
            animation: { animateRotate: true, duration: 1000 }
        }
    });
}

function initializeRevenueChart() {
    const ctx = document.getElementById('revenueChart');
    if (!ctx) return;
    
    const months = [];
    const revenueData = [];
    const currentDate = new Date();
    
    for (let i = 5; i >= 0; i--) {
        const date = new Date(currentDate.getFullYear(), currentDate.getMonth() - i, 1);
        months.push(date.toLocaleDateString('vi-VN', { month: 'short', year: 'numeric' }));
        const baseRevenue = 50000000;
        const variation = Math.random() * 0.4 + 0.8;
        revenueData.push(Math.floor(baseRevenue * variation));
    }
    
    const data = {
        labels: months,
        datasets: [{
            label: 'Doanh thu (VNĐ)',
            data: revenueData,
            borderColor: 'hsl(220, 73%, 49%)',
            backgroundColor: 'hsl(220, 73%, 49%, 0.1)',
            borderWidth: 3,
            fill: true,
            tension: 0.4,
            pointBackgroundColor: 'hsl(220, 73%, 49%)',
            pointBorderColor: 'white',
            pointBorderWidth: 2,
            pointRadius: 6,
            pointHoverRadius: 8
        }]
    };
    
    revenueChart = new Chart(ctx, {
        type: 'line',
        data: data,
        options: {
            responsive: true,
            maintainAspectRatio: false,
            interaction: {
                intersect: false,
                mode: 'index'
            },
            plugins: {
                legend: { display: false },
                tooltip: {
                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                    titleColor: 'white',
                    bodyColor: 'white',
                    borderColor: 'rgba(255, 255, 255, 0.1)',
                    borderWidth: 1,
                    callbacks: {
                        label: function(context) {
                            const value = context.parsed.y;
                            return `Doanh thu: ${formatCurrencyVN(value)}`;
                        }
                    }
                }
            },
            scales: {
                x: {
                    grid: { display: false },
                    ticks: { font: { size: 12 } }
                },
                y: {
                    beginAtZero: true,
                    grid: { color: 'rgba(0, 0, 0, 0.1)' },
                    ticks: {
                        font: { size: 12 },
                        callback: function(value) {
                            return formatCurrencyVN(value, true);
                        }
                    }
                }
            },
            animation: { duration: 1500, easing: 'easeInOutQuart' }
        }
    });
}

function initializeAnimations() {
    const statCards = document.querySelectorAll('.stat-card');
    statCards.forEach((card, index) => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        setTimeout(() => {
            card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
        }, index * 100);
    });
    
    const chartCards = document.querySelectorAll('.chart-card');
    chartCards.forEach((card, index) => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(30px)';
        setTimeout(() => {
            card.style.transition = 'opacity 0.8s ease, transform 0.8s ease';
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
        }, 300 + index * 200);
    });
    
    const feedbackSection = document.querySelector('.feedback-section');
    if (feedbackSection) {
        feedbackSection.style.opacity = '0';
        feedbackSection.style.transform = 'translateY(30px)';
        setTimeout(() => {
            feedbackSection.style.transition = 'opacity 0.8s ease, transform 0.8s ease';
            feedbackSection.style.opacity = '1';
            feedbackSection.style.transform = 'translateY(0)';
        }, 700);
    }
}

function formatCurrencyVN(amount, short = false) {
    if (short) {
        if (amount >= 1000000000) return (amount / 1000000000).toFixed(1) + 'B';
        if (amount >= 1000000) return (amount / 1000000).toFixed(1) + 'M';
        if (amount >= 1000) return (amount / 1000).toFixed(1) + 'K';
        return amount.toString();
    }
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: 'VND',
        minimumFractionDigits: 0
    }).format(amount);
}

function updateRoomStatusChart(newData) {
    if (roomStatusChart) {
        roomStatusChart.data.datasets[0].data = [
            newData.available || 0,
            newData.occupied || 0,
            newData.maintenance || 0,
            newData.cleaning || 0
        ];
        roomStatusChart.update('active');
    }
}

function updateRevenueChart(newData) {
    if (revenueChart && newData) {
        revenueChart.data.labels = newData.labels;
        revenueChart.data.datasets[0].data = newData.values;
        revenueChart.update('active');
    }
}

function startRealTimeUpdates() {
    setInterval(() => {
        updateDashboardStats();
    }, 30000);
}

function updateDashboardStats() {
    const statCards = document.querySelectorAll('.stat-card');
    statCards.forEach(card => {
        card.style.transform = 'scale(1.02)';
        setTimeout(() => {
            card.style.transform = 'scale(1)';
        }, 200);
    });
}

function updateChartsForTheme(theme) {
    const textColor = theme === 'dark' ? '#E2E8F0' : '#1E293B';
    const gridColor = theme === 'dark' ? 'rgba(255, 255, 255, 0.1)' : 'rgba(0, 0, 0, 0.1)';
    
    if (roomStatusChart) {
        roomStatusChart.options.plugins.legend.labels.color = textColor;
        roomStatusChart.update();
    }
    
    if (revenueChart) {
        revenueChart.options.scales.x.ticks.color = textColor;
        revenueChart.options.scales.y.ticks.color = textColor;
        revenueChart.options.scales.y.grid.color = gridColor;
        revenueChart.update();
    }
}

window.DashboardUtils = {
    updateRoomStatusChart,
    updateRevenueChart,
    updateChartsForTheme,
    startRealTimeUpdates
};

document.addEventListener('DOMContentLoaded', function() {
    if (window.location.pathname === '/index.html') {
        setTimeout(startRealTimeUpdates, 5000);
    }
});