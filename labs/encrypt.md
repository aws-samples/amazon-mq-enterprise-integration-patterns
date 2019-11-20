# Encrypting configuration settings

Often, you would need to include sensistive configuration settings in your properties file. Apache Camel includes camel-jasypt component to decrypt encrypted properties.

## Setup

>The setup.sh script takes an optional string as a parameter and encrypts all parameters and creates secrets.properties file in ~/environment/amazon-mq-enterprise-integration-patterns. For example, if you run setup.sh above as follows, the broker parameters are all encrypted using the example master password: password. 

```
cd ~/environment/amazon-mq-enterprise-integration-patterns
./setup.sh password
```

>A seperate crypt.sh script provided to encrypt specific parts of a properties file.

```
cd ~/environment/amazon-mq-enterprise-integration-patterns
./crypt.sh encrypt <password> <string to encrypt>
./crypt.sh decrypt <password> <string to decrypt>
```

>Setting the CAMEL_MASTER_PASSWORD is optional if you haven't encrypted the properties. If you did ```export CAMEL_MASTER_PASSWORD=<password>``` before running the following commands.
