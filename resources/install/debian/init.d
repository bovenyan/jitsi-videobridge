#! /bin/sh
#
# INIT script for Jitsi Videobridge
# Version: 1.0  01-May-2014  yasen@bluejimp.com
#
### BEGIN INIT INFO
# Provides:          jitsi-videobridge
# Required-Start:    $local_fs $remote_fs
# Required-Stop:     $local_fs $remote_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Jitsi Videobridge
# Description:       WebRTC compatible Selective Forwarding Unit (SFU)
### END INIT INFO

. /lib/lsb/init-functions

# Include videobridge defaults if available
if [ -f /etc/jitsi/videobridge/config ]; then
    . /etc/jitsi/videobridge/config
fi

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/usr/share/jitsi-videobridge/jvb.sh
NAME=jvb
USER=jvb
PIDFILE=/var/run/jitsi-videobridge.pid
LOGFILE=/var/log/jitsi/jvb.log
DESC=jitsi-videobridge
if [ ! $JVB_HOST ]; then
    JVB_HOST=localhost
fi
DAEMON_OPTS=" --host=$JVB_HOST --domain=$JVB_HOSTNAME --port=$JVB_PORT --secret=$JVB_SECRET $JVB_OPTS"

test -x $DAEMON || exit 0

set -e

stop() {
    if [ -f $PIDFILE ]; then
        PID=$(cat $PIDFILE)
    fi
    echo -n "Stopping $DESC: "
    if [ $PID ]; then
        kill $PID
        rm $PIDFILE || true
        echo "$NAME stopped."
    else
        echo "$NAME doesn't seem to be running."
    fi
}

start() {
    if [ -f $PIDFILE ]; then
        echo "$DESC seems to be already running, we found pidfile $PIDFILE."
        exit 1
    fi
    echo -n "Starting $DESC: "
    DAEMON_START_CMD="JAVA_SYS_PROPS=\"$JAVA_SYS_PROPS\" exec $DAEMON $DAEMON_OPTS < /dev/null >> $LOGFILE 2>&1"
    AUTHBIND_CMD=""
    if [ "$AUTHBIND" = "yes" ]; then
        AUTHBIND_CMD="/usr/bin/authbind --deep /bin/bash -c "
        DAEMON_START_CMD="'$DAEMON_START_CMD'"
    fi
    start-stop-daemon --start --quiet --background --chuid $USER --make-pidfile --pidfile $PIDFILE \
        --exec /bin/bash -- -c "$AUTHBIND_CMD $DAEMON_START_CMD"
    echo "$NAME started."
}

reload() {
    echo 'Not yet implemented.'
}

status() {
    status_of_proc -p $PIDFILE java "$NAME" && exit 0 || exit $?
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    stop
    start
    ;;
  reload)
    reload
    ;;
  force-reload)
    reload
    ;;
  status)
    status
    ;;
  *)
    N=/etc/init.d/$NAME
    echo "Usage: $N {start|stop|restart|reload|status}" >&2
    exit 1
    ;;
esac

exit 0
