# Define the variables
source /apps/variables.txt


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