;; TODO: https://github.com/akirak/emacs-config

(setq inhibit-startup-screen t) ; hide emacs info screen
(setq inhibit-startup-message t) ; ??

(tool-bar-mode -1) ; hide toolbar
(menu-bar-mode -1) ; hide menu
(toggle-scroll-bar -1) ; hide scrollbar

(setq line-number-mode t) ; show line number in status line
(setq column-number-mode t) ; show line column in status line
(setq size-indication-mode t) ; show lin

;;; fonts
(set-frame-font "Terminus 10" nil t)

;;; colorscheme
(set-foreground-color "white")
(set-background-color "black")

;;= completions (not used; see "vertico" plugin)
(setq completions-format 'one-column) ; because minibuffer-next-completion goes right, not down
(setq completion-auto-help 'always) ; always show window with completions list
(setq completion-auto-select 'second-tab)
;;~(setq completion-auto-select t)
;;~(setq completion-cycle-threshold t)
;;~(modify-syntax-entry ?- "w" emacs-lisp-mode-syntax-table)
;;~(modify-syntax-entry ?_ "w" emacs-lisp-mode-syntax-table)
;; TODO: https://www.masteringemacs.org/article/understanding-minibuffer-completion
;;~(setq ido-enable-flex-matching t)
;;~(setq ido-everywhere t)
;;~(ido-mode 1)

;;= package manager
;; users of Emacs versions >= 27 will want to add this line to their early init-file to
;; prevent package.el loading packages prior to their init-file loading:
(setq package-enable-at-startup nil)

;; straight.el: setup
;; https://github.com/radian-software/straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
       'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; straight.el: packages
(straight-use-package 'devdocs)
(straight-use-package 'magit)

(straight-use-package 'evil) ; evil mode
(evil-mode 1)

(straight-use-package 'vertico)
;; verttico: sort directories before files
(defun vertico-my-sort-directories-first (files)
  (setq files (vertico-sort-history-length-alpha files))
  (nconc (seq-filter (lambda (x) (string-suffix-p "/" x)) files)
         (seq-remove (lambda (x) (string-suffix-p "/" x)) files)))
(custom-set-variables
 '(vertico-scroll-margin 0)
 '(vertico-resize t)
 '(vertico-count 50)
 '(vertico-multiform-categories
   '((symbol (vertico-sort-function . vertico-sort-alpha))
     (file (vertico-sort-function . vertico-my-sort-directories-first))))
 )
(vertico-mode)

;;(straight-use-package 'consult) -- TODO

;;= package manager: END

;; devdocs cache & update
;;()

;; TODO: https://git.sr.ht/~pkal/setup ;; https://www.emacswiki.org/emacs/SetupEl

;;= info
;; (if window-system ...)
;; C-h b : list all the bindings available in a buffer
;; C-h m : show help for current major and minor modes and their commands
;; C-M i : completion
