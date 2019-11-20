class Cat
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def identify
    self
aveas end
end

kitty = Cat.new('Sophie')
p kitty.identify
