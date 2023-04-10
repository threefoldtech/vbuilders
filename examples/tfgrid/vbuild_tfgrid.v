
module main




import threefoldtech.builders

fn do() ! {

	dockerregistry_datapath:=""
	// dockerregistry_datapath:="/Volumes/FAST/DOCKERHUB"
	prefix:="despiegk/" //dont forget trailing slash
	reset:=false


	mut ub:=builders.new(dockerregistry_datapath:dockerregistry_datapath,prefix:prefix)!
	
	ub.build_tfgrid(reset:reset)!	

}

fn main() {

	do() or { panic(err) }
}
