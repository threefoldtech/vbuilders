## TFGrid SDK

An environment to test the TFGrid based on vlang and javascript client.

### docker-compose

1. the `docker-compose.yaml` file manage a container that provide a test environment for tfgrid funcitionlity with the required tools.
    - the image can be built from this [builder](../builders/devenv/Dockerfile)
    - required EnvVars
        - `NETWORK`: the tf-chain network. (`dev`, `qa`, `test` or `main`)
        - `MNEMONICS`: should have a twin id on the chian.
    - mounted volumes:
        - `/etc/zinit`: zinit services files
        - `/etc/tmuxp`: examples to load in a tmux session
        - `/root/scripts`: some vlang scripts that runs to test the funcitonality of the grid.
2. up
    ```bash
    docker compose up -d
    ```
3. down
    ```bash
    docker compose down
    ```
4. enter the container
    ```bash
    docker compose exec -it devenv bash
    ```


### zinit services

- `config-client`: a bash script that runs one time to place the envvars (network, mnemonics) in the server config. 
- `http-server`: an http server that exposes the functionality of gridclient
- `redis`: runs a redis server
- `tmuxp`: uses tmuxp to load tmux session from a yaml file.

### tmuxp example

Found [here](./tmuxp/example.yaml).
It create a tmux session with a window seperated into 4 panes in each pane on of the v scripts is running.

### V scripts 

see the scritps [docs](./scripts/README.md)

### Useful commands

Inside the container you can interact and see the status of the running services:

#### check if all services successed

```bash
zinit list
```

#### see the logs of all services

```bash
zinit log
```

#### or a log for specific service

```bash
zinit log | grep <service-name>
```

#### to interact with vlang script you can easily attach to the tmux session

```bash
tmux a
```
