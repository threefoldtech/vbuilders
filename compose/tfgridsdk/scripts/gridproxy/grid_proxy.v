module gridproxy

import threefoldtech.vgrid.gridproxy.model as gmodel
import threefoldtech.vgrid.gridproxy as gp
import term

pub fn find_nodes() ?[]gmodel.Node {
	mut gproxy := gp.get(.test, false)
	nodes := gproxy.get_nodes()?
	return nodes
}

fn main() {
	println(term.blue('🔍 | + | Searching for available nodes') + '\n')
	nodes := find_nodes()?
	if nodes.len > 0 {
		println(term.green('✅ | + | Found node ${nodes[0].node_id}.') + '\n')
		println(term.green(nodes.str()))
	} else {
		println(term.red('😱 | - | No nodes were found.'))
	}
}
