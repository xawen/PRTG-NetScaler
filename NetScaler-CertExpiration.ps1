Param(
	[string]$Nsip,
	[string]$Username,
	[string]$Password
)
    
$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($Username, $SecurePassword)

$Session =  Connect-Netscaler -Hostname $Nsip -Credential $Credential -PassThru

$CertResults = Get-NSSSLCertificate -session $Session | Where-Object {$_.certificatetype -eq "CLIENTANDSERVER_CERT"} 

$today = Get-Date

Write-Host "<prtg>"

foreach ($Result in $CertResults) {
	Write-Host "<result>"
	Write-Host ("<channel>" + $Result.certkey + "</channel>")
	Write-Host ("<value>" + $Result.daystoexpiration + "</value>")
	Write-Host "<unit>Custom</unit>"
	Write-Host "<CustomUnit>Days</CustomUnit>"
	Write-Host "<LimitMode>1</LimitMode>"
	Write-Host "<LimitMinWarning>30</LimitMinWarning>"
	Write-Host "<LimitWarningMsg>Certificate expiration in less than 30 days</LimitWarningMsg>"
	Write-Host "<LimitMinError>10</LimitMinError>"
	Write-Host "<LimitErrorMsg>Certificate expiration in less than 10 days</LimitErrorMsg>"
	Write-Host "</result>"
}

Write-Host "</prtg>"

Disconnect-Netscaler