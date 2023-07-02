#!/bin/bash

# Read the variables from the variabletxt file
source /apps/variables.txt

# Check if the variables are valid
if [ -z "$domainname" ] || [ -z "$selector" ] || [ -z "$keylength" ] || [ -z "$ips" ]; then
  echo "Invalid variables. Please provide domainname, selector, keylength and ips in the variabletxt file."
  exit 1
fi

# Check if the keylength is valid
if [ $keylength -ne 1024 ] && [ $keylength -ne 2048 ]; then
  echo "Invalid keylength. Please choose either 1024 or 2048."
  exit 2
fi

# Generate the private key in PEM format and save it in the dkim_path folder
openssl genrsa -out "$dkim_path${selector}.${domainname}.pem" "$keylength"

# Generate the public key in PEM format and save it in the dkim_path folder
openssl rsa -in "$dkim_path${selector}.${domainname}.pem" -pubout -out "$dkim_path${selector}.public.${domainname}.key"

# Print the private and public keys
echo "Private Key:"
cat "$dkim_path${selector}.${domainname}.pem"
echo "Public Key:"
echo "DKIM public key(type=TXT,Name=cast._domainkey):: cast._domainkey.${domainname} TXT v=DKIM1; k=rsa; p=$(cat "$dkim_path${selector}.public.${domainname}.key" | grep -v -e '^-' | tr -d '\n')" >> ./DNS_UPDATE.txt
echo "DKIM public key(type=TXT,Name=cast._domainkey):: cast._domainkey.${domainname} TXT v=DKIM1; k=rsa; p=$(cat "$dkim_path${selector}.public.${domainname}.key" | grep -v -e '^-' | tr -d '\n')"






# Generate the SPF record using the ips variable
# echo "SPF Record:"
echo "SPF Record (type=TXT,Name=@):: ${domainname} TXT v=spf1 mx a $(for ip in $ips; do echo -n "ip4:$ip "; done)-all" >> ./DNS_UPDATE.txt




# Generate the DMARC record using the domainname and selector variables
# echo "DMARC Record:"
echo "DMARC Record(type=TXT,Name=_dmarc):: _dmarc.${domainname} TXT v=DMARC1; p=reject; sp=none; aspf=r; ruf=mailto:${selector}@${domainname}; rua=mailto:${selector}@${domainname};" >> ./DNS_UPDATE.txt
