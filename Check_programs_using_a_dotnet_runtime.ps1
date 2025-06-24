#Microsoft.NETCore.App
write-host "checking for program that uses Microsoft.NETCore.App 3.1" -ForegroundColor Green
Get-ChildItem -Recurse "C:\Program Files\", "C:\Program Files (x86)\" -Include *.runtimeconfig.json -ErrorAction SilentlyContinue | 
    ForEach-Object {
        try {
            $json = Get-Content $_.FullName -Raw | ConvertFrom-Json
            if ($json.runtimeOptions.framework.name -eq "Microsoft.NETCore.App" -and $json.runtimeOptions.framework.version -like "3.1*") {
                Write-Output "Uses .NET Core 3.1: $($_.FullName)"
            }
        } catch {
            Write-Output "Skipped (invalid or unreadable): $($_.FullName)"
        }
    }

#Microsoft.AspNetCore.App
write-host "checking for program that uses Microsoft.AspNetCore.App 3.1" -ForegroundColor Green
Get-ChildItem -Recurse "C:\Program Files\", "C:\Program Files (x86)\" -Include *.runtimeconfig.json -ErrorAction SilentlyContinue | 
    ForEach-Object {
        try {
            $json = Get-Content $_.FullName -Raw | ConvertFrom-Json
            if ($json.runtimeOptions.framework.name -eq "Microsoft.AspNetCore.App" -and $json.runtimeOptions.framework.version -like "3.1*") {
                Write-Output "Uses .NET Core 3.1: $($_.FullName)"
            }
        } catch {
            Write-Output "Skipped (invalid or unreadable): $($_.FullName)"
        }
    }

#Microsoft.WindowsDesktop.App
write-host "checking for program that uses Microsoft.WindowsDesktop.App  3.1" -ForegroundColor Green
Get-ChildItem -Recurse "C:\Program Files\", "C:\Program Files (x86)\" -Include *.runtimeconfig.json -ErrorAction SilentlyContinue | 
    ForEach-Object {
        try {
            $json = Get-Content $_.FullName -Raw | ConvertFrom-Json
            if ($json.runtimeOptions.framework.name -eq "Microsoft.WindowsDesktop.App" -and $json.runtimeOptions.framework.version -like "3.1*") {
                Write-Output "Uses .NET Core 3.1: $($_.FullName)"
            }
        } catch {
            Write-Output "Skipped (invalid or unreadable): $($_.FullName)"
        }
    }




    
