
```javascript

//include a file or a directory, only runner actions will be executed, these are only processed in memory
!!runner.include source:'https://github.com/threefoldtech/vbuilders/tree/development/3builders/examples/vars'


//will add an action can be https file, https git, scp, or local path
!!runner.recipe_add source:'${ROOT}/core/base0' aname:'base0' execute:1

//cannot define the name when we add a directory to it
!!runner.recipe_add source:'${ROOT}/core' execute:1 

```

