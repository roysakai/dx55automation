#!/usr/bin/env bash
#
# Version:      @(#)skeleton  1.9  26-Feb-2001  miquels@cistron.nl
#
# chkconfig: 2345 75 25
# description: ACS startup script.

### BEGIN INIT INFO
# Provides:          acssvc
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start daemon at boot time.
# Description:       Incognito ACS Service Startup Script.
### END INIT INFO

r=$2

touch /var/run/jacs.pid

ACSPID=`/usr/bin/pgrep -U 0 -P 1 -f jacs.jar`
PIDFILE=/var/run/jacs.pid
PID=`cat $PIDFILE`

DESC="Incognito ACS Service"

# ACS default BASE_DIR
BASE_DIR=/usr/local/lib/acs

DAEMON=$BASE_DIR/acs.sh
PWD=`pwd`

# Include acs defaults if available
if [ -f /etc/default/acs ] ; then
        . /etc/default/acs
fi

EXIT_CODE=0

set -e

DAEMON_OPTS="$DAEMON_OPTS "

case "$1" in
  start)
    if [ "$ACSPID" != "" ]; then
      echo "ACS has already been started, its PID is"
      /usr/bin/pgrep -U 0 -P 1 -f jacs.jar
      exit 0
    else
      echo "Starting $DESC: "
      cd $BASE_DIR
      $DAEMON
      EXIT_CODE=$?
      cd $PWD
    fi
    ;;
  stop)
    echo -n "Stopping $DESC: "
    echo "PID= $ACSPID"
    if [ "$ACSPID" != "" ]; then
      kill -HUP $ACSPID
      EXIT_CODE=$?
      for i in {1..60}
        do
          if [ -n "$(ps -p $ACSPID -o pid=)" ]; then
            echo "Waiting for ACS with PID $ACSPID to exit ..."
            sleep 1
          else
            break
          fi
        done
    fi
    ;;
  restart)
    $0 stop
    $0 start
    ;;
  condrestart)
    if [ "$ACSPID" != "" ]; then
      $0 restart
    fi
    ;;
  force-reload)
    $0 restart
    ;;
  register)
    while [ -z "${2}" ]
    do
      $2
    done
    cd $BASE_DIR
    $DAEMON -r ${2}
    EXIT_CODE=$?
    cd $PWD
    ;;
  status)
    if [ "$ACSPID" != "" ]; then
      echo "You have Incognito ACS Service running. The PID is $ACSPID"
      EXIT_CODE=0
    else
      echo "Incognito ACS Service is NOT running now."
      EXIT_CODE=3
    fi
    ;;
  *)
    N=/etc/init.d/acs
    echo "Usage: $N {start|stop|restart|condrestart|register|status}" >&2
    EXIT_CODE=1
    ;;
esac

exit $EXIT_CODE