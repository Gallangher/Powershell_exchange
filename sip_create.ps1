
param(
[Parameter(Mandatory=$true)][string]$User = '')



#Conecting to Lync
Write-host
write-host "At the beginning we should create one Lync session to remote Lync server..."
write-host "be patient and wait several seconds :)"
	
$lyncsession = New-PSSession -ConnectionUri https://abslyfvwp01.gemalto.com/ocspowershell -Authentication NegotiateWithImplicitCredential
Import-PSSession -Session $lyncsession


{


$Identity = 'gemalto\'+$user





#Enabling Lync account
#set SIP address
$sipaddress = 'sip:'+(Get-aduser $user -properties emailaddress).EmailAddress
# write-host "SIP address will be: " $sipaddress

if ((get-aduser $user).disntinguishedname -like "*OU=RnD*") {
    Enable-CSuser -Identity $Identity -registrarpool 'lyncpool.gemalto.com' -sipaddress $sipaddress -DomainController ABSDOMVWP04.gemalto.com 
    Grant-CSConferencingPolicy -Identity $Identity -policyname "Conferencing_rd" -DomainController ABSDOMVWP04.gemalto.com
} else {
   
   Enable-CSuser -Identity $Identity -registrarpool 'lyncpool.gemalto.com' -sipaddress $sipaddress -DomainController ABSDOMVWP04.gemalto.com
}
write-host -foregroundcolor Green "Pausing for 10 seconds for Lync, let Lync finish...."
Start-Sleep -s 10


#Get-Mailbox $user -DomainController ABSDOMVWP04.gemalto.com | Select Name, PrimarySMTPAddress
#Get-User $Identity -DomainController ABSDOMVWP04.gemalto.com | Select Name, WindowsEmailAddress

get-aduser   $user -properties Displayname, emailaddress, targetaddress,proxyaddresses |Select-Object Displayname,name,emailaddress,proxyaddresses,targetaddress |fl
Get-CSUser $identity -DomainController ABSDOMVWP04.gemalto.com | Select Name, SIPAddress 

write-host "Primary SMTP address :" (Get-ADUser $user -Properties proxyaddresses |select -expandProperty proxyaddresses |where {$_ -clike "SMTP:*"})


$user = $null
$targetaddress = $null



}



write-host "Close Lync session..."
write-host "bye"
Remove-PsSession $lyncsession

