param environmentType string
param client string
param location string
param tags object
@description('The language worker runtime to load in the function app')
@allowed([ 'dotnet' ])
param runtime string = 'dotnet'
param asp_id1 string
param storageAccountName1 string
param serviceBusQueueName string
param serviceBusNamespaceName string
param instrumentationKey string

var servicebusFunc = 'func-${environmentType}-servicebus-${client}'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: storageAccountName1
}

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2022-01-01-preview' existing = {
  name: serviceBusNamespaceName
}

var serviceBusEndpoint = '${serviceBusNamespace.id}/AuthorizationRules/RootManageSharedAccessKey'
var serviceBusConnectionString = listKeys(serviceBusEndpoint, serviceBusNamespace.apiVersion).primaryConnectionString

resource functionApp 'Microsoft.Web/sites@2022-09-01' = {
  name: servicebusFunc
  location: location
  tags: tags
  kind: 'functionapp'
  properties: {
    serverFarmId: asp_id1
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value};EndpointSuffix=${environment().suffixes.storage}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageAccount.name};AccountKey=${storageAccount.listKeys().keys[0].value};EndpointSuffix=${environment().suffixes.storage}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower(servicebusFunc)
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: instrumentationKey
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: runtime
        }
        {
          name: 'Servicebus_ConnectionString'
          value: serviceBusConnectionString
        }
        {
          name: 'Servicebus_QueueName'
          value: serviceBusQueueName
        }
      ]
      ftpsState: 'FtpsOnly'
      minTlsVersion: '1.2'
    }
    httpsOnly: true
  }
}

output function_app_name string = functionApp.name
