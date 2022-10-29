local status, vscode = pcall(require, 'vscode')
if not status then
  return
end

vim.o.background = 'dark'
vscode.setup({})
