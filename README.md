# Deploy to AKS from GitHub Actions

## Setup

Create the AKS cluster:

```
$ az group create \
    --location $LOCATION \
    --name $RG

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

Take the `tenant` output and create a GitHub repository secret named `SERVICE_PRINCIPAL_TENANT` with the value from `tenant`.

Grant this service principal the ability to push to the container registry:

```
$ az role assignment create \
    --role AcrPush \
    --assignee-principal-type ServicePrincipal \
    --assignee-object-id $(az ad sp show \
        --id $SERVICE_PRINCIPAL_APP_ID \
        --query objectId -o tsv) \
    --scope $(az acr show --name $ACR --query id -o tsv)
```

Grant this service principal the ability to get credentials:

```
$ az role assignment create \
    --role "Azure Kubernetes Service Cluster User Role" \
    --assignee-principal-type ServicePrincipal \
    --assignee-object-id $(az ad sp show \
        --id $SERVICE_PRINCIPAL_APP_ID \
        --query objectId -o tsv) \
    --scope $(az aks show \
        --resource-group $RG \
        --name $CLUSTER \
        --query id -o tsv)
```

Grant this service principal the ability to read and write in the default namespace:

```
$ az role assignment create \
    --role "Azure Kubernetes Service RBAC Writer" \
    --assignee-principal-type ServicePrincipal \
    --assignee-object-id $(az ad sp show \
        --id $SERVICE_PRINCIPAL_APP_ID \
        --query objectId -o tsv) \
    --scope "$(az aks show \
        --resource-group $RG \
        --name $CLUSTER \
        --query id -o tsv)/namespaces/default"
```
