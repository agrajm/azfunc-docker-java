# azfunc-docker-java
Azure Functions Docker for Java

Sample Azure Function getting triggered using an Event Hub & Writing to Cosmos DB using Output Bindings

# Setup
Execute the script `setup-env.sh` to setup the required Azure resources
```
./setup-env.sh
```

Now build and run the docker image
```
docker build -t agrajm/azure-functions-java:1.0 .
...
docker run agrajm/azure-functions-java:1.0
```
