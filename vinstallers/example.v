module main


import freeflowuniverse.crystallib.installers.caddy
import freeflowuniverse.crystallib.installers.postgresql
import freeflowuniverse.crystallib.tmux
import os

const configpath = os.dir(@FILE) + '/config'

fn do() ! {


	// export PGPASSWORD='meet007'
	// export HOST=web2
	// export DEBIAN_FRONTEND=noninteractive
	// # export RESTIC_REPOSITORY=/data/restic
	// export RESTIC_REPOSITORY=s3:https://bckp-s3-02.grid.tf/meet.tf/backups/
	// export RESTIC_PASSWORD=ThisIsMyBackup888
	// export AWS_SECRET_ACCESS_KEY=95a959ace44407d80df1736a63abf39b
	// export AWS_ACCESS_KEY_ID=bckpusr

	// MAIL_FROM           = git@meet.tf
	// SMTP_ADDR      = smtp-relay.brevo.com
	// SMTP_PORT      = 587
	// SMTP_PASSWD         = '0yJcWpH5OKrTfkbw'	
		

	//kill the full tmux session, we will create new one
	mut t := tmux.new()!

	t.session_delete("main")! //kill the full tmux, is not done gracefully

	t.window_new(name: 'mc', cmd: 'mc', reset: true)!	 //launch a window with mc

	caddy.install(reset:true)! //will get the binary and put in /usr/local/bin
	caddy.configuration_set(path:"${configpath}/Caddyfile",restart:true)!

	mut db:=postgresql.new(passwd:'meet007',reset:true)!



}

fn main() {
	do() or { panic(err) }
}
