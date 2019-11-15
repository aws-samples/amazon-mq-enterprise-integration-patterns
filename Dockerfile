FROM maven:3.6-amazoncorretto-8
ADD router /root/router
ADD lib /root/lib
RUN mvn install:install-file -Dfile=/root/lib/tibjms.jar -DgroupId=com.tibco -DartifactId=tibjms -Dversion=8.5 -Dpackaging=jar && cd /root/router && mvn clean install
