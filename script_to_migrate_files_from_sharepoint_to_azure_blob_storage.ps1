# Ensure TLS 1.2 for secure connections
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Import required modules
Import-Module PnP.PowerShell
Import-Module Az.Storage

# SharePoint connection info
$sharePointSite = ""
$folderUrl = ""  # Site-relative folder path

# Azure Blob Storage info
$storageAccountName = ""
$storageAccountKey = ""
$containerName = ""

# Connect to SharePoint
Connect-PnPOnline -Url $sharePointSite -Interactive -ClientId 19de4886-dd80-40a6-8cda-c58f3bff1d3d

# ✅ Get all PDF files with their server-relative URLs
$files = Get-PnPFolderItem -FolderSiteRelativeUrl $folderUrl -ItemType File | Where-Object { $_.Name -like "*.pdf" }

# Create Azure Storage context
$storageContext = New-AzStorageContext -StorageAccountName $storageAccountName -StorageAccountKey $storageAccountKey

# Check if container exists; create if not
$container = Get-AzStorageContainer -Name $containerName -Context $storageContext -ErrorAction SilentlyContinue
if (-not $container) {
    Write-Host "Creating container: $containerName"
    New-AzStorageContainer -Name $containerName -Context $storageContext | Out-Null
}

# Process each file
foreach ($file in $files) {
    $fileName = $file.Name
    $serverRelativeUrl = $file.ServerRelativeUrl   # ✅ Use actual server-relative URL from SharePoint

    Write-Host "`nDownloading: $serverRelativeUrl..."

    # Download the file to a temp directory
    $tempFile = Join-Path $env:TEMP $fileName
    Get-PnPFile -Url $serverRelativeUrl -Path $env:TEMP -FileName $fileName -AsFile -Force

    Write-Host "Uploading $fileName to Azure Blob Storage..."

    # Upload to Azure Blob Storage
    Set-AzStorageBlobContent -File $tempFile -Container $containerName -Blob $fileName -Context $storageContext -Force | Out-Null

    Write-Host "Uploaded: $fileName"

    # Remove the temp file
    Remove-Item $tempFile -Force
}

Write-Host "`n✅ Migration complete. All PDFs have been uploaded to Azure Blob Storage."
