class Elevator
  attr_reader :elevator_number

  def initialize(elevator_system, elevator_number)
    @elevator_system = elevator_system
    @current_floor = 1
    @direction = 0
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
    @current_floor = (@current_floor + @direction).clamp(1, @elevator_system.floors)
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
    # check for picking up a pickup_call here
    # needs more complicated logic to check the direction, i.e. stationary
    # todo: define should_pickup_at_current_floor
    if (@elevator_system.pickup_calls.any? { |call| call.floor == @current_floor })
      @elevator_system.floor_picked_up(@current_floor)
      puts "Passenger(s) picked up by elevator ##{@elevator_number} from floor #{@current_floor}"
    end
  end

  def set_next_direction
    # if we are stationary:
    # set direction towards closest dropoff
    # if there are no dropoffs, set direction towards closest pickup
    # if we are moving:
    # check for pickups or dropoffs in current direction
    # continue that way if there are any
    # else check in opposite direction
    # reverse direction if there are any
    # otherwise set to stationary
    if @direction == 0
      closest_dropoff = @dropoff_calls.min_by{ |floor| (floor - @current_floor).abs }
      if closest_dropoff
        @direction = (closest_dropoff - @current_floor).positive? ? 1 : -1
        return
      end
      closest_pickup = @elevator_system.pickup_calls.min_by{ |call| (call.floor - @current_floor).abs }
      if closest_pickup
        @direction = (closest_pickup.floor - @current_floor).positive? ? 1 : -1
        return
      end
    elsif @direction == 1
      dropoffs_up = @dropoff_calls.any? { |call| call > @current_floor }
      pickups_up = @elevator_system.pickup_calls.any? { |call| call.floor > @current_floor }
      return if dropoffs_up || pickups_up
      dropoffs_down = @dropoff_calls.any? { |call| call < @current_floor}
      pickups_down = @elevator_system.pickup_calls.any? { |call| call.floor < @current_floor }
      if dropoffs_down || pickups_down
        @direction = -1
        return
      end
      @direction = 0
    elsif @direction == -1
      dropoffs_down = @dropoff_calls.any? { |call| call < @current_floor}
      pickups_down = @elevator_system.pickup_calls.any? { |call| call.floor < @current_floor }
      return if dropoffs_down || pickups_down
      dropoffs_up = @dropoff_calls.any? { |call| call > @current_floor }
      pickups_up = @elevator_system.pickup_calls.any? { |call| call.floor > @current_floor }
      if dropoffs_up || pickups_up
        @direction = 1
        return
      end
      @direction = 0
    end
  end
end
