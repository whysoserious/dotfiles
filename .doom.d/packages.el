;; -*- no-byte-compile: t; -*-
;;; ~/.doom.d/packages.el

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:fetcher github :repo "username/repo"))
;; (package! builtin-package :disable t)

(packages!
  ag
  elixir-yasnippets
  persistent-scratch
  super-save
  window-numbering)

(packages!
 company-lsp
 dap-mode
 lsp-mode
 lsp-ui)

(package! flycheck-credo :disable t)
(package! magit-gitflow :disable t)
(package! persp-mode :disable t)
