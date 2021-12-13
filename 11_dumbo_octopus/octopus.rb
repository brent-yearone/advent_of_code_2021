class Octopus
  attr_reader :energy

  def initialize(energy)
    @energy = energy
  end

  def flash?
    @energy == 10
  end

  def flashed?
    @energy >= 10
  end

  def increment
    @energy += 1
  end

  def next_iteration
    if @energy >= 10
      @energy = 0
    end
  end
end
