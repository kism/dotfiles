# Kieran's Dotfiles

Only for Kieran reallly

## Simple, just curl the basics (bash, tmux, vim)

With curl

```bash
curl --silent https://raw.githubusercontent.com/kism/dotfiles-simple/main/setup.sh | bash && . ~/.bashrc && bind -f ~/.inputrc
```

With a proper airgapped system, you can use the generate script and then paste the output `generated.txt` into the terminal

```bash
bash setup_simple_generate.sh
```

## All dotfiles, using gnu stow

### Test

Test normal

```bash
stow --simulate -v 3 --target=$HOME --stow .
```

Test adopt

```bash
stow --simulate --adopt -v 3 --target=$HOME --stow .
```

Test with a temp folder

```bash
mkdir /tmp/stowtest
stow  --target=/tmp/stowtest --stow .
ls -lah /tmp/stowtest
tree -a /tmp/stowtest
```

### Production

Stow

```bash
stow  --target=$HOME --stow .
```

Stow and override existing files

```bash
stow --adopt --target=$HOME --stow .
```

Unstow

```bash
stow  --target=$HOME --delete .
```

Restow

```bash
stow  --target=$HOME --restow .
```

## Packages per environment

```bash
./setup.sh
```
