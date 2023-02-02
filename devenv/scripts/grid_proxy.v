import threefoldtech.vgrid.gridproxy.model as gmodel
import threefoldtech.vgrid.gridproxy as gp


pub fn (mut grd Grid3)find_nodes()? []gp.Node{
	mut gproxy := gp.get(.test, false)
	nodes := gproxy.get_nodes()?
	return nodes
}