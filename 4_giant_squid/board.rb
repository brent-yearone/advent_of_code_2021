class Board
  attr_reader :bingo

  def initialize(numbers)
    @bingo = false
    @numbers = {}
    @board_dimension = numbers.length
    @rows = Array.new(@board_dimension){ @board_dimension }
    @cols = Array.new(@board_dimension){ @board_dimension }
    @marked_numbers = {}
    @score = 0

    numbers.each_with_index do |row, row_index|
      row.each_with_index do |number, col_index|
        @numbers[number] = [row_index, col_index]
      end
    end
  end

  def mark(number)
    row_index, col_index = @numbers[number]
    return if row_index.nil?
    @marked_numbers[number] = true
    @rows[row_index] -= 1
    @cols[col_index] -= 1
    if @rows[row_index] == 0 || @cols[col_index] == 0
      @bingo = true
      @score = number * unmarked_numbers.sum
    end
  end

  def unmarked_numbers
    @numbers.keys - @marked_numbers.keys
  end

  def inspect
    output = "\n"
    rows = Array.new(@board_dimension){ [] }
    index = 0
    @numbers.each do |number, indices|
      rows[indices.first] << (@marked_numbers[number] ? "*#{number}" : number.to_s).rjust(3, ' ')
    end
    rows.each do |row|
      output += row.join(' ') + "\n"
    end
    output += "Score: #{@score}\n"
    output
  end
end
