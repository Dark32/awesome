require('awful')
require('vicious')
require('naughty')
local M = {}
function M.new(args)
	local gmail = {}
	gmail.widget = widget({type = "imagebox" })
	gmail.widget.image = image("/usr/share/awesome/icons/blue/mail.png")

	gmail.enabled = true
	gmail.args = { ["{count}"] = 0 }
	gmail.widget:buttons(awful.util.table.join(
		awful.button({ }, 1, function ()
			local browser = browser or "dwb"
			awful.util.spawn(browser .. " https://mail.google.com")
			gmail.widget.image = image("/usr/share/awesome/icons/blue/mail.png")
			gmail.args["{count}"] = 0
		end),
		awful.button({}, 3, function ()
			if gmail.enabled then
				gmail.widget.image = image("/usr/share/awesome/icons/blue/mail.png")
				vicious.unregister(gmail.widget, true)
			else
				gmail.widget.image = image("/usr/share/awesome/icons/blue/mail.png")
				vicious.activate(gmail.widget)
			end
			gmail.enabled = not gmail.enabled
		end)
	))

	gmail.notify = nil
	gmail.widget:add_signal("mouse::enter",
	function()
		local popuptext = ""
		if gmail.args["{count}"] > 0 then
			popuptext = gmail.args["{count}"] .. " unread mails."
		else
			popuptext = "no unread mail"
		end
		if gmail.notify then
			naughty.destroy(gmail.notify)
		end
		gmail.notify = naughty.notify({
			text = popuptext,
			title = "Mail",
			timeout = 0,
			position = "top_left"
		})
	end)
	gmail.widget:add_signal("mouse::leave", 
	function ()
		if gmail.notify then
			naughty.destroy(gmail.notify)
			gmail.notify = nil
		end
	end)
	vicious.register(gmail.widget, vicious.widgets.gmail,
	function(widget, args)
		if args["{count}"] > 0 then
			widget.image = image("/usr/share/awesome/icons/blue/mail_new.png")
		else
			widget.image = image("/usr/share/awesome/icons/blue/mail.png")
		end
		if args["{count}"] > gmail.args["{count}"] then
			naughty.notify({
				text = "new mail: " .. args["{subject}"] .. "\nand " .. (args["{count}"]-1) .. " more...",
				title = "New Mail",
				timeout = 5,
				position = "top_left"
			})
		
		end
		gmail.args["{count}"] = args["{count}"]
		gmail.args["{subject}"] = args["{subject}"]
		return args
	end
	, 240)

	return gmail.widget
end

return M
