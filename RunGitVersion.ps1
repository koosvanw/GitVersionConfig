
function RunGitversion {
  param (
    [string]$branchname
  )

  git checkout $branchname -f | Out-Null
  Copy-Item -Path .\GitVersion.yml.bak -Destination .\GitVersion.yml -Force
  $time = Measure-Command { dotnet-gitversion /output json /showvariable FullSemVer | Tee-Object -Variable version }
  $timeInSeconds = $time.TotalSeconds.ToString("0")
  Write-Host "Found $version in $timeInSeconds seconds on branch $branchname"
  return "$version,$timeInSeconds,"
}
$output = ""

$output += RunGitversion "RC-4.20.0"
$output += RunGitversion "develop"
$output += RunGitversion "main"
$output += RunGitversion "DoMakeFixAsFeatyre"
$output += RunGitversion "DevFeature"
$output += RunGitversion "FixesInRc"

Write-Host 
Write-Host $output
