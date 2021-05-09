class Elevator
  attr_reader :elevator_number

  def initialize(elevator_number)
    @current_floor = 0
    @direction = 0
    @elevator_number = elevator_number
    @dropoff_calls = []
  end

  def pass_time
    # perform dropoffs
    # perform pickups
    # set new direction
    # set new floor
  end

  def request_dropoff(floor)
    @dropoff_calls << floor
  end
end
