#!/bin/bash

# Create Client App
CLIENT_APP=$(az ad app create --display-name "${1}" --identifier-uris "http://${1}")
# Get App Id and Object Id
CLIENT_ID=$(echo $CLIENT_APP | jq -r '.appId')
CLIENT_OID=$(echo $CLIENT_APP | jq -r '.objectId')
JSON="{\"spa\": {\"redirectUris\": [\"${URL}\"]}, \"web\": {\"implicitGrantSettings\": {\"enableAccessTokenIssuance\": true,\"enableIdTokenIssuance\": true}}}"

sleep 30
# Setup Implicit Grant Flow and Reply URLs
az rest -m patch -u "https://graph.microsoft.com/beta/applications/${CLIENT_OID}" --headers Content-Type=application/json -b "$JSON"

# Create API App
API_APP=$(az ad app create --display-name "${2}" --identifier-uris "http://${2}")
# Get App Id and Object Id
PERMISSION_ID=$(echo $API_APP | jq -r '.oauth2Permissions | .[].id')
API_ID=$(echo $API_APP | jq -r '.appId')
API_OID=$(echo $API_APP | jq -r '.objectId')
JSON="{\"api\": {\"preAuthorizedApplications\": [{\"appId\": \"${CLIENT_ID}\",\"permissionIds\": [\"${PERMISSION_ID}\"]}]}}"

sleep 30
# Allow client app above to access API as a trusted service
az rest -m patch -u "https://graph.microsoft.com/beta/applications/${API_OID}" --headers Content-Type=application/json -b "$JSON"

SECRET=$(az ad app credential reset --id $API_OID --append | jq -r '.password')

az webapp auth update -g $4 -n $API --enabled true \
  --action LoginWithAzureActiveDirectory \
  --aad-allowed-token-audiences $3 \
  --aad-client-id $API_ID --aad-client-secret $SECRET  \
  --aad-token-issuer-url $3