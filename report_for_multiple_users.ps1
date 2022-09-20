
#Conecting to Lync
Write-host
write-host "At the beginning we should create one Lync session to remote Lync server..."
write-host "be patient and wait several seconds :)"
	
$lyncsession = New-PSSession -ConnectionUri https://abslyfvwp01.gemalto.com/ocspowershell -Authentication NegotiateWithImplicitCredential
Import-PSSession -Session $lyncsession


Import-Csv .\proxyaddresses.csv |% {

$user = $_.alias
$Identity = 'gemalto\'+$user
$SIP = (Get-CSUser $identity -DomainController ABSDOMVWP04.gemalto.com).SIPAddress 
Write-host
Write-host
get-aduser   $user -properties Displayname, emailaddress, targetaddress,proxyaddresses |Select-Object Displayname,name,emailaddress,proxyaddresses,targetaddress |fl
write-host "Primary SMTP address " (Get-ADUser $user -Properties proxyaddresses |select -expandProperty proxyaddresses |where {$_ -clike "SMTP:*"})
Write-host "SIP                   " $sip
write-host "WindowsEmailAddress       " (get-aduser $user -Properties emailaddress).emailaddress
}


write-host "Close Lync session..."
write-host "bye"
Remove-PsSession $lyncsession

