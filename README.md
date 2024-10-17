# Kieran's Dotfiles

Only for Kieran really

## Simple, just curl the basics (bash, tmux, vim)

With curl

```bash
curl --silent https://raw.githubusercontent.com/kism/dotfiles-simple/main/setup.sh | bash && . ~/.bashrc && bind -f ~/.inputrc
```

## Simple, setup the basics (bash, tmux, vim), for an air-gapped system

With a proper air-gapped system, you can use the generate script and then paste the output `generated.txt` into the terminal

```bash
bash setup_simple_generate.sh
```

## Full (Real) install

This runs stow `stow --no-folding --adopt --target=$HOME --stow .` , learn more from the cheat sheet [here](README_STOW.md)

```bash
bash setup.sh
```

If you have run before and don't need to install packages and update all

```bash
bash setup.sh --no-package-install
```
