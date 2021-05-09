To run: `irb > require 'ElevatorSystem.rb'`

New elevator system: `e = ElevatorSystem.new(elevators: 5, floors: 5)`

Request pickup: `e.request_pickup(floor: 3, direction: :down)`

Request dropoff: `e.request_dropoff(elevator: 1, floor: 5)`

Pass time, default 1 tempo: `e.time_passed` or `e.time_passed(3)`

Print status: `e.status_report`

We allow a pickup or dropoff of passengers at any time from any floor or elevator, since real-world elevator systems have no concept of a passenger, due to the unpredictable nature of human behavior.
