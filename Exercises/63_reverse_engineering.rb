# Write a class that will display:

# ABC
# xyz
# when the following code is run:
#
# Problem
# a class with two methods that change text to lower and uppercase
# Input: String
# Output: String
#
# Data Structure
# Initialize
# one variable
# set attr reader
#
# def uppercase
#   @var.uppercase
#
# Same for lowercase

class Transform
  attr_reader :word

  def initialize(word)
    @word = word
  end

  def uppercase
    @word.upcase
  end

  def self.lowercase(word)
    word.downcase
  end
end

my_data = Transform.new('abc')
puts my_data.uppercase
puts Transform.lowercase('XYZ')

