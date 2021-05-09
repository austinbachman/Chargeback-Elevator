require_relative 'Elevator.rb'
require_relative 'PickupCall.rb'

class ElevatorSystem
  attr_reader :pickup_calls, :floors

  def initialize(elevators:, floors:)
    raise ArgumentError.new 'Invalid elevator count' unless valid_int?(elevators)
    raise ArgumentError.new 'Invalid floor count' unless valid_int?(floors)
    @elevators = Array.new(elevators) { |i| Elevator.new(self, i + 1) }
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
    @pickup_calls << PickupCall.new(floor, direction)
    "Pickup requested from floor #{floor}"
  end

  def request_dropoff(elevator:, floor:)
    raise ArgumentError.new 'Invalid floor' unless floor.between?(1, @floors)
    ev = @elevators.find { |e| e.elevator_number == elevator }
    raise ArgumentError.new 'Invalid elevator' if ev.nil?
    ev.request_dropoff(floor)
    "Dropoff requested in elevator ##{ev.elevator_number} at floor #{floor}"
  end

  def status_report
    @elevators.map(&:print_status)
  end

  def floor_picked_up(floor)
    pickup_calls.delete_if { |c| c.floor == floor }
  end

  private

  def valid_int?(value)
    value.to_i > 0
  end
end
