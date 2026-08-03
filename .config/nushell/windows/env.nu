zoxide init --cmd cd nushell | save -f ~/.zoxide.nu

$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

$env.DIRENV_CONFIG = $"($env.APPDATA)\\direnv\\config"
$env.XDG_CACHE_HOME = $"($env.APPDATA)\\direnv\\cache"
$env.XDG_DATA_HOME = $"($env.APPDATA)\\direnv\\data"
