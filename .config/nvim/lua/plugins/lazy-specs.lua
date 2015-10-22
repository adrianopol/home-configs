return {
  { 'jlanzarotta/bufexplorer', version = '*' },
  { 'neovim/nvim-lspconfig',   version = '*' },

  --{ 'preservim/nerdtree',      version = '*' },
  { -- `g?` -- show help
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    config = function()
      require('nvim-tree').setup {
        view = {
          width = 35,
        },
        filters = {
          git_ignored = false,
          dotfiles = false,
        },
        git = { enable = false },
        renderer = { icons = { glyphs = {
          default = '', symlink = '', bookmark = '', modified = '', hidden = '',
          folder = {
            arrow_closed = '▸', arrow_open = '▾',
            default = '', open = '', empty = '', empty_open = '', symlink = '', symlink_open = '',
          } } }
        },
      }
    end
  },

  {
    'ibhagwan/fzf-lua',
    version = '*',
    config = function()
      local actions = require("fzf-lua").actions
      require('fzf-lua').setup({
        winopts = {
          height = 0.90,
          width = 0.90,
          preview = {
            flip_columns = 140,
          },
        },
        files = {
          cmd = 'fd --type f --color never -H -L --no-ignore-vcs --full-path'
              .. ' -E .git/'
              .. ' -E "*.{gz,tgz,xz,txz,bz2,tbz2,zst,tzst,tar,ico,iso,png,jpg,jpeg}"'
              .. ' -E .cache/'
              .. ' -E "*.min.{js,css}"'
              .. ' -E /target/debug/'                  -- rust
              .. ' -E .venv/ -E ".{mypy,ruff}_cache/"' -- python
              .. ' -E /site/assets/'                   -- mkdocs
              .. ' -E "/site/**/*.html"',              -- mkdocs
        },
        grep = {
          multiprocess = true, -- run command in a separate process
          file_icons   = false,
          color_icons  = false,
          prompt       = 'Rg❯ ',
          cmd          = "rg --color=always --hidden --no-heading --with-filename --line-number --column "
              .. " --smart-case "
              .. [[ -g "!*.html" -g "!/site/assets/" ]]           -- ignore: HTML, img
              .. [[ -g "!/target/debug" -g "!/target/release/" ]] -- ignore: rust
              .. [[ -g "!**/build/" --glob "!**/.venv/" -g "!**/node_modules/" -g "!*.js" ]]
              .. [[ -g "!**/docs/" ]]
              .. " -e",
        },
        hidden = true,
        no_ignore = true,
        actions = {
          -- actions inherit from 'actions.files' and merge
          -- this action toggles between 'grep' and 'live_grep'
          ["ctrl-g"] = { actions.grep_lgrep },
          -- uncomment to enable '.gitignore' toggle for grep
          ["ctrl-r"] = { actions.toggle_ignore },
        },
      })
    end
  },
}
