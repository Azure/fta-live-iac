param location string
param environment string
param appServiceName string

var appServicePlanSkuName = (environment == 'prod') ? 'P1v3' : 'S1'
var environmentType = (environment == 'prod') ? environment : 'nonprod'
var appServicePlanName = '${environmentType}-${appServiceName}-plan'

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: appServicePlanSkuName
  }
}

resource webApp 'Microsoft.Web/sites@2020-06-01' = {
  name: '${environment}${appServiceName}'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
  }
}

resource slot 'Microsoft.Web/sites/slots@2021-01-01' = {
  name: '${environment}${appServiceName}/staging'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
  }
}
