

# Download JFK
Write-Output "Downloading JDK..."
Invoke-WebRequest "https://corretto.aws/downloads/resources/11.0.15.9.1/amazon-corretto-11.0.15.9.1-windows-x64-jdk.zip" -UseBasicParsing -OutFile $env:TEMP\jdk.zip
Expand-Archive $env:TEMP\jdk.zip -DestinationPath $env:TEMP\
Move-Item $env:TEMP\jdk11.0.15_9  c:\JRE

# Download TeamCity build agent ZIP-file
Write-Output "Downloading TCA..."
Invoke-WebRequest "https://radogor.teamcity.com/update/buildAgent.zip" -UseBasicParsing -OutFile $env:TEMP\buildAgent.zip
Expand-Archive $env:TEMP\buildAgent.zip -DestinationPath c:\buildAgent

# Change path for Java
Write-Output "Patching wrapper.conf..."
(gc C:\buildAgent\launcher\conf\wrapper.conf ) -replace '=java', '=c:/jre/bin/java' | Out-File -encoding ASCII C:\buildAgent\launcher\conf\wrapper.conf

cd C:\buildAgent\bin\
Write-Output "Installing TSA service..."
./service.install.bat
Write-Output "Starting TSA service..."
./service.start.bat



