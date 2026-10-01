-- ~/.config/nvim/init.lua (C++ ONLY)

vim.g.mapleader = " "
local o = vim.o
o.number = true
o.relativenumber = true
o.mouse = "a"
o.termguicolors = true
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.clipboard = "unnamedplus"
o.completeopt = "menu,menuone,noselect,popup"

-- =================================================================
-- 1. C++ SPECIFIC SYNTAX COLORS
-- =================================================================
local langs = {
  cpp = { 
    keyword = "#ff8c5a", 
    type    = "#4fd6be", 
    func    = "#7aa2f7", 
    ns      = "#c099ff", 
    macro   = "#f7768e", 
    string  = "#c3e88d", 
    field   = "#b4f9f8" 
  },
}

local groups = {
  keyword = { "@keyword", "@keyword.function", "@keyword.return", "@keyword.conditional", "@keyword.repeat", "@keyword.type", "@keyword.modifier" },
  type    = { "@type", "@type.builtin", "@lsp.type.class", "@lsp.type.struct", "@lsp.type.enum" },
  func    = { "@function", "@function.call", "@function.method", "@function.method.call", "@lsp.type.function", "@lsp.type.method" },
  ns      = { "@module", "@lsp.type.namespace" },
  macro   = { "@keyword.directive", "@keyword.import", "@function.macro", "@lsp.type.macro" },
  string  = { "@string" },
  field   = { "@variable.member", "@property", "@lsp.type.property" },
}

local function apply_colors()
  for lang, pal in pairs(langs) do
    for role, list in pairs(groups) do
      for _, g in ipairs(list) do
        vim.api.nvim_set_hl(0, g .. "." .. lang, { fg = pal[role] })
      end
    end
  end
end
vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_colors })

-- =================================================================
-- 2. PLUGIN MANAGER SETUP (lazy.nvim)
-- =================================================================
local p = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(p) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", "https://github.com/folke/lazy.nvim.git", p })
end
vim.opt.rtp:prepend(p)

-- =================================================================
-- 3. PLUGINS
-- =================================================================
require("lazy").setup({
  -- Tokyonight Theme
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },

  -- C / C++ Treesitter Highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c", "cpp" },
        highlight = { enable = true },
      })
    end,
  },

  -- Lualine Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
      })
    end,
  },

  -- C++ Language Server (clangd)
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.config("clangd", {
        cmd = {
          "clangd",
          "--background-index",
          "--completion-style=detailed",
          "--function-arg-placeholders=1",
        },
      })
      if vim.fn.executable("clangd") == 1 then
        vim.lsp.enable("clangd")
      end
    end,
  },
}) -- Correctly closed lazy.setup table

apply_colors()

-- =================================================================
-- 4. AUTO-COMPLETION & KEYBINDS
-- =================================================================
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(a)
    local client = vim.lsp.get_client_by_id(a.data.client_id)
    if client and client.server_capabilities.completionProvider then
      -- Trigger autocompletion on every typed character
      local chars = {}
      for i = 32, 126 do chars[#chars + 1] = string.char(i) end
      client.server_capabilities.completionProvider.triggerCharacters = chars
    end

    vim.lsp.completion.enable(true, a.data.client_id, a.buf, { autotrigger = true })
    
    local function map(lhs, rhs) vim.keymap.set("n", lhs, rhs, { buffer = a.buf }) end
    map("gd", vim.lsp.buf.definition)
    map("<leader>rn", vim.lsp.buf.rename)
    map("K", vim.lsp.buf.hover) -- Press K over a function/symbol to see documentation box
    map("<C-LeftMouse>", "<LeftMouse><cmd>lua vim.lsp.buf.hover()<cr>")
  end,
})

-- Autocomplete dropdown navigation
vim.keymap.set("i", "<C-Space>", function() vim.lsp.completion.get() end)
vim.keymap.set("i", "<Tab>", function() return vim.fn.pumvisible() == 1 and "<C-n>" or "<Tab>" end, { expr = true })
vim.keymap.set("i", "<S-Tab>", function() return vim.fn.pumvisible() == 1 and "<C-p>" or "<S-Tab>" end, { expr = true })
vim.keymap.set("i", "<CR>", function() return vim.fn.pumvisible() == 1 and "<C-y>" or "<CR>" end, { expr = true })
