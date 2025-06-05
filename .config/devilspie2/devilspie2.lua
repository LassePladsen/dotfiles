-- on window open
debug_print("Application: " .. get_application_name())
debug_print("Window: " .. get_window_name());

local window_name = get_window_name()
if (string.match(window_name, "Obsidian") 
    or string.match(window_name, "Discord") 
    or string.match(window_name, "Spotify")) then
    pin_window() -- show on all workspaces
end


