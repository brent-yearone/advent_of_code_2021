# --- Day 5: Hydrothermal Venture ---

# You come across a field of hydrothermal vents on the ocean floor! These vents constantly produce large, opaque clouds, so it would be best to avoid them if possible.

# They tend to form in lines; the submarine helpfully produces a list of nearby lines of vents (your puzzle input) for you to review. For example:

# 0,9 -> 5,9
# 8,0 -> 0,8
# 9,4 -> 3,4
# 2,2 -> 2,1
# 7,0 -> 7,4
# 6,4 -> 2,0
# 0,9 -> 2,9
# 3,4 -> 1,4
# 0,0 -> 8,8
# 5,5 -> 8,2
# Each line of vents is given as a line segment in the format x1,y1 -> x2,y2 where x1,y1 are the coordinates of one end the line segment and x2,y2 are the coordinates of the other end. These line segments include the points at both ends. In other words:

# An entry like 1,1 -> 1,3 covers points 1,1, 1,2, and 1,3.
# An entry like 9,7 -> 7,7 covers points 9,7, 8,7, and 7,7.
# For now, only consider horizontal and vertical lines: lines where either x1 = x2 or y1 = y2.

# So, the horizontal and vertical lines from the above list would produce the following diagram:

# .......1..
# ..1....1..
# ..1....1..
# .......1..
# .112111211
# ..........
# ..........
# ..........
# ..........
# 222111....
# In this diagram, the top left corner is 0,0 and the bottom right corner is 9,9. Each position is shown as the number of lines which cover that point or . if no line covers that point. The top-left pair of 1s, for example, comes from 2,2 -> 2,1; the very bottom row is formed by the overlapping lines 0,9 -> 5,9 and 0,9 -> 2,9.

# To avoid the most dangerous areas, you need to determine the number of points where at least two lines overlap. In the above example, this is anywhere in the diagram with a 2 or larger - a total of 5 points.

# Consider only horizontal and vertical lines. At how many points do at least two lines overlap?

DEBUG = false

puts
puts
puts "*******************"
puts "PART I"

map = {}

File.open("./#{DEBUG ? 'sample_' : nil}input.txt").each do |line|
  coordinates = line.chomp.split(' -> ')

  coordinates.collect! do |coordinate_pair|
    x,y = coordinate_pair.split(',')
    {x: x.to_i, y: y.to_i}
  end
  puts "Coordinates: #{coordinates.inspect}" if DEBUG

  if coordinates[0][:x] == coordinates[1][:x]
    # vertical line
    x = coordinates[0][:x]
    y1 = coordinates[0][:y]
    y2 = coordinates[1][:y]
    y1, y2 = y2, y1 if y1 > y2
    (y1..y2).each do |y|
      map[[x,y]] ||= 0
      map[[x,y]] += 1
    end
  elsif coordinates[0][:y] == coordinates[1][:y]
    # horizontal line
    y = coordinates[0][:y]
    x1 = coordinates[0][:x]
    x2 = coordinates[1][:x]
    x1, x2 = x2, x1 if x1 > x2
    (x1..x2).each do |x|
      map[[x,y]] ||= 0
      map[[x,y]] += 1
    end
  end
end
if DEBUG
  10.times do |y|
    line = ''
    10.times do |x|
      if map[[x,y]]
        line << map[[x,y]].to_s
      else
        line << '.'
      end
    end
    puts line
  end
end
puts "Loaded coordinates"

count = 0
map.each do |coordinates, number|
  count += 1 if number >= 2
end

puts "Count of spaces where at least two lines overlap: #{count}"
