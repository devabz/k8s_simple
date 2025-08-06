source .env

curl -X POST \
    "https://api.digitalocean.com/v2/droplets" \
    -H "Authorization: Bearer $DIGITALOCEAN_TOKEN" \
    --json @resources/droplets.json \
    > vms_create.json