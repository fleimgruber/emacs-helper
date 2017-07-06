;;; eh-devtools.el --- Tools for emacs-helper

;; * Header
;; Copyright 2015 Feng Shu

;; Author: Feng Shu <tumashu@163.com>
;; URL: https://github.com/tumashu/emacs-helper
;; Version: 0.0.1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

;;; Commentary:

;; * 说明文档                                                              :doc:

;;; Code:

;; * 代码                                                                 :code:
(require 'emacs-helper)
(require 'org-webpage)
(require 'owp-web-server)
(require 'owp-el2org)

(defvar eh-website-repository
  "~/project/emacs-packages/emacs-helper/")

(owp/add-project-config
 '("emacs-helper"
   :repository-directory (:eval eh-website-repository)
   :remote (git "https://github.com/tumashu/emacs-helper.git" "gh-pages")
   :site-domain "https://tumashu.github.io/emacs-helper"
   :site-main-title "Emacs-helper"
   :site-sub-title "(Tumashu 的 emacs 配置)"
   :default-category "documents"
   :theme (worg killjs)
   :force-absolute-url t
   :source-browse-url ("GitHub" "https://github.com/tumashu/emacs-helper")
   :category-ignore-list ("themes" "assets" "uploaders" "elpa")
   :personal-avatar nil
   :preparation-function owp/el2org-preparation-function
   :org-export-function owp/el2org-org-export-function
   :lentic-doc-sources ("eh-.*\\.el$")
   :lentic-readme-sources ("emacs-helper.el")
   :lentic-index-sources ("emacs-helper.el")
   :web-server-port 8765))

;; * Footer
(provide 'eh-devtools)

;; Local Variables:
;; no-byte-compile: t
;; End:

;;; eh-devtools.el ends here
