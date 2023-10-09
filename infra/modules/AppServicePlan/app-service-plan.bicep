param location string
param resourceNameSuffix string
param client string
param environmentType string

var aspName1 = 'asp-${environmentType}-${resourceNameSuffix}-${client}-1'
//var aspName2 = 'asp-${environmentType}-${resourceNameSuffix}-${client}-2'

resource appServicePlan1 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: aspName1
  location: location
  sku: environmentType == 'production' ? {
    name: 'EP1'
  } : {
    name: 'Y1'
    tier: 'Dynamic'
  }
  properties: {}
}

// resource appServicePlan2 'Microsoft.Web/serverfarms@2020-12-01' = {
//   name: aspName2
//   location: location
//   sku: {
//     name: 'Y1'
//     tier: 'Dynamic'
//   }
//   properties: {}
// }

output asp1_name string = appServicePlan1.name
output asp1_id string = appServicePlan1.id
// output asp2_name string = appServicePlan2.name
// output asp2_id string = appServicePlan2.id
