module deployvm

import twinserver
import term

fn main() {
	mut grid := twinserver.Grid3{
		host: 'http://localhost:3000'
	}
	grid.connect()!
	machine_name := 'TestVM'
	deployement_found := grid.machines_get(machine_name)!

	if deployement_found.len > 0 {
		grid.machines_delete(machine_name)!
	}

	mut nodes := grid.filter_nodes()!
	reach_node := grid.ping_nodes(nodes, 3)!
	if reach_node != 0 {
		// That means there is node we can use it.
		grid.machines_deploy(reach_node, machine_name)!
		dep_info := grid.machines_get(machine_name)!
		println(term.green(dep_info.str()) + '\n')
	}
}
