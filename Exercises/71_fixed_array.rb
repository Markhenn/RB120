# A fixed-length array is an array that always has a fixed number of elements. Write a class that implements a fixed-length array, and provides the necessary methods to support the following code:

# Problem
# create a class that produces arrays of fixed lenght
# input: an int for the length
#  output: the fixes array object
#
#  when instantiated all elements are nil
#  elements can be reassigned
#  the size of the array is fixes
#     no pushing of new elements
#     no assigning of elements that would increase array size
#
#  def to_a method
#  def to_s method
#  def []= method
#  def == method
#  def [] method
#
#  Examples => see below
#
#  Algorithm:
#  define [](index)
#  @array[index]
#
#

class FixedArray
  def initialize(size)
    @array = Array.new(size)
  end

  def [](index)
    array.fetch(index)
  end

  def []=(index, value)
    self[index]
    array[index] = value
  end

  def to_s
    array.to_a.to_s
  end

  def to_a
    array.clone
  end

  private

  attr_reader :array
end


fixed_array = FixedArray.new(5)
puts fixed_array[3] == nil
puts fixed_array.to_a == [nil] * 5

p  fixed_array.to_a
p  fixed_array.to_a[0].object_id
p  fixed_array.to_a[0] = 'z'
puts fixed_array

fixed_array[3] = 'a'
puts fixed_array[3] == 'a'
puts fixed_array.to_a == [nil, nil, nil, 'a', nil]

fixed_array[1] = 'b'
puts fixed_array[1] == 'b'
puts fixed_array.to_a == [nil, 'b', nil, 'a', nil]

fixed_array[1] = 'c'
puts fixed_array[1] == 'c'
puts fixed_array.to_a == [nil, 'c', nil, 'a', nil]

fixed_array[4] = 'd'
puts fixed_array[4] == 'd'
puts fixed_array.to_a == [nil, 'c', nil, 'a', 'd']
puts fixed_array.to_s == '[nil, "c", nil, "a", "d"]'

puts fixed_array[-1] == 'd'
puts fixed_array[-4] == 'c'

begin
  fixed_array[6]
  puts false
rescue IndexError
  puts true
end

begin
  fixed_array[-7] = 3
  puts false
rescue IndexError
  puts true
end

begin
  fixed_array[7] = 3
  puts false
rescue IndexError
  puts true
end

# The above code should output true 16 times.
