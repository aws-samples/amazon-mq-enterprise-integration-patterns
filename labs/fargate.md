# Running Camel integrations in ECS/Fargate

## Setup

The Labs 1, 2, 3 demonstrate how to start a basic Camel Spring DSL project and add simple integrations. This lab extends the knowledge you gained in the previous labs.

## What are we doing?

In this bonus lab, you will take the Camel project, containerize the application and run it in a ECS/Fargate cluster.

## Create an ECR repository 

```
$(aws ecr get-login --no-include-email --region <region>)
aws ecr create-repository --repository-name <repository name>
```

## Containerize the application

Add the following lines to a file named Dockerfile in ```~/environment/arc322```.

```
FROM maven:3.6-amazoncorretto-8
ADD router /root/router
ADD lib /root/lib
RUN cd /root/router && mvn clean install
```

Note: If you want to run TIBCO EMS integration, then you must add the maven command to register the tibjms.jar. In that case the Dockerfile would be as shown below.

```
FROM maven:3.6-amazoncorretto-8
ADD router /root/router
ADD lib /root/lib
RUN mvn install:install-file -Dfile=/root/lib/tibjms.jar -DgroupId=com.tibco -DartifactId=tibjms -Dversion=8.5 -Dpackaging=jar && cd /root/router && mvn clean install
```

Build the container using the following command.

```
cd ~/environment/arc322
docker build -t <repository name> .
```

## Push the image to ECR 

```
docker tag router:latest 1234567890123.dkr.ecr.us-east-1.amazonaws.com/<repository name>:latest
docker push 1234567890123.dkr.ecr.us-east-1.amazonaws.com/<repository name>:latest
```

## Create an ECS/Fargate cluster

If you already have an ECS/Fargate cluster you can use it. If not, the following steps help you to create one. Please note: All parameters that you need to supply are marked with angle brackets.

### Create task execution role

The task-execution-assume-role.json file was provided to you. The role name is ecsTaskExecutionRole

```
aws iam --region us-east-1 create-role --role-name ecsTaskExecutionRole --assume-role-policy-document file://task-execution-assume-role.json
```

### Attach any policies you need

Add AmazonECSTaskExecutionRolePolicy managed policy and add any other services you need.

```
aws iam --region us-east-1 attach-role-policy --role-name ecsTaskExecutionRole --policy-arn arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy
```

### Create cluster

Create a cluster 

```
aws ecs create-cluster --cluster-name <cluster-name>
```

### Create a task definition.

A sample task definition is provided in the lab. See task-definition.json. Please replace the 1234567890123 with a valid AWS account number.

```
aws ecs register-task-definition --cli-input-json file://task-definition.json
```

### Run task

Task definition in the parameter --task-definition should be in the format <task>:<revision>. Each time you change the task definition, by running the above command, would increment the revision. If the subnets provided below are public subnets, then you must set the assignPublicIp ENABLED.

```
aws ecs run-task --cluster <cluster name> --task-definition <task>:<revision> --launch-type "FARGATE" --network-configuration "awsvpcConfiguration={subnets=[subnet-1234,subnet-4567],securityGroups=[sg-1234],assignPublicIp=ENABLED}"
```
