#!/bin/bash

print_3title() {
    echo "=== $1 ==="
}

if command -v curl &> /dev/null; then
    gcp_req='curl -s -f -H "Metadata-Flavor: Google"'
elif command -v wget &> /dev/null; then
    gcp_req='wget -q -O - --header "Metadata-Flavor: Google"'
else
    echo "Neither curl nor wget were found. Exiting."
    exit 1
fi

echo ""
print_3title "Startup-script"
echo "$($gcp_req http://metadata.google.internal/computeMetadata/v1/instance/attributes/startup-script)"
echo ""

echo ""
print_3title "Service Accounts"
for sa in $($gcp_req http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/); do
    echo "  Name: $sa"
    echo "  Email: $($gcp_req http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/$sa/email)"
    echo "  Aliases: $($gcp_req http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/$sa/aliases)"
    echo "  Identity: $($gcp_req http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/$sa/identity)"
    echo "  Scopes: $($gcp_req http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/$sa/scopes)"
    echo "  Token: $($gcp_req http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/$sa/token)"
    echo "  ==============  "
done
