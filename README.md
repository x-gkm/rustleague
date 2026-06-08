# rustleague
Run rust on [algoleague](https://algoleague.com/)

## Running
#### Dependencies
- nightly rust
- rust-src
- `wasi-libc-devel` on fedora
- jq
- wabt

### Nix
```bash
nix run github:x-gkm/rustleague
```

### Docker
```bash
$ docker build . -t rustleague
$ docker run -it --rm -v .:/workspace rustleague bash
```
