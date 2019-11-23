# Lab 3: Implement a sample route

## Prerequisites

You must have completed Lab-2 successfully. Each lab builds on the previous lab. 

```
cd ~/environment/amazon-mq-enterprise-integration-patterns/router
```

## What are we doing?

The Labs 1 and 2 demonstrated and provided you the scaffolding for implementing the "Content Based Router" integration pattern. This provides you sample code excerpts that you can use to build the router application.

## Example routes

### Example makes a decision based on contents of the message.

You might have noticed the following example route that was created for you in Lab 1. Essentially the following route takes reads xml files in src/data, looks at the content and if city in the data contains "London", performs one action, a different action otherwise.

```
      <from uri="file:src/data?noop=true"/>
      <choice>
        <when>
          <xpath>/person/city = 'London'</xpath>
          <log message="UK message"/>
          <to uri="file:target/messages/uk"/>
        </when>
        <otherwise>
          <log message="Other message"/>
          <to uri="file:target/messages/others"/>
        </otherwise>
      </choice>
    </route>
```

## Run the project 

Now run the skeleton project using the following commands. 

```
mvn install
mvn camel:run
```

That's it!!! for Lab 3. Congratulations on completing Lab 3. Now you can start implementing the use case. See [fully implemented solution](solution.md) for one way to implement. Not necessarily the only way!! 
