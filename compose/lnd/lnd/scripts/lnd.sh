lnd --rpclisten=0.0.0.0:10009 \
    --restlisten=0.0.0.0:10080 \
    --bitcoin.active \
    --bitcoin.mainnet \
    --alias=kristof2.test \
    --routing.assumechanvalid \
    --accept-keysend \
    --bitcoin.node=neutrino \
    --neutrino.addpeer=btcd-mainnet.lightning.computer \
    --neutrino.addpeer=mainnet3-btcd.zaphq.io \
    --neutrino.addpeer=mainnet4-btcd.zaphq.io \
    --neutrino.feeurl=https://nodes.lightning.computer/fees/v1/btc-fee-estimates.json \
    --debuglevel=info

    # --neutrino.addpeer=btcd-mainnet.lightning.computer  \
    # --neutrino.addpeer=mainnet1-btcd.zaphq.io \
    # --neutrino.addpeer=mainnet2-btcd.zaphq.io \
    # --neutrino.addpeer=mainnet3-btcd.zaphq.io \
    # --neutrino.addpeer=mainnet4-btcd.zaphq.io \    
