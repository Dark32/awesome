
-- Grab environment
local ipairs = ipairs
local type = type
local table = table
local math = math
local util = require("awful.util")
local default = require("awful.widget.layout.default")
local margins = awful.widget.layout.margins

local print = print
local assert = assert

--- Horizontal widget layout
module("horizontal")

function center(bounds, widgets, screen)
    local keys = util.table.keys_filter(widgets, "table", "widget")

    local total_width = bounds.width
    local element_l, element_c, element_r
    local offset_l, offset_r

    local geometries = { }
    local geometry_c

    offset_l = total_width/2
    offset_r = offset_l

    -- Don't accept more than three top-level widgets
    assert(#keys <= 3)

    if #keys == 1 then
        element_c = widgets[ keys[1] ]
    elseif #keys == 2 then
        element_l = widgets[ keys[1] ]
        element_c = widgets[ keys[2] ]
    elseif #keys == 3 then
        element_l = widgets[ keys[1] ]
        element_c = widgets[ keys[2] ]
        element_r = widgets[ keys[3] ]
    end

    if type(element_c) == "widget" then
        if element_c.visible then
            geometry_c = element_c:extents(screen)

            offset_l = offset_l-geometry_c.width/2
            offset_r = offset_r+geometry_c.width/2

            geometry_c.height = bounds.height
            geometry_c.x = offset_l
            geometry_c.y = 0
        else
            geometry_c = {
                width = 0,
                height = 0
            }
        end

    elseif type(element_c) == "table" then
        geometry_c = element_c.layout(bounds, element_c, screen)

        offset_l = geometry_c.free.width/2
        offset_r = total_width-offset_l

        for _, v in ipairs(geometry_c) do
          v.x = offset_l + v.x
        end
    end

    if type(element_l) == "widget" then
        geometry_l = { }

        if element_l.visible then
            geometry_l = {
                x = 0,
                y = 0,
                width = offset_l,
                height = bounds.height
            }
        else
            geometry_l = {
                width = 0,
                height = 0,
            }
        end

        table.insert(geometries, geometry_l)
    elseif type(element_l) == "table" then
        bounds_l = {
            x = 0,
            y = 0,
            width = offset_l,
            height = bounds.height
        }

        geometries_l = element_l.layout(bounds_l, element_l, screen)

        for _, v in ipairs(geometries_l) do
          table.insert(geometries, v)
        end
    end

    if type(element_c) == "widget" then
        table.insert(geometries, geometry_c)
    elseif type(element_c) == "table" then
        for _, v in ipairs(geometry_c) do
          table.insert(geometries, v)
        end
    end

   if type(element_r) == "widget" then
        geometry_r = { }

        if element_r.visible then
            geometry_r = {
                x = offset_r,
                y = 0,
                width = total_width-offset_r,
                height = bounds.height
            }
        else
            geometry_r = {
                width = 0,
                height = 0
            }
        end

        table.insert(geometries, geometry_r)

    elseif type(element_r) == "table" then
        bounds_r = {
            x = offset_r,
            y = 0,
            width = total_width-offset_r,
            height = bounds.height
        }

        geometries_r = element_r.layout(bounds_r, element_r, screen)

        for _, v in ipairs(geometries_r) do
          v.x = v.x + offset_r
          table.insert(geometries, v)
        end
    end

    return geometries
end

local function horizontal(direction, bounds, widgets, screen)
    local geometries = { }
    local x = 0

    -- we are only interested in tables and widgets
    local keys = util.table.keys_filter(widgets, "table", "widget")

    for _, k in ipairs(keys) do
        local v = widgets[k]
        if type(v) == "table" then
            local layout = v.layout or default
            if margins[v] then
                bounds.width = bounds.width - (margins[v].left or 0) - (margins[v].right or 0)
                bounds.height = bounds.height - (margins[v].top or 0) - (margins[v].bottom or 0)
            end
            local g = layout(bounds, v, screen)
            if margins[v] then
                x = x + (margins[v].left or 0)
            end
            for _, v in ipairs(g) do
                v.x = v.x + x
                v.y = v.y + (margins[v] and (margins[v].top and margins[v].top or 0) or 0)
                table.insert(geometries, v)
            end
            bounds = g.free
            if margins[v] then
                x = x + g.free.x + (margins[v].right or 0)
                bounds.width = bounds.width - (margins[v].right or 0) - (margins[v].left or 0)
            else
                x = x + g.free.x
            end
        elseif type(v) == "widget" then
            local g
            if v.visible then
                g = v:extents(screen)
                if margins[v] then
                    g.width = g.width + (margins[v].left or 0) + (margins[v].right or 0)
                    g.height = g.height + (margins[v].top or 0) + (margins[v].bottom or 0)
                end
            else
                g = {
                    width  = 0,
                    height = 0,
                }
            end

            if v.resize and g.width > 0 and g.height > 0 then
                local ratio = g.width / g.height
                g.width = math.floor(bounds.height * ratio)
                g.height = bounds.height
            end

            if g.width > bounds.width then
                g.width = bounds.width
            end
            g.height = bounds.height

            if margins[v] then
                g.y = (margins[v].top or 0)
            else
                g.y = 0
            end

            if direction == "leftright" then
                if margins[v] then
                    g.x = x + (margins[v].left or 0)
                else
                    g.x = x
                end
                x = x + g.width
            else
                if margins[v] then
                    g.x = x + bounds.width - g.width + (margins[v].left or 0)
                else
                    g.x = x + bounds.width - g.width
                end
            end
            bounds.width = bounds.width - g.width

            table.insert(geometries, g)
        end
    end

    geometries.free = util.table.clone(bounds)
    geometries.free.x = x
    geometries.free.y = 0

    return geometries
end

function flex(bounds, widgets, screen)
    local geometries = {
        free = util.table.clone(bounds)
    }
    -- the flex layout always uses the complete available place, thus we return
    -- no usable free area
    geometries.free.width = 0

    -- we are only interested in tables and widgets
    local keys = util.table.keys_filter(widgets, "table", "widget")
    local nelements = 0

    for _, k in ipairs(keys) do
        local v = widgets[k]
        if type(v) == "table" then
            nelements = nelements + 1
        elseif type(v) == "widget" then
            local g = v:extents()
            if v.resize and g.width > 0 and g.height > 0 then
                bounds.width = bounds.width - bounds.height
            elseif g.width > 0 and g.height > 0 then
                nelements = nelements + 1
            end
        end
    end

    nelements = (nelements == 0) and 1 or nelements

    local x = 0
    local width = bounds.width / nelements

    for _, k in ipairs(util.table.keys(widgets)) do
        local v = widgets[k]
        if type(v) == "table" then
            local layout = v.layout or default
            local g = layout(bounds, v, screen)
            for _, v in ipairs(g) do
                v.x = v.x + x
                table.insert(geometries, v)
            end
            bounds = g.free
        elseif type(v) == "widget" then
            local g = v:extents(screen)
            g.resize = v.resize

            if v.resize and g.width > 0 and g.height > 0 then
                g.width = bounds.height
                g.height = bounds.height
                g.x = x
                g.y = bounds.y
                x = x + g.width
            elseif g.width > 0 and g.height > 0 then
                g.x = x
                g.y = bounds.y
                g.width = math.floor(width + 0.5)
                g.height = bounds.height
                x = x + width
            else
                g.x = 0
                g.y = 0
                g.width = 0
                g.height = 0
            end

            table.insert(geometries, g)
        end
    end

    return geometries
end

function leftright(...)
    return horizontal("leftright", ...)
end

function rightleft(...)
    return horizontal("rightleft", ...)
end

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:encoding=utf-8:textwidth=80
