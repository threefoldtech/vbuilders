import threefoldtech.vgrid.gridproxy.model as gmodel
import threefoldtech.vgrid.gridproxy as gp

pub fn find_nodes()? []gmodel.Node{
	mut gproxy := gp.get(.test, false)
	nodes := gproxy.get_nodes()?
	return nodes
}


fn main(){
	println("Searching for available nodes")
	nodes := find_nodes()?
	println("nodes found!")
	println(nodes)
}