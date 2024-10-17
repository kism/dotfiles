## All dotfiles, using gnu stow

Bit of a cheat sheet, `.stow-local-ignore` has the ignore rules

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
stow  --no-folding --adopt --target=/tmp/stowtest --stow .
ls -lah /tmp/stowtest
tree -a /tmp/stowtest
```

### Production

Stow, the `--no-folding` is important to avoid symlinking folders

```bash
stow --no-folding --target=$HOME --stow .
```

Stow and override existing files

```bash
stow --no-folding --adopt --target=$HOME --stow .
```

Unstow

```bash
stow  --target=$HOME --delete .
```

Restow

```bash
stow  --target=$HOME --restow .
```
