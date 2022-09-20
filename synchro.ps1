Import-Csv .\proxyaddresses.csv | ForEach-Object{
$user = $_.alias
$proxyaddresses = Get-ADUser $user -Properties proxyaddresses
$old = $proxyaddresses.proxyaddresses
$new=$_.addresses
$old+=$new
$proxyaddresses.proxyaddresses = $old
Set-ADUser -Instance $proxyaddresses
}
