
module main


import freeflowuniverse.crystallib.docker

// import threefoldtech.builders.core.base0
import threefoldtech.builders.core.zdb
// import threefoldtech.builders.core.gobuilder
// import threefoldtech.builders.core.vbuilder
// import threefoldtech.builders.core.rustbuilder
// import threefoldtech.builders.core.nodejsbuilder
// import threefoldtech.builders.core.natstools
// import threefoldtech.builders.core.caddy
// import threefoldtech.builders.core.mycelium
// import threefoldtech.builders.play.goca
// import threefoldtech.builders.tfgrid.web3proxy
// import threefoldtech.builders.tfgrid.dashboard
// import threefoldtech.builders.tfgrid.playground
// import threefoldtech.builders.tfgrid.tfchainbuilder
// import threefoldtech.builders.tfgrid.gridproxybuilder


fn do() ! {

	reset:=false

	mut engine := docker.new()!

	zdb.build(engine:&engine,reset:reset)!
	
	// gobuilder.build(engine:&engine,reset:reset)!
	// nodejsbuilder.build(engine:&engine,reset:reset)!
	// vbuilder.build(engine:&engine,reset:reset)!
	// rustbuilder.build(engine:&engine,reset:reset)!
	// caddy.build(engine:&engine,reset:reset)!	

	// natstools.build(engine:&engine,reset:reset)!	
	// goca.build(engine:&engine,reset:reset)!
	// web3proxy.build(engine:&engine,reset:true)!

	// mycelium.build(engine:&engine,reset:true)!

}

fn main() {

	do() or { panic(err) }
}
