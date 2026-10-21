# copy stdin to the system clipboard, detecting the available backend
def clip [] {
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
