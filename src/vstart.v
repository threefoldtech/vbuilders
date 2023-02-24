
module main

import threefoldtech.vbuilder.gobuilder
import threefoldtech.vbuilder.vbuilder
import threefoldtech.vbuilder.nodejsbuilder
import threefoldtech.vbuilder.natstools

fn do() ! {

	// gobuilder.build(reset:false)!
	// nodejsbuilder.build(reset:false)!
	// vbuilder.build(reset:false)!
	natstools.build(reset:false)!

}

fn main() {
	do() or { panic(err) }
}
