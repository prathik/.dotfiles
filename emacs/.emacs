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
   '("2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3" "c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358" "79586dc4eb374231af28bbc36ba0880ed8e270249b07f814b0e6555bdcb71fab" default))
 '(line-move-visual nil)
 '(org-agenda-files
   '("/Users/prathikrajendran/GetThingsDone/gtd.org" "/Users/prathikrajendran/GetThingsDone/habits.org" "/Users/prathikrajendran/GetThingsDone/inbox.org" "/Users/prathikrajendran/GetThingsDone/someday.org" "/Users/prathikrajendran/GetThingsDone/tickler.org"))
 '(org-enforce-todo-dependencies nil)
 '(org-modules
   '(ol-bbdb ol-bibtex ol-docview ol-eww ol-gnus org-habit ol-info ol-irc ol-mhe ol-rmail ol-w3m))
 '(org-startup-folded nil)
 '(org-startup-indented t)
 '(package-selected-packages
   '(ox-hugo agda2-mode find-file-in-project disable-mouse helm-lsp yaml-mode treemacs-icons-dired treemacs-magit treemacs-projectile treemacs multiple-cursors ox-reveal org-roam helm-xref xref yasnippet-snippets yasnippet company haskell-mode free-keys undo-tree nyan-mode guru-mode ace-window golden-ratio avy use-package lsp-mode clojure-mode-extra-font-locking clojure-mode cider go-mode paredit magit exec-path-from-shell ripgrep ag helm-ag projectile-ripgrep flx-ido helm-rg helm-projectile projectile solarized-theme darcula-theme helm ##))
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

; install the missing packages
(dolist (package '(avy use-package lsp-mode clojure-mode-extra-font-locking clojure-mode cider go-mode paredit magit exec-path-from-shell ripgrep ag helm-ag projectile-ripgrep flx-ido helm-rg helm-projectile projectile solarized-theme darcula-theme helm))
  (unless (package-installed-p package)
    (package-install package)))

;; helm
(helm-mode 1)
(global-set-key (kbd "M-x") 'helm-M-x)
(setq helm-M-x-fuzzy-match t)

(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-b") 'helm-buffers-list)
(setq helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match    t)

(global-set-key (kbd "C-x C-f") 'helm-find-files)

(global-set-key (kbd "M-y") 'helm-show-kill-ring)

;; theme
(load-theme 'tango-dark t)

(set-face-attribute 'default nil
                :family "Monaco" :height 180 :weight 'normal)

;; projectile
(use-package projectile
  :bind-keymap
  ("C-c p" . projectile-command-map))


(projectile-mode +1)

(setq projectile-project-search-path '("~/Git/go-jek/" "~/Git/prathik/"))

;; helm-projective-integration
(require 'helm-projectile)
(helm-projectile-on)

;; backup settings
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; org gtd setup
(setq org-directory "/Users/prathikrajendran/GetThingsDone/")
(setq gtd-file (concat org-directory "gtd.org"))
(setq inbox-file (concat org-directory "inbox.org"))
(setq tickler-file (concat org-directory "tickler.org"))
(setq someday-file (concat org-directory "someday.org"))
(setq org-agenda-files (directory-files-recursively org-directory "\\.org$"))

(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

(setq org-capture-templates '(("t" "Todo [inbox]" entry
                               (file+headline inbox-file "Tasks")
                               "* TODO %i%? [0%]")
                              ("T" "Tickler" entry
                               (file+headline tickler-file "Tickler")
                               "* TODO %i%? \nDEADLINE: %t")))

(setq org-todo-keywords '((sequence "TODO(t)" "|" "DONE(d)" "CANCELLED(c)")))
(setq org-refile-targets '((gtd-file :maxlevel . 3)
                           (someday-file :level . 1)
                           (tickler-file :maxlevel . 2)))

(setq org-agenda-custom-commands 
      '(("o" "At the office" tags-todo "@office"
         ((org-agenda-overriding-header "Office")))))

(setq org-agenda-custom-commands 
      '(("o" "At the office" tags-todo "@office"
         ((org-agenda-overriding-header "Office")
          (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))))

(defun my-org-agenda-skip-all-siblings-but-first ()
  "Skip all but the first non-done entry."
  (let (should-skip-entry)
    (unless (org-current-is-todo)
      (setq should-skip-entry t))
    (save-excursion
      (while (and (not should-skip-entry) (org-goto-sibling t))
        (when (org-current-is-todo)
          (setq should-skip-entry t))))
    (when should-skip-entry
      (or (outline-next-heading)
          (goto-char (point-max))))))
		  
(defun org-current-is-todo ()
  (string= "TODO" (org-get-todo-state)))

(setq org-refile-use-outline-path 'file)

(setq org-clock-idle-time 4)

(defun insert-subtask ()
  ;; insert a subtask at the next line
  ;; this is useful when you want to break a task into
  ;; multiple next steps
  (interactive)
  (end-of-line)
  (insert (concat "\n" (make-string (+ 1 (current-heading-level (line-beginning-position) 0)) ?*) " TODO "))
  (end-of-line))

(defun current-heading-level (position count)
  ;; find the current heading level for a TODO
  ;; ** TODO x -> would return 2
  (if (eq 42 (char-after position)) (current-heading-level (+ 1 position) (+ 1 count)) count))

(add-hook 'org-mode-hook
  (lambda ()
    (local-set-key (kbd "C-c t") 'insert-subtask)))

;; org-roam setup
(setq org-roam-directory "~/org-roam")
(add-hook 'after-init-hook 'org-roam-mode)
(setq org-roam-completion-system 'helm)

(global-set-key (kbd "C-c r i") #'org-roam-insert)
(global-set-key (kbd "C-c r f") #'org-roam-find-file)
(global-set-key (kbd "C-c r r") #'org-roam-buffer-toggle-display)
(global-set-key (kbd "C-c r b") #'org-roam-switch-to-buffer)
(global-set-key (kbd "C-c r t") #'org-roam-tag-add)

;; productivity key bindings
(global-set-key (kbd "<f5>") (lambda() (interactive)(find-file "~/work.org")))
(global-set-key (kbd "<f6>") (lambda() (interactive)(find-file inbox-file)))
(global-set-key (kbd "<f7>") (lambda() (interactive)(find-file gtd-file)))


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
      (expand-file-name "/Users/prathikrajendran/plantuml.jar"))

;; plantuml non org
(setq plantuml-jar-path "/Users/prathikrajendran/plantuml.jar")
(setq plantuml-default-exec-mode 'jar)


;; magit
(global-set-key (kbd "C-x g") 'magit-status)

(when (version<= "26.0.50" emacs-version )
  (global-display-line-numbers-mode))

;; avy
(global-set-key (kbd "C-:") 'avy-goto-char)
(global-set-key (kbd "C-'") 'avy-goto-char-2)
(global-set-key (kbd "M-g f") 'avy-goto-line)
(global-set-key (kbd "M-g e") 'avy-goto-word-0)
(global-set-key (kbd "M-g w") 'avy-goto-word-1)

;; undo tree
(global-undo-tree-mode)

(setq inhibit-startup-message t) 
(setq initial-scratch-message nil)

(setq default-directory "~/")

(add-hook 'after-init-hook 'global-company-mode)

;; lsp settings
(require 'lsp-mode)
(add-hook 'go-mode-hook #'lsp-deferred)
(add-hook 'sh-mode-hook #'lsp-deferred)
(add-hook 'c++-mode-hook #'lsp)
(add-hook 'c-mode-hook #'lsp)

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

;; treemacs
(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay      0.5
          treemacs-directory-name-transformer    #'identity
          treemacs-display-in-side-window        t
          treemacs-eldoc-display                 t
          treemacs-file-event-delay              5000
          treemacs-file-extension-regex          treemacs-last-period-regex-value
          treemacs-file-follow-delay             0.2
          treemacs-file-name-transformer         #'identity
          treemacs-follow-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-move-forward-on-expand        nil
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                      'left
          treemacs-read-string-input             'from-child-frame
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-asc
          treemacs-space-between-root-nodes      t
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-user-mode-line-format         nil
          treemacs-user-header-line-format       nil
          treemacs-width                         35
          treemacs-workspace-switch-cleanup      nil)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode 'always)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :after (treemacs dired)
  :ensure t
  :config (treemacs-icons-dired-mode))

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

;; windmove
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; company yas integration
(global-set-key (kbd "C-c y") 'company-yasnippet)

(require 'keyfreq)
(keyfreq-mode 1)
(keyfreq-autosave-mode 1)

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
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(global-visual-line-mode t)
(global-disable-mouse-mode)

;; Org sort entire buffer
(defun org-sort-buffer ()
  "go to the top of the buffer and sort the file"
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
(global-set-key (kbd "C-c f") 'helm-projectile-find-file)

;; blogging using hugo
(use-package ox-hugo
  :ensure t            ;Auto-install the package from Melpa (optional)
  :after ox)

;; mac switch meta key
(setq mac-option-modifier 'meta)
(setq mac-command-modifier 'hyper)
