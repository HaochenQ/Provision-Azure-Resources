param location string = resourceGroup().location

@description('The environment type for provisioning resources')
@allowed([
    'production'
    'test' ]
)
param environmentType string

@description('The client name')
param client string

@description('Tags for azure resources, it inclues createdBy, client and project')
param tags object

@description('Resource name suffix with a unique string seeded with reource group id')
param resourceNameSuffix string = uniqueString(resourceGroup().id)

@allowed([ 'Standard_LRS'
  'Standard_ZRS'
  'Standard_GRS' ])
param storageAccountType string
param storageAccountKind string

// param environmentConfigurationMap object = {
//   production: {
//     functions: {
//       sku: {
//         name: 'consumption'
//       }
//     }
//   }
//   test: {
//     functions: {
//       sku: {
//         name: 'premium'
//       }
//     }
//   }
// }

module storageAccount 'modules/Storage/storage-accounts.bicep' = {
  name: 'storage'
  params: {
    location: location
    resourceNameSuffix: resourceNameSuffix
    storageAccountKind: storageAccountKind
    storageAccountType: storageAccountType
    tags: tags
  }
}

module serviceBus 'modules/ServiceBus/servicebus.bicep' = {
  name: 'servicebus'
  params: {
    client: client
    environmentType: environmentType
    location: location
    tags: tags
  }
}

module appInsights 'modules/AppInsights/appinsights.bicep' = {
  name: 'appInsights'
  params: {
    client: client
    environmentType: environmentType
    location: location
    tags: tags
  }
}

module asp 'modules/AppServicePlan/app-service-plan.bicep' = {
  name: 'app-service-plan'
  params: {
    client: client
    environmentType: environmentType
    location: location
    resourceNameSuffix: resourceNameSuffix
  }
}

module functions 'modules/Functions/functions.bicep' = {
  name: 'azure-functions'
  params: {
    asp_id1: asp.outputs.asp1_id
    client: client
    environmentType: environmentType
    instrumentationKey: appInsights.outputs.instrumentationKey
    location: location
    storageAccountName1: storageAccount.outputs.name
    serviceBusQueueName: serviceBus.outputs.serviceBusQueueName
    serviceBusNamespaceName: serviceBus.outputs.serviceBusNamespaceName
    tags: tags
  }
}

module logicapp 'modules/LogicApps/logic-apps.bicep' = {
  name: 'logicapp'
  params: {
    client: client
    environmentType: environmentType
    location: location
    tags: tags
  }
}

output function_app_name string = functions.outputs.function_app_name
