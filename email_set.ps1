If ( ! (Get-module ActiveDirectory )) 
{
Import-Module ActiveDirectory
}

Import-Csv .\temp.csv | ForEach-Object{
# stage one 
$Doeas_proxy_address_exist = (Get-aduser $_.alias -properties proxyaddresses).proxyaddresses
if ($Doeas_proxy_address_exist) {
 Write-Host "There is proxy address for User" 
                                            } 
Else {      # There is no data in ProxyAddresses table

            # Set email as Primary SMTP address
                $NewProxyAddress = "SMTP:"+$_.address
                $proxyaddresses = Get-ADUser $_.alias -Properties proxyaddresses
                $proxyaddresses.proxyaddresses = $NewProxyAddress
                Set-ADUser  -Instance $proxyaddresses
            
            #set WindowsEmail address 
                Set-ADUser $_.alias -EmailAddress $_.address
            
            #set MailNickName
                $result = (Get-ADUser $_.alias -Properties mailnickname)
                $result.mailnickname = $_.alias
                set-aduser -instance $result

        }

#Lync Stage

#   $Identity = 'gemalto\'+$user
#
#   Enabling Lync account
#   set SIP address
#   $sipaddress = 'sip:'+(Get-aduser $user -properties emailaddress).EmailAddress
#    write-host "SIP address will be: " $sipaddress
#
#       if ((get-aduser $user).disntinguishedname -like "*OU=RnD*") 
#           {
#               Enable-CSuser -Identity $Identity -registrarpool 'lyncpool.gemalto.com' -sipaddress $sipaddress -DomainController ABSDOMVWP04.gemalto.com 
#               Grant-CSConferencingPolicy -Identity $Identity -policyname "Conferencing_rd" -DomainController ABSDOMVWP04.gemalto.com
#           } 
#       else 
#           {
#               Enable-CSuser -Identity $Identity -registrarpool 'lyncpool.gemalto.com' -sipaddress $sipaddress -DomainController ABSDOMVWP04.gemalto.com
#           }
#       write-host -foregroundcolor Green "Pausing for 10 seconds for Lync, let Lync finish...."
#   Start-Sleep -s 10


# Report stage
get-aduser   $_.alias -properties Displayname, emailaddress,mailnickname|Select-Object Displayname,name,mailnickname,emailaddress |fl
write-host "Primary SMTP address :" (Get-ADUser $_.alias -Properties proxyaddresses |select -expandProperty proxyaddresses |where {$_ -clike "SMTP:*"})
write-host 
write-host "proxy addresses:      " (get-aduser   $_.alias -properties proxyaddresses).proxyaddresses |fl
}
