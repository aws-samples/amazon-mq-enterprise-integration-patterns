# Integrate IBM MQ with Amazon MQ

## Setup

IBM provides a [developer edition](https://developer.ibm.com/messaging/mq-downloads/) of its WebsphereMQ messaging service. Some host systems such as Linux require specific [kernel settings](https://www.ibm.com/support/knowledgecenter/SSFKSJ_8.0.0/com.ibm.mq.ins.doc/q008550_.htm). Please make sure kernel settings are in place before proceeding with installation. 

Follow the [installation instructions](https://www.ibm.com/support/knowledgecenter/en/SSFKSJ_8.0.0/com.ibm.mq.ins.doc/q008640_.htm) to install IBM MQ on EC2. For development purposes, you may chose to turn off [channel auth](https://www-01.ibm.com/support/docview.wss?uid=swg21577137) settings. Enable administration of MQ via [MQExplorer](https://www-01.ibm.com/support/docview.wss?uid=swg21623113).

## What are we doing?

We will integrate IBM MQ with AmazonMQ using Camel Spring DSL. This integration can be added to the project independently of other integrations.

## Add the IBM MQ dependencies to maven

Change version tag that matches the IBM install. 

```
    <dependency>
        <groupId>com.ibm.mq</groupId>
        <artifactId>com.ibm.mq.allclient</artifactId>
        <version>9.1.0.0</version>
    </dependency>
```

## Add IBM MQ bean configuration

```
	<bean id="ibmmqConnectionFactory" class="com.ibm.mq.jms.MQConnectionFactory">
		<property name="transportType" value="1" />
		<property name="hostName" value="${ibmmq.host}" />
		<property name="port" value="${ibmmq.port}" />
		<property name="queueManager" value="${ibmmq.qmname}" />
	</bean>

	<bean id="ibmmqConfig" class="org.apache.camel.component.jms.JmsConfiguration">
		<property name="connectionFactory" ref="ibmmqConnectionFactory" />
		<property name="concurrentConsumers" value="10" />
	</bean>

	<bean id="ibmmq" class="org.apache.camel.component.jms.JmsComponent">
		<property name="configuration" ref="ibmmqConfig" />
	</bean>
```

Add the following to ~/environment/router/main/resources/secrets.properties 

```
ibmmq.host=<hostname>
ibmmq.port=<port>
ibmmq.qmname=<QueueManager name>
```

## Add a route

When sending messages to IBM, remove the JMS headers. The JMS headers are set by IBM libraries before writing to a queue or topic.

```
    <route>
      <from uri="activemq:queue:CAMEL.1"/>
      <removeHeaders pattern="JMS*"/>
      <to uri="ibmmq:queue:AMQ_TO_IBMMQ"/>
    </route> 
```

## Run the project 

Now run the project using the following commands. 

```
export CAMEL_MASTER_PASSWORD=<Password supplied by host>
mvn install
mvn camel:run
```

