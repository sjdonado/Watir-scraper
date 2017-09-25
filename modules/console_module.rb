require 'console_view_helper'
require 'date'

module ConsoleModule
  # Principal menu
  def self.menu
    puts 'Menu'
    puts ConsoleViewHelper.menu(%w[Schedule Bookings My-bookings Matrix Exit], li_gap: 1)
    puts 'Select a option'
    ConsoleViewHelper.input.to_i
  end

  # For get user information
  def self.get_info
    puts 'User uninorte'
    user = ConsoleViewHelper.input
    puts 'Pass'
    pass = ConsoleViewHelper.hidden_input
    puts 'Loading...'
    { user: user, pass: pass }
  end

  # Number of users
  def self.get_number_users
    puts 'Number of users'
    ConsoleViewHelper.input.to_i
  end

  def self.get_room
    puts 'Room Number'
    ConsoleViewHelper.input
  end

  # Time's params
  def self.get_date
    sw = true
    while sw
      puts 'Year (2017, 2018, 2019...)'
      year = ConsoleViewHelper.input
      puts 'Month (1, 2, 3...)'
      month = ConsoleViewHelper.input
      puts 'Day'
      day = ConsoleViewHelper.input
      sw = verfify_date(year, month, day)
    end
    puts 'Duration (30, 60, 90...) minutes'
    duration = ConsoleViewHelper.input
    puts 'Loading...'
    date = Date.parse(day + '-' + month + '-' + year)
    date_array = date.strftime("%A").split('')
    puts date = date_array[0] + date_array[1] + date_array[2]
    { duration: duration, month: Date::MONTHNAMES[month.to_i] + ' ' + year, day: day, day_name: date}
  end

  def self.get_time
    puts 'Time'
    ConsoleViewHelper.input
  end

  def self.get_start_hour
    puts 'Start hour (2:30PM, 12:30AM, 7:00AM...)'
    ConsoleViewHelper.input
  end

  def self.my_bookings_menu
    puts ConsoleViewHelper.menu(%w[Room-Details Cancel-booking Exit], li_gap: 1)
    ConsoleViewHelper.input.to_i
  end

  def self.my_bookings_select
    puts 'Select a booking'
    ConsoleViewHelper.input.to_i
  end

  # Allows show an array in a table form
  def self.show_table(array, width)
    # puts ConsoleViewHelper.table(array)
    puts ConsoleViewHelper.table([%w(6:30AM-7:29AM 7:30AM-8:29AM 8:30AM-9:29AM 9:30AM-10:29AM 10:30AM-11:29AM 11:30AM-12:29AM 12:30AM-1:29PM 1:30PM-2:29PM 2:30PM-3:29PM 3:30PM-4:29PM 4:30PM-5:29PM 5:30PM-6:29PM 6:30PM-7:29PM 7:30PM-8:29PM), array[0], array[1], array[2], array[3], array[4], array[5]], header: %w(TIME MONDAY TUESDAY WEDNESDAY THURSDAY FRIDAY SATURDAY), cell_width: width)
  end

  def self.show_my_bookings(array)
    puts ConsoleViewHelper.table([array[0], array[1], array[2], array[3], array[4]], cell_width: 28)
  end

  def self.verfify_date(year, month, day)
    sw = false
    if year.to_i < time.year
      sw = true
      puts 'Error, date not valid for year specified'
    end
    if month.to_i == time.month && month.to_i < time.month
      sw = true
      puts 'Error, date not valid for month specified'
    end
    if month.to_i == time.month && day.to_i < time.day
      sw = true
      puts 'Error, date not valid for day specified'
    end
    sw
  end

  def self.time
    Time.new
  end

  def self.clean_screen
    system('clear')
  end

end
