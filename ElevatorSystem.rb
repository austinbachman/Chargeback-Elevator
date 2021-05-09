require_relative 'Elevator.rb'
require_relative 'PickupCall.rb'

class ElevatorSystem
  def initialize(elevators_count, floors)
    raise ArgumentError.new 'Invalid elevator count' unless valid_int?(elevators_count)
    raise ArgumentError.new 'Invalid floor count' unless valid_int?(floors)
    @elevators = Array.new(elevators_count) { |i| Elevator.new(i + 1) }
    @floors = floors
    @pickup_calls = []
  end

  def time_passed(time = 1)
    raise ArgumentError.new 'Invalid time' unless valid_int?(time)
    time.times do
      @elevators.map(&:pass_time)
    end
  end

  def request_pickup(floor:, direction:)
    raise ArgumentError.new 'Invalid floor' unless floor.between?(1, @floors)
    raise ArgumentError.new 'Direction invalid - must be -1 or 1' unless [-1,1].include? direction
    @pickup_calls << PickupCall.new(floor, direction)
  end

  def request_dropoff(elevator:, floor:)
    raise ArgumentError.new 'Invalid floor' unless floor.between?(1, @floors)
    ev = @elevators.find { |e| e.elevator_number == elevator }
    raise ArgumentError.new 'Invalid elevator' unless ev.present?
    ev.request_dropoff(floor)
  end

  private

  def valid_int?(value)
    value.to_i > 0
  end

end
