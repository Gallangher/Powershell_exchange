param(
[Parameter(Mandatory=$true)][string]$user = '',
[Parameter(Mandatory=$true)][string]$address = ''
)
$result = (Get-ADUser $user -Properties name,targetaddress)
$result.targetaddress = $address
set-aduser -instance $result
$user = $null
$address = $null
