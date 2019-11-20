# pratice for LS RB Class

class Person
  def initialize(full_name)
    @name = full_name
  end

  def name
    @name
  end

  def name=(name)
    @name = name.split.first
  end
end

p bob = Person.new('Robert')
p bob.name                  # => 'Robert'

p bob.name = "John Adams"
p bob.name
p bob.name=("John Maynard Adams")
p bob.name
