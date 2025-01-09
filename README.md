# Kieran's Dotfiles

Only for Kieran really

## Simple, just curl the basics (bash, tmux, vim)

With curl, assuming bash is your shell

```bash
curl --silent https://raw.githubusercontent.com/kism/dotfiles/main/setup_simple.sh | bash && . ~/.bashrc && bind -f ~/.inputrc
```

Gui systems, Assumes you have zsh and git installed

```bash
curl --silent https://raw.githubusercontent.com/kism/dotfiles/main/setup_simple.sh | bash -s -- --gui
curl --silent https://raw.githubusercontent.com/kism/dotfiles/main/setup_simple.sh | bash -s -- --no-package-install

```

## Simple, setup the basics (bash, tmux, vim), for an air-gapped system

With a proper air-gapped system, you can use the generate script and then paste the output `generated.txt` into the terminal

```bash
bash setup_simple_generate.sh
```

## Just Run stow

`stow --no-folding --adopt --target=$HOME --stow .`

Learn more from the cheat sheet [here](README_STOW.md)

## Complete install (Install packages, stow dotfiles)

This runs stow per the section above

```bash
bash setup.sh
```

If you have run before and don't need to install packages and update all

```bash
bash setup.sh --no-package-install
```
