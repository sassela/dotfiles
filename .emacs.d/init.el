;;; init.el -- Abby's emacs config

;;; Commentary:

;;; Code:

;; M-x byte-recompile-directory

(setq inhibit-startup-screen t)

(if window-system
    (progn
      (scroll-bar-mode -1)
      (tool-bar-mode -1)
      (set-face-attribute 'default nil :height 100)
      (set-frame-size (selected-frame) 100 100))
  (menu-bar-mode 0))

(add-to-list 'default-frame-alist
             '(font . "Ubuntu Mono-10"))
;; =============================================================
;; package

(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)

(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)

(setq package-enable-at-startup nil)

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(when (not (package-installed-p 'use-package))
  (package-install 'use-package))

(require 'use-package)

;; =============================================================
;; Major modes

;; Clojure
(use-package clojure-mode
  :ensure t
  :pin melpa-stable
  :config
  (setq safe-local-variable-values
	(quote
	 ((eval define-clojure-indent
		(snippet
		 (quote defun))
		(template
		 (quote defun)))))))

;; Cider
(use-package cider
  :ensure t
  :defer t
  :pin melpa-stable
  :diminish (cider-mode . "Cdr")
  :config
  (setq cider-repl-history-file "~/.emacs.d/cider-history")
  (setq cider-font-lock-dynamically '(macro core function var))
  (setq cider-repl-use-pretty-printing nil)
  (setq cider-repl-use-clojure-font-lock t)
  (setq cider-repl-result-prefix ";; => ")
  (setq cider-repl-wrap-history t)
  (setq cider-repl-history-size 3000)
  (setq cider-show-error-buffer 'except-in-repl)
  (setq cider-repl-display-help-banner nil)
  (setq cider-inject-dependencies-at-jack-in nil)
  (add-hook 'cider-mode-hook #'eldoc-mode))

;; Go lang
(use-package go-mode
  :ensure t
  :defer t
  :pin melpa-stable)

(use-package go-eldoc
  :ensure t
  :defer t
  :pin melpa-stable)

;; Haskell
;; make sure there is no local ghc in the path!
;; stack setup
;; stack install hlint hindent hdevtools ghcid intero stylish-haskell

(use-package haskell-mode
  :ensure t
  :pin melpa-stable
  :config
  (require 'haskell-interactive-mode)
  (setq haskell-interactive-popup-errors nil
        haskell-process-suggest-hoogle-imports t
        haskell-process-suggest-remove-import-lines t
        haskell-process-auto-import-loaded-modules t
        haskell-stylish-on-save t
        hindent-reformat-buffer-on-save t
        haskell-tags-on-save t
        haskell-process-log t
        haskell-process-args-stack-ghci '("--ghci-options=-ferror-spans"))
  (add-hook 'haskell-mode-hook
            '(lambda ()
               (setq-local completion-at-point-functions '(haskell-process-completions-at-point))
               (intero-mode)
               (hindent-mode)
               (haskell-indentation-mode t)
               (ghc-init)))
  (define-key haskell-mode-map "\C-c\C-h" 'hoogle))

(use-package intero
  :ensure t
  :defer t
  :config
  (add-hook 'intero-mode-hook
            '(lambda ()
               (flycheck-add-next-checker 'intero '(warning . haskell-hlint))
               (flycheck-add-next-checker 'intero '(warning . haskell-stack-ghc)))))

(use-package ghc
  :ensure t
  :defer t
  :disabled t
  :pin melpa-stable)

(use-package hindent
  :ensure t
  :defer t
  :pin melpa-stable)

(use-package shm
  :ensure t
  :defer t
  :pin melpa-stable)

;; Elm
(use-package elm-mode
  :ensure t
  :defer t
  :pin melpa-stable
  :init (setq elm-indent-offset 4))

;; Purescript
(use-package purescript-mode
  :ensure t
  :defer t
  :pin melpa
  :config
  (require 'psc-ide)
  (add-hook 'purescript-mode-hook
            (lambda ()
              (repl-toggle-mode)
              (inferior-psci-mode)
              (psc-ide-mode)
              (flycheck-mode)
              (turn-on-purescript-indentation))))

(use-package psc-ide
  :ensure t
  :defer t
  :pin melpa)

(use-package psci
  :ensure t
  :defer t
  :pin melpa-stable)

(use-package repl-toggle
  :ensure t
  :defer t
  :pin melpa-stable
  :config
  (add-to-list 'rtog/mode-repl-alist '(purescript-mode . psci)))

;; Markdown
(use-package markdown-mode
  :ensure t
  :pin melpa-stable
  :mode "\\.md\\'")

;; Yaml
(use-package yaml-mode
  :ensure t
  :defer t
  :pin melpa-stable)

;; Docker
(use-package docker
  :ensure t
  :defer t
  :pin melpa-stable
  :bind ("C-c d" . docker))

(use-package docker-compose-mode
  :ensure t
  :defer t
  :pin melpa-stable)

(use-package dockerfile-mode
  :ensure t
  :defer t
  :pin melpa-stable)

;; Mustache
(use-package mustache-mode
  :ensure t
  :defer t
  :pin melpa-stable
  :mode "\\.mustache\\'")

;; Dired
(use-package dired
  :config
  (setq dired-dwim-target t)
  (defun kill-dired-buffers ()
    (interactive)
    (mapc (lambda (buffer)
	    (when (eq 'dired-mode (buffer-local-value 'major-mode buffer))
	      (kill-buffer buffer)))
	  (buffer-list)))
  (add-hook 'dired-mode-hook
	    '(lambda ()
	       (define-key dired-mode-map "\C-x\M-q" 'wdired-change-to-wdired-mode)
	       (define-key dired-mode-map "\C-x\M-f" 'find-name-dired))))

;; =============================================================
;; Minor modes

;; eldoc
(use-package eldoc
  :diminish (eldoc-mode . "ED")
  :config
  (add-hook 'emacs-lisp-mode-hook 'eldoc-mode))

;; Magit
(use-package magit
  :ensure t
  :pin melpa-stable
  :bind (("C-c C-g" . magit-status)
         ("C-c C-b" . magit-blame-mode))
  :config
  (setq magit-last-seen-setup-instructions "1.4.0")
  (setq magit-auto-revert-mode 'silent)
  (setq magit-diff-refine-hunk t))

;; Paredit
(use-package paredit
  :ensure t
  :pin melpa-stable
  :diminish (paredit-mode . "Pe")
  :config
  (add-hook 'lisp-mode-hook 'paredit-mode)
  (add-hook 'emacs-lisp-mode-hook 'paredit-mode)
  (add-hook 'scheme-mode-hook 'paredit-mode)
  (add-hook 'cider-repl-mode-hook 'paredit-mode)
  (add-hook 'clojure-mode-hook 'paredit-mode))

;; Smartparens
(use-package smartparens
  :ensure t
  :pin melpa-stable
  :config
  (sp-use-paredit-bindings)
  (sp-pair "'" nil :actions :rem)
  (add-hook 'haskell-mode-hook 'smartparens-mode)
  (add-hook 'haskell-interactive-mode-hook 'smartparens-mode)
  (add-hook 'ruby-mode-hook 'smartparens-mode)
  (add-hook 'inf-clojure-mode-hook 'smartparens-mode))

;; Company
(use-package company
  :ensure t
  :pin melpa-stable
  :diminish company-mode
  :config
  (global-company-mode))

;; IDO
(use-package ido-completing-read+
  :ensure t
  :pin melpa-stable
  :config
  (ido-mode 1)
  (ido-ubiquitous-mode 1)
  (ido-everywhere 1)
  (setq ido-enable-flex-matching t)
  (global-set-key "\M-x"
                (lambda ()
                  (interactive)
                  (call-interactively
                   (intern (ido-completing-read "M-x " (all-completions "" obarray 'commandp)))))))

;; Projectile
(use-package projectile
  :ensure t
  :pin melpa-stable
  :config
  (setq projectile-mode-line '(:eval (format " P[%s]" (projectile-project-name))))
  (add-hook 'clojure-mode-hook 'projectile-mode)
  (add-hook 'ruby-mode-hook 'projectile-mode))

;; Yasnippet
(use-package yasnippet
  :ensure t
  :pin melpa-stable
  :diminish (yas-minor-mode . " Y")
  :config
  (yas-global-mode 1)
  (add-to-list 'yas-snippet-dirs "~/.emacs.d/snippets")
  (yas-load-directory "~/.emacs.d/snippets"))

;; Silver searcher
(use-package ag
  :ensure t
  :pin melpa-stable
  :bind ("C-x M-f" . mt-ag-search)
  :config
  (setq ag-highlight-search t)
  (setq ag-reuse-buffers t)
  (defun mt-ag-search (string file-regex directory)
    (interactive (list (read-from-minibuffer "Search string: " (ag/dwim-at-point))
		       (read-from-minibuffer "In filenames matching PCRE: " (ag/buffer-extension-regex))
		       (read-directory-name "Directory: " (ag/project-root default-directory))))
    (ag/search string directory :file-regex file-regex)))

;; Linum
(use-package linum
  :config
  (if window-system
      (setq linum-format "%d")
    (setq linum-format "%d "))
  (setq linum-modes '(clojure-mode emacs-lisp-mode tuareg-mode puppet-mode ruby-mode markdown-mode python-mode
                                   go-mode haskell-mode purescripe-mode elm-mode purescript-mode js-mode html-mode css-mode c-mode-common))
  (require 's)
  (--each linum-modes (add-hook (intern (s-concat (symbol-name it) "-hook")) 'linum-mode)))

;; Flycheck
(use-package flycheck
  :ensure t
  :pin melpa-stable
  :config
  (add-hook 'after-init-hook #'global-flycheck-mode))

;; Flyspell
(use-package flyspell
  :ensure t
  :pin melpa-stable)

;; idle-highlight-mode
(use-package idle-highlight-mode
  :ensure t
  :pin melpa-stable
  :config
  (add-hook 'clojure-mode-hook 'idle-highlight-mode)
  (add-hook 'lisp-mode-hook 'idle-highlight-mode)
  (add-hook 'scheme-mode-hook 'idle-highlight-mode)
  (add-hook 'emacs-lisp-mode-hook 'idle-highlight-mode)
  (add-hook 'haskell-mode-hook 'idle-highlight-mode))

;; Golden ratio
(use-package golden-ratio
  :ensure t
  :pin melpa-stable
  :diminish (golden-ratio-mode . "AU")
  :config
  (golden-ratio-mode 1)
  (add-to-list 'golden-ratio-exclude-modes "ediff-mode"))

;; undo-tree
(use-package undo-tree
  :ensure t
  :pin marmalade
  :diminish (undo-tree-mode . "UT")
  :config
  (global-undo-tree-mode))

;; browse-kill-ring
(use-package browse-kill-ring
  :ensure t
  :pin melpa-stable
  :config
  (browse-kill-ring-default-keybindings))

;; Multiple cursors
(use-package multiple-cursors
  :ensure t
  :pin melpa-stable
  :bind (("C-c ." . mc/mark-next-like-this)
         ("C-c ," . mc/mark-previous-like-this)
         ("C-c M-." . mc/mark-all-like-this)))

;; Expand region
(use-package expand-region
 :ensure t
 :bind ("C-x =" . er/expand-region))

;; Yagist
(use-package yagist
  :ensure t
  :defer t
  :pin melpa-stable
  :config
  (setq yagist-encrypt-risky-config t))

(use-package kaesar
  :ensure t
  :pin melpa-stable)

;; Git gutter
(use-package git-gutter
  :ensure t
  :pin melpa-stable
  :diminish (git-gutter-mode . "GG")
  :bind ("C-x C-g" . git-gutter-mode))

;; inf-ruby
(use-package inf-ruby
  :ensure t
  :pin melpa-stable
  :config
  (add-hook 'ruby-mode-hook 'inf-ruby-minor-mode))

;; Avy
(use-package avy
  :ensure t
  :pin melpa-stable
  :bind (("M-g f" . avy-goto-line)
         ("M-g w" . any-goto-word-1)))

;; JVM
(use-package jvm-mode
  :ensure t
  :pin melpa-stable
  :config
  (setq jvm-mode-line-string " jvm[%d]")
  (jvm-mode))

;; buffer-move
(use-package buffer-move
  :ensure t
  :pin melpa-stable
  :bind (("C-c <C-right>" . mt-move-right)
         ("C-c <C-left>" . mt-move-left))
  :config
  (defun mt-move-right ()
    (interactive)
    (buf-move-right) (golden-ratio))
  (defun mt-move-left ()
    (interactive)
    (buf-move-left) (golden-ratio)))

;; align-cljlet
(use-package align-cljlet
  :ensure t
  :pin marmalade
  :config
  (add-hook 'clojure-mode-hook
          '(lambda ()
             (define-key clojure-mode-map "\C-c\C-y" 'align-cljlet))))

;; clj-refactor
(use-package clj-refactor
  :ensure t
  :pin melpa-stable
  :diminish clj-refactor-mode
  :config
  (add-hook 'clojure-mode-hook (lambda ()
                               (clj-refactor-mode 1)
                               (cljr-add-keybindings-with-prefix "C-c C-o"))))

(use-package dumb-jump
  :ensure t
  :diminish dumb-jump-mode
  :bind (("C-c j" . dumb-jump-go)
         ("C-c b" . dumb-jump-back)
         ("C-c q" . dumb-jump-quick-look)))

;; https://github.com/jaypei/emacs-neotree
(use-package neotree
  :ensure t
  :pin melpa-stable
  :config
  (global-set-key (kbd "C-x t") 'neotree-toggle))

;; =============================================================
;; Colors

(use-package flatland-theme
  :ensure t
  :pin marmalade
  :config
  (when (not window-system)
    (let ((bg-one (assoc "flatland-bg+1" flatland-colors-alist))
	  (bg-two (assoc "flatland-bg+2" flatland-colors-alist)))
      (setq flatland-colors-alist (delete bg-one flatland-colors-alist))
      (add-to-list 'flatland-colors-alist (cons "flatland-bg+1" (cdr bg-two))))
    (custom-set-faces
     '(company-preview ((t (:background "brightyellow" :foreground "wheat"))))
     '(company-tooltip ((t (:background "brightyellow" :foreground "black"))))))
  (custom-set-faces
   '(diff-refine-added ((t (:inherit diff-added :background "#4e4e4e"))))
   '(idle-highlight ((t (:background "#4e4e4e"))))
   '(linum ((t (:foreground "#555"))))
   '(region ((t (:background "#4c4f52")))))
  (load-theme 'flatland t))

;; =============================================================
;; Misc config

;; tags
  (defun create-tags (dir-name)
     "Create tags file."
     (interactive "DDirectory: ")
     (eshell-command
      (format "find %s -type f -name \"*.[ch]\" | etags -" dir-name)))

;; file history
(recentf-mode)
(setq recentf-max-menu-items 25)
(global-set-key (kbd "C-x C-r") 'recentf-open-files)

(show-paren-mode)
(global-auto-revert-mode t)
(column-number-mode t)

;; comments
(global-set-key (kbd "C-c ;") 'comment-or-uncomment-region)

;; better search
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

(global-set-key (kbd "RET") 'newline-and-indent)

;; duplicate line
(global-set-key (kbd "C-c C-d") 'duplicate-line)

(setq frame-title-format "%b")
(set-default 'truncate-lines t)
(defalias 'yes-or-no-p 'y-or-n-p)
(setq scroll-step 1)
(setq scroll-error-top-bottom t)
(blink-cursor-mode -1)
(setq ring-bell-function 'ignore)

;; remove trailing whitespace
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; uniquify
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; match parens
(setq blink-matching-paren-distance nil)

;; spaces instead of tabs
(setq-default indent-tabs-mode nil)
(setq tab-width 2)
(setq python-indent 3)
(setq c-basic-offset 3)
(setq c-indent-level 3)
(setq c++-tab-always-indent nil)
(setq js-indent-level 2)

;; Write backup files to own directory
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "backups")))))

;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)

;; Save point position between sessions
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name "places" user-emacs-directory))

;; copy line
(defun duplicate-line()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (forward-line 1)
  (yank)
)

;; =============================================================
;; Handy functions

;; XML pretty print
(defun pretty-print-xml-region(begin end)
  (interactive "r")
  (save-excursion
    (nxml-mode)
    (goto-char begin)
    (while (search-forward-regexp "\>[ \\t]*\<" nil t)
      (backward-char) (insert "\n"))
    (indent-region begin end))
  (message "Ah, much better!"))

;; =============================================================
;; OSX

;; Allow hash to be entered
(when (eq 'darwin system-type)

  (global-set-key (kbd "M-3") '(lambda () (interactive) (insert "#")))

  (use-package exec-path-from-shell
    :ensure t
    :pin melpa-stable
    :config
    (exec-path-from-shell-initialize))

  (defun copy-from-osx ()
    (shell-command-to-string "pbpaste"))

	(defun paste-to-osx (text &optional push)
    (let ((process-connection-type nil))
      (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
        (process-send-string proc text)
        (process-send-eof proc))))

  (unless (getenv "TMUX")
    (setq interprogram-cut-function 'paste-to-osx)
    (setq interprogram-paste-function 'copy-from-osx)))

(let ((local-path (expand-file-name "~/.local/bin")))
  (setenv "PATH" (concat local-path ":" (getenv "PATH")))
  (add-to-list 'exec-path local-path))

;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (intero psc-ide dumb-jump smex highlight-sexp expand-region docker-compose-mode docker psci clj-refactor cider avy haskell-mode go-mode clojure-mode exec-path-from-shell flatland-theme align-cljlet buffer-move jvm-mode inf-ruby git-gutter kaesar yagist yasnippet yaml-mode use-package undo-tree smartparens shm repl-toggle projectile paredit mustache-mode multiple-cursors markdown-mode magit ido-completing-read+ idle-highlight-mode hl-sexp hindent golden-ratio go-eldoc ghc flyspell-correct flycheck-haskell elm-mode dockerfile-mode browse-kill-ring ansible ag ace-flyspell)))
 '(safe-local-variable-values
   (quote
    ((intero-stack-yaml . "/Users/sassela/.stack/config.yaml")
     (intero-targets "aeas:lib" "aeas:exe:aeas-exe" "aeas:test:aeas-test")
     (eval define-clojure-indent
           (snippet
            (quote defun))
           (template
            (quote defun)))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#26292c" :foreground "#f8f8f8" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 100 :width normal :foundry "nil" :family "Menlo"))))
 '(company-preview ((t (:background "brightyellow" :foreground "wheat"))))
 '(company-tooltip ((t (:background "brightyellow" :foreground "black"))))
 '(diff-refine-added ((t (:inherit diff-added :background "#4e4e4e"))))
 '(idle-highlight ((t (:background "#4e4e4e"))))
 '(linum ((t (:foreground "#555"))))
 '(org-level-3 ((t (:foreground "white"))))
 '(org-level-4 ((t (:foreground "brightmagenta"))))
 '(region ((t (:background "#4c4f52")))))
