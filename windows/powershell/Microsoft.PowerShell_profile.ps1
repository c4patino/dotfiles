#===============================================================================
#  plugins
#===============================================================================
# direnv init
$env:DIRENV_CONFIG = Join-Path $env:APPDATA "direnv\config"
$env:XDG_DATA_HOME = Join-Path $env:APPDATA "direnv\data"
$env:XDG_CACHE_HOME = Join-Path $env:APPDATA "direnv\cache"
Invoke-Expression "$(direnv hook pwsh)"

# fzf init
Import-Module PSReadLine
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

# starship init
Invoke-Expression (&starship init powershell --print-full-init | Out-String)
$starshipPrompt = ${function:prompt}
function prompt {
    (& $starshipPrompt).TrimEnd("`r", "`n")
}

# zoxide init
Invoke-Expression (& { (zoxide init powershell --cmd cd | Out-String) })

# carapace init
carapace _carapace powershell | Out-String | Invoke-Expression
