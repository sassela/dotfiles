;;; init.el -- Abby's emacs config

;;; Commentary:
;; restart, `M-x load file` or` M-x byte-recompile-directory` to update

;;; Code:

(setq inhibit-startup-screen t)

;; =============================================================
;; package

(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/") t)

; disable automatic package loading for slightly faster initialisation
(setq package-enable-at-startup nil)

(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(when (not (package-installed-p 'use-package))
  (package-install 'use-package))

(require 'use-package)

;;; init.el ends here
