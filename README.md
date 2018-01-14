# Applescripts
A wee collection of useful applescripts I've collected over time.

For those unfamiliar with Applescript syntax a really handy codex for python users can be found here:
http://aurelio.net/articles/applescript-vs-python.html

Apple's documentation can be found here:
https://developer.apple.com/library/content/documentation/AppleScript/Conceptual/AppleScriptX/Concepts/work_with_as.html#//apple_ref/doc/uid/TP40001568-BABEBGCF

## Script list
All scripts can be run via:
+ [An Automator Calendar Alarm](https://discussions.apple.com/docs/DOC-4082)
+ [An Apple Mail rule action](https://support.apple.com/en-gb/guide/mail/use-scripts-with-mail-rules-mlhlp1171/mac)
+ [a standalone application](https://developer.apple.com/library/content/documentation/LanguagesUtilities/Conceptual/MacAutomationScriptingGuide/SaveaScript.html)

### IPviaEmail
This script sends the WAN IP address of your machine to a specified email address.
If, like me, you have a MacMini sitting at home as a server, this script can be
connected to a mac Mail rule for easy update of IP address. 

This is mainly for those who are too lazy to organise a static IP but would
like remote access of their machine

### IPviaText
Same as IPviaEmail but will send an iMessage instead. Only useful if you have
an iPhone. This script exhibits a slightly different way of parsing the WAN IP
from checkip.dyndns.org
