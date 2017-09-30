require_relative '../modules/scraper_module'
require_relative 'recurring_reservation'
require_relative 'book_room'

class RecurringReservation
  def initialize browser, credentials
    @browser = browser
    @credentials = credentials
    ScraperModule.login_unespacio(@browser, @credentials[0])
    @browser.goto('http://guaymaro.uninorte.edu.co/UNEspacio/index.php?p=FindRoomSS&r=1')
    @browser.select_list(:id, 'cboLocation').select('B_58468bae-fafe-43eb-98de-f7b992f1ac2b')
    @time = {}
  end

  def search_hours(params, time_start)
    @browser.select_list(:id, 'cboDuration').select(params[:duration])
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
    unless time_start.include? '30'
      time_start = time_start.split(':')[0] + ':' + '30'
    end
    time_variable = time_start.split(':')[0].to_i
    time_final = time_variable.to_s + ':' + time_start.split(':')[1] + ' ' + time_format
    i = 1
    while time > 0
      time_verify = time_variable.to_s + ':' + time_start.split(':')[1] + ' ' + time_format
      i += 1 if !ConflictMatrix.matrix_hour_free(params[:day_name], time_verify.split(' ')).nil? && ConflictMatrix.matrix_hour_free(params[:day_name], time_verify.split(' '))
      time_variable += 1
      time -= 1
    end
    if i == 1
      puts 'This day is unavailable'
    else
      @browser.select_list(:id, 'cboStartTime').select((ConflictMatrix.hour(time_final.split(' '))*60+390).to_s)
      @browser.element(css: '#btnAnyDate').click
      BookRoom.search_day(@browser, params[:day], BookRoom.search_month(@browser, params[:month]))
    end
  end

  def name_rooms
    page_html = ScraperModule.parse_html(@browser)
    # page_html. tr.ClickableRow:nth-child(1)
  end
end
