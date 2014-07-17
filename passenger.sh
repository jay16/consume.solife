echo "Sync Consume DB from remote VPS In Background!"
nohup /usr/local/var/rbenv/shims/ruby /Users/lijunjie/Code/crond/sync_consume_db.rb > ./log/nohup.syncDB.log 2>&1 &

echo "Make Sure MySQL start!"
mysql.server start

#sudo lsof -i:3000
passenger start -e production
