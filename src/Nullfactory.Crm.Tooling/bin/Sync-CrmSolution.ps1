#
# Sync-CrmSolution.ps1
#
param(
	[string]$serverUrl,
	[string]$username,
	[string]$password,
	[string]$solutionName,
	[string]$solutionRootFolder
)

Write-Verbose "Import Micrsoft.Xrm.Data.Powershell module"
Import-Module Microsoft.Xrm.Data.Powershell

$securePassword = ConvertTo-SecureString $password -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential ($username, $securePassword)

Write-Verbose "connect to the crm instance"
Connect-CrmOnPremDiscovery -Credential $creds -ServerUrl $serverUrl

$exportZipFileName = $solutionName + "_export.zip"
$exportZipFileNameManaged = $solutionName + "_export_Managed.zip"

Remove-Item $exportZipFileName
Remove-Item $exportZipFileNameManaged 

Write-Verbose "export the un-managed version of the solution"
Export-CrmSolution -SolutionName $solutionName -SolutionZipFileName $exportZipFileName

Write-Verbose "export the managed version of the solution"
Export-CrmSolution -SolutionName $solutionName -Managed -SolutionZipFileName $exportZipFileNameManaged

Write-Verbose "delete the source controlled artifacts while keeping the project file intact"
Remove-Item -Recurse $solutionRootFolder  -Force -exclude *.csproj 

Write-Verbose "regenerate by exporting the previously extracted solution"
.\coretools\SolutionPackager.exe /a:extract /packagetype:both /f:"$solutionRootFolder" /z:"$exportZipFileName" /ad:no