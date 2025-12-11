# This file is loaded first when Nushell starts.
# Info about nushell configuration.
# https://www.nushell.sh/book/configuration.html#configuration-overview
def create_left_prompt [] {
  let dir = ($env.PWD | path basename)

  let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
  let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
  let path_segment = $"($path_color)($dir)(ansi reset)"

  $path_segment
}

def create_right_prompt [] {
  ""
}

$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
  "PATH": {
    from_string: {|s| $s | split row (char esep) | path expand --no-symlink }
    to_string: {|v| $v | path expand --no-symlink | str join (char esep) }
  }
  "Path": {
    from_string: {|s| $s | split row (char esep) | path expand --no-symlink }
    to_string: {|v| $v | path expand --no-symlink | str join (char esep) }
  }
}

# Directories to search for scripts when calling source or use
# The default for this is $nu.default-config-dir/scripts
$env.NU_LIB_DIRS = [
  ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
  ($nu.data-dir | path join 'completions') # default home for nushell completions
]

# Directories to search for plugin binaries when calling register
# The default for this is $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
  ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

$env.EDITOR = "nvim"

# brew and other external packages
use std "path add"
path add "/Users/ryan/bin"
path add "/Users/ryan/dev/lua-language-server/bin"
path add "/opt/homebrew/bin"
path add "/opt/homebrew/opt/mysql-client/bin"
$env.DENO_INSTALL = "/Users/ryan/.deno"
path add "/Users/ryan/.deno/bin"
$env.PNPM_HOME = "/Users/ryan/Library/pnpm"
path add "/Users/ryan/Library/pnpm"
path add "/opt/homebrew/opt/node@24/bin"
$env.CARGO_HOME = "/Users/ryan/.cargo"
path add "/Users/ryan/.cargo/bin"
path add "~/bin"
# my packages
# path add "/Users/ryan/dev/nutorch/rs/nutorch/target/release"
path add "/Users/ryan/dev/chatvim.cli/bin"
path add "/Library/TeX/texbin"
path add "/usr/local/bin"
path add "~/.local/bin"
path add "/Applications/Docker.app/Contents/Resources/bin"
path add "/opt/homebrew/opt/sqlite/bin"

# this is for tch-rs, the tool for putting pytorch in rust
$env.LIBTORCH = "/opt/homebrew/lib/python3.11/site-packages/torch"
$env.LD_LIBRARY_PATH = ($env.LIBTORCH | path join "lib")
$env.DYLD_LIBRARY_PATH = ($env.LIBTORCH | path join "lib")

use std/dirs shells-aliases *
# for the "enter" command, "dexit", "p", "n", "shells"

# topiary-cli is a tool for formatting code. there is a plugin for nushell here:
# https://github.com/blindFS/topiary-nushell
# these environment variables are used by the topiary-nushell plugin
$env.TOPIARY_CONFIG_FILE = ($env.XDG_CONFIG_HOME | path join topiary languages.ncl)
$env.TOPIARY_LANGUAGE_DIR = ($env.XDG_CONFIG_HOME | path join topiary languages)

# api keys for ai
source "env_api_keys.nu"

# aliases
alias vim = nvim
alias macopen = /usr/bin/open

# git completions
source "~/dev/nu_scripts/custom-completions/git/git-completions.nu"
# cargo completions
source "~/dev/nu_scripts/custom-completions/cargo/cargo-completions.nu"

$env.config = {
  edit_mode: vi
  history: {
    file_format: 'sqlite'
    max_size: 100000
    sync_on_enter: true
    isolation: true
  }
}
