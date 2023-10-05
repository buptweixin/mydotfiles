# dotfiles

## tmux

1. split panes: `prefix + \`(vertical) or `prefix + -`(horizontal)
2. reload tmux config: `prefix + C-r`
3. create new window:  `prefix + c`
4. rename window: `prefix + ,`, rename session: `prefix + $`
5. switch window: `prefix + C-[` previous-window `prefix + C-]` next-window `prefix + Tab` last window
6. switch panel: `prefix + hjkl` switch to left/down/up/right panel `prefix + C-o/O` swap current pane with the next/previous one
7. zoom pane: `prefix + z`
8. kill pane/window: `prefix + x/X`, kill other window: `prefix + C-x`, kill session `prefix + Q`
9. copy mode: `prefix + [` enter copy mode, `v` start selection, `y` copy selection, `prefix-p` paste selection, `prefix-b` list-buffers, `prefix-P` choose-buffer

## binaries

### ripgrep

ripgrep recursively searches directories for a regex pattern while respecting your gitignore

#### Usage

```sh
rg fast README.md # search for the word "fast" in the README
rg 'fast\w+' README.md # search for words starting with "fast"
rg 'fn write\(' # search for the string "fn write(" in current directory
rg 'fn write\(' src # search for the string "fn write(" in the src directory
rg clap -g '*.toml' # search for the string "clap" in all toml files (manual filtering: globs)
rg clap -g '!*.toml' # search for the string "clap" in all files that are not toml files
rg 'fn run' --type rust # or rg 'fn run' -trust. search for the string "fn run" in all Rust files (manual filtering: file types)
rg fast README.md --replace FAST # or rg fast README.md -r FAST. replace the word "fast" with "FAST" in the README
```

### fd

fd is a program to find entries in your filesystem. It is a simple, fast and user-friendly alternative to find. While it does not aim to support all of find's powerful functionality, it provides sensible (opinionated) defaults for a majority of use cases.

#### Usage

```sh
fd netfl # search for entries starting with "netfl"
fd '^x.*rc$' # search for entries starting with "x" and ending with "rc"
fd passwd /etc # search for entries named "passwd" in the /etc directory
fd # fd can be called with no arguments. This is very useful to get a quick overview of all entries in the current directory, recursively (similar to ls -R)
fd -e md # search for entries named "md" while ignoring their case

# To find files with exactly the provided search pattern, use the -g (or --glob) option:
fd -g libc.so /usr # search for entries named "libc.so" in the /usr directory while ignoring their case 

# ignore
fd -H pre-commit # search for entries named "pre-commit" in the current directory and all subdirectories, while also showing hidden entries
## If we work in a directory that is a Git repository (or includes Git repositories), fd does not search folders (and does not show files) that match one of the .gitignore patterns. To disable this behavior, we can use the -I (or --no-ignore) option
fd -I num_cpu # search for entries named "num_cpu" in the current directory and all subdirectories, while ignoring hidden entries

# matching the full path
fd -p -g '**/.git/config' # search for entries named "config" in all .git directories

# Command execution
fd -e zip -x unzip # search for entries named "zip" and execute unzip on them
fd -e h -e cpp -x clang-format -i # search for entries named "h" or "cpp" and execute clang-format -i on them
fd -e jpg -x convert {} {.}.png # search for entries named "jpg" and execute convert {} {.}.png on them. Here, {} is a placeholder for the search result. {.} is the same, without the file extension.
## Placeholder syntax
### `{}`: A placeholder token that will be replaced with the path of the search result (documents/images/party.jpg).
### `{.}` Like `{}`, but without the file extension (`documents/images/party`).
### `{/}`: A placeholder that will be replaced by the basename of the search result (party.jpg).
### `{//}`: The parent of the discovered path (documents/images).
### `{/.}`: The basename, with the extension removed (party).

# Parallel vs. serial execution
For -x/--exec, you can control the number of parallel jobs by using the -j/--threads option. Use --threads=1 for serial execution.

# Excluding specific files or directories
fd -H -E .git … # search for entries while ignoring hidden entries and entries in .git directories
fd -E /mnt/external-drive … # search for entries while ignoring entries in /mnt/external-drive

```




### koalaman/shellcheck

shellcheck is a static analysis tool for shell scripts. 

#### Usage
```sh
shellcheck script/bootstrap
```

### sharkdp/hyperfine

A command-line benchmarking tool

#### Usage

   ```sh
hyperfine 'sleep 0.3'
hyperfine --runs 5 'sleep 0.3' # change number of runs
hyperfine 'hexdump file' 'xxd file' # compare the runtimes of different programs
hyperfine --warmup 3 'grep -R TODO *' # warmup runs
hyperfine --prepare 'make clean' --parameter-scan num_threads 1 12 'make -j {num_threads}' # benchmark a parameter scan
hyperfine --shell zsh 'for i in {1..10000}; do echo test; done' # intermediate shell
```



   
Your dotfiles are how you personalize your system. These are mine.

I was a little tired of having long alias files and everything strewn about
(which is extremely common on other dotfiles projects, too). That led to this
project being much more topic-centric. I realized I could split a lot of things
up into the main areas I used (Ruby, git, system libraries, and so on), so I
structured the project accordingly.

If you're interested in the philosophy behind why projects like these are
awesome, you might want to [read my post on the
subject](http://zachholman.com/2010/08/dotfiles-are-meant-to-be-forked/).

## topical

Everything's built around topic areas. If you're adding a new area to your
forked dotfiles — say, "Java" — you can simply add a `java` directory and put
files in there. Anything with an extension of `.zsh` will get automatically
included into your shell. Anything with an extension of `.symlink` will get
symlinked without extension into `$HOME` when you run `script/bootstrap`.

## what's inside

A lot of stuff. Seriously, a lot of stuff. Check them out in the file browser
above and see what components may mesh up with you.
[Fork it](https://github.com/holman/dotfiles/fork), remove what you don't
use, and build on what you do use.

## components

There's a few special files in the hierarchy.

- **bin/**: Anything in `bin/` will get added to your `$PATH` and be made
  available everywhere.
- **Brewfile**: This is a list of applications for [Homebrew Cask](https://caskroom.github.io) to install: things like Chrome and 1Password and Adium and stuff. Might want to edit this file before running any initial setup.
- **topic/\*.zsh**: Any files ending in `.zsh` get loaded into your
  environment.
- **topic/path.zsh**: Any file named `path.zsh` is loaded first and is
  expected to setup `$PATH` or similar.
- **topic/completion.zsh**: Any file named `completion.zsh` is loaded
  last and is expected to setup autocomplete.
- **topic/install.sh**: Any file named `install.sh` is executed when you run `script/install`. To avoid being loaded automatically, its extension is `.sh`, not `.zsh`.
- **topic/\*.symlink**: Any file ending in `*.symlink` gets symlinked into
  your `$HOME`. This is so you can keep all of those versioned in your dotfiles
  but still keep those autoloaded files in your home directory. These get
  symlinked in when you run `script/bootstrap`.

## install

Prerequirements:

[neovim](https://github.com/neovim/neovim)

Run this:

```sh
git clone https://github.com/buptweixin/mydotfiles.git ~/.dotfiles
cd ~/.dotfiles
git checkout nobrew
script/bootstrap
```

This will symlink the appropriate files in `.dotfiles` to your home directory.
Everything is configured and tweaked within `~/.dotfiles`.

The main file you'll want to change right off the bat is `zsh/zshrc.symlink`,
which sets up a few paths that'll be different on your particular machine.

`dot` is a simple script that installs some dependencies, sets sane macOS
defaults, and so on. Tweak this script, and occasionally run `dot` from
time to time to keep your environment fresh and up-to-date. You can find
this script in `bin/`.

## bugs

I want this to work for everyone; that means when you clone it down it should
work for you even though you may not have `rbenv` installed, for example. That
said, I do use this as *my* dotfiles, so there's a good chance I may break
something if I forget to make a check for a dependency.

If you're brand-new to the project and run into any blockers, please
[open an issue](https://github.com/buptweixin/mydotfiles/issues) on this repository
and I'd love to get it fixed for you!

## thanks

I forked [Ryan Bates](http://github.com/ryanb)' excellent
[dotfiles](http://github.com/ryanb/dotfiles) for a couple years before the
weight of my changes and tweaks inspired me to finally roll my own. But Ryan's
dotfiles were an easy way to get into bash customization, and then to jump ship
to zsh a bit later. A decent amount of the code in these dotfiles stem or are
inspired from Ryan's original project.
