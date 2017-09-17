require_relative '../modules/scraper_module'

class BookRoom
  @@rooms = {}
  @@time = {}

  def initialize(browser, credentials)
    @@browser = ScraperModule.login_unespacio(browser, credentials)
  end

  # Print info of rooms
  def name_rooms
    @@browser.element(css: '#menuContent > ul > li:nth-child(2) > ul > li:nth-child(3) > div > a').click
    @@browser.select_list(:id, 'cboLocation').select('B_58468bae-fafe-43eb-98de-f7b992f1ac2b')
    page_html = ScraperModule.parse_html(@@browser)
    i = 1
    sw = true
    while sw
      if page_html.xpath('//*[@id="ajaxRoomList"]/div[3]/table/tbody/tr[' + i.to_s + ']/td[3]').text != ''
        puts i.to_s + ') ' + page_html.xpath('//*[@id="ajaxRoomList"]/div[3]/table/tbody/tr[' + i.to_s + ']/td[3]').text
        @@rooms[i.to_s] = page_html.xpath('//*[@id="ajaxRoomList"]/div[3]/table/tbody/tr[' + i.to_s + ']/td[5]/span/a').first.attributes['onclick'].content.split("'")[1].strip
        i += 1
      else
        if @@browser.element(css: '#ajaxRoomList > div.ListActionBar.ListActionBarBottom > div.PageSelectorControls > input[type="number"]').value.to_s == '1'
          @@browser.element(css: '#ajaxRoomList > div:nth-child(2) > div.PageSelectorControls > div.imgNextArrow').click
          page_html_2 = ScraperModule.parse_html(@@browser)
          j = 1
          while page_html_2.xpath('//*[@id="ajaxRoomList"]/div[3]/table/tbody/tr[' + j.to_s + ']/td[3]').text != ''
            puts i.to_s + ') ' + page_html_2.xpath('//*[@id="ajaxRoomList"]/div[3]/table/tbody/tr[' + j.to_s + ']/td[3]').text
            @@rooms[i.to_s] = page_html_2.xpath('//*[@id="ajaxRoomList"]/div[3]/table/tbody/tr[' + j.to_s + ']/td[5]/span/a').first.attributes['onclick'].content.split("'")[1].strip
            i += 1
            j += 1
          end
          @@browser.element(css: '#ajaxRoomList > div:nth-child(2) > div.PageSelectorControls > div.imgBackArrow').click
          sw = false
        end
      end
    end
  end

  # send params to booking
  def booking(params)
    if @@browser.element(css: '#ajaxRoomList > div.listDiv.initialized > table > tbody > tr:nth-child(' + params[:room].to_s + ')').present?
      @@browser.element(css: '#ajaxRoomList > div.listDiv.initialized > table > tbody > tr:nth-child(' + params[:room].to_s + ')').click
    else
      @@browser.element(css: '#ajaxRoomList > div:nth-child(2) > div.PageSelectorControls > div.imgNextArrow').click
      room = params[:room].to_i - 30
      @@browser.element(css: '#ajaxRoomList > div.listDiv.initialized > table > tbody > tr:nth-child(' + room.to_s + ')').click
    end
    @@browser.select_list(:id, 'cboDuration').select(params[:duration].to_s)
    @@browser.element(css: '#btnAnyDate').click
    search_day(params[:day], search_month(params[:month]))
    page_html = ScraperModule.parse_html(@@browser)
    i = 1
    acum = 1
    while i < 29
      date = page_html.xpath('//*[@id="roomavailability"]/div/div/div[2]/table/tbody/tr[' + i.to_s + ']/td[1]').text
      if page_html.at_css('#roomavailability > div > div > div.listDiv.initialized.RoomAvailabilityList.NoPadding.NoEntityType.TableLayoutAuto > table > tbody > tr:nth-child(' + i.to_s + ') > td:nth-child(2) > input')
        puts i.to_s + ') ' + date.to_s + ' >> Room is available'
        @@time[i.to_s] = @@browser.element(css: '#roomavailability > div > div > div.listDiv.initialized.RoomAvailabilityList.NoPadding.NoEntityType.TableLayoutAuto > table > tbody > tr:nth-child(' + i.to_s + ') > td:nth-child(2) > input')
      else
        puts i.to_s + ') ' + date.to_s + ' >> Room is unavailable'
        acum += 1
      end
      i += 1
    end
    if actum == 28
      return false
    else
      return true
    end
  end

  # search month

  def search_month(month)
    i = 0
    sw = false
    while sw == false
      if i < 2
        # puts @@browser.element(css: '#availabilityCalendar' + i.to_s + ' > table > tbody > tr:nth-child(1) > td > b').text
        if @@browser.element(css: '#availabilityCalendar' + i.to_s + ' > table > tbody > tr:nth-child(1) > td > b').text.eql? month
          sw = true
        else
          i += 1
        end
      else
        i = 0
        @@browser.element(css: '#availabilityCalendarTable > tbody > tr > td:nth-child(3)').click
      end
    end
    i
  end

  # search day in the calendar
  def search_day(day, month)
    sw = true
    i = 3
    while sw && i <= 7
      j = 1
      while j <= 7
        clickeable = @@browser.element(css: '#availabilityCalendar' + month.to_s + ' > table > tbody > tr:nth-child(' + i.to_s + ') > td:nth-child(' + j.to_s + ')')
        if clickeable.text.to_s == day.to_s
          sw = false
          clickeable.click
        end
        j += 1
      end
      i += 1
    end
  end

  # click last confirm buttons
  def confirm_booking(time)
    if @@time[time].nil?
      false
    else
      @@time[time].click
      @@browser.element(css: '#btnConfirm').click
      @@browser.element(css: 'body > div.MessageBoxWindow > div.MessageBoxButtons.NoBorder > input:nth-child(1)').click
      @@browser.element(css: 'input.MessageBoxButton:nth-child(1)').click
      true
    end
  end
end
