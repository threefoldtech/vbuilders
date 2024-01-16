module main

import freeflowuniverse.crystallib.osal.docker
import threefoldtech.builders.publishingtools

pub fn main() {
	prefix := ''
	localonly := false

	mut engine := docker.new(prefix: prefix, localonly: localonly)!
	publishingtools.build(engine: &engine, reset: true)!
}
