# Amazon MQ Enterprise Integration Patterns 

## Overview

This is a reInvent 2019 Builder's session (ARC-322) that provides a hands-on introduction to building enterprise integration patterns using Apache Camel and Amazon MQ.

The labs help participants gain knowledge in using Apache Camel in a structured appraach for their projects and in deploying the applications at scale.

## Introduction

Enterprises use messaging services as a backbone for integrating disparate systems and services. Most of these messaging systems are proprietary techonolgies, but many open source messaging systems are gaining popularity. The most notable open source messaging systems are ActiveMQ and RabbitMQ.

In addition to messaging systems, there is also a need for software to integrate various applications that use messaging. Apache Camel is one of the most popular and robust technology platform that offers seamless integration with different messaging systems, databases, and cloud services.

Application integration has been a challenge for many architects and developers. Architectural patterns such as [Enterprise Integration Patterns](https://www.enterpriseintegrationpatterns.com/) are of great help in promoting consistency, managing technical dept, and increasing software reuse.

## Concepts

[Amazon MQ](https://aws.amazon.com/amazon-mq/) is an ActiveMQ-based managed messaging service. For the ARC322 builder session, you will use Amazon MQ to build your use case. You would need to understand how to login to ActiveMQ console. This [simple tutorial](https://master.d1l1ei0bin3mnd.amplifyapp.com/failover/failover-step-1.html) will help you get started.

The user-id and password for the ActiveMQ console are **workshopUser**. Once logged in you would need to create the needed queues for implementing your use case.

The following queues were already created for you:

| Queue Name  | Purpose |
| ------------- | ------------- |
| CLIENT.A.ORDERS  | Queue where you receive orders from client A  |
| CLIENT.A.TRADES | Queue where client A receives their trades |
| CLIENT.B.ORDERS  | Queue where you receive orders from client B  |
| CLIENT.B.TRADES | Queue where client B receives their trades |
| US.ORDERS  | Orders destined for US Exchanges  |
| CA.ORDERS  | Orders destined for Canadian Exchanges  |
| US.TRADES  | Trades from US Exchanges  |
| CA.TRADES  | Trades from Canadian Exchanges  |

### Use Case

![Use Case](/images/sample-usecase.png)

The use case implements a content based router using Apache Camel and Amazon MQ. In this example, you are tasked to build a SaaS service for a stock brokerage firm. The service you are building takes stock orders in XML format into each client's queue. If the orders contains a destination such as US or Canada, your router application copies the order messages to a destination queue. The detination queue essentially is a single service queue in your SaaS application. This queue pools orders from different clients and sends them to an exchange. When the exchange fills the order, the trade messages would need to route back to an individual client's trade queues.

In the current session, you will be building the Router application. Labs 1 and 2 teach you how to set up a skeleton application, and Lab 3 provides you a framework for building the use case.

## Lab Guide

### :white_check_mark: Prerequisites

The steps detailed here are only when you are exploring the labs in your own account. If you are running the labs as part of an event the prerequisites are optional. Please check with your event organizer.

* Go to the AWS console and go to CloudFormation.
* Create a new stack using the template provided in `cloudformation/workshop.yaml`.
    * You can give the stack any name you like.
    * Leave other options at default values.

Each lab and the additional integrations all follow 4 simple steps. 

* Add camel component dependencies.
* Add a bean to configure the component.
* Add a simple route as an example.
* Run the project to view the results.

### Labs

* **[Lab 1: Create and run a skeleton Apache Camel java project](/labs/lab-1.md)** - In this Lab you will explore how to start a new Camel Java project and run it. 
* **[Lab 2: Integrate Broker endpoints and test](/labs/lab-2.md)** - In this Lab you will explore how to add broker endpoints, send/receive messages to get familiar with Spring DSL.
* **[Lab 3: Implement an example route](/labs/lab-3.md)** - In this lab you will add a simple route that helps you to set the stage for sample use case.
* **[Solution: Fully immplemented sample use case](/labs/solution.md)** - Solution for the use case in the builders session.

### Examples (Optional)

* **[Encrypting configuration settings](/labs/encrypt.md)** - Encrypting configuration settings such as passwords, accessKey, secretKeyId etc.
* **[Connection Pooling](/labs/pooled.md)** - Example of AmazonMQ PooledConnectionFactory 
* **[AWS/SQS: Integrate AmazonSQS with AmazonMQ](/labs/sqs.md)** - This lab provides details on how to integrate different AWS services with AmazonMQ.
* **[TIBCO EMS: Integrate TIBCO EMS into Camel project](/labs/tibco.md)** - This optional lab can be run as a standalone for integrating TIBCO EMS with Amazon MQ.
* **[IBM WebsphereMQ: Integrate IBM MQ into Camel project](/labs/ibmmq.md)** - This optional lab can be run as a standalone for integrating IBM MQ with Amazon MQ.
* **[ECS/Fargate: Running Camel inegrations at scale using containers](/labs/fargate.md)** - Running camel sping integration containers at scale using Fargate.
* **[JMX Integration](/labs/jmx.md)** - Enabling JMX for your project and viewing metrics.



