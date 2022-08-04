
# 
$download_url = "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe"
Write-Output "Downloading $download_url..."
(New-Object System.Net.WebClient).DownloadFile($download_url, "C:\Windows\Temp\Docker Desktop Installer.exe")

Write-Output "Installing..."
$arguments = "install --quiet"
Start-Process "C:\Windows\Temp\Docker Desktop Installer.exe"  -ArgumentList $arguments  -Wait
