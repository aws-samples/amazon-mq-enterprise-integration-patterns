#!/bin/bash
masterPassword=${1:-none}
workshopDir=amazon-mq-enterprise-integration-patterns

cd ~/environment

if command -v jq > /dev/null 2>&1; then
  echo "jq already exists.."
else
  echo "Installing jq..."
  sudo yum install -y jq > /dev/null 2>&1
fi

java_version=`java -version |& awk -F '"' '/version/ {print $2}'`
if [[ "$java_version" =~ .*1\.8.*  ]]; then
    echo "Java is up to date"
else 
    echo "Updating java to 1.8"
    wget https://d3pxv6yz143wms.cloudfront.net/8.222.10.1/java-1.8.0-amazon-corretto-devel-1.8.0_222.b10-1.x86_64.rpm > /dev/null 2>&1
    sudo yum localinstall -y java-1.8.0-amazon-corretto-devel-1.8.0_222.b10-1.x86_64.rpm > /dev/null 2>&1
fi

echo "export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which javac))))" >> ~/.bashrc
source ~/.bashrc

mvn_version=`mvn -version |& awk '/Apache Maven/ {print $3 }'`
if [[ "$mvn_version" =~ .*3\.6.* ]]; then
    echo "Maven is up to date"
else 
    echo "Updating maven to 3.6"
    wget http://mirror.cc.columbia.edu/pub/software/apache/maven/maven-3/3.6.1/binaries/apache-maven-3.6.1-bin.tar.gz > /dev/null 2>&1
    tar zxvf apache-maven-3.6.1-bin.tar.gz > /dev/null 2>&1
    echo "export PATH=~/environment/apache-maven-3.6.1/bin:$PATH" >> ~/.bashrc
fi
echo "Getting broker urls..."
brokerId=`aws mq list-brokers | jq '.BrokerSummaries[] | select(.BrokerName=="Broker") | {id:.BrokerId}' | grep "id" | cut -d '"' -f4`
url=`aws mq describe-broker --broker-id=$brokerId | jq '.BrokerInstances[].Endpoints[0]' | xargs -n 2 | awk '{ print "failover:("$1","$2")" }'`
echo "Accessing parameter store..."
userPassword=`aws ssm get-parameter --name "MQBrokerUserPassword" |& grep "Value\|ParameterNotFound"`
if [[ $userPassword =~ .*ParameterNotFound.* ]];
then
    echo "Unable to obtain parameters from SSM. Most likely you are running this script outside of workshop."
else
    brokerUser=`echo $userPassword | sed 's/"//g' | sed 's/Value://g' | cut -d',' -f1 | sed 's/ //g'`
    brokerPassword=`echo $userPassword | sed 's/"//g' | sed 's/Value://g' | cut -d',' -f2`
fi
echo "Creating and Encrypting properties"
if [ "$masterPassword" != "none" ]; 
then
    encUrl=`~/environment/$workshopDir/crypt.sh encrypt $masterPassword $url`
    encUser=`~/environment/$workshopDir/crypt.sh encrypt $masterPassword $brokerUser`
    encPswd=`~/environment/$workshopDir/crypt.sh encrypt $masterPassword $brokerPassword`
    encUrl="ENC(${encUrl})"
    encUser="ENC(${encUser})"
    encPswd="ENC(${encPswd})"
else 
    encUrl=$url
    encUser=$brokerUser
    encPswd=$brokerPassword
fi
echo "broker.brokerURL=${encUrl}" >> ~/environment/$workshopDir/secrets.properties
echo "broker.username=${encUser}" >> ~/environment/$workshopDir/secrets.properties
echo "broker.password=${encPswd}" >> ~/environment/$workshopDir/secrets.properties

mkdir lib; cd lib
wget https://repo1.maven.org/maven2/org/jasypt/jasypt/1.9.2/jasypt-1.9.2.jar 
wget https://repo1.maven.org/maven2/org/apache/camel/camel-jasypt/2.24.2/camel-jasypt-2.24.2.jar

cd ~/environment
