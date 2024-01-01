if [ "$(command -v curl)" ]; then
        gcp_req='curl "'
elif [ "$(command -v wget)" ]; then
    gcp_req='wget'
else 
    echo "Neither curl nor wget were found, I can't enumerate the metadata service :("
fi

echo ""
print_3title "Startup-script"
echo $(eval $gcp_req "http://metadata.google.internal/computeMetadata/v1/instance/attributes/startup-script")
echo ""

echo ""
print_3title "Service Accounts"
for sa in $(eval $gcp_req "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/"); do 
    echo "  Name: $sa"
    echo "  Email: "$(eval $gcp_req "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/$sa/email")
    echo "  Aliases: "$(eval $gcp_req "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/$sa/aliases")
    echo "  Identity: "$(eval $gcp_req "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/$sa/identity")
    echo "  Scopes: "$(eval $gcp_req "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/$sa/scopes")
    echo "  Token: "$(eval $gcp_req "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/$sa/token")
    echo "  ==============  "
done

