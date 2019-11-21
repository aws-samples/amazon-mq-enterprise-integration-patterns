# Lab 2: Integrate Amazon MQ 

## Prerequisites

You must have completed Lab 1 successfully. Each lab builds on the previous lab. 

Switch to the `router` directory in your Cloud 9 IDE.

```
cd ~/environment/amazon-mq-enterprise-integration-patterns/router
```

## What are we doing?

In this lab, we will be integrating AmazonMQ broker endpoints to our skeleton project. First we will add necessary dependencies to our project and then we will configure a route that just copies messages from one queue to another.

## Add dependencies

Our project depends on various java libraries to run. These dependencies are managed by Maven. Add the following lines to ```pom.xml`` file in the ```<dependencies>``` block.

```
    <dependency>
        <groupId>org.apache.activemq</groupId>
        <artifactId>activemq-camel</artifactId>
        <version>5.15.9</version>
    </dependency>
    <dependency>
        <groupId>org.apache.activemq</groupId>
        <artifactId>activemq-all</artifactId>
        <version>5.15.9</version>
    </dependency> 
```

## Add ActiveMQ bean

Add the following lines to ```router/src/main/resources/META-INF/spring/camel-context.xml``` under ```<beans>``` 

```
        <!-- define the activemq component -->
        <bean id="activemq" class="org.apache.activemq.camel.component.ActiveMQComponent">
        <property name="connectionFactory">
          <bean class="org.apache.activemq.ActiveMQConnectionFactory">
            <property name="brokerURL" value="${broker.brokerURL}"/>
            <property name="userName" value="${broker.username}"/>
            <property name="password" value="${broker.password}"/>
          </bean>
        </property>
        </bean>
```

## Add a new route that uses the bean above

Add the following lines to ```router/src/main/resources/META-INF/spring/camel-context.xml``` under ```<camelContext>``` 

```
    <route>
      <from uri="activemq:queue:CAMEL.1"/>
      <to uri="activemq:queue:CAMEL.2"/>
    </route>
```

## Run the project 

Now run the skeleton project using the following commands. 

```
mvn install
mvn camel:run
```

That's it for Lab 2. Now you can start [Lab 3](lab-3.md).
