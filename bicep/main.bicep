param name string
param environment string {
  allowed: [
    'dev'
    'test'
    'prod'
  ]
  default: 'dev'
}

var _location = resourceGroup().location
var _storageAccountSkuName = environment == 'prod' ? 'Standard_GRS' : 'Standard_LRS'
var _storageAccountName = '${environment}${name}${uniqueString(resourceGroup().id)}sa'

resource storageAccount 'Microsoft.Storage/storageAccounts@2020-08-01-preview' = {
  name: _storageAccountName
  location: _location
  sku:{
    name: _storageAccountSkuName
  }
  kind: 'StorageV2'
  properties: {
    accessTier: 'Hot'
  }
}

module appService 'modules/app-service.bicep' = {
  name: 'app-service'
  params: {
    location: _location
    appServiceName: name
    environment: environment
  }
}