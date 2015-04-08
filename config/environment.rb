# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Consume::Application.initialize!

class Logger  
  def format_message(level, time, progname, msg)  
    "%s, [%s] -- %s\n" % [level[0], time.to_s(:db), msg]
  end  
end  
