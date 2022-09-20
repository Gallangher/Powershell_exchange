param(
[Parameter(Mandatory=$true)][string]$user = '',
[Parameter(Mandatory=$true)][string]$address_to_remove = '')




get-aduser $user -prop proxyaddresses |%{
$pr = $_.proxyaddresses -like $address_to_remove
set-aduser $user -remove @{proxyaddresses=$pr}
#write-host $pr
}