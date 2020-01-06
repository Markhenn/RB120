class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age  = 0
  end

  def make_one_year_older
    self.age = age + 1
  end
end

nino = Cat.new('house')
puts nino.age
nino.make_one_year_older
puts nino.age

