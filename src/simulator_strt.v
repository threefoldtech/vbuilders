
module main

import simulator

fn do() ! {

	mut s:= simulator.new()!
	println(s)

}

fn main() {
	do() or { panic(err) }
}
