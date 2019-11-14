require 'Time'

module Towable
  def can_tow?(pounds)
    pounds < 2000 ? true : false
  end
end

class Vehicle
  attr_accessor :color, :speed
  attr_reader :year, :model
  @@vehicles = 0

  def initialize(year, color, model)
    @year = year
    self.color = color
    @model = model
    self.speed = 0
    @@vehicles += 1
  end

  def self.count
    puts "There are #{@@vehicles} vehicles so far!"
  end

  def self.gas_mileage(miles, tank)
    mpg = miles / tank
    puts "This car's gas mileage is #{mpg} miles per gallon."
  end

  def spray_paint(color='esotiril blue')
    self.color = color
    puts "The #{model} is now #{color}"
  end

  def current_speed
    puts "The #{model} is cruising at #{speed} km/h"
  end

  def start
    puts "#{model} is starting up"
  end

  def break(number)
    self.speed = speed - number > 0 ? speed - number : 0
    puts "The #{model} slowed down to #{speed} km/h"
  end

  def speed_up(number)
    self.speed += number
    puts "The #{model} sped up to #{speed} km/h"
  end

  def turn_off
    self.speed = 0
    puts "The #{model} halted and turned off!"
  end

  def age
    "The #{model} is #{calculate_age} year old."
  end

  private

  def calculate_age
    Time.now.year - year
  end
end

class MyTruck < Vehicle
  include Towable

  VEHICLE = 'Truck'

  def self.what_vehicle
    VEHICLE
  end

  def to_s
    "This truck is a #{model} in #{color} from #{year}"
  end
end

class MyCar < Vehicle
  VEHICLE = 'Car'

  def self.what_vehicle
    VEHICLE
  end

  def to_s
    "This car is a #{model} in #{color} from #{year}"
  end
end

bmw = MyCar.new(2018, 'esotiril blue', 'BMW 2er GT')
puts bmw.year, bmw.color, bmw.model, bmw.speed

bmw.start
bmw.current_speed
bmw.speed_up(63)
bmw.current_speed
bmw.break(8)
bmw.current_speed
bmw.turn_off
bmw.current_speed
bmw.spray_paint('bubbly pink')
bmw.color
bmw.spray_paint
bmw.color
MyCar.gas_mileage(400, 16)
puts bmw
puts MyCar.ancestors

puts MyCar.what_vehicle
man = MyTruck.new(2010, 'silver', 'MAN 12T')
puts man
puts MyTruck.what_vehicle
Vehicle.count
puts man.can_tow?(1800)
man.start
puts bmw.age
puts man.age
bmw.calculate_age
bmw.turn_off




