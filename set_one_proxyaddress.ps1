param(
[Parameter(Mandatory=$true)][string]$user = '',
[Parameter(Mandatory=$true)][string]$NEWaddress = '')


$proxyaddresses = Get-ADUser $user -Properties proxyaddresses
# $old = $proxyaddresses.proxyaddresses
#$new=$_.addresses
#$old=$nEWADDDRESS
$proxyaddresses.proxyaddresses = $NEWaddress
Set-ADUser -Instance $proxyaddresses
get-aduser   $user -properties Displayname, emailaddress, targetaddress,proxyaddresses |Select-Object Displayname,name,emailaddress,proxyaddresses,targetaddress |fl
