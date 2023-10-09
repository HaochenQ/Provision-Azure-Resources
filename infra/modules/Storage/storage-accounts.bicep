param location string
param resourceNameSuffix string
param storageAccountType string
param tags object
param storageAccountKind string

var storageAccountName = 'function${resourceNameSuffix}'

resource storageaccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccountName
  location: location
  kind: storageAccountKind
  tags: tags
  sku: {
    name: storageAccountType
  }
  properties: {
    supportsHttpsTrafficOnly: true
    defaultToOAuthAuthentication: true
  }
}

output name string = storageaccount.name
output primaryEndpoints object = storageaccount.properties.primaryEndpoints
