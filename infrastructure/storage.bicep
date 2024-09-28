// Input param
@description('The name of the storage account to create.')
param storageAccountName string

@description('The location where the storage account will be created.')
param location string = resourceGroup().location

@description('The name of the index document for the static website.')
param indexDocument string = 'index.html'

@description('The name of the error document for the static website.')
param errorDocument string = '404.html'

// Resource definition
resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    staticWebsite: {
      enabled: true
      indexDocument: indexDocument
      error404Document: errorDocument
    }
  }
}

// Output
output staticWebsitePrimaryEndpoint string = storageAccount.properties.primaryEndpoints.web
output storageAccountId string = storageAccount.id
output storageAccountName string = storageAccount.name
