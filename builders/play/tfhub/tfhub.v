module tfhub

import freeflowuniverse.crystallib.docker
import threefoldtech.builders.core.base

pub fn build(args docker.BuildArgs) ! {
	mut engine := args.engine

	// make sure dependency has been build
	base.build(engine: engine, reset: args.reset, strict: args.strict)!

	// specify we want to build an alpine version
	mut r := engine.recipe_new(name: "tfhub", platform: .alpine)

	// starting from light base image
	r.add_from(image: "base", alias: "builder")!

	deps := "alpine-sdk git autoconf automake libtool libtar-dev zlib-dev jansson-dev \
	         capnproto-dev hiredis-dev sqlite-dev libb2-dev fts musl-fts-dev linux-headers \
			 snappy-dev curl-dev"

	r.add_package(name: deps)!

	// fetch dependencies source code
	r.add_codeget(url: "https://github.com/threefoldtech/0-db", dest: "/code/zdb")!
	r.add_codeget(url: "https://github.com/threefoldtech/0-flist", dest: "/code/zflist")!
	r.add_codeget(url: "https://github.com/opensourcerouting/c-capnproto", dest: "/code/capnpc")!

	// building capnpc not available in apk
	r.add_run(
		cmd: "
			cd /code/capnpc
			git submodule update --init --recursive
			autoreconf -f -i -s
			./configure
			make
			make install
		"
	)!

	// compiling zdb
	r.add_run(
		cmd: "
			make -C /code/zdb/libzdb release
			make -C /code/zdb/zdbd release
		"
	)!

	// compiling zflist
	r.add_run(
		cmd: "
			make -C /code/zflist/libflist alpine
			make -C /code/zflist/zflist alpine
		"
	)!

	// download customized config easier to populate
	configurl := "https://raw.githubusercontent.com/threefoldtech/builders/development/builders/play/tfhub/config.py.sample"
	r.add_run(cmd: "wget $configurl -O /root/config.py")!



	r.add_from(image: 'base', alias: 'installer')!
	
	// download hub source code
	r.add_codeget(url: "https://github.com/threefoldtech/0-hub", dest: "/code/hub")!

	// copy binaries from builder, we don't keep source files
	r.add_copy(from: "builder", source: "/code/zdb/zdbd/zdb", dest: "/bin/zdb")!
	r.add_copy(from: "builder", source: "/code/zflist/zflist/zflist", dest: "/bin/zflist")!
	r.add_copy(from: "builder", source: "/root/config.py", dest: "/root/config.py")!

	// but we need to add runtime libraries dependencies
	r.add_package(name: "libtar libb2 zlib jansson hiredis sqlite fts snappy curl sqlite-libs openssl")!
	
	r.add_sshserver()!

	// runtime python dependencies
	r.add_package(name: "python3 py3-requests py3-pip py3-flask py3-pynacl py3-redis py3-pytoml")!

	// runtime python dependencies not available via apk
	r.add_run(cmd: "pip3 install python-jose docker")!

	// create customized config not runtime dependant
	r.add_run(
		cmd: "
			cd /code/hub/src
			cp /root/config.py ./config.py
			
			sed -i 's#ZFLIST-BIN#/bin/zflist#' config.py
		"
	)!

	// put back sample config file
	r.add_zinit_cmd(
		name: "zdb", 
		oneshot: true,
		exec: "
			zdb --background --protect --admin superadmin
		"
	)!

	// generate config from environment
	r.add_zinit_cmd(
		name: "hub-config",
		after: "zdb",
		oneshot: true,
		exec: "
			if [ -z \$HUB_HOSTNAME ]; then
				HUB_HOSTNAME=hub.example.io
			fi

			cd /code/hub/src

			rm -f private.key
			openssl genpkey -algorithm x25519 -out private.key

			privkey=\$(openssl pkey -in private.key -text | xargs | sed -e 's/.*priv\\:\\(.*\\)pub\\:.*/\\1/' | xxd -r -p | base64)
			seed=\$(python -c 'import nacl; from nacl import utils; print(nacl.utils.random(32))' | sed 's/\\\\/\\\\\\\\/g')

			sed -i \"s#THREEBOT-PRIVKEY#\$privkey#\" config.py
			sed -i \"s/THREEBOT-SEED/\$seed/\" config.py
			sed -i \"s/THREEBOT-APPID/TEST.TEST/\" config.py

			sed -i 's/BACKEND-INTERNAL-HOST/127.0.0.1/' config.py 
			sed -i 's/BACKEND-INTERNAL-PORT/9900/' config.py
			sed -i 's/BACKEND-INTERNAL-PASS/superadmin/' config.py
			sed -i 's/BACKEND-INTERNAL-NAME/default/' config.py

			sed -i 's/BACKEND-PUBLIC-HOST/no.clue/' config.py
			sed -i 's/BACKEND-PUBLIC-PORT/9900/' config.py
			sed -i 's/BACKEND-PUBLIC-NAME/default/' config.py

			sed -i 's/LISTEN-ADDR/::/' config.py
			sed -i 's/LISTEN-PORT/80/' config.py
			sed -i 's/DEBUG-ENABLED/False/' config.py

			sed -i 's#PUBLIC-WEBSITE#http://TEST#' config.py
		"
	)!


	// the hub server process
	r.add_zinit_cmd(
		name: "hub",
		after: "hub-config",
		exec: "
		    cd /code/hub/src
			python flist-uploader.py
		"
	)!

	r.build(args.reset)!
}
