-- rc.lua by intrntbrn

require("awful")
require("awful.autofocus")
require("awful.rules")
require("beautiful")
require("naughty")
require("vicious")
require("blingbling")

-- startup error
do
    local in_error = false
    awesome.add_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "time to debug",
                         text = err,
			 timeout = 1 }) -- CHANGED TIMEOUT TIME
        in_error = false
    end)
end


-- error handling
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end


-- theme
beautiful.init("/usr/share/awesome/themes/lightblue/theme.lua")
barheight 	= 16
borderwidth = 0

-- path
config		= awful.util.getdir("config")
icons		= "/usr/share/awesome/icons/blue/"
iconsmenu   = "/usr/share/awesome/icons/menu/"

-- std programs
terminal	= "urxvt"
browser		= "dwb"
editor		= os.getenv("EDITOR") or "vim"
editor_cmd	= terminal .. " -e " .. editor
guieditor	= "geany "
fm			= "spacefm "

-- alias
exec		= awful.util.spawn
sexec		= awful.util.spawn_with_shell
modkey 		= "Mod4"
winkey		= "Mod4"
altkey		= "Mod1"

-- mixed
space 		= 48
widthMpd 	= 350
useMpd 		= true


-- layouts
layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
 --   awful.layout.suit.max.fullscreen,
 --   awful.layout.suit.magnifier
}


-- tags
 tags = {
   names  = { "sys", "web", "doc", "dev", "irc", "fooaa"},
   layout = { layouts[1], layouts[10], layouts[8], layouts[8], layouts[2], layouts[1]},
   icons  = {nil, icons .. "arrow.png", icons .. "arrow.png", icons .. "arrow.png", icons .. "arrow.png", icons .. "arrow.png"}
   }
 
 
 for s = 1, screen.count() do
     tags[s] = awful.tag(tags.names, s, tags.layout)

  for i, t in ipairs(tags[s]) do
      awful.tag.seticon(tags.icons[i], t)
  end
 end



-- menu
myawesomemenu = {
   { "Edit rc.lua", function () sexec(guieditor .. "rc.lua") end},
   { "Edit theme.lua", function () sexec(guieditor ..  "theme.lua") end },
   { "Testmode", function () sexec("bash ~/bin/awsm.sh") end},
   { "Restart", awesome.restart },
   { "Quit", awesome.quit }
}

mysystemmenu = {
   { "Shutdown", function () sexec("sudo shutdown -h 0") end},
   { "Reboot", function () sexec("sudo reboot") end},
   { "Lock", function () sexec("slimlock") end},
   { "Suspend", function () sexec("sudo pm-suspend") end},
   { "Hibernate", function () sexec("sudo pm-hibernate") end}
}

myfoldermenu = {
   { "Home", function () exec(fm .. " ~/") end},
   { "Downloads", function () exec(fm .. " ~/Downloads") end},
   { "Movies", function () exec(fm .. " ~/HDD/Film") end},
   { "Music", function () exec(fm .. " ~/HDD/Musik") end},
   { "Stick", function () exec(fm .. " ~/STICK") end},
   { "Downloads JD", function () exec(fm .. " ~/HDD/Downloads_JD") end},
   { " ", nil, nil}, 
   { "Workspace", function () exec(fm .. " ~/Workspace") end},
   { "Dropbox WS", function () exec(fm .. " ~/Dropbox/WORKSPACE") end},
   { "Netbeans", function () exec(fm .. " ~/Workspace/NetBeansProjects") end},
   { " ", nil, nil}, 
   { "SE", function () exec(fm .. " ~/Dropbox/SS2011/SS2012/SE") end},
   { "DB", function () exec(fm .. " ~/Dropbox/SS2011/SS2012/Datenbanken") end},
   { "MPS", function () exec(fm .. " ~/Dropbox/SS2011/SS2012/MPS-ARM") end},
   { "OS", function () exec(fm .. " ~/Dropbox/SS2011/SS2012/Betriebssysteme") end},
}

myinternetmenu = {
	{ "Dwb", "dwb"},
	{ "Firefox", "firefox"},
	{ " ", nil, nil}, 
    { "jDownloader", function () exec("jdownloader") end},	
    { "Mcabber", terminal .. " -e mcabber" },
    { "IRC", terminal .. " -e weechat-curses" },
    { "Youtube", terminal .. " -e youtube-viewer" },
	{ " ", nil, nil}, 
    { "Wicd", "wicd-gtk"},
}

mymultimediamenu = {
   { "ncmpcpp", terminal .. " -e ncmpcpp"},
   { "Dreambox WebTV", "vlc stream.m3u" },  
   { "Vlc", function () exec("vlc") end},
   { "Gnome-Mplayer", function () exec("gnome-mplayer") end},
}

mydevelmenu = {
   { "Eclipse", "eclipse" },
   { "Netbeans", function () sexec("wmname LG3D; netbeans --laf com.sun.java.swing.plaf.gtk.GTKLookAndFeel") end},
   { "Insight ARM", function () sexec("~/toolchain/insight/bin/arm-none-eabi-insight") end},   
}

mygraphicsmenu = {
   { "Gimp", function () exec("gimp") end},
   { "Mirage", function () exec("mirage") end},
   { "Feh", function () sexec("feh") end},   
}

myappmenu = {
   { "Powertop", terminal .. " -e powertop2"},  
}

myofficemenu = {
   { "Geany", "geany" },
   { "Medit", "medit" },
   { "Gvim", "gvim" },
   { "Gedit", "gedit" },
   { " ", nil, nil}, 
   { "Zathura", "zathura" },
   { "Epdfview", "epdfview" },
   { " ", nil, nil}, 
   { "Calculator", function () exec("gnome-calculator") end},
}


mymainmenu = awful.menu({ items = { 	
					{ "Internet", myinternetmenu, iconsmenu .. "internet.png" },	
					{ "Multimedia", mymultimediamenu, iconsmenu .. "multimedia.png" },	
					{ "Office", myofficemenu, iconsmenu .. "office.png" },	
					{ "Development", mydevelmenu, iconsmenu .. "development.png" },		
					{ "Graphics", mygraphicsmenu, iconsmenu .. "graphics.png" },
					{ "Other Apps", myappmenu, iconsmenu .. "otherapp.png" },
					{ "Awesome", myawesomemenu, iconsmenu .."awesome-greenmod.png" },
				    { "Folder", myfoldermenu, iconsmenu .."folder.png" },
					{ " ", nil, nil}, 
                    { "Terminal", terminal },
   					{ "Browser", function () exec(browser) end},
   					{ "Filemanager", function () exec(fm .. "/home/intrntbrn/") end},
   					{ "Editor", function () sexec(guieditor) end},
   					{ "Thunar", function () sexec("thunar") end},   					
 					{ " ", nil, nil}, 
   				    { "Exit", mysystemmenu, iconsmenu .. "arch-red.png" },
   					
			}
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })


-- systray
mysystray = widget({ type = "systray" })


-- wiboxes
mywibox = {}
mywib = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
						-- swap to master mod
                                              if c == client.focus then
                                                 --  c.minimized = true
						  client.focus = c
						 -- c:swap(awful.client.getmaster())
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
							client.focus = c
						 --	c:swap(awful.client.getmaster())
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
						 -- c:swap(awful.client.getmaster())
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end),
		     -- middle mouse
		     awful.button({ }, 0, function (c)
						if c == client.focus then
							c.minimized = true
						else
							client.focus = c
							c:raise()
						end
                                          end))	  

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)
					  
			
			
-- widgets		
			
---------- spacer
	spacer = widget({ type = "textbox" })	
	spacer.text = " "

---------- klammern
	kl = widget({ type = "textbox" })	
	kl.text = '<span color="#ffffff">' .. " [" .. '</span>'
	
	kr = widget({ type = "textbox" })	
	kr.text = '<span color="#ffffff">' .. "]" .. '</span>'


	

	
---------- textclock	
	mytextclock = awful.widget.textclock({ align = "right",}, "%H:%M", 60)
	mytextclock.width = 32



---------- calendar
	my_cal =blingbling.calendar.new({type = "imagebox", image = icons .. "clock.png"})
	my_cal:set_cell_padding(2)
	my_cal:set_title_font_size(8)
	my_cal:set_font_size(8)
	my_cal:set_inter_margin(1)
	my_cal:set_columns_lines_titles_font_size(8)
	my_cal:set_columns_lines_titles_text_color("#1692d0ff")
	my_cal:set_link_to_external_calendar(true)
	
	
	
---------- wlan widget
	wlanwidget = widget({ type = "textbox" }) 
	vicious.register(wlanwidget, vicious.widgets.wifi, 
	function (widget, args)
		if ((args["{link}"] == 0) or (args["{link}"] == nil)) then
			netwidget.width = 0
			netwidget.visible = false
			neticon.visible = false
			return  "off"
		else 
			netwidget.width = space
			netwidget.visible = true
			neticon.visible = true
			return  round(((args["{link}"] *100) / 70), 0) .. "%"
	
		end
	end, 10, "wlan0")  
	
	wlanwidget.width = space
	
	wlanicon = widget({ type = "imagebox" })
	wlanicon.image = image(icons .. "wifi_01.png")
	
---------- wlan downstream
	netwidget = widget({ type = "textbox" })
	vicious.register(netwidget, vicious.widgets.net,
	function (widget, args)
		if (args["{wlan0 down_kb}"] ~= nil) then
			return round(args["{wlan0 down_kb}"], 0) .. "kb"
		
		else 
			return ""
		end
	end)
	netwidget.width = space
	
	neticon = widget({ type = "imagebox" })
	neticon.image = image(icons .. "net_down_01.png")
					  
	
---------- mem load
	mymem = widget({ type = "textbox" })
	vicious.register(mymem, vicious.widgets.mem, "$1%", 30)
	mymem.width = space
	
	mymemicon = widget({ type = "imagebox" })
	mymemicon.image = image(icons .. "mem.png")
	
	
---------- cpu load
	mycpuload = widget({ type = "textbox" })
        vicious.register(mycpuload, vicious.widgets.cpu, "$1%", 5)
	mycpuload.width = space
	
	mycpuloadicon = widget({ type = "imagebox" })
	mycpuloadicon.image = image(icons .. "cpu.png")
	
---------- fan()
        function fan()
	    local file = io.open("/sys/devices/platform/thinkpad_hwmon/fan1_input", "r")
	    local fan = file:read("*n")
	    file:close()

    	    return fan
	end
	
---------- cputmp()
	function cputemp()
	    local file = io.open("/sys/class/thermal/thermal_zone0/temp", "r")
	    local tmp = file:read("*n")
	    file:close()
	    output = tmp / 1000

    	    return output
	end		
	
---------- cpu popup
	mycpuloadicon:add_signal("mouse::enter", function() batnotify = naughty.notify({
	text = "Fan: " .. fan() .. " RPM\n" .. "Temp: " .. cputemp() .. " °C",
	title = "CPU Info",
	timeout = 0
	})
	end)
	
	mycpuloadicon:add_signal("mouse::leave", 
	function ()
		if batnotify then
			naughty.destroy(batnotify)
			batnotify = nil
		end
	end)
			
	
---------- volume
	myvolicon = widget({ type = "imagebox" })
	myvolicon.image = image(icons .. "spkr_01.png")
	
	myvol = widget({ type = "textbox" })
		vicious.register(myvol, vicious.widgets.volume,
		function (widget, args)
			if args[1] < 1 then
				myvolicon.image = image(icons .. "spkr_02.png")		
				return "mute"
			else 
				myvolicon.image = image(icons .. "spkr_01.png")	
				return args[1] .. "%"
			end
		end, 2, "Master")
	
	myvol.width = space
	
	 myvolicon:buttons(awful.util.table.join(
    awful.button({ }, 1, function () sexec("sh ~/bin/vol.sh mute", false) end)))

	
	
---------- battery
	mybaticon = widget({ type = "imagebox" })
	mybaticon.image = image(icons .. "bat_full_01.png")
	
	-- batstate()
	function batstate()
		local fileee = io.open("/sys/class/power_supply/BAT0/status", "r")
		local batstate = fileee:read("*line")
		if ((batstate == 'Discharging') or (batstate == 'Charging')) then
			return batstate
		else
			return "Fully charged"
		end
	end
	
	
	-- round()
	function round(num, idp)
		if ((num ~= nil) and (num ~= 0)) then
			local mult = 10^(idp or 0)
			return math.floor(num * mult + 0.5) / mult
		else 
			return 0
		end
	end
	
	-- shutdown()
	function shdown()
		sexec("sudo pm-suspend")
	end
	
	
	-- watt()
	function watt()
	    	    
		if (batstate() == 'Discharging') then
		
			if(assert(io.open("/sys/devices/platform/smapi/BAT0/power_avg", "r"))) then
					
				local file = io.open("/sys/devices/platform/smapi/BAT0/power_avg", "r")
				local avg = file:read("*n")
				file:close()
			
				wattavg = ((avg * -1) / 1000)
				
				return "\nUsage: ".. round(wattavg, 2) .. " W"
			else
				return "\nUsage: Error"			
			end	
		else
			return ""
		end
	end
	
		
	-- remaining()
	function remaining()
	
		if (batstate() == 'Fully charged') then
			return ""
		end
		
		if (batstate() == 'Discharging') then
		
				if (assert(io.open("/sys/devices/platform/smapi/BAT0/remaining_running_time", "r"))) then
					local file = (io.open("/sys/devices/platform/smapi/BAT0/remaining_running_time", "r"))
					local remain = file:read("*n")
					file:close()
					
					return "\nRemaining: " .. remain .. " min" 	
					
				else return "\nRemaining: Error" 			 
				end	
		else	    
			
			if (assert(io.open("/sys/devices/platform/smapi/BAT0/remaining_charging_time", "r"))) then
				local filee = io.open("/sys/devices/platform/smapi/BAT0/remaining_charging_time", "r")
				local charge = filee:read("*n")
				filee:close()
				return "\nRemaining: " .. charge .. " min"
			else 
				return "\nRemaining: Error"
			end	
		end
	 end
	
	 -- batterypopup
	mybaticon:add_signal("mouse::enter", function() batnotify = naughty.notify({
	text = "Status: " .. batstate() .. watt() .. remaining(),
	title = "Battery Info",
	timeout = 0
	})
	end)
	
		
	mybaticon:add_signal("mouse::leave", 
	function ()
		if batnotify then
			naughty.destroy(batnotify)
			batnotify = nil
		end
	end)
	
	
	mybat = widget({ type = "textbox" })
	vicious.register(mybat, vicious.widgets.bat,
	function (widget, args)
	
			batnofiy = nil

			-- critical ( < 4)
			if (args[2] < 4 and batstate() == 'Discharging') then
				naughty.notify({
						text = "hybernating to disk now",
						title = "Critical Battery",
						position = "top_right",
						timeout = 30,
						fg="#262729",
						bg="#f92671",
						screen = 1,
						ontop = true, 
						run = function () sexec("sudo pm-suspend") end
				})
				shdown()
				mybaticon.image = image(icons .. "bat_empty_01.png")
				return args[2] .. "%"

			-- low ( < 10)
			elseif (args[2] < 10 and batstate() == 'Discharging') then
				naughty.notify({
						text = "charge now",
						title = "Low Battery",
						position = "top_right",
						timeout = 1,
						fg="#262729",
						bg="#f92671",
						screen = 1,
						ontop = true, 
				})
				
				mybaticon.image = image(icons .. "bat_empty_01.png")
				return args[2] .. "%"
				
			-- normal discharging
			elseif (batstate() == 'Discharging') then
				mybaticon.image = image(icons .."bat_full_01.png")
				return args[2] .. "%"
			-- charging
			else	
				mybaticon.image = image(icons .. "ac_01.png")
				return args[2] .. "%"
		end
	end, 61, 'BAT0')
	mybat.width = space
	
	
	
---------- gmail old (inactive only for popup)	
	awful.widget.gmail = require('awful.widget.gmail')
	gmailwidget = awful.widget.gmail.new()
	
	
---------- gmailcount
mygmail = widget({ type = "textbox" })
-- gmail_t = awful.tooltip({ objects = { mygmail },})
mygmail.width = space


vicious.register(mygmail, vicious.widgets.gmail,
                function (widget, args)
               --     gmail_t:set_text(args["{subject}"])
               --     gmail_t:add_to_object(mygmailimg)
                    return args["{count}"]
                 end, 120) 
	

----------- pacman
pacicon = widget({type = "imagebox" })
pacicon.image = image(icons .."pacman.png")

pacwidget = widget({type = "textbox"})
--pacwidget_t = awful.tooltip({ objects = { pacwidget},})
vicious.register(pacwidget, vicious.widgets.pkg,
                function(widget,args)
                    return args[1]
                end, 900, "Arch")
                
 pacicon:buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn(terminal .. " -e yaourt -Syyua", false) end)
))
pacwidget.width = space
	
------ MPD
	if useMpd == true then
	
	 mpdstop = widget({ type = "textbox" })	
	 mpdstop.text = "stop"
	 mpdstop.width = space
	
	  music_play = awful.widget.launcher({
	    image = image(icons .. "play.png"),
	    command = "ncmpcpp toggle && echo -e 'vicious.force({ mpdwidget, })' | awesome-client"
	  })

	  music_pause = awful.widget.launcher({
	    image = image(icons .. "pause.png"),
	    command = "ncmpcpp toggle && echo -e 'vicious.force({ mpdwidget, })' | awesome-client"
	  })
	  music_pause.visible = false

	  music_stop = awful.widget.launcher({
	    image = image(icons .. "stop.png"),
	    command = "ncmpcpp stop && echo -e 'vicious.force({ mpdwidget, })' | awesome-client"
	  })

	  music_prev = awful.widget.launcher({
	    image = image(icons .. "prev.png"),
	    command = "ncmpcpp prev && echo -e 'vicious.force({ mpdwidget, })' | awesome-client"
	  })

	  music_next = awful.widget.launcher({
	    image = image(icons .. "next.png"),
	    command = "ncmpcpp next && echo -e 'vicious.force({ mpdwidget, })' | awesome-client"
	  })
	  maxlength = 15
  
	  mpdicon = awful.widget.launcher({
	    image = image(icons .. "note.png"),
	    command = "ncmpcpp toggle && echo -e 'vicious.force({ mpdwidget, })' | awesome-client"
	  })
  
	  mpdwidget = widget({ type = "textbox" })
	  mpdwidget.width = widthMpd
	  vicious.register(mpdwidget, vicious.widgets.mpd,
	    function(widget, args)
    
	      local string = args["{Artist}"] .. " - " .. args["{Title}"]

	      -- play
	      if (args["{state}"] == "Play") then
		music_play.visible = false
		music_pause.visible = true
		music_next.visible = true
		music_prev.visible = true
		music_stop.visible = true
		mpdwidget.visible = true
		mpdicon.visible = false
		mpdstop.visible = false
		kr.visible = true
		kl.visible = true
		return string
		
	      -- pause
	      elseif (args["{state}"] == "Pause") then
      
		music_play.visible = true
		music_pause.visible = false
		music_next.visible = true
		music_prev.visible = true
		music_stop.visible = true
		mpdwidget.visible = true
		mpdicon.visible = false
		mpdstop.visible = false
		kr.visible = true
		kl.visible = true
		return string  
		
	      -- stop
	      else
		mpdicon.visible = true
		music_play.visible = false
		music_pause.visible = false
		music_next.visible = false
		music_prev.visible = false
		music_stop.visible = false
		mpdwidget.visible = false
		mpdstop.visible = true
		kr.visible = false
		kl.visible = false
		return string
	
	      end

	    end, 1)
	end

    
-- wibox

    -- top
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    
        mywibox[s].widgets = {
            {
        mylauncher,
        spacer,
        mytaglist[s],
        spacer,
        mylayoutbox[s],
	    spacer,
	    spacer,
	    spacer,
	    kl,
	    music_play,
	    music_pause,
    	music_stop,
    	music_prev,
	    music_next,
	    kr,
	    spacer,   
	    mpdwidget,
	    spacer,
        mypromptbox[s],
        layout = awful.widget.layout.horizontal.leftright,
        },

        mytextclock,
	    my_cal.widget,

	    

        mybat,
	    mybaticon,

	    myvol,
        myvolicon,

        mymem,
	    mymemicon,

	    mycpuload,
	    mycpuloadicon,

	    netwidget,
	    neticon,
	    
	    wlanwidget,
	    wlanicon,
	    
		pacwidget,
	    pacicon,

        mygmail,
		gmailwidget,

		mpdstop,
		mpdicon,
		

				
        s == 1 or nil,
        layout = awful.widget.layout.horizontal.rightleft		         
    }
    
    
    -- bottom 
    mywib[s] = awful.wibox({ position = "bottom", screen = s})
    
    
    mywib[s].widgets = {
	-- s == 1 and mysystray or nil,
	mysystray,
        mytasklist[s],
        
        layout = awful.widget.layout.horizontal.rightleft
        
    }
end


-- mouse binds
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))


-- key binds
globalkeys = awful.util.table.join(
    awful.key({ "Control"           }, "Left",   awful.tag.viewprev       ),
    awful.key({ "Control"           }, "Right",  awful.tag.viewnext       ),
    awful.key({ "Control"           }, "Escape", awful.tag.history.restore),
    awful.key({}, "#122", function () sexec("sh ~/bin/vol.sh down" ) end),
    awful.key({}, "#123", function () sexec("sh ~/bin/vol.sh up") end),
    awful.key({}, "#121", function () sexec("sh ~/bin/vol.sh mute") end),
    awful.key({}, "#233", function () sexec("sh ~/bin/bright.sh") end),
    awful.key({}, "#232", function () sexec("sh ~/bin/bright.sh") end),
    awful.key({ altkey,           }, "Tab",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ altkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey			    }, "Tab", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ altkey            }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ altkey            }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ "Control"         }, "y", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
--    awful.key({ modkey, "Shift"   }, "q", awesome.quit),
    awful.key({ }, "F1", function () exec("dwb") end),
--    awful.key({ }, "F1", function () run_or_raise("dwb", { class = "Dwb" }) end),
    awful.key({ }, "F8", function () run_or_raise("firefox", { class = "Firefox" }) end),    
    awful.key({}, "#160", function () exec("slimlock") end),
    awful.key({}, "#150", function () sexec("sudo pm-suspend") end),
    
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ altkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ altkey           }, "m",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ "Control"   	  }, "q",      function (c) c:kill()                         end),
    awful.key({ altkey }, "d",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ altkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ altkey           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ altkey           }, "f",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ "Control" }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ altkey }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ altkey }, 1, awful.mouse.client.move),
    awful.button({ altkey }, 3, awful.mouse.client.resize))

root.keys(globalkeys)



-- rules

awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },


{ rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][2] } },
      
      
      -- 1: sys
      
      
      
      -- 2: web
      
          { rule = { class = "Firefox" },
      except = { instance = "Navigator" },
      properties = { tag = tags[1][2], floating = true, switchtotag = true },
 --     callback = awful.placement.centered
      
      
    },
        { rule = { class = "Firefox", instance = "Navigator" },
      properties = { tag = tags[1][2], switchtotag = true }
    },
    
        { rule = { class = "Firefox", instance = "Dialog" },
      properties = { tag = tags[1][2], switchtotag = true }
    },
              { rule = { class = "Midori" },
      properties = { tag = tags[1][2], switchtotag = true }
    },
     { rule = { class = "Dwb" },
      properties = { tag = tags[1][2], switchtotag = true }
    },
      
      
      
      -- 3: doc
     { rule = { class = ".*[Mm]edit.*", name = ".*[Mm]edit.*", instance = ".*[Mm]edit.*" },
      except = { name = "Find" },
      properties = { tag = tags[1][3], switchtotag = true }
    },
   { rule = { class = "medit" },
      except = { name = "Find" },
      properties = { tag = tags[1][3], switchtotag = true }
    },
    { rule = { instance = "medit" },
      except = { name = "Find" },
      properties = { tag = tags[1][3], switchtotag = true }
    },
    { rule = { instance = "medit.*" },
      except = { name = "Find" },
      properties = { tag = tags[1][3], switchtotag = true }
    },
    { rule = { name = "^medit\ %-.*" },
      except = { name = "Find" },
      properties = { tag = tags[1][3], switchtotag = true }
    },
    { rule = { name = "medit.*" },
      except = { name = "Find" },
      properties = { tag = tags[1][3], switchtotag = true }
    },

              { rule = { class = "epdfview" },
      properties = { tag = tags[1][3], switchtotag = true }
    },
              { rule = { class = "Epdfview" },
      properties = { tag = tags[1][3], switchtotag = true }
    },
                  { rule = { class = "zathura" },
      properties = { tag = tags[1][3], switchtotag = true }
    },
              { rule = { class = "Zathura" },
      properties = { tag = tags[1][3], switchtotag = true }
    },
         { rule = { class = "Geany" },
      properties = { tag = tags[1][3], switchtotag = true }
    },
             { rule = { class = "geany" },
      properties = { tag = tags[1][3], switchtotag = true }
    },
    
     
      
      -- 4: dev
          
              { rule = { class = "NetBeans" },
      properties = { tag = tags[1][4], switchtotag = true }
    },
                  { rule = { class = "netbeans" },
      properties = { tag = tags[1][4], switchtotag = true }
    },
    
                       { rule = { class = "sun-awt-X11-XFramePeer" },
      properties = { tag = tags[1][4], switchtotag = true }
    },
                           { rule = { class = "java-lang-Thread" },
      properties = { tag = tags[1][4], switchtotag = true }
    },
		    { rule = { class = "Eclipse" },
      properties = { tag = tags[1][4], switchtotag = true }
    },

      
      
      -- 5: irc
      
      -- 6: foo
      
          { rule = { class = "Mplayer" },
      properties = { tag = tags[1][6], switchtotag = true }
    },
          { rule = { class = "mplayer" },
      properties = { tag = tags[1][6], switchtotag = true }
    },
    
    
    
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}


-- mcabber notifcation wrapper (gettin jabber msgs & statusupdates via naughty)

naughty.config.presets.online = {
    bg = "#1f880e80",
    fg = "#ffffff",
}
naughty.config.presets.chat = naughty.config.presets.online
naughty.config.presets.away = {
    bg = "#eb4b1380",
    fg = "#ffffff",
}
naughty.config.presets.xa = {
    bg = "#65000080",
    fg = "#ffffff",
}
naughty.config.presets.dnd = {
    bg = "#65340080",
    fg = "#ffffff",
}
naughty.config.presets.invisible = {
    bg = "#ffffff80",
    fg = "#000000",
}
naughty.config.presets.offline = {
    bg = "#64636380",
    fg = "#ffffff",
}
naughty.config.presets.requested = naughty.config.presets.offline
naughty.config.presets.error = {
    bg = "#ff000080",
    fg = "#ffffff",
}

muc_nick = "intrntbrn"

function mcabber_event_hook(kind, direction, jid, msg)
    if kind == "MSG" then
        if direction == "IN" or direction == "MUC" then
            local filehandle = io.open(msg)
            local txt = filehandle:read("*all")
            filehandle:close()
            awful.util.spawn("rm "..msg)
            if direction == "MUC" and txt:match("^<" .. muc_nick .. ">") then
                return
            end
            naughty.notify{
--                icon = "chat_msg_recv",
                text = awful.util.escape(txt),
                title = jid
            }
        end
    elseif kind == "STATUS" then
        local mapping = {
            [ "O" ] = "online",
            [ "F" ] = "chat",
            [ "A" ] = "away",
            [ "N" ] = "xa",
            [ "D" ] = "dnd",
            [ "I" ] = "invisible",
            [ "_" ] = "offline",
            [ "?" ] = "error",
            [ "X" ] = "requested"
        }
        local status = mapping[direction]
        local iconstatus = status
        if not status then
            status = "error"
        end
        if jid:match("icq") then
            iconstatus = "icq/" .. status
        end
        naughty.notify{
            preset = naughty.config.presets[status],
            text = jid,
 --           icon = iconstatus
        }
    end
end

-- RUN OR RAISE

--- Spawns cmd if no client can be found matching properties
-- If such a client can be found, pop to first tag where it is visible, and give it focus
-- @param cmd the command to execute
-- @param properties a table of properties to match against clients.  Possible entries: any properties of the client object
function run_or_raise(cmd, properties)
   local clients = client.get()
   local focused = awful.client.next(0)
   local findex = 0
   local matched_clients = {}
   local n = 0
   for i, c in pairs(clients) do
      --make an array of matched clients
      if match(properties, c) then
         n = n + 1
         matched_clients[n] = c
         if c == focused then
            findex = n
         end
      end
   end
   if n > 0 then
      local c = matched_clients[1]
      -- if the focused window matched switch focus to next in list
      if 0 < findex and findex < n then
         c = matched_clients[findex+1]
      end
      local ctags = c:tags()
      if table.getn(ctags) == 0 then
         -- ctags is empty, show client on current tag
         local curtag = awful.tag.selected()
         awful.client.movetotag(curtag, c)
      else
         -- Otherwise, pop to first tag client is visible on
         awful.tag.viewonly(ctags[1])
      end
      -- And then focus the client
      client.focus = c
      c:raise()
      return
   end
   awful.util.spawn(cmd)
end

-- Returns true if all pairs in table1 are present in table2
function match (table1, table2)
   for k, v in pairs(table1) do
      if table2[k] ~= v and not table2[k]:find(v) then
         return false
      end
   end
   return true
end


-- disable startup-notification globally
local oldspawn = awful.util.spawn
awful.util.spawn = function (s)
  oldspawn(s, false)
end

