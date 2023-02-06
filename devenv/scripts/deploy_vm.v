import twinserver

fn main() {
	mut grid := twinserver.Grid3{host: 'http://localhost:3000'}
	grid.connect()!
	machine_name := 'TestVM'
	deployement_found := grid.machines_get(machine_name)!

	if deployement_found.len > 0 {
		grid.machines_delete(machine_name)!
	}

	mut nodes := grid.filter_nodes()!
	if nodes.len > 0 {
		grid.machines_deploy(nodes[0], machine_name)!
	} else {
		grid.no_nodes_found()
	}
}