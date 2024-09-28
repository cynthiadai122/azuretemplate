@description('The username of the sql server admin')
param sqlUsername string = 'sqladmin'

@secure()
@description('The password of the sql server admin')
param sqlPassword string

param utc_now string = utcNow('u')
var randomString = take(uniqueString(resourceGroup().id, deployment().name), 8)
var storageAccountName = 'stg${randomString}'
var appServicePlanName = 'ap${randomString}'
var webappName = 'api${randomString}'
var databaseName = 'testdb'
var sqlServerName = 'sqlsv${randomString}'

var resourceCommonTags = {
  createdby: 'Patrick'
  createdDate: utc_now
 }

module storageModule 'storage.bicep' = {
  name: 'storageModule'
  params: {
    storageAccountName: storageAccountName
    location: resourceGroup().location
    indexDocument: 'index.html'
    errorDocument: 'index.html'
  }
}

module sqlModule 'sqldatabase.bicep' = {
  name: 'sqlModule'
  params: {
     administratorLogin: sqlUsername
     administratorPassword: sqlPassword
     databaseName: databaseName
     sqlServerName: sqlServerName
     databaseEdition: 'Basic'
     databaseServiceObjective: 'Basic'
     location: resourceGroup().location
     tags: resourceCommonTags
  }
}

module webappModule 'webapp.bicep' = {
  name: 'webappModule'
  params: {
   sqlServerName: sqlServerName
   sqlDatabasename: databaseName
   administratorLogin: sqlUsername
   administratorPassword: sqlPassword
   appServicePlanName: appServicePlanName
   webAppName: webappName
   dotNetVersion: 'DOTNETCORE|8.0'
   location: resourceGroup().location
   skuName: 'B1'
   tags: resourceCommonTags 
  }
}

output storageAccountId string = storageModule.outputs.storageAccountId
output storageAccountName string = storageModule.outputs.storageAccountName
output webAppEndpoint string = webappModule.outputs.webAppEndpoint
output webAppId string = webappModule.outputs.webAppId
output appServicePlanId string = webappModule.outputs.appServicePlanId
