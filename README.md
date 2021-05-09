To run: `irb > require 'ElevatorSystem.rb'`

New system: `e = ElevatorSystem.new(5, 5)`

Request pickup: `e.request_pickup(floor: 3, direction: -1)`

Request dropoff: `e.request_dropoff(elevator: 1, floor: 5)`

Pass time, default 1 tempo: `e.time_passed` or `e.time_passed(3)`

