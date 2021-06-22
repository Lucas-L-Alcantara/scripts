#!/bin/bash

# Cloudflare provides an API to update a DNS

# How to:
# 1 - Save file:
#   wget -c /home/$USER/ https://raw.githubusercontent.com/lucas-apd/scripts/main/cloudflare_ddns.sh 
# 2 - Permission set: 
#   chmod +x /home/$USER/cloudflare_ddns.sh
# 3 - Create a cronjob for auto update (every 30 minutes):
#   { crontab -l; echo "*/30 * * * * /home/$USER/cloudflare_ddns.sh"; } | crontab -
# 4 - Edit personal information:
#   vi /home/$USER/cloudflare_ddns.sh

# Start changing... 
DNS_ZONE=example.com
DNS_ENTRY=sub
CLOUDFLARE_EMAIL=example@mail.com
CLOUDFLARE_AUTH_KEY=111aaa222bbb333ccc444ddd555 # your GLOBAL API KEY from https://dash.cloudflare.com/profile/api-tokens
# Stop!

PUBLIC_IP=$(curl -s https://checkip.amazonaws.com)

# Get the zone id for the requested zone:
ZONE_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$zone&status=active" \
  -H "X-Auth-Email: $CLOUDFLARE_EMAIL" \
  -H "X-Auth-Key: $CLOUDFLARE_AUTH_KEY" \
  -H "Content-Type: application/json" | jq -r '{"result"}[] | .[0] | .id')

echo "Zoneid for $zone is $zoneid"

# Get the dns record id
DNS_RECORD=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/" \
  -H "X-Auth-Email: $CLOUDFLARE_EMAIL" \
  -H "X-Auth-Key: $CLOUDFLARE_AUTH_KEY" \
  -H "Content-Type: application/json" | jq -r '{"result"}[] | .[0] | .id')

echo "DNSrecordid for $DNS_RECORD is $DNS_RECORD_ID"

# Update the record
curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$DNS_RECORD_ID" \
  -H "X-Auth-Email: $CLOUDFLARE_EMAIL" \
  -H "X-Auth-Key: $CLOUDFLARE_AUTH_KEY" \
  -H "Content-Type: application/json" \
  --data "{\"type\":\"A\",\"name\":\"$DNS_RECORD\",\"content\":\"$PUBLIC_IP\",\"ttl\":1,\"proxied\":false}" | jq
