module baobab
import freeflowuniverse.crystallib.baobab.actions
import freeflowuniverse.crystallib.osal { download }
import freeflowuniverse.crystallib.pathlib

pub struct Runner{
pub mut:
	root pathlib.Path
	circle string
}


[params]
pub RunnerArgs{
pub mut:
	name string 	//need to give a unique name
	path string 	//existing path to load actions from
	url string 		//if we need to download a file which is not git, contains actions
	giturl string
	gitreset bool 		// to remove all changes
	gitpull bool 		// if you want to force to pull the information
	circle string 		// can be empty by default
	runnerbase string	// is the base of all the actions
}

fn run(args ) ! {

	mut path:=string{}

	if giturl.len>0{
		mut gs := gittools.get(multibranch:true, light:true, root:"~/codemulti")!
		mut gr := gs.repo_get_from_url(url: giturl, pull: args.gitpull, reset: args.gitreset)!
		path = gr.path_content_get() 

	}else if args.url.len>0{


		mut p:=download(
			url:args.url
			reset:false
			dest:'/tmp/@name'
		)!


	}


	ap = actions.new(path: path, defaultcircle: args.circle)!	

	println("See the examples in ${path}/data")


}