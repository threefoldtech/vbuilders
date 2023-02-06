# Description

## These are some scripts that you can run to interact with the grid-client module using Vlang

### Tabel of content

- Scripts target
- How to modify the scripts
- How to add script
- Run the scripts by using `docker-compose`
- Run the scripts by using `Vlang` on the local machine

### Scripts target

the idea of it is, There are a lot of packages that we use in [grid-client-ts](https://github.com/threefoldtech/grid3_client_ts) which are not supported yet in [V](https://vlang.io/), we created a tool named [twinclient](https://github.com/freeflowuniverse/crystallib/tree/development_38/twinclient) that speaks with the [ts-client](https://github.com/threefoldtech/grid3_client_ts) across 3 different types, e.g. HTTP protocol, this tool you can use to interact with our grid and do some functionality

### How to modify the scripts

it's so simple, you just need to open any script in any [code editor](https://en.wikipedia.org/wiki/Source-code_editor) then find the part you want to update e.g. `SSH KEY` then save the file and run it normally

### How to add script

it's also so simple, it does not require modifying anything you only need to be familiar with our tool, then create a new file and start coding, we also suggest that you take a look at [twinclient tool](https://github.com/freeflowuniverse/crystallib/tree/development_38/twinclient), also there are some examples you can take as a [reference](https://github.com/freeflowuniverse/crystallib/tree/development_38/twinclient/examples)

### Run the scripts by using `docker-compose`

check [here](../README.md)

### Run the scripts by using `Vlang` on the local machine

You should run the [http server](https://github.com/threefoldtech/grid3_client_ts/blob/development/docs/http_server.md) for `deploy_vm` and `funds` scripts, if you want to run the `rmb` script you have to run the [rmb server](https://github.com/threefoldtech/rmb_go), otherways, if you implemented your own script so we suggest you to run the correct server [see server docs](https://github.com/threefoldtech/grid3_client_ts/tree/development/docs)

then open a terminal window and excute the script like.

```sh
    v run scripts/funds.v
```

> **Note, Make sure that you have [vlang](https://github.com/vlang/v) on your local machine**
