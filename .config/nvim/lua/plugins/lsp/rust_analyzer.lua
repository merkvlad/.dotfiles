local Util = require("lazyvim.util")
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "williamboman/mason-lspconfig.nvim" },
    --- Здесь идёт расширение опций, не трогая оригинал ---
    opts = {
      servers = {
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              procMacro = {
                enable = true,
                ignored = {}, -- теперь async_trait и другие будут разворачиваться
              },
            },
          },
        },
      },
    },
  },
}
