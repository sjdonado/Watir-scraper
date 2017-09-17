require_relative 'modules/console_module'
require_relative 'classes/principal_manager'

sw_cycle = true
manager = PrincipalManager.new

while sw_cycle
  case ConsoleModule.menu
  when 1
    # schedule
    manager.schedule
  when 2
    # unespacio
    manager.booking
  when 3
    manager.matrix
  when 4
    manager.view_bookings
  when 5
    sw_cycle = false
  else
    puts 'Error!'
  end
end
