# Integrate TIBCO EMS with Amazon MQ

## Setup

TIBCO provides a community edition for development. You can download one from [here](https://www.tibco.com/resources/product-download/tibco-enterprise-message-service-community-edition--free-download). Install [TIBCO EMS Community Edition on EC2 instance](https://docs.tibco.com/pub/ems-vms/8.5.0/doc/html/GUID-BA4B3A1E-0BEF-4752-8C46-720B5D14A84D.html). Start the [TIBCO EMS Server](https://docs.tibco.com/pub/ems-vms/8.5.0/doc/html/GUID-374B3C9A-7EEC-427A-B08C-E63813FBB993.html). Follow the instructions in [Lab 1](/labs/lab-1.md) to update Cloud9 environment and setup a skeleton project.
TIBCO EMS provides tibjms.jar as part of the installation. You would need to copy this jar file to the workspace where you setup the skeleton project.

## What are we doing?

We will integrate TIBCO EMS with AmazonMQ using Camel Spring DSL. This integration can be added to the project independently of other integrations.

## Add the tibjms manually to maven

TIBCO JMS library is not part of the maven repository. Hence the library would need to be added manually to local maven repository using the following command:

```
mvn install:install-file -Dfile=tibjms.jar -DgroupId=com.tibco -DartifactId=tibjms -Dversion=8.5 -Dpackaging=jar
```

Add the following lines to ```pom.xml`` file in the ```<dependencies>``` block.

```
    <dependency>
        <groupId>com.tibco</groupId>
        <artifactId>tibjms</artifactId>
        <version>8.5</version>
    </dependency>  
```

## Add a bean to configure TIBCO JMS

Currently the bean is configured with just the server url. In the future, we will explore adding userName, password and SSL/TLS.

```
  <bean id="tibco" class="org.apache.camel.component.jms.JmsComponent">
    <property name="connectionFactory">
      <bean class="com.tibco.tibjms.TibjmsConnectionFactory">
        <property name="serverUrl" value="${tibco.server.url}"/>
      </bean>
    </property>
  </bean>
```

Add TIBCO EMS server's public ip and port to ~/environment/router/main/resources/secrets.properties file as shown below. Make sure the EC2 instance's security group allows ingress to TIBCO EMS port.

```
tibco.server.url=<public-ip:port>
```

## Add a route 

The following route copies messages from TIBCO queue ems.to.amq to queue CAMEL.1 on AmazonMQ

```
    <route>
      <from uri="tibco:queue:ems.to.amq"/>
      <to uri="activemq:queue:CAMEL.1" />
    </route> 
```

## Run the project 

Now run the project using the following commands. 

```
export CAMEL_MASTER_PASSWORD=<Password supplied by host>
mvn install
mvn camel:run
```
