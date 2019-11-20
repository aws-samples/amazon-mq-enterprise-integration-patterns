# Lab 1: Create and run a skeleton Apache Camel Spring XML project

You will run this lab in the Cloud 9 IDE created for you.  You can find this by going to the Cloud 9 console and finding the environment named `IDE`.

## Setup

Run the following commands in a terminal window in your Cloud 9 IDE to update Java to version 1.8 and install maven and jq.

```
cd ~/environment/amazon-mq-enterprise-integration-patterns
./setup.sh 
source ~/.bashrc
```

>The setup.sh script takes an optional string as a parameter and encrypts all parameters and creates secrets.properties file in ~/environment/amazon-mq-enterprise-integration-patterns. For example, if you run setup.sh above as follows, the broker parameters are all encrypted using the example master password: password. For this session, we will use un-encrypted properties.

```
./setup.sh password
```

## What are we doing?

In order for you to build the example use case that was presented in the slide deck, you need some basic project structure and a set of tools. In this lab, you will learn how to start an integration project from scratch. 

## Create a skeleton project

Run the following command which creates a skeleton project for you.

```
mvn archetype:generate -DarchetypeGroupId=org.apache.camel.archetypes -DarchetypeArtifactId=camel-archetype-spring -DarchetypeVersion=2.24.2 -DgroupId=com.example -DartifactId=router
```
Just press enter for two prompts accepting default values.

Copy the secrets.properties file from ~/environment/amazon-mq-enterprise-integration-patterns to ~/environment/amazon-mq-enterprise-integration-patterns/router/src/main/resources

```
cp ~/environment/amazon-mq-enterprise-integration-patterns/secrets.properties ~/environment/amazon-mq-enterprise-integration-patterns/router/src/main/resources
cp ~/environment/amazon-mq-enterprise-integration-patterns/data/templates/order2trade.xsl ~/environment/amazon-mq-enterprise-integration-patterns/router/src/main/resources 
```

Note: If you changed the artifactId in the mvn archetype command, then replace router in the above command with that name.

## Add dependencies

Our project depends on various java libraries to run. These dependencies are managed by Maven. Add the following lines to ```pom.xml`` file in the ```<dependencies>``` block.

```
    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-jasypt</artifactId>
        <version>2.24.2</version>
    </dependency> 
```

## Add properties bean and enable encryption

Add the following lines to ```router/src/main/resources/META-INF/spring/camel-context.xml``` under ```<beans>``` 


```
        <!-- define the jasypt properties parser with the given password to be used -->
        <bean id="jasypt" class="org.apache.camel.component.jasypt.JasyptPropertiesParser">
            <property name="password" value="sysenv.CAMEL_MASTER_PASSWORD"/>
        </bean>
        
        <bean id="bridgePropertyPlaceholder" class="org.apache.camel.spring.spi.BridgePropertyPlaceholderConfigurer">
        <property name="location" value="classpath:secrets.properties"/>
        <property name="parser" ref="jasypt"/>
        </bean>
  
        <!-- define the camel properties component -->
        <bean id="properties" class="org.apache.camel.component.properties.PropertiesComponent">
            <!-- the properties file is in the classpath -->
            <property name="location" value="classpath:secrets.properties"/>
            <!-- and let it leverage the jasypt parser -->
            <property name="propertiesParser" ref="jasypt"/>
        </bean>  
```

## Run the skeleton project 

Now run the skeleton project using the following commands. You will be repeating the following two commands for testing our changes.

>Setting the CAMEL_MASTER_PASSWORD is optional if you haven't encrypted the properties. If you did ```export CAMEL_MASTER_PASSWORD=<password>``` before running the following commands.

```
cd router
mvn install
mvn camel:run
```

That's it for Lab 1. Now you can start Lab 2.
