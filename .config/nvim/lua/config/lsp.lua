-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md

-- default-configured servers:
vim.lsp.enable('clangd')
vim.lsp.enable('neocmake')
vim.lsp.enable('gopls')
vim.lsp.enable('bashls')


-- Rust
local rustfmt_cfg_opts = -- TODO: switch to stable features ASAP and remove this
    'unstable_features=true'
    --.. ',struct_field_align_threshold=30'
    .. ',imports_granularity=Module'
    .. ',normalize_doc_attributes=true'
    .. ',comment_width=100' -- TODO: depends on project; maybe delete at all
--
-- FIXME!!!
--
if vim.fs.basename(vim.fn.getcwd()) ~= 'rocd' then
  rustfmt_cfg_opts = rustfmt_cfg_opts .. ',struct_field_align_threshold=30'
end
vim.lsp.config('rust_analyzer', {
  settings = {
    ['rust-analyzer'] = {
      rustfmt = { overrideCommand = { 'rustfmt', '--config', rustfmt_cfg_opts } },
    },
  }
})
vim.lsp.enable('rust_analyzer')


-- Lua
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {},
  },
  on_init = function(cl)
    if cl.workspace_folders then
      local path = cl.workspace_folders[1].name
      if path ~= vim.fn.stdpath('config')
          and (vim.uv.fs_stat(path .. '/.luarc.json')
            or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
        return
      end
    end
    cl.config.settings.Lua = vim.tbl_deep_extend('force', cl.config.settings.Lua, {
      runtime = {
        -- tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- tell the language server how to find Lua modules same way as Neovim (see `:h lua-module-load`)
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- depending on the usage, you might want to add additional paths here.
          '${3rd}/luv/library',
          -- '${3rd}/busted/library',
        }
        -- or pull in all of 'runtimepath'.
        -- NOTE: this is a lot slower and will cause issues when working on your own configuration
        -- (see https://github.com/neovim/nvim-lspconfig/issues/3189)
        -- library = vim.api.nvim_get_runtime_file('', true)
      },
    })
  end,
})
vim.lsp.enable('lua_ls')


-- Python
vim.lsp.config('pylsp', {
  --cmd = { "pylsp", "-vvv", "--log-file", "/tmp/lsp.log" },
  settings = {
    pylsp = {
      plugins = {
        -- TODO: just remove lines with automatically enabled plugins maybe?
        pylsp_mypy = { enabled = true }, -- needs https://github.com/python-lsp/pylsp-mypy
        ruff = {                         -- needs https://github.com/python-lsp/python-lsp-ruff
          -- basic settings; use ruff.toml for a project; SA https://github.com/astral-sh/ruff
          enabled = true,
          formatEnabled = true,
          format = { "I" },
          lineLength = 120,
          unsafeFixes = false,
        },
        --
        black = { enabled = false },
        flake8 = { enabled = false },
        autopep8 = { enabled = false },
        mccabe = { enabled = false },
        preload = { enabled = false },
        pycodestyle = { enabled = false },
        pydocstyle = { enabled = false },
        pyflakes = { enabled = false },
        pylint = { enabled = false },
        yapf = { enabled = false },
        -- leave enabled by default if tools available:
        --jedi_completion = { enabled = false },
        --jedi_hover = { enabled = false },
        --jedi_references = { enabled = false },
        --jedi_signature_help = { enabled = false },
        --jedi_symbols = { enabled = false },
        --jedi_type_definition = { enabled = false },
        --rope_autoimport = { enabled = false },
        --rope_completion = { enabled = false },
      },
    }
  }
})
vim.lsp.enable('pylsp')


-- Nix (NixOS)
-- TODO: verify!!!
-- TODO: https://github.com/oxalica/nil/blob/main/dev/nvim-lsp.nix
vim.lsp.config('nil_ls', {
  settings = {
    ['nil'] = {
      formatting = {
        command = { "nixfmt" }
      },
    }
  }
})
vim.lsp.enable('nil_ls')


-- TODO:
-- cfg.nixd.setup {}
-- LaTeX: digestif, ltex_ls_plus, texlab
-- Dart: dartls
-- JS: eslint
-- ProtoBuf: pbls || protols
-- Perl: perlls || perlnavigator
-- Python: facebook/pyre-check (not available on nixos)
-- Nix: statix
-- Vimscript: https://github.com/iamcco/vim-language-server
-- different langs and features: dprint
