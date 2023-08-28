module main

import os
import freeflowuniverse.crystallib.bizmodel
import freeflowuniverse.crystallib.spreadsheet
import freeflowuniverse.crystallib.gittools
import cli { Command, Flag }

fn run_planner(cmd Command) ! {

	mut source:=cmd.args[0]

	dest := cmd.flags.get_string('dest') or {""}


}

fn get_examples(cmd Command) ! {

	mut gs := gittools.get()!

	url := 'https://github.com/ourworldventures/biztools.git'
	mut gr := gs.repo_get_from_url(url: url, pull: false, reset: false)!

	mut path:=gr.path_content_get() 

	println("See the examples in ${path}/data")


}

fn main() {

	mut cmd := Command{
		name: 'bizplanner'
		description: 'Business Planning Tool'
		version: '1.0.0'
	}
	mut docgen_cmd := Command{
		name: 'generate'
		description: 'Generate a business plan'
		usage: '<3scripts path, can be name of example too>'
		required_args: 1
		execute: run_planner
	}
	docgen_cmd.add_flag(Flag{
		flag: .string
		required: false
		name: 'dest'
		abbrev: 'd'
		description: 'Destination where to generate.'
	})


	//code mgmt
	// mut getexamples_cmd := Command{
	// 	name: 'getstarted'
	// 	description: 'get the examples'
	// 	execute: get_examples
	// }
	// docgen_cmd.add_flag(Flag{
	// 	flag: .bool
	// 	required: false
	// 	name: 'reset'
	// 	abbrev: 'r'
	// 	description: 'Reset if something is already there.'
	// })


	cmd.add_command(docgen_cmd)
	cmd.add_command(getexamples_cmd)
	cmd.setup()
	cmd.parse(os.args)

	// do() or { panic(err) }
}
