
module main


import freeflowuniverse.crystallib.osal.docker

// import threefoldtech.builders.core.base0
// import threefoldtech.builders.core.zdb
// import threefoldtech.builders.tfgrid.tfhub
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
// import threefoldtech.builders.play.sonicsearch
// import threefoldtech.builders.play.mdbook
// import threefoldtech.builders.play.sftpgo
// import threefoldtech.builders.core.syncthing
// import threefoldtech.builders.core.coredns
// import threefoldtech.builders.play.zola
import threefoldtech.builders.tfgrid.web3gwdev


fn do() ! {

	// reset:=false

	mut engine := docker.new()!

	// zdb.build(engine:&engine,reset:reset)!
	// tfhub.build(engine:&engine,reset:reset)!
	
	// gobuilder.build(engine:&engine,reset:reset)!
	// nodejsbuilder.build(engine:&engine,reset:reset)!
	// vbuilder.build(engine:&engine,reset:reset)!
	// rustbuilder.build(engine:&engine,reset:true)!
	// caddy.build(engine:&engine,reset:reset)!	

	// natstools.build(engine:&engine,reset:reset)!	
	// goca.build(engine:&engine,reset:reset)!
	// web3proxy.build(engine:&engine,reset:true)!

	// mycelium.build(engine:&engine,reset:true)!
	// sonicsearch.build(engine:&engine,reset:true)!
	// mdbook.build(engine:&engine,reset:true)!
	// syncthing.build(engine:&engine,reset:true)!
	// coredns.build(engine:&engine,reset:true)!
	// zola.build(engine:&engine,reset:true)!
	// sftpgo.build(engine:&engine,reset:true)!
	web3gwdev.build(engine:&engine,reset:true)!
	

}

fn main() {

	do() or { panic(err) }
}
