require_relative 'helper'
require 'rmagick'

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

    def to_img(cell)
      tree_image = Magick::Image.read("assets/tileset/" + pick_tree_tile(cell)).first
      tree_image.alpha(Magick::ActivateAlphaChannel)
      grass_image = Magick::Image.read("assets/tileset/tile000.png").first
      grass_image.composite(tree_image,Magick::NorthWestGravity, 0, 0, Magick::OverCompositeOp)
    end

    def pick_tree_tile(cell)
      # If a forest is at the edge of the map, assume it's more tree 'off' the map.
      north = cell.north&.type == :tree
      east  = cell.east&.type  == :tree
      south = cell.south&.type == :tree
      west  = cell.west&.type  == :tree
      northeast = cell.northeast&.type == :tree && north && east
      northwest = cell.northwest&.type == :tree && north && west
      southeast = cell.southeast&.type == :tree && south && east
      southwest = cell.southwest&.type == :tree && south && west

      case
      when northeast && northwest && southeast && southwest
        "tile240.png"
      when northeast && southeast && southwest 
        "tile210.png"
      when northwest && southeast && southwest
        "tile211.png"
      when northeast && northwest && southeast
        "tile242.png"
      when northeast && northwest && southwest
        "tile243.png"
      when southeast && southwest
        "tile208.png"
      when northeast && southeast
        "tile239.png"
      when northwest && southwest 
        "tile241.png"
      when northeast && northwest 
        "tile272.png"
      when northeast && southwest 
        "tile274.png"
      when northwest && southeast 
        "tile275.png"
      when southeast
        "tile207.png"
      when southwest
        "tile209.png"
      when northeast 
        "tile271.png"
      when northwest 
        "tile273.png"
      else
        "tile206.png"
      end

    end

  end


end
