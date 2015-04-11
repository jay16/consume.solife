#!/bin/sh  
# Program to operate Rails with Unicorn 

PORT=$(test -z "$2" && echo "4001" || echo "$2") # default 4001
ENVIRONMENT=$(test -z "$3" && echo "production" || echo "$3") # default production
UNICORN=unicorn  
CONFIG_FILE=config/unicorn.rb  
APP_ROOT_PATH=$(pwd)

case "$1" in  
    precompile)
        RAILS_ENV=production bundle exec rake assets:clean
        RAILS_ENV=production bundle exec rake assets:my_precompile
        ;;
    start)  
        echo "## bundle install"
        bundle install --local > /dev/null 2>&1 
        if test $? -eq 0 
        then
          echo -e "\t bundle install --local successfully."
        else
          bundle install
        fi
      
        test -d log || mkdir log
        test -d tmp || mkdir -p tmp/pids

        echo "## rake tasks"
        TASK1="bundle exec rake tmp:clear"
        `${TASK1}`
        echo -e "\t ${TASK1} $(test $? -eq 0 && echo "successfully" || echo "failed")."
        TASK2="bundle exec rake assets:clobber"
        `${TASK2} > /dev/null 2>&1`
        echo -e "\t ${TASK2} $(test $? -eq 0 && echo "successfully" || echo "failed")."
        TASK3="bundle exec rake assets:my_precompile"
        `${TASK3} > /dev/null 2>&1`
        echo -e "\t ${TASK3} $(test $? -eq 0 && echo "successfully" || echo "failed")."

        echo "## start unicorn"
        echo -e "\t port: ${PORT} \n\t environment: ${ENVIRONMENT}"
        bundle exec ${UNICORN} -c ${CONFIG_FILE} -p ${PORT} -E ${ENVIRONMENT} -D > /dev/null 2>&1
        echo -e "\t unicorn start $(test $? -eq 0 && echo "successfully" || echo "failed")."
        ;;  
    stop)  
        echo "## stop unicorn"
        TMP_PID=tmp/pids/unicorn.pid
        if test -f ${TMP_PID} 
        then 
          kill -QUIT `cat ${TMP_PID}`  
          echo -e "\t unicorn stop $(test $? -eq 0 && echo "successfully" || echo "failed")."
        else
          echo -e "\t unicorn stop failed for has not been started."
        fi
        ;;  
    restart)  
        #kill -USR2 `cat tmp/pids/unicorn.pid`  
        sh unicorn.sh stop 
        echo -e "\n\n-----------command sparate line----------\n\n"
        sh unicorn.sh start ${PORT} ${ENVIRONMENT}
        ;;  
    deploy)
        # echo "RACK_ENV=production bundle exec rake remote:deploy"
        bundle exec cap production my_deploy
        ;;
    *)  
        echo "Usage: $SCRIPTNAME {start|stop|restart|deploy}" >&2  
        exit 3  
        ;;  
esac  
