import freeflowuniverse.crystallib.twinclient as tw

const (
	stellar_address = 'SBCWGJ4A4IHDUUXPASQBL7VKGZGNRMVNV66GO5P6FU6Q4NDKHIHZFRKI'
)

pub struct Grid3{
	mut:
		grid tw.TwinClient
		host string
}

pub fn (mut grd Grid3)connect()! Grid3 {
	mut transport := tw.HttpTwinClient{}
	transport.init(grd.host)!
	mut grid := tw.grid_client(transport)!
	grd.grid = grid
	return grd
}

pub fn (mut grd Grid3)create_tfchain_account(name string, ip string)! tw.BlockChainCreateResponseModel {
	return grd.grid.tfchain_create(name, ip)!
}

pub fn (mut grd Grid3)get_tfchain_account(name string)! tw.BlockChainModel {
	return grd.grid.tfchain_get(name)!
}

pub fn (mut grd Grid3)transfer_from_stellar_to_tfchain(
	name string, address_dest string, amount f64, asset string, description string
) !string {
	return grd.grid.stellar_pay(name, address_dest, amount, asset, description)!
}

pub fn (mut grd Grid3)delete_tfchain_account(name string)! bool{
	return grd.grid.tfchain_delete(name)!
}

pub fn (mut grd Grid3)delete_stellar_account(name string)! bool{
	return grd.grid.stellar_delete(name)!
}

pub fn (mut grd Grid3)stellar_balance_by_address(address string)! []tw.StellarBalance{
	return grd.grid.stellar_balance_by_address(address)!
}

pub fn (mut grd Grid3)stellar_get(name string)!tw.StellarWallet {
	return grd.grid.stellar_get(name)!
}


fn main(){
	account_name := "alice22"
	mut grid := Grid3{host: 'http://localhost:3000'}
	grid.connect()!
	found_tf := grid.get_tfchain_account(account_name) or { tw.BlockChainModel{} }
	if found_tf.name == account_name{
		println("Found accounts")
		println("Delete '$account_name' account")
		grid.delete_tfchain_account(account_name)!
		println("Deleted!")
	}
	println("Create TF-Chain Account Stage...")
	println("Create new accounts")
	tf := grid.create_tfchain_account(account_name, "2a02:1812:1443:300:7913:de17:4c83:ecb2")!
	println("Account Created!")
	println(tf)

	println("Initialize Stellar Account Stage...")
	st := grid.stellar_get("testaccount")!
	// // SBCWGJ4A4IHDUUXPASQBL7VKGZGNRMVNV66GO5P6FU6Q4NDKHIHZFRKI
	// // GBFLR2NFRBLEPUIKXH2T4AWJIC4WSUCCVYEYGIGZECKVDVCXVSLFL34S
	println(st)

	println("Transfare stage...")
	grid.transfer_from_stellar_to_tfchain(
		"testaccount",
		tf.public_key,
		5,
		"XLM",
		"twin_" + tf.twin_id
	)!
	println("Transfared...")
}