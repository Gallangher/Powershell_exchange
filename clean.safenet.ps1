param(
[Parameter(Mandatory=$true)][string]$user = ''
)
(get-aduser   $user -properties proxyaddresses).proxyaddresses |fl
 get-aduser $user -prop proxyaddresses |%{
 $pr = $_.proxyaddresses -clike "SMTP:*"
 set-aduser $user -remove @{proxyaddresses=$pr} 
 } 