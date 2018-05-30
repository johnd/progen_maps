class Cell
  attr_reader :row, :column, :type
  attr_accessor :north, :south, :east, :west

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

  def type=(cell_type)
    if CELL_TYPE_MAP.keys.include? cell_type
      @type = cell_type
    else
      raise "INVALID CELL TYPE!"
    end
  end

end

