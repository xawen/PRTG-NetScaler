Param(
	[string]$Nsip,
	[string]$Username,
	[string]$Password
)
    
$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($Username, $SecurePassword)

$Session =  Connect-Netscaler -Hostname $Nsip -Credential $Credential -PassThru

$CertResults = Get-NSSSLCertificate -session $Session | Where-Object {$_.certificatetype -eq "CLIENTANDSERVER_CERT"} 

$ResultSSL = Get-NSStat -session $Session -Type 'ssl'
$ResultSystem = Get-NSStat -session $Session -Type 'system'
$ResultInterface = Get-NSStat -session $Session -Type 'interface'

Write-Host "<prtg>"

Write-Host "<result>"
Write-Host ("<channel>CPU Usage</channel>")
Write-Host ("<value>" + [math]::Round($ResultSystem.cpuusagepcnt) + "</value>")
Write-Host "<unit>Percent</unit>"
Write-Host "</result>"

Write-Host "<result>"
Write-Host ("<channel>Packet CPU Usage</channel>")
Write-Host ("<value>" + [math]::Round($ResultSystem.pktcpuusagepcnt) + "</value>")
Write-Host "<unit>Percent</unit>"
Write-Host "</result>"

Write-Host "<result>"
Write-Host ("<channel>Management CPU Usage</channel>")
Write-Host ("<value>" + [math]::Round($ResultSystem.mgmtcpuusagepcnt) + "</value>")
Write-Host "<unit>Percent</unit>"
Write-Host "</result>"

Write-Host "<result>"
Write-Host ("<channel>Memory Usage</channel>")
Write-Host ("<value>" + [math]::Round($ResultSystem.memusagepcnt) + "</value>")
Write-Host "<unit>Percent</unit>"
Write-Host "</result>"

Write-Host "<result>"
Write-Host ("<channel>Memory MB Usage</channel>")
Write-Host ("<value>" + (([int]$ResultSystem.memuseinmb)*1024)*1024 + "</value>")
Write-Host "<unit>BytesMemory</unit>"
Write-Host "</result>"

Write-Host "<result>"
Write-Host ("<channel>Disk 0 Usage</channel>")
Write-Host ("<value>" + [math]::truncate(($ResultSystem.disk0used/$ResultSystem.disk0size)*100) + "</value>")
Write-Host "<unit>Percent</unit>"
Write-Host "</result>"

Write-Host "<result>"
Write-Host ("<channel>Disk 1 Usage</channel>")
Write-Host ("<value>" + [math]::truncate(($ResultSystem.disk1used/$ResultSystem.disk1size)*100) + "</value>")
Write-Host "<unit>Percent</unit>"
Write-Host "</result>"

Write-Host "<result>"
Write-Host ("<channel>SSL Transactions/sec</channel>")
Write-Host ("<value>" + $ResultSSL.ssltransactionsrate + "</value>")
Write-Host "<unit>Custom</unit>"
Write-Host "<CustomUnit>Transactions</CustomUnit>"
Write-Host "</result>"

$rxbytesratetotal = 0
$txbytesratetotal = 0

foreach ($Result in $ResultInterface) {
	$rxbytesratetotal = $rxbytesratetotal + $Result.rxbytesrate
	$txbytesratetotal = $txbytesratetotal + $Result.txbytesrate
}

Write-Host "<result>"
Write-Host ("<channel>RX Bandwidth</channel>")
Write-Host ("<value>" + $rxbytesratetotal + "</value>")
Write-Host "<unit>BytesBandwidth</unit>"
Write-Host "<SpeedSize>KiloBits</SpeedSize>"
Write-Host "</result>"

Write-Host "<result>"
Write-Host ("<channel>TX Bandwidth</channel>")
Write-Host ("<value>" + $txbytesratetotal + "</value>")
Write-Host "<unit>BytesBandwidth</unit>"
Write-Host "<SpeedSize>KiloBits</SpeedSize>"
Write-Host "</result>"

Write-Host "</prtg>"

Disconnect-Netscaler
