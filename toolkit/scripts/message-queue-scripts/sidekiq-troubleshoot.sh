#!/bin/bash
echo "Sidekiq Troubleshooting Tool"
echo "------------------------"
echo "1. Check Redis connection for Sidekiq"
echo "   Usage: redis-cli -h <redis-host> -p <redis-port> ping"
echo "2. Monitor Sidekiq queues in Redis"
echo "   Usage: redis-cli -h <redis-host> -p <redis-port> LLEN sidekiq:queue:<queue-name>"
echo "3. Check all Sidekiq queues"
echo "   Usage: redis-cli -h <redis-host> -p <redis-port> KEYS \"sidekiq:queue:*\""
echo "4. Check Sidekiq retry set"
echo "   Usage: redis-cli -h <redis-host> -p <redis-port> ZCARD sidekiq:retry"
echo "5. Check Sidekiq dead set"
echo "   Usage: redis-cli -h <redis-host> -p <redis-port> ZCARD sidekiq:dead"
echo "6. Connect to a Rails app with Sidekiq"
echo "   Usage: cd /path/to/rails/app && bundle exec rails console"
echo "   Then: Sidekiq::Stats.new (in the Rails console)" 
