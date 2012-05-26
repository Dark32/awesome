---------------------------------------------------------------------------
-- @author Julien Danjou &lt;julien@danjou.info&gt;
-- @copyright 2008-2009 Julien Danjou
-- @release v3.4.11
---------------------------------------------------------------------------

-- Grab environment we need
local capi = { screen = screen,
               image = image,
               client = client }
local ipairs = ipairs
local type = type
local setmetatable = setmetatable
local table = table
local common = require("awful.widget.common")
local beautiful = require("beautiful")
local client = require("awful.client")
local util = require("awful.util")
local tag = require("awful.tag")
local layout = require("awful.widget.layout")

--- Tasklist widget module for awful
module("awful.widget.tasklist")

-- Public structures
label = {}

icons = "/usr/share/awesome/icons/client/"

local function tasklist_update(w, buttons, label, data, widgets)
    local clients = capi.client.get()
    local shownclients = {}
    for k, c in ipairs(clients) do
        if not (c.skip_taskbar or c.hidden
            or c.type == "splash" or c.type == "dock" or c.type == "desktop") then
            table.insert(shownclients, c)
        end
    end
    -- sortmpd
 --   function cmp(c1,c2)
 --      return c1.pid < c2.pid
 --   end

  --  table.sort(clients,cmp)
    -- /mod
    clients = shownclients

    common.list_update(w, buttons, label, data, widgets, clients)
end

--- Create a new tasklist widget.
-- @param label Label function to use.
-- @param buttons A table with buttons binding to set.
function new(label, buttons)
    local w = {
        layout = layout.horizontal.flex
    }
    local widgets = { }
    widgets.imagebox = { }
    widgets.textbox  = { margin    = { left  = 2,
                                       right = 2 },
                         bg_resize = true,
                         bg_align  = "right"
                       }
    local data = setmetatable({}, { __mode = 'kv' })
    local u = function () tasklist_update(w, buttons, label, data, widgets) end
    for s = 1, capi.screen.count() do
        tag.attached_add_signal(s, "property::selected", u)
        capi.screen[s]:add_signal("tag::attach", u)
        capi.screen[s]:add_signal("tag::detach", u)
    end
    capi.client.add_signal("new", function (c)
        c:add_signal("property::urgent", u)
        c:add_signal("property::floating", u)
        c:add_signal("property::maximized_horizontal", u)
        c:add_signal("property::maximized_vertical", u)
        c:add_signal("property::minimized", u)
        c:add_signal("property::name", u)
        c:add_signal("property::icon_name", u)
        c:add_signal("property::icon", u)
        c:add_signal("property::skip_taskbar", u)
        c:add_signal("property::screen", u)
        c:add_signal("property::hidden", u)
        c:add_signal("tagged", u)
        c:add_signal("untagged", u)
    end)
    capi.client.add_signal("unmanage", u)
    capi.client.add_signal("list", u)
    capi.client.add_signal("focus", u)
    capi.client.add_signal("unfocus", u)
    u()
    return w
end

-- custom icons
mcabber = capi.image(icons .. "chat.png")
geany = capi.image(icons .. "editor.png")
ncmpcpp = capi.image(icons .. "music.png")
weechat = capi.image(icons .. "irc.png")

-- color of client states
state_focus = "#0a0a0b"
state_normal = "#426797"

local function widget_tasklist_label_common(c, args)
    if not args then args = {} end
    local theme = beautiful.get()
    local fg_focus = args.fg_focus or theme.tasklist_fg_focus or theme.fg_focus
    local bg_focus = args.bg_focus or theme.tasklist_bg_focus or theme.bg_focus
    local fg_urgent = args.fg_urgent or theme.tasklist_fg_urgent or theme.fg_urgent
    local bg_urgent = args.bg_urgent or theme.tasklist_bg_urgent or theme.bg_urgent
    local fg_minimize = args.fg_minimize or theme.tasklist_fg_minimize or theme.fg_minimize
    local bg_minimize = args.bg_minimize or theme.tasklist_bg_minimize or theme.bg_minimize

    local font = args.font or theme.tasklist_font or theme.font or ""
    local bg =  nil
    local text = "<span font_desc='"..font.."'>"
    local name


    if c.minimized then
        name = util.escape(c.icon_name) or util.escape(c.name) or util.escape("<untitled>")
    else
        name = util.escape(c.name) or util.escape("<untitled>")
    end
    if capi.client.focus == c then
        bg = bg_focus
        if fg_focus then
            text = text .. "<span color='"..util.color_strip_alpha(fg_focus).."'>"..name.."</span>"
        else
            text = text .. name
        end
    elseif c.urgent and fg_urgent then
        bg = bg_urgent
        text = text .. "<span color='"..util.color_strip_alpha(fg_urgent).."'>"..name.."</span>"
    elseif c.minimized and fg_minimize and bg_minimize then
        bg = bg_minimize
        text = text .. "<span color='"..util.color_strip_alpha(fg_minimize).."'>"..name.."</span>"
    else
        text = text .. name
    end

    ---- state mod

    -- focus
    if capi.client.focus == c then

        if client.floating.get(c) then
            text = text .. "<span color='" .. state_focus .. "'>" .. " [f]" .. "</span>"
        end

        if c.minimized then
            text = text .. "<span color='" .. state_focus .. "'>" .. " [m]" .. "</span>"
        elseif c.ontop then
            text = text .. "<span color='" .. state_focus .. "'>" .. " [t]" .. "</span>"
        end

        if c.sticky then
            text = text .. "<span color='" .. state_focus .. "'>" .. " [s]" .. "</span>"
        end

    -- normal
    else
        if client.floating.get(c) then
            text = text .. "<span color='" .. state_normal .. "'>" .. " [f]" .. "</span>"
        end

        if c.minimized then
            text = text .. "<span color='" .. state_normal .. "'>" .. " [m]" .. "</span>"
        elseif c.ontop then
            text = text .. "<span color='" .. state_normal .. "'>" .. " [t]" .. "</span>"
        end

        if c.sticky then
            text = text .. "<span color='" .. state_normal .. "'>" .. " [s]" .. "</span>"
        end
    end


    text = text .. "</span>" -- close fontspan

    if (c.class == "Geany") then
    return text, bg, nil, geany
    end

    if (name == "mcabber") then
    return text, bg, nil, mcabber
    end

    if (name == "ncmpcpp") then
    return text, bg, nil, ncmpcpp
    end

    if (name == "weechat 0.3.7") then
    return text, bg, nil, weechat
    end

    return text, bg, nil, c.icon
end

--- Return labels for a tasklist widget with clients from all tags and screen.
-- It returns the client name and set a special
-- foreground and background color for focused client.
-- It also puts a special icon for floating windows.
-- @param c The client.
-- @param screen The screen we are drawing on.
-- @param args The arguments table.
-- bg_focus The background color for focused client.
-- fg_focus The foreground color for focused client.
-- bg_urgent The background color for urgent clients.
-- fg_urgent The foreground color for urgent clients.
-- @return A string to print, a background color and a status image.
function label.allscreen(c, screen, args)
    return widget_tasklist_label_common(c, args)
end

--- Return labels for a tasklist widget with clients from all tags.
-- It returns the client name and set a special
-- foreground and background color for focused client.
-- It also puts a special icon for floating windows.
-- @param c The client.
-- @param screen The screen we are drawing on.
-- @param args The arguments table.
-- bg_focus The background color for focused client.
-- fg_focus The foreground color for focused client.
-- bg_urgent The background color for urgent clients.
-- fg_urgent The foreground color for urgent clients.
-- @return A string to print, a background color and a status image.
function label.alltags(c, screen, args)
    -- Only print client on the same screen as this widget
    if c.screen ~= screen then return end
    return widget_tasklist_label_common(c, args)
end

--- Return labels for a tasklist widget with clients from currently selected tags.
-- It returns the client name and set a special
-- foreground and background color for focused client.
-- It also puts a special icon for floating windows.
-- @param c The client.
-- @param screen The screen we are drawing on.
-- @param args The arguments table.
-- bg_focus The background color for focused client.
-- fg_focus The foreground color for focused client.
-- bg_urgent The background color for urgent clients.
-- fg_urgent The foreground color for urgent clients.
-- @return A string to print, a background color and a status image.
function label.currenttags(c, screen, args)
    -- Only print client on the same screen as this widget
    if c.screen ~= screen then return end
    -- Include sticky client too
    if c.sticky then return widget_tasklist_label_common(c, args) end
    for k, t in ipairs(capi.screen[screen]:tags()) do
        if t.selected then
            local ctags = c:tags()
            for _, v in ipairs(ctags) do
                if v == t then
                    return widget_tasklist_label_common(c, args)
                end
            end
        end
    end
end

--- Return label for only the currently focused client.
-- It returns the client name and set a special
-- foreground and background color for focused client.
-- It also puts a special icon for floating windows.
-- @param c The client.
-- @param screen The screen we are drawing on.
-- @param args The arguments table.
-- bg_focus The background color for focused client.
-- fg_focus The foreground color for focused client.
-- bg_urgent The background color for urgent clients.
-- fg_urgent The foreground color for urgent clients.
-- @return A string to print, a background color and a status image.
function label.focused(c, screen, args)
    -- Only print client on the same screen as this widget
    if c.screen == screen and capi.client.focus == c then
        return widget_tasklist_label_common(c, args)
    end
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
