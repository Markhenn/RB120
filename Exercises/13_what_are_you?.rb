# Using the code from the previous exercise, add an #initialize method that prints I'm a cat! when a new Cat object is initialized.

module Walkable
  def walk
    puts "Let's go for a walk!"
  end
end

class Cat
  include Walkable

  attr_accessor :name

 def initialize(n)
    @name = n
  end
  
  def greet
    puts "Hello my name is #{name}!"
  end
end

kitty = Cat.new('Sophie')
kitty.greet
kitty.walk
