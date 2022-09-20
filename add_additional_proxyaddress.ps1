param(
[Parameter(Mandatory=$true)][string]$user = '',
[Parameter(Mandatory=$true)][string]$AdditionalAddress = '')


$proxyaddresses = Get-ADUser $user -Properties proxyaddresses
$old = $proxyaddresses.proxyaddresses
$old+=$AdditionalAddress
$proxyaddresses.proxyaddresses = $old
Set-ADUser -Instance $proxyaddresses
get-aduser   $user -properties Displayname, emailaddress, targetaddress,proxyaddresses |Select-Object Displayname,name,emailaddress,proxyaddresses,targetaddress |fl
