-- theme by intrntbrn
require("awful.util")

theme = {}
menu 										= 	"/usr/share/awesome/icons/menu/"
icons 										= 	"/usr/share/awesome/icons/blue/"
layoutstyle								= "old-layout-huge-fill/" -- fill/outline

wallpaper    								= menu .. "nintendo_arch.png"
theme.wallpaper_cmd 				= { "awsetbg " .. wallpaper }

theme.font 								= "MonteCarlo 8"
theme.fg_normal 						= "#ecedee"
theme.fg_focus 						= "#262729"
theme.fg_urgent 						= "#262729"
theme.fg_title 							= "#66d9ef"
theme.fg_disabled 					= "#262729"

theme.bg_normal 						= "#262729"
theme.bg_focus 						= "#1692d0"
theme.bg_urgent 						= "#f92671"
theme.bg_disabled 					= "#5e7175"
theme.bg_hover 						= "#5e7175"

theme.border_width 					= 1
theme.border_normal 				= "#a3babf"
theme.border_focus 					= "#1692d0"
theme.border_marked 				= "#1692d0"

theme.menu_submenu_icon 		=  menu .. "menuexpand.png"
theme.menu_width 					= 130
theme.menu_border_color 			= "#262729"

theme.taglist_squares      		    = true
theme.taglist_squares_sel  	 	= menu .. "squarefw.png"
theme.taglist_squares_unsel 		= menu .. "squarefw.png"

theme.layout_tile       				= menu .. layoutstyle .. "tile.png"
theme.layout_tileleft   				= menu .. layoutstyle .. "tileleft.png"
theme.layout_tilebottom 			= menu .. layoutstyle .. "tilebottom.png"
theme.layout_tiletop    				= menu .. layoutstyle .. "tiletop.png"
theme.layout_fairv      				= menu .. layoutstyle .. "fairv.png"
theme.layout_fairh      				= menu .. layoutstyle .. "fairh.png"
theme.layout_spiral     				= menu .. layoutstyle .. "spiral.png"
theme.layout_dwindle    				= menu .. layoutstyle .. "dwindle.png"
theme.layout_max        				= menu .. layoutstyle .. "max.png"
theme.layout_fullscreen 			= menu .. layoutstyle .. "fullscreen.png"
theme.layout_magnifier  			= menu .. layoutstyle .. "magnifier.png"
theme.layout_floating   				= menu .. layoutstyle .. "floating.png"

theme.awesome_icon 				= icons .. "arch-blue.png"

return theme
