#!/bin/bash

apppath=$(test -z "$1" && echo "not exist" || echo "$1")
environment=$(test -z "$2" && echo "production" || echo "$2") # default production
timestamp=$(date +%y%m%d_%H%M%S)

logfile=log/${environment}.log
bakfile=log/split/${environment}.${timestamp}.log
reportfile=log/report/report.${timestamp}.html

if [ -e ${logfile} ];
then
  cd ${apppath} 
  test -d log/split || mkdir log/split
  test -d log/report|| mkdir log/report
	cp ${logfile} ${bakfile} && true > ${logfile} || echo "WARNING - Copy File"
  bundle exec request-log-analyzer ${bakfile} --file ${reportfile} --output HTML
  # remove the row with SED command.
  #     `background: #CAE8EA url(images/bg_header.jpg) no-repeat;`
  # it will be scaned by rails web and cause exception: ActionController::UnknownFormat .
  # rails web has already fix#bug above.
  sed -i -e /bg_header.jpg/d ${reportfile}
else
	echo "ERROR - Not Found: ${logfile}"
fi;
