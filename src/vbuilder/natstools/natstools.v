module natstools

import freeflowuniverse.crystallib.docker
import threefoldtech.vbuilder.base

pub fn build(args docker.BuildArgs) ! {
	// make sure dependency has been build
	base.build(reset: args.reset, strict: args.strict)!

	mut engine := docker.new()!

	// specify we want to build an alpine version
	mut r := engine.recipe_new(name: 'natstools', platform: .alpine)

	r.add_from(image: 'gobuilder', alias: 'builder')!

	r.add_cmd(
		cmd: '
		set -ex
		cd /tmp
		curl -LO https://raw.githubusercontent.com/nats-io/nsc/main/install.sh
		cd /tmp
		sh ./install.sh
		mv ~/.nsccli/bin/nsc /bin
		rm -rf ~/.nsccli	
	'
	)!

	r.add_cmd(
		cmd: '
		#install nats
		CGO_ENABLED=1
		GOOS=linux
		go install github.com/nats-io/natscli/nats@latest	
	'
	)!

	r.build(args.reset)!
}

// # Start a new, final image.
// FROM despiegk/base as final

// # install tmuxp
// ADD scripts/* /bin/
// WORKDIR /tmp
// RUN sh /bin/tmuxp_install.sh

// # Copy the binaries from the builder image.
// COPY --from=builder /bin/nsc /bin/
// COPY --from=builder /app/bin/nats /bin/

// ADD conf.sh /
