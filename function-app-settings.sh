#!/bin/bash
LOCATION=eastus
RESOURCE_GROUP="azfuncapp$LOCATION"
EVENT_HUB_NAMESPACE="evhubnsazfunc$LOCATION"
EVENT_HUB_NAME="evhubazfunc$LOCATION"
EVENT_HUB_AUTHORIZATION_RULE=evhubauthrule
COSMOS_DB_ACCOUNT="cosmosdbazfunc$LOCATION"
STORAGE_ACCOUNT="stgaccazfunc$LOCATION"
FUNCTION_APP="funcappazfunc$LOCATION"

az functionapp create \
    --resource-group $RESOURCE_GROUP \
    --name $FUNCTION_APP \
    --storage-account $STORAGE_ACCOUNT \
    --consumption-plan-location $LOCATION \
    --runtime java

echo "Get the storage account, cosmos & eventhub connection details"

AZURE_WEB_JOBS_STORAGE=$( \
    az storage account show-connection-string \
        --name $STORAGE_ACCOUNT \
        --query connectionString \
        --output tsv)
echo "Storage account details"
echo $AZURE_WEB_JOBS_STORAGE
EVENT_HUB_CONNECTION_STRING=$( \
    az eventhubs eventhub authorization-rule keys list \
        --resource-group $RESOURCE_GROUP \
        --name $EVENT_HUB_AUTHORIZATION_RULE \
        --eventhub-name $EVENT_HUB_NAME \
        --namespace-name $EVENT_HUB_NAMESPACE \
        --query primaryConnectionString \
        --output tsv)
echo "Event hub conn string"
echo $EVENT_HUB_CONNECTION_STRING

COSMOS_DB_CONNECTION_STRING=$( \
    az cosmosdb keys list \
        --resource-group $RESOURCE_GROUP \
        --name $COSMOS_DB_ACCOUNT \
        --type connection-strings \
        --query connectionStrings \
        | jq -r '.[0].connectionString')

echo "cosmos db conn string"
echo $COSMOS_DB_CONNECTION_STRING

az functionapp config appsettings set \
    --resource-group $RESOURCE_GROUP \
    --name $FUNCTION_APP \
    --settings \
        AzureWebJobsStorage=$AZURE_WEB_JOBS_STORAGE \
        EventHubConnectionString=$EVENT_HUB_CONNECTION_STRING \
        CosmosDBConnectionString=$COSMOS_DB_CONNECTION_STRING
