> _Wahoo_: The [Fishshell][Fishshell] Framework

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
<b><a href="#about">Start</a></b>
|
<b><a href="#install">Install</a></b>
|
<b><a href="#usage">Usage</a></b>
|

<b><a href="DOC.md">Documentation</a></b>
|
<b><a href="https://github.com/bucaran/wahoo/wiki">Wiki</a></b>
|
<b><a href="#contributing">Contributing</a></b>
|
<b><a href="#uninstall">Uninstall</a></b>
</p>

<br>

# About [![Join the chat at https://gitter.im/bucaran/wahoo](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/bucaran/wahoo?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

_Wahoo_ is an all-purpose framework and decentralized package manager for the [fishshell][Fishshell]. It looks after your configuration and packages. It's light, fast and easy to use.

# Install [![][TravisLogo]][Travis]
> Use `sudo` if you need to install [fish][Fishshell].

```sh
curl -L git.io/wa | sh
wa help
```

### About `sudo`

You don't need to use `sudo` if you already have `fish` installed or use [Homebrew](http://brew.sh/), but if you are starting from scratch you need to `sudo` in order to install `fish` along with its dependencies and change the system's default shell.

# Usage

## `wa update`

Update the framework using [`Git`][Git].

Updates are constructive. Unstaged changes are [stashed](https://git-scm.com/book/no-nb/v1/Git-Tools-Stashing) and reapplied after pulling updates from upstream. Similarly, if you have committed changes to the repo they are [rebased](https://git-scm.com/book/en/v2/Git-Branching-Rebasing) with master.

## `wa get` _`<package>`_

Install one or more themes or packages. Discover packages with `wa get` and themes with `wa use` . _If_ the package is already installed Wahoo will __update__ it.

## `list`

List all installed packages.

## `use` _`<theme>`_

Apply a theme. To list all available themes type `wa use`.

## `remove` _`<package>`_

Remove a theme or package. Packages subscribed to `uninstall_<pkg>` events will be called before the package is removed to allow custom cleanup of resources, etc. See [Documentation](DOC.md#uninstall).

## `new pkg/theme` _`<name>`_


Create a new package or theme from a template.

A new directory is created under `$WAHOO_CUSTOM/[themes|pkg]/` (or `$WAHOO_PATH/[themes|pkg]/` if that fails).

## `submit` _`<package>`_

> Current directory must be under `git` source control and have a remote origin.

Create a new branch `add-<package name>` in your local fork of Wahoo and adds a new entry to the local registry under `$WAHOO_PATH/db` using the [`$PWD`](http://en.wikipedia.org/wiki/Working_directory) git remote origin.

This also forks Wahoo (if you haven't already) and updates your clone's remote [origin](http://stackoverflow.com/questions/9529497/what-is-origin-in-git) and [upstream](http://stackoverflow.com/questions/2739376/definition-of-downstream-and-upstream).

### `submit` _`<package>`_ `--url` _`<url>`_

Add _`package`_ and  _`url`_ to the local registry without opening a PR.

See [Submitting a Package](https://github.com/bucaran/wahoo/wiki/Screencasts#submitting-a-package).

If you prefer to roll your own, simply add a new file `<package name>.pkg` or `<theme name>.theme` with the remote URL in `$WAHOO_PATH/db` and _submit your PR_. See [Documentation](DOC.md#submitting-a-package).

## `wa help`

Display help on the console.

## `wa version`

Display version.

## `wa destroy`

Uninstall _Wahoo_. See [uninstall](#uninstall) for more information.

# Contributing

Just try Wahoo to handle your fish configuration. If you think something is missing, want a new theme or find a bug, please [open an issue](https://git.io/wahoo-issues) or create a PR.

Consult the [documentation](DOC.md) to learn more about creating packages.


# Uninstall

To remove Wahoo, run `wa destroy`. This removes both `$HOME/.wahoo` and `$HOME/.config/wahoo`, restores you `fish` configuration in `$HOME/config/fish/config.fish` and attempts to uninstall each plugin by emitting `uninstall_<pkg>` events to subscribed packages. Packages can use this event to correctly remove their own configuration, resources, etc

# License

[MIT](http://opensource.org/licenses/MIT) © [Jorge Bucaran][Author] et [al](https://github.com/bucaran/wahoo/graphs/contributors)

[Author]: http://about.bucaran.me
[TravisLogo]: http://img.shields.io/travis/bucaran/wahoo.svg?style=flat-square
[Travis]: https://travis-ci.org/bucaran/wahoo
[Fishshell]: http://fishshell.com
[Git]: https://git-scm.com/


