require_relative 'modules/console_module'
require_relative 'classes/manager'

sw_cycle = true
manager = Manager.new

while sw_cycle
  case ConsoleModule.menu
  when 1
    # schedule
    manager.schedule
  when 2
    # unespacio
    manager.booking
  when 3
    manager.my_bookings
  when 4
    manager.matrix
  when 5
    sw_cycle = false
  else
    puts 'Error!'
  end
end
