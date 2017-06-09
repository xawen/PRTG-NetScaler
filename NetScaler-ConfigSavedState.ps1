Param(
	[string]$Nsip,
	[string]$Username,
	[string]$Password
)
    
$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($Username, $SecurePassword)

$Session =  Connect-Netscaler -Hostname $Nsip -Credential $Credential -PassThru

$ConfigResults =  Invoke-Nitro -Session $Session -Method GET -Type nsconfig 

switch ($ConfigResults.nsconfig.configchanged) 
    		{ 
        		"False" {$ConfigChanged = 0} 
			"True" {$ConfigChanged = 1}
    		}
$LastConfigChangedTime = $expDate = [datetime]::ParseExact($ConfigResults.nsconfig.lastconfigchangedtime, "ddd MMM  d HH:mm:ss yyyy", $null)
$LastConfigSaveTime = $expDate = [datetime]::ParseExact($ConfigResults.nsconfig.lastconfigsavetime, "ddd MMM  d HH:mm:ss yyyy", $null)
$MinutesOfUnsavedChanges = [math]::truncate(($LastConfigChangedTime - $LastConfigSaveTime).TotalMinutes)

If ($MinutesOfUnsavedChanges -lt 0) {$MinutesOfUnsavedChanges = 0}

Write-Host "<prtg>"

Write-Host "<result>"
Write-Host ("<channel>Unsaved Config</channel>")
Write-Host ("<value>" + $ConfigChanged + "</value>")
Write-Host "<unit>Custom</unit>"
Write-Host "<valuelookup>prtg.networklookups.REST.NetscalerConfigChangedStatus</valuelookup>"
Write-Host "</result>"

Write-Host "<result>"
Write-Host ("<channel>Config Unsaved For</channel>")
Write-Host ("<value>" + $MinutesOfUnsavedChanges + "</value>")
Write-Host "<unit>Custom</unit>"
Write-Host "<CustomUnit>Minutes</CustomUnit>"
Write-Host "<LimitMode>1</LimitMode>"
Write-Host "<LimitMaxError>1440</LimitMaxError>"
Write-Host "</result>"

Write-Host "</prtg>"

Disconnect-Netscaler