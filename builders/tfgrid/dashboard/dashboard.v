module dashboard

import freeflowuniverse.crystallib.osal.docker

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	println(' - build dashboard: reset:${args.reset}')

	mut r := engine.recipe_new(name: 'dashboard', platform: .alpine)

	r.add_from(image: 'node', tag: '18', alias: 'build')!
	r.add_workdir(workdir: '/app')!
	r.add_copy(source: '.', dest: '/app')!

	r.add_run(cmd: 'yarn install')!
	r.add_run(cmd: 'yarn lerna run build --no-private')!
	r.add_run(cmd: 'yarn workspace @threefold/dashboard build')!

	r.add_from(image: 'nginx', tag: '1.16.0-alpine')!

	r.add_copy(from: 'build', source: '/app/packages/dashboard/dist', dest: '/usr/share/nginx/html')!
	r.add_copy(
		from: 'build'
		source: '/app/packages/dashboard/scripts/build-env.sh'
		dest: '/usr/share/nginx/html'
	)!
	r.add_run(cmd: 'rm /etc/nginx/conf.d/default.conf')!
	r.add_copy(source: './packages/dashboard/nginx.conf', dest: '/etc/nginx/conf.d')!

	r.add_workdir(workdir: '/usr/share/nginx/html')!
	r.add_run(cmd: 'apk add --no-cache bash')!
	r.add_run(cmd: 'chmod +x build-env.sh')!

	r.add_expose(ports: ['80'])!
	r.add_cmd(cmd: '/bin/bash -c /usr/share/nginx/html/build-env.sh && nginx -g daemon off')!

	r.build(args.reset)!
}
