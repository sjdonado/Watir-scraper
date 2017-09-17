require_relative '../modules/scraper_module'
require_relative '../modules/console_module'
require_relative '../modules/conflict_matrix'
require_relative 'schedule'
require_relative 'book_room'

class PrincipalManager
  @@credentials = {}

  def initialize(user = false)
    @@bot = ScraperModule.create_bot_watir
    if user
      @@number_users = ConsoleModule.get_number_users
      i = 0
      while i < @@number_users
        credentials = ConsoleModule.get_info
        @@credentials.store(i.to_s, credentials)
        i += 1
      end
    else
      credentials = ConsoleModule.get_info
      @@credentials.store(0, credentials)
    end
  end

  def schedule
    schedule = Schedule.new(ScraperModule.login_pomelo(@@bot, @@credentials[0]))
    schedule.search_schedule
    # schedule.show_schedule
    p schedule.schedule
    ConsoleModule.show_table(schedule.schedule)
    @@boot.screenshot.save('/home/juan/Documents/Projects/ruby/unespacio/ss.png')
 end

  def booking
    booking_room = BookRoom.new(ScraperModule.login_unespacio(@@bot, @@credentials[0]))
    booking_room.name_rooms
    if booking_room.booking(ConsoleModule.get_room)
      confirm_booking = booking_room.confirm_booking(ConsoleModule.get_time)
      while confirm_booking == false
        puts 'Error!, Room is unavailable'
        confirm_booking = booking_room.confirm_booking(ConsoleModule.get_time)
      end
    else
      puts 'Select other room'
    end
    @@boot.screenshot.save('/home/juan/Documents/Projects/ruby/unespacio/ss.png')
  end

  def matrix
    @@credentials.each do |_key, credentials|
      # puts "#{key}"
      schedule = Schedule.new(ScraperModule.login_pomelo(@@bot, credentials))
      schedule.search_schedule
      ConflictMatrix.add_schedule(schedule.schedule)
    end
    # ConsoleModule.show_table(ConflictMatrix.matrix)
    pp ConflictMatrix.matrix
   end
end
