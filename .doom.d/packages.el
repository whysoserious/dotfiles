;; -*- no-byte-compile: t; -*-
;;; ~/.doom.d/packages.el

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:fetcher github :repo "username/repo"))
;; (package! builtin-package :disable t)

(packages!
  ag
  elixir-yasnippets
  lsp-mode
  persistent-scratch
  super-save
  window-numbering)

(package! persp-mode :disable t)
; (package! flycheck-credo :disable t)
