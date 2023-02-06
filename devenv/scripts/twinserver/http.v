module twinserver
import freeflowuniverse.crystallib.twinclient as tw
import term

pub struct Grid3{
	mut:
		grid tw.TwinClient
		host string
}

pub fn (mut grd Grid3)connect()! Grid3 {
	println(term.blue("🚀 | + | Connecting to the grid...") + "\n")
	mut transport := tw.HttpTwinClient{}
	transport.init(grd.host)!
	mut grid := tw.grid_client(transport)!
	grd.grid = grid
	println(term.green("🎉 | + | Connected!") + "\n")
	return grd
}

pub fn (mut grd Grid3)machines_get(name string) ![]tw.Deployment {
	return grd.grid.machines_get(name)!
}

pub fn (mut grd Grid3)create_tfchain_account(name string, ip string)! tw.BlockChainCreateResponseModel {
	println(term.blue("🧠 | + | Create TF-Chain Account...") + "\n")
	created := grd.grid.tfchain_create(name, ip)!
	println(term.green("✅ | + | Account Created!" + "\n"))
	println(term.green(created.str()))
	return created
}

pub fn (mut grd Grid3)get_tfchain_account(name string)! tw.BlockChainModel {
	println(term.blue("🔍 | + | Searching for account with name ${term.green(name)}.") + "\n")
	return grd.grid.tfchain_get(name)!
}

pub fn (mut grd Grid3)transfer_from_stellar_to_tfchain(
	name string, address_dest string, amount f64, asset string, description string
) !string {
	println(term.blue("💰 | + | Transfare stage...") + "\n")
	transfered := grd.grid.stellar_pay(name, address_dest, amount, asset, description)!
	println(term.green("✅ | + | Transfared...") + "\n")
	return transfered
}

pub fn (mut grd Grid3)delete_tfchain_account(name string)! bool{
	println(term.red("🗑️  | - | Delete ${term.green(name)} ${term.red('account')}") + "\n")
	deleted := grd.grid.tfchain_delete(name)!
	println(term.green("✅ | + | Deleted!") + "\n")
	return deleted
}

pub fn (mut grd Grid3)delete_stellar_account(name string)! bool{
	println(term.red("🗑️  | - | Delete ${term.green(name)} ${term.red('account')}") + "\n")
	deleted := grd.grid.stellar_delete(name)!
	println(term.green("✅ | + | Deleted!") + "\n")
	return deleted
}

pub fn (mut grd Grid3)stellar_get(name string)!tw.StellarWallet {
	println(term.blue("🔍 | + | Get Stellar Account...") + "\n")
	return grd.grid.stellar_get(name)!
}

pub fn (mut grd Grid3)stellar_init(name string, secret string)!string {
	println(term.blue("💎 | + | Initialize Stellar Account...") + "\n")
	return grd.grid.stellar_init(name, secret)!
}

pub fn (mut grd Grid3)machines_delete(name string) !tw.ContractResponse {
	println(term.blue("🤫 | + | Machine with name ${term.green(name)} ${term.blue('catched!')}") + "\n")
	println(term.red("🗑️  | - | Will delete machine ${term.green(name)}") + "\n")
	deleted := grd.grid.machines_delete(name)!
	println(term.green("✅ | + | Machine ${term.blue(name)} ${term.green('Deleted!')}") + "\n")
	return deleted
}

pub fn (mut grd Grid3)zos_get_node_statistics(node_id u32)! tw.ZOSNodeStatisticsResponse{
	println(term.blue("🏃 | + | Request to get node statistics...") + "\n")
	statistics := grd.grid.zos_get_node_statistics(node_id)!
	println(term.blue("✅ | + | Node statistics found!") + "\n")
	println(term.green(statistics.str()))
	return statistics
}

pub fn (mut grd Grid3)no_nodes_found(){
	println(term.red("😱 | - | No nodes were found, Maybe invalid filter, try to change the filter and try again."))
}

pub fn (mut grd Grid3)filter_nodes() ![]tw.Node {
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

pub fn (mut grd Grid3) machines_deploy(node tw.Node, name string) !tw.DeployResponse {
	println(term.blue("🥏 | + | Deploying on node id ${node.node_id}...") + "\n")
	payload := tw.MachinesModel{
		name: name
		network: tw.Network{
			ip_range: '10.200.0.0/16'
			name: 'net'
			add_access: false
		}
		machines: [
			tw.Machine{
				name: name
				node_id: node.node_id
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