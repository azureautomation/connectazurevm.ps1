Param (
	[string]$servicename,
	[string]$name,
	[string]$userName,
	[string]$password
)

$vm = Get-AzureVM -ServiceName $servicename -Name $name

If ($vm.InstanceStatus -ne 'ReadyRole')
{
    Write-Host ("VM is not running. InstanceStatus:" + $vm.instancestatus)        
}
Else
{        
    $port = ($vm.VM.ConfigurationSets.Inputendpoints | Where { $_.LocalPort -eq 5986 }).Port
    $vip = ($vm.VM.ConfigurationSets.Inputendpoints | Where { $_.LocalPort -eq 5986 }).Vip
    $uri = ('https://' + $vip + ':' + $port)
        
    $Credential = New-Object System.Management.Automation.PSCredential($username, $(ConvertTo-SecureString -String $password -AsPlainText -Force))
	$SessionOption = New-PSSessionOption -SkipCACheck -SkipCNCheck -NoMachineProfile
	$PSSession = New-PSSession -ConnectionUri $uri -Credential $Credential -SessionOption $SessionOption
    
    Enter-PSSession $PSSession	
}