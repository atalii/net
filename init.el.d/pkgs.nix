{ fetchFromGitHub }:

[
  {
    name = "uniquify-files";
    dir = fetchTarball {
      url = "https://elpa.gnu.org/packages/uniquify-files-1.0.4.tar";
      sha256 = "sha256:047rcgi4ipqwhsm6w5sr5i0hkc3yv88ihiaybr70lwys51rmw1a9";
    };
  }
  {
    name = "wisi";
    dir = fetchTarball {
      url = "https://elpa.gnu.org/packages/wisi-4.3.2.tar";
      sha256 = "sha256:1rkjpnnj3fyafgi878ijjnjwnh3gd15qgjfp8gwlqicilgg8rqf8";
    };
  }

  {
    name = "gnat-compiler";
    dir = fetchTarball {
      url = "https://elpa.gnu.org/packages/gnat-compiler-1.0.3.tar";
      sha256 = "sha256:1qm57bph4fm6mb2b3ra4n3wnnk72p06mvc0wxdqn8dd6ff814izx";
    };
  }

  {
    name = "ada-mode";
    dir = fetchTarball {
      url = "https://elpa.gnu.org/packages/ada-mode-8.1.0.tar";
      sha256 = "sha256:1mi91xg5j8rxn53iw3faamb2di6rcm7wij0p5m181n6xihxpf4ni";
    };

    config = ''
        (add-to-list 'auto-mode-alist '("\\.ads\\'" . ada-mode))
        (add-to-list 'auto-mode-alist '("\\.adb\\'" . ada-mode))
      '';
  }
  {
    name = "devil";
    dir = fetchFromGitHub {
      owner = "susam";
      repo = "devil";
      rev = "0.6.0";
      hash = "sha256-Puwtz7gOYwUlgrIMg4/61Ly9ylPIWh08Ll+f4YzzKd8=";
    };

    config = ''
        (global-devil-mode)
      '';
  }

  {
    name = "treemacs";
    dir = fetchFromGitHub {
      owner = "Alexander-Miller";
      repo = "treemacs";
      rev = "3.1";
      hash = "sha256-JdkLUOcB98Hln7ktWRml0aNQqpOEpCPMVh01lyagQOc=";
    };

    postamble = ''
      (treemacs)
    '';
  }

  {
    name = "go-mode";
    dir = fetchFromGitHub {
      owner = "dominikh";
      repo = "go-mode.el";
      rev = "v1.6.0";
      hash = "sha256-B6+G/q0lEvtro4/zU4M1uZwd43CdkLi+HpShZkawHwM=";
    };

    config = ''
      (add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))
    '';
  }

  {
    name = "helm";
    dir = fetchFromGitHub {
      owner = "emacs-helm";
      repo = "helm";
      rev = "v4.0";
      hash = "sha256-/Hys07+USA44AbUQ+gekt7TefcLJeYsaXzdzxPu1hUY=";
    };

    config = ''
      (helm-mode 1)
      (keymap-global-set "M-x" #'helm-M-x)
      (keymap-global-set "C-x C-f" #'helm-find-files)
    '';
  }

  {
    name = "markdown-mode";
    dir = fetchFromGitHub {
      owner = "jrblevin";
      repo = "markdown-mode";
      rev = "v2.6";
      hash = "sha256-h2RRbBiRw0sq1eit3bPYjZc7o5ZHdRHITEPHP74YC8Q=";
    };

    config = ''
      (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
    '';
  }

  {
    name = "nix-mode";
    dir = fetchFromGitHub {
      owner = "NixOS";
      repo = "nix-mode";
      rev = "v1.5.0";
      hash = "sha256-OLMEchEfQJlQFmF9Xx8JSf75tW3rSKNkKVVadua1efc=";
    };

    config = ''
      (add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))
    '';
  }

  {
    name = "rust-mode";
    dir = fetchFromGitHub {
      owner = "rust-lang";
      repo = "rust-mode";
      rev = "1.0.5";
      hash = "sha256-SIct6iAF1sbNrFhJXmoHW5MP1jVOSea8qqk1rLrWUGo=";
    };

    config = ''
      (add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))
      (add-hook 'rust-mode-hook 'lsp-deferred)
    '';
  }

  {
    name = "tel";
    dir = fetchFromGitHub {
      owner = "atalii";
      repo = "tel";
      rev = "b431e05214fdd3fb5140b749cfe83bb3a4f5ec05";
      hash = "sha256-sPY3D1nlvgudN+WV2EvF6vb3vL+Wp5IKo4Kiij/ghl0=";
    };

    config = ''
      (tel-make-shortcut
       "eshell" eshell
       (lambda () (string= "*eshell*" (buffer-name (current-buffer)))))

      (tel-make-shortcut
       "org-index" (lambda () (find-file "~/org/index.org"))
       (lambda () (string= "index.org" (buffer-name (current-buffer)))))

      (keymap-global-set "C-<tab> a" #'tel-shortcut-eshell)
      (keymap-global-set "C-<tab> o" #'tel-shortcut-org-index)
    '';
  }

  {
    name = "doom-themes";
    dir = fetchFromGitHub {
      owner = "doomemacs";
      repo = "themes";
      rev = "v2.3.0";
      hash = "sha256-mZNiAtAZ5dzbP8TakC6W2ivQnaDMdRxK4aYGCrRiF4g=";
    };
  }
]
