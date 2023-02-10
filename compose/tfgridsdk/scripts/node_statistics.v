import twinserver

fn main(){
	mut grid := twinserver.Grid3{host: 'http://localhost:3000'}
	grid.connect()!
	nodes := grid.filter_nodes()!
	reach_node := grid.ping_nodes(nodes, 3)!
	if reach_node != 0 { 
		// That means there is node we can use it.
		grid.zos_get_node_statistics(reach_node)!
	}
}