Write-Host "------------------------------------------------" -ForegroundColor DarkCyan
Write-Host "Building Container....." -ForegroundColor DarkYellow
$image = "dc16363cfccdd7e501c33bcdf2b8698147e98753e6e0cfb98477666b69db10df"
$con_id = docker create -it $image
Write-Host "------------------------------------------------" -ForegroundColor DarkCyan
Write-host "Container ID: $($con_id)" -ForegroundColor Green
Write-Host "------------------------------------------------" -ForegroundColor DarkCyan
Write-Host "Running Scripts....." -ForegroundColor DarkYellow

# -----------------------------------------
$jobslist = (
    "docker cp .\\assets\\...",
foreach ($item in $jobslist) {
    Start-Job -ScriptBlock { Invoke-Expression $($args) } -ArgumentList $item
}

# ------------------------------------------
$list = Get-Job
foreach ($item in $list.id) {
    Receive-Job $item -AutoRemoveJob -Wait
}
# ------------------------------------------
Write-Host "------------------------------------------------" -ForegroundColor DarkCyan
Write-Host "Jobs Complete" -ForegroundColor DarkYellow
Write-Host "------------------------------------------------" -ForegroundColor DarkCyan
Write-Host "Starting Container......" -ForegroundColor DarkYellow
docker start $con_id
Write-Host "Running Tasks......" -ForegroundColor DarkYellow
# docker attach $con_id