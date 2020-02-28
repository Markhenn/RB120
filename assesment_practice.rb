module Mixin
  attr_reader :module_var

  MOD_CONST = 'Mod Constant'

  @@mod_var = 0

  def mod_var_instance
    @@mod_var += 1
    @@mod_var
  end

  def self.mod_method
    @@mod_var += 1
    @@mod_var
  end

  def mod_const
    MOD_CONST
  end

  def print_var
    @instance_var
  end

  def print_test
    "#{self.class::TEST} for a Test"
  end

  def create_inst_var
    @module_var = 'Module Var'
  end

  def print_inst_var
    @module_var
  end
end

class TestClass
  include Mixin
  TEST = 'test'
  @@outside_method_self = self


  def initialize(input)
    @instance_var = input
  end

  def get_inside_method_self
    self
  end

  def self.get_outside_method_self
    puts self #TestClass
    p @instance_var
    @@outside_method_self
  end

  def shadowing
    puts 'Instance value: ' + instance_var
    instance_var = 'this is different'
    puts 'shadowed value: ' + instance_var
    self.instance_var = 'input 2'
    puts 'Instance value changed: ' + @instance_var
    # puts 'Instance value: ' + self.instance_var
  end

  def class_method_test
    @@outside_method_self
  end

  def mod_var_getter
    @@mod_var += 1
    @@mod_var
  end

  def this_is_public
    puts instance_var
    self.instance_var = 'New input'
    puts instance_var
    this_is_private
  end

  private

  attr_reader :instance_var
  attr_writer :instance_var

  def this_is_private
    'PRIVATE!'
  end
end

class Child < TestClass
  TEST = 'Test in Child'

  puts "This is the child class. #{self.class}"
end

test = TestClass.new("input")
puts test.get_inside_method_self ##<TestClass:0x00000001e4b410>
puts TestClass.get_outside_method_self #TestClass
puts test.print_test
puts test.class_method_test
# puts test.get_outside_method_self
puts TestClass.class
puts '-----Ancestors------'
puts TestClass.ancestors
puts
puts test.shadowing
puts test.create_inst_var
puts test.print_inst_var
puts test.module_var
puts Mixin::MOD_CONST
puts test.mod_const
puts test.print_var
puts test
p test
puts Mixin.mod_method
puts test.mod_var_getter
puts test.mod_var_instance
puts test.this_is_public
puts Child::TEST
