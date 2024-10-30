(add-to-list 'load-path "/home/atalii/Documents/src/tel")

(require 'devil)
(require 'go-mode)
(require 'helm)
(require 'markdown-mode)
(require 'nix-mode)
(require 'rust-mode)
(require 'slime)
(require 'tel)
(require 'treemacs)
(require 'doom-themes)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(doom-nord-light))
 '(custom-safe-themes
   '("7c28419e963b04bf7ad14f3d8f6655c078de75e4944843ef9522dbecfcd8717d"))
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

(global-devil-mode)
(helm-mode 1)

(tool-bar-mode -1)
(menu-bar-mode -1)

(add-to-list 'auto-mode-alist '("\\.nix\\'" . nix-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'"  . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.rs\\'"  . rust-mode))
(add-to-list 'auto-mode-alist '("\\.go\\'"  . go-mode))

(add-hook 'rust-mode-hook 'lsp-deferred)
(add-hook 'write-file-hooks 'delete-trailing-whitespace)

(add-hook 'lisp-mode-hook (lambda () (slime-mode t)))
(add-hook 'inferior-lisp-mode-hook (lambda () (inferior-slime-mode t)))
(setq inferior-lisp-program "sbcl")

(set-frame-font "BerkeleyMono")

(add-to-list 'exec-path "/home/atalii/bin")
(add-to-list 'exec-path "/home/atalii/.cargo/bin")

(setq org-agenda-files '("~/org" "~/org/REED-24F" "~/org/REED-24F/SEPTEMBER"))
(setq org-src-fontify-natively t)

(setq c-default-style "linux")

;; SHORTCUTS

(tel-make-shortcut
 "eshell" eshell
 (lambda () (string= "*eshell*" (buffer-name (current-buffer)))))

(tel-make-shortcut
 "org-index" (lambda () (find-file "~/org/index.org"))
 (lambda () (string= "index.org" (buffer-name (current-buffer)))))

(keymap-global-set "C-<tab> a" #'tel-shortcut-eshell)
(keymap-global-set "C-<tab> o" #'tel-shortcut-org-index)

;; NOTE TEMPLATES

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

(treemacs)
