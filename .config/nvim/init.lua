-- FIXME:
-- - "neovim lsp completion preview open_floating_preview"
-- - move diagnostic to line number column ('statuscolumn'?)
--   https://github.com/luukvbaal/statuscol.nvim
--   https://neovim.io/doc/user/diagnostic.html
-- - lua: comments are highlighted even when `:syntax off`
-- - ERROR Found paths on the rtp from another plugin manager `paq`
--
-- TODO:
-- - https://neovim.io/doc/user/lua-guide.html#lua-guide
-- - https://github.com/sadiksaifi/nvim/tree/main/lua/plugins
-- - https://github.com/catgoose/nvim-colorizer.lua
-- - https://neovim.io/doc/user/lua.html
--
-- - https://github.com/nvim-neorocks/rocks.nvim
--
-- folding: zr: reduce folding ; zM: fold all ; zR: unfold all
--          zO: open all fold under cursor

--[ plugins: manager & configuration ]--

--- lazy ; https://lazy.folke.io/installation
require('config.lazy')

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep,  { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers,    { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags,  { desc = 'Telescope help tags' })

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    -- TODO: remove `{buffer = true}`?
    vim.keymap.set('n', 'gd',          vim.lsp.buf.definition,       {buffer = true})
    vim.keymap.set('n', 'gD',          vim.lsp.buf.declaration,      {buffer = true})
    vim.keymap.set('n', 'gs',          vim.lsp.buf.document_symbol,  {buffer = true})
    vim.keymap.set('n', 'gS',          vim.lsp.buf.workspace_symbol, {buffer = true})
    vim.keymap.set('n', 'gr',          vim.lsp.buf.references,       {buffer = true})
    vim.keymap.set('n', 'gi',          vim.lsp.buf.implementation,   {buffer = true})
    vim.keymap.set('n', 'gt',          vim.lsp.buf.type_definition,  {buffer = true})
    vim.keymap.set('n', 'K',           vim.lsp.buf.hover,            {buffer = true})
    vim.keymap.set('n', '<leader>ca',  vim.lsp.buf.code_action,      {buffer = true})
    vim.keymap.set('n', '<leader>rn',  vim.lsp.buf.rename,           {buffer = true})

    vim.keymap.set('n', '[d', function() vim.diagnostic.jump({float = true, count = -1}); end, {buffer = true})
    vim.keymap.set('n', ']d', function() vim.diagnostic.jump({float = true, count =  1}); end, {buffer = true})

    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method('textDocument/formatting') then
      vim.keymap.set('n', '<F12>', function()
        vim.lsp.buf.format({bufnr = args.buf, id = client.id, async = false})
        --print('formatting completed')
      end, {buffer = true})
    end
  end,
})

--[ main ]--

vim.cmd.syntax('on')
vim.cmd.colorscheme('paq-minimal')

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
vim.o.laststatus = 2  -- tells when the last window also has a status line
vim.o.scrolloff = 1   -- n lines to the cursor when moving vertically

vim.o.sessionoptions = 'blank,buffers,folds,help,options,sesdir,tabpages,winpos,winsize'

--[ other ]--

-- folding
--vim.o.foldenable = false
--vim.o.foldmethod = 'indent'
--vim.o.foldlevel = 999

vim.o.backspace = 'indent,eol,start' -- fix for nixos

--[ mappings ]--

vim.keymap.set({'n', 'v'}, '<leader>]', '"+y', {noremap = true}) -- '\]' : copy to X clipboard (was `"+y`)
vim.keymap.set({'n', 'v'}, '<leader>[', '"+p', {noremap = true}) -- '\[' : paste from X clipboard (was `"+p`)

-- keep visual mode after indention:
vim.keymap.set('v', '<', '<gv', {noremap = true})
vim.keymap.set('v', '>', '>gv', {noremap = true})

vim.keymap.set('n', '<F4>', [[:%s/\s\+$//e<CR>]], {noremap = true}) -- remove trailing spaces
vim.keymap.set('n', '<F5>', ':set list!<CR>', {noremap = true}) -- toggle hidden characters

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
end, {noremap = true, expr = true, silent = true})

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
vim.api.nvim_create_autocmd({'FileType'}, { pattern = "yaml", command = "setl indentexpr=" })

-- prevent vim from reading boost include files:
--~ vim.o.include = '^\\s*#\\s*include\ \\(<boost/\\)\\@!'
