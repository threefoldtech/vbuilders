cat <<EOF > /usr/local/lib/node_modules/grid3_client/dist/node/server/config.json
{
    "network": "$NETWORK",
    "mnemonic": "$MNEMONICS",
    "rmb_proxy": true,
    "storeSecret": "secret",
    "keypairType": "sr25519"
}
EOF