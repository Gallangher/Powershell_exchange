param(
[Parameter(Mandatory=$true)][string]$user = '',
[Parameter(Mandatory=$true)][string]$New_default_smtp_address = '')


Write-host "BEFORE"

(get-aduser   $user -properties proxyaddresses).proxyaddresses |fl

write-host "########################################################################"
write-host
# Stage 1 - remove PrimarySmtp from proxy addresses list
 get-aduser $user -prop proxyaddresses |%{
 $pr = $_.proxyaddresses -clike "SMTP:*"
 set-aduser $user -remove @{proxyaddresses=$pr}
 write-host $pr
 } 

 Write-Host ##### 
#stage 2 - take old WindowsEmailaddress and set as secondary proxy addresses
$old_proxy = (Get-ADUser $user -Properties emailaddress).emailaddress
$new_proxy = "smtp:"+$old_proxy

$proxyaddresses = Get-ADUser $user -Properties proxyaddresses
$old = $proxyaddresses.proxyaddresses
$old+=$new_proxy
$proxyaddresses.proxyaddresses = $old
Set-ADUser -Instance $proxyaddresses



write-host "AFTER"

(get-aduser   $user -properties proxyaddresses).proxyaddresses |fl

write-host "########################################################################"
write-host

# stage 3 - set new address as primary SMTP proxy addresses 
$additionaladdress = "SMTP:"+$New_default_smtp_address


$proxyaddresses = Get-ADUser $user -Properties proxyaddresses
$old = $proxyaddresses.proxyaddresses
$old+=$AdditionalAddress
$proxyaddresses.proxyaddresses = $old
Set-ADUser -Instance $proxyaddresses
Set-aduser $user -emailaddress $New_default_smtp_address


write-host "########################################################################"
# FINAL Report
get-aduser   $user -properties Displayname, emailaddress, targetaddress,proxyaddresses |Select-Object Displayname,name,emailaddress,proxyaddresses,targetaddress |fl
