#!/usr/bin/env sh

if [ ! ${1##*.} = 'jmx' ]; then
    echo "The first parameter must be the reference to the jmx file"
    exit 1
fi

export JMX_FILE=$1
shift

  # empty the logs directory, or jmeter may fail
rm -rf /logs/report /logs/*.log /logs/*.jtl

  # remove setting JAVA heap and use the RUN_IN_DOCKER variable
  sed -i 's/-Xms1g -Xmx1g -XX:MaxMetaspaceSize=256m//' $JMETER_HOME/bin/jmeter
  sed -i 's/# RUN_IN_DOCKER/RUN_IN_DOCKER/' $JMETER_HOME/bin/jmeter

echo jmeter -l $RESULTS_LOG \
     -t $JMX_FILE \
     -n $@ -e -o /logs/report

exec jmeter -l $RESULTS_LOG \
     -t $JMX_FILE \
     -n $@ -e -o /logs/report
