require 'console_view_helper'
require 'date'

module ConsoleModule
  # Principal menu
  def self.menu
    puts 'Select a option'
    puts ConsoleViewHelper.menu(%w[Schedule Bookings Matrix Exit], li_gap: 1)
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

  # Room's params
  def self.get_room
    puts 'Room Number'
    room = ConsoleViewHelper.input
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
    { room: room, duration: duration, month: Date::MONTHNAMES[month.to_i] + ' ' + year, day: day }
  end

  def self.get_time
    puts 'Time'
    ConsoleViewHelper.input
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

  # Allows show an array in a table form
  def self.show_table(array)
    puts ConsoleViewHelper.table(array)
    # puts ConsoleViewHelper.table(array, header: %w(LUNES MARTES MIERCOLES JUEVES VIERNES SABADO), cell_width: 24)
  end
end
