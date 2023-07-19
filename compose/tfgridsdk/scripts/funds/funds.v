module funds

import freeflowuniverse.crystallib.twinclient as tw
import twinserver

const (
	stellar_address = 'GBFLR2NFRBLEPUIKXH2T4AWJIC4WSUCCVYEYGIGZECKVDVCXVSLFL34S'
	stellar_secret  = 'SBCWGJ4A4IHDUUXPASQBL7VKGZGNRMVNV66GO5P6FU6Q4NDKHIHZFRKI'
	bridge_address  = 'GAQH7XXFBRWXT2SBK6AHPOLXDCLXVFAKFSOJIRMRNCDINWKHGI6UYVKM'
)

fn main() {
	account_name := 'alice22'
	mut grid := twinserver.Grid3{
		host: 'http://localhost:3000'
	}
	grid.connect()!

	found_tf := grid.get_tfchain_account(account_name) or { tw.BlockChainModel{} }

	if found_tf.name == account_name {
		grid.delete_tfchain_account(account_name)!
	}

	tf := grid.create_tfchain_account(account_name, '2a02:1812:1443:300:7913:de17:4c83:ecb2')!
	grid.get_tfchain_balance(account_name, tf.public_key)!
	grid.stellar_init('testaccount', stellar_secret)!
	grid.stellar_get('testaccount')!

	grid.transfer_from_stellar_to_tfchain('testaccount', bridge_address, 5, 'XLM', 'twin_' +
		tf.twin_id)!
	grid.get_tfchain_balance(account_name, tf.public_key)!
}
