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

DEBUG = false

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

File.open("./#{DEBUG ? 'sample_' : nil}input.txt").each do |line|
  digits, outputs = line.chomp.split(' | ')
  puts "#{digits} | #{outputs}" if DEBUG
  digits = digits.split(' ')
  digits.collect!{|d| d.chars.sort.join }
  outputs = outputs.split(' ')
  outputs.collect!{|d| d.chars.sort.join }
  data[digits] = outputs
end

puts "Parsed inputs"
puts data.inspect if DEBUG
puts

sum = 0
data.each do |digits, outputs|
  puts if DEBUG
  puts "Processing #{digits} => #{outputs}" if DEBUG
  segment_map = {}
  map = {} # {'cf' => 1}, but customized for this set of digits/outputs
  inverse_map = {}

  digits.each do |segment_characters|
    case segment_characters.length # Compare with SEGMENT_COUNTS
    when 2
      inverse_map[1] = segment_characters
      map[segment_characters] = 1
    when 3
      inverse_map[7] = segment_characters
      map[segment_characters] = 7
    when 4
      inverse_map[4] = segment_characters
      map[segment_characters] = 4
    when 7
      inverse_map[8] = segment_characters
      map[segment_characters] = 8
    else
      nil
    end
  end
  puts "Map: #{map.inspect}" if DEBUG

  # 2, 3, and 5 all have 5 segments. They all share segments adg. 3 shares segments cf with 1, which is only cf.
  two_three_five = digits.select{|o| o.length == 5 }
  two_three_five.collect!(&:chars)
  puts "2,3,5: #{two_three_five.collect(&:join)}" if DEBUG
  three = two_three_five.find{|segments| (segments & inverse_map[1].chars) == inverse_map[1].chars}.join
  map[three] = 3
  inverse_map[3] = three
  puts "three: #{three.inspect}" if DEBUG
  puts "map: #{map.inspect}" if DEBUG
  two_five = two_three_five.reject{|segments| segments == three.chars}
  puts "2,5: #{two_five.collect(&:join)}" if DEBUG
  adg = two_five.first & two_five.last
  puts "adg: #{adg.inspect}" if DEBUG
  two = two_five.find{|segments| ((segments - adg) & inverse_map[4].chars).length == 1}.join
  map[two] = 2
  inverse_map[2] = two
  five = two_five.select{|segments| segments != two.chars}.join
  map[five] = 5
  inverse_map[5] = five
  puts "map: #{map.inspect}" if DEBUG

  # 0, 6, and 9 all have 6 segments. They all share segments abgf.
  zero_six_nine = digits.select{|o| o.length == 6}
  zero_six_nine.collect!(&:chars)
  puts "0,6,9: #{zero_six_nine.collect(&:join)}" if DEBUG
  six = zero_six_nine.find{|segments| (segments & inverse_map[1].chars).length == 1}.join
  map[six] = 6
  inverse_map[6] = six
  puts "map: #{map.inspect}" if DEBUG
  zero_nine = zero_six_nine.reject{|segments| segments == six.chars}
  nine = zero_nine.find{|segments| (segments & inverse_map[4].chars) == inverse_map[4].chars}.join
  map[nine] = 9
  inverse_map[9] = nine
  zero = zero_nine.find{|segments| segments != nine.chars}.join
  map[zero] = 0
  inverse_map[0] = zero
  puts "map: #{map.inspect}" if DEBUG

  output_value = outputs.collect{|o| map[o].to_s}.join
  puts "output value: #{output_value}" if DEBUG
  # Now, we've solved this particular set of digits, so let's calculate the outputs.
  sum += output_value.to_i
end

puts "Solved! The grand sum is #{sum}"
