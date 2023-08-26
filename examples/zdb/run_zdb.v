module main

import freeflowuniverse.crystallib.docker
import threefoldtech.builders.core.zdb

fn do() ! {
	prefix:=""
	reset:=false
	localonly:=false

	mut engine := docker.new(prefix:prefix, localonly:localonly)!

	if reset{
		engine.reset_all()!
	}

	zdb.build(engine:&engine, reset:true)!

	mut env := map[string]string{}
	env['SSH_AUTH_SOCK'] = '/run/host-services/ssh-auth.sock'

	mut container := engine.container_create(name:"zdb", mounted_volumes: ["/tmp/builder/zdb:/src", "/run/host-services/ssh-auth.sock:/run/host-services/ssh-auth.sock"],
				image_repo:"zdb", image_tag:"latest", hostname: "zdb", privileged: true, env: env, command: '')!
		
	container.shell(cmd: '/bin/shell.sh')!
	
	container.delete()!
}

fn main() {

	do() or { panic(err) }
}
