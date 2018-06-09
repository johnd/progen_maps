require_relative 'cell'
require 'rmagick'

class Grid
  attr_reader :rows, :columns

  def initialize(rows, columns)
    @rows = rows
    @columns = columns

    @grid = prepare_grid
    configure_cells
  end

  def inspect
    "<Grid #{self.rows} x #{self.columns}>"
  end

  def prepare_grid
    Array.new(rows) do |row|
      Array.new(columns) do |column|
        Cell.new(row, column)
      end
    end
  end

  def configure_cells
    each_cell do |cell|
      row, col = cell.row, cell.column

      cell.north = self[row - 1, col]
      cell.south = self[row + 1, col]
      cell.west  = self[row, col - 1]
      cell.east  = self[row, col + 1]
    end
  end

  def [](row, column)
    return nil unless row.between?(0, @rows - 1)
    return nil unless column.between?(0, @grid[row].count - 1)
    @grid[row][column]
  end

  def random_cell
    row = rand(@rows)
    column = rand(@grid[row].count)

    self[row, column]
  end

  def size
    @rows * @columns
  end

  def each_row
    @grid.each do |row|
      yield row
    end
  end

  def each_cell
    each_row do |row|
      row.each do |cell|
        yield cell if cell
      end
    end
  end

  def to_s
    output = "\n"
    each_row do |row|
      row.each do |cell|
        output << cell.to_s
      end
      output << "\n"
    end
    output
  end

  def to_img
    output = Magick::ImageList.new
    each_row do |row|
      row_list = Magick::ImageList.new
      row.each do |cell|
        row_list.push(cell.to_img)
      end
      output.push(row_list.append(false))
    end
    output.append(true)
  end

  def to_png(filename="output.png")
    self.to_img.write(filename)
  end

end
