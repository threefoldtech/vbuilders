module builders

import freeflowuniverse.crystallib.docker
import threefoldtech.builders.core.gobuilder
import threefoldtech.builders.core.vbuilder
import threefoldtech.builders.core.rustbuilder
import threefoldtech.builders.core.nodejsbuilder
import threefoldtech.builders.core.natstools
import threefoldtech.builders.core.caddy
// import threefoldtech.builders.play.ca
import threefoldtech.builders.tfgrid.dashboard
// import threefoldtech.builders.tfgrid.playground
import threefoldtech.builders.tfgrid.tfchainbuilder
import threefoldtech.builders.tfgrid.gridproxybuilder

pub struct UniverseBuilder {
	dockerregistry_datapath string
	prefix                  string
	localonly               bool
}

[params]
pub struct UniverseBuilderArgs {
	dockerregistry_datapath string
	prefix                  string
	localonly               bool
}

// get a new builder
pub fn new(args UniverseBuilderArgs) !UniverseBuilder {
	mut ub := UniverseBuilder{
		dockerregistry_datapath: args.dockerregistry_datapath
		prefix: args.prefix
	}
	return ub
}

[params]
pub struct BuildArgs {
	reset bool
}

// be careful reset removes all your local docker images and containers !!!
pub fn (mut ub UniverseBuilder) build_base(args BuildArgs) ! {
	mut engine := docker.new(prefix: ub.prefix, localonly: ub.localonly)!

	if ub.dockerregistry_datapath.len > 0 {
		engine.registry_add(datapath: ub.dockerregistry_datapath)! // this means we run one locally
	}

	if args.reset {
		// TODO: prob better to only remove what is relevant to building
		engine.reset_all()!
	}

	gobuilder.build(engine: &engine, reset: args.reset)!
	nodejsbuilder.build(engine: &engine, reset: args.reset)!
	vbuilder.build(engine: &engine, reset: args.reset)!
	rustbuilder.build(engine: &engine, reset: args.reset)!
	natstools.build(engine: &engine, reset: args.reset)!
	caddy.build(engine: &engine, reset: args.reset)!
	// ca.build(engine: &engine, reset: args.reset)!
}

// be careful reset removes all your local docker images and containers !!!
pub fn (mut ub UniverseBuilder) build_tfgrid(args BuildArgs) ! {
	mut engine := docker.new(prefix: ub.prefix, localonly: ub.localonly)!

	if ub.dockerregistry_datapath.len > 0 {
		engine.registry_add(datapath: ub.dockerregistry_datapath)! // this means we run one locally
	}

	if args.reset {
		// TODO: prob better to only remove what is relevant to building
		engine.reset_all()!
	}

	// make sure we have the base done
	ub.build_base()!

	dashboard.build(engine: &engine, reset: false)!
	// playground.build(engine:&engine,reset:false)!
	tfchainbuilder.build(engine: &engine, reset: true)!
	gridproxybuilder.build(engine: &engine, reset: true)!
}
