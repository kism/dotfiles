# Kieran's Dotfiles

Only for Kieran reallly

Use gnu stow

## Test

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

## Prod

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
