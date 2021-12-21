# --- Day 14: Extended Polymerization ---

# The incredible pressures at this depth are starting to put a strain on your submarine. The submarine has polymerization equipment that would produce suitable materials to reinforce the submarine, and the nearby volcanically-active caves should even have the necessary input elements in sufficient quantities.

# The submarine manual contains instructions for finding the optimal polymer formula; specifically, it offers a polymer template and a list of pair insertion rules (your puzzle input). You just need to work out what polymer would result after repeating the pair insertion process a few times.

# For example:

# NNCB

# CH -> B
# HH -> N
# CB -> H
# NH -> C
# HB -> C
# HC -> B
# HN -> C
# NN -> C
# BH -> H
# NC -> B
# NB -> B
# BN -> B
# BB -> N
# BC -> B
# CC -> N
# CN -> C
# The first line is the polymer template - this is the starting point of the process.

# The following section defines the pair insertion rules. A rule like AB -> C means that when elements A and B are immediately adjacent, element C should be inserted between them. These insertions all happen simultaneously.

# So, starting with the polymer template NNCB, the first step simultaneously considers all three pairs:

# The first pair (NN) matches the rule NN -> C, so element C is inserted between the first N and the second N.
# The second pair (NC) matches the rule NC -> B, so element B is inserted between the N and the C.
# The third pair (CB) matches the rule CB -> H, so element H is inserted between the C and the B.
# Note that these pairs overlap: the second element of one pair is the first element of the next pair. Also, because all pairs are considered simultaneously, inserted elements are not considered to be part of a pair until the next step.

# After the first step of this process, the polymer becomes NCNBCHB.

# Here are the results of a few steps using the above rules:

# Template:     NNCB
# After step 1: NCNBCHB
# After step 2: NBCCNBBBCBHCB
# After step 3: NBBBCNCCNBBNBNBBCHBHHBCHB
# After step 4: NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB
# This polymer grows quickly. After step 5, it has length 97; After step 10, it has length 3073. After step 10, B occurs 1749 times, C occurs 298 times, H occurs 161 times, and N occurs 865 times; taking the quantity of the most common element (B, 1749) and subtracting the quantity of the least common element (H, 161) produces 1749 - 161 = 1588.

# Apply 10 steps of pair insertion to the polymer template and find the most and least common elements in the result. What do you get if you take the quantity of the most common element and subtract the quantity of the least common element?


DEBUG = false

class Polymer
  attr_reader :rules

  def initialize(template)
    @poly = template.chars
    @rules = {}
  end

  def add_rule(parents, child)
    @rules[parents.chars] = child
  end

  def polymerize!
    new_poly = []
    @poly.each_with_index do |char1, i|
      if i == @poly.length - 1 # last char
        new_poly << char1
      else
        char2 = @poly[i+1]
        if new_element = @rules[[char1,char2]]
          new_poly << char1
          new_poly << new_element
        else
          new_s << char1
        end
      end
    end
    @poly = new_poly
  end

  def to_s
    @poly.join
  end

  def print_min_max
    tally = @poly.tally.invert
    min = tally.keys.min
    max = tally.keys.max
    puts "The min is #{tally[min]}, which shows up #{min} times"
    puts "The max is #{tally[max]}, which shows up #{max} times"
    puts "max - min = #{max} - #{min} = #{max - min}"
  end
end

first_line = true
polymer = nil

File.open("./#{DEBUG ? 'sample_' : nil}input.txt").each do |input_line|
  line = input_line.chomp
  if first_line
    polymer = Polymer.new(line)
    first_line = false
    next
  elsif line == ''
    # Noop
  else
    parents, child = line.split(' -> ')
    polymer.add_rule(parents, child)
  end
end

puts polymer.rules.inspect if DEBUG

puts
puts
puts "*******************"
puts "PART I"
puts

puts "Round 0: #{polymer}"

10.times do |n|
  polymer.polymerize!
  puts "Round #{n+1}: #{polymer}"
  polymer.print_min_max
end
