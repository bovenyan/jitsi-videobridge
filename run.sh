HOST=localhost
DOMAIN=boven-cute.dev.local
PORT=5347
SECRET=NQrY0v7h
JVB_HOME=/home/bovenyan/git/jitsi-videobridge

mvn compile exec:java -Dexec.args="--host=$HOST --domain=$DOMAIN --port=$PORT --secret=$SECRET" -Djava.library.path=$JVB_HOME/lib/native/linux-64 -Djava.util.logging.config.file=$JVB_HOME/lib/logging.properties -Dnet.java.sip.communicator.SC_HOME_DIR_NAME=.jitsi-videobridge

