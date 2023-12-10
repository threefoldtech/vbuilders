module publishingtools

import freeflowuniverse.crystallib.osal.docker

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	// specify we want to build an alpine version
	mut r := engine.recipe_new(name: 'pubtools', platform: .ubuntu)

	r.add_env('PBRANCH', 'development')!
	r.add_env('TERM', 'xterm')!
	r.add_run(
		cmd: 'apt update'
	)!
	r.add_run(
		cmd: 'apt -y install curl wget git make build-essential  unzip vim libgc-dev'
	)!
	r.add_run(cmd: 'apt install -y debian-keyring debian-archive-keyring apt-transport-https')!
	r.add_run(
		cmd: 'curl -1sLf https://dl.cloudsmith.io/public/caddy/stable/gpg.key |  gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg'
	)!
	r.add_run(
		cmd: 'curl -1sLf https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt | tee /etc/apt/sources.list.d/caddy-stable.list'
	)!
	r.add_run(cmd: 'apt update')!
	r.add_run(cmd: 'apt install caddy')!
	r.add_run(cmd: 'caddy add-package github.com/baldinof/caddy-supervisor')!
	r.add_run(
		cmd: 'wget https://github.com/vlang/v/releases/download/weekly.2022.16/v_linux.zip'
	)!
	r.add_run(cmd: 'unzip v_linux.zip ;cd v ; ./v symlink')!
	r.add_run(
		cmd: 'wget https://raw.githubusercontent.com/freeflowuniverse/crystaltools/development/install.sh'
	)!

	r.add_run(
		cmd: 'bash install.sh'
	)!

	r.build(args.reset)!
}
