vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        require("lazy").sync({ show = false })
    end,
})
require("config.lazy")
