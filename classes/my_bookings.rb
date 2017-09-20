require_relative '../modules/scraper_module'

class MyBookings

  def initialize(browser, credentials = nil)
    @@browser = credentials.nil? ? browser : ScraperModule.login_unespacio(browser, credentials)
  end

  def build_table
    @@table = Array.new(5){Array.new()}
    header = %w(BOOKING DATE TIME REQUESTED STATUS)
    header.each_with_index do |content, row|
      @@table[row][0] = content
    end
    @@browser.goto(ScraperModule.url[:my_bookings])
    page_html = ScraperModule.parse_html(@@browser)
    i = 1
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
      row = [(i + 1).to_s + '.' + array[0], array[1], array[2], array[4], status]
      row.each_with_index do |content, index|
        @@table[index][i] = content
      end
      i += 1
    end
  end

  def cancel_bookings(index)
    if @@table[4][index] == 'Approved'
      @@browser.element(:xpath => '//*[@id="genericDiv"]/div[4]/table/tbody/tr[' + index.to_s + ']/td[7]/input').click
      @@browser.element(css: 'body > div.MessageBoxWindow > div.MessageBoxButtons.NoBorder > input:nth-child(1)').click
      @@table[4][index] = 'Cancelled'
      puts 'Room cancelled successfully'
      return true
    else
      puts "Error!, the room's cancelled"
      return false
    end
  end

  def details_room
  end

  def table
    @@table
  end

end
