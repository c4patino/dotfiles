param(
    [Parameter(ValueFromRemainingArguments)]
    [string[]]$Paths = @(),

    [switch]$All,

    [switch]$DryRun,

    [ValidateSet("Copy", "Symlink")]
    [string]$Mode
)

$RepoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

$config = Get-Content (Join-Path $RepoRoot "deploy.json") -Raw |
    ConvertFrom-Json

if (-not $Mode) {
    $Mode = (Get-Culture).TextInfo.ToTitleCase($config.defaults.mode)
}

$Ignore = @($config.ignore) |
    ForEach-Object { $_.Replace('/', '\') }

$Mappings = @{}

foreach ($property in $config.mappings.PSObject.Properties) {
    $value = $property.Value.Replace("~", $HOME)
    $value = [Environment]::ExpandEnvironmentVariables($value)

    $Mappings[$property.Name.Replace('/', '\')] = $value
}

$MappingKeys = $Mappings.Keys |
    Sort-Object Length -Descending


function Get-Relative {
    param(
        [string]$FullPath
    )

    $RepoUri = New-Object System.Uri(
        ($RepoRoot.TrimEnd('\') + '\')
    )

    $FileUri = New-Object System.Uri(
        $FullPath
    )

    return $RepoUri.MakeRelativeUri($FileUri).ToString().Replace('/', '\')
}

function Should-Ignore {
    param(
        [string]$Relative
    )

    if ([string]::IsNullOrWhiteSpace($Relative)) {
        return $false
    }

    foreach ($entry in $Ignore) {
        if ($Relative.StartsWith(
            $entry,
            [System.StringComparison]::OrdinalIgnoreCase
        )) {
            return $true
        }

        if ((Split-Path -Path $Relative -Leaf) -eq $entry) {
            return $true
        }
    }

    return $false
}


function Get-TargetPath {
    param(
        [string]$Relative
    )

    foreach ($key in $MappingKeys) {
        if ($Relative.StartsWith(
            $key,
            [System.StringComparison]::OrdinalIgnoreCase
        )) {
            $remaining = $Relative.Substring(
                $key.Length
            ).TrimStart('\')
            if ($remaining -eq '') {
                return $Mappings[$key]
            }

            return Join-Path $Mappings[$key] $remaining
        }
    }

    return Join-Path $HOME $Relative
}

function Install-File {
    param(
        [string]$Source,
        [string]$Target
    )

    $Parent = Split-Path -Path $Target -Parent

    if (-not (Test-Path $Parent)) {
        if ($DryRun) {
            Write-Host "MKDIR  $Parent"
        } else {
            New-Item `
                -ItemType Directory `
                -Force `
                -Path $Parent |
                Out-Null
        }
    }

    if ($DryRun) {
        Write-Host ""
        Write-Host "FROM $Source"
        Write-Host "TO   $Target"

        return
    }

    switch ($Mode) {
        "Copy" {

            Copy-Item `
                -Force `
                -Recurse `
                $Source `
                $Target
        }

        "Symlink" {

            if (Test-Path $Target) {

                Remove-Item `
                    -Force `
                    -Recurse `
                    $Target
            }

            New-Item `
                -ItemType SymbolicLink `
                -Path $Target `
                -Target $Source |
                Out-Null
        }
    }

    Write-Host "Installed $Target"
}


function Deploy-File {
    param(
        [string]$FullPath
    )

    $Relative = Get-Relative $FullPath

    if (Should-Ignore $Relative) {
        return
    }

    $Target = Get-TargetPath $Relative

    Install-File `
        $FullPath `
        $Target
}


function Deploy-Path {
    param(
        [string]$Source
    )

    if (Test-Path $Source -PathType Container) {
        Get-ChildItem `
            $Source `
            -Recurse |
            Where-Object {
                -not $_.PSIsContainer
            } |
            ForEach-Object {
                Deploy-File $_.FullName
            }
    } elseif (Test-Path $Source -PathType Leaf) {

        Deploy-File (
            (Resolve-Path $Source).Path
        )
    } else {

        Write-Warning "$Source does not exist."
    }
}

$Targets = @()

if ($All) {

    $Targets += Get-ChildItem $RepoRoot |
        Where-Object {
            $_.Name -ne ".git"
        } |
        Select-Object -ExpandProperty Name
} else {

    foreach ($path in $Paths) {

        $Targets += $path
    }
}

foreach ($target in $Targets) {
    $Source = Join-Path $RepoRoot $target

    Write-Host ""
    Write-Host "=== $target ==="

    Deploy-Path $Source
}
