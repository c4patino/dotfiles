$env.config = {
  buffer_editor: "nvim"
  edit_mode: "vi"
  show_banner: false

  hooks: {
    pre_prompt: [{ ||
      if (which direnv | is-empty) {
        return
      }

      direnv export json | from json | default {} | load-env
      if 'ENV_CONVERSIONS' in $env and 'PATH' in $env.ENV_CONVERSIONS {
        $env.PATH = do $env.ENV_CONVERSIONS.PATH.from_string $env.PATH
      }
    }]
  }
}

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

source ~/.zoxide.nu

source ~/.cache/carapace/init.nu

# gitignore.io command
def _gitignoreio_list [] {
    http get https://www.toptal.com/developers/gitignore/api/list
    | str replace -a "\n" ","
    | split row ","
    | str trim
    | where {|x| $x != ""}
}

def "nu-complete gi" [] {
    _gitignoreio_list
}

def gi [...args: string@"nu-complete gi"] {
    if ($args | length) > 0 and $args.0 == "list" {
        do { _gitignoreio_list }
    }

    let joined = ($args | str join ",")
    http get $"https://www.toptal.com/developers/gitignore/api/($joined)"
}

# take command
def take [path: string] {
    mkdir $path
    cd $path
}
