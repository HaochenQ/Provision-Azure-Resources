using 'main.bicep'

param client = 'client'

param environmentType = 'test'

param tags = {
  createdBy: 'Howard'
  client: client
  project: 'project'
  env: 'test'
}

param storageAccountType = 'Standard_LRS'
param storageAccountKind = 'StorageV2'
