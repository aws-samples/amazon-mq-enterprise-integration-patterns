# ActiveMQ PooledConnectionFactory

## Prerequisites

You must have completed Lab 1 successfully. Each lab builds on the previous lab. 

Switch to the `router` directory in your Cloud 9 IDE.

```
cd ~/environment/amazon-mq-enterprise-integration-patterns/router
```

## What are we doing?

In this example, we will be integrating AmazonMQ broker endpoints to our skeleton project using a PooledConnectionFactory. In contrast to a ConnectionFactory, connection pooling helps Camel application to share a fixed number of connections thus reducing the load on the AmazonMQ broker and improving connections efficiently.

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
    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-jasypt</artifactId>
        <version>2.24.2</version>
    </dependency>    
```

## Add ActiveMQ bean with connection pooling.

```
  <bean id="activeMQConnectionFactory" class="org.apache.activemq.ActiveMQConnectionFactory">
    <property name="brokerURL" value="${broker.brokerURL}"/>
    <property name="userName" value="${broker.username}"/>
    <property name="password" value="${broker.password}"/>
  </bean>
   
  <bean id="pooledConnectionFactory" class="org.apache.activemq.pool.PooledConnectionFactory"
  init-method="start" destroy-method="stop">
    <property name="maxConnections" value="10" />
    <property name="maximumActiveSessionPerConnection" value="20" />
    <property name="blockIfSessionPoolIsFull" value="true" />
    <property name="createConnectionOnStartup" value="true" />
    <property name="idleTimeout" value="50" />
    <property name="connectionFactory" ref="activeMQConnectionFactory" />
  </bean>
   
  <bean id="jmsConfiguration" class="org.apache.camel.component.jms.JmsConfiguration">
    <property name="connectionFactory" ref="pooledConnectionFactory"/>
    <property name="concurrentConsumers" value="5"/>
    <property name="maxConcurrentConsumers" value="10"/>
  </bean>
   
  <bean id="activemq-pool" class="org.apache.activemq.camel.component.ActiveMQComponent">
    <property name="configuration" ref="jmsConfiguration"/>
  </bean>
```

## Add the pooled routes

```
    <route>
      <from uri="activemq-pool:queue:CAMEL.1"/>
      <to uri="activemq-pool:queue:CAMEL.2"/>
    </route>
```

## Run the project 

Now run the skeleton project using the following commands. 

```
mvn install
mvn camel:run
```
