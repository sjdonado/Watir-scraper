require_relative 'modules/console_module'
require_relative 'classes/principal_manager'

sw_cycle = true

while sw_cycle
  case ConsoleModule.menu
  when 1
    # schedule
    PrincipalManager.new.schedule
  when 2
    # unespacio
    PrincipalManager.new.booking
  when 3
    PrincipalManager.new(true).matrix
  when 4
    sw_cycle = false
  else
    puts 'Error!'
  end
end
