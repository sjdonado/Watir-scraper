require_relative '../modules/scraper_module'

class MyBookings

  @@table = Array.new(5){Array.new()}

  def initialize(browser, credentials = nil)
    @@browser = credentials.nil? ? browser : ScraperModule.login_unespacio(browser, credentials)
  end

  def build_table
    @@browser.goto(ScraperModule.url[:my_bookings])
    page_html = ScraperModule.parse_html(@@browser)
    i = 0
    page_html.css('#genericDiv > div.listDiv.initialized > table > tbody > tr.ClickableRow').each do |e|
      j = 0
      array = Array.new(6)
      e.css('td').each do |element|
        array[j] = element.text.strip
        j += 1
      end
      if array[3] == array[4]
        status = 'Approved'
      else
        status = 'Cancelled'
      end
      @@table[0][i] = array[0]
      @@table[1][i] = array[1]
      @@table[2][i] = array[2]
      @@table[3][i] = array[4]
      @@table[4][i] = status
      i += 1
      # # BOOKING DATE TIME REQUESTED-ROOMS STATUS
    end
    # @@browser.screenshot.save('/home/juan/Documents/Projects/ruby/unespacio/ss.png')
  end

  def cancel_bookings(index)
    if @@table[0][index] == 'Approved'
      # crear menu en console module para eliminar, y hacer los clicks
    end
  end

  def table
    @@table
  end

end
