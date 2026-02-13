/**
 * Balance Management Integration
 * Handles fetching balance data from separate wallet tables
 */

class BalanceManager {
    constructor() {
        this.cache = new Map();
        this.cacheTimeout = 5 * 60 * 1000; // 5 minutes
    }

    /**
     * Get user balance data from wallet tables
     */
    async getUserBalances(userId) {
        console.log('BalanceManager: Fetching balances for user:', userId);
        
        // Check cache first
        const cached = this.cache.get(userId);
        if (cached && Date.now() - cached.timestamp < this.cacheTimeout) {
            console.log('BalanceManager: Using cached data for user:', userId);
            return cached.data;
        }

        try {
            // Fetch from user_wallets table
            console.log('BalanceManager: Fetching user_wallets...');
            const { data: userWallets, error: walletsError } = await window.API.request('user_wallets?user_id=eq.' + userId);
            console.log('BalanceManager: user_wallets result:', { data: userWallets, error: walletsError });
            
            // Fetch from crypto_wallets table  
            console.log('BalanceManager: Fetching crypto_wallets...');
            const { data: cryptoWallets, error: cryptoError } = await window.API.request('crypto_wallets?user_id=eq.' + userId);
            console.log('BalanceManager: crypto_wallets result:', { data: cryptoWallets, error: cryptoError });

            if (walletsError || cryptoError) {
                console.error('BalanceManager: Error fetching wallet data:', walletsError || cryptoError);
                return { wallets: {}, totalBalance: 0, error: walletsError || cryptoError };
            }

            // Combine wallet data
            const wallets = {};
            let totalBalance = 0;

            // Process user_wallets
            if (userWallets && userWallets.length > 0) {
                userWallets.forEach(wallet => {
                    const currency = wallet.currency || 'USD';
                    wallets[currency] = {
                        balance: wallet.balance || 0,
                        available: wallet.available || 0,
                        frozen: wallet.frozen || 0,
                        type: wallet.type || 'fiat',
                        last_updated: wallet.updated_at
                    };
                    totalBalance += wallet.balance || 0;
                });
            }

            // Process crypto_wallets
            if (cryptoWallets && cryptoWallets.length > 0) {
                cryptoWallets.forEach(wallet => {
                    const currency = wallet.currency || wallet.symbol || 'BTC';
                    wallets[currency] = {
                        balance: wallet.balance || 0,
                        available: wallet.available || 0,
                        frozen: wallet.frozen || 0,
                        type: 'crypto',
                        address: wallet.address,
                        network: wallet.network,
                        last_updated: wallet.updated_at
                    };
                    totalBalance += wallet.balance || 0;
                });
            }

            console.log('BalanceManager: Combined wallet data:', { wallets, totalBalance });

            // Cache the result
            this.cache.set(userId, {
                data: { wallets, totalBalance },
                timestamp: Date.now()
            });

            return { wallets, totalBalance };
        } catch (error) {
            console.error('BalanceManager: Error in getUserBalances:', error);
            return { wallets: {}, totalBalance: 0, error: error.message };
        }
    }

    /**
     * Get formatted balance text for display
     */
    getBalanceText(wallets) {
        const totalBalance = Object.values(wallets || {}).reduce((sum, wallet) => sum + wallet.balance, 0);
        return totalBalance > 0 ? `$${totalBalance.toLocaleString()}` : '$0';
    }

    /**
     * Clear cache for a specific user
     */
    clearUserCache(userId) {
        this.cache.delete(userId);
    }

    /**
     * Clear all cache
     */
    clearAllCache() {
        this.cache.clear();
    }
}

// Create global instance
window.balanceManager = new BalanceManager();
