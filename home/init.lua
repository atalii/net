  vim.cmd [[colorscheme catppuccin-latte]]

  local lspconfig = require('lspconfig')
  lspconfig.clangd.setup{}
  lspconfig.gopls.setup{}
  lspconfig.hls.setup{}
  lspconfig.svelte.setup{}
  lspconfig.tinymist.setup{}

  lspconfig.nil_ls.setup {
    settings = {
      ['nil'] = {
	nix = { flake = { autoArchive = true; }; };
	formatting = { command = { "nixfmt" }; };
      };
    };
  }

  local set_spaces_callback = function (width)
    return function()
      vim.opt_local.shiftwidth = width;
      vim.opt_local.tabstop = width;
      vim.opt_local.expandtab = true;
    end
  end

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'nix';
    callback = set_spaces_callback(2);
  })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'ada';
    callback = set_spaces_callback(3);
  })

  vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
      vim.opt.number = true
      vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(ev)
	  vim.lsp.buf.format {bufnr = ev.buf}
	end
      })
    end,
  })

  vim.diagnostic.config({
    virtual_lines = true,
  })

  vim.g.mapleader = ' ';

  local telescope = require('telescope.builtin');
  vim.keymap.set('n', '<leader>a', telescope.live_grep, { desc = 'Live grep (telescope)'; });
  vim.keymap.set('n', '<leader>o', telescope.find_files, { desc = 'Find files (telescope)'; });
  vim.keymap.set('n', '<leader>e', telescope.buffers, { desc = 'Open buffer (telescope)'; });

  vim.keymap.set('n', '<leader>ll', function()
    vim.diagnostic.jump({
      diagnostic = vim.diagnostic.get_next()
    })
  end, { desc = "Next diagnostic." })

  vim.keymap.set('n', '<leader>lr', function()
    vim.diagnostic.jump({
      diagnostic = vim.diagnostic.get_next()
    })
  end, { desc = "Next diagnostic." })
