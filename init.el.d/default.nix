{ pkgs ? import <nixpkgs> { } }:

let
  packages = [
    {
      name = "devil";
      dir = pkgs.fetchFromGitHub {
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
      dir = pkgs.fetchFromGitHub {
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
      dir = pkgs.fetchFromGitHub {
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
      dir = pkgs.fetchFromGitHub {
        owner = "emacs-helm";
        repo = "helm";
        rev = "v4.0";
        hash = "sha256-/Hys07+USA44AbUQ+gekt7TefcLJeYsaXzdzxPu1hUY=";
      };

      config = ''
        (helm-mode 1)
      '';
    }

    {
      name = "markdown-mode";
      dir = pkgs.fetchFromGitHub {
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
      dir = pkgs.fetchFromGitHub {
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
      dir = pkgs.fetchFromGitHub {
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
      dir = pkgs.fetchFromGitHub {
        owner = "atalii";
        repo = "tel";
        rev = "963d2c2fff0459bb32e9606834df8c3c347b3030";
        hash = "sha256-GLTB6Oq/BR6P/LDyIo2oO+j9ENejZ8zK8WFifW7Jy/4=";
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
      dir = pkgs.fetchFromGitHub {
        owner = "doomemacs";
        repo = "themes";
        rev = "v2.3.0";
        hash = "sha256-mZNiAtAZ5dzbP8TakC6W2ivQnaDMdRxK4aYGCrRiF4g=";
      };
    }
  ];

  pkgToPreamble = pkg: ''
    ;; Auto-generated peramble for: ${pkg.name}
    (add-to-list 'load-path "${pkg.dir}")
    (require '${pkg.name})
  '';

  pkgToConf = pkg: ''
    ;; Auto-generated conf section for: ${pkg.name}
    ${pkg.config or ";; EMPTY"}
  '';

  pkgToPostamble = pkg: ''
    ;; Auto-generated postamble for: ${pkg.name}
    ${pkg.postamble or ";; EMPTY"}
  '';

  forPackages = f: pkgs.lib.concatStringsSep "\n"
    (map f packages);

  preamble = forPackages pkgToPreamble;
  config = forPackages pkgToConf;
  postamble = forPackages pkgToPostamble;

  extraConfig = ''
    (add-hook 'write-file-hooks 'delete-trailing-whitespace)

    (tool-bar-mode -1)
    (menu-bar-mode -1)

    (set-frame-font "BerkeleyMono")

    (add-to-list 'exec-path "/home/atalii/bin")
    (add-to-list 'exec-path "/home/atalii/.cargo/bin")

    (setq org-agenda-files '("~/org" "~/org/REED-24F/OCTOBER"))

    (setq org-src-fontify-natively t)

    (setq c-default-style "linux")


    (defun note-path (slug)
      (let
          ((long-month (upcase (format-time-string "%B")))
           (suffix (format-time-string "%m-%d")))
        (concat
         "~/org/REED-24F/"
         long-month
         "/"
         slug
         "-"
         suffix
         ".org")))

    (defun new-org-ask ()
      (interactive)
      (find-file
       (note-path
        (completing-read
         "org template:"
               '("CRES-150F"
    	     "CRES-150F-READINGS"
    	     "HUM-110-LECTURE"
    	     "HUM-110-READING"
    	     "CSCI-221-SECTION")))))

    (keymap-global-set "C-x C-o" #'new-org-ask)

    (custom-set-variables
     ;; custom-set-variables was added by Custom.
     ;; If you edit it by hand, you could mess it up, so be careful.
     ;; Your init file should contain only one such instance.
     ;; If there is more than one, they won't work right.
     '(custom-enabled-themes '(doom-nord-light))
     '(custom-safe-themes
       '("7e068da4ba88162324d9773ec066d93c447c76e9f4ae711ddd0c5d3863489c52"))
     '(devil-global-sets-buffer-default t)
     '(markdown-hide-markup t)
     '(markdown-non-nil true)
     '(org-babel-load-languages '((C . t))))

    (custom-set-faces
     ;; custom-set-faces was added by Custom.
     ;; If you edit it by hand, you could mess it up, so be careful.
     ;; Your init file should contain only one such instance.
     ;; If there is more than one, they won't work right.
     '(markdown-header-face-1 ((t (:inherit markdown-header-face :height 2.0))))
     '(markdown-header-face-2 ((t (:inherit markdown-header-face :height 1.8))))
     '(markdown-header-face-3 ((t (:inherit markdown-header-face :height 1.6))))
     '(markdown-header-face-4 ((t (:inherit markdown-header-face :height 1.4))))
     '(markdown-header-face-5 ((t (:inherit markdown-header-face :height 1.2))))
     '(mode-line ((t (:background "white" :foreground "#2E3436" :box (:line-width (1 . -1) :style released-button) :height 1))))
     '(mode-line-buffer-id ((t (:underline "purple" :weight bold)))))
  '';

  initContents = pkgs.lib.concatStringsSep "\n"
    [ preamble config postamble extraConfig ];

in pkgs.writeText "init.el" initContents
