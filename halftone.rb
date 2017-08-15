#!/usr/bin/env ruby

require 'bundler/setup'
require 'cairo'

def graymap(png)
  png.data.bytes.each_slice(4).with_index.map { |rgba, idx|
    r, g, b, a = rgba
    y = (2 * r + 4 * g + b).fdiv(7)
    (255 - y).fdiv(255) * a.fdiv(255)
  }.each_slice(png.width).to_a
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

png = Cairo::ImageSurface.from_png(ARGV[0])
abort 'The width of png img is not even number' unless png.width.even?
abort 'The height of png img is not even number' unless png.height.even?
gmap = graymap(png)
dmap = dotmap(gmap)

surface = Cairo::SVGSurface.new(ARGV[1], png.width, png.height)
context = Cairo::Context.new(surface)
dmap.each.with_index do |row, y|
  row.each.with_index do |val, x|
    next if val.nil?
    context.fill do
      context.circle(x + 1, y + 1, val)
    end
  end
end
