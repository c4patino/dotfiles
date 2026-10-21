# copy a sops secret (relative to /run/secrets) to the clipboard
# no completion: /run/secrets.d/N is root:keys r-x, so listing always fails
# depends on clip.nu, which must load first (alphabetical order)
def sc [secret: string] {
  ["/run/secrets" $secret]
  | path join
  | open
  | clip
}
