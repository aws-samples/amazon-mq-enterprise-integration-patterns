# Tips, Tricks and Gotchas

## Performance Metrics

Apache Camel includes a metrics component, that collects metrics on route performance. These metrics can be accessed via JMX. 

### Dependencies

Add the following dependency to your pom.xml
```
    <dependency>
        <groupId>org.apache.camel</groupId>
        <artifactId>camel-metrics</artifactId>
        <version>2.24.2</version>
    </dependency>  
```

### Bean configuration

Add a policy bean to turn on JMX. The beans must be configured in the beans section.

```
        <bean id="policy" class="org.apache.camel.component.metrics.routepolicy.MetricsRoutePolicy">
          <property name="useJmx" value="true"/>
          <property name="prettyPrint" value="true"/>
        </bean>
```

### Route configuration

For each route that you want to collect metrics, add the routepolicyRef as shown below. Add the routes in comel conext.


```
<jmxAgent id="agent" createConnector="true"/>
```

```
      <route routePolicyRef="policy">        

      </route> 
```

### View metrics

In order to view metrics, you would need a JMX client such as jconsole. Alternatively, you could use jmxterm to access the metrics using CLI. You will see how to use jmxterm to view metrics below.

Download jmxterm from : https://docs.cyclopsgroup.org/jmxterm 

```
java -jar jmxterm-1.0.0-uber.jar
$>open  service:jmx:rmi:///jndi/rmi://<ip address>:1099/jmxrmi/camel 
$>domain org.apache.camel.metrics
$>get -i *
```

## hawtio integration

hawtio is a modular web console for Java applications. Embedding hawtio console within a Camel application and monitoring would be super easy.

### Plugin

Add the following to plugins section in Camel application pom.xml

```
      <plugin>
        <groupId>io.hawt</groupId>
        <artifactId>hawtio-maven-plugin</artifactId>
        <version>2.8.0</version>
        <configuration>
          <logClasspath>true</logClasspath>
          <port>8292</port>
        </configuration>
      </plugin> 
```

In order to run the Camel app with hawtio embedded, run the following commands.

```
mvn install
mvn io.hawt:hawtio-maven-plugin:2.8.0:camel
```
