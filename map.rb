require_relative 'grid'
require_relative 'trees'

rows = (ARGV[0] || 30).to_i
columns = (ARGV[1] || 90).to_i

map = Grid.new(rows,columns)
Trees.seed(map)
Trees.grow_forests(map)
puts map
