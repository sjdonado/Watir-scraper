require_relative '../modules/scraper_module'
require_relative 'recurring_reservation'

class RecurringReservation

  def initialize(browser, credentials)
    @browser = browser
    @credentials = credentials
  end

  def search_hours(params, time_start)
    time = (params[:duration].to_f/60).to_f
    time = time % 1 == 0.5 ? (time + 0.5).to_i : time.to_i
    while time > 0
      time_verify = (time_start.split(':')[0].to_i + 1).to_s + time_start.split(':')[1]
      puts time_verify + '->' + ConflictMatrix.matrix_hour_free(params[:day_name], time_verify).to_s
      time -= 1
    end
  end

end
