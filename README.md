# mood-adwaita-theme
### Version 1.0.0

## About

`mood-adwaita-theme` is a dark color scheme that aims to replicate the appearance and colors of GTK4 "libadwaita" applications.

## Features

* Beautiful dark color scheme inspired by Adwaita

* Custom fringe bitmaps for diff-hl, flycheck, and flymake

* Lightweight with no dependencies

## Preview

![Preview Image](https://gitlab.com/jessieh/mood-adwaita-theme/raw/assets/mood-adwaita-theme.png "Preview Image")

## Configuration

### Custom Neotree Configuration

`(eval-after-load 'neotree #'mood-adwaita-theme-neotree-configuration-enable)`

### Custom Fringe Bitmaps

To replace default line continuation/line wrap fringe bitmaps:
`(mood-adwaita-theme-arrow-fringe-bmp-enable)`

To enable custom fringe bitmaps for [diff-hl](https://github.com/dgutov/diff-hl):
`(setq diff-hl-fringe-bmp-function #'mood-adwaita-theme-diff-hl-fringe-bmp-function)`

To enable custom fringe bitmaps for [flycheck](https://www.flycheck.org/en/latest/):
`(eval-after-load 'flycheck #'mood-adwaita-theme-flycheck-fringe-bmp-enable)`

To enable custom fringe bitmaps for [flymake](https://www.emacswiki.org/emacs/FlyMake):
`(eval-after-load 'flymake #'mood-adwaita-theme-flymake-fringe-bmp-enable)`

## Known Issues

* No known issues.

If you experience any issues with this package, please
[open an issue](https://gitlab.com/jessieh/mood-adwaita-theme/issues/new)
on the issue tracker.

Suggestions for improvements and feature requests are always appreciated, as well!
