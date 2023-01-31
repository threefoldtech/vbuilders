cat <<EOF > ~/grid3_client_ts/src/server/config.json
{
    "network": "dev",
    "mnemonic": "$MNEMONICS",
    "rmb_proxy": false,
    "storeSecret": "secret",
    "keypairType": "sr25519"
}
EOF