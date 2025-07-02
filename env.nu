# Nushell Environment Config File
#
# version = "0.99.1"

def create_left_prompt [] {
  let dir = ($env.PWD | path basename)

  let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
  let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
  let path_segment = $"($path_color)($dir)(ansi reset)"

  $path_segment
}
# def create_left_prompt [] {
#     let dir = match (do --ignore-errors { $env.PWD | path relative-to $nu.home-path }) {
#         null => $env.PWD
#         '' => '~'
#         $relative_pwd => ([~ $relative_pwd] | path join)
#     }

#     let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
#     let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
#     let path_segment = $"($path_color)($dir)(ansi reset)"

#     $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
# }

def create_right_prompt [] {
  # # create a right prompt in magenta with green separators and am/pm underlined
  # let time_segment = ([
  #     (ansi reset)
  #     (ansi magenta)
  #     (date now | format date '%x %X') # try to respect user's locale
  # ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
  #     str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")

  # let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
  #     (ansi rb)
  #     ($env.LAST_EXIT_CODE)
  # ] | str join)
  # } else { "" }

  # ([$last_exit_code, (char space), $time_segment] | str join)
  ""
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
# FIXME: This default is not implemented in rust code as of 2023-09-08.
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# If you want previously entered commands to have a different prompt from the usual one,
# you can uncomment one or more of the following lines.
# This can be useful if you have a 2-line prompt and it's taking up a lot of space
# because every command entered takes up 2 lines instead of 1. You can then uncomment
# the line below so that previously entered commands show with a single `🚀`.
# $env.TRANSIENT_PROMPT_COMMAND = {|| "🚀 " }
# $env.TRANSIENT_PROMPT_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "" }
# $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }

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

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
# An alternate way to add entries to $env.PATH is to use the custom command `path add`
# which is built into the nushell stdlib:
# use std "path add"
# $env.PATH = ($env.PATH | split row (char esep))
# path add /some/path
# path add ($env.CARGO_HOME | path join "bin")
# path add ($env.HOME | path join ".local" "bin")
# $env.PATH = ($env.PATH | uniq)

# To load from a custom file you can use:
# source ($nu.default-config-dir | path join 'custom.nu')

$env.EDITOR = "nvim"
# $env.TERM = "WezTerm"
# $env.NVM_DIR = "/Users/ryan/.nvm"
# source "/Users/ryan/.nvm/nvm.sh"

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
path add "/Users/ryan/dev/nutorch/rs/nutorch/target/release"
path add "/Users/ryan/dev/chatvim.cli/bin"

# alias pip = pip3.11
# alias python = python3.11

# this is for tch-rs, the tool for putting pytorch in rust
# $env.LIBTORCH_USE_PYTORCH = "1"
# $env.LIBTORCH = (brew --prefix pytorch)
$env.LIBTORCH = "/opt/homebrew/lib/python3.11/site-packages/torch"
$env.LD_LIBRARY_PATH = ($env.LIBTORCH | path join "lib")
$env.DYLD_LIBRARY_PATH = ($env.LIBTORCH | path join "lib")

use std/dirs shells-aliases *
# for the "enter" command

# topiary-cli is a tool for formatting code. there is a plugin for nushell here:
# https://github.com/blindFS/topiary-nushell
# these environment variables are used by the topiary-nushell plugin
$env.TOPIARY_CONFIG_FILE = ($env.XDG_CONFIG_HOME | path join topiary languages.ncl)
$env.TOPIARY_LANGUAGE_DIR = ($env.XDG_CONFIG_HOME | path join topiary languages)

# api keys for ai
source "env_api_keys.nu"

# git completions
source "~/dev/nu_scripts/custom-completions/git/git-completions.nu"
# cargo completions
source "~/dev/nu_scripts/custom-completions/cargo/cargo-completions.nu"

$env.config.plugin_gc = {
  # Settings for plugins not otherwise specified:
  default: {
    enabled: true # set to false to never automatically stop plugins
    stop_after: 10sec # how long to wait after the plugin is inactive before stopping it
  }
  # Settings for specific plugins, by plugin name
  # (i.e. what you see in `plugin list`):
  plugins: {
    torch: {
      stop_after: 10min
    }
    gstat: {
      stop_after: 1min
    }
    inc: {
      stop_after: 0sec # stop as soon as possible
    }
    example: {
      enabled: false # never stop automatically
    }
  }
}
