# Alyssa has been assigned a task of modifying a class that was initially created to keep track of secret information. The new requirement calls for adding logging, when clients of the class attempt to access the secret data. Here is the class in its current form:

class SecretFile
  def initialize(secret_data, logger)
    @data = secret_data
    @log = logger
  end

  def data
    @log.create_log_entry
    @data
  end
end
# She needs to modify it so that any access to data must result in a log entry being generated. That is, any call to the class which will result in data being returned must first call a logging class. The logging class has been supplied to Alyssa and looks like the following:

class SecurityLogger
  def create_log_entry
    # ... implementation omitted ...
  end
end
# Hint: Assume that you can modify the initialize method in SecretFile to have an instance of SecurityLogger be passed in as an additional argument.

# Problem
# log everytime the secret is read
# When the data is returned a logging class is called first
#
# How to solve
# add a logging object as argument to initialize of SecretFile
# create instance var named logging and assign logger
# delete attr_reader
# def method to return data
#   call create_log_entry on @log
#   return @data
