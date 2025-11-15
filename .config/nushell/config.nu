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

  keybindings: [
    {
      name: fuzzy_history_fzf
      modifier: control
      keycode: char_r
      mode: [emacs , vi_normal, vi_insert]
      event: {
        send: executehostcommand
        cmd: "commandline edit --replace (
          history
            | get command
            | reverse
            | uniq
            | str join (char -i 0)
            | fzf --scheme=history --read0 --tiebreak=chunk --layout=reverse --preview='echo {..}' --preview-window='bottom:3:wrap' --bind alt-up:preview-up,alt-down:preview-down --height=70% -q (commandline) --preview='echo -n {} | nu --stdin -c \'nu-highlight'''
            | decode utf-8
            | str trim
        )"
      }
    }
  ]
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
  let fixed = ["list"]
  let templates = _gitignoreio_list
  $fixed ++ $templates
}

def gi [...args: string@"nu-complete gi"] {
  if ($args | where {|x| $x == "list"} | length) > 0 {
    return (_gitignoreio_list)
  }

  # Join templates with commas and fetch .gitignore
  let joined = ($args | sort | str join ",")
  http get $"https://www.toptal.com/developers/gitignore/api/($joined)"
}

# secret copy command
def sc [path: string] {
  ["/run/secrets" ($path)]
  | path join
  | open
  | wl-copy
}
