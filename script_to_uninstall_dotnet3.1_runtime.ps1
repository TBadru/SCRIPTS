write-host "unintsall .net runtime 3.1" -ForegroundColor Green
$products = Get-WmiObject -Class Win32_Product | Where-Object {
    $_.Name -like "*3.1*" -and ($_.Name -like "*Microsoft .NET*" -or $_.Name -like "*AspNetCore*")
}

foreach ($product in $products) {
    Write-Host "Uninstalling: $($product.Name)"
    $product.Uninstall()
}
