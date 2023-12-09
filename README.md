# <img src=".repo-assets/icon.png" width=50> adwaita-dark-theme

A dark color scheme that aims to replicate the appearance and colors of GTK4 "libadwaita" applications.

[![MELPA](https://melpa.org/packages/adwaita-dark-theme-badge.svg)](https://melpa.org/#/adwaita-dark-theme)
[![MELPA Stable](https://stable.melpa.org/packages/adwaita-dark-theme-badge.svg)](https://stable.melpa.org/#/adwaita-dark-theme)

## Features

* Beautiful dark color scheme inspired by Adwaita

* Automatic 256-color mode support

* Configurable theme features

* Custom fringe bitmaps for diff-hl, flycheck, and flymake

* Lightweight, no dependencies

## Preview

![Preview Image](.repo-assets/preview.webp "Preview Image")

## Configuration

To see all of the theme features that can be configured:

`M-x customize-group adwaita-dark-theme`

### Custom Neotree Configuration

`(eval-after-load 'neotree #'adwaita-dark-theme-neotree-configuration-enable)`

### Custom Fringe Bitmaps

To replace default line continuation/line wrap fringe bitmaps:\
`(adwaita-dark-theme-arrow-fringe-bmp-enable)`

To enable custom fringe bitmaps for [diff-hl](https://github.com/dgutov/diff-hl):\
`(eval-after-load 'diff-hl #'adwaita-dark-theme-diff-hl-fringe-bmp-enable)`

To enable custom fringe bitmaps for [flycheck](https://www.flycheck.org):\
`(eval-after-load 'flycheck #'adwaita-dark-theme-flycheck-fringe-bmp-enable)`

To enable custom fringe bitmaps for [flymake](https://www.emacswiki.org/emacs/FlyMake):\
`(eval-after-load 'flymake #'adwaita-dark-theme-flymake-fringe-bmp-enable)`

## Feedback

If you experience any issues with this package, please
[open an issue](https://git.tty.dog/jessieh/adwaita-dark-theme/issues/new)
on the issue tracker.

Suggestions for improvements and feature requests are always appreciated, as well!
