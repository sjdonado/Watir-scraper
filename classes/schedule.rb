require_relative '../modules/scraper_module'

class Schedule

  @@schedule = Array.new(6){Array.new(14)}

  def initialize(browser, credentials = nil)
    @@browser = credentials.nil? ? browser : ScraperModule.login_pomelo(browser, credentials)
  end

  # search schedule params
  def search_schedule
    @@browser.goto(ScraperModule.url[:horario_pomelo])
    select_term
    @@browser.element(css: 'body > div.pagebodydiv > form > input[type="submit"]').click
    page_html = ScraperModule.parse_html(@@browser)
    page_html = page_html.css('tbody > tr')
    i = -1
    page_html.each do |n|
      if n.content.include? 'Clase regular'
        content = n.content.split("\n")
        name_content = page_html.xpath('/html/body/div[3]/table[' + i.to_s + ']/caption').text
        case content[3]
          when "L"
            add_schedule(content[2], 0, name_content)
          when "M"
            add_schedule(content[2], 1, name_content)
          when "I"
            add_schedule(content[2], 2, name_content)
          when "J"
            add_schedule(content[2], 3, name_content)
          when "V"
            add_schedule(content[2], 4, name_content)
          when "S"
            add_schedule(content[2], 5, name_content)
        end
      end
      if n.content.include? 'Periodo Asociado'
        i += 2
      end
    end
  end

  # add to matrix
  def add_schedule(time, day, content)
    array = time.split(' - ')
    time_start = hour(array[0].split(' '))
    time_finish = hour(array[1].split(' '))
    # puts "Day: " + day + " time_start: " + time_start.to_s + " time_finish: " + time_finish.to_s + " content: " + content
    case time_finish - time_start
    when 1
      @@schedule[day][time_start] = content
    when 2
      @@schedule[day][time_start] = content
      @@schedule[day][time_start + 1] = content
    when 3
      @@schedule[day][time_start] = content
      @@schedule[day][time_start + 1] = content
      @@schedule[day][time_start + 2] = content
    end
  end

  def select_term
    time = ConsoleModule.time
    if time.month > 6
      select_id = time.year.to_s + '30'
    else
      select_id = time.year.to_s + '10'
    end
    @@browser.select_list(:id, 'term_id').select(select_id)
  end

  # return hour to add
  def hour(time)
    hour_array = time[0].split(':')
    hour = time[1] == 'PM' && hour_array[0].to_i != 12 ? hour_array[0].to_i + 6 : hour_array[0].to_i - 6
    hour
    # response = hour.to_s + hour_array[1]
    # response
  end

  def fill_in

  end

  def schedule
    @@schedule
  end

  def show_schedule
    @@schedule.each do |day|
      # day.each do |subject|
      #   if subject != nil
      #     puts subject
      #   end
      # end
      day.each { |subject| p subject }
    end
  end
end
