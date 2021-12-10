# --- Day 9: Smoke Basin ---

# These caves seem to be lava tubes. Parts are even still volcanically active; small hydrothermal vents release smoke into the caves that slowly settles like rain.

# If you can model how the smoke flows through the caves, you might be able to avoid it and be that much safer. The submarine generates a heightmap of the floor of the nearby caves for you (your puzzle input).

# Smoke flows to the lowest point of the area it's in. For example, consider the following heightmap:

# 2199943210
# 3987894921
# 9856789892
# 8767896789
# 9899965678
# Each number corresponds to the height of a particular location, where 9 is the highest and 0 is the lowest a location can be.

# Your first goal is to find the low points - the locations that are lower than any of its adjacent locations. Most locations have four adjacent locations (up, down, left, and right); locations on the edge or corner of the map have three or two adjacent locations, respectively. (Diagonal locations do not count as adjacent.)

# In the above example, there are four low points, all highlighted: two are in the first row (a 1 and a 0), one is in the third row (a 5), and one is in the bottom row (also a 5). All other locations on the heightmap have some lower adjacent location, and so are not low points.

# The risk level of a low point is 1 plus its height. In the above example, the risk levels of the low points are 2, 1, 6, and 6. The sum of the risk levels of all low points in the heightmap is therefore 15.

# Find all of the low points on your heightmap. What is the sum of the risk levels of all low points on your heightmap?

DEBUG = false

map = {}

y = 0
max_x = 0
max_y = 0
File.open("./#{DEBUG ? 'sample_' : nil}input.txt").each do |line|
  heights = line.chomp.chars
  puts "Row #{y}: #{heights}" if DEBUG
  heights.each_with_index do |digit, x|
    max_x = x
    map[[x, y]] = digit.to_i
  end
  max_y = y
  y += 1
end
puts
puts "Parsed map: #{map.length} coordinates found"
puts "Map: #{map.inspect}" if DEBUG
puts "Max (x,y): (#{max_x}, #{max_y})"

puts
puts
puts "*******************"
puts "PART I"

low_points = []

(max_x + 1).times do |x|
  (max_y + 1).times do |y|
    focal_point_height = map[[x,y]]
    neighbor_heights = [
      map[[x-1, y]],
      map[[x+1, y]],
      map[[x, y-1]],
      map[[x, y+1]]
    ].compact
    if neighbor_heights.all?{|h| h > focal_point_height}
      puts "Found a low point at (#{x},#{y}): #{focal_point_height}. Neighbor heights: #{neighbor_heights.inspect}" if DEBUG
      low_points << focal_point_height
    end
  end
end

risk_factors = low_points.collect{|h| h + 1 }
puts "Total risk: #{risk_factors.sum}"
