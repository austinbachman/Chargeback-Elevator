require_relative 'Constants.rb'

class PickupCall
  include Constants

  attr_reader :floor, :direction

  def initialize(floor, direction)
    raise ArgumentError.new 'Direction invalid - must be :up or :down' unless [:up, :down].include? direction
    @floor = floor
    @direction = DIRECTIONS[direction][:value]
  end
end
