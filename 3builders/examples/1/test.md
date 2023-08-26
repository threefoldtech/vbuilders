
```javascript

//include a file or a directory, only runner actions will be executed, these are only processed in memory
!!runner.include source:'https://github.com/threefoldtech/vbuilders/tree/development/3builders/examples/vars'

//root: is where we will checkout all the actions, if not specified is /root/actions
//circle: is the circle for which we execute
!!runner.config circle:'' root:'' 

//will add an action can be https file, https git, scp, or local path
!!runner.recipe_add source:'${ROOT}/core/base0' aname:'base0' execute:1

//cannot define the name when we add a directory to it
!!runner.recipe_add source:'${ROOT}/core' execute:1 

```

