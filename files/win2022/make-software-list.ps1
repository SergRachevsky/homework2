$outfile = "c:\windows\temp\autoinstalled-software.csv"

cd "c:\Program Files\Far Manager\"
$aa = ./Far.exe /? 2>&1 | Out-String
$match = select-string "version (\S+)" -inputobject $aa
$version = $match.Matches.groups[1].value
"Far Manager;$version" | Out-File $outfile -Encoding UTF8 -Append

cd "c:\Program Files\windows_exporter\"
$aa = ./windows_exporter.exe --version 2>&1 | Out-String
$match = select-string "version (\S+)" -inputobject $aa
$version = $match.Matches.groups[1].value
"Prometheus node exporter;$version" | Out-File $outfile -Encoding UTF8 -Append

cd "c:\JRE\bin\"
$aa = ./java.exe -version 2>&1 | Out-String
$match = select-string 'openjdk version "(\S+)"' -inputobject $aa
$version = $match.Matches.groups[1].value
"JDK;$version" | Out-File $outfile -Encoding UTF8 -Append

$aa = Get-ChildItem c:\buildagent
$match = select-string "BUILD_(\S+)" -inputobject $aa
$version = $match.Matches.groups[1].value
"TeamCity build agent;$version" | Out-File $outfile -Encoding UTF8 -Append
