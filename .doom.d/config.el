;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Fix keybindings
(global-set-key (kbd "M-v") 'scroll-down-command)
(global-set-key (kbd "C-c s") 'window-swap-states)

;; disable suspend-frame
(global-set-key (kbd "C-z") nil)

;; Un-popup some buffers
(set-popup-rule! "\\*shell.**\\*" :ignore t)
(set-popup-rule! "\\*test*\\*" :ignore t)

;; Set default syntax for re-builder
(setq reb-re-syntax 'string)

;; Smooth mouse scrolling
(setq mouse-wheel-scroll-amount '(2 ((shift) . 1))  ; scroll two lines at a time
      mouse-wheel-progressive-speed nil             ; don't accelerate scrolling
      mouse-wheel-follow-mouse t                    ; scroll window under mouse
      scroll-step 1)

;; Change projectile prefixes
(after! projectile
  (setq persp-keymap-prefix (kbd "C-c e")
        projectile-keymap-prefix (kbd "C-c p"))
  (define-key projectile-mode-map (kbd "C-c p") #'projectile-command-map))

(after! ivy
  (setq ivy-use-virtual-buffers t))

(after! smerge
  (setq smerge-command-prefix (kbd "C-c ;")))

(def-package! magit
  :bind
  ("C-x g" . magit))

(def-package! yasnippet
  :config
  (yas-global-mode 1))

(def-package! elixir-yasnippets
  :after
  yasnippet)

(def-package! window-numbering
  :config
  (window-numbering-mode 1)
  :bind
  (("M-0" . select-window-0)
   ("M-1" . select-window-1)
   ("M-2" . select-window-2)
   ("M-3" . select-window-3)
   ("M-4" . select-window-4)
   ("M-5" . select-window-5)
   ("M-6" . select-window-6)
   ("M-7" . select-window-7)
   ("M-8" . select-window-8)
   ("M-9" . select-window-9)))

(def-package! persistent-scratch
  :config
  (persistent-scratch-setup-default))

(after! whitespace
  (setq whitespace-line-column 1000)
  (add-hook 'before-save-hook 'delete-trailing-whitespace)
  (add-hook 'prog-mode-hook
            (lambda () (setq show-trailing-whitespace t))))

(after! counsel
  (global-set-key (kbd "M-y") 'counsel-yank-pop))

(after! swiper
  (global-set-key (kbd "C-s") 'counsel-grep-or-swiper))

(after! super-save
  (super-save-mode +1)
  (setq super-save-auto-save-when-idle t))

(def-package! smartparens
  :hook ((prog-mode . smartparens-mode)
         (html-mode . smartparens-mode)
         (alchemist-iex-mode . smartparens-mode))
  :bind (:map smartparens-mode-map
          ("C-M-f" . sp-forward-sexp)
          ("C-M-b" . sp-backward-sexp)
          ("C-M-n" . sp-next-sexp)
          ("C-M-p" . sp-previous-sexp)
          ("C-M-d" . sp-down-sexp)
          ("C-M-e" . sp-up-sexp)
          ("C-M-a" . sp-backward-down-sexp)
          ("C-M-u" . sp-backward-up-sexp)
          ("C-S-a" . sp-beginning-of-sexp)
          ("C-S-d" . sp-end-of-sexp)
          ("C-M-k" . sp-kill-sexp)
          ("C-M-w" . sp-copy-sexp)
          ("C-M-t" . sp-transpose-sexp)
          ("M-<delete>" . sp-unwrap-sexp)
          ("M-<backspace>" . sp-backward-kill-sexp)
          ("C-<right>" . sp-forward-slurp-sexp)
          ("C-<left>" . sp-forward-barf-sexp)
          ("C-M-<left>" . sp-backward-slurp-sexp)
          ("C-M-<right>" . sp-backward-barf-sexp)
          ("M-D" . sp-splice-sexp)
          ("C-M-<delete>" . sp-splice-sexp-killing-forward)
          ("C-M-<backspace>" . sp-splice-sexp-killing-backward)
          ("C-S-<backspace>" . sp-splice-sexp-killing-around)
          ("C-]" . sp-select-next-thing-exchange)
          ("C-<left_bracket>" . sp-select-previous-thing)
          ("C-M-]" . sp-select-next-thing)
          ("M-F" . sp-forward-symbol)
          ("M-B" . sp-backward-symbol)
          ("H-t" . sp-prefix-tag-object)
          ("H-p" . sp-prefix-pair-object)
          ("H-s c" . sp-convolute-sexp)
          ("H-s a" . sp-absorb-sexp)
          ("H-s e" . sp-emit-sexp)
          ("H-s p" . sp-add-to-previous-sexp)
          ("H-s n" . sp-add-to-next-sexp)
          ("H-s j" . sp-join-sexp)
          ("H-s s" . sp-split-sexp)))

(def-package! alchemist
  :init
  (setq alchemist-hooks-compile-on-save nil
        alchemist-key-command-prefix (kbd "C-c x")
        alchemist-mix-command "~/.asdf/shims/mix"
        alchemist-iex-program-name "~/.asdf/shims/iex"
        alchemist-execute-command "~/.asdf/shims/elixir"
        alchemist-compile-command "~/.asdf/shims/elixirc")
  :config
  (add-hook 'elixir-mode-hook
            (lambda () (add-hook 'before-save-hook 'elixir-format nil t)))
  (add-to-list 'elixir-mode-hook 'alchemist-mode)
  (add-to-list 'elixir-mode-hook 'smartparens-mode)
  (set-popup-rule! "\\*Alchemist-IEx*\\*" :size 80))

(defun show-file-name ()
  "Show the full path file name in the minibuffer and put it into kill ring"
  (interactive)
  (message (buffer-file-name))
  (kill-new (file-truename buffer-file-name)))

(defun dos2unix ()
  "Not exactly but it's easier to remember"
  (interactive)
  (set-buffer-file-coding-system 'unix 't))

(defun copy-line (arg)
  "Copy lines (as many as prefix argument) in the kill ring.
      Ease of use features:
      - Move to start of next line.
      - Appends the copy on sequential calls.
      - Use newline as last char even on the last line of the buffer.
      - If region is active, copy its lines."
  (interactive "p")
  (let ((beg (line-beginning-position))
        (end (line-end-position arg)))
    (when mark-active
      (if (> (point) (mark))
          (setq beg (save-excursion (goto-char (mark)) (line-beginning-position)))
        (setq end (save-excursion (goto-char (mark)) (line-end-position)))))
    (if (eq last-command 'copy-line)
        (kill-append (buffer-substring beg end) (< end beg))
      (kill-ring-save beg end)))
  (kill-append "\n" nil)
  (beginning-of-line (or (and arg (1+ arg)) 2))
  (if (and arg (not (= 1 arg))) (message "%d lines copied" arg)))
(global-set-key "\C-c\C-k" 'copy-line)

(defun ascii-table ()
  "Display basic ASCII table (0 thru 128)."
  (interactive)
  (switch-to-buffer "*ASCII*")
  (erase-buffer)
  (setq buffer-read-only nil)        ;; Not need to edit the content, just read mode (added)
  (local-set-key "q" 'bury-buffer)   ;; Nice to have the option to bury the buffer (added)
  (save-excursion (let ((i -1))
                    (insert "ASCII characters 0 thru 127.\n\n")
                    (insert " Hex  Dec  Char|  Hex  Dec  Char|  Hex  Dec  Char|  Hex  Dec  Char\n")
                    (while (< i 31)
                      (insert (format "%4x %4d %4s | %4x %4d %4s | %4x %4d %4s | %4x %4d %4s\n"
                                      (setq i (+ 1  i)) i (single-key-description i)
                                      (setq i (+ 32 i)) i (single-key-description i)
                                      (setq i (+ 32 i)) i (single-key-description i)
                                      (setq i (+ 32 i)) i (single-key-description i)))
                      (setq i (- i 96))))))

(defun sh-send-line-or-region (&optional step)
  (interactive ())
  (let ((proc (get-process "shell"))
        pbuf min max command)
    (unless proc
      (let ((currbuff (current-buffer)))
        (shell)
        (switch-to-buffer currbuff)
        (setq proc (get-process "shell"))
        ))
    (setq pbuff (process-buffer proc))
    (if (use-region-p)
        (setq min (region-beginning)
              max (region-end))
      (setq min (point-at-bol)
            max (point-at-eol)))
    (setq command (concat (buffer-substring min max) "\n"))
    (with-current-buffer pbuff
      (goto-char (process-mark proc))
      (insert command)
      (move-marker (process-mark proc) (point))
      ) ;;pop-to-buffer does not work with save-current-buffer -- bug?
    (process-send-string  proc command)
    (display-buffer (process-buffer proc) t)
    (when step
      (goto-char max)
      (next-line))
    ))

(defun sh-send-line-or-region-and-step ()
  (interactive)
  (sh-send-line-or-region t))
(defun sh-switch-to-process-buffer ()
  (interactive)
  (pop-to-buffer (process-buffer (get-process "shell")) t))
