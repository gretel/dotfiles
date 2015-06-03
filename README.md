> _Wahoo_: The [Fishshell][Fishshell] Framework

[![][TravisLogo]][Travis]
![](https://img.shields.io/badge/100% -Fresh-00cc00.svg?style=flat-square)
![](https://img.shields.io/badge/Wahoo-Framework-00b0ff.svg?style=flat-square)
![](https://img.shields.io/badge/Mac-OSX-FF0066.svg?style=flat-square)
![](https://img.shields.io/badge/Linux-Common-FF0066.svg?style=flat-square)
![](https://img.shields.io/badge/License-MIT-707070.svg?style=flat-square)

<a name="wahoo"></a>

<br>

<p align="center">
<a href="https://github.com/bucaran/wahoo/blob/master/README.md">
<img width="40%" src="https://cloud.githubusercontent.com/assets/8317250/7772540/c6929db6-00d9-11e5-86bc-4f65533243e9.png">
</a>
</p>

<br>

<p align="center">
<b><a href="#about">About</a></b>
|
<b><a href="#install">Install</a></b>
|
<b><a href="#getting-started">Getting Started</a></b>
|

<b><a href="#advanced">Advanced</a></b>
|
<b><a href="https://github.com/bucaran/wahoo/wiki/Screencasts">Screencasts</a></b>
</p>

<br>

# About
[![Join the chat at https://gitter.im/bucaran/wahoo](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/bucaran/wahoo?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

_Wahoo_ is an all-purpose framework and decentralized package manager for the [fishshell][Fishshell]. It looks after your configuration and packages. It's light, fast and easy to use.

# Install
> Use `sudo` if you need to install [fish][Fishshell].

```sh
curl -L git.io/wa | sh
wa help
```

### `sudo`?

You don't need to use `sudo` if you already have `fish` installed or use [Homebrew](http://brew.sh/), but if you are starting from scratch you need to `sudo` in order to install `fish` along with its dependencies and change the system's default shell.

# Getting Started

## `wa update`

Update the framework using [`Git`][Git].

Updates are constructive. Unstaged changes are [stashed](https://git-scm.com/book/no-nb/v1/Git-Tools-Stashing) and reapplied after pulling updates from upstream. Similarly, if you have committed changes to the repo they are [rebased](https://git-scm.com/book/en/v2/Git-Branching-Rebasing) with master.

## `wa get` _`<package>`_

Install one or more themes or packages. Discover packages with `wa get` and themes with `wa use`. If the package is already installed Wahoo will _update_ it.

## `list`

List all installed packages.

## `use` _`<theme>`_

Apply a theme. To list all available themes type `wa use`.

## `remove` _`<package>`_

Remove a theme or package. Packages subscribed to `uninstall_<pkg>` events will be invoked before the package is removed to allow custom cleanup of resources, etc. See [Advanced](#uninstall).

## `new pkg/theme` _`<name>`_

Create a new package or theme from a template.

A new directory will be created under `$WAHOO_CUSTOM/[pkg|themes]/`.

## `submit` _`<package>`_

> The current directory must be under `git` source control and have a remote origin.

Create a new branch `add-<package name>` in your local fork of Wahoo and adds a new entry to the local registry under `$WAHOO_PATH/db` using the [`$PWD`](http://en.wikipedia.org/wiki/Working_directory) git remote origin.

This also forks Wahoo (if you haven't already) and updates your clone's remote [origin](http://stackoverflow.com/questions/9529497/what-is-origin-in-git) and [upstream](http://stackoverflow.com/questions/2739376/definition-of-downstream-and-upstream).

### `submit` _`<package>`_ `--url` _`<url>`_

Add _`package`_ and  _`url`_ to the local registry without opening a PR.

> See [Submitting a Package](https://github.com/bucaran/wahoo/wiki/Screencasts#submitting-a-package).

If you prefer to roll your own, simply add a new `pkg/<package name>` or `themes/<theme name>` with your URL under `$WAHOO_PATH/db` and _submit a PR_.


## `wa help`

Display help on the console.

## `wa destroy`

> Does not remove fish.

Uninstall _Wahoo_. See [uninstall](#uninstall) for more information.

# Advanced

+ [Bootstrap](#bootstrap-process)
+ [Core Library](#core-library)
+ [Packages](#packages)
  + [Names](#names)
  + [Submitting](#submitting)
  + [Directory Structure](#directory-structure)
  + [Initialization](#initialization)
+ [Uninstall](#uninstall)

## Bootstrap Process

Wahoo's bootstrap script installs `git`, `fish` if not already installed, changes your default shell to `fish` and modifies `$HOME/.config/fish/config.fish` to load the Wahoo `init.fish` script at the start of a shell session.

It also extends the `fish_function_path` to autoload Wahoo's core library under `$WAHOO_PATH/lib` and the `$WAHOO_PATH/pkg` directory.

## `init.fish`

Autoloads Wahoo's packages, themes and _custom_ path (in that order), loading any `<package>.fish` files if available. If this succeeds, emits the `init_<package>` event. See [Initialization](#initialization).

Also autoloads any `functions` directory and sources `init.fish` under the _custom_ path if available.

The _custom_ path, `$HOME/.dotfiles` by default, is defined in `$WAHOO_CUSTOM` and set in `$HOME/.config/fish/config.fish`. You can modify this to your own preferred path.

## Core library

The core library is a minimum set of basic utility functions that you can use in your own packages or at anytime during your shell session.

### `autoload`

Modify the `$fish_function_path` and autoload functions and/or completions.

```fish
autoload "mypkg/utils" "mypkg/core" "mypkg/lib/completions"
```

### `refresh`

refresh Wahoo.

## Packages

Every directory inside `$WAHOO_PATH/pkg` is a _package_. Although themes are similar to other packages, only one theme can be activated at a time, so they are kept in a different directory under `$WAHOO_PATH/themes`.

### Package Names

A package name may only contain lowercase letters without spaces. Hyphens `-` may be used to separate words.

### Submitting

Run `wa submit <package/theme name>` from the package's directory, or by hand, add a plain text file to `$WAHOO_PATH/db/[pkg/themes]/name` with the URL to your repository and submit a [pull request](https://github.com/bucaran/wahoo/pulls).

_Directory Structure_
```
wahoo/
  db/
    pkg/
      mypkg
```
_Contents of_ `mypkg`
```
https://github.com/<USER>/wa-mypkg
```

### Package Directory Structure

A package can be as simple as a `mypkg/mypkg.fish` file exposing only a `mypkg` function, or several `function.fish` files, a `README` file, a `completions/mypkg.fish` file with fish [tab-completions](http://fishshell.com/docs/current/commands.html#complete), etc.

+ Example:

```
mypkg/
  README.md
  mypkg.fish
  completions/mypkg.fish
```

### Initialization

Wahoo loads each `$WAHOO_PATH/<pkg>.fish` on startup and [emits](http://fishshell.com/docs/current/commands.html#emit) `init_<pkg>` events to subscribers with the full path to the package.

```fish
function init -a path --on-event init_mypkg
end

function mypkg -d "My package"
end
```

Use the `init` event set up your package environment, load resources, autoload functions, etc.

> Writing an event handler for the `init` event is optional.

### Uninstall

Wahoo emits `uninstall_<pkg>` events before a package is removed via `wahoo remove <pkg>`. Subscribers can use the event to clean up custom resources, etc.

```fish
function uninstall --on-event uninstall_pkg
end
```

# License

[MIT](http://opensource.org/licenses/MIT) © [Jorge Bucaran][Author] et [al](https://github.com/bucaran/wahoo/graphs/contributors)

[Author]: http://about.bucaran.me
[TravisLogo]: http://img.shields.io/travis/bucaran/wahoo.svg?style=flat-square
[Travis]: https://travis-ci.org/bucaran/wahoo
[Fishshell]: http://fishshell.com
[Git]: https://git-scm.com/


