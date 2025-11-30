param ($inspectOutputPath)
[PSCustomObject]$styleResults = Get-Content -Path $inspectOutputPath | ConvertFrom-Json

$shouldFail = $false

if($styleResults.runs.results.count -gt 0)
{
    $styleResults.runs.results | ForEach-Object {
        $location = $_.locations[0].physicalLocation
        Write-Host "$( $location.artifactLocation.uri ):$( $location.region.startLine ) - $( $_.message.text )"
        # Any issues found are high enough to fail the build, because the inspect code command we use filters for warning severity level or higher
        $shouldFail = $true
    }
} else {
    Write-Host "No addressable inspection results were found"
}
if($shouldFail -eq $true) {
    Write-Host "##vso[task.complete result=Failed;]Found code inspection issues, failing the build"
    exit 1
}
exit 0