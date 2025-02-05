return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = {
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "javascript", "html", "php", "python", "typescript", "tsx", "json" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
    },
}
