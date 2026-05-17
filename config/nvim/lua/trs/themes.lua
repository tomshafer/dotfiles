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
    if not pcall(vim.cmd.colorscheme, "rose-pine-dawn") then
        vim.cmd.colorscheme "default"
    end
else
    vim.o.background = "dark"
    if not pcall(vim.cmd.colorscheme, "tokyonight") then
        vim.cmd.colorscheme "habamax"
    end
end
