# Behold this incomplete class for constructing boxed banners.

# Problem:
#   input: string -> message
#   output: box with message print

#   create a class that is instantiated with the message and that prints the box when
#   puts is called on the instance.

#   finish implementation

#   Basic approach:
#   set up instance variable for message

#   define horizontal rule
#    +- then add size of message times - and -+ again

#   define empty line
#    add | then message size empty space and | 

class Banner
  def initialize(message)
    @message = message
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  def horizontal_rule
    "+-#{'-' * @message.size}-+"
  end

  def empty_line
    "| #{' ' * @message.size} |"
  end

  def message_line
    "| #{@message} |"
  end
end

# Complete this class so that the test cases shown below work as intended. You are free to add any methods or instance variables you need. However, do not make the implementation details public.

# You may assume that the input will always fit in your terminal window.

# Test Cases

banner = Banner.new('To boldly go where no one has gone before.')
puts banner
# +--------------------------------------------+
# |                                            |
# | To boldly go where no one has gone before. |
# |                                            |
# +--------------------------------------------+
banner = Banner.new('')
puts banner
# +--+
# |  |
# |  |
# |  |
# +--+
