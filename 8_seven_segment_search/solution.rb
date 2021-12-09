# --- Day 8: Seven Segment Search ---

# You barely reach the safety of the cave when the whale smashes into the cave mouth, collapsing it. Sensors indicate another exit to this cave at a much greater depth, so you have no choice but to press on.

# As your submarine slowly makes its way through the cave system, you notice that the four-digit seven-segment displays in your submarine are malfunctioning; they must have been damaged during the escape. You'll be in a lot of trouble without them, so you'd better figure out what's wrong.

# Each digit of a seven-segment display is rendered by turning on or off any of seven segments named a through g:

#   0:      1:      2:      3:      4:
#  aaaa    ....    aaaa    aaaa    ....
# b    c  .    c  .    c  .    c  b    c
# b    c  .    c  .    c  .    c  b    c
#  ....    ....    dddd    dddd    dddd
# e    f  .    f  e    .  .    f  .    f
# e    f  .    f  e    .  .    f  .    f
#  gggg    ....    gggg    gggg    ....

#   5:      6:      7:      8:      9:
#  aaaa    aaaa    aaaa    aaaa    aaaa
# b    .  b    .  .    c  b    c  b    c
# b    .  b    .  .    c  b    c  b    c
#  dddd    dddd    ....    dddd    dddd
# .    f  e    f  .    f  e    f  .    f
# .    f  e    f  .    f  e    f  .    f
#  gggg    gggg    ....    gggg    gggg
# So, to render a 1, only segments c and f would be turned on; the rest would be off. To render a 7, only segments a, c, and f would be turned on.

# The problem is that the signals which control the segments have been mixed up on each display. The submarine is still trying to display numbers by producing output on signal wires a through g, but those wires are connected to segments randomly. Worse, the wire/segment connections are mixed up separately for each four-digit display! (All of the digits within a display use the same connections, though.)

# So, you might know that only signal wires b and g are turned on, but that doesn't mean segments b and g are turned on: the only digit that uses two segments is 1, so it must mean segments c and f are meant to be on. With just that information, you still can't tell which wire (b/g) goes to which segment (c/f). For that, you'll need to collect more information.

# For each display, you watch the changing signals for a while, make a note of all ten unique signal patterns you see, and then write down a single four digit output value (your puzzle input). Using the signal patterns, you should be able to work out which pattern corresponds to which digit.

# For example, here is what you might see in a single entry in your notes:

# acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab |
# cdfeb fcadb cdfeb cdbaf
# (The entry is wrapped here to two lines so it fits; in your notes, it will all be on a single line.)

# Each entry consists of ten unique signal patterns, a | delimiter, and finally the four digit output value. Within an entry, the same wire/segment connections are used (but you don't know what the connections actually are). The unique signal patterns correspond to the ten different ways the submarine tries to render a digit using the current wire/segment connections. Because 7 is the only digit that uses three segments, dab in the above example means that to render a 7, signal lines d, a, and b are on. Because 4 is the only digit that uses four segments, eafb means that to render a 4, signal lines e, a, f, and b are on.

# Using this information, you should be able to work out which combination of signal wires corresponds to each of the ten digits. Then, you can decode the four digit output value. Unfortunately, in the above example, all of the digits in the output value (cdfeb fcadb cdfeb cdbaf) use five segments and are more difficult to deduce.

# For now, focus on the easy digits. Consider this larger example:

# be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb |
# fdgacbe cefdb cefbgd gcbe
# edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec |
# fcgedb cgb dgebacf gc
# fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef |
# cg cg fdcagb cbg
# fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega |
# efabcd cedba gadfec cb
# aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga |
# gecf egdcabf bgf bfgea
# fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf |
# gebdcfa ecba ca fadegcb
# dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf |
# cefg dcbef fcge gbcadfe
# bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd |
# ed bcgafe cdgba cbgef
# egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg |
# gbdfcae bgc cg cgb
# gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc |
# fgae cfgab fg bagce
# Because the digits 1, 4, 7, and 8 each use a unique number of segments, you should be able to tell which combinations of signals correspond to those digits. Counting only digits in the output values (the part after | on each line), in the above example, there are 26 instances of digits that use a unique number of segments (highlighted above).

# In the output values, how many times do digits 1, 4, 7, or 8 appear?

DEBUG = true

count = 0
File.open("./#{DEBUG ? 'sample_' : nil}input.txt").each do |line|
  digits, outputs = line.chomp.split(' | ')
  puts "#{digits} | #{outputs}" if DEBUG
  # for now, ignore the digits
  outputs.split(' ').each do |output|
    case output.length
    when 2, 4, 3, 7
      count += 1
    else
      # noop
    end
  end
end

puts
puts
puts "*******************"
puts "PART I"

puts "The digits 1, 4, 7, and 8 appear #{count} times in the outputs"



# --- Part Two ---

# Through a little deduction, you should now be able to determine the remaining digits. Consider again the first example above:

# acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab |
# cdfeb fcadb cdfeb cdbaf
# After some careful analysis, the mapping between signal wires and segments only make sense in the following configuration:

#  dddd
# e    a
# e    a
#  ffff
# g    b
# g    b
#  cccc
# So, the unique signal patterns would correspond to the following digits:

# acedgfb: 8
# cdfbe: 5
# gcdfa: 2
# fbcad: 3
# dab: 7
# cefabd: 9
# cdfgeb: 6
# eafb: 4
# cagedb: 0
# ab: 1
# Then, the four digits of the output value can be decoded:

# cdfeb: 5
# fcadb: 3
# cdfeb: 5
# cdbaf: 3
# Therefore, the output value for this entry is 5353.

# Following this same process for each entry in the second, larger example above, the output value of each entry can be determined:

# fdgacbe cefdb cefbgd gcbe: 8394
# fcgedb cgb dgebacf gc: 9781
# cg cg fdcagb cbg: 1197
# efabcd cedba gadfec cb: 9361
# gecf egdcabf bgf bfgea: 4873
# gebdcfa ecba ca fadegcb: 8418
# cefg dcbef fcge gbcadfe: 4548
# ed bcgafe cdgba cbgef: 1625
# gbdfcae bgc cg cgb: 8717
# fgae cfgab fg bagce: 4315
# Adding all of the output values in this larger example produces 61229.

# For each entry, determine all of the wire/segment connections and decode the four-digit output values. What do you get if you add up all of the output values?

puts
puts
puts "*******************"
puts "PART II"

# How many sements does each digit have? { digit => segment_count }
SEGMENT_COUNTS = {
  0 => 6,
  1 => 2, # UNIQUE
  2 => 5,
  3 => 5,
  4 => 4, # UNIQUE
  5 => 5,
  6 => 6,
  7 => 3, # UNIQUE
  8 => 7, # UNIQUE
  9 => 6
}

# How many times does a sement appear in the numbers 0-10? { segment_letter => count }
# SEGEMENT_FREQUENCIES = {
#   'a' => 8,
#   'b' => 6, # UNIQUE
#   'c' => 8,
#   'd' => 7,
#   'e' => 4, # UNIQUE
#   'f' => 9, # UNIQUE
#   'g' => 7
# }

# LETTER_SEGMENTS = {
#   0 => 'abcefg',
#   1 => 'cf',
#   2 => 'acdeg',
#   3 => 'acdfg',
#   4 => 'bcdf',
#   5 => 'abdfg',
#   6 => 'abdefg',
#   7 => 'acf',
#   8 => 'abcdefg',
#   9 => 'abcdfg'
# }

data = {}

class Segment
  attr_reader :chars, :segment, :length

  def initialize(segment)
    @chars = segment.chars.sort
    @segment = @chars.join
    @length = @chars.length
  end

  def &(other_segment)
    Segment.new((@chars & other_segment.chars).join)
  end

  def -(other_segment)
    Segment.new((@chars - other_segment.chars).join)
  end

  def ==(other_segment)
    @segment == other_segment.segment
  end

  def to_s
    @segment
  end

  def inspect
    "\"#{@segment}\""
  end
end

class SolutionMap
  attr_reader :segments

  def initialize
    @segments = {}
    @numbers = {}
  end

  def add(segment, number)
    @segments[segment] = number
    @numbers[number] = segment
  end

  def [](number)
    @numbers[number]
  end

  def lookup_segment(segment)
    key = @segments.keys.find{|k| k == segment}
    @segments[key]
  end

  def inspect
    @numbers.inspect
  end
end

File.open("./#{DEBUG ? 'sample_' : nil}input.txt").each do |line|
  digits, outputs = line.chomp.split(' | ')
  puts "#{digits} | #{outputs}" if DEBUG
  digits = digits.split(' ')
  digits.collect!{|d| Segment.new(d) }
  outputs = outputs.split(' ')
  outputs.collect!{|d| Segment.new(d) }
  data[digits] = outputs
end

puts "Parsed inputs"
puts data.inspect if DEBUG
puts

sum = 0
data.each do |digits, outputs|
  puts if DEBUG
  puts "Processing #{digits} => #{outputs}" if DEBUG
  map = SolutionMap.new

  digits.each do |segment|
    case segment.length # Compare with SEGMENT_COUNTS
    when 2
      map.add(segment, 1)
    when 3
      map.add(segment, 7)
    when 4
      map.add(segment, 4)
    when 7
      map.add(segment, 8)
    end
  end
  puts "Map: #{map.inspect}" if DEBUG

  # 2, 3, and 5 all have 5 segments. They all share segments adg. 3 shares segments cf with 1, which is only cf.
  two_three_five = digits.select{|o| o.length == 5 }
  puts "2,3,5: #{two_three_five.inspect}" if DEBUG
  three = two_three_five.find{|segment| (segment & map[1]) == map[1]}
  map.add(three, 3)
  puts "three: #{three.inspect}" if DEBUG
  puts "map: #{map.inspect}" if DEBUG
  two_five = two_three_five - [three]
  puts "2,5: #{two_five.inspect}" if DEBUG
  adg = two_five.first & two_five.last
  puts "adg: #{adg.inspect}" if DEBUG
  two = two_five.find{|segment| ((segment - adg) & map[4]).length == 1}
  map.add(two, 2)
  five = two_five.select{|segment| segment != two}.first
  map.add(five, 5)
  puts "map: #{map.inspect}" if DEBUG

  # 0, 6, and 9 all have 6 segments. They all share segments abgf.
  zero_six_nine = digits.select{|o| o.length == 6}
  puts "0,6,9: #{zero_six_nine.inspect}" if DEBUG
  six = zero_six_nine.find{|segments| (segments & map[1]).length == 1}
  map.add(six, 6)
  puts "map: #{map.inspect}" if DEBUG
  zero_nine = zero_six_nine - [six]
  nine = zero_nine.find{|segments| (segments & map[4]) == map[4]}
  map.add(nine, 9)
  zero = (zero_nine - [nine]).first
  map.add(zero, 0)
  puts "map: #{map.inspect}" if DEBUG

  # Now, we've solved this particular set of digits, so let's calculate the outputs.
  output_value = outputs.collect{|o| map.lookup_segment(o).to_s}.join
  puts "output value: #{output_value}" if DEBUG
  sum += output_value.to_i
end

puts "Solved! The grand sum is #{sum}"
