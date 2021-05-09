require_relative 'Constants.rb'

class Elevator
  include Constants

  attr_reader :elevator_number

  def initialize(elevator_system, elevator_number)
    @elevator_system = elevator_system
    @current_floor = BOTTOM_FLOOR
    @direction = STATIONARY
    @elevator_number = elevator_number
    @dropoff_calls = []
  end

  def pass_time
    # first we drop off passengers if this floor has been requested
    perform_dropoffs
    # then we pickup if this floor has requested a pickup
    perform_pickups
    # set next direction based on requests for dropoffs and pickups
    set_next_direction
    # set next floor
    @current_floor = (@current_floor + @direction).clamp(BOTTOM_FLOOR, @elevator_system.floors)
  end

  def request_dropoff(floor)
    @dropoff_calls << floor
  end

  private

  def perform_dropoffs
    if @dropoff_calls.delete(@current_floor)
      puts "Passenger(s) dropped off by elevator ##{@elevator_number} at floor #{@current_floor}"
    end
  end

  def perform_pickups
    if should_pickup_at_current_floor?
      @elevator_system.floor_picked_up(@current_floor)
      puts "Passenger(s) picked up by elevator ##{@elevator_number} from floor #{@current_floor}"
    end
  end

  def should_pickup_at_current_floor?
    if stationary?
      @elevator_system.pickup_calls.any? { |call| call.floor == @current_floor }
    else
      @elevator_system.pickup_calls.any? { |call| call.floor == @current_floor && call.direction == @direction }
    end
  end

  def set_next_direction
    @direction = stationary? ? set_direction_from_stationary : set_direction_from_moving
  end

  def set_direction_from_stationary
    # set direction towards closest dropoff
    closest_dropoff = @dropoff_calls.min_by{ |floor| (floor - @current_floor).abs }
    if closest_dropoff
      return (closest_dropoff - @current_floor).positive? ? UP : DOWN
    end
    # if there are no dropoffs, set direction towards closest pickup
    closest_pickup = @elevator_system.pickup_calls.min_by{ |call| (call.floor - @current_floor).abs }
    if closest_pickup
      return (closest_pickup.floor - @current_floor).positive? ? UP : DOWN
    end
    @direction
  end

  def set_direction_from_moving
    dropoffs_up, dropoffs_down = @dropoff_calls.partition { |call| call > @current_floor }
    pickups_up, pickups_down = @elevator_system.pickup_calls.partition { |call| call.floor > @current_floor }
    stops_upwards = dropoffs_up.any? || pickups_up.any?
    stops_downwards = dropoffs_down.any? || pickups_down.any?
    # check for pickups or dropoffs in current direction
    keep_going_up = going_up? && stops_upwards
    keep_going_down = going_down? && stops_downwards
    keep_current_direction = keep_going_up || keep_going_down
    # continue that way if there are any
    return @direction if keep_current_direction
    # else check in opposite direction
    start_going_up = going_down? && stops_upwards
    start_going_down = going_up? && stops_downwards
    reverse_direction = start_going_up || start_going_down
    # reverse direction if there are any
    return reverse(@direction) if reverse_direction
    # otherwise set to stationary
    return 0
  end

  def reverse(direction)
    direction * -1
  end

  DIRECTIONS.each do |_, dir|
    define_method "#{dir[:description]}?" do
      @direction == dir[:value]
    end
  end
end
