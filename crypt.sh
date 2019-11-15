#!/bin/bash
masterPassword=${2:-none}
if [ "$masterPassword" != "none" ]; 
then
cd ~/environment/arc322/lib
echo `java -cp jasypt-1.9.2.jar:camel-jasypt-2.24.2.jar org.apache.camel.component.jasypt.Main -c $1 -p $masterPassword -i $3` | cut -d':' -f2 | sed -e 's/^[[:space:]]*//'
fi