require_relative '../modules/scraper_module'

class RecurringReservation

  def initialize(browser, credentials)
    @browser = browser
    @credentials = credentials
  end

  def search_hours(params, start_time)
    duration = params[:duration].to_i
    while duration < 0
      array_time = start_time.split(':')
      if array[1].include? 'AM'
        minutes = array[1].split('AM')[0] + duration
      else
      end
      hour = array[0] +
      matrix_hour_free(params[:day], params)
    end
  end

end
