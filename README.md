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

# About [![][TravisLogo]][Travis]

_Wahoo_ is an all-purpose framework and decentralized package manager for the [fishshell][Fishshell]. It looks after your configuration and packages. It's light, fast and easy to use.

# Install
> Requires `sudo` to install [fish][Fishshell] and other [dependencies](#deps).

```sh
curl -L git.io/wa | sh
wa help
```

### About `sudo`

You don't need to use `sudo` if you already have `fish` installed or use [Homebrew](http://brew.sh/), but if you are starting from scratch you need to `sudo` in order to install `fish`, its dependencies and change the system's default shell.

# Usage

> Each command is preceded by `wa`, e.g, `wa help`

## `update`

Update the framework using [`Git`][Git].

Updates are constructive. Unstaged changes are [stashed](https://git-scm.com/book/no-nb/v1/Git-Tools-Stashing) and reapplied after pulling updates from upstream. Similarly, if you have committed changes to the repo they are [rebased](https://git-scm.com/book/en/v2/Git-Branching-Rebasing) with master.

## `get <package>`

Install one or more themes or packages. Discover packages with `wa get` and themes with `wa use` _without_ arguments. If the package is already installed Wahoo will update it.

## `list`

List all packages in the registry. Same as `wa get` _without_ arguments.

## `use <theme>`

Apply a theme. If the theme is not installed, Wahoo will download it from the registry. To list all available themes type `wa use`.

## `remove <package>`

Remove a theme or package. Packages listening to `uninstall` events will be called before the package is removed from disk to allow custom cleanup of resources, etc. See [Documentation](DOC.md#uninstall).

## `new pkg|theme <name>`

Create a new directory in `$WAHOO_CUSTOM/[themes|pkg]/<name>` or `$WAHOO_PATH/[themes|pkg]/<name>` if that fails and copy a starting template for the new package. The template for packages is the same as `themes/default/fish_prompt.fish`. For regular packages it's created in the fly.

## `submit <package>`

> Current directory must be under `git` source control and have a remote origin.

Creates a new branch `add-<package name>` in your local fork of Wahoo and adds a new entry to the local registry under `$WAHOO_PATH/db` using the [`$PWD`](http://en.wikipedia.org/wiki/Working_directory) git remote origin. If you haven't forked Wahoo, this forks the project on GitHub and updates your local clone remote [origin](http://stackoverflow.com/questions/9529497/what-is-origin-in-git) and [upstream](http://stackoverflow.com/questions/2739376/definition-of-downstream-and-upstream).

Finally, the GitHub's repository is opened in your preferred browser. You can submit a PR from there.

If you prefer to roll your own, simply add a new file `<package name>.pkg` or `<theme name>.theme` with the remote URL to `$WAHOO_PATH/db` and submit your PR. See [Documentation](DOC.md#submitting-a-package).

## `help`

Display the help page on the console.

## `version`

Display version.

## `destroy`

Uninstall _Wahoo_. See [uninstall](#uninstall) for more information.

# Contributing

Just start using Wahoo to handle your fish configuration. If you think something is missing, make a theme or find a bug, consider creating a PR.

Consult the [documentation](DOC.md) to learn more about creating packages.


# Uninstall

To remove Wahoo, run `wa destroy`. This removes the directories in `$HOME/.wahoo` and `$HOME/.config/wahoo`, restores you `fish` configuration in `$HOME/config/fish/config.fish` and attempts to uninstall each plugin by emitting `uninstall_<pkg>` event to which packages can subscribe to correctly remove their own configuration, resources, etc

# License

[MIT](http://opensource.org/licenses/MIT) © [Jorge Bucaran][Author] et [al](https://github.com/bucaran/wahoo/graphs/contributors)

[Author]: http://about.bucaran.me
[TravisLogo]: http://img.shields.io/travis/bucaran/wahoo.svg?style=flat-square
[Travis]: https://travis-ci.org/bucaran/wahoo
[Fishshell]: http://fishshell.com
[Git]: https://git-scm.com/


