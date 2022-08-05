
# 
$download_url = "https://github.com/prometheus-community/windows_exporter/releases/download/v0.19.0/windows_exporter-0.19.0-amd64.msi"
Write-Output "Downloading $download_url..."
(New-Object System.Net.WebClient).DownloadFile($download_url, "C:\Windows\Temp\windows_exporter-0.19.0-amd64.msi")

Write-Output "Installing..."
$arguments = "/i C:\Windows\Temp\windows_exporter-0.19.0-amd64.msi"
Start-Process "MsiExec.exe"  -ArgumentList $arguments  -Wait
