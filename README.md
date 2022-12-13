# adwaita-dark-theme
### Version 1.0.0

## About

`adwaita-dark-theme` is a dark color scheme that aims to replicate the appearance and colors of GTK4 "libadwaita" applications.

## Features

* Beautiful dark color scheme inspired by Adwaita

* Automatic 256-color mode support

* Custom fringe bitmaps for diff-hl, flycheck, and flymake

* Lightweight with no dependencies

## Preview

![Preview Image](https://gitlab.com/jessieh/adwaita-dark-theme/raw/assets/preview.png "Preview Image")

## Configuration

### Custom Neotree Configuration

`(eval-after-load 'neotree #'adwaita-dark-theme-neotree-configuration-enable)`

### Custom Fringe Bitmaps

To replace default line continuation/line wrap fringe bitmaps:
`(adwaita-dark-theme-arrow-fringe-bmp-enable)`

To enable custom fringe bitmaps for [diff-hl](https://github.com/dgutov/diff-hl):
`(setq diff-hl-fringe-bmp-function #'adwaita-dark-theme-diff-hl-fringe-bmp-function)`

To enable custom fringe bitmaps for [flycheck](https://www.flycheck.org/en/latest/):
`(eval-after-load 'flycheck #'adwaita-dark-theme-flycheck-fringe-bmp-enable)`

To enable custom fringe bitmaps for [flymake](https://www.emacswiki.org/emacs/FlyMake):
`(eval-after-load 'flymake #'adwaita-dark-theme-flymake-fringe-bmp-enable)`

## Known Issues

* No known issues.

If you experience any issues with this package, please
[open an issue](https://gitlab.com/jessieh/adwaita-dark-theme/issues/new)
on the issue tracker.

Suggestions for improvements and feature requests are always appreciated, as well!
