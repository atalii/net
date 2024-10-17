
(add-hook 'write-file-hooks 'delete-trailing-whitespace)

(setq inhibit-startup-screen t)

(tool-bar-mode -1)
(menu-bar-mode -1)

(set-frame-font "BerkeleyMono")

(add-to-list 'exec-path "/home/atalii/bin")
(add-to-list 'exec-path "/home/atalii/.cargo/bin")

(setq org-agenda-files '("~/org" "~/org/REED-24F/OCTOBER"))
(setq org-refile-targets '(("~/org/index.org" :maxlevel . 2)))

(setq org-src-fontify-natively t)

(setq c-default-style "linux")


(defun notes-dir ()
  (let ((long-month (upcase (format-time-string "%B"))))
    (concat "~/org/REED-24F/" long-month)))

(defun new-org-ask ()
  (interactive)
  (tel-open-dated-file
   "org template"
   '("CRES-150F" "HUM-110-LECTURE" "HUM-110-READING" "CSCI-221")
   (notes-dir)
   ".org"))

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
