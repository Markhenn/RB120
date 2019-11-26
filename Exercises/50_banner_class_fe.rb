# Behold this incomplete class for constructing boxed banners.

# Problem:
  # add an optional argument to new with a fixed banner width

  # use String center method
  # check if message size is longer than given width
  #   if yes => set width to message size
  #   else to width

  # horizontal rule will be width * -
  # empty line same

class Banner
  def initialize(message, width=0)
    @message = message
    @width = message.size > width ? message.size : width
  end

  def to_s
    [horizontal_rule, empty_line, message_line, empty_line, horizontal_rule].join("\n")
  end

  private

  def horizontal_rule
    "+-#{'-' * @width}-+"
  end

  def empty_line
    "| #{' ' * @width} |"
  end

  def message_line
    "| #{@message.center(@width, ' ')} |"
  end
end

# Test Cases

banner = Banner.new('To boldly go where no one has gone before.')
puts banner
banner = Banner.new('To boldly go where no one has gone before.', 65)
puts banner
banner = Banner.new('To boldly go where no one has gone before.', 20)
puts banner
# +--------------------------------------------+
# |                                            |
# | To boldly go where no one has gone before. |
# |                                            |
# +--------------------------------------------+
banner = Banner.new('')
puts banner
banner = Banner.new('', 65)
puts banner
banner = Banner.new('', 5)
puts banner
# +--+
# |  |
# |  |
# |  |
# +--+
