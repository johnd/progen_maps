require 'rmagick'
require_relative 'helper'
require_relative 'trees'

class Cell
  attr_reader :row, :column, :type
  attr_accessor :north, :south, :east, :west
  attr_accessor :northwest, :southwest, :northeast, :southeast

  CELL_TYPE_MAP = 
    {:grass => "¨",
     :tree  => "t"}

  def initialize(row, column, cell_type=:grass)
    @row, @column = row, column
    self.type = cell_type
  end

  def inspect
    "<Cell #{self.row}, #{self.column}: #{self.type} #{self.to_s}>"
  end

  def neighbors
    list = []
    list << north if north
    list << south if south
    list << east  if east
    list << west  if west
    list
  end

  def neighborhood
    list = neighbors
    neighbors.each do |c|
      list << c.neighbors
    end
    list.flatten
  end

  def to_s
    CELL_TYPE_MAP[type]
  end

  def to_img
    if type == :grass
      Magick::Image.read("assets/tileset/" + pick_grass_tile).first
    elsif type == :tree
      Trees.to_img(self)
    end
  end

  def type=(cell_type)
    if CELL_TYPE_MAP.keys.include? cell_type
      @type = cell_type
    else
      raise "INVALID CELL TYPE!"
    end
  end

  def pick_grass_tile
    if neighbors.map(&:type).include? :tree
      # Use plain grass tile when next to trees...
      "tile000.png"
    else
      # ...otherwise scatter leaves randomly + infrequently
      randomness = rand(75)
      case
      when randomness == 0
        "tile001.png"
      when randomness == 1
        "tile002.png"
      when randomness == 2
        "tile003.png"
      else
        "tile000.png"
      end
    end
  end

end

