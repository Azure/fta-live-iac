param location string
param environment string
param appServiceName string

var appServicePlanSkuName = (environment == 'prod') ? 'P1v3' : 'S1'
var appServicePlanName = concat((environment == 'prod') ? environment : 'nonprod', '-', appServiceName,'-plan')

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
  }
}

resource webApp 'Microsoft.Web/sites@2020-06-01' = {
  name: concat(environment,appServiceName)
  location: location
  properties: {
    serverFarmId: appServicePlan.id
  }
}