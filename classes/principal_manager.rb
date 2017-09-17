require_relative '../modules/scraper_module'
require_relative '../modules/console_module'
require_relative '../modules/conflict_matrix'
require_relative 'my_bookings'
require_relative 'schedule'
require_relative 'book_room'

class PrincipalManager

  @@credentials = {}

  def initialize
    @@bot = ScraperModule.create_bot_watir
  end

  def credentials_users
    @@number_users = ConsoleModule.get_number_users
    i = 0
    while i < @@number_users
      credentials = ConsoleModule.get_info
      @@credentials.store(i.to_s, credentials)
      i += 1
    end
  end

  def schedule
    schedule = Schedule.new(@@bot, ConsoleModule.get_info)
    schedule.search_schedule
    # schedule.show_schedule
    # p schedule.schedule
    ConsoleModule.show_table(schedule.schedule, 20)
   # @@bot.screenshot.save('/home/juan/Documents/Projects/ruby/unespacio/ss.png')
 end

  def booking
    booking_room = BookRoom.new(@@bot, ConsoleModule.get_info)
    booking_room.name_rooms
    if booking_room.booking(ConsoleModule.get_room)
      confirm_booking = booking_room.confirm_booking(ConsoleModule.get_time)
      while confirm_booking == false
        puts 'Error!, Room is unavailable'
        confirm_booking = booking_room.confirm_booking(ConsoleModule.get_time)
      end
      my_bookings = MyBookings.new(@@bot)
      my_bookings.build_table
      ConsoleModule.show_my_bookings(my_bookings.table)
    else
      puts 'Select other room'
    end
    # @@bot.screenshot.save('/home/juan/Documents/Projects/ruby/unespacio/ss.png')
  end

  def my_bookings
    my_bookings = MyBookings.new(@@bot, ConsoleModule.get_info)
    my_bookings.build_table
    # my_bookings.table
    ConsoleModule.show_my_bookings(my_bookings.table)
  end

  def matrix
    credentials_users
    @@credentials.each do |_key, credentials|
      # puts "#{key}"
      schedule = Schedule.new(ScraperModule.login_pomelo(@@bot, credentials))
      schedule.search_schedule
      ConflictMatrix.add_schedule(schedule.schedule)
    end
    # pp ConflictMatrix.matrix
    ConsoleModule.show_table(ConflictMatrix.matrix, 16)
   end
end
