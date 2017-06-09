Scripts:
	- NetScaler-AppliancePerformance.ps1 - Monitor general NetScaler perfomance stats.
	- NetScaler-AllvServer-State.ps1 - Monitor state and health of all instances of all vServer types.
	- NetScaler-LBvServer-State.ps1 - Monitor state and health of all instances of Load Balancer vServers.
	- NetScaler-CertExpiration.ps1 - Monitor days until expiration for all SSL server certificates.
	- NetScaler-ConfigSavedState.ps1 - Monitor for unsaved configuration changes.

Steps to configure:

1) On the PRTG Server open a Powershell (x86) prompt as admin and run: Install-Module -Name NetScaler -scope AllUsers
	- Note:  This MUST be done in the (x86) version of powershell
2) Create a user on the NetScaler with the read-only Command Policy
3) Copy all .ps1 files to C:\Program Files (x86)\PRTG Network Monitor\Custom Sensors\EXEXML
	- Directory may vary with PRTG install path
4) Copy all .ovl files to C:\Program Files (x86)\PRTG Network Monitor\lookups\custom
	- Directory may vary with PRTG install path
5) In PRTG go to Setup > Administrative tools
	Reload lookups
	Restart core server (optional, run if PRTG has issues finding the script)
6) Edit your NetScaler device in PRTG and set the Linux credentials to the new read only account
7) Add a new EXE/Script Advanced type sensor to your NetScaler device
8) Set the following options on the sensor
	Name - Set a descriptive name
	EXE/Script - Choose the desired script
	Parameters - Enter: %host %linuxuser %linuxpassword
9) Select continue