<#

Script Name: 	CheckProgramVersions.ps1
Author:		 	Michael Ham
Date:			09/01/2015
Tested On:		Windows Server 2008 R2, Windows 7, Windows 8

Notes: This script is designed to be run in a domain environment with an appropriate level of priviliges to execute PowerShell commands.
If runnign the script in a workgroup, you may run into issues with teh Invoke-Command block.  This is because of differing default security
settings between the environments.  Furthermore, if the remot host's network adapter is set to "Public" mode, the Enable-PSRemoting command will
not be able to complete successfully; it must be in a Domain or Private network.  The user account on the target machines should have a password
in order for the remote connection to work.

See the GitHub repository for more information: https://github.com/DSUmjham/CSC842/tree/master/Module%2001%20-%20Check%20Program%20Versions

#>

# This file contains a list of remote windows machines that have PowerShell remote execution enabled (Enable-PSRemoting)
$workstations = Get-Content "C:\Users\mjham\Desktop\workstations.txt"
$credential = Get-Credential

# Scan each computer in the list for user-defined software.
cls
foreach ($computerName in $workstations)
{
	$computerName + "`n=================================================="

	# Run the following commands in the scriptblock against the remote machinesq
	Invoke-Command -ComputerName $computerName -Credential $credential -ScriptBlock{
		
		# Define variables for the sofware versions being checked 
		$adobeFlashVer = "18.0.0.232"
		$adobeReaderVer = "11.0.10"
		$firefoxVer = "40.0.3"
		$skypeVer = "7.7.103"
		
		# Registry key that contains program information including version that we will check against
		$uninstall = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
		$installedPrograms = @()
		
		# Get all of the keys in the computer's uninstall key
		Get-ChildItem -Path $uninstall  | ForEach-Object {
			
			# Get the values within the subkeys of the uninstall key that have the property "DisplayName"
			$subkey = Join-Path -Path $uninstall -ChildPath $_.PSChildName
			$installedPrograms += Get-ItemProperty -Path $subkey -ErrorAction SilentlyContinue | where {$_.DisplayName -ne $null}
		}					
		
		#region Adobe Flash
		
		$adobeFlashInst =  $installedPrograms |?{$_.DisplayName -like "Adobe Flash* ActiveX"}
		if ($adobeFlashInst -eq $null)
			{
				"Adobe Flash not installed on " + (gc env:computername)
			}
			elseif ($adobeFlashInst.DisplayVersion -ne $adobeFlashVer)
			{
				Write-Host "Adobe Flash out of date: " $adobeFlashInst.DisplayVersion -ForegroundColor Red
			}
			else
			{
				Write-Host "Adobe Flash is at current version: " $adobeFlashInst.DisplayVersion -ForegroundColor Green
			}
		
		#endregion
		
		#region Adobe Reader
		
		$adobeReaderInst = $installedPrograms |?{$_.DisplayName -like "Adobe Reader*"}
		if ($adobeReaderInst -eq $null)
			{
				"Adobe Reader not installed on " + (gc env:computername)
			}
			elseif ($adobeReaderInst.DisplayVersion -ne $adobeReaderVer)
			{
				Write-Host "Adobe Reader out of date: "  $adobeReaderInst.DisplayVersion -ForegroundColor Red
			}
			else
			{
				Write-Host "Adobe Reader is at current version: "  $adobeReaderInst.DisplayVersion -ForegroundColor DarkGreen
			}
		
		#endregion
			
		#region Firefox
		
		# Check Firefox
		$firefoxInst = $installedPrograms |?{$_.DisplayName -like "Mozilla Firefox*"}
		if ($firefoxInst -eq $null)
		{
			"Firefox not installed on " + (gc env:computername)
		}
		elseif ($firefoxInst.DisplayVersion -ne $firefoxVer)
		{
			Write-Host "Firefox out of date: " $firefoxInst.DisplayVersion -ForegroundColor Red
		}
		else
		{
			Write-Host "Firefox is at current version: " $firefoxInst.DisplayVersion -ForegroundColor Green
		}
		
		#endregion
		
		#region Skype
		
		# Check Skype
		$skypeInst = $installedPrograms |?{$_.DisplayName -like "Skype*"}
		if ($skypeInst -eq $null)
		{
			"Skype not installed on " + (gc env:computername)
		}
		elseif ($skypeInst.DisplayVersion -ne $skypeVer)
		{
			Write-Host "Skype out of date: " $skypeInst.DisplayVersion -ForegroundColor Red
		}
		else
		{
			Write-Host "Skype is at current version: " $skypeInst.DisplayVersion -ForegroundColor Green
		}
		
		#endregion
	
		"`n"
	}
}