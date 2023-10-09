using 'main.bicep'

param client = 'client'

param environmentType = 'production'

param tags = {
  createdBy: 'Howard'
  client: client
  project: 'project'
  env: 'Prod'
}

param storageAccountType = 'Standard_GRS'
param storageAccountKind = 'StorageV2'
