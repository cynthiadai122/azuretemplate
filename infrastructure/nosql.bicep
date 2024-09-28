@description('The name of the Cosmos DB account.')
param cosmosDbAccountName string

@description('The location for the Cosmos DB account.')
param location string = resourceGroup().location

@description('The name of the Cosmos DB database.')
param cosmosDbDatabaseName string

@description('The name of the Cosmos DB container.')
param cosmosDbContainerName string

@description('The partition key path for the Cosmos DB container.')
param partitionKeyPath string = '/partitionKey'

@description('The throughput for the Cosmos DB container (Request Units per second).')
param throughput int = 400

@description('The default consistency level for the Cosmos DB account.')
param consistencyLevel string = 'Session'

@description('Tags to assign to the Cosmos DB account.')
param tags object = {}

resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2024-05-15' = {
  name: cosmosDbAccountName
  location: location
  kind: 'GlobalDocumentDB'
  properties: {
    consistencyPolicy: {
      defaultConsistencyLevel: consistencyLevel
    }
    locations: [
      {
        locationName: location
        failoverPriority: 0
      }
    ]
    databaseAccountOfferType: 'Standard'
  }
  tags: tags
}

resource cosmosDbDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2021-04-15' = {
  parent: cosmosDbAccount
  name: cosmosDbDatabaseName
  properties: {
    resource: {
      id: cosmosDbDatabaseName
    }
  }
}

resource cosmosDbContainer 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2021-04-15' = {
  parent: cosmosDbDatabase
  name: cosmosDbContainerName
  properties: {
    resource: {
      id: cosmosDbContainerName
      partitionKey: {
        paths: [partitionKeyPath]
        kind: 'Hash'
      }
    }
    options: {
      throughput: throughput
    }
  }
}

output cosmosDbEndpoint string = cosmosDbAccount.properties.documentEndpoint
output cosmosDbPrimaryKey string = listKeys(cosmosDbAccount.id, '2021-04-15').primaryMasterKey
