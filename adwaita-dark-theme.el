;;; adwaita-dark-theme.el --- A dark color scheme inspired by Adwaita -*- lexical-binding: t; -*-

;; Author: Jessie Hildebrandt <jessieh.net>
;; Homepage: https://gitlab.com/jessieh/adwaita-dark-theme
;; Keywords: mode-line faces
;; Version: 1.0.0
;; Package-Requires: ((emacs "27.1"))

;; This file is not part of GNU Emacs.

;;; Commentary:
;;
;; adwaita-dark is a dark color scheme that aims to replicate the
;; appearance and colors of GTK4 "libadwaita" applications.
;;
;; Features offered:
;; * Beautiful dark color scheme inspired by Adwaita
;; * Automatic 256-color mode support
;; * Custom fringe bitmaps for line continuations, visual-line-mode, diff-hl, flycheck, and flymake
;; * Custom configuration for neotree
;; * Lightweight with no dependencies
;;
;; To replace default line continuation/line wrap fringe bitmaps:
;; (adwaita-dark-theme-arrow-fringe-bmp-enable)
;;
;; To enable custom configuration for `neotree':
;; (eval-after-load 'neotree #'adwaita-dark-theme-neotree-configuration-enable)
;;
;; To enable custom fringe bitmaps for `diff-hl':
;; (setq diff-hl-fringe-bmp-function #'adwaita-dark-theme-diff-hl-fringe-bmp-function)
;;
;; To enable custom fringe bitmaps for `flycheck':
;; (eval-after-load 'flycheck #'adwaita-dark-theme-flycheck-fringe-bmp-enable)
;;
;; To enable custom fringe bitmaps for `flymake':
;; (eval-after-load 'flymake #'adwaita-dark-theme-flymake-fringe-bmp-enable)

;;; License:
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.

;;; Code:

;;
;; Ext. variable declarations
;;

(defvar neotree-dir-button-keymap)
(defvar neotree-file-button-keymap)
(defvar neo-global--window)

;;
;; Ext. function prototypes
;;

(declare-function neo-path--file-short-name "neotree" (file))
(declare-function neo-buffer--node-list-set "neotree" (line-num path))
(declare-function neo-buffer--newline-and-begin "neotree" ())
(declare-function neo-global--select-window "neotree" ())
(declare-function neo-buffer--insert-root-entry "neotree" (node))
(declare-function neo-buffer--insert-dir-entry "neotree" (node depth expanded))
(declare-function neo-buffer--insert-file-entry "neotree" (node depth))

(declare-function flycheck-redefine-standard-error-levels "flycheck" (&optional margin-str fringe-bitmap))

;;
;; Helper functions
;;

(defun adwaita-dark-theme--true-color-p ()
  "Return 't' if the frame is capable of displaying true colors."
  (or
   (display-graphic-p)
   (>= (tty-display-color-cells) 16777216)))

;;
;; Theme definition
;;

(deftheme adwaita-dark
  "A dark color scheme inspired by the libadwaita colors.")

(let ((class '((class color) (min-colors 256)))

      ;; =====================
      ;; -- Theme variables --
      ;; =====================

      ;; Layout/Sizing
      (mode-line-padding 10)

      ;; Base (Background) Colors
      ;; [True color | 256-compatible]
      (bg (if (adwaita-dark-theme--true-color-p) "#1e1e1e" "gray12"))     ;; #1f1f1f
      (bg-alt (if (adwaita-dark-theme--true-color-p) "#242424" "gray14")) ;; #242424
      (base-0 (if (adwaita-dark-theme--true-color-p) "#202020" "gray13")) ;; #212121
      (base-1 (if (adwaita-dark-theme--true-color-p) "#262626" "gray15")) ;; #262626
      (base-2 (if (adwaita-dark-theme--true-color-p) "#292929" "gray16")) ;; #292929
      (base-3 (if (adwaita-dark-theme--true-color-p) "#303030" "gray19")) ;; #303030
      (base-4 (if (adwaita-dark-theme--true-color-p) "#454545" "gray27")) ;; #454545
      (base-5 (if (adwaita-dark-theme--true-color-p) "#656565" "gray40")) ;; #666666
      (base-6 (if (adwaita-dark-theme--true-color-p) "#7b7b7b" "gray48")) ;; #7a7a7a
      (base-7 (if (adwaita-dark-theme--true-color-p) "#a5a5a5" "gray65")) ;; #a6a6a6
      (base-8 (if (adwaita-dark-theme--true-color-p) "#dfdfdf" "gray87")) ;; #dedede
      (fg (if (adwaita-dark-theme--true-color-p) "#deddda" "gray86"))     ;; #dbdbdb
      (fg-alt (if (adwaita-dark-theme--true-color-p) "#77767b" "gray47")) ;; #787878

      ;; Foreground Colors
      ;; [True color | 256-compatible]
      (gray (if (adwaita-dark-theme--true-color-p) "#3d3846" "gray23"))           ;; #3b3b3b
      (red (if (adwaita-dark-theme--true-color-p) "#ff6c6b" "indianred2"))        ;; #ee6363
      (orange (if (adwaita-dark-theme--true-color-p) "#ffa348" "orange2"))        ;; #ee9a00
      (green (if (adwaita-dark-theme--true-color-p) "#54d18c" "seagreen3"))       ;; #43cd80
      (teal (if (adwaita-dark-theme--true-color-p) "#5bc8af" "mediumaquamarine")) ;; #66cdaa
      (yellow (if (adwaita-dark-theme--true-color-p) "#f8e45c" "gold2"))          ;; #eec900
      (blue (if (adwaita-dark-theme--true-color-p) "#64a6f4" "steelblue2"))       ;; #5cacee
      (dark-blue (if (adwaita-dark-theme--true-color-p) "#1a5fb4" "dodgerblue4")) ;; #104e8b
      (magenta (if (adwaita-dark-theme--true-color-p) "#dd80de" "orchid3"))       ;; #cd69c9
      (pink (if (adwaita-dark-theme--true-color-p) "#edb8ee" "plum"))             ;; #dda0dd
      (violet (if (adwaita-dark-theme--true-color-p) "#7d8ac7" "mediumpurple3"))  ;; #8968cd
      (cyan (if (adwaita-dark-theme--true-color-p) "#7ee5ff" "mediumturquoise"))  ;; #48d1cc
      (dark-cyan (if (adwaita-dark-theme--true-color-p) "#6bacbd" "cadetblue")))  ;; #5f9ea0

  ;; Face Definitions
  (custom-theme-set-faces
   'adwaita-dark

   ;; ================
   ;; -- Core faces --
   ;; ================

   ;; default face
   `(default ((,class (:background ,bg :foreground ,fg))))

   ;; generic faces
   `(error ((,class (:foreground ,red))))
   `(warning ((,class (:foreground ,yellow))))
   `(success ((,class (:foreground ,green))))

   ;; emacs faces
   `(fringe ((,class (:inherit 'default :foreground ,base-4))))
   `(region ((,class (:background ,base-4 :foreground nil :distant-foreground ,fg))))
   `(highlight ((,class (:background ,blue :foreground ,base-0 :distant-foreground ,base-8))))
   `(cursor ((,class (:background ,fg))))
   `(shadow ((,class (:foreground ,base-5))))
   `(minibuffer-prompt ((,class (:foreground ,base-7))))
   `(tooltip ((,class (:background ,base-3 :foreground ,fg))))
   `(secondary-selection ((,class (:background ,gray))))
   `(lazy-highlight ((,class (:background ,dark-blue :foreground ,base-8 :distant-foreground ,base-0 :weight bold))))
   `(match ((,class (:background ,base-0 :foreground ,green :weight bold))))
   `(trailing-whitespace ((,class (:background ,red))))
   `(nobreak-space ((,class (:inherit 'default :underline nil))))
   `(vertical-border ((,class (:background ,bg-alt :foreground ,bg-alt))))
   `(link ((,class (:foreground ,blue :underline t :weight bold))))
   `(widget-single-line-field ((,class :background ,base-5)))
   `(widget-field ((,class (:inherit 'widget-single-line-field :extend t))))

   ;; font-lock
   `(font-lock-builtin-face ((,class (:foreground ,violet))))
   `(font-lock-comment-face ((,class (:foreground ,base-5))))
   `(font-lock-comment-delimiter-face ((,class (:inherit 'font-lock-comment-face))))
   `(font-lock-doc-face ((,class (:inherit 'font-lock-comment-face :foreground ,base-6))))
   `(font-lock-constant-face ((,class (:foreground ,violet))))
   `(font-lock-function-name-face ((,class (:foreground ,blue))))
   `(font-lock-keyword-face ((,class (:inherit 'bold :foreground ,orange))))
   `(font-lock-string-face ((,class (:foreground ,teal))))
   `(font-lock-type-face ((,class (:foreground ,teal))))
   `(font-lock-variable-name-face ((,class (:foreground ,fg))))
   `(font-lock-warning-face ((,class (:inherit 'warning))))
   `(font-lock-negation-char-face ((,class (:inherit 'bold :foreground ,blue))))
   `(font-lock-preprocessor-face ((,class (:inherit 'bold :foreground ,violet))))
   `(font-lock-preprocessor-char-face ((,class (:inherit 'bold :foreground ,violet))))
   `(font-lock-regexp-grouping-backslash ((,class (:inherit 'bold :foreground ,teal))))
   `(font-lock-regexp-grouping-construct ((,class (:inherit 'bold :foreground ,teal))))

   ;; mode-line / header-line
   `(mode-line ((,class (:background ,base-3 :foreground ,fg :box (:line-width ,mode-line-padding :color ,base-3)))))
   `(mode-line-inactive ((,class (:background ,bg-alt :foreground ,base-5 :box (:line-width ,mode-line-padding :color ,bg-alt)))))
   `(mode-line-emphasis ((,class (:foreground ,blue))))
   `(mode-line-highlight ((,class (:foreground ,fg))))
   `(mode-line-buffer-id ((,class (:foreground ,base-8 :weight bold))))
   `(header-line ((,class (:inherit 'mode-line-inactive ,base-6))))

   ;; ===============================
   ;; -- Built-in packages/plugins --
   ;; ===============================

   ;; ansi-colors
   `(ansi-color-bold ((,class (:weight bold))))
   `(ansi-color-black ((,class (:foreground "#464646" :background "#464646"))))
   `(ansi-color-red ((,class (:foreground "#ed333b" :background "#ed333b"))))
   `(ansi-color-green ((,class (:foreground "#57e389" :background "#57e389"))))
   `(ansi-color-yellow ((,class (:foreground "#ff7800" :background "#ff7800"))))
   `(ansi-color-blue ((,class (:foreground "#62a0ea" :background "#62a0ea"))))
   `(ansi-color-magenta ((,class (:foreground "#9141ac" :background "#9141ac"))))
   `(ansi-color-cyan ((,class (:foreground "#5bc8af" :background "#5bc8af"))))
   `(ansi-color-white ((,class (:foreground "#deddda" :background "#deddda"))))
   `(ansi-color-bright-black ((,class (:foreground "#9a9996" :background "#9a9996"))))
   `(ansi-color-bright-red ((,class (:foreground "#f66151" :background "#f66151"))))
   `(ansi-color-bright-green ((,class (:foreground "#8ff0a4" :background "#8ff0a4"))))
   `(ansi-color-bright-yellow ((,class (:foreground "#ffa348" :background "#ffa348"))))
   `(ansi-color-bright-blue ((,class (:foreground "#99c1f1" :background "#99c1f1"))))
   `(ansi-color-bright-magenta ((,class (:foreground "#dc8add" :background "#dc8add"))))
   `(ansi-color-bright-cyan ((,class (:foreground "#93ddc2" :background "#93ddc2"))))
   `(ansi-color-bright-white ((,class (:foreground "#f6f5f4" :background "#f6f5f4"))))

   ;; cperl
   `(cperl-array-face ((,class (:inherit 'font-lock-variable-name-face :weight bold))))
   `(cperl-hash-face ((,class (:inherit 'font-lock-variable-name-face :weight bold :slant italic))))
   `(cperl-nonoverridable-face ((,class (:inherit 'font-lock-builtin-face))))

   ;; consult
   `(consult-line-number-wrapped ((,class (:foreground ,base-7))))

   ;; compilation
   `(compilation-column-number ((,class (:inherit 'font-lock-comment-face))))
   `(compilation-line-number ((,class (:foreground ,blue))))
   `(compilation-error ((,class (:inherit 'error :weight bold))))
   `(compilation-warning ((,class (:inherit 'warning :slant italic))))
   `(compilation-info ((,class (:inherit 'success))))
   `(compilation-mode-line-exit ((,class (:inherit 'compilation-info))))
   `(compilation-mode-line-fail ((,class (:inherit 'compilation-error))))

   ;; completions
   `(completions-annotations ((,class (:inherit 'shadow))))
   `(completions-common-part ((,class (:foreground ,blue))))

   ;; custom
   `(custom-button ((,class (:background ,base-3 :foreground ,fg :box (:line-width 3 :color ,base-3)))))
   `(custom-button-pressed ((,class (:background ,base-4 :foreground ,fg :box (:line-width 3 :color ,base-4)))))
   `(custom-button-unraised ((,class (:inherit 'custom-button))))
   `(custom-button-pressed-unraised ((,class (:inherit 'custom-button-pressed))))
   `(custom-button-mouse ((,class (:inherit 'custom-button-pressed))))
   `(custom-variable-button ((,class (:inherit 'link :foreground ,green))))
   `(custom-saved ((,class (:foreground ,green :bold bold))))
   `(custom-comment ((,class (:foreground ,fg :background ,dark-blue))))
   `(custom-comment-tag ((,class (:foreground ,gray))))
   `(custom-modified ((,class (:foreground ,blue :bold bold))))
   `(custom-variable-tag ((,class (:foreground ,teal))))
   `(custom-visibility ((,class (:foreground ,blue :underline nil))))
   `(custom-group-subtitle ((,class (:foreground ,base-8 :weight bold))))
   `(custom-group-tag ((,class (:foreground ,base-8 :weight bold))))
   `(custom-group-tag-1 ((,class (:inherit 'custom-group-tag))))
   `(custom-set ((,class (:foreground ,yellow))))
   `(custom-themed ((,class (:foreground ,yellow))))
   `(custom-invalid ((,class (:foreground ,red :bold bold))))
   `(custom-variable-obsolete ((,class (:foreground ,gray))))
   `(custom-state ((,class (:foreground ,green :bold bold))))
   `(custom-changed ((,class (:foreground ,blue))))

   ;; diff-mode
   `(diff-added ((,class (:inherit 'hl-line :foreground ,green))))
   `(diff-changed ((,class (:foreground ,violet))))
   `(diff-context ((,class (:foreground ,fg-alt))))
   `(diff-removed ((,class (:background ,base-3 :foreground ,red))))
   `(diff-header ((,class (:background nil :foreground ,cyan))))
   `(diff-file-header ((,class (:background nil :foreground ,blue))))
   `(diff-hunk-header ((,class (:foreground ,violet))))
   `(diff-refine-added ((,class (:inherit 'diff-added :inverse-video t))))
   `(diff-refine-changed ((,class (:inherit 'diff-changed :inverse-video t))))
   `(diff-refine-removed ((,class (:inherit 'diff-removed :invertse-video t))))

   ;; dired
   `(dired-directory ((,class (:foreground ,magenta))))
   `(dired-ignored ((,class (:foreground ,base-5))))
   `(dired-flagged ((,class (:foreground ,red))))
   `(dired-header ((,class (:foreground ,blue :weight bold))))
   `(dired-mark ((,class (:foreground ,orange :weight bold))))
   `(dired-marked ((,class (:foreground ,magenta :weight bold))))
   `(dired-perm-write ((,class (:foreground ,fg :underline t))))
   `(dired-symlink ((,class (:foreground ,cyan :weight bold))))
   `(dired-warning ((,class (:foreground ,yellow))))

   ;; ediff
   `(ediff-fine-diff-A ((,class (:background ,base-4 :weight bold)))) ;; bg blend 0.7
   `(ediff-fine-diff-B ((,class (:inherit 'ediff-fine-diff-A))))
   `(ediff-fine-diff-C ((,class (:inherit 'ediff-find-diff-A))))
   `(ediff-current-diff-A ((,class (:background ,base-2)))) ;; bg blend 0.2
   `(ediff-current-diff-B ((,class (:inherit 'ediff-current-diff-A))))
   `(ediff-current-diff-C ((,class (:inherit 'ediff-current-diff-A))))
   `(ediff-even-diff-A ((,class (:inherit 'hl-line))))
   `(ediff-even-diff-B ((,class (:inherit 'ediff-even-diff-A))))
   `(ediff-even-diff-C ((,class (:inherit 'ediff-even-diff-A))))
   `(ediff-odd-diff-A ((,class (:inherit 'ediff-even-diff-A))))
   `(ediff-odd-diff-B ((,class (:inherit 'ediff-odd-diff-A))))
   `(ediff-odd-diff-C ((,class (:inherit 'ediff-odd-diff-A))))

   ;; elfeed
   `(elfeed-log-debug-level-face ((,class (:foreground ,base-5))))
   `(elfeed-log-error-level-face ((,class (:inherit 'error))))
   `(elfeed-log-info-level-face ((,class (:inherit 'success))))
   `(elfeed-log-warn-level-face ((,class (:inherit 'warning))))
   `(elfeed-search-date-face ((,class (:foreground ,violet))))
   `(elfeed-search-feed-face ((,class (:foreground ,blue))))
   `(elfeed-search-tag-face ((,class (:foreground ,base-5))))
   `(elfeed-search-title-face ((,class (:foreground ,base-5))))
   `(elfeed-search-filter-face ((,class (:foreground ,violet))))
   `(elfeed-search-unread-count-face ((,class (:foreground ,yellow))))
   `(elfeed-search-unread-title-face ((,class (:foreground ,fg :Weight bold))))

   ;; eshell
   `(eshell-prompt ((,class (:foreground ,teal :weight bold))))
   `(eshell-ls-archive ((,class (:foreground ,magenta))))
   `(eshell-ls-backup ((,class (:foreground ,base-7))))
   `(eshell-ls-clutter ((,class (:foreground ,base-5))))
   `(eshell-ls-directory ((,class (:foreground ,blue))))
   `(eshell-ls-executable ((,class (:foreground ,green))))
   `(eshell-ls-missing ((,class (:foreground ,base-5))))
   `(eshell-ls-product ((,class (:foreground ,teal))))
   `(eshell-ls-readonly ((,class (:foreground ,violet))))
   `(eshell-ls-special ((,class (:foreground ,magenta))))
   `(eshell-ls-symlink ((,class (:foreground ,cyan))))
   `(eshell-ls-unreadable ((,class (:foreground ,base-5))))

   ;; gdb
   `(breakpoint-enabled ((,class (:foreground ,red))))
   `(breakpoint-disabled ((,class (:foreground ,base-5))))

   ;; help
   `(help-key-binding ((,class (:foreground ,blue))))

   ;; hi-lock
   `(hi-yellow ((,class (:foreground ,yellow :inverse-video t))))
   `(hi-pink ((,class (:foreground ,pink :inverse-video t))))
   `(hi-green ((,class (:foreground ,green :inverse-video t))))
   `(hi-blue ((,class (:foreground ,blue :inverse-video t))))
   `(hi-salmon ((,class (:foreground ,orange :inverse-video t))))
   `(hi-aquamarine ((,class (:foreground ,teal :inverse-video t))))

   ;; hl-line
   `(hl-line ((,class (:background ,bg-alt :extend t))))

   ;; ido
   `(ido-first-match ((,class (:foreground ,orange))))
   `(ido-indicator ((,class (:background ,bg :foreground ,red))))
   `(ido-only-match ((,class (:foreground ,green))))
   `(ido-subdir ((,class (:foreground ,violet))))
   `(ido-virtual ((,class (:foreground ,base-5))))

   ;; isearch
   `(isearch ((,class (:background ,blue :foreground ,base-0 :weight bold))))

   ;; line-number
   `(line-number ((,class (:inherit 'default
                                    :foreground ,base-5 :distant-foreground nil
                                    :weight normal :italic nil :underline nil :strike-through nil))))
   `(line-number-current-line ((,class (:inherit 'hl-line 'default
                                                 :foreground ,fg :distant-foreground nil
                                                 :weight normal :italic nil :underline nil :strike-through nil))))

   ;; linum
   `(linum ((,class (:inherit 'line-number))))

   ;; make-file-*-mode
   `(makefile-targets ((,class (:foreground ,blue))))

   ;; message
   `(message-header-name ((,class (:foreground ,green))))
   `(message-header-subject ((,class (:foreground ,blue :weight bold))))
   `(message-header-to ((,class (:foreground ,blue :weight bold))))
   `(message-header-cc ((,class (:inherit 'message-header-to :foreground ,dark-blue))))
   `(message-header-other ((,class (:foreground ,violet))))
   `(message-header-newsgroups ((,class (:foreground ,yellow))))
   `(message-header-xheader ((,class (:foreground ,base-6))))
   `(message-separator ((,class (:foreground ,base-5))))
   `(message-mml ((,class (:foreground ,base-5 :slant italic))))
   `(message-cited-text ((,class (:foreground ,magenta))))

   ;; outline
   `(outline-1 ((,class (:foreground ,base-6 :weight bold))))
   `(outline-2 ((,class (:foreground ,base-7 :weight bold))))
   `(outline-3 ((,class (:foreground ,base-6 :weight bold))))
   `(outline-4 ((,class (:foreground ,base-5 :weight bold))))
   `(outline-5 ((,class (:foreground ,base-6 :weight bold))))
   `(outline-6 ((,class (:foreground ,base-7 :weight bold))))
   `(outline-7 ((,class (:foreground ,base-6 :weight bold))))
   `(outline-8 ((,class (:foreground ,base-5 :weight bold))))

   ;; pulse
   `(pulse-highlight-start-face ((,class (:background ,base-5 :extend t))))

   ;; show-paren
   `(show-paren-match ((,class (:foreground ,fg :weight ultra-bold))))
   `(show-paren-mismatch ((,class (:foreground ,red :weight ultra-bold))))

   ;; tab-line
   `(tab-line ((,class (:background ,bg-alt))))
   `(tab-line-tab ((,class (:background ,bg :foreground ,fg :box (:line-width ,mode-line-padding :color ,bg)))))
   `(tab-line-tab-inactive ((,class (:background ,bg-alt :foreground ,fg-alt :box (:line-width ,mode-line-padding :color ,bg-alt)))))
   `(tab-line-tab-current ((,class (:inherit 'tab-line-tab))))
   `(tab-line-highlight ((,class (:inherit 'tab-line-tab))))

   ;; tab-bar
   `(tab-bar ((,class (:background ,bg-alt))))
   `(tab-bar-tab ((,class (:background ,bg :foreground ,fg :box (:line-width ,mode-line-padding :color ,bg)))))
   `(tab-bar-tab-inactive ((,class (:background ,bg-alt :foreground ,fg-alt :box (:line-width ,mode-line-padding :color ,bg-alt)))))

   ;; term
   `(term ((,class (:foreground ,fg))))
   `(term-bold ((,class (:weight bold))))
   `(term-color-black ((,class (:foreground "#464646" :background "#464646"))))
   `(term-color-red ((,class (:foreground "#ed333b" :background "#ed333b"))))
   `(term-color-green ((,class (:foreground "#57e389" :background "#57e389"))))
   `(term-color-yellow ((,class (:foreground "#ff7800" :background "#ff7800"))))
   `(term-color-blue ((,class (:foreground "#62a0ea" :background "#62a0ea"))))
   `(term-color-magenta ((,class (:foreground "#9141ac" :background "#9141ac"))))
   `(term-color-cyan ((,class (:foreground "#5bc8af" :background "#5bc8af"))))
   `(term-color-white ((,class (:foreground "#deddda" :background "#deddda"))))
   `(term-color-bright-black ((,class (:foreground "#9a9996" :background "#9a9996"))))
   `(term-color-bright-red ((,class (:foreground "#f66151" :background "#f66151"))))
   `(term-color-bright-green ((,class (:foreground "#8ff0a4" :background "#8ff0a4"))))
   `(term-color-bright-yellow ((,class (:foreground "#ffa348" :background "#ffa348"))))
   `(term-color-bright-blue ((,class (:foreground "#99c1f1" :background "#99c1f1"))))
   `(term-color-bright-magenta ((,class (:foreground "#dc8add" :background "#dc8add"))))
   `(term-color-bright-cyan ((,class (:foreground "#93ddc2" :background "#93ddc2"))))
   `(term-color-bright-white ((,class (:foreground "#f6f5f4" :background "#f6f5f4"))))

   ;; window-divider
   `(window-divider ((,class (:inherit 'vertical-border))))
   `(window-divider-first-pixel ((,class (:inherit 'window-divider))))
   `(window-divider-last-pixel ((,class (:inherit 'window-divider))))

   ;; ===============================
   ;; -- External packages/plugins --
   ;; ===============================

   ;; anzu
   `(anzu-mode-line ((,class (:foreground ,blue))))
   `(anzu-replace-highlight ((,class (:background ,base-0 :foreground ,red :weight bold :strike-through t))))
   `(anzu-replace-to ((,class (:background ,base-0 :foreground ,green :weight bold))))

   ;; avy
   `(avy-background-face ((,class (:foreground ,base-5))))
   `(avy-lead-face ((,class (:background ,blue :foreground ,bg :distant-foreground ,fg :weight bold))))
   `(avy-lead-face-0 ((,class (:inherit 'avy-lead-face))))
   `(avy-lead-face-1 ((,class (:inherit 'avy-lead-face))))
   `(avy-lead-face-2 ((,class (:inherit 'avy-lead-face))))

   ;; bufler
   `(bufler-path ((,class (:inherit 'font-lock-string-face))))
   `(bufler-buffer-special ((,class (:inherit 'font-lock-builtin-face))))

   ;; company
   `(company-tooltip ((,class (:inherit 'tooltip))))
   `(company-tooltip-common ((,class (:foreground ,blue :distant-foreground ,base-0 :weight bold))))
   `(company-tooltip-search ((,class (:background ,blue :foreground ,bg :distant-foreground ,fg :weight bold))))
   `(company-tooltip-search-selection ((,class (:background ,dark-cyan :weight bold))))
   `(company-tooltip-selection ((,class (:background ,dark-blue :weight bold))))
   `(company-tooltip-mouse ((,class (:background ,magenta :foreground ,bg :distant-foreground ,fg))))
   `(company-tooltip-annotation ((,class (:foreground ,violet :distant-foreground ,bg))))
   `(company-scrollbar-bg ((,class (:inherit 'tooltip))))
   `(company-scrollbar-fg ((,class (:background ,blue))))
   `(company-preview ((,class (:foreground ,base-5))))
   `(company-preview-common ((,class (:background ,base-3 :foreground ,blue))))
   `(company-preview-search ((,class (:inherit 'company-tooltip-search))))
   `(company-template-field ((,class (:inherit 'match))))

   ;; company-box
   `(company-box-candidate ((,class (:foreground ,fg))))

   ;; corfu
   `(corfu-default ((,class (:background ,base-3 :foreground ,base-8))))
   `(corfu-current ((,class (:background ,base-4))))
   `(corfu-bar ((,class (:background ,base-5))))
   `(corfu-border ((,class (:background ,base-3))))
   `(corfu-echo ((,class (:inherit 'font-lock-doc-face))))

   ;; diff-hl
   `(diff-hl-change ((,class (:foreground ,orange))))
   `(diff-hl-delete ((,class (:foreground ,red))))
   `(diff-hl-insert ((,class (:foreground ,green))))

   ;; fic-mode
   `(fic-face ((,class (:foreground ,violet :weight bold))))

   ;; flx-ido
   `(flx-highlight-face ((,class (:foreground ,yellow :weight bold :underline nil))))

   ;; flycheck
   `(flycheck-error ((,class (:underline (:color ,red)))))
   `(flycheck-warning ((,class (:underline (:color ,yellow)))))
   `(flycheck-info ((,class (:underline (:color ,green)))))
   `(flycheck-error-list-highlight ((,class (:inherit hl-line :weight bold))))
   `(flycheck-error-list-id-with-explainer ((,class (:inherit (flycheck-error-list-id button)))))
   `(flycheck-verify-select-checker ((,class (:inherit 'button))))

   ;; flycheck-posframe
   `(flycheck-posframe-face ((,class (:inherit 'default))))
   `(flycheck-posframe-background-face ((,class (:background ,bg-alt))))
   `(flycheck-posframe-error-face ((,class (:inherit 'flycheck-posframe-face :foreground ,red))))
   `(flycheck-posframe-info-face ((,class (:inherit 'flycheck-posframe-face :foreground ,fg))))
   `(flycheck-posframe-warning-face ((,class (:inherit 'flycheck-posframe-face :foreground ,yellow))))

   ;; flymake
   `(flymake-error ((,class (:underline (:color ,red)))))
   `(flymake-note ((,class (:underline (:color ,green)))))
   `(flymake-warning ((,class (:underline (:color ,orange)))))

   ;; flyspell
   `(flyspell-incorrect ((,class (:inherit 'unspecified :underline (:color ,red)))))

   ;; git-gutter
   `(git-gutter:modified ((,class (:foreground ,orange))))
   `(git-gutter:added ((,class (:foreground ,green))))
   `(git-gutter:deleted ((,class (:foreground ,red))))

   ;; git-gutter+
   `(git-gutter+-modified ((,class (:background nil :foreground ,orange))))
   `(git-gutter+-added ((,class (:background nil :foreground ,green))))
   `(git-gutter+-deleted ((,class (:background nil :foreground ,red))))

   ;; git-gutter-fringe
   `(git-gutter-fr:modified ((,class (:inherit 'git-gutter:modified))))
   `(git-gutter-fr:added ((,class (:inherit 'git-gutter:added))))
   `(git-gutter-fr:deleted ((,class (:inherit 'git-gutter:deleted))))

   ;; helm
   `(helm-selection ((,class (:inherit 'bold :background ,dark-blue :distant-foreground ,blue))))
   `(helm-match ((,class (:inherit 'bold :foreground ,blue :distant-foreground ,base-8))))
   `(helm-source-header ((,class (:background ,base-2 :foreground ,base-5))))
   `(helm-swoop-target-line-face ((,class (:foreground ,blue :inverse-video t))))
   `(helm-visible-mark ((,class (:inherit (bold highlight)))))
   `(helm-ff-file ((,class (:foreground ,fg))))
   `(helm-ff-prefix ((,class (:foreground ,blue))))
   `(helm-ff-dotted-directory ((,class (:foreground ,gray))))
   `(helm-ff-directory ((,class (:foreground ,pink))))
   `(helm-ff-executable ((,class (:inherit 'italic :foreground ,base-8))))
   `(helm-grep-match ((,class (:foreground ,blue :distant-foreground ,red))))
   `(helm-grep-file ((,class (:foreground ,cyan))))
   `(helm-grep-lineno ((,class (:foreground ,base-5))))
   `(helm-grep-finish ((,class (:foreground ,green))))
   `(helm-swoop-target-line-face ((,class (:foreground ,blue :inverse-video t))))
   `(helm-swoop-target-line-block-face ((,class (:foreground ,yellow))))
   `(helm-swoop-target-word-face ((,class (:inherit 'bold :foreground ,green))))
   `(helm-swoop-target-number-face ((,class (:foreground ,base-5))))

   ;; highlight-indentation-mode
   `(highlight-indentation-face ((,class (:inherit 'hl-line))))
   `(highlight-indentation-current-column-face ((,class (:background ,base-1))))
   `(highlight-indentation-guides-odd-face ((,class (:inherit 'highlight-indentation-face))))
   `(highlight-indentation-guides-even-face ((,class (:inherit 'highlight-indentation-face))))

   ;; hlinum
   `(linum-highlight-face ((,class (:foreground ,fg :distant-foreground nil :weight normal))))

   ;; hl-todo
   `(hl-todo ((,class (:foreground ,yellow :weight bold))))

   ;; hydra
   `(hydra-face-red ((,class (:foreground ,red :weight bold))))
   `(hydra-face-blue ((,class (:foreground ,blue :weight bold))))
   `(hydra-face-amaranth ((,class (:foreground ,magenta :weight bold))))
   `(hydra-face-pink ((,class (:foreground ,violet :weight bold))))
   `(hydra-face-teal ((,class (:foreground ,teal :weight bold))))

   ;; ido-vertical-mode
   `(ido-vertical-match-face ((,class (:foreground ,blue :underline nil))))

   ;; ivy
   `(ivy-current-match ((,class (:background ,base-4 :distant-foreground nil))))
   `(ivy-minibuffer-match-face-1 ((,class (:background nil :foreground ,gray :weight light))))
   `(ivy-minibuffer-match-face-2 ((,class (:inherit 'ivy-minibuffer-match-face-1 :background ,base-1 :foreground ,magenta :weight semi-bold))))
   `(ivy-minibuffer-match-face-3 ((,class (:inherit 'ivy-minibuffer-match-face-2 :foreground ,green :weight semi-bold))))
   `(ivy-minibuffer-match-face-4 ((,class (:inherit 'ivy-minibuffer-match-face-2 :foreground ,yellow :weight semi-bold))))
   `(ivy-minibuffer-match-highlight ((,class (:foreground ,teal))))
   `(ivy-highlight-face ((,class (:foreground ,teal))))
   `(ivy-confirm-face ((,class (:foreground ,green))))
   `(ivy-match-required-face ((,class (:foreground ,red))))
   `(ivy-virtual ((,class (:inherit 'italic :foreground ,base-5))))
   `(ivy-modified-buffer ((,class (:inherit 'bold :foreground ,orange))))

   ;; ivy-posframe
   `(ivy-posframe ((,class (:background ,bg-alt))))

   ;; linum-relative
   `(linum-relative-current-face ((,class (:inherit 'line-number-current-line))))

   ;; lsp
   `(lsp-face-highlight-textual ((,class (:background ,base-4 :distant-foreground ,base-0))))
   `(lsp-face-highlight-read ((,class (:background ,base-4 :distant-foreground ,base-0))))
   `(lsp-face-highlight-write ((,class (:background ,base-4 :distant-foreground ,base-0))))

   ;; lsp-ui-doc
   `(lsp-ui-doc-background ((,class (:background ,base-3))))
   `(lsp-ui-doc-header ((,class (:background ,base-0 :bold bold :box (:line-width 5 :color ,base-0)))))

   ;; lsp-ui-peek
   `(lsp-ui-peek-filename ((,class (:inherit 'mode-line-buffer-id))))
   `(lsp-ui-peek-header ((,class (:background ,base-0 :foreground ,fg :bold bold :box (:line-width 5 :color ,base-0)))))
   `(lsp-ui-peek-footer ((,class (:background ,base-3))))
   `(lsp-ui-peek-selection ((,class (:background ,blue :foreground ,bg :bold bold))))
   `(lsp-ui-peek-list ((,class (:background ,base-3))))
   `(lsp-ui-peek-peek ((,class (:background ,base-3))))
   `(lsp-ui-peek-highlight ((,class (:background ,orange :foreground ,base-0))))
   `(lsp-ui-peek-line-number ((,class (:foreground ,base-5))))

   ;; lsp-ui-sideline
   `(lsp-ui-sideline ((,class (:foreground ,yellow))))

   ;; magit
   `(magit-bisect-bad ((,class (:foreground ,red))))
   `(magit-bisect-good ((,class (:foreground ,green))))
   `(magit-bisect-skip ((,class (:foreground ,orange))))
   `(magit-blame-date ((,class (:foreground ,red))))
   `(magit-blame-heading ((,class (:background ,base-3 :foreground ,orange))))
   `(magit-branch-current ((,class (:foreground ,cyan))))
   `(magit-branch-local ((,class (:foreground ,blue))))
   `(magit-branch-remote ((,class (:foreground ,green))))
   `(magit-cherry-equivalent ((,class (:foreground ,violet))))
   `(magit-cherry-unmatched ((,class (:foreground ,cyan))))
   ;; magit-diff-added
   ;; magit-diff-added-highlight
   ;; magit-diff-base
   ;; magit-diff-base-highlight
   ;; magit-diff-context
   ;; magit-diff-context-highlight
   `(magit-diff-file-heading ((,class (:foreground ,base-7 :weight bold))))
   `(magit-diff-file-heading-selection ((,class (:foreground ,base-8 :weight bold))))
   ;; magit-magit-diff-hunk-heading
   `(magit-diff-hunk-heading-highlight ((,class (:background ,fg :foreground ,bg :weight bold))))
   ;; magit-diff-removed
   ;; magit-diff-removed-highlight
   `(magit-diff-lines-heading ((,class (:background ,red :foreground ,yellow))))
   `(magit-diffstat-added ((,class (:foreground ,green))))
   `(magit-diffstat-removed ((,class (:foreground ,red))))
   `(magit-dimmed ((,class (:foreground ,base-5))))
   `(magit-hash ((,class (:foreground ,base-5))))
   `(magit-header-line ((,class (:inherit 'header-line))))
   `(magit-log-author ((,class (:foreground ,blue))))
   `(magit-log-date ((,class (:foreground ,base-5))))
   `(magit-log-graph ((,class (:foreground ,base-5))))
   `(magit-process-ng ((,class (:inherit 'error))))
   `(magit-process-ok ((,class (:inherit 'success))))
   `(magit-reflog-amend ((,class (:foreground ,magenta))))
   `(magit-reflog-checkout ((,class (:foreground ,blue))))
   `(magit-reflog-cherry-pick ((,class (:foreground ,green))))
   `(magit-reflog-commit ((,class (:foreground ,green))))
   `(magit-reflog-merge ((,class (:foreground ,green))))
   `(magit-reflog-other ((,class (:foreground ,cyan))))
   `(magit-reflog-rebase ((,class (:foreground ,magenta))))
   `(magit-reflog-remote ((,class (:foreground ,cyan))))
   `(magit-reflog-reset ((,class (:inherit 'error))))
   `(magit-refname ((,class (:foreground ,base-5))))
   `(magit-section-heading ((,class (:foreground ,base-7 :weight bold))))
   `(magit-section-heading-selection ((,class (:foreground ,base-8 :weight bold))))
   `(magit-section-highlight ((,class (:inherit 'hl-line))))
   `(magit-sequence-drop ((,class (:foreground ,red))))
   `(magit-sequence-head ((,class (:foreground ,blue))))
   `(magit-sequence-part ((,class (:foreground ,orange))))
   `(magit-sequence-stop ((,class (:foreground ,green))))
   `(magit-signature-bad ((,class (:inherit 'error))))
   `(magit-signature-error ((,class (:inherit 'error))))
   `(magit-signature-expired ((,class (:foreground ,orange))))
   `(magit-signature-good ((,class (:inherit 'success))))
   `(magit-signature-revoked ((,class (:foreground ,magenta))))
   `(magit-signature-untrusted ((,class (:foreground ,yellow))))
   `(magit-tag ((,class (:foreground ,teal))))
   `(magit-filename ((,class (:foreground ,violet))))
   `(magit-section-secondary-heading ((,class (:foreground ,violet :weight bold))))
   `(git-commit-summary ((,class (:foreground ,base-8 :weight bold))))
   `(git-commit-overlong-summary ((,class (:foreground ,base-7 :weight bold :strike-through t))))
   `(git-commit-nonempty-second-line ((,class (:foreground ,base-7 :strike-through t))))
   `(git-commit-known-pseudo-header ((,class (:inherit 'git-commit-pseudo-header))))
   `(git-commit-comment-heading ((,class (:foreground ,base-7))))
   `(git-commit-comment-branch-local ((,class (:inherit 'magit-branch-local))))
   `(git-commit-comment-branch-remote ((,class (:inherit 'magit-branch-remote))))

   ;; mic-paren
   `(paren-face-match ((,class (:inherit 'show-paren-match))))
   `(paren-face-mismatch ((,class (:inherit 'show-paren-mismatch))))
   `(paren-face-no-match ((,class (:inherit 'show-paren-mismatch))))

   ;; mood-line
   `(mood-line-status-info ((,class (:foreground ,teal))))

   ;; multiple-cursors
   `(mc/cursor-face ((,class (:inherit 'cursor :background ,fg-alt))))

   ;; nav-flash
   `(nav-flash-face ((,class (:background ,dark-blue :foreground ,base-8 :weight bold))))

   ;; neotree
   `(neo-root-dir-face ((,class (:inherit 'bold :foreground ,base-8)))) ;;:box (:line-width 7 :color ,bg)))))
   `(neo-file-link-face ((,class (:foreground ,fg))))
   `(neo-dir-link-face ((,class (:foreground ,fg :foreground ,base-7))))
   `(neo-expand-btn-face ((,class (:foreground ,blue))))
   `(neo-vc-edited-face ((,class (:foreground ,yellow))))
   `(neo-vc-added-face ((,class (:foreground ,green))))
   `(neo-vc-removed-face ((,class (:foreground ,red :strike-through t))))
   `(neo-vc-ignored-face ((,class (:foreground ,base-5))))

   ;; nlinum
   `(nlinum-current-line ((,class (:inherit 'line-number-current-line))))
   `(nlinum-hl-face ((,class (:inherit 'line-number-current-line))))
   `(nlinum-relative-current-face ((,class (:inherit 'line-number-current-line))))

   ;; popup
   `(popup-face ((,class (:inherit 'tooltip))))
   `(popup-tip-face ((,class (:inherit 'popup-face :background ,base-0 :foreground ,violet))))
   `(popup-selection-face ((,class (:background ,dark-blue))))

   ;; rainbow-delimiters
   `(rainbow-delimiters-depth-1-face ((,class (:foreground ,blue))))
   `(rainbow-delimiters-depth-2-face ((,class (:foreground ,magenta))))
   `(rainbow-delimiters-depth-3-face ((,class (:foreground ,green))))
   `(rainbow-delimiters-depth-4-face ((,class (:foreground ,orange))))
   `(rainbow-delimiters-depth-5-face ((,class (:foreground ,violet))))
   `(rainbow-delimiters-depth-6-face ((,class (:foreground ,yellow))))
   `(rainbow-delimiters-depth-7-face ((,class (:foreground ,teal))))
   `(rainbow-delimiters-unmatched-face ((,class (:foreground ,red :weight ultra-bold))))
   `(rainbow-delimiters-mismatched-face ((,class (:inherit 'rainbow-delimiters-unmatched-face))))

   ;; re-builder
   `(reb-match-0 ((,class (:foreground ,orange :inverse-video t))))
   `(reb-match-1 ((,class (:foreground ,magenta :inverse-video t))))
   `(reb-match-2 ((,class (:foreground ,green :inverse-video t))))
   `(reb-match-3 ((,class (:foreground ,yellow :inverse-video t))))

   ;; smartparens
   `(sp-pair-overlay-face ((,class (:background ,base-4))))
   `(sp-show-pair-match-face ((,class (:inherit 'show-paren-match))))
   `(sp-show-pair-mismatch-face ((,class (:inherit 'show-paren-mismatch))))

   ;; solaire-mode
   `(solaire-default-face ((,class (:inherit 'default :background ,bg-alt))))
   `(solaire-hl-line-face ((,class (:inherit 'hl-line :background ,bg))))

   ;; swiper
   `(swiper-line-face ((,class (:background ,blue :foreground ,base-0))))
   `(swiper-match-face-1 ((,class (:inherit 'unspecified :background ,base-0 :foreground ,base-5))))
   `(swiper-match-face-2 ((,class (:inherit 'unspecified :background ,orange :foreground ,base-0 :weight bold))))
   `(swiper-match-face-3 ((,class (:inherit 'unspecified :background ,magenta :foreground ,base-0 :weight bold))))
   `(swiper-match-face-4 ((,class (:inherit 'unspecified :background ,green :foreground ,base-0 :weight bold))))

   ;; tabbar
   `(tabbar-default ((,class (:background ,bg :foreground ,bg :height 1.0))))
   `(tabbar-highlight ((,class (:background ,dark-blue :foreground ,fg :distant-foreground ,bg))))
   `(tabbar-button ((,class (:background ,bg :foreground ,fg))))
   `(tabbar-button-highlight ((,class (:inherit 'tabbar-button :inverse-video t))))
   `(tabbar-modified ((,class (:inherit 'tabbar-default :foreground ,red :weight bold))))
   `(tabbar-unselected ((,class (:inherit 'tabbar-default :foreground ,base-5))))
   `(tabbar-unselected-modified ((,class (:inherit 'tabbar-modified))))
   `(tabbar-selected ((,class (:inherit 'tabbar-default :background ,bg-alt :foreground ,fg :weight bold))))
   `(tabbar-selected-modified ((,class (:inherit 'tabbar-selected :foreground ,green))))

   ;; transient
   `(transient-heading ((,class (:foreground ,base-8 :weight bold))))
   `(transient-key ((,class (:inherit 'help-key-binding))))
   `(transient-argument ((,class (:inherit 'success))))
   `(transient-blue ((,class (:inherit 'transient-key :foreground ,blue))))
   `(transient-pink ((,class (:inherit 'transient-key :foreground ,pink))))
   `(transient-purple ((,class (:inherit 'transient-key :foreground ,magenta))))
   `(transient-red ((,class (:inherit 'transient-key :foreground ,red))))
   `(transient-teal ((,class (:inherit 'transient-key :foreground ,teal))))

   ;; treemacs
   `(treemacs-root-face ((,class (:inherit 'font-lock-string-face))))
   `(treemacs-file-face ((,class (:foreground ,fg))))
   `(treemacs-directory-face ((,class (:foreground ,blue))))
   `(treemacs-tags-face ((,class (:foreground ,blue))))
   `(treemacs-git-modified-face ((,class (:foreground ,violet))))
   `(treemacs-git-added-face ((,class (:foreground ,green))))
   `(treemacs-git-conflict-face ((,class (:foreground ,red))))
   `(treemacs-git-untracked-face ((,class (:inherit 'font-lock-doc-face))))

   ;; undo-tree
   `(undo-tree-visualizer-default-face ((,class (:foreground ,base-5))))
   `(undo-tree-visualizer-current-face ((,class (:foreground ,green :weight bold))))
   `(undo-tree-visualizer-unmodified-face ((,class (:foreground ,base-5))))
   `(undo-tree-visualizer-active-branch-face ((,class (:foreground ,blue))))
   `(undo-tree-visualizer-register-face ((,class (:foreground ,yellow))))

   ;; vertico
   `(vertico-current ((,class (:inherit 'hl-line :background ,base-3 :weight bold))))

   ;; which-func
   `(which-func ((,class (:foreground ,blue))))

   ;; which-key
   `(which-key-key-face ((,class (:foreground ,green))))
   `(which-key-group-description-face ((,class (:foreground ,violet))))
   `(which-key-command-description-face ((,class (:foreground ,blue))))
   `(which-key-local-map-description-face ((,class (:foreground ,magenta))))

   ;; whitespace
   `(whitespace-empty ((,class (:background ,base-3))))
   `(whitepsace-space ((,class (:foreground ,base-4))))
   `(whitespace-tab ((,class (:background ,base-3 :foreground ,base-4))))
   `(whitespace-newline ((,class (:foreground ,base-4))))
   `(whitespace-indentation ((,class (:background ,base-5 :foreground ,base-3))))
   `(whitespace-trailing ((,class (:inherit 'trailing-whitespace))))
   `(whitespace-line ((,class (:background ,base-0 :foreground ,red :weight bold))))

   ;; yasnippet
   `(yas-field-highlight-face ((,class (:inherit 'match))))))

;;
;; Neotree functions
;;

(defun adwaita-dark-theme--neotree-hidden-dir-p (dirname)
  "Return non-nil if DIRNAME should be considered hidden."
  (string-prefix-p "." dirname))

(defun adwaita-dark-theme--neotree-hidden-file-p (filename)
  "Return non-nil if FILENAME should be considered hidden."
  (or (string-prefix-p "." filename)
      (and (string-prefix-p "#" filename)
           (string-suffix-p "#" filename))))

(defun adwaita-dark-theme--neotree-insert-root (node)
  "Insert root directory NODE at point."
  (insert
   (concat
    " "
    (propertize
     "🖿"
     'face '(:inherit (neo-root-dir-face) :height 1.5))
    (propertize
     (concat " " (or (neo-path--file-short-name node) "-") " \n")
     'face '(:inherit (neo-root-dir-face) :height 1.0)))))

(defun adwaita-dark-theme--neotree-insert-dir (node depth expanded)
  "Insert directory NODE with indentation level DEPTH and state EXPANDED at point."
  (let ((short-name (neo-path--file-short-name node))
        (face '(:inherit (neo-dir-link-face))))
    (when (adwaita-dark-theme--neotree-hidden-dir-p short-name)
      (setq face '(:inherit (shadow neo-dir-link-face))))
    (insert-char ?\s (* (- depth 1) 2))
    (insert (propertize
             (if expanded " ▾ " " ▸ ")
             'face face))
    (insert-button (concat "🖿 " short-name)
                   'follow-link t
                   'face face
                   'neo-full-path node
                   'keymap neotree-dir-button-keymap)
    (neo-buffer--node-list-set nil node)
    (neo-buffer--newline-and-begin)))

(defun adwaita-dark-theme--neotree-insert-file (node depth)
  "Insert file NODE with indentation level DEPTH at point."
  (let ((short-name (neo-path--file-short-name node))
        (face '(:inherit (neo-file-link-face))))
    (when (adwaita-dark-theme--neotree-hidden-file-p short-name)
      (setq face '(:inherit shadow neo-file-link-face)))
    (insert-char ?\s (* (- depth 1) 2))
    (insert (propertize "   " 'face face))
    (insert-button short-name
                   'follow-link t
                   'face face
                   'neo-full-path node
                   'keymap neotree-file-button-keymap)
    (neo-buffer--node-list-set nil node)
    (neo-buffer--newline-and-begin)))

;;;###autoload
(defun adwaita-dark-theme-neotree-configuration-enable ()
  "Enable custom adwaita-dark configuration for use with neotree."
  (progn
    (advice-add #'neo-global--select-window :after (lambda () (visual-line-mode 0) (set-window-fringes neo-global--window 0 0)))
    (advice-add #'neo-buffer--insert-root-entry :override #'adwaita-dark-theme--neotree-insert-root)
    (advice-add #'neo-buffer--insert-dir-entry :override #'adwaita-dark-theme--neotree-insert-dir)
    (advice-add #'neo-buffer--insert-file-entry :override #'adwaita-dark-theme--neotree-insert-file)))

;;
;; Fringe bitmap functions
;;

;; arrow fringe bitmaps
(defconst adwaita-dark-theme--right-arrow-bmp
  (vector #b00000000
          #b00000000
          #b00110000
          #b00111000
          #b00111100
          #b00111000
          #b00110000
          #b00000000)
  "Bitmap used to overwrite Emacs's right line-continuation fringe bitmap.")
(defconst adwaita-dark-theme--left-arrow-bmp
  (vector #b00000000
          #b00000000
          #b00001100
          #b00011100
          #b00111100
          #b00011100
          #b00001100
          #b00000000)
  "Bitmap used to overwrite Emacs's left line-continuation fringe bitmap.")
(defconst adwaita-dark-theme--down-arrow-bmp
  (vector #b00000000
          #b00000000
          #b00000000
          #b00000000
          #b00000000
          #b01111110
          #b00111100
          #b00011000)
  "Bitmap used to overwrite Emac's right line-wrapping fringe bitmap.")
(defconst adwaita-dark-theme--empty-bmp
  (vector #b0)
  "Bitmap used to overwrite Emac's left line-wrapping fringe bitmap.")

;;;###autoload
(defun adwaita-dark-theme-arrow-fringe-bmp-enable ()
  "Replace the default line continuation and line wrap arrows with custom bitmaps."
  (define-fringe-bitmap 'right-arrow adwaita-dark-theme--right-arrow-bmp)
  (define-fringe-bitmap 'left-arrow adwaita-dark-theme--left-arrow-bmp)
  (define-fringe-bitmap 'right-curly-arrow adwaita-dark-theme--down-arrow-bmp)
  (define-fringe-bitmap 'left-curly-arrow adwaita-dark-theme--empty-bmp))

;; diff-hl fringe bitmap
(defvar adwaita-dark-theme--diff-hl-bmp
  (define-fringe-bitmap 'adwaita-dark-theme--diff-hl-bmp
    (vector #b11100000)
    1 8
    '(center t))
  "Fringe bitmap for use with `diff-hl'.")

;;;###autoload
(defun adwaita-dark-theme-diff-hl-fringe-bmp-function (_type _pos)
  "Fringe bitmap function for use as `diff-hl-fringe-bmp-function'."
  adwaita-dark-theme--diff-hl-bmp)

;; flycheck/flymake fringe bitmaps
(define-fringe-bitmap 'adwaita-dark-theme--marker-bmp
  (vector #b11100000
          #b11110000
          #b11111000
          #b11111100
          #b11111000
          #b11110000
          #b11100000))
(defconst adwaita-dark-theme--dot-bmp
  (vector #b01100000
          #b01100000)
  "Bitmap used to overwrite flycheck's continuation fringe bitmap.")

;;;###autoload
(defun adwaita-dark-theme-flycheck-fringe-bmp-enable ()
  "Enable custom adwaita-dark fringe bitmaps for use with flycheck."
  (flycheck-redefine-standard-error-levels nil 'adwaita-dark-theme--marker-bmp)
  (define-fringe-bitmap 'flycheck-fringe-bitmap-continuation adwaita-dark-theme--dot-bmp))

;;;###autoload
(defun adwaita-dark-theme-flymake-fringe-bmp-enable ()
  "Enable custom adwaita-dark fringe bitmaps for use with flymake."
  (progn
    (setq-default flymake-error-bitmap '(adwaita-dark-theme--marker-bmp compilation-error))
    (setq-default flymake-warning-bitmap '(adwaita-dark-theme--marker-bmp compilation-warning))
    (setq-default flymake-note-bitmap '(adwaita-dark-theme--marker-bmp compilation-info))))

;;
;; Register theme folder location
;;

;;;###autoload
(when (and (boundp 'custom-theme-load-path) load-file-name)
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

;;
;; Provide adwaita-dark-theme
;;

(provide-theme 'adwaita-dark)
(provide 'adwaita-dark-theme)

;;; adwaita-dark-theme.el ends here
