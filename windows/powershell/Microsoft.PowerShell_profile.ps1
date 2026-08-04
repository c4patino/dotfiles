#===============================================================================
#  plugins
#===============================================================================
# direnv init
Invoke-Expression "$(direnv hook pwsh)"
$env:DIRENV_CONFIG="%APPDATA%\direnv\config"
$env:XDG_DATA_HOME="%APPDATA%\direnv\data"
$env:XDG_CACHE_HOME="%APPDATA%\direnv\cache"

# fzf init
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
