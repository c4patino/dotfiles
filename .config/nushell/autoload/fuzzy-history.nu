# fzf-powered history search, bound to Ctrl-R (see settings.keybindings)
def fuzzy-history [] {
  commandline edit --replace (
    history
      | get command
      | reverse
      | uniq
      | str join (char -i 0)
      | fzf --scheme=history --read0 --tiebreak=chunk --layout=reverse --preview-window='bottom:3:wrap' --bind alt-up:preview-up,alt-down:preview-down --height=70% -q (commandline) --preview='echo -n {} | nu --stdin -c nu-highlight'
      | decode utf-8
      | str trim
  )
}
