# Use Case 

This lab implements one possible solution for the use case in the builder session. In the use case, the inputs (client order entry) and outputs (exchange trade entry) are left open to your imagination. In order to get the entire solution implemented within an hour, you could use a simple XML file as input for both order and trade entry. An example in Lab 3 demonstrates reading from file and making decision based on contents of the file.

## Setup

You should have completed the Labs 1 and 2. Run the following commands to copy the data files to your project.

```
cd ~/environment/arc322
cp -r ~/environment/arc322/data/orders ./router/src/data
cp -r ~/environment/arc322/data/templates ./router/src/data
```

In ./router/src/data, you would find orders directory and a templates directory. The router project you are building reads data from orders directory.

Each file in orders directory represents a unique order for a given client. You were also provided two templates in templates directory.If you want to enter a US order, cp orderUS.xml for a Canadian order, cp orderCA.xml. Feel free to change the data in xml file to change client field as needed.

Run the following commands for each order. Remember to replace N with a number.

```
cd ~/environment/arc322/data/templates
cp orderUS.xml ../orders/orderN.xml
```

## Route implementation

```
    <!-- When a new file copied to data/orders directory, put the contents of file into client A or client B order queues -->
    <route>
      <from uri="file:src/data/orders?noop=true"/>
       <choice>
        <when>
          <xpath>/order/client = 'A'</xpath>
          <log message="Order for client A"/>
          <to uri="activemq:queue:CLIENT.A.ORDERS"/>
        </when>
        <when>
          <xpath>/order/client = 'B'</xpath>
          <log message="Order for client B"/>
          <to uri="activemq:queue:CLIENT.B.ORDERS"/>
        </when>        
        <otherwise>
          <log message="Invalid client id"/>
        </otherwise>
      </choice>     
    </route>
    
    <!-- When a message appears on CLIENT A or B order queue check country and move the message to US or CA exchange queues --> 
    <route>
      <from uri="activemq:queue:CLIENT.A.ORDERS"/>
      <from uri="activemq:queue:CLIENT.B.ORDERS"/>
       <choice>
        <when>
          <xpath>/order/country = 'US'</xpath>
          <log message="Order for client A and country US"/>
          <to uri="activemq:queue:US.ORDERS"/>
        </when>
        <when>
          <xpath>/order/country = 'CA'</xpath>
          <log message="Order for client A and country CA"/>
          <to uri="activemq:queue:CA.ORDERS"/>
        </when>        
        <otherwise>
          <log message="Invalid country id"/>
        </otherwise>
      </choice>     
     </route>   
     
    <route>
      <from uri="activemq:queue:US.ORDERS"/>
      <from uri="activemq:queue:CA.ORDERS"/>
      <to uri="xslt:order2trade.xsl"/>
      <multicast>
          <to uri="direct:fillOrders"/>
          <to uri="direct:sendTrades"/>
      </multicast>
   </route>  
   
   <route>
    <from uri="direct:fillOrders"/>
       <choice>
        <when>
          <xpath>/trade/country = 'US'</xpath>
          <log message="Trade for client A and country US"/>
          <to uri="activemq:queue:US.TRADES"/>
        </when>
        <when>
          <xpath>/order/country = 'CA'</xpath>
          <log message="Trade for client A and country CA"/>
          <to uri="activemq:queue:CA.TRADES"/>
        </when>        
        <otherwise>
          <log message="Invalid country id"/>
        </otherwise>
      </choice>        
   </route>
   
   <route>
    <from uri="direct:sendTrades"/>
       <choice>
        <when>
          <xpath>/trade/client = 'A'</xpath>
          <log message="Trade for client A and country US"/>
          <to uri="activemq:queue:CLIENT.A.TRADES"/>
        </when>
        <when>
          <xpath>/trade/client = 'B'</xpath>
          <log message="Trade for client A and country CA"/>
          <to uri="activemq:queue:CLIENT.B.TRADES"/>
        </when>        
        <otherwise>
          <log message="Invalid client id"/>
        </otherwise>
      </choice>        
   </route>    
```

