#!/bin/bash

apppath=$(test -z "$1" && echo "not exist" || echo "$1")
environment=$(test -z "$2" && echo "production" || echo "$2") # default production
timestamp=$(date +%y%m%d_%H%M%S)

logfile=log/${environment}.log
bakfile=log/split/${environment}.${timestamp}.log

if [ -e ${logfile} ];
then
  cd ${apppath} && test -d log/split || mkdir log/split
	cd ${apppath} && cp ${logfile} ${bakfile} && true > ${logfile} || echo "WARNING - Copy File"
  cd ${apppath} && test -d log/report|| mkdir log/report
  cd ${apppath} && bundle exec request-log-analyzer ${bakfile} --file log/report/report.${timestamp}.html --output HTML
else
	echo "ERROR - Not Found: ${logfile}"
fi;
