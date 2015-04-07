#!/bin/sh  
# 
PORT=$(test -z "$2" && echo "4001" || echo "$2")
ENVIRONMENT=$(test -z "$3" && echo "production" || echo "$3")

UNICORN=unicorn  
CONFIG_FILE=config/unicorn.rb  
 
APP_ROOT_PATH=$(pwd)

case "$1" in  
    precompile)
        RAILS_ENV=production bundle exec rake assets:clean
        RAILS_ENV=production bundle exec rake assets:my_precompile
        ;;
    start)  
        test -d log || mkdir log
        test -d tmp || mkdir -p tmp/pids
        gravatar_path=app/assets/images/gravatar
        test -d ${gravatar_path} || mkdir -p ${gravatar_path}

        echo "## start unicorn"
        echo -e "\t port: ${PORT} \n\t environment: ${ENVIRONMENT}"
        bundle exec ${UNICORN} -c ${CONFIG_FILE} -p ${PORT} -E ${ENVIRONMENT} -D > /dev/null 2>&1
        echo -e "\t unicorn start $(test $? -eq 0 && echo "successfully" || echo "failed")."
        ;;  
    stop)  
        echo "## stop unicorn"
        kill -QUIT `cat tmp/pids/unicorn.pid`  
        echo -e "\t unicorn stop $(test $? -eq 0 && echo "successfully" || echo "failed")."
        ;;  
    restart|force-reload)  
        #kill -USR2 `cat tmp/pids/unicorn.pid`  
        sh unicorn.sh stop
        echo -e "\n\n-----------command sparate line----------\n\n"
        sh unicorn.sh start ${PORT} ${ENVIRONMENT}
        ;;  
    deploy)
        echo "RACK_ENV=production bundle exec rake remote:deploy"
        ;;
    *)  
        echo "Usage: $SCRIPTNAME {start|stop|restart|force-reload|deploy}" >&2  
        exit 3  
        ;;  
esac  
