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
