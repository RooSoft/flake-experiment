{ lib, config, pkgs, ... }:

let
  unstable = import <nixos-unstable> {};
in
  {
    nixpkgs.config.allowUnfree = true;

    home = {
      stateVersion = "22.11";
      username = "roo";
      homeDirectory = /home/roo;
      packages = with pkgs; [
        htop
        tmux
        nodejs-16_x
        bash
        unrar-wrapper
      ];
    };

    programs.zsh = {
      enable = true;
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = lib.cleanSource ./p10k-config;
          file = "p10k.zsh";
        }
      ];
    };

    programs.vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [ vim-airline vim-nix vim-elixir ];
      settings = { ignorecase = true; };
      extraConfig = ''
              set mouse=a
              set number
      '';
    };

    programs.neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins;
      let
      in [
        vim-nix
        gruvbox-community
        nvim-tree-lua
        nvim-web-devicons
        telescope-nvim
        telescope-fzf-native-nvim
        vim-elixir
      ];
      extraConfig = ''
        set mouse=a
        set number

        set tabstop=2
        set shiftwidth=2
        set softtabstop=2
        set expandtab

        let mapleader=" "
        let maplocalleader=" "

        " Find files using Telescope command-line sugar.
        nnoremap <leader>ff <cmd>Telescope find_files<cr>
        nnoremap <leader>fg <cmd>Telescope live_grep<cr>
        nnoremap <leader>fb <cmd>Telescope buffers<cr>
        nnoremap <leader>fh <cmd>Telescope help_tags<cr>

        " Using Lua functions
        nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
        nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
        nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
        nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
      '';
    };
  }
