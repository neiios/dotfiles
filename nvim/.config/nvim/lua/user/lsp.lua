local status, cmp = pcall(require, 'cmp')
if not status then
  return
end

local status, null_ls = pcall(require, 'null-ls')
if not status then
  return
end

local status, lspconfig = pcall(require, 'lspconfig')
if not status then
  return
end

-- make lsp work with nvim-cmp
cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
  },
})
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- only use null-ls for formatting
local lsp_formatting = function(bufnr)
  vim.lsp.buf.format({
    bufnr = bufnr,
  })
end

-- if you want to set up formatting on save, you can use this as a callback
local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

-- add to your shared on_attach callback
local on_attach = function(client, bufnr)
  -- disable formatting in tsserver
  if client.name == 'tsserver' then
    client.server_capabilities.documentFormattingProvider = false
  end
  -- default opts
  local bufopts = { noremap = true, silent = true, buffer = bufnr }

  -- lsp keymaps
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<leader>dn', vim.diagnostic.goto_next, bufopts)
  vim.keymap.set('n', '<leader>dp', vim.diagnostic.goto_prev, bufopts)
  vim.keymap.set('n', '<leader>dl', ':Telescope diagnostics<CR>', bufopts)
  vim.keymap.set('n', '<leader>rf', lsp_formatting, bufopts)
  vim.keymap.set('n', '<leader>rr', vim.lsp.buf.rename, bufopts)

  -- format on save
  if client.supports_method('textDocument/formatting') then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd('BufWritePre', {
      group = augroup,
      buffer = bufnr,
      callback = function()
        lsp_formatting(bufnr)
      end,
    })
  end
end

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.diagnostics.cppcheck,
  },
  -- run formatter on file save
  on_attach = on_attach,
})

lspconfig.eslint.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.clangd.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.html.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.cssls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.sumneko_lua.setup({
  settings = {
    Lua = {
      format = { enable = false },
      diagnostics = {
        globals = { 'vim' },
      },
      telemetry = {
        enable = false,
      },
    },
  },
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.tsserver.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

lspconfig.bashls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
})

-- ansiblels filetype detection
-- vim.cmd('autocmd BufRead,BufNewFile *.yaml,*.yml if search('hosts:', 'nw') | set ft=yaml.ansible | endif')
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.yaml,*.yml' },
  callback = function()
    vim.cmd("if search('hosts:|- name:', 'nw') | set ft=yaml.ansible | endif")
  end,
})

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.yml.j2,*.yaml.j2' },
  callback = function()
    vim.cmd('set ft=yaml')
  end,
})

lspconfig.ansiblels.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {
    'yaml.ansible',
    'yaml',
  },
  settings = {
    ansible = {
      ansible = {
        path = 'ansible',
        useFullyQualifiedCollectionNames = true,
      },
      ansibleLint = {
        enabled = true,
        path = 'ansible-lint',
      },
      executionEnvironment = {
        enabled = false,
      },
      python = {
        interpreterPath = 'python',
      },
      completion = {
        provideRedirectModules = true,
        provideModuleOptionAliases = true,
      },
    },
  },
})
