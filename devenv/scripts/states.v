import twinserver

fn main(){
	mut grid := twinserver.Grid3{host: 'http://localhost:3000'}
	grid.connect()!
	nodes := grid.filter_nodes()!
	if nodes.len > 0{
		grid.zos_statistics_get(nodes[0].node_id)!
	} else {
		grid.no_nodes_found()
	}
}