# gitignore.io: fetch .gitignore templates for given languages
def _gitignoreio_list [] {
  http get https://www.toptal.com/developers/gitignore/api/list
  | str replace -a "\n" ","
  | split row ","
  | str trim
  | where {|x| $x != ""}
}

def "nu-complete gi" [] {
  let fixed = ["list"]
  let templates = (_gitignoreio_list)
  $fixed ++ $templates
}

def gi [...args: string@"nu-complete gi"] {
  if "list" in $args {
    return (_gitignoreio_list)
  }

  # join templates with commas and fetch the .gitignore
  let joined = ($args | sort | str join ",")
  http get $"https://www.toptal.com/developers/gitignore/api/($joined)"
}
