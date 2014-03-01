require 'rubygems'
gem "rspec"
require "selenium-webdriver"

describe "Login" do
  attr_reader :selenium_driver, :wait
  attr_accessor :contact
  alias :browser :selenium_driver

  before(:all) do
    @selenium_driver = Selenium::WebDriver.for :firefox
    @selenium_driver.get "http://m.mpdx.org/"
    @wait = Selenium::WebDriver::Wait.new(:timeout => 7)
  end

  after(:all) { browser.quit }

  describe "good user" do
    before(:all) do
      @wait.until { /Welcome to MPDX/.match(browser.page_source) }

      browser.find_element(:class_name, "login_btn").click

      login_user_name = @wait.until {
        elm = browser.find_element(:id, "username")
        elm if elm.displayed?
      }
      login_user_name.send_keys("test@256design.com")

      browser.find_element(:id, "password").send_keys("AppTest256")
      browser.find_element(:id, "btn_signin").click
    end

    it "successful login" do
      @wait.until {
        /Dashboard/.match(browser.page_source)
      }
      /Dashboard/.should match(browser.page_source)

      username_h1 = browser.find_element(:class_name, "current-user")
      @wait.until { !(/Loading.../.match(username_h1.text)) }
    end

    it "logout" do
      browser.find_element(:class_name, "ui-icon-gear").click
      browser.find_element(:css, "[href='#logout']").click

      @wait.until {
        /You have been logged out/.match(browser.page_source)
      }
      /You have been logged out/.should match(browser.page_source)
    end
  end

end
