-- Only load lazy and plugins if not in vscode
if not vim.g.vscode then
    require("config.lazy")
end

-- hightlight on yank
vim.cmd([[au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=250, on_visual=true}]])

-- listchars not supported in regular vim
-- vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.g.have_nerd_font = true
