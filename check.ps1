Import-Csv .\proxyaddresses.csv |% {

$user = $_.alias

$type = (Get-aduser $user -properties emailaddress).EmailAddress

if ($type) {
 
#address is set ....

write-host "For user" $user  "address already exists"
get-aduser   $user -properties Displayname, emailaddress, targetaddress,proxyaddresses |Select-Object Displayname,name,emailaddress,proxyaddresses,targetaddress |fl
write-host "Primary SMTP address :" (Get-ADUser $user -Properties proxyaddresses |select -expandProperty proxyaddresses |where {$_ -clike "SMTP:*"})

} Else {

#Ther is no address, so we have to set...


write-host "For user" $user "there is no Windows Email address ... time to run our script  and set address!!"


#set targetAddress


[string]$targetaddress = Get-ADUser $user -Properties proxyaddresses |select -expandProperty proxyaddresses |where {$_ -like "*qmm.target"}
$result = (Get-ADUser $user -Properties targetaddress)
$result.targetaddress = $targetaddress
set-aduser -instance $result


#set Windows Emailaddress using primary SMTP address

[string]$primarSMTPaddress = Get-ADUser $user -Properties proxyaddresses |select -expandProperty proxyaddresses |where {$_ -clike "SMTP:*"}

$WindowsAddress = $primarSMTPaddress.TrimStart("SMTP:")  

#nie wiem dlaczego ale to kilka razy nie zadzialalo poprawnie :( i ucielo pierwsza litera adresu
#to jest bardziej uniwersalne ale nie testowane 
#pos = $primarSMTPaddress.IndexOf(":")
#$prefix = $primarySMTPaddress.Substring(0, $pos)
#$WindowsAddress = $primarySMTPaddress.Substring($pos+1)

Set-ADUser $user -EmailAddress $WindowsAddress


$user = $null
$targetaddress = $null



}
}