class Map
  attr_reader :max_x, :max_y

  def initialize
    @map = {}
    @max_x = 0
    @max_y = 0
  end

  def add_dot(x, y)
    raise ArgumentError, "Coordinates must be non-negative. x was input as #{x}" if x < 0
    raise ArgumentError, "Coordinates must be non-negative. y was input as #{x}" if y < 0
    @max_x = x if x > @max_x
    @max_y = y if y > @max_y
    @map[[x,y]] = true
  end

  def to_s
    s = ""
    (0..@max_y).each do |y|
      (0..@max_x).each do |x|
        s << (@map[[x,y]] ? '#' : '.')
      end
      s << "\n"
    end
    s << "Number of dots: #{dots}\n"
  end

  def dots
    @map.keys.length
  end

  def fold(x: nil, y: nil)
    raise ArgumentError, "Please only provide an X or a Y coordinate along which to fold, not both. We can only make one fold at a time." if x && y
    if y
      @map.keys.each do |x_i,y_i|
        if y_i > y
          add_dot(x_i, (2*y) - y_i)
          @map.delete([x_i, y_i])
        elsif y_i == y
          # This is the fold
          @map.delete([x_i, y_i])
        end
      end
      @max_y = y - 1
    else
      @map.keys.each do |x_i,y_i|
        if x_i > x
          add_dot((2*x) - x_i, y_i)
          @map.delete([x_i, y_i])
        elsif x_i == x
          # This is the fold
          @map.delete([x_i, y_i])
        end
      end
      @max_x = x - 1
    end
  end
end
