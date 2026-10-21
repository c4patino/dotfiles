# flat sha256 of a file, as used by fetchurl (pass --unpack for fetchzip's NAR hash)
def nix-prefetch-url-hash [url: string, --unpack] {
  let raw = if $unpack {
    nix-prefetch-url --unpack $url
  } else {
    nix-prefetch-url $url
  }

  let hash = (nix hash convert --hash-algo sha256 --to sri $raw)

  $hash | clip
  $hash
}

# NAR sha256 of an unpacked source tree, as used by fetchFromGitHub
def nix-prefetch-github-hash [spec: string] {
  let parts = ($spec | split row "/")
  if (($parts | length) < 4) {
    error make {msg: "expected <host>/<owner>/<repo>/<tag>"}
  }

  let host = ($parts | get 0)
  let owner = ($parts | get 1)
  let repo = ($parts | get 2)
  let tag = ($parts | skip 3 | str join "/")

  let url = $"https://($host)/($owner)/($repo)/archive/($tag).tar.gz"
  let hash = (nix hash convert --hash-algo sha256 --to sri (nix-prefetch-url --unpack $url))

  $hash | clip
  $hash
}

# nix build an installable; streams output as normal, copies the "got:" hash on failure
def nix-build-clip [pkg: string] {
  let res = (^nix build $pkg | tee --stderr { print } | complete)
  if ($res.stdout | is-not-empty) {
    print --no-newline $res.stdout
  }
  if $res.exit_code == 0 {
    return
  }

  let got = ($res.stderr | parse -r 'got:\s+(?<hash>\S+)' | get hash)
  if ($got | is-empty) {
    error make {msg: $"nix build failed for ($pkg): no got: hash found"}
  }
  $got | last | clip
}
