-- FIXME:
-- - "neovim lsp completion preview open_floating_preview"
-- - move diagnostic to line number column ('statuscolumn'?)
--   https://github.com/luukvbaal/statuscol.nvim
--   https://neovim.io/doc/user/diagnostic.html
-- - lua: comments are highlighted even when `:syntax off`
--
-- TODO:
-- - https://github.com/sadiksaifi/nvim/tree/main/lua/plugins
-- - https://github.com/catgoose/nvim-colorizer.lua
--
-- - https://github.com/nvim-neorocks/rocks.nvim
--
-- folding: zr: reduce folding ; zM: fold all ; zR: unfold all
--          zO: open all fold under cursor

vim.cmd.syntax('on')
vim.cmd.colorscheme('paq-minimal')

--[ plugins: manager & configuration ]--

--- lazy ; https://lazy.folke.io/installation
require('config.lazy')

-- nvim-tree.lua
vim.cmd([[ :hi NvimTreeExecFile guifg=#ff77ff ]])
vim.cmd([[ :hi NvimTreeImageFile guifg=#aa44aa ]])
-- disable netrw at the very start of your init.lua:
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- fzf-lua
local fzf_handle = require('fzf-lua')
vim.keymap.set('n', '<leader>ff', fzf_handle.files, {})
vim.keymap.set('n', '<leader>fg', fzf_handle.live_grep_native, {})
vim.keymap.set('n', '<leader>fb', fzf_handle.buffers, {})
vim.keymap.set('n', '<leader>fh', fzf_handle.helptags, {})

--[ LSP ]--
vim.diagnostic.config({
  jump = { float = true },
  float = { focusable = true, border = 'rounded' },
})
-- see https://neovim.io/doc/user/lsp.html#lsp-defaults ;
-- see https://github.com/neovim/neovim/blob/master/runtime/lua/vim/_core/defaults.lua#L203 :
-- > These GLOBAL keymaps are created unconditionally when Nvim starts:
-- > "an" and "in" (Visual and Operator-pending mode) are mapped to outer and inner incremental selections, respectively, using vim.lsp.buf.selection_range()
-- > vim.keymap.set({'n', 'x'},   'gra',   function() vim.lsp.buf.code_action() end, ...)
-- > vim.keymap.set('n',          'grn',   function() vim.lsp.buf.rename() end, ...)
-- > vim.keymap.set('n',          'grr',   function() vim.lsp.buf.references() end, ...)
-- > vim.keymap.set('n',          'gri',   function() vim.lsp.buf.implementation() end, ...)
-- > vim.keymap.set('n',          'grt',   function() vim.lsp.buf.type_definition() end, ...)
-- > vim.keymap.set({'x', 'o'},   'an',    function() vim.lsp.buf.selection_range(vim.v.count1) end, ...)
-- > vim.keymap.set({'x', 'o'},   'in',    function() vim.lsp.buf.selection_range(-vim.v.count1) end, ...)
-- > vim.keymap.set('n',          'gO',    function() vim.lsp.buf.document_symbol() end, ...)
-- > vim.keymap.set({ 'i', 's' }, '<C-S>', function() vim.lsp.buf.signature_help() end, ...)
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    vim.keymap.set('n', 'grd', vim.lsp.buf.declaration, { buffer = args.buf })
    vim.keymap.set('n', 'grs', vim.lsp.buf.document_symbol, { buffer = args.buf })    -- == 'gO'
    vim.keymap.set('n', 'grS', vim.lsp.buf.workspace_symbol, { buffer = args.buf })
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = args.buf }) -- == 'gra'
    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover({ border = 'rounded' }) end, { buffer = args.buf })
    --~vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = args.buf })
    --~vim.keymap.set('n', '<leader>rn',  vim.lsp.buf.rename, { buffer = args.buf })

    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method('textDocument/formatting') then
      vim.keymap.set('n', '<F12>', function()
        vim.lsp.buf.format({ bufnr = args.buf, id = client.id, async = false })
        --print('formatting completed')
      end, { buffer = args.buf })
    end
  end,
})

require('config.lsp') -- load LSP configs from config/lsp.lua

--[ main ]--

vim.o.history = 500
vim.o.shiftwidth = 2    -- the number of space characters inserted for indentation
vim.o.tabstop = 2       -- number of spaces that a <Tab> in the file counts for
vim.o.expandtab = true  -- to insert space characters whenever the tab key is pressed
vim.o.smarttab = true   -- delete tab, not a single space when pressing backspace
vim.o.autoindent = true -- use the indent from the previous line
vim.o.cindent = false
vim.o.indentexpr = ''
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.ignorecase = false
vim.o.number = true
vim.o.numberwidth = 3
vim.o.inccommand = ''
--~vim.o.mouse = ''

vim.o.statusline = '%F%m%r%h%w  hex=%2B  pos=%02p%%  line=%03l/%03L  col=%v'
    .. '  V=%{abs(line(".") - line("v")) + 1}'
vim.o.laststatus = 2 -- tells when the last window also has a status line
vim.o.scrolloff = 3  -- n lines to the cursor when moving vertically

vim.o.sessionoptions = 'blank,buffers,folds,help,options,sesdir,tabpages,winpos,winsize'

--[ other ]--

-- folding
--vim.o.foldenable = false
--vim.o.foldmethod = 'indent'
--vim.o.foldlevel = 999

vim.o.backspace = 'indent,eol,start' -- fix for nixos

--[ mappings ]--

vim.keymap.set({ 'n', 'v' }, '<leader>]', '"+y', { noremap = true }) -- '\]' : copy to X clipboard (was `"+y`)
vim.keymap.set({ 'n', 'v' }, '<leader>[', '"+p', { noremap = true }) -- '\[' : paste from X clipboard (was `"+p`)

-- keep visual mode after indention:
vim.keymap.set('v', '<', '<gv', { noremap = true })
vim.keymap.set('v', '>', '>gv', { noremap = true })

vim.keymap.set('n', '<F4>', [[:%s/\s\+$//e<CR>]], { noremap = true }) -- remove trailing spaces
vim.keymap.set('n', '<F5>', [[:set list!<CR>]], { noremap = true })   -- toggle hidden characters

vim.keymap.set('n', 'cp', [[:let @+ = expand('%')<CR>]], { noremap = true }) -- copy buffer path to clipboard

-- TODO: go to definition (if only one), or show a list of possible definitions (if many):
--~nnoremap <C-]> g<C-]>

--[ language-specific settings ]--

vim.g.omni_sql_no_default_maps = 1 -- disable sql omni completion; see `:h 'ft-sql'`

--~vim.cmd([[ au FileType * setl fo-=ro ]]) -- disable auto-commention (on Enter and 'o')

vim.opt.completeopt:remove { 'preview' } -- disable until fixing preview window (see FIXME in header)
--~vim.cmd([[ au! CompleteDone * if pumvisible() == 0 | pclose | endif ]]) -- auto close preview window (LSP; completion)

-- make <C-o> work like <C-n> in completion mode (move down in suggestions list):
vim.keymap.set('i', '<C-o>', function()
  return vim.fn.pumvisible() == 1 and "<C-n>" or "<C-o>"
end, { noremap = true, expr = true, silent = true })

-- file types:
vim.cmd([[ au BufRead,BufNewFile *.vala,*.vapi         setl ft=vala ]])
vim.cmd([[ au BufRead,BufNewFile SConstruct,SConscript setl ft=python ]])
vim.cmd([[ au BufRead,BufNewFile *.1c                  setl ft=bsl ]])

vim.cmd([[ au FileType asciidoc,markdown setl textwidth=0 ]])
vim.cmd([[ au FileType c,cpp,python  setl shiftwidth=4 tabstop=4 ]]) -- cc=101
vim.cmd([[ au FileType d             setl noexpandtab shiftwidth=2 tabstop=2 ]])
vim.cmd([[ au FileType go            setl noexpandtab shiftwidth=4 tabstop=4 nowrap ]])
vim.cmd([[ au FileType make          setl noexpandtab shiftwidth=8 tabstop=8 ]])
vim.cmd([[ au FileType markdown      setl shiftwidth=2 tabstop=2 formatoptions-=l ]])
vim.cmd([[ au FileType c,cpp,go,python,rust,d,java, setl foldmethod=indent foldlevel=30 ]])
-- TODO: temporary fix (indentexpr get redefined)
vim.api.nvim_create_autocmd({ 'FileType' }, { pattern = "yaml", command = "setl indentexpr=" })
