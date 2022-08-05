
# 
$download_url = "https://aka.ms/vs/17/release/vs_BuildTools.exe"
$arguments = "--quiet --wait --add Microsoft.VisualStudio.Workload.ManagedDesktopBuildTools"

Write-Output "Downloading $download_url..."
(New-Object System.Net.WebClient).DownloadFile($download_url, "C:\Windows\Temp\vs_BuildTools.exe")

Write-Output "Installing..."
Start-Process "C:\Windows\Temp\vs_BuildTools.exe"  -ArgumentList $arguments  -Wait
