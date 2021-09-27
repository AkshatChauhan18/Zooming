$exe_file_path = "$env:USERPROFILE/AppData/Local/Programs/ZOOM!NG"
if (-not(Test-Path -Path $exe_file_path )) {
    try {
        New-Item -Path $exe_file_path -ItemType Directory
    }
    catch {
        throw $_.Exception.Message
    }
    
}
else {
    Write-Host "$exe_file_path exists so continueing."
}
Start-BitsTransfer -Source https://github.com/AkshatChauhan18/Zooming/releases/download/0.0/zooming.exe -Destination "$env:USERPROFILE/AppData/Local/Programs/ZOOM!NG/zooming.exe"
Start-BitsTransfer -Source https://github.com/AkshatChauhan18/Zooming/releases/download/0.0/zooming.exe -Destination "$env:USERPROFILE/AppData/Local/Programs/ZOOM!NG/zooming.exe"
Start-BitsTransfer -Source https://github.com/AkshatChauhan18/Zooming/releases/download/0.0/zooming.exe -Destination "$env:USERPROFILE/AppData/Local/Programs/ZOOM!NG/zooming.exe"
