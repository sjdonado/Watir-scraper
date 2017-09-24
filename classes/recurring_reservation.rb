require_relative '../modules/scraper_module'

class RecurringReservation

  def initialize(browser, credentials)
    @browser = browser
    @credentials = credentials
  end

  def search_hours(duration)
    time = duration.to_f/60
    time = time % 1 == 0.5 ? time + 0.5 : time/60
    time.to_i
  end

end
