require("config.lazy")

-- hightlight on yank
vim.cmd([[au TextYankPost * lua vim.highlight.on_yank {higroup="IncSearch", timeout=250, on_visual=true}]])
