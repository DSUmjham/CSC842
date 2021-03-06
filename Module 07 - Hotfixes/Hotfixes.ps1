<#

.SYNOPSIS
This is a simple Powershell script to list and uninstall hotfixes on a system.

.DESCRIPTION
The script will list hotfixes installed on a system and allows for the option to uninstall them.  The script can list all hotfixes or those installed on or after a certain date.  Additionally, the script can filter out Update hotfixes and display Security Update hotfixes only if desired.

.EXAMPLE
./hotfixes.ps1 -date 11/29/2015
Lists all hotfixes installed on or after 11/29/2015

.EXAMPLE
./hotfixes.ps1 -uninstall $true
Uninstalls all hotfixes

.EXAMPLE
./hotfixes.ps1 -uninstall $true -securityOnly $true
Uninstalls security hotfixes only

#>

param (
	#[DateTime]$date = $(Get-Date -Format d),
	[DateTime]$date,
	[Boolean] $uninstall = $false,
	[Boolean] $securityOnly = $false
)
cls

# global variables
$hotfixes = ""

function generateList(){
	if ($date -eq $null){
		# user did not set date parameter, so get all of the hotfixes
		Write-Host "Finding all installed hotfixes..."
		$h = Get-HotFix
	}
	else{
		# find all of the hotfixes installed after a certain date
		[string]$date = $date.ToString("MM/dd/yyyy")
		Write-Host "Finding hotfixes installed on $date or after..."
		$h = Get-Hotfix | ? InstalledOn -gt $date
	}
	
	# filter hotfixes by security updates only if need be
	if ($securityOnly){
		$h = $h | ? Description -eq "Security Update"
	}
	return $h
}

function uninstallHotfixes($hotfixes){
	# are you sure?
	Write-Host "The following hotfixes will be uninstalled:"
	$hotfixes
	$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Uninstalls the selected hotfixes."
	$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Retains all of the hotfixes."
	$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
	$result = $host.ui.PromptForChoice("", "Are you sure you wish to uninstall the listed hotfixes?", $options, 0)

	switch ($result)
	{
		0 {
			# parse through each of the hotfixes and uninstall them
			foreach ($h in $hotfixes){
				# get just the hotfix number for wusa.exe
				$hotfixID = $h.HotFixID.Replace("KB","")
				
				# start the uninstall process
				Write-Host "Uninstalling hotfix $($h.HotFixID)..."
				$uninstallCmd = "cmd.exe /c wusa.exe /uninstall /KB:$hotfixID /quiet /norestart"
				Invoke-Expression -Command:$uninstallCmd
				Write-Host "Done with $($h.HotFixID)."
			}
		}
		1 {"The hotfixes will not be uninstalled."}
	}
}

$hotfixes = generateList # get the list of hotfixes
if ($uninstall){ # uninstall them if need be
	uninstallHotfixes($hotfixes)
}
else{
	$hotfixes
}