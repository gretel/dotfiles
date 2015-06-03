<p align="center">
<a href="https://github.com/bucaran/wahoo/blob/master/README.md">
<img width="20%" src="https://cloud.githubusercontent.com/assets/8317250/7772540/c6929db6-00d9-11e5-86bc-4f65533243e9.png">
</a>
</p>

<br>
<p align="center">
<b><a href="#bootstrap-process">Bootstrap</a></b>
|
<b><a href="#core-library">Core</a></b>
|
<b><a href="#packages">Packages</a></b>
|
<b><a href="#submitting">Submitting</a></b>
|
<b><a href="#package-directory-structure">Structure</a></b>
|
<b><a href="#initialization">Initialization</a></b>
|
<b><a href="#uninstall">Uninstall</a></b>
</p>
<br>


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

Wahoo loads each `$WAHOO_PATH/<pkg>.fish` on startup and [emit](http://fishshell.com/docs/current/commands.html#emit) `init_<pkg>` events to subscribers with the full path to the package.

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