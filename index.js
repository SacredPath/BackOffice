// Back Office Dashboard JavaScript
class BackOfficeDashboard {
    constructor() {
        this.init();
    }

    async init() {
        console.log('Back Office Dashboard initializing...');
        
        // Initialize user data
        await this.loadUserData();
        
        // Initialize stats
        await this.loadDashboardStats();
        
        // Load recent activity
        await this.loadRecentActivity();
        
        // Load pending deposits
        await this.loadDepositRequests();
        
        // Setup periodic updates
        this.setupPeriodicUpdates();
        
        console.log('Back Office Dashboard initialized');
    }

    async loadUserData() {
        try {
            // Mock user data - replace with actual API call
            const userData = {
                name: 'Admin User',
                role: 'Super Admin',
                avatar: 'A'
            };
            
            document.getElementById('user-name').textContent = userData.name;
            document.getElementById('user-role').textContent = userData.role;
            document.getElementById('user-avatar').textContent = userData.avatar;
        } catch (error) {
            console.error('Error loading user data:', error);
        }
    }

    async loadDashboardStats() {
        try {
            // Mock stats - replace with actual API calls
            const stats = {
                totalUsers: 1234,
                usersChange: '+12.5%',
                totalDeposits: '$45,678',
                depositsChange: '+8.3%',
                totalWithdrawals: '$12,345',
                withdrawalsChange: '+5.2%',
                activePositions: 89,
                positionsChange: '+15.7%'
            };

            document.getElementById('total-users').textContent = stats.totalUsers;
            document.getElementById('users-change').textContent = stats.usersChange;
            document.getElementById('total-deposits').textContent = stats.totalDeposits;
            document.getElementById('deposits-change').textContent = stats.depositsChange;
            document.getElementById('total-withdrawals').textContent = stats.totalWithdrawals;
            document.getElementById('withdrawals-change').textContent = stats.withdrawalsChange;
            document.getElementById('active-positions').textContent = stats.activePositions;
            document.getElementById('positions-change').textContent = stats.positionsChange;
        } catch (error) {
            console.error('Error loading dashboard stats:', error);
        }
    }

    async loadRecentActivity() {
        try {
            // Mock activity data - replace with actual API call
            const activities = [
                {
                    icon: '👤',
                    title: 'New User Registration',
                    description: 'John Doe registered for an account',
                    time: '2 minutes ago'
                },
                {
                    icon: '💰',
                    title: 'Deposit Received',
                    description: 'Deposit of $1,000 from Jane Smith',
                    time: '5 minutes ago'
                },
                {
                    icon: '📈',
                    title: 'Position Opened',
                    description: 'BTC/USD position opened by Mike Johnson',
                    time: '10 minutes ago'
                }
            ];

            const activityList = document.getElementById('activity-list');
            activityList.innerHTML = activities.map(activity => `
                <div class="activity-item">
                    <div class="activity-icon">${activity.icon}</div>
                    <div class="activity-content">
                        <div class="activity-title">${activity.title}</div>
                        <div class="activity-description">${activity.description}</div>
                    </div>
                    <div class="activity-time">${activity.time}</div>
                </div>
            `).join('');
        } catch (error) {
            console.error('Error loading recent activity:', error);
        }
    }

    async loadDepositRequests() {
        try {
            // Mock deposit requests - replace with actual API call
            const deposits = [
                {
                    id: 'DEP001',
                    user: 'Alice Johnson',
                    amount: '$500.00',
                    method: 'Bank Transfer',
                    time: '1 hour ago',
                    status: 'pending'
                },
                {
                    id: 'DEP002',
                    user: 'Bob Smith',
                    amount: '$1,200.00',
                    method: 'Credit Card',
                    time: '2 hours ago',
                    status: 'pending'
                }
            ];

            const depositContainer = document.getElementById('deposit-requests');
            depositContainer.innerHTML = deposits.map(deposit => `
                <div class="activity-item">
                    <div class="activity-icon">💰</div>
                    <div class="activity-content">
                        <div class="activity-title">${deposit.id} - ${deposit.user}</div>
                        <div class="activity-description">${deposit.amount} via ${deposit.method}</div>
                    </div>
                    <div class="activity-time">${deposit.time}</div>
                </div>
            `).join('');

            // Update badge
            document.getElementById('pending-deposits-badge').textContent = deposits.length;
        } catch (error) {
            console.error('Error loading deposit requests:', error);
        }
    }

    setupPeriodicUpdates() {
        // Update dashboard every 30 seconds
        setInterval(() => {
            this.loadDashboardStats();
            this.loadRecentActivity();
        }, 30000);
    }

    logout() {
        if (confirm('Are you sure you want to logout?')) {
            window.location.href = 'login.html';
        }
    }

    refreshActivity() {
        this.loadRecentActivity();
    }
}

// Initialize dashboard when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.backofficePage = new BackOfficeDashboard();
});

// Export for use in other files
if (typeof module !== 'undefined' && module.exports) {
    module.exports = BackOfficeDashboard;
}
