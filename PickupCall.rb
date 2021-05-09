class PickupCall
  attr_reader :floor, :direction

  def initialize(floor, direction)
    @floor = floor
    @direction = direction
  end
end
