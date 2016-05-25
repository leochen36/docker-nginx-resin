


##java -jar start.jar etc/jetty.xml
#rm -rf nohup.out
nohup java -XX:+HeapDumpOnOutOfMemoryError -Xms1024m -Xmx1024m -Xmn512m -XX:PermSize=128m -XX:MaxPermSize=128m  -DSTOP.PORT=8009 -DSTOP.KEY=qudream  -jar start.jar  jetty.port=8080  &
