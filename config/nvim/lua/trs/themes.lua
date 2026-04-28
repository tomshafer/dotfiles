-- Default to a dark theme, but if we detect a light one then use it
local function is_light_mode()
    local cfgbg = os.getenv "COLORFGBG"
    if not cfgbg then
        return false
    end
    local parts = {}
    for p in string.gmatch(cfgbg, "([^;]+)") do
        table.insert(parts, tonumber(p))
    end
    if #parts == 2 then
        return parts[2] >= 7
    end
    return false
end

if is_light_mode() then
    vim.o.background = "light"
    vim.cmd.colorscheme "rose-pine-dawn"
else
    vim.o.background = "dark"
    vim.cmd.colorscheme "tokyonight"
end
