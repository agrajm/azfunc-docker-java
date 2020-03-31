#!/bin/bash
LOCATION=eastus
RESOURCE_GROUP="azfuncapp$LOCATION"
EVENT_HUB_NAMESPACE="evhubnsazfunc$LOCATION"
EVENT_HUB_NAME="evhubazfunc$LOCATION"
EVENT_HUB_AUTHORIZATION_RULE=evhubauthrule
COSMOS_DB_ACCOUNT="cosmosdbazfunc$LOCATION"
STORAGE_ACCOUNT="stgaccazfunc$LOCATION"
FUNCTION_APP="funcappazfunc$LOCATION"

echo "Creating Resource Group"

az group create \
    --name $RESOURCE_GROUP \
    --location $LOCATION

echo "Creating Event Hub Namespace, Event Hub and Authorization Rule"

az eventhubs namespace create \
    --resource-group $RESOURCE_GROUP \
    --name $EVENT_HUB_NAMESPACE
az eventhubs eventhub create \
    --resource-group $RESOURCE_GROUP \
    --name $EVENT_HUB_NAME \
    --namespace-name $EVENT_HUB_NAMESPACE \
    --message-retention 1
az eventhubs eventhub authorization-rule create \
    --resource-group $RESOURCE_GROUP \
    --name $EVENT_HUB_AUTHORIZATION_RULE \
    --eventhub-name $EVENT_HUB_NAME \
    --namespace-name $EVENT_HUB_NAMESPACE \
    --rights Listen Send

echo "Creating Cosmos DB Account, Database & Collection"

az cosmosdb create \
    --resource-group $RESOURCE_GROUP \
    --name $COSMOS_DB_ACCOUNT
 az cosmosdb sql database create \
    --resource-group $RESOURCE_GROUP \
    --account-name $COSMOS_DB_ACCOUNT \
    --name TelemetryDb
az cosmosdb sql container create \
    --resource-group $RESOURCE_GROUP \
    --account-name $COSMOS_DB_ACCOUNT \
    --name TelemetryInfo \
    --database-name TelemetryDb \
    --partition-key-path '/temperatureStatus'

echo "Create Stroage Account Required by Azure Functions App"
az storage account create \
    --resource-group $RESOURCE_GROUP \
    --name $STORAGE_ACCOUNT \
    --sku Standard_LRS