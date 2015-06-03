#!/bin/sh  
test -n "${DEBUG}" && set -x

# Program to operate Rails with Unicorn 
PORT=$(test -z "$2" && echo "4001" || echo "$2") # default 4001
ENVIRONMENT=$(test -z "$3" && echo "production" || echo "$3") # default production
UNICORN=unicorn  
CONFIG_FILE=config/unicorn.rb  
APP_ROOT_PATH=$(pwd)

# user bash environment for crontab job.
shell_used=${SHELL##*/}
echo "** shell used: ${shell_used}"
[ -f ~/.${shell_used}_profile ] && source ~/.${shell_used}_profile > /dev/null 2&>1
[ -f ~/.${shell_used}rc ] && source ~/.${shell_used}rc > /dev/null 2&>1
export LANG=zh_CN.UTF-8
# maybe enter other dir after source.
cd ${APP_ROOT_PATH}

# use the current .ruby-version's command
bundle_command=$(rbenv which bundle)
gem_command=$(rbenv which gem)
case "$1" in 
    gem)
        shift 1
        $gem_commnd $@
    ;;
    precompile)
        RAILS_ENV=production $bundle_command exec rake assets:clean
        RAILS_ENV=production $bundle_command exec rake assets:my_precompile
    ;;
    bundle)
        echo "## bundle install"
        $bundle_command install --local > /dev/null 2>&1 
        if test $? -eq 0 
        then
          echo -e "\t bundle install --local successfully."
        else
          $bundle_command install
        fi
    ;;
    start)  
        /bin/sh unicorn.sh bundle

        test -d log || mkdir log
        test -d tmp || mkdir -p tmp/pids

        echo "## release cache/buffer."
        #sync && echo 3 > /proc/sys/vm/drop_caches > /dev/null 2>&1
        echo -e "\t release cache/buffer $(test $? -eq 0 && echo "successfully" || echo "failed")."

        echo "## rake tasks"
        bundle_task="$bundle_command exec rake tmp:clear"
        `${bundle_task}`
        echo -e "\t ${bundle_task##*/} $(test $? -eq 0 && echo "successfully" || echo "failed")."
        bundle_task="$bundle_command exec rake assets:clobber"
        `${bundle_task} > /dev/null 2>&1`
        echo -e "\t ${bundle_task##*/} $(test $? -eq 0 && echo "successfully" || echo "failed")."
        bundle_task="$bundle_command exec rake assets:my_precompile"
        `${bundle_task} > /dev/null 2>&1`
        echo -e "\t ${bundle_task##*/} $(test $? -eq 0 && echo "successfully" || echo "failed")."

        echo "## start unicorn"
        echo -e "\t port: ${PORT} \n\t environment: ${ENVIRONMENT}"
        $bundle_command exec ${UNICORN} -c ${CONFIG_FILE} -p ${PORT} -E ${ENVIRONMENT} -D > /dev/null 2>&1
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
        /bin/sh unicorn.sh stop 
        printf "\n\n%10s command sparate line %10s\n\n" |  tr ' ' -
        /bin/sh unicorn.sh start ${PORT} ${ENVIRONMENT}
    ;;  
    deploy)
        # echo "RACK_ENV=production bundle exec rake remote:deploy"
        $bundle_command exec rake remote:upload
        $bundle_command exec cap production my_deploy
    ;;
    log-analyzer)
        /bin/sh bin/bash/log_split.sh "$(pwd)" "$2"
        # bundle exec request-log-analyzer log/production.log --file report.html --output HTML
    ;;
    restore)
        $bundle_command exec rake qiniu:download
    ;;
    whenever)
        command="$1"
        $bundle_command exec whenever ${command} -i config/schedule.rb
    ;;
    *)  
        echo "Usage: $SCRIPTNAME {bundle|start|stop|restart|deploy|log-analyzer|whenever|restore}" >&2  
        exit 3  
    ;;  
esac  
