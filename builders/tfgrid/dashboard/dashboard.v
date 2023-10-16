module dashboard

import freeflowuniverse.crystallib.osal.docker

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	println(' - build dashboard: reset:${args.reset}')

	mut r := engine.recipe_new(name: 'dashboard', platform: .alpine)

	r.add_from(image: 'nginx', tag: 'alpine')!
	r.add_nodejsbuilder()!

	r.add_run(cmd: 'apk add git')!
	r.add_run(cmd: 'npm i -g yarn')!
	r.add_run(
		cmd: '
		git clone https://github.com/threefoldtech/tfgrid_dashboard /app 
		cd /app
		yarn install
		npm run build
	'
	)!
	r.add_run(
		cmd: '
		rm /etc/nginx/conf.d/default.conf
		cp /app/nginx.conf /etc/nginx/conf.d
		apk add --no-cache bash
		chmod +x /app/scripts/build-env.sh
		cp -r /app/dist /usr/share/nginx/html
	'
	)!
	r.add_run(cmd: 'echo "daemon off;" >> /etc/nginx/nginx.conf')!
	r.add_cmd(cmd: '/bin/bash -c /app/scripts/build-env.sh')!
	r.add_entrypoint(cmd: 'nginx')!

	r.build(args.reset)!
}
