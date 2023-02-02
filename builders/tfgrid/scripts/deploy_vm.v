import freeflowuniverse.crystallib.twinclient as tw

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

pub fn (mut grd Grid3)machines_get(name string) ![]tw.Deployment {
	return grd.grid.machines_get(name)!
}

pub fn (mut grd Grid3)machines_delete(name string) !tw.ContractResponse {
	return grd.grid.machines_delete(name)!
}

pub fn (mut grd Grid3)filter_nodes() ![]tw.Node {
	filters := tw.FilterOptions{
		country: "Belgium",
		cru: 50,
		sru: 50,
	}
	nodes := grd.grid.capacity_filter_nodes(filters)!
	return nodes
}

pub fn (mut grd Grid3) machines_deploy(node tw.Node, name string) !tw.DeployResponse {
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
	return grd.grid.machines_deploy(payload)
}

fn main() {
	mut grid := Grid3{host: 'http://localhost:3000'}
	grid.connect()!
	machine_name := 'TestVM'
	found := grid.machines_get(machine_name) or {panic(err)}
	if found.len > 0 {
		eprintln("Will delete node {$machine_name}.")
		deleted := grid.machines_delete(machine_name)!
		eprintln(deleted)
	} else {
		eprintln("No deployments were found with name > `$machine_name`.")
	}
	mut nodes := grid.filter_nodes()!
	if nodes.len > 0 {
		eprintln("Node ${nodes[0].node_id} were found!.")
		eprintln("Deploying on node id ${nodes[0].node_id}.")
		deplyment := grid.machines_deploy(nodes[0], machine_name)!
		eprintln(deplyment)
	}else {
		eprintln("No nodes were found, Maybe invalid filter, try to change the filter and try again.")
	}
}