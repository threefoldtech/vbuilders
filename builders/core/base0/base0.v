module base0

import freeflowuniverse.crystallib.docker

pub fn build(args docker.BuildArgs) ! {
	println(' - build base0: reset:${args.reset}')

	mut engine := args.engine

	// specify we want to build an alpine version
	mut r := engine.recipe_new(name: 'base0', platform: .alpine, zinit: false)

	r.files << $embed_file('templates/env.sh')
	r.files << $embed_file('templates/shell0.sh')

	r.add_package(name: 'mc, htop, rsync, wget, openssh, libssh2')!
	r.add_package(name: 'redis, dumb-init, curl, git, tmux, zsh, bash, ca-certificates')!

	r.add_run(
		cmd: "
		echo 'THREEFOLD BASE DEV ENV WELCOMES YOU' > /etc/motd		
	"
	)!

	r.add_file_embedded(source: 'shell0.sh', dest: '/bin/shell.sh', make_executable: true)!
	r.add_file_embedded(source: 'env.sh', dest: '/')!

	r.add_cmd(cmd: '/bin/shell.sh')!
	r.build(args.reset)!

}
