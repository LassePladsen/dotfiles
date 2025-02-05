return {
    {
        'vscode-neovim/vscode-multi-cursor.nvim',
        dependencies = {
            { 'folke/flash.nvim', event = "VeryLazy", opts = {} },
        },
        event = 'VeryLazy',
        cond = not not vim.g.vscode,
        opts = {},
    }
}
