
# 
$download_url = "https://www.farmanager.com/files/Far30b6000.x64.20220723.msi"
Write-Output "Downloading $download_url..."
(New-Object System.Net.WebClient).DownloadFile($download_url, "C:\Windows\Temp\Far30b6000.x64.20220723.msi")

Write-Output "Installing..."
$arguments = "/i C:\Windows\Temp\Far30b6000.x64.20220723.msi ADDLOCAL=ALL /qn"
Start-Process "MsiExec.exe"  -ArgumentList $arguments  -Wait
