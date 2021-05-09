require_relative 'Elevator.rb'

class ElevatorSystem
  def initialize(elevators_count, floors)
    # need to validate params here
    @elevators = Array.new(elevators_count) { Elevator.new }
    @floors = floors
  end

  def time_passed(n = 1)
    n.times do
      # pass time here
    end
  end


end
