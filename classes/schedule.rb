require_relative '../modules/scraper_module'
require_relative '../modules/conflict_matrix'

class Schedule

  attr_reader :schedule

  def initialize(browser, credentials = nil)
    @schedule = Array.new(6){Array.new(14)}
    @browser = credentials.nil? ? browser : ScraperModule.login_pomelo(browser, credentials)
  end

  # search schedule params
  def search_schedule
    @browser.goto(ScraperModule.url[:horario_pomelo])
    select_term
    @browser.element(css: 'body > div.pagebodydiv > form > input[type="submit"]').click
    page_html = ScraperModule.parse_html(@browser)
    page_html = page_html.css('tbody > tr')
    i = -1
    page_html.each do |n|
      if n.content.include? 'Clase regular'
        content = n.content.split("\n")
        name_content = page_html.xpath('/html/body/div[3]/table[' + i.to_s + ']/caption').text
        add_schedule(content[2], ConflictMatrix.day(content[3]), name_content)
      end
      if n.content.include? 'Periodo Asociado'
        i += 2
      end
    end
  end

  # add to matrix
  def add_schedule(time, day, content)
    array = time.split(' - ')
    time_start = ConflictMatrix.hour(array[0].split(' '))
    time_finish = ConflictMatrix.hour(array[1].split(' '))
    # puts "Day: " + day + " time_start: " + time_start.to_s + " time_finish: " + time_finish.to_s + " content: " + content
    case time_finish - time_start
    when 1
      @schedule[day][time_start] = content
    when 2
      @schedule[day][time_start] = content
      @schedule[day][time_start + 1] = content
    when 3
      @schedule[day][time_start] = content
      @schedule[day][time_start + 1] = content
      @schedule[day][time_start + 2] = content
    end
  end

  def select_term
    time = ConsoleModule.time
    if time.month > 6
      select_id = time.year.to_s + '30'
    else
      select_id = time.year.to_s + '10'
    end
    @browser.select_list(:id, 'term_id').select(select_id)
  end

  def show_schedule
    @schedule.each do |day|
      # day.each do |subject|
      #   if subject != nil
      #     puts subject
      #   end
      # end
      day.each { |subject| p subject }
    end
  end
end
