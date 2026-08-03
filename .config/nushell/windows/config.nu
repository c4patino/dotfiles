$env.config = {
  buffer_editor: "nvim"
  edit_mode: "vi"
  show_banner: false
}

$env.PATH = ($env.PATH 
  | append $"($env.USERPROFILE)/AppData/Local/Programs/nvim-v0.12.2/bin"
  | append $"($env.USERPROFILE)/AppData/Local/Programs/cmake-v4.3.2/bin"
  | append $"($env.USERPROFILE)/AppData/Local/Programs/msys64/ucrt64/bin"
  | append $"($env.USERPROFILE)/AppData/Local/Programs/jdk-25.0.3/bin"
  | append $"($env.USERPROFILE)/AppData/Local/Programs/gradle-8.14.4/bin"
)

#===============================================================================
#  plugins
#===============================================================================
# direnv init
$env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD? | default []
$env.config.hooks.env_change.PWD ++= [{||
  if (which direnv | is-empty) {
    return
  }

  direnv export json | from json | default {} | load-env
}]

# fzf init
$env.config = ($env.config | upsert keybindings [
  {
    name: fuzzy_history_fzf
    modifier: control
    keycode: char_r
    mode: [emacs, vi_normal, vi_insert]
    event: {
      send: executehostcommand
      cmd: "commandline edit --replace (
        history
          | get command
          | reverse
          | uniq
          | str join (char -i 0)
          | fzf --scheme=history --read0 --tiebreak=chunk --layout=reverse --preview='echo {..}' --preview-window='bottom:3:wrap' --bind alt-up:preview-up,alt-down:preview-down --height=70% -q (commandline) --preview='echo -n {} | nu --stdin -c nu-highlight'
          | decode utf-8
          | str trim
      )"
    }
  }
])

# starship init
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# zoxide init
source ~/.zoxide.nu

# carapace init
source ~/.cache/carapace/init.nu

#===============================================================================
#  custom commands
#===============================================================================
# take command
def --env take [dir: path] {
  mkdir $dir
  cd $dir
}

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

def copy-to-clipboard [] {
  if ("WSL_DISTRO_NAME" in ($env | columns)) {
    clip.exe
  } else if (which wl-copy | is-not-empty) {
    wl-copy
  } else if (which xclip | is-not-empty) {
    xclip -selection clipboard
  } else if (which pbcopy | is-not-empty) {
    pbcopy
  } else {
    error make {msg: "No clipboard utility found"}
  }
}

# secret copy command
def sc [path: string] {
  ["/run/secrets" $path]
  | path join
  | open
  | copy-to-clipboard
}
