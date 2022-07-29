#!/bin/bash
REGION="eastus"
RGPREFIX="_group"
IMAGE="UbuntuLTS"
USERNAME="azureuser"
PASSWORD="xxxxxxxxxx"
SIZE="Standard_B1ms"

if [ "$1" = "create" ]; then
        az group create --name $2$RGPREFIX --location $REGION
        az vm create --resource-group $2$RGPREFIX --name $2 --image $IMAGE --admin-username $USERNAME --admin-password $PASSWORD --size $SIZE
        IPADD=`az vm list-ip-addresses --resource-group $2$RGPREFIX --name $2 --query "[].virtualMachine.network.publicIpAddresses[0].ipAddress" -o tsv`
        echo "-------------------------------"
        echo "ssh $USERNAME@$IPADD"
        echo "-------------------------------"
elif [ "$1" = "delete" ]; then
        az group delete --name $2$RGPREFIX --force-deletion-types Microsoft.Compute/virtualMachines --yes
elif [ "$1" = "list" ]; then
        az vm list-ip-addresses --query "[].{Name:virtualMachine.name,ResourceGroup:virtualMachine.resourceGroup,PrivateIp:virtualMachine.network.privateIpAddresses[0],PublicIp:virtualMachine.network.publicIpAddresses[0].ipAddress}" --output table
else
        echo "Can not find option."
        echo "create: vm create"
        echo "delete: vm delete"
        echo "list: vm list"
fi
