param(
[Parameter(Mandatory=$true)][string]$user = ''
)

get-aduser   $user -properties Displayname, emailaddress, targetaddress|Select-Object Displayname,name,emailaddress, targetaddress |fl
write-host "proxy addresses"
(get-aduser   $user -properties proxyaddresses).proxyaddresses |fl

write-host "Primary SMTP address :" (Get-ADUser $user -Properties proxyaddresses |select -expandProperty proxyaddresses |where {$_ -clike "SMTP:*"})