require 'mechanize'
require 'watir'
require_relative 'console_module'

module ScraperModule

  @@url =  {
    pomelo:"https://pomelo.uninorte.edu.co/pls/prod/twbkwbis.P_ValLogin",
    unespacio:"http://guaymaro.uninorte.edu.co/UNEspacio/index.php?p=Index",
    find_a_room:"http://guaymaro.uninorte.edu.co/UNEspacio/index.php?p=FindRoomSS&r=1",
    horario_pomelo: "https://pomelo.uninorte.edu.co/pls/prod/bwskfshd.P_CrseSchdDetl"
  }

  def self.create_bot
    Mechanize.new
  end

  def self.create_bot_watir
    #phantomjs firefox
    browser = ::Watir::Browser.new :phantomjs

    browser.window.maximize
    browser
  end

  def self.url
    @@url
  end

  #Return the robot with the unespacio credentials
  def self.login_unespacio(browser, params)
    browser.goto(url[:unespacio])
    browser.li(class:"userBarButton ", index:1).click
    browser.form(id:"frmLogin")
    browser.text_field(name:'txtUsername').set(params[:user])
    browser.text_field(name: 'txtPassword').set(params[:pass])
    browser.button(id: 'btnLogin').click
    browser.refresh
    if browser.element(css: '#spanUsername').present?
      puts "Welcome " + browser.element(css: '#spanUsername').text.strip
      browser.goto(url[:find_a_room])
      browser
    else
      puts "LOGIN ERROR"
      false
    end
  end

  #return the robot with pomelo credentials
  def self.login_pomelo(browser, params)
    browser.goto(url[:pomelo])
    browser.text_field(name: 'sid').set(params[:user])
    browser.text_field(name: 'PIN').set(params[:pass])
    browser.element(css: 'body > div.pagebodydiv > form > p > input[type="submit"]').click
    puts "Welcome " + browser.element(css: 'body > div.pagebodydiv > table:nth-child(1) > tbody > tr > td:nth-child(2)').text.split(",")[1]
    browser.goto(url[:horario_pomelo])
    browser
  end

  #parse html to nokogiri object
  def self.parse_html(browser)
    sleep 1
    Nokogiri::HTML.parse(browser.html)
  end

end