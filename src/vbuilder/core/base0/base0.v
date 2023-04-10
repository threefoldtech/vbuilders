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

// RUN rm  -rf /tmp/* /var/cache/apk/*
// RUN apk update
// RUN apk upgrade
// RUN apk add --no-cache redis \
//     && apk add --no-cache dumb-init \
//     && echo

// RUN apk add --no-cache curl libssh2 git tmux zsh bash

// # add openssh and clean
// RUN apk add --no-cache openssh && rm  -rf /tmp/* /var/cache/apk/*

// RUN apk add --no-cache mc htop rsync wget

// # EXPOSE 22
// # EXPOSE 6379

// # RUN echo 'nameserver 8.8.8.8' > '/etc/resolv.conf'

// ADD binscripts/* /bin/
// ADD env.sh /
// ADD conf.sh /

// RUN chmod 770 /bin/shell.sh

// RUN echo 'THREEFOLD BASE DEV ENV WELCOMES YOU' > /etc/motd

// CMD ["/bin/shell.sh"]
