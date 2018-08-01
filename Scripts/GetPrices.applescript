(* Get Prices Script
 *
 * 	This script will go through an open numbers document that has a URL for parts
 * in Farnell/ CPC, RS-Online and Pimoroni then recover the item name, price and order code
 *
 *	This is currently a wok in process and will require 
 *
 *	- ggrep via homebrew
 *
 * 	Basically, it will open the URL, copy the text into a temp text edit file then grep, head and or tail for
 * 	data retrieval. This is unbelivably hacky, but it should demonstrate som of the functionality of Applescript
 *
 *
 *	This script was created in order populate a spreadsheet when ordering components
 *
 *)

--================================================================================
tell application "Numbers"
	--=============================================================================
	tell table 1 of sheet 1 of document 1
		set colIndex to address of column "URL"
		repeat with i from 13 to the count of rows
			set tempURL to (("\"" & value of cell colIndex of row i as string) & "\"")
			if tempURL ­ missing value then
				set termCommand to "/bin/echo " & tempURL & " | grep -o -E \"(farnell|rs|pimoroni)\" "
				--log termCommand
				set supplier to do shell script termCommand
				set supplier to word 1 of supplier
				log word 1 of supplier
				--=============================================================================
				tell application "Safari"
					tell window 1
						set newTab to items 2 thru -2 of tempURL as text
						set current tab to make new tab with properties {URL:newTab}
						log newTab
						delay 5
						set webText to text of current tab
						close current tab
					end tell
					
				end tell
				--=============================================================================
				tell application "TextEdit"
					activate
					open file "~:Downloads:tempweb.txt"
					set text of document 1 to webText as text
					save document 1 in file "Users:Shared:LastUpdate.txt"
					close document 1
				end tell
				
				set webTextFile to "/Users/Shared/LastUpdate.txt"
				--=============================================================================
				if supplier is "pimoroni" or supplier is "rs" then
					set grepCommand to "/usr/local/Cellar/grep/3.1/bin/ggrep -A1 -E \"Price\" " & webTextFile & " | grep -v \"Price\""
					try
						set price to do shell script grepCommand
					on error
						set price to "Can't get Price"
					end try
					
					if supplier is "rs" then
						set orderCodeCmd to "/usr/local/Cellar/grep/3.1/bin/ggrep -oP -e \"(?<=RS Stock No\\. ).+(?= Brand RS Pro)\" " & webTextFile
						try
							set orderCode to do shell script orderCodeCmd
						on error
							set orderCode to "check order code"
						end try
						
						set itemNameCmd to "/usr/bin/head -9 " & webTextFile & " | tail -1"
						try
							set itemName to do shell script itemNameCmd
						on error
							set itemName to "CHECK NAME"
						end try
						
						set itemNameCmd to "/usr/bin/grep -B3 -e \"^Ask a question\" " & webTextFile & " | head -n 1"
						try
							set itemName to do shell script itemNameCmd
						on error
							set itemName to "CHECK NAME"
						end try
						set value of cell 1 of row i to itemName
					end if
					
					if supplier is "pimoroni" then
						set itemNameCmd to "/usr/local/Cellar/grep/3.1/bin/ggrep -oP -e \"(?<=A product image of ).+\" " & webTextFile
						try
							set itemName to do shell script itemNameCmd
						on error
							set itemName to "CHECK NAME"
						end try
						set orderCodeCmd to "/usr/bin/grep -B1 -e \"all prices include VAT @ 20%\" /Users/mhamilt7/Untitled.txt | grep -v \"all prices include VAT @ 20%\" | grep -o -E \"^\\S*\""
						try
							set orderCode to do shell script orderCodeCmd
						on error
							set orderCode to ""
						end try
					end if
				end if
				--=============================================================================
				if supplier = "farnell" then
					set grepCommand to "/usr/local/Cellar/grep/3.1/bin/ggrep -E \"(1 \\+ )£.+\" " & webTextFile
					set orderCodeCmd to "/usr/local/Cellar/grep/3.1/bin/ggrep -oP -e \"(?<=Order Code:\\s).+\" " & webTextFile
					log orderCodeCmd
					--set orderCodeCmd to "/bin/echo " & tempURL & " | grep -o -E \"\\d{7}\""
					--set itemNameCmd to "/usr/local/Cellar/grep/3.1/bin/ggrep -oP -e \"(?<=Manufacturer Part No:\\s).+\" " & webTextFile
					set itemNameCmd to "/usr/bin/grep -A1 -e \"Print Page\" " & webTextFile & " | grep -v \"Print Page\""
					log orderCodeCmd
					log grepCommand
					try
						set price to do shell script grepCommand
						set price to items 5 thru -1 of price as text
					on error
						set price to "Can't get Price"
					end try
					
					try
						set orderCode to do shell script orderCodeCmd
					on error
						set orderCode to "check order code"
					end try
					
					try
						set itemName to do shell script itemNameCmd
					on error
						set itemName to "CHECK NAME"
					end try
					set value of cell 1 of row i to itemName
					
				end if
				--=============================================================================
				log orderCode
				log price
				set value of cell 3 of row i to price
				set value of cell 5 of row i to supplier
				set value of cell 6 of row i to orderCode
			end if
			--=============================================================================			
			tell application "Finder" to delete "/Users/Shared/LastUpdate.txt" as POSIX file
			--=============================================================================			
		end repeat
	end tell
	
end tell

--EOF