
```javascript

// mut r := engine.recipe_new(name: 'base0', platform: .alpine, zinit: false)

!!builder.recipe_new name:base0 platform:alpine zinit:0

!!builder.recipe_add_file name:base0 
    source:'templates/shell0.sh'
    dest:'/bin/shell.sh'
    make_executable:1

!!builder.recipe_add_file name:base0 
    source:'templates/env.sh'
    dest:'/'

!!builder.recipe_add_package name:base0 
    names:'mc, htop, rsync, wget, openssh, libssh2'

!!builder.recipe_add_package name:base0 
	names:'redis, dumb-init, curl, git, tmux, zsh, bash, ca-certificates'

!!builder.recipe_add_run name:base0
    cmd:
		echo "THREEFOLD BASE DEV ENV WELCOMES YOU" > /etc/motd		
	    echo "yes"

!!builder.recipe_add_cmd name:base0 
    cmd: '/bin/shell.sh'

!!builder.recipe_execute name:base0 


```