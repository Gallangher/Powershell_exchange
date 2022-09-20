Get-ADUser -Filter * -Properties proxyaddresses, targetaddress  | where {$_.proxyaddresses -notlike "" }| where {$_.targetaddress -like $null} | ForEach-Object{
$first = $_.givenname
$last =$_.surname
$targetaddress =smtp:$first.$last@qmm.target

$name=(get-aduser).name
write-host $_ $targetaddress $name
#get-aduser $_ Set-ADUser -replace @{targetAddress=($targetaddress)}
}
