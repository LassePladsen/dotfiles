-- on window open
debug_print("Application: " .. get_application_name())
debug_print("Window: " .. get_window_name());

local window_name = get_window_name()
if (string.match(window_name, "Spotify")) then
    pin_window() -- show on all workspaces
end

if (string.match(window_name, "Discord")) then 
    set_viewport(1) -- left monitor
    pin_window()
    set_window_geometry(0,0,1280,1440) -- pin to left side of monitor
end

if (string.match(window_name, "Obsidian")) then
    set_viewport(1) -- left monitor
    pin_window()
    set_window_geometry(1280,0,1280,720) -- pin to right side of monitor
end

if (window_name == "Mozilla Thunderbird") then
    set_viewport(2) -- move to right monitor
    maximize()
    pin_window() -- show on all workspaces
end



