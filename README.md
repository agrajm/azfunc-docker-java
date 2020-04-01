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

Once the local setup works correctly, we need to setup Function App & configure the Application Settings with connection strings for EventHub & Cosmos
```
./function-app-settings.sh
```
