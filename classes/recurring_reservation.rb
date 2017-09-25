require_relative '../modules/scraper_module'
require_relative 'recurring_reservation'

class RecurringReservation
  def initialize(browser, credentials)
    @browser = browser
    @credentials = credentials
    @time = {}
  end

  def search_hours(params, time_start)
    time = (params[:duration].to_f / 60).to_f
    time = time % 1 == 0.5 ? (time + 0.5).to_i : time.to_i
    # time change in the cycle
    if time_start.include? 'AM'
      time_start.slice! 'AM'
      time_format = 'AM'
    else
      time_start.slice! 'PM'
      time_format = 'PM'
    end
    time_variable = time_start.split(':')[0].to_i
    i = 1
    while time > 0
      time_verify = time_variable.to_s + ':' + time_start.split(':')[1] + ' ' + time_format
      @time[i] = time_verify.to_s
      if ConflictMatrix.matrix_hour_free(params[:day_name], time_verify.split(' '))
        puts i.to_s + ')' + time_verify.to_s
      end
      time_variable += 1
      time -= 1
      i += 1
    end
  end
end
