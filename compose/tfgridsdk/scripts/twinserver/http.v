module twinserver
import freeflowuniverse.crystallib.twinclient as tw
import term
import rand

pub struct Grid3{
	mut:
		grid tw.TwinClient
		host string
}

pub fn (mut grd Grid3)connect()! Grid3 {
	// Connect to ts-client http server.
	println(term.blue("🚀 | + | Connecting to the grid...") + "\n")
	mut transport := tw.HttpTwinClient{}
	transport.init(grd.host)!
	mut grid := tw.grid_client(transport)!
	grd.grid = grid
	println(term.green("🎉 | + | Connected!") + "\n")
	return grd
}

pub fn (mut grd Grid3)machines_get(name string) ![]tw.Deployment {
	// Get machine deployment based on its name.
	return grd.grid.machines_get(name)!
}

pub fn (mut grd Grid3)create_tfchain_account(name string, ip string)! tw.BlockChainCreateResponseModel {
	// Create new tf-chain account.
	println(term.blue("🧠 | + | Create TF-Chain Account...") + "\n")
	created := grd.grid.tfchain_create(name, ip)!
	println(term.green("✅ | + | Account Created!" + "\n"))
	println(term.green(created.str()))
	return created
}

pub fn (mut grd Grid3)get_tfchain_account(name string)! tw.BlockChainModel {
	// Request to get tf-chain account based on its name.
	println(term.blue("🔍 | + | Searching for account with name ${term.green(name)}.") + "\n")
	return grd.grid.tfchain_get(name)!
}

pub fn (mut grd Grid3)transfer_from_stellar_to_tfchain(
	name string, address_dest string, amount f64, asset string, description string
) !string {
	// Requrest to Transfer from stellar to tf-chain account.
	// * name => The wallet name.
	// * address_dest => Should be the bridge address.
	// * amount => The amount that will be transfered.
	// * asset => e.g. XLM.
	// * description => Should be like twin_ + the twin id of the receiver account.
	println(term.blue("💰 | + | Transfer stage...") + "\n")
	transfered := grd.grid.stellar_pay(name, address_dest, amount, asset, description)!
	println(term.green("✅ | + | Done...") + "\n")
	return transfered
}

pub fn (mut grd Grid3)delete_tfchain_account(name string)! bool{
	// Request to delete tf-chain account based on its name.
	println(term.red("🗑️  | - | Delete ${term.green(name)} ${term.red('account')}") + "\n")
	deleted := grd.grid.tfchain_delete(name)!
	println(term.green("✅ | + | Deleted!") + "\n")
	return deleted
}

pub fn (mut grd Grid3)zos_ping_node(node_id u32, stage string)!tw.Message{
	// Request to ping node before use it.
	println(term.blue("🔃 | + | Check node ${term.green(node_id.str())} ${term.blue('if it is reachable.')}") + "\n")
	return grd.grid.zos_ping_node(node_id)!
}

pub fn (mut grd Grid3)stellar_get(name string)!tw.StellarWallet {
	// Get stellar account based on its name.
	println(term.blue("🔍 | + | Get Stellar Account...") + "\n")
	return grd.grid.stellar_get(name)!
}

pub fn (mut grd Grid3)node_is_down(error string){
	// Just print an error when the node not respond
	println(term.red("😓 | - | The node is not respond it returns ` $error `") + "\n")
}

pub fn (mut grd Grid3)stellar_init(name string, secret string)!string {
	// Initialize the stellar account before using it.
	println(term.blue("💎 | + | Initialize Stellar Account...") + "\n")
	return grd.grid.stellar_init(name, secret)!
}

pub fn (mut grd Grid3)get_tfchain_balance(account_name string, address string)!tw.BalanceResult {
	// Get the selected tf-chain account balance.
	println(term.blue("💸 | + | Request to get ${term.green(account_name)} ${term.blue('balance')}") + "\n")
	balance := grd.grid.tfchain_balance_by_address(address)!
	println(term.green("✅ | + | Check Balance") + "\n")
	println(term.green(balance.str()) + "\n")
	return grd.grid.tfchain_balance_by_address(address)!
}

pub fn (mut grd Grid3)machines_delete(name string) !tw.ContractResponse {
	// Request to delete the deployment<Machine>.
	println(term.blue("🤫 | + | Machine with name ${term.green(name)} ${term.blue('catched!')}") + "\n")
	println(term.red("🗑️  | - | Deleteing machine ${term.green(name)}") + "\n")
	deleted := grd.grid.machines_delete(name)!
	println(term.green("✅ | + | Machine ${term.blue(name)} ${term.green('Deleted!')}") + "\n")
	return deleted
}

pub fn (mut grd Grid3)zos_get_node_statistics(node_id u32)! tw.ZOSNodeStatisticsResponse{
	// Request to get node statistics.
	println(term.blue("🏃 | + | Request to get node statistics...") + "\n")
	statistics := grd.grid.zos_get_node_statistics(node_id)!
	println(term.blue("✅ | + | Node statistics found!") + "\n")
	println(term.green(statistics.str()))
	return statistics
}

pub fn (mut grd Grid3)no_nodes_found(){
	// Just print an error when no nodes found
	println(term.red("😱 | - | No nodes were found, Maybe invalid filter, try to change the filter and try again."))
}

pub fn (mut grd Grid3)retries_limit_executed(){
	// print an error when the number of retries are executed
	println(term.red("😥 | - | The number of retries was executed, maybe all nodes are down or there are any relevant issues, try to execute the script one more time.\n"))
}

pub fn (mut grd Grid3)ping_nodes(nodes []tw.Node, retries u32)! u32{
	// Check and ping an exact node with its id
	if nodes.len > 0{
		if retries != 0{
			for node in nodes{
				check_node := grd.zos_ping_node(node.node_id, retries.str())!
				if check_node.err.len > 0 {
					grd.node_is_down(check_node.err)
				} 
				else {
					return node.node_id
				}
			}
			return grd.ping_nodes(nodes, retries - 1)!
		} else {
			grd.retries_limit_executed()
			return 0
		}
	} else {
		grd.no_nodes_found()
		return 0
	}
}

pub fn (mut grd Grid3)filter_nodes() ![]tw.Node {
	// Request to filter nodes based on some resources.
	filters := tw.FilterOptions{
		country: "Belgium",
		mru: 1,
		sru: 10,
	}
	println(term.blue("🔍 | + | Searching for nodes...") + "\n")
	nodes := grd.grid.capacity_filter_nodes(filters)!
	if nodes.len > 0 {
		println(term.green("✅ | + | Found node ${nodes[0].node_id}.") + "\n")
	}
	return nodes
}

pub fn (mut grd Grid3) machines_deploy(node_id u32, name string) !tw.DeployResponse {
	// Deploy new machin on an exact node.
	println(term.blue("✅ | + | Node ${term.green(node_id.str())} ${term.blue('is reachable')}") + "\n")
	println(term.green("🥏 | + | Deploying on node id ${node_id}...") + "\n")
	random_uuid := rand.uuid_v4()
	payload := tw.MachinesModel{
		name: name
		network: tw.Network{
			ip_range: '10.200.0.0/16'
			name: random_uuid.split("-")[0]
			add_access: false
		}
		machines: [
			tw.Machine{
				name: name
				node_id: node_id
				public_ip: false
				planetary: true
				cpu: 1
				memory: 1024
				rootfs_size: 1
				flist: 'https://hub.grid.tf/tf-official-apps/base:latest.flist'
				entrypoint: '/sbin/zinit init'
				env: tw.Env{
					ssh_key: 'SSH_KEY'
				}
			},
		]
	}
	deployed := grd.grid.machines_deploy(payload)!
	println(term.green("🎉 | + | Deployed!") + "\n")
	println(term.blue(deployed.str()))
	return deployed
}