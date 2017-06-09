Param(
	[string]$Nsip,
	[string]$Username,
	[string]$Password
)
    
$SecurePassword = ConvertTo-SecureString $Password -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential ($Username, $SecurePassword)

$Session =  Connect-Netscaler -Hostname $Nsip -Credential $Credential -PassThru

$CSvServerResults = Get-NSCSVirtualServer -session $Session
$LBvServerResults = Get-NSLBVirtualServer -session $Session
$VPNvServerResults = Get-NSVPNVirtualServer -session $Session
$AAAvServerResults = Get-NSAAAVirtualServer -session $Session

Write-Host "<prtg>"

foreach ($Result in $CSvServerResults) {
	switch ($Result.curstate) 
    		{ 
        		"UP" {$CurState = 1} 
			"DOWN" {$CurState = 2}
			"OUT OF SERVICE" {$CurState = 3}
    		}
	Write-Host "<result>"
	Write-Host ("<channel>State CS: " + $Result.name + "</channel>")
	Write-Host ("<value>" + $CurState + "</value>")
	Write-Host "<unit>Custom</unit>"
	Write-Host "<CustomUnit>Status</CustomUnit>"
	Write-Host "<valuelookup>prtg.networklookups.REST.NetscalerVserverStatus</valuelookup>"
	Write-Host "</result>"
}

foreach ($Result in $LBvServerResults) {
	switch ($Result.curstate) 
    		{ 
        		"UP" {$CurState = 1} 
			"DOWN" {$CurState = 2}
			"OUT OF SERVICE" {$CurState = 3}
    		}
	Write-Host "<result>"
	Write-Host ("<channel>State LB: " + $Result.name + "</channel>")
	Write-Host ("<value>" + $CurState + "</value>")
	Write-Host "<unit>Custom</unit>"
	Write-Host "<CustomUnit>Status</CustomUnit>"
	Write-Host "<valuelookup>prtg.networklookups.REST.NetscalerVserverStatus</valuelookup>"
	Write-Host "</result>"

	Write-Host "<result>"
	Write-Host ("<channel>Health LB: " + $Result.name + "</channel>")
	Write-Host ("<value>" + $Result.health + "</value>")
	Write-Host "<unit>Percent</unit>"
	Write-Host "</result>"
}

foreach ($Result in $VPNvServerResults) {
	switch ($Result.curstate) 
    		{ 
        		"UP" {$CurState = 1} 
			"DOWN" {$CurState = 2}
			"OUT OF SERVICE" {$CurState = 3}
    		}
	Write-Host "<result>"
	Write-Host ("<channel>State VPN: " + $Result.name + "</channel>")
	Write-Host ("<value>" + $CurState + "</value>")
	Write-Host "<unit>Custom</unit>"
	Write-Host "<CustomUnit>Status</CustomUnit>"
	Write-Host "<valuelookup>prtg.networklookups.REST.NetscalerVserverStatus</valuelookup>"
	Write-Host "</result>"
}

foreach ($Result in $AAAvServerResults) {
	switch ($Result.curstate) 
    		{ 
        		"UP" {$CurState = 1} 
			"DOWN" {$CurState = 2}
			"OUT OF SERVICE" {$CurState = 3}
    		}
	Write-Host "<result>"
	Write-Host ("<channel>State AAA: " + $Result.name + "</channel>")
	Write-Host ("<value>" + $CurState + "</value>")
	Write-Host "<unit>Custom</unit>"
	Write-Host "<CustomUnit>Status</CustomUnit>"
	Write-Host "<valuelookup>prtg.networklookups.REST.NetscalerVserverStatus</valuelookup>"
	Write-Host "</result>"
}

Write-Host "</prtg>"

Disconnect-Netscaler