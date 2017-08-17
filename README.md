# Mizutama Emoji font
Mizutama Emoji font built from the [Twitter Color Emoji SVGinOT Font][1].
Since B&W emojis are represented by dot patterns,
its color space is pseudo-expanded.
This makes it possible to use awesome Twemoji
even in environments where correspondence to color emojis is difficult.

The font works in all operating systems, but will *currently* only show color
emoji in Firefox, Thunderbird, Photoshop CC 2017, and Windows Edge V38.14393+.
This is not a limitation of the font, but of the operating systems and
applications. Regular B&W dot pattern emoji are included for backwards/fallback
compatibility.

[1]: https://github.com/eosrei/twemoji-color-font

## Table of Contents

* [Examples](#examples)
* [What is SVGinOT?](#what-is-svginot)
* [Install on Linux](#install-on-linux)
* [Install on OS X](#install-on-os-x)
* [Install on Windows](#install-on-windows)
* [Building](#building)
* [License](#license)

## Examples

Demo in Firefox on Linux.
![Firefox color emoji in Linux](images/firefox-demo.png?raw=true)

Demo in Chromium on Linux.
![Chromium B&W emoji in Linux](images/chromium-demo.png?raw=true)

Demo in Terminal on Linux.
![Terminal B&W emoji in Linux](images/terminal-demo.png?raw=true)

Demo in Gedit on Linux.
![Gedit B&W emoji in Linux](images/gedit-demo.png?raw=true)

## What is SVGinOT?
*SVG in Open Type* is a standard by Adobe and Mozilla for color OpenType
and Open Font Format fonts. It allows font creators to embed complete SVG files
within a font enabling full color and even animations. There are more details
in the [SVGinOT proposal][6] and the [OpenType SVG table specifications][7].

SVGinOT Font demos (Firefox only):

* https://hacks.mozilla.org/2014/10/svg-colors-in-opentype-fonts/
* http://xerographer.github.io/reinebow/
* http://xerographer.github.io/multicoloure/

[6]: https://www.w3.org/2013/10/SVG_in_OpenType/
[7]: https://www.microsoft.com/typography/otspec/svg.htm

## Install on Linux
The font can be installed for a user or system-wide. Get the latest version
from releases: https://github.com/yantene/mizutama-emoji-font/releases

*Note: This requires `Bitstream Vera` is installed and will change your
systems default serif, sans-serif and monospace fonts.*

### Why Bitstream Vera
The default serif, sans-serif and monospace font for most Linux distributions is
`DejaVu`. `DejaVu` includes a wide range of symbols which override the
`Twitter Color Emoji` characters. The previous solution was to make
`Twitter Color Emoji` the default system font, but that causes a number of issues.
A better solution is a different font that doesn't override any emoji characters
such as `Bitstream Vera`. `Bitstream Vera` is the source of the glyphs used in
`DejaVu`, so it's not very different. 99%+ of people will not notice the
difference.

### Additional default font options
The `Noto` and `Roboto` font families conflict far less than `DejaVu`. You may
want to try them. Primary issues are the 0x2639 and 0x263a characters.

### Known issues

* [Symbols/emoji in monospace formatted text cause incorrect character alignment][8].
  The whitespace character widths from the most recently selected
  fallback font are used in Pango/GTK applications.
* [[Issue #31][9]] [Some font families are not matched correctly in Linux Firefox][10].
  Workaround: Open `about:config` set
  `gfx.font_rendering.fontconfig.fontlist.enabled` to `false`.
  [Note: May cause crashes in Firefox \<48.][11]

[8]:https://bugzilla.gnome.org/show_bug.cgi?id=757785
[9]:https://github.com/eosrei/emojione-color-font/issues/31
[10]:https://bugzilla.mozilla.org/show_bug.cgi?id=1245811
[11]:https://bugzilla.mozilla.org/show_bug.cgi?id=1266341

### Install on Arch Linux
AUR package: https://aur.archlinux.org/packages/ttf-mizutama-emoji/

```sh
yaourt -S ttf-mizutama-emoji
```

### Get mizutama font for other environment

Get it [Here](https://github.com/yantene/mizutama-emoji-font/release)

## Building
Overview:

1. B&W SVGs are generated on-the-fly from the color SVGs
2. The B&W SVGs are imported based on their filename to create either regular
   glyphs or ligature glyphs.
3. The color SVGs are imported to override both types of glyphs.

Requires:
* Inkscape
* Imagemagick
* potrace/mkbitmap
* FontTools 3.0+
* FontForge 20160405+
* SVGO
* make
* Ruby
* Bundler
* Cairo
* [SCFBuild][11] *(Created for this project!)*

[11]: https://github.com/eosrei/scfbuild

Setup and build on Ubuntu 14.04 LTS:
```sh
sudo add-apt-repository ppa:fontforge/fontforge
sudo apt-get update
sudo apt-get install inkscape potrace npm nodejs nodejs-legacy fontforge \
python-fontforge python-pip python-yaml imagemagick git make
sudo npm install -g svgo
sudo pip install fonttools
sudo gem install bundler
git clone https://github.com/yantene/mizutama-emoji-font.git
cd mizutama-emoji-font
bundle install --path vendor/bundle
git clone https://github.com/eosrei/scfbuild.git SCFBuild
make -j 4
```

## License

The artwork and TTF fonts are licensed CC-BY-4.0. Please see
[LICENSE.md](LICENSE.md) for details.
