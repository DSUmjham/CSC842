# Specify the input .nessus file and where the resulting HTML should be placed
param (
	[Parameter(Mandatory = $true)][string]$nessusFile,
	[Parameter(Mandatory = $true)][string]$outputPath
)
<#$nesssusFile = "\\vmware-host\Shared Folders\Downloads\SCANME_NMAP_ORG_9a4aeh.nessus"
$outputPath = "\\vmware-host\Shared Folders\Downloads\"
#>
$global:ipList = @()
cls

# Parse the Nessus v2 XML (.nessus) file for any IP addresses that report plugin 24260 (HTTP Information)
# Return a list of URLs with the HTML tags surrounding them
Function BuildURLs ($file) {
	$urlList = @()
	foreach ($rh in $file.NessusClientData_v2.Report.ReportHost){
		foreach ($ri in $rh.ReportItem | where {$_.pluginID -eq "24260"}){
			$url = "http://" + $rh.name + ":" + $ri.port 
			$urlList += "<li><a href=""" + $url + """>" + $url + "</a></li>"
			
			if ($global:ipList -notcontains "<li>" + $rh.name + "</li>"){
					$global:ipList += "<li>" + $rh.name + "</li>"
				}
		}
	}
	return $urlList
}

# This function parses the list of URLs and builds an HTML file containing links to each URL
Function BuildHTML ($nessusFile, $outputPath) {
	"<h1>$nessusFile - HTTP Sites</h1>" >> $outputPath
	"<h2>Links</h2" >> $outputPath
	[xml]$nessusFile = Get-Content $nessusFile
	"<ol>" >> $outputPath
	BuildURLs $nessusFile >> $outputPath
	"</ol>" >> $outputPath
	"<h2>IPs</h2>" >> $outputPath
	"<ul>" >> $outputPath
	$global:ipList >> $outputPath
	"</ul>" >> $outputPath

}

# Ensure that the user-supplied path to a .nessus file exists
$nessusFile = $nessusFile.Replace('"', '')
if (-not(Test-Path $nessusFile)){
	"Error: Please enter a valid path to a .nessus file."
	return
}

# Check to see that the file we are going to write to does not already exist.
$outputPath = Join-Path $outputPath.Replace('"','') ($(Get-ChildItem $nessusFile -Name).Replace(".nessus","-HTTP.html"))
if (Test-Path $outputPath){
	"Error: $outputPath already exists."
	return
}
else{
	# Create the output file
	New-Item $outputPath -ItemType file -Force	| Out-Null
	$output = BuildHTML $nessusFile $outputPath
}