**Shell Alias**
```sh
alias platform="docker run --rm -it --workdir=/app --entrypoint /usr/local/bin/platform --env PLATFORMSH_CLI_UPDATES_CHECK=0 --env PLATFORMSH_CLI_DISABLE_CACHE=1 --env PLATFORMSH_CLI_TOKEN -v $PWD:/app pjcdawkins/platformsh-cli"
```
