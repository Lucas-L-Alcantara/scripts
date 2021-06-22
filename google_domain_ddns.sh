#!/bin/bash
# Google Domains provides an API to update a DNS:
# https://support.google.com/domains/answer/6147083

# How to:
# 1 - Save file: /home/$USER/google_domain_ddns.sh
# 2 - Permission: "chmod +x /home/$USER/google_domain_ddns.sh"
# 3 - Create a cronjob: { crontab -l; echo "*/30 * * * * /home/$USER/google_domain_ddns.sh"; } | crontab -

USERNAME=""
PASSWORD=""
DNS_ENDPOINT=""
PUBLIC_IP=$(curl -s https://checkip.amazonaws.com)
URL="https://${USERNAME}:${PASSWORD}@domains.google.com/nic/update?hostname=${DNS_ENDPOINT}&myip=${PUBLIC_IP}"

# Update Google DNS Record
curl -s $URL
