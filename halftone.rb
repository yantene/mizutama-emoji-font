#!/usr/bin/env ruby

require 'bundler/setup'
require 'cairo'
require 'rsvg2'

def graymap(image)
  image.data.bytes.each_slice(4).with_index.map { |rgba, idx|
    r, g, b, a = rgba
    y = (2 * r + 4 * g + b).fdiv(7)
    (255 - y).fdiv(255) * a.fdiv(255)
  }.each_slice(image.width).to_a
end

def dotmap(gmap)
  Array.new(gmap.size - 1) do |y|
    Array.new(gmap[0].size - 1) do |x|
      if (y + x).odd?
        [
          gmap[y][x],
          gmap[y + 1][x],
          gmap[y][x + 1],
          gmap[y + 1][x + 1]
        ].compact.tap { |v| break v.sum.fdiv(v.size) }
      end
    end
  end
end

def halftone(dmap, context)
  dmap.each.with_index do |row, y|
    row.each.with_index do |val, x|
      next if val.nil?
      context.fill do
        context.circle(x + 1, y + 1, val)
      end
    end
  end
end

input, output = ARGV

width = height = 32

input_svg = RSVG::Handle.new_from_file(input)

# input image
## evaluate ratio of width and height
input_width_ratio = width.fdiv(input_svg.width)
input_height_ratio = height.fdiv(input_svg.height)
## generate raster image from SVG
input_surface = Cairo::ImageSurface.new(Cairo::FORMAT_ARGB32, width, height)
input_context = Cairo::Context.new(input_surface)
input_context.scale(input_width_ratio, input_height_ratio)
input_context.render_rsvg_handle(input_svg)

# make dot pattern
gmap = graymap(input_surface)
dmap = dotmap(gmap)
Cairo::SVGSurface.new(output, width, height) do |surface|
  context = Cairo::Context.new(surface)
  halftone(dmap, context)
  context.target.finish
end
