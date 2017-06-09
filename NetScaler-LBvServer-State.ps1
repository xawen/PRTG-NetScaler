Param(
	[string]$Nsip,
	[string]$Username,
	[string]$Password
)
    
$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($Username, $SecurePassword)

$Session =  Connect-Netscaler -Hostname $Nsip -Credential $Credential -PassThru

$vServerResults = Get-NSLBVirtualServer -session $Session

Write-Host "<prtg>"

foreach ($Result in $vServerResults) {
	switch ($Result.curstate) 
    		{ 
        		"UP" {$CurState = 1} 
			"DOWN" {$CurState = 2}
			"OUT OF SERVICE" {$CurState = 3}
    		}
	Write-Host "<result>"
	Write-Host ("<channel>State:" + $Result.name + "</channel>")
	Write-Host ("<value>" + $CurState + "</value>")
	Write-Host "<unit>Custom</unit>"
	Write-Host "<CustomUnit>Status</CustomUnit>"
	Write-Host "<valuelookup>prtg.networklookups.REST.NetscalerVserverStatus</valuelookup>"
	Write-Host "</result>"

	Write-Host "<result>"
	Write-Host ("<channel>Health: " + $Result.name + "</channel>")
	Write-Host ("<value>" + $Result.health + "</value>")
	Write-Host "<unit>Percent</unit>"
	Write-Host "</result>"
}

Write-Host "</prtg>"

Disconnect-Netscaler