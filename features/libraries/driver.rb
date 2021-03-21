# frozen_string_literal: true

module Libraries
  class Driver
    attr_accessor :driver

    $focus_driver = nil
    @driver = nil
    @main_window = nil
    @click_exception_count = nil
    @@drivers = []
    @@drivers_with_names = {}

    def initialize(driver_name = 'Driver', browser = $conf['browser'])
      start(driver_name, browser)
      puts "#{driver_name} is initialized"
    rescue Exception => e
      puts "#{driver_name} is failed to initialize \n\n #{e.backtrace}\n\nRetrying to initialize #{driver_name}"
      start(driver_name, browser)
      puts "#{driver_name} is initialized after an exception"
    end

    ##############################
    # Custom methods of driver #
    ##############################

    def start(driver_name, browser)
      case browser.downcase
      when 'chrome'
        options = Selenium::WebDriver::Chrome::Options.new
        switches = if (ENV['MODE'] == 'headless') || ($conf['mode'] == 'headless')
                     %w[disable-infobars disable-gpu disable-dev-shm-usage no-sandbox headless]
                   else
                     %w[disable-infobars disable-gpu disable-dev-shm-usage no-sandbox start-maximized]
                   end
        switches.map { |k| options.add_argument(k) }
        @driver = Selenium::WebDriver.for(:chrome, options: options)
        @driver.manage.timeouts.implicit_wait = $conf['implicit_wait']

      when 'firefox', 'ff'
        @driver = Selenium::WebDriver.for :firefox

      else
        raise ArgumentError, "Specify a proper browser while initiating a driver \n \n#{browser.inspect}"
      end

      @click_exception_count = 0
      @@drivers.push(self)
      @@drivers_with_names[self] = driver_name.to_s
      $focus_driver = self
      puts "#{driver_name} - #{self}"
      self
    end

    def get(url)
      $focus_driver = self
      @driver.get(url)
      puts "#{$focus_driver} loaded with - #{url}"
    end

    def refresh
      $focus_driver = self
      navigate.refresh
      puts "#{$focus_driver} is refreshed"
    end

    def find_element(locator)
      $focus_driver = self
      Libraries::Wait.wait_for_element(locator)
      @driver.find_element(locator.how, locator.what)
    end

    def find_elements(locator)
      $focus_driver = self
      @driver.find_elements(locator.how, locator.what)
    end

    def mouse_over(locator, index = 1)
      $focus_driver = self
      element = find_elements(locator)[index - 1]
      @driver.action.move_to(element).perform
      puts "mouse over for the element - #{locator.how} => #{locator.what} is done"
    end

    def mouse
      $focus_driver = self
      @driver.mouse
    end

    def action
      $focus_driver = self
      @driver.action
    end

    def move_and_click(locator)
      $focus_driver = self
      ele = find_element(locator)
      @driver.action.move_to(ele).click.perform
      puts "Mouse over the locator and then click for - #{locator.how} => #{locator.what} is done"
    end

    def current_url
      $focus_driver = self
      @driver.current_url
    end

    def save_screenshot(file_name = nil)
      $focus_driver = self
      if file_name.nil?
        file_name = "#{Pathname.pwd}/#{$conf['screenshot_location']}/#{Time.new.strftime('%Y-%m-%d-%H-%M-%S-%L-%N')}.png"
      end
      puts "#{$focus_driver}'s Screenshot saved in this path => #{file_name}"
      @driver.save_screenshot(file_name)
    end

    def switch_to_frame(locator)
      $focus_driver = self
      @main_window = @driver.window_handle
      @driver.switch_to.frame(find_element(locator))
      puts "Switched to iframe - #{locator.how} => #{locator.what} on #{$focus_driver}"
      @main_window
    end

    def switch_to_window(locator = nil)
      $focus_driver = self
      @main_window = @driver.window_handle
      locator&.click
      windows = @driver.window_handles
      new_window = nil
      windows.length.times do |i|
        new_window = windows[i] if windows[i] != @main_window
      end
      @driver.switch_to.window(new_window)
      puts "Switched to new window on #{$focus_driver}"
      @main_window
    end

    def scroll_to_locator(locator)
      $focus_driver = self
      element = find_element(locator)
      @driver.execute_script(
        "arguments[0].scrollIntoView({behavior: 'smooth', block: 'center', inline: 'nearest'});", element
      )
      puts "Scroll to this locator - #{locator.how} => #{locator.what} on #{$focus_driver}"

    end

    def revert_to(window = nil)
      $focus_driver = self
      if !window.nil?
        @driver.switch_to.window(window)
        puts "Switched back to another window - #{window} in #{$focus_driver}"
      else
        @driver.switch_to.window(@main_window)
        puts "Switched back to main window in #{focus_driver}"
      end
    end

    def close
      $focus_driver = self
      @driver.close
      puts "Closed the browser - #{$focus_driver}"
    end

    def quit
      @driver.quit
      @@drivers.delete(self)
      $focus_driver = @@drivers[0]
      puts "Quit the browser - #{$focus_driver}"
    end

    def quit_all
      @@drivers.each do |driver|
        driver.quit if driver != self
      end
      quit
      puts 'deleted all the browsers'
    end

    def self.quit_all_drivers
      @@drivers.each do |driver|
        driver.quit if driver != self
      end
      puts 'deleted all the browsers'
    end

    def self.get_all_drivers
      @@drivers_with_names
    end

    def self.get_current_driver
      $focus_driver
    end

    def get_title
      @driver.title
    end

  end
end
