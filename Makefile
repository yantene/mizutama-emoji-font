# Makefile to create all versions of the Twitter Color Emoji SVGinOT font
# Run with: make -j [NUMBER_OF_CPUS]

# Where to find scfbuild?
SCFBUILD := SCFBuild/bin/scfbuild

VERSION := 0.9
FONT_PREFIX := MizutamaEmoji
FONT := build/$(FONT_PREFIX).ttf
PACKAGE := build/$(FONT_PREFIX)-$(VERSION).tar.gz
PACKAGE_TMP := build/$(FONT_PREFIX)-$(VERSION)

# There are two SVG source directories to keep the assets separate
# from the additions
SVG_TWEMOJI := assets/twemoji-svg

# Create the lists of traced and color SVGs
SVG_FILES := $(wildcard $(SVG_TWEMOJI)/*.svg)
SVG_STAGE_FILES := $(patsubst $(SVG_TWEMOJI)/%.svg, build/stage/%.svg, $(SVG_FILES))
SVG_BW_FILES := $(patsubst build/stage/%.svg, build/svg-bw/%.svg, $(SVG_STAGE_FILES))
SVG_COLOR_FILES := $(patsubst build/stage/%.svg, build/svg-color/%.svg, $(SVG_STAGE_FILES))

.DEFAULT_GOAL := $(PACKAGE)

$(PACKAGE): $(FONT)
	mkdir $(PACKAGE_TMP)
	cp $(FONT) $(PACKAGE_TMP)
	cp LICENSE* $(PACKAGE_TMP)
	cp README.md $(PACKAGE_TMP)
	tar -C "`dirname $(PACKAGE_TMP)`" -zcf $(PACKAGE) "`basename $(PACKAGE_TMP)`"
	rm -rf $(PACKAGE_TMP)

# Build both versions of the fonts
$(FONT): $(SCFBUILD) $(SVG_BW_FILES) $(SVG_COLOR_FILES)
	$(SCFBUILD) -c scfbuild.yml -o $(FONT) --font-version="$(VERSION)"

$(SCFBUILD):
	git clone --depth=1 https://github.com/eosrei/scfbuild.git SCFBuild

build/svg-bw/%.svg: build/staging/%.svg | build/svg-bw
	./halftone.rb $< $@

# Optimize/clean the color SVG files
build/svg-color/%.svg: build/staging/%.svg | build/svg-color
	svgo -i $< -o $@

# Copy the files from multiple directories into one source directory
build/staging/%.svg: $(SVG_TWEMOJI)/%.svg | build/staging
	cp $< $@

# Create the build directories
build/staging:
	mkdir -p build/staging

build/svg-bw:
	mkdir -p build/svg-bw

build/svg-color:
	mkdir -p build/svg-color

clean:
	rm -rf build
