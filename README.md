# Deploy to AKS from GitHub Actions

## Setup

Create the AKS cluster:

```
$ az aks create \
    --resource-group $RG \
    --name $CLUSTER
```

Create the container registry (ACR):

```
$ az acr create \
    --resource-group $RG \
    --name $ACR \
    --sku basic
```

Attach the container registry to the AKS cluster:

```
$ az aks update \
    --resource-group $RG \
    --name $CLUSTER \
    --attach-acr $ACR
```

Create a service principal which will be used to deploy the application to the AKS cluster:

```
$ az ad sp create-for-rbac \
    --name upgrade-test \
    --skip-assignment
```

Take the `appId` output and create a GitHub repository secret named `SERVICE_PRINCIPAL_APP_ID` with the value from `appId`.

Take the `password` output and create a GitHub repository secret named `SERVICE_PRINCIPAL_SECRET` with the value from `password`.
