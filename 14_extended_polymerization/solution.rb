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
  attr_reader :rules, :elements

  def initialize(template)
    @pairs = Hash.new{ 0 }
    @elements = Hash.new{ 0 }
    template.length.times do |i|
      @elements[template[i]] += 1
      next if i == template.length - 1
      @pairs[template[i..i+1]] += 1
    end
    @rules = {}
  end

  def add_rule(parents, child)
    @rules[parents] = child
  end

  def polymerize!
    new_pairs = Hash.new{ 0 }
    last_pair = @pairs.keys.last
    @pairs.each do |pair, count|
      if new_element = @rules[pair]
        @elements[new_element] += count
        new_pairs["#{pair[0]}#{new_element}"] += count
        new_pairs["#{new_element}#{pair[1]}"] += count
      else
        new_pairs[pair] = count
      end
    end
    @pairs = new_pairs
  end

  def to_s
    "#{@pairs.inspect} (#{@elements.inspect})"
  end

  def print_min_max
    min = @elements.values.min
    max = @elements.values.max
    puts "The min element appears #{min} times in the polymer"
    puts "The max element appears #{max} times in the polymer"
    puts "max - min = #{max} - #{min} = #{max - min}"
  end
end

first_line = true
polymer = nil

File.open("./#{DEBUG ? 'sample_' : nil}input.txt").each do |input_line|
  line = input_line.chomp
  if first_line
    polymer = Polymer.new(line)
    puts "Polymer: #{line}" if DEBUG
    first_line = false
    next
  elsif line == ''
    # Noop
  else
    parents, child = line.split(' -> ')
    polymer.add_rule(parents, child)
  end
end

puts "Rules: #{polymer.rules.inspect}" if DEBUG

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

puts
puts
puts "*******************"
puts "PART II"
puts

30.times do |n|
  polymer.polymerize!
  polymer.print_min_max
end
