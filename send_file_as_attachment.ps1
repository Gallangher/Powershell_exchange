
param(
[Parameter(Mandatory=$true)][string]$Attachment = ''
)
									
$date = (get-date).ToShortDateString()

#default recipient
$mailto = "<AAA.BBB@atos.net>"                                                                                #CHANGE IT !!!

#sender address - check is allowed
$MailFrom = "Reporting mailbox<no_reply@domain.com>"
$Subject = "Report $Attachment - $date"
$SmtpServer = "10.3.0.250"

$smtpsettings = @{
	To =  $MailTo
	From = $MailFrom
    Subject = $subject
	SmtpServer = $SmtpServer
	}

	$htmlcontent="<html><body>
                <p>Report created $date. <br>
                CSV version of report attached to this email.</p>
		        </body></html>"	

    Send-MailMessage @smtpsettings -Body $htmlcontent -BodyAsHtml -Encoding ([System.Text.Encoding]::UTF8) -Attachments $Attachment
