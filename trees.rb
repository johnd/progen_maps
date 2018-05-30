require_relative 'helper'

class Trees
  class << self
    def seed(grid,seeds=nil)
      seeds ||= (grid.rows + grid.columns) / 10
      seeded_cells = []
      seeds.times do
        new_cell = grid.random_cell
        while seeded_cells.include? new_cell
          new_cell = grid.random_cell
        end
        seeded_cells << new_cell
        new_cell.type = :tree
      end
    end

    def grow_forests(grid)
      seed_trees = []
      grid.each_cell {|c| seed_trees << c if c.type == :tree}
      seed_trees.each do |tree_cell|
        forest_cells = tree_cell.neighbors
        tree_cell.neighbors.each do |tc_n|
          forest_cells << tc_n.neighbors
        end
        forest_cells.flatten!
        forest_cells.each do |forest_cell|
          forest_cell.type = :tree
        end

        outer_layer_trees = forest_cells - tree_cell.neighbors
        outer_layer_trees.each do |tree|
          random_tree_growth(tree)
        end
      end
    end

    def random_tree_growth(cell)
      cell.neighbors.each do |tree|
        next if tree.type == :tree
        if Helper.coinflip(3)
          tree.type = :tree
          random_tree_growth(tree)
        end
      end
    end
  end
end
