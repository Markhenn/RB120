class Machine
  def start
    flip_switch(:on)
  end

  def stop
    flip_switch(:off)
  end

  def current_state
    switch || :off
  end

  private

  attr_accessor :switch

  def flip_switch(desired_state)
    self.switch = desired_state
  end
end

# Modify this class so both flip_switch and the setter method switch= are private methods.
#

radio = Machine.new
puts radio.current_state
radio.start
puts radio.current_state
radio.stop
puts radio.current_state
