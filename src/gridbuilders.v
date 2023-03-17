
module main

import threefoldtech.vbuilder.dashboard
import threefoldtech.vbuilder.playground
import threefoldtech.vbuilder.tfchainbuilder
import threefoldtech.vbuilder.gridproxybuilder

fn do() ! {
	dashboard.build(reset:false)!
	// playground.build(reset:false)!
	// tfchainbuilder.build(reset:true)!
	// gridproxybuilder.build(reset:true)!
}

fn main() {
	do() or { panic(err) }
}