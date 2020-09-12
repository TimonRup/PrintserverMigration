#Drucker auslesen und exportieren
Get-Printer -ComputerName Printserver1.olddomain | Where-Object{$_.Name -like 'A*' -or $_.Name -like 'F*'} | Export-Csv C:\TMP\Printserver1.csv -Encoding UTF8
Get-PrinterPort -ComputerName Printserver1.olddomain | Where-Object{$_.Name -like '192.168.*' -or $_.Name -like '10.*'} | Export-Csv C:\TMP\Printserver1Ports.csv

Get-Printer -ComputerName Printserver2.olddomain | Where-Object{$_.Name -like 'L*' -or $_.Name -like 'LH*'} | Export-Csv C:\TMP\Printserver2.csv -Encoding UTF8
Get-PrinterPort -ComputerName Printserver2.olddomain | Where-Object{$_.Name -like '192.168.*' -or $_.Name -like '10.*'} | Export-Csv C:\TMP\Printserver2Ports.csv

Get-Printer -ComputerName Printserver3.olddomain | Where-Object{$_.Name -like 'S*' -or $_.Name -like 'FL*'} | Export-Csv C:\TMP\Printserver3.csv -Encoding UTF8
Get-PrinterPort -ComputerName Printserver3.olddomain | Where-Object{$_.Name -like '192.168.*' -or $_.Name -like '10.*'} | Export-Csv C:\TMP\Printserver3Ports.csv 

#Drucker + Ports in Arrays legen
$PrinterServer1 = Import-Csv -Path C:\TMP\Printserver1.csv 
$PrinterServerPorts1 = Import-Csv -Path C:\TMP\PrintserverPorts1.csv 

$PrinterServer2 = Import-Csv -Path C:\TMP\Printserver2.csv 
$PrinterServerPorts2 = Import-Csv -Path C:\TMP\PrintserverPorts2.csv 

$PrinterServer3 = Import-Csv -Path C:\TMP\Printserver3.csv 
$PrinterServerPorts3 = Import-Csv -Path C:\TMP\PrintserverPorts3.csv 

#Arrays verbinden
$Printers = $PrinterServer1 + $PrinterServer2 + $PrinterServer3
$Ports = $PrinterServerPorts1 + $PrinterServerPorts2 + $PrinterServerPorts3

#Ports auf neuem Server hinzufügen
foreach($port in $Ports){
    if($port.description -like 'Standard TCP/IP Port'){
    Add-PrinterPort -ComputerName Printserver.newdomain -Name $port.Name -PrinterHostAddress $port.PrinterHostAddress
    }
}

#Drucker auf neuem Server hinzufügen
foreach($printer in $Printers){
    Add-Printer -ComputerName Printserver.newdomain -Name $printer.name -Comment $printer.comment -DriverName $printer.DriverName -Location $printer.location -Published $true
}

#Drucker Sichtbar machen
foreach($printer in $Printers){
    Set-Printer -ComputerName Printserver.newdomain -Name $printer.name -Shared $True -ShareName $printer.Name
}
