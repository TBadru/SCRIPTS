# Clean-BuildFolders.ps1
# Deletes all 'bin' and 'obj' folders recursively from the current directory

Write-Host "Searching for 'bin' and 'obj' folders..." -ForegroundColor Cyan

Get-ChildItem -Path . -Include bin,obj -Recurse -Directory | ForEach-Object {
    Write-Host "Deleting $($_.FullName)" -ForegroundColor Yellow
    Remove-Item $_.FullName -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host "Cleanup complete." -ForegroundColor Green
