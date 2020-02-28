# Cheat Sheet for LS129 Assesment

module Swimmable
  def swim
    "A #{self.class} can swim!"
  end

  def self.info
    "Behaviour for animals that can swim"
  end
end

class Animal
  include Comparable

  @@number_of_animals = 0

  attr_accessor :name, :age

  def initialize(name)
    @name = name
    @@number_of_animals += 1
  end

  def self.amount
    @@number_of_animals
  end

  def breathing
    'I am breathing'
  end

  protected

  def <=>(other)
    if age > other.age
      1
    elsif age < other.age
      -1
    elsif age == other.age
      0
    end
  end
end

class Mamal < Animal
  def initialize(name, color)
    super(name)
    @color = color
  end

  def gives_birth
    'My offspring sees the world alive'
  end

  def color
    "#{name}'s fur is #{@color}"
  end
end

class Fish < Animal
  include Swimmable

  def lays_eggs
    'My offspring hatches from eggs'
  end

  def breathing
    super + ' under water'
  end
end

class Dog < Mamal
  include Swimmable

  def fetch
    'I like to play fetch'
  end
end

class Cat < Mamal
  MOOD = %w(sleepy relaxed cuddly playful angry)

  def purr
    'Scratch my back and I will purr'
  end

  def mood
    "I am #{random_mood} right now!"
  end

  private

  def random_mood
    MOOD.sample
  end
end

sparky = Dog.new('Sparky', 'golden')
nino = Cat.new('Nino', 'black and white')
nemo = Fish.new('Nemo')

puts sparky.name
puts sparky.fetch
puts sparky.swim
puts sparky.color
puts nino.name
puts nino.purr
puts nino.mood
puts nino.breathing
puts nemo.name
puts nemo.swim
puts nemo.breathing
# puts nino.swim
sparky.age = 10
nino.age = 15
puts sparky > nino
puts Animal.amount
puts Swimmable.info
