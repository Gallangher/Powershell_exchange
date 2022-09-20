param(
[Parameter(Mandatory=$true)][string]$user = ''
)

#set targetAddress


[string]$targetaddress = Get-ADUser $user -Properties proxyaddresses |select -expandProperty proxyaddresses |where {$_ -like "*qmm.target"}
$result = (Get-ADUser $user -Properties targetaddress)
$result.targetaddress = $targetaddress
set-aduser -instance $result


#set Windows Emailaddress using primary SMTP address

[string]$primarSMTPaddress = Get-ADUser $user -Properties proxyaddresses |select -expandProperty proxyaddresses |where {$_ -clike "SMTP:*"}
$WindowsAddress = $primarSMTPaddress.TrimStart("SMTP:")
Set-ADUser $user -EmailAddress $WindowsAddress


$user = $null
$targetaddress = $null
