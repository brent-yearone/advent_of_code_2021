require './path_search.rb'

# --- Day 15: Chiton ---

# You've almost reached the exit of the cave, but the walls are getting closer together. Your submarine can barely still fit, though; the main problem is that the walls of the cave are covered in chitons, and it would be best not to bump any of them.

# The cavern is large, but has a very low ceiling, restricting your motion to two dimensions. The shape of the cavern resembles a square; a quick scan of chiton density produces a map of risk level throughout the cave (your puzzle input). For example:

# 1163751742
# 1381373672
# 2136511328
# 3694931569
# 7463417111
# 1319128137
# 1359912421
# 3125421639
# 1293138521
# 2311944581
# You start in the top left position, your destination is the bottom right position, and you cannot move diagonally. The number at each position is its risk level; to determine the total risk of an entire path, add up the risk levels of each position you enter (that is, don't count the risk level of your starting position unless you enter it; leaving it adds no risk to your total).

# Your goal is to find a path with the lowest total risk. In this example, a path with the lowest total risk is highlighted here:

# 1163751742
# 1381373672
# 2136511328
# 3694931569
# 7463417111
# 1319128137
# 1359912421
# 3125421639
# 1293138521
# 2311944581
# The total risk of this path is 40 (the starting position is never entered, so its risk is not counted).

# What is the lowest total risk of any path from the top left to the bottom right?


DEBUG = false

class Hash
  def to_map
    output = "\n"
    (MAX_Y + 1).times do |y|
      (MAX_X + 1).times do |x|
        node = self[[x,y]]
        output << (node ? node.risk.to_s : '.')
      end
      output << "\n"
    end
    output
  end
end


@map = {}
MAX_X = DEBUG ? 9 : 99 # 10x10 or 100x100 map, zero-offset
MAX_Y = DEBUG ? 9 : 99
y = 0

class Node
  attr_reader :x, :y, :risk, :heuristic_distance_to_end
  attr_accessor :distance_to_start, :previous_node

  def initialize(x:, y:, risk:)
    @x = x
    @y = y
    @risk = (x == 0 && y == 0 ? 0 : risk) # Per puzzle input, we don't count the risk in the starting spot
    @distance_to_start = 0
    @heuristic_distance_to_end = (MAX_X - @x) + (MAX_Y - @y)
    @previous_node = nil
  end

  def search_criterion
    distance_to_start + heuristic_distance_to_end
  end

  def neighbor_coordinates
  [
    [@x+1, @y],
    [@x, @y+1],
    [@x-1, @y],
    [@x, @y-1],
  ]
  end

  def coordinates
    [@x,@y]
  end
end

puts
puts
puts "*******************"
puts "PART I"
puts

File.open("./#{DEBUG ? 'sample_' : nil}input.txt").each do |input_line|
  line = input_line.chomp
  line.chars.each_with_index do |risk, x|
    @map[[x,y]] = Node.new(x: x, y: y, risk: risk.to_i)
  end

  y += 1
end

puts "Map: #{@map.to_map}"

searcher = PathSearch.new(@map, @map[[0,0]], @map[[MAX_X,MAX_Y]])
best_path = searcher.search
total_risk = best_path.collect(&:risk).sum

puts "Best path has risk #{total_risk}: #{best_path.collect(&:coordinates).inspect}"



puts
puts
puts "*******************"
puts "PART II"
puts

GRID_X = MAX_X.dup
GRID_Y = MAX_Y.dup
MAX_X = DEBUG ? 49 : 499
MAX_Y = DEBUG ? 49 : 499
@map = {}
y = 0
File.open("./#{DEBUG ? 'sample_' : nil}input.txt").each do |input_line|
  line = input_line.chomp
  line.chars.each_with_index do |risk_txt, x|
    risk = risk_txt.to_i
    @map[[x,y]] = Node.new(x: x, y: y, risk: risk)
    (0..4).each do |repeat_x|
      (0..4).each do |repeat_y|
        new_x = (GRID_X + 1)*repeat_x + x
        new_y = (GRID_Y + 1)*repeat_y + y
        new_risk = risk + repeat_x + repeat_y
        new_risk -= 9 if new_risk > 9
        @map[[new_x , new_y]] = Node.new(x: new_x, y: new_y, risk: new_risk)
      end
    end
  end

  y += 1
end

puts "Map: #{@map.to_map}"

searcher = PathSearch.new(@map, @map[[0,0]], @map[[MAX_X,MAX_Y]])
best_path = searcher.search
total_risk = best_path.collect(&:risk).sum

puts "Best path has risk #{total_risk}: #{best_path.collect(&:coordinates).inspect}"
