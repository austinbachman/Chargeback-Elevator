require_relative 'Elevator.rb'
require_relative 'PickupCall.rb'

class ElevatorSystem
  def initialize(elevators_count, floors)
    # need to validate params here
    raise ArgumentError.new 'Invalid elevator count' unless valid_int?(elevators_count)
    raise ArgumentError.new 'Invalid floor count' unless valid_int?(floors)
    @elevators = Array.new(elevators_count) { Elevator.new }
    @floors = floors
    @pickup_calls = []
  end

  def time_passed(n = 1)
    n.times do
      # pass time here
    end
  end

  def request_pickup(floor:, direction:)
    # validate floor and direction
    raise ArgumentError.new 'Invalid floor' unless floor.between?(1, @floors)
    raise ArgumentError.new 'Direction invalid - must be -1 or 1' unless [-1,1].include? direction
    @pickup_calls << PickupCall.new(floor, direction)
  end

  private

  def valid_int?(value)
    value.to_i > 0
  end


end
