(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("0fffa9669425ff140ff2ae8568c7719705ef33b7a927a0ba7c5e2ffcfac09b75" "2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3" "c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358" "79586dc4eb374231af28bbc36ba0880ed8e270249b07f814b0e6555bdcb71fab" default))
 '(display-line-numbers 'visual)
 '(display-line-numbers-type 'visual)
 '(line-move-visual nil)
 '(org-agenda-files
   '("~/GetThingsDone/gtd.org" "~/GetThingsDone/habits.org" "~/GetThingsDone/inbox.org" "~/GetThingsDone/someday.org" "~/GetThingsDone/tickler.org" "~/GetThingsDone/waiting.org"))
 '(org-agenda-start-with-follow-mode nil)
 '(org-enforce-todo-dependencies nil)
 '(org-indent-mode-turns-on-hiding-stars nil)
 '(org-modules
   '(ol-bbdb
     ol-bibtex
     ol-docview
     ol-eww
     ol-gnus
     org-habit
     ol-info
     ol-irc
     ol-mhe
     ol-rmail ol-w3m))
 '(org-reverse-note-order t)
 '(org-startup-folded nil)
 '(org-startup-indented t)
 '(package-selected-packages
   '(parinfer-rust-mode smartparens color-identifiers-mode dimmer hydra counsel keyfreq lua-mode transpose-frame ox-gfm benchmark-init command-log-mode writegood-mode feebleline which-key graphviz-dot-mode expand-region plantuml-mode ox-hugo agda2-mode find-file-in-project disable-mouse yaml-mode multiple-cursors ox-reveal xref yasnippet-snippets yasnippet company haskell-mode free-keys undo-tree nyan-mode guru-mode ace-window avy use-package lsp-mode clojure-mode-extra-font-locking clojure-mode cider go-mode magit exec-path-from-shell ripgrep ag projectile-ripgrep flx-ido projectile solarized-theme darcula-theme ##))
 '(visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))
 '(word-wrap t)
 '(yas-global-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

(setq use-package-always-ensure t)

(use-package benchmark-init
  :ensure t
  :config
  ;; To disable collection of benchmark data after init is done.
  (add-hook 'after-init-hook 'benchmark-init/deactivate))

;; install the missing packages
(dolist (package (butlast package-selected-packages 1))
  (unless (package-installed-p package)
    (package-install package)))

(use-package graphviz-dot-mode
  :ensure t
  :config
  (setq graphviz-dot-indent-width 4))

(use-package counsel
  :init
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  :bind
  ("M-x" . counsel-M-x)
  ("<f1> b" . counsel-descbinds)
  ("C-x C-f" . counsel-find-file)
  ("C-x b" . counsel-buffer-or-recentf)
  ("C-s" . swiper-isearch)
  ("C-r" . swiper-isearch-backward))

;; theme
(load-theme 'tango-dark t)

;; Check https://github.com/tonsky/FiraCode on install instructions
(set-face-attribute 'default nil
                    :family "Fira Code" :height 180 :weight 'normal)

;; projectile
(use-package projectile
  :bind-keymap
  ("s-p" . projectile-command-map))


(projectile-mode +1)

(defun valid-git-dir (x) (not (or (string= x ".") (string= x ".."))))

(defun folder-names () (seq-filter 'valid-git-dir (directory-files "~/Git/")))

(defun add-path (v) (concat "~/Git/" v))

(setq projectile-project-search-path (mapcar 'add-path (folder-names)))


;; backup settings
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; active Org-babel languages
(org-babel-do-load-languages
 'org-babel-load-languages
 '(;; other Babel languages
   (shell . t)
   (plantuml . t)
   (dot . t)))

(setq org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js")

;; paranthesis
(show-paren-mode t)

;; plantuml
(setq org-plantuml-jar-path
      (expand-file-name "~/plantuml.jar"))

;; plantuml non org
(setq plantuml-jar-path "~/plantuml.jar")
(setq plantuml-default-exec-mode 'jar)


;; magit
(global-set-key (kbd "C-x g") 'magit-status)

(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))

;; avy
(use-package avy
  :bind (("C-;" . avy-goto-char-timer)
	 ("C-'" . avy-goto-word-1))
  :init
  (setq avy-orders-alist
	'((avy-goto-char . avy-order-closest)
        (avy-goto-word-1 . avy-order-closest))))


(setq inhibit-startup-message t) 
(setq initial-scratch-message nil)

(setq default-directory "~/")

(add-hook 'after-init-hook 'global-company-mode)

;; lsp settings
(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "s-l")
  :hook ((go-mode . lsp)
	 (sh-mode . lsp)
	 (c-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

;; disable file watcher for performance
(setq lsp-enable-file-watchers nil)
(setq lsp-log-io nil)
(setq lsp-print-performance t)

;; settings to optimize lsp-mode
(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setq gc-cons-threshold 100000000)

;; multiple cursors
(require 'multiple-cursors)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

;; windmove
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; company yas integration
(global-set-key (kbd "C-c y") 'company-yasnippet)

(use-package keyfreq
  :ensure t
  :init
  (setq keyfreq-excluded-commands '(disable-mouse--handle
				    self-insert-command
				    org-self-insert-command))
  :config
  (keyfreq-mode 1)
  (keyfreq-autosave-mode 1))


(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; disable arrow keys
(global-unset-key (kbd "<left>"))
(global-unset-key (kbd "<right>"))
(global-unset-key (kbd "<up>"))
(global-unset-key (kbd "<down>"))
(global-unset-key (kbd "<C-left>"))
(global-unset-key (kbd "<C-right>"))
(global-unset-key (kbd "<C-up>"))
(global-unset-key (kbd "<C-down>"))
(global-unset-key (kbd "<M-left>"))
(global-unset-key (kbd "<M-right>"))
(global-unset-key (kbd "<M-up>"))
(global-unset-key (kbd "<M-down>"))

;; Backup into temp
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
      backup-by-copying t    ; Don't delink hardlinks
      version-control t      ; Use version numbers on backups
      delete-old-versions t  ; Automatically delete excess backups
      kept-new-versions 20   ; how many of the newest versions to keep
      kept-old-versions 5    ; and how many of the old
      )


(global-visual-line-mode t)
(global-disable-mouse-mode)

;; Org sort entire buffer
(defun org-sort-buffer ()
  "Go to the top of the buffer and sort the file"
  (interactive)
  (beginning-of-buffer)
  (org-sort))

(global-set-key (kbd "C-x x") 'previous-buffer)
(global-set-key (kbd "C-x y") 'next-buffer)
(add-hook 'org-mode-hook (lambda ()
			   (local-set-key (kbd "C-c s") 'org-sort-buffer)))
(add-to-list 'auto-mode-alist '("\\.puml\\'" . plantuml-mode))
(require 'find-file-in-project)

(setq ffip-use-rust-fd t)

;; blogging using hugo
(use-package ox-hugo
  :ensure t            ;Auto-install the package from Melpa (optional)
  :after ox)

;; mac switch meta key
(setq mac-option-modifier 'meta)
(setq mac-command-modifier 'super)

(use-package expand-region
  :ensure t
  :bind ("C-=" . er/expand-region))

(add-to-list 'load-path "~/custom-elisp")
(require 'exec-plantuml)
(require 'org-gtd)

(tool-bar-mode -1)
(scroll-bar-mode -1)

(use-package which-key
  :config
  (add-hook 'after-init-hook 'which-key-mode))

(use-package ace-window
  :bind ("M-o" . ace-window)
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(use-package command-log-mode)

(use-package transpose-frame)

(use-package lua-mode)

(use-package hydra
  :init
  (defhydra hydra-zoom (global-map "s-b")
    "scroll"
    ("j" scroll-up-command "scroll up")
    ("k" scroll-down-command "scroll down")
    ("l" beginning-of-buffer "start")
    ("h" end-of-buffer "end")
    ("d" xref-find-definitions "definition")
    ("f" xref-pop-marker-stack "back")
    ("r" lsp-find-references "references")
    ("g" avy-goto-char "goto")))

(global-set-key (kbd "<f5>") (lambda () (interactive) (load-file (buffer-file-name))))

(defalias 'yes-or-no-p 'y-or-n-p)

;; from https://stackoverflow.com/a/12790410/1737080
(defun org-mode-is-intrusive ()
  ;; Make something work in org-mode:
  ;; (local-unset-key (kbd "something I use"))
  (local-unset-key (kbd "C-'"))
  )
(add-hook 'org-mode-hook 'org-mode-is-intrusive)

;; start emacs server if not running
(server-start)

(display-time-mode 1)
(display-battery-mode 1)

(use-package dimmer
  :init
  (dimmer-configure-which-key)
  (dimmer-mode t))

(global-set-key
 (kbd "C-x s")
 (lambda ()
   (interactive)
   (save-some-buffers t)))

(setq visible-bell t)

(use-package smartparens
  :init
  (bind-key "C-M-f" #'sp-forward-sexp smartparens-mode-map)
  (bind-key "C-M-b" #'sp-backward-sexp smartparens-mode-map)
  (bind-key "C-)" #'sp-forward-slurp-sexp smartparens-mode-map)
  (bind-key "C-(" #'sp-backward-slurp-sexp smartparens-mode-map)
  (bind-key "M-)" #'sp-forward-barf-sexp smartparens-mode-map)
  (bind-key "M-(" #'sp-backward-barf-sexp smartparens-mode-map)
  (bind-key "C-S-s" #'sp-splice-sexp)
  (bind-key "C-M-<backspace>" #'backward-kill-sexp)
  (bind-key "C-M-S-<SPC>" (lambda () (interactive) (mark-sexp -1)))

  :config
  (smartparens-global-mode t)

  (sp-pair "'" nil :actions :rem)
  (sp-pair "`" nil :actions :rem)
  (setq sp-highlight-pair-overlay nil))

;; enable auto insert mode
(auto-insert-mode t)

;; plantuml support for auto insert
(add-to-list
 'auto-insert-alist
 '(("\\.puml\\'" . "Plantuml File") . ["template.puml"]))

(use-package parinfer-rust-mode
  :hook emacs-lisp-mode
  :init
  (setq parinfer-rust-auto-download t))
