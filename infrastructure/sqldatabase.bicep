@description('The name of the SQL Server.')
param sqlServerName string

@description('The administrator username for the SQL Server.')
param administratorLogin string

@secure()
@description('The administrator password for the SQL Server.')
param administratorPassword string

@description('The name of the SQL Database.')
param databaseName string

@description('The edition of the SQL Database. Example: Basic, Standard, Premium')
param databaseEdition string = 'Basic'

@description('The compute size for the SQL Database. Example: S0, P1, Basic')
param databaseServiceObjective string = 'Basic'

@description('The location for the resources.')
param location string = resourceGroup().location

@description('Tags to assign to the resources.')
param tags object = {}

resource sqlServer 'Microsoft.Sql/servers@2023-08-01-preview' = {
  name: sqlServerName
  location: location
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorPassword
  }
  tags: tags
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2022-02-01-preview' = {
  name: '${sqlServer.name}/${databaseName}'
  location: location
  properties: {
    sku: {
      name: databaseServiceObjective
      tier: databaseEdition
    }
  }
  tags: tags
}

output sqlServerFqdn string = sqlServer.properties.fullyQualifiedDomainName
output sqlDatabaseName string = sqlDatabase.name
