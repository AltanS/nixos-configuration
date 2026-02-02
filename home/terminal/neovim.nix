{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;

    # Runtime dependencies for LazyVim (treesitter compilation, search, etc.)
    extraPackages = with pkgs; [
      gcc
      gnumake
      fd
      lua-language-server
      stylua
      nil # nix LSP
    ];
  };

  # LazyVim starter config — lazy.nvim manages plugins at runtime
  xdg.configFile = {
    "nvim/init.lua".text = ''
      require("config.lazy")
    '';

    "nvim/lua/config/lazy.lua".text = ''
      local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
      if not (vim.uv or vim.loop).fs_stat(lazypath) then
        local lazyrepo = "https://github.com/folke/lazy.nvim.git"
        local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
        if vim.v.shell_error ~= 0 then
          vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
          }, true, {})
          vim.fn.getchar()
          os.exit(1)
        end
      end
      vim.opt.rtp:prepend(lazypath)

      require("lazy").setup({
        spec = {
          { "LazyVim/LazyVim", import = "lazyvim.plugins" },
          { import = "plugins" },
        },
        defaults = {
          lazy = false,
          version = false,
        },
        install = { colorscheme = { "tokyonight", "habamax" } },
        checker = {
          enabled = true,
          notify = false,
        },
        performance = {
          rtp = {
            disabled_plugins = {
              "gzip",
              "tarPlugin",
              "tohtml",
              "tutor",
              "zipPlugin",
            },
          },
        },
      })
    '';

    "nvim/lua/config/options.lua".text = ''
      -- Options are automatically loaded before lazy.nvim startup
      -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
    '';

    "nvim/lua/config/keymaps.lua".text = ''
      -- Keymaps are automatically loaded on the VeryLazy event
      -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
    '';

    "nvim/lua/config/autocmds.lua".text = ''
      -- Autocmds are automatically loaded on the VeryLazy event
      -- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
    '';

    "nvim/lua/plugins/nix.lua".text = ''
      return {
        -- Nix language support
        { "LnL7/vim-nix" },

        -- Add nix treesitter parser
        {
          "nvim-treesitter/nvim-treesitter",
          opts = function(_, opts)
            vim.list_extend(opts.ensure_installed, { "nix" })
          end,
        },
      }
    '';

    "nvim/stylua.toml".text = ''
      indent_type = "Spaces"
      indent_width = 2
      column_width = 120
    '';

    "nvim/.neoconf.json".text = builtins.toJSON {
      neodev = { library = { enabled = true; plugins = true; }; };
      neoconf = { plugins = { lua_ls = { enabled = true; }; }; };
    };
  };
}
