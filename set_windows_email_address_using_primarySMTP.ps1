Import-Csv .\proxyaddresses.csv |% {


[string]$primarSMTPaddress = Get-ADUser $_.alias -Properties proxyaddresses |select -expandProperty proxyaddresses |where {$_ -clike "SMTP:*"}

$pos = $primarSMTPaddress.IndexOf(":")
$prefix = $primarSMTPaddress.Substring(0, $pos)
$WindowsAddress = $primarSMTPaddress.Substring($pos+1)

Set-ADUser $_.alias -EmailAddress $WindowsAddress

}