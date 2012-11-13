-- Growl Alerts in Mail
-- Hunter Ford [http://www.cupcakewithsprinkles.com]
-- This script arises from the lack of any Growl Support in Mac OS X Snow Leopard (10.6)
-- Code inspired by and adapted from James Higgs [http://blog.jameshiggs.com/2009/08/28/growlmail-on-snow-leopard-a-temporary-fix/] as well as those mentioned.
-- Updated for Lion, Mail 5.3, and Growl 2.0 by Kevin Sulonen Sep 2012

tell application "Growl"
	-- Make a list of all the notification types
	-- that this script will ever send:
	set the allNotificationsList to {"New Email"}

	-- Make a list of the notifications
	-- that will be enabled by default.
	-- Those not enabled by default can be enabled later
	-- in the 'Applications' tab of the growl prefpane.
	set the enabledNotificationsList to {"New Email"}

	-- Register our script with growl.
	-- You can optionally (as here) set a default icon
	-- for this script's notifications.
	register as application "Mail" all notifications allNotificationsList default notifications enabledNotificationsList icon of application "Mail"
end tell

-- Mail Rule Trigger
--
-- Source: Benjamin S. Waldie [http://www.mactech.com/articles/mactech/Vol.21/21.09/ScriptingMail/index.html]
using terms from application "Mail"
	on perform mail action with messages theSelectedMessages for rule theRule
		repeat with thisMessage in theSelectedMessages
			-- Process the current message

			-- Grab the subject and sender of the message
			set growlSubject to subject of thisMessage
			set growlSender to my ExtractName(sender of thisMessage)

			-- Use the first 100 characters of a message
			set growlMessage to (content of thisMessage)
			set growlLength to (length of growlMessage)

			if growlLength > 100 then
				set growlMessage to (characters 1 through 100 of growlMessage) & ""
			end if

			set growlMessage to growlSubject & "

" & growlMessage

			-- Send a Notification
			tell application "Growl"
				notify with name "New Email" title growlSender description growlMessage application name "Mail"
			end tell
		end repeat
	end perform mail action with messages
end using terms from

-- *ExtractName*
--
-- gathers the name portion from the "From: " line
--
-- Source: robJ [http://forums.macosxhints.com/archive/index.php/t-19954.html]
to ExtractName(sender_)
	if sender_ begins with "<" then
		return text 2 thru -2 of sender_
	else
		set oldTIDs to text item delimiters
		try
			set text item delimiters to "<"
			set name_ to first text item of sender_
			set text item delimiters to oldTIDs
		on error
			set text item delimiters to oldTIDs
		end try
		return name_
	end if
end ExtractName