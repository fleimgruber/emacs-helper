;;; eh-misc.el --- Tumashu's emacs configuation

;; * Header
;; Copyright (c) 2011-2016, Feng Shu

;; Author: Feng Shu <tumashu@163.com>
;; URL: https://github.com/tumashu/emacs-helper
;; Version: 0.0.1

;; This file is not part of GNU Emacs.

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; * 简介                                                  :README:
;;  这个文件是tumashu个人专用的emacs配置文件，emacs中文用户可以参考。

;;; Code:

;; * 代码                                                      :code:
;; ** eh-website
(use-package org2web
  :config
  ;; my website's org2web config
  (use-package eh-website :ensure nil)
  ;; org2web's org2web config
  (use-package org2web-devtools :ensure nil)
  (use-package pyim
    :ensure nil
    :config
    ;; pyim org2web config
    (use-package pyim-devtools :ensure nil)))

;; ** el2org
(use-package el2org)

;; ** EPG
(use-package epg
  :config
  ;; 1. Put the below to your ~/.gnupg/gpg-agent.conf:
  ;;       allow-emacs-pinentry
  ;;       allow-loopback-pinentry
  ;; 2. gpgconf --reload gpg-agent
  ;; 3. (setq epa-pinentry-mode 'loopback)
  ;; 4. (pinentry-start)
  (setq epa-pinentry-mode 'loopback))

;; ** emms
(use-package eh-emms :ensure nil)

;; ** elisp setting
(use-package lisp-mode
  :ensure nil
  :config
  (use-package aggressive-indent
    :config
    (defun eh-elisp-setup ()
      ;; 跟踪行尾空格
      (setq show-trailing-whitespace t)
      ;; 高亮TAB
      (setq highlight-tabs t)
      ;; 自动缩进
      (aggressive-indent-mode))
    (add-hook 'emacs-lisp-mode-hook
              #'eh-elisp-setup)))

;; ** ESS
(use-package ess
  :ensure nil
  :config
  (setq ess-eval-visibly-p nil)
  (setq ess-ask-for-ess-directory nil)
  (setq ess-smart-S-assign-key "@")

  (defun eh-ess-popup-ESS-buffer (eob-p)
    (interactive "P")
    (ess-force-buffer-current)
    (let ((buffer (current-buffer)))
      (ess-switch-to-ESS eob-p)
      (ess-show-buffer buffer t)))

  (defun eh-ess-eval-paragraph (vis)
    (interactive "P")
    (ess-eval-paragraph-and-step vis)
    (eh-ess-popup-ESS-buffer t))

  :bind (:map
         ess-mode-map
         ("C-c C-c" . eh-ess-eval-paragraph)))

;; ** aggressive-indent
(use-package aggressive-indent)

;; ** autopair
(use-package autopair
  :config
  (autopair-global-mode 1))

;; ** multi-term
(use-package multi-term
  :ensure nil
  :config
  (setq multi-term-program "/bin/bash")
  (setq multi-term-buffer-name "term")
  (setq term-scroll-show-maximum-output nil)
  (setq term-scroll-to-bottom-on-output nil)
  (setq multi-term-dedicated-select-after-open-p t)
  (setq term-bind-key-alist
        (append '(("C-c C-x" . eh-term-send-ctrl-x)
                  ("C-c C-h" . eh-term-send-ctrl-h))
                term-bind-key-alist))

  (remove-hook 'term-mode-hook 'eh-term-setup)
  (remove-hook 'term-mode-hook 'multi-term-keystroke-setup)
  (remove-hook 'kill-buffer-hook 'multi-term-kill-buffer-hook)

  (add-hook 'term-mode-hook #'eh-term-setup)
  (add-hook 'term-mode-hook #'multi-term-keystroke-setup)
  (add-hook 'kill-buffer-hook #'multi-term-kill-buffer-hook)

  (defun eh-term-setup ()
    (setq truncate-lines t)
    (setq term-buffer-maximum-size 0)
    (setq show-trailing-whitespace nil)
    (multi-term-handle-close))

  (defun eh-term-send-ctrl-x ()
    "Send C-x in term mode."
    (interactive)
    (term-send-raw-string "\C-x"))

  (defun eh-term-send-ctrl-z ()
    "Send C-z in term mode."
    (interactive)
    (term-send-raw-string "\C-z"))

  (defun eh-term-send-ctrl-h ()
    "Send C-h in term mode."
    (interactive)
    (term-send-raw-string "\C-h")))

;; ** wdired and dired-ranger
(use-package dired
  :ensure nil
  :config
  (use-package wdired :ensure nil)
  (use-package dired-ranger :ensure nil))

;; ** ace-jump
(use-package ace-jump-mode
  :ensure nil
  :bind (("C-j" . ace-jump-mode)))

;; ** switch-window
(use-package switch-window
  :bind (("C-x o" . switch-window)
         ("C-x 1" . switch-window-then-maximize)
         ("C-x 2" . switch-window-then-split-below)
         ("C-x 3" . switch-window-then-split-right)
         ("C-x 0" . switch-window-then-delete))
  :config
  (setq switch-window-increase 6)
  (setq switch-window-shortcut-style 'qwerty)
  (setq switch-window-input-style 'minibuffer))

;; ** gitpatch
(use-package gitpatch
  :bind (("C-c m" . eh-gitpatch-mail))
  :ensure nil
  :config
  (setq gitpatch-mail-function 'gnus-msg-mail)
  (setq gitpatch-mail-attach-patch-key "C-c i")
  (setq gitpatch-mail-database
        '("guix-patches@gnu.org"
          "emms-help@gnu.org"
          "emacs-orgmode@gnu.org"
          "emacs-devel@gnu.org"))
  (defun eh-gitpatch-mail ()
    (interactive)
    ;; 如果 gnus 没有开启，强制开启。
    (let ((buffer (current-buffer)))
      (unless (gnus-alive-p)
        (gnus)
        (switch-to-buffer buffer))
      (call-interactively 'gitpatch-mail))))

;; ** ebdb
(use-package ebdb
  :ensure nil
  :config
  (require 'ebdb-mua)
  (require 'ebdb-gnus)
  (require 'ebdb-com)
  (require 'ebdb-vcard)
  (require 'ebdb-complete)
  (ebdb-complete-enable)

  (use-package pyim
    :config
    (use-package ebdb-i18n-chn)
    ;; (defun eh-ebdb-search-chinese (string)
    ;;   (if (functionp 'pyim-isearch-build-search-regexp)
    ;;       (pyim-isearch-build-search-regexp string)
    ;;     string))

    ;; (setq ebdb-search-transform-functions
    ;;       '(eh-ebdb-search-chinese))
    (cl-defmethod ebdb-field-search
        :around (field criterion)
        (or (cl-call-next-method)
            (when (stringp criterion)
              (let ((str (ebdb-string field)))
                (cl-some
                 (lambda (pinyin)
                   (string-match-p criterion pinyin))
                 (append (pyim-hanzi2pinyin str nil "" t)
                         (pyim-hanzi2pinyin str t "" t)))))))))

;; ** magit
(use-package magit
  :bind (("C-c g" . magit-status)
         :map magit-status-mode-map
         ("C-c f" . magit-format-patch))
  :config
  (use-package swiper
    :config
    (setq magit-completing-read-function 'ivy-completing-read)))

;; ** projectile
(use-package projectile
  :bind (("C-x F" . projectile-find-file)
         ("C-S-s" . projectile-grep))
  :config
  (use-package swiper
    :ensure nil
    :config (setq projectile-completion-system 'ivy))
  (use-package wgrep
    :config
    (projectile-global-mode 1)
    (setq projectile-enable-caching nil)))

;; ** guix
(use-package guix
  :ensure nil
  :config
  (setq guix-directory "~/project/guix")
  (setq geiser-debug-jump-to-debug-p nil)
  (setq geiser-guile-binary
        (list (executable-find "guile")
              ;; Avoid auto-compilation as it is slow and error-prone:
              ;; <https://notabug.org/alezost/emacs-guix/issues/2>.
              "--no-auto-compile"))
  (add-hook 'after-init-hook 'global-guix-prettify-mode)
  (add-hook 'scheme-mode-hook 'guix-devel-mode)
  (with-eval-after-load 'geiser-guile
    (add-to-list 'geiser-guile-load-path "~/.config/guix/latest")))

;; ** undo-tree
(use-package undo-tree
  :bind (("C-c /" . undo-tree-visualize))
  :config
  (global-undo-tree-mode)
  (add-hook 'undo-tree-visualizer-mode-hook
            #'eh-undo-tree-visualizer-settings)
  (defun eh-undo-tree-visualizer-settings ()
    (interactive)
    (define-key undo-tree-visualizer-mode-map (kbd "C-c C-k") #'undo-tree-visualizer-quit)
    (define-key undo-tree-visualizer-mode-map (kbd "C-k") #'undo-tree-visualizer-quit)
    (define-key undo-tree-visualizer-mode-map (kbd "k") #'undo-tree-visualizer-quit)
    (define-key undo-tree-visualizer-mode-map (kbd "C-g") #'undo-tree-visualizer-abort)))

;; * Footer
(provide 'eh-misc)

;; Local Variables:
;; coding: utf-8-unix
;; no-byte-compile: t
;; End:

;;; eh-misc.el ends here
