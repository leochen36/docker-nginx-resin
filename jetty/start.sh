


##java -jar start.jar etc/jetty.xml
#rm -rf nohup.out
nohup java -XX:+HeapDumpOnOutOfMemoryError -Xms256m -Xmx256m -Xmn128m -XX:PermSize=96m -XX:MaxPermSize=96m  -DSTOP.PORT=8009 -DSTOP.KEY=qudream  -jar start.jar  jetty.port=8080  &
