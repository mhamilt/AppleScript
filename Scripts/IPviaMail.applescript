--Script to find WAN IP and then send it to inbox
set ip_address to do shell script "/usr/bin/curl --silent http://checkip.dyndns.org/ | grep -o -E \"(\\d{1,3}\\.?){4}\" "

set recipientName to "YOURNAME" -- EDIT HERE
set recipientAddress to "YOURADDRESS" -- EDIT HERE
set theSubject to ip_address
set theContent to ip_address

tell application "Mail"
	
	##Create the message
	set theMessage to make new outgoing message with properties {subject:theSubject, content:theContent, visible:true}
	
	##Set a recipient
	tell theMessage
		make new to recipient with properties {name:recipientName, address:recipientAddress}
		
		##Send the Message
		send
		
	end tell
end tell