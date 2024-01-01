if [ "$(command -v curl)" ]; then
        gcp_req='curl -s -f  -H "X-Google-Metadata-Request: True"'
elif [ "$(command -v wget)" ]; then
    gcp_req='wget -q -O - --header "X-Google-Metadata-Request: True"'
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
    echo "  Scopes: "$(eval $gcp_req "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/$sa/scopes") | sed -${E} "s,${GCP_GOOD_SCOPES},${SED_GREEN},g" | sed -${E} "s,${GCP_BAD_SCOPES},${SED_RED},g"
    echo "  Token: "$(eval $gcp_req "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/$sa/token")
    echo "  ==============  "
    done
fi
