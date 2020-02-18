# Write a class that implements a miniature stack-and-register-based programming language that has the following commands:

# n Place a value n in the "register". Do not modify the stack.
# PUSH Push the register value on to the stack. Leave the value in the register.
# ADD Pops a value from the stack and adds it to the register value, storing the result in the register.
# SUB Pops a value from the stack and subtracts it from the register value, storing the result in the register.
# MULT Pops a value from the stack and multiplies it by the register value, storing the result in the register.
# DIV Pops a value from the stack and divides it into the register value, storing the integer result in the register.
# MOD Pops a value from the stack and divides it into the register value, storing the integer remainder of the division in the register.
# POP Remove the topmost item from the stack and place in register
# PRINT Print the register value
# All operations are integer operations (which is only important with DIV and MOD).

# Programs will be supplied to your language method via a string passed in as an argument. Your program should produce an error if an unexpected item is present in the string, or if a required stack value is not on the stack when it should be (the stack is empty). In all error cases, no further processing should be performed on the program.

# You should initialize the register to 0.
#
# Problem:
# Write the oop version of the mini lang
# input: string of commands
# output: a number or error message
#
# Each command from the string must be evaluated and exercised
#   this leads to a calculation
#   or an error
#
# Data Structure:
#   array for stack
#   int for register
#   each command is a method that can be called by send from the string
#
# Algorithm
#   create eval method to start
#   loops over all commands
#   sends the command to the method implicated
#   if integer -> pt in register
#

class MiniLangError < StandardError; end
class BadTokenError < MiniLangError; end
class EmptyStackError < MiniLangError; end

puts MiniLangError.ancestors
puts String.ancestors

class Minilang
  ACTIONS = %w(PRINT POP PUSH ADD SUB MULT DIV MOD)

  def initialize(commands)
    @commands = commands
  end

  def eval
    @register = 0
    @stack = []
    @commands.split.each { |command| eval_command(command) }

  rescue MiniLangError => e
    puts e.message
  end

  def eval_command(command)
    if ACTIONS.include?(command)
      send(command.downcase)
    elsif command =~ /\A[-+]?\d+\z/
      @register = command.to_i
    else
      raise BadTokenError, "Invalid token: #{command}"
    end
  end

  private

  def print
    puts @register
  end

  def push
    @stack << @register
  end

  def mult
    @register *= pop
  end

  def add
    @register += pop
  end

  def sub
    @register -= pop
  end

  def div
    @register /= pop
  end

  def mod
    @register %= pop
  end

  def pop
    raise EmptyStackError, 'Empty Stack!' if @stack.empty?
    @register = @stack.pop
  end
end

# Examples:

Minilang.new('PRINT').eval
# 0

Minilang.new('5 PUSH 3 MULT PRINT').eval
# 15

Minilang.new('5 PRINT PUSH 3 PRINT ADD PRINT').eval
# 5
# 3
# 8

Minilang.new('5 PUSH 10 PRINT POP PRINT').eval
# 10
# 5

Minilang.new('5 PUSH POP POP PRINT').eval
# Empty stack!

Minilang.new('3 PUSH PUSH 7 DIV MULT PRINT ').eval
# 6

Minilang.new('4 PUSH PUSH 7 MOD MULT PRINT ').eval
# 12

Minilang.new('-3 PUSH 5 XSUB PRINT').eval
# Invalid token: XSUB

Minilang.new('-3 PUSH 5 SUB PRINT').eval
# 8

Minilang.new('6 PUSH').eval
# (nothing printed; no PRINT commands)

class MinilangConversion < Minilang
  def eval(to_convert: 0)
    original_commands = @commands
    @commands = format(@commands, to_convert: to_convert)

    super()

    @commands = original_commands
  end
end

CENTIGRADE_TO_FAHRENHEIT =
  '5 PUSH %<to_convert>d PUSH 9 MULT DIV PUSH 32 ADD PRINT'

minilang = MinilangConversion.new(CENTIGRADE_TO_FAHRENHEIT)
minilang.eval(to_convert: 100)
# 212
minilang.eval(to_convert: 0)
# 32
minilang.eval(to_convert: -40)
# -40

MPH_TO_KPH = '3 PUSH %<to_convert>d PUSH 5 MULT DIV PRINT'
minilang = MinilangConversion.new(MPH_TO_KPH)
minilang.eval(to_convert: 70)
# 116
minilang.eval(to_convert: 45)
# 75
minilang.eval(to_convert: 50)
# 83

class MinilangMultipleInputs < Minilang
  def eval(**inputs)
    original_commands = @commands

  begin
    @commands = format(@commands, inputs)
  rescue
    return puts 'Not enough values passed in!'
  end

    super()

    @commands = original_commands
  end
end

RECTANGLE_AREA = '%<value_1>d PUSH %<value_2>d MULT PRINT'

rectangle = MinilangMultipleInputs.new(RECTANGLE_AREA)
input = {value_1: 5, value_2: 5}
rectangle.eval(input)
# 25

CIRCUMFENCE =
  "%<value_1>d PUSH %<value_2>d PUSH %<value_3>d PUSH %<value_4>d "\
    "ADD ADD ADD PRINT"

circ_rec = MinilangMultipleInputs.new(CIRCUMFENCE)
input = {value_1: 2, value_2: 5, value_3: 2}
circ_rec.eval(input)
# 14


# Try to implement this modification. Also, try writing other minilang programs, such as one that converts fahrenheit to centigrade, another that converts miles per hour to kilometers per hour (3 mph is approximately equal to 5 kph). Try writing a program that needs two inputs: for example, compute the area of a rectangle.
#
# Problem
# Update eval to take an extra param of centigrade
# preset register to the param
# add a MULT in front of the token
