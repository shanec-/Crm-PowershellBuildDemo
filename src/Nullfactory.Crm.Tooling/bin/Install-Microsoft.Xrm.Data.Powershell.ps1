param
(
[switch]$InstallGlobal
)


if($InstallGlobal)
{
	$modulesFolder  = $env:windir + '\System32\WindowsPowerShell\v1.0\Modules\Microsoft.Xrm.Data.PowerShell'
}
else
{
	$modulesFolder = $env:USERPROFILE + '\Documents\WindowsPowerShell\Modules\Microsoft.Xrm.Data.PowerShell'	
}

md -Force $modulesFolder
cp -Recurse -Force 'Microsoft.Xrm.Data.PowerShell/*' $modulesFolder