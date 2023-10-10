module syncthing

import freeflowuniverse.crystallib.osal.docker
import threefoldtech.builders.core.gobuilder

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	// make sure dependency has been build
	gobuilder.build(engine: engine)!

	// specify we want to build an alpine version
	mut r := engine.recipe_new(name: 'syncthing', platform: .alpine)

	r.files << $embed_file('templates/syncthing_start.sh')

	r.add_from(image: 'gobuilder', alias: 'builder')!

	r.add_gobuild_from_code(
		url: 'https://github.com/syncthing/syncthing/tree/v1.24.0-rc.1'
		name: 'syncthing'
		buildcmd: 'go run build.go'
		copycmd: 'cp bin/syncthing /bin/syncthing'
	)!

	// buildcmd:"go run build.go --with-next-gen-gui",

	// r.add_run(
	// 	cmd: '
	// 	go install github.com/syncthingserver/xsyncthing/cmd/xsyncthing@latest

	// '
	// )!

	r.add_from(image: 'base', alias: 'installer')!
	// // we are now in phase 2, and start from a clean image, we call this layer 'installer'
	// //we now add the file as has been build in step one to phase 2
	r.add_copy(from: 'builder', source: '/bin/syncthing', dest: '/bin/syncthing')!

	r.add_expose(ports: ['8384'])!

	r.add_file_embedded(source: 'syncthing_start.sh', dest: '/bin/syncthing_start.sh')!

	r.add_zinit_cmd(name: 'syncthing', exec: '/bin/syncthing_start.sh')!

	r.build(args.reset)!
}
